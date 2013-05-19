module Albizia
  class RBNode < Node
    COLORS = %i(red black)
    attr_accessor :color

    def initialize(value)
      super(value)
      @color = :black
    end

    def black?
      color == :black
    end

    def red?
      color == :red
    end

    def valid?
      traverse do |node|
        return false unless node.red? || node.black?
        return false if node.leaf? && !node.black?
        return false if node.red? and node.right_child.red? and
          node.left_child.red?
        # Every simple path from a node to a descendant leaf contains the same
        # number of black nodes.
      end
      true
    end

    class Sentinel < RBNode
      attr_reader :value

      def initialize
        @value = nil
      end
    end

  end
end
