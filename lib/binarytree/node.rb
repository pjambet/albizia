module Binarytree
  class Node
    
    attr_accessor :left_child, :right_child, :value, :parent
    
    def initialize(v=nil)
      @value = v
      @parent = nil
    end
    
    def empty?
      leaf? && value == nil
    end
    
    # A leaf node has no children
    def leaf?
      @left_child == nil && @right_child == nil
    end
    
    # A root has no parent
    def root?
      @parent == nil
    end
    
    #The depth of a node n is the length of the path from the root to the node.
    # The set of all nodes at a given depth is sometimes called a level of the
    # tree. The root node is at depth zero (here 1).
    def depth      
      
    end
    
    # The height of a tree is the length of the path from the root to the 
    # deepest node in the tree. A (rooted) tree with only one node (the root)
    # has a height of zero (here it's 1).
    def height
      if root?
        init_depth = 0
      else
        init_depth = 1
      end
      
      if empty?
        -1
      elsif root? && leaf?
        0      
      elsif leaf?
        1
      else
        if @left_child == nil && @right_child != nil
          init_depth + @right_child.height
        elsif @left_child != nil && @right_child == nil
          init_depth + @left_child.height
        elsif @left_child != nil && @right_child != nil
          init_depth + ([@left_child.height, @right_child.height].max)
        else
          raise "Unhandled depth case"
        end
      end
    end
    
    # Siblings are nodes that share the same parent node.
    def sibling
      
    end
    
    # The size of a node is the number of descendants it has including itself.
    def size
      
    end
    
    def max
      if @right_child == nil
        if empty?
          nil
        else
          self
        end
      else
        @right_child.max
      end
    end
    
    def min
      if @left_child == nil
        if empty?
          nil
        else
          self
        end
      else
        @left_child.min
      end
    end
    
    def add(v)
      if empty?
        @value = v
      elsif v > @value
        if(@right_child == nil)
          @right_child = Node.new(v)
          @right_child.parent = self
        else
          @right_child.add(v)
        end
      else
        if @left_child == nil
          @left_child = Node.new(v)
          @left_child.parent = self
        else
          @left_child.add(v)
        end
      end
    end
    
    # Alias of #add
    def <<(v)
      add(v)
    end
    
  end #class
end #module