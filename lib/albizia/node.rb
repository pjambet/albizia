
module Albizia

  AlreadyExistingNodeException = Class.new(StandardError)
  NodeNotFoundError            = Class.new(StandardError)

  class Node

    attr_accessor :left_child, :right_child, :value, :parent

    def initialize(v=nil)
      @value = v
      @parent = nil
    end

    def empty?
      leaf? && @value.nil?
    end

    #
    # A leaf node has no children
    #
    def leaf?
      @left_child.nil? && @right_child.nil?
    end

    #
    # A root has no parent
    #
    def root?
      @parent.nil?
    end

    #
    # Return the root element of the tree
    #
    def root
      root? ? self : @parent.root
    end

    #
    # The depth of a node n is the length of the path from the root to the node.
    # The set of all nodes at a given depth is sometimes called a level of the
    # tree. The root node is at depth zero.
    #
    def depth
      root? ? 0 : 1 + parent.depth
    end

    #
    # The height of a tree is the length of the path from the root to the
    # deepest node in the tree. A rooted tree with only one node (the root)
    # has a height of zero.
    #
    # Available options :
    #   initial : this will mark the current node as a root.
    #
    def height(initial: false)
      current_height = (root? || initial) ? 0 : 1

      if empty?
        -1
      elsif (root? && leaf?) || (initial && leaf?)
        0
      elsif leaf?
        1
      elsif @left_child.nil?
        current_height + @right_child.height
      elsif @right_child.nil?
        current_height + @left_child.height
      else
        current_height + [@left_child.height, @right_child.height].max
      end
    end

    #
    # Siblings are nodes that share the same parent node.
    #
    def siblings
      root.to_a.select{|node| node.depth == depth && node != self}
    end

    #
    # All nodes above current node
    #
    def ancestors
      if root?
        []
      else
        parent.ancestors.push parent
      end
    end

    #
    # The size of a node is the number of descendants it has including itself.
    #
    def size
      if empty?
        0
      elsif leaf?
        1
      elsif @left_child.nil?
        1 + @right_child.size
      elsif @right_child.nil?
        1 + @left_child.size
      else
        1 + @left_child.size + @right_child.size
      end
    end

    #
    # A tree is full if every nodes except leaves has 2 children
    #
    def full?
      traverse do |node|
        if !node.leaf? && (node.right_child.nil? || node.right_child.nil?)
          return false
        end
      end
      true
    end

    def balanced?
      left_height = left_child ? left_child.height(initial: true) : 0
      right_height = right_child ? right_child.height(initial: true) : 0
      (left_height - right_height).abs <= 1
    end

    def degenerated?
    end

    #
    # Return the highest value in the tree
    #
    def max
      if @right_child.nil?
        empty? ? nil : self
      else
        @right_child.max
      end
    end

    #
    # Return the lowest value in the tree
    #
    def min
      if @left_child.nil?
        empty? ? nil : self
      else
        @left_child.min
      end
    end

    #
    # Add a node with value equals to v in the tree
    #
    def add(v)
      if v.is_a? Enumerable
        v.each {|item| self.add(item)}
      else
        if empty?
          @value = v
        elsif v > @value
          if @right_child.nil?
            insert_node :right, v
          else
            @right_child.add(v)
          end
        else
          if @left_child.nil?
            insert_node :left, v
          else
            @left_child.add(v)
          end
        end
      end
    end
    alias_method :<<, :add

    #
    # Returns the node with value v if it exists
    #
    def find(v)
      raise_not_found = lambda { raise NodeNotFoundError.new }
      if empty?
        raise_not_found.call
      elsif leaf? && @value != v
        raise_not_found.call
      elsif @value == v
        self
      elsif v < @value
        @left_child.nil? ? raise_not_found.call : @left_child.find(v)
      else
        @right_child.nil? ? raise_not_found.call : @right_child.find(v)
      end
    end

    #
    # Delete the node with the given value
    # return the deleted node
    #
    def delete(v)
      if leaf? && @value != v
        raise NodeNotFoundError.new
      elsif @value == v
        remove_node
      elsif v < @value
        @left_child.delete v
      elsif v >= @value
        @right_child.delete v
      end
    end

    #
    # Traverse the tree and returns the list of elements
    # For the following tree :
    #
    #     5
    #   /  \
    # 2     10
    #     / \
    #    6  12
    #
    # It returns [2, 5, 6, 10, 12]
    #
    def to_a
      list = []
      traverse { |v| list << v }
      list
    end

    #
    # Traverse the tree and return elements in a hash:
    # For the following tree :
    #
    #     5
    #   /  \
    # 2     10
    #     / \
    #    6  12
    #
    # It returns { :"5" => { :"2" => nil, :"10" => { :"6" => nil, :"12" => nil } } }
    #
    def to_hash
    end

    #
    # Draw the tree in the console
    # example :
    #
    #     5
    #   /  \
    # 2     10
    #     / \
    #    6  12
    #
    def draw
      queue = []
      queue.push self
      current_depth = 0
      while queue.length != 0
        v = queue.shift
        if block_given?
          yield v
        else
          if current_depth != v.depth
            current_depth = v.depth
            print "\n"
          end
          print "#{v.value} "
        end
        queue.push v.left_child if v.left_child
        queue.push v.right_child if v.right_child
      end
    end

    def traverse(&block)
      left_child.traverse(&block) if left_child
      block_given? ? yield(self) : puts(@value)
      right_child.traverse(&block) if right_child
    end
    alias_method :in_order_traverse, :traverse

    def pre_order_traverse(&block)
      block_given? ? yield(self) : puts(@value)
      left_child.traverse(&block) if left_child
      right_child.traverse(&block) if right_child
    end

    def post_order_traverse(&block)
      left_child.traverse(&block) if left_child
      right_child.traverse(&block) if right_child
      block_given? ? yield(self) : puts(@value)
    end

    def >(other)
      @value > other.value
    end

    def <(other)
      @value < other.value
    end

    def <=>(other)
      if @value < other.value
        -1
      elsif @value == other.value
        0
      else
        1
      end
    end

    def valid?
      ordered?
    end

    def ordered?
      list = to_a
      0..(list.size - 1).times do |i|
        return false if list[i] > list[i + 1]
      end
      true
    end

    def detached?
      parent.nil? and left_child.nil? and right_child.nil?
    end

    private

    def insert_node(direction, v)
      raise AlreadyExistingNode.new if send(:"#{direction}_child") != nil
      new_node = Node.new(v).tap { |n| n.parent = self }
      send :"#{direction}_child=", new_node
    end

    #
    #
    #
    def remove_node
      new_child = if @left_child != nil && @right_child != nil
        @left_child.parent = parent
        @right_child.parent = @left_child
      elsif @left_child != nil
        @left_child.parent = parent
        @left_child
      elsif @right_child != nil
        @right_child.parent = parent
        @right_child
      end

      if @parent != nil
        if @value < @parent.value
          @parent.left_child = new_child
        else
          @parent.right_child = new_child
        end
      end
      detach
    end

    #
    # Delete all current links (parent & children)
    #
    def detach
      self.tap do
        %i(parent= left_child= right_child=).each do |attr|
          send attr, nil
        end
      end
    end

  end #class
end #module
