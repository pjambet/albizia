
module Albizia

  AlreadyExistingNode = Class.new(StandardError)

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
    # deepest node in the tree. A (rooted) tree with only one node (the root)
    # has a height of zero.
    #
    # Available options :
    #   initial : this will mark the current node as a root.
    #
    def height(opts={})
      current_height = (root? || opts[:initial]) ? 0 : 1

      if empty?
        -1
      elsif (root? && leaf?) || (opts[:initial] && leaf?)
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

    #
    # Siblings are nodes that share the same parent node.
    #
    def siblings
    end

    #
    # All nodes above current node
    #
    def ancestors
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
    end

    def balanced?
    end

    def degenerated?
    end

    #
    # Return the highest value in the tree
    #
    def max
      if @right_child.nil?
        if empty?
          nil
        else
          self
        end
      else
        @right_child.max
      end
    end

    #
    # Return the lowest value in the tree
    #
    def min
      if @left_child.nil?
        if empty?
          nil
        else
          self
        end
      else
        @left_child.min
      end
    end

    #
    # Add a node with value equals to v in the tree
    #
    def add(v)
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
    alias_method :<<, :add

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
    # It return [2, 5, 6, 10, 12]
    #
    def to_a

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

    end

    private

    def insert_node(direction, v)
      raise AlreadyExistingNode.new if send(:"#{direction}_child") != nil
      new_node = Node.new(v).tap { |n| n.parent = self }
      send :"#{direction}_child=", new_node
    end


  end #class
end #module
