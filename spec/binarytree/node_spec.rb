require "spec_helper"

module Binarytree
  describe Node do
    describe "#init" do
      context "Without params" do
        before(:each) do
          @node = Node.new
        end
        it "should be empty" do
          @node.should be_empty
        end

        it "should have a height of -1" do
          @node.height.should == -1
        end
      end

      context "With an integer param" do
        before(:each) do
          @v = 0
          @node = Node.new(@v)
        end
        it "should not be empty" do
          @node.should_not be_empty
        end

        it "should have a height of 0" do
          @node.should be_root
          @node.should be_leaf
          @node.height.should == 0
        end

        it "should have the assigned value" do
          @node.value.should == @v
        end
      end
    end

    describe "#add" do
      context "To an empty tree" do
        before(:each) do
          @node = Node.new
          @node.add(5)
        end
        it "should be inserted at the root" do
          @node.value.should == 5
          @node.parent.should == nil
        end
        it "should be a leaf" do
          @node.should be_leaf
        end
        it "should have a height of 0" do
          @node.height.should == 0
        end
      end

      context "To an almost empty tree" do
        before(:each) do
          @node = Node.new(5)
        end

        context "A greater value than root's value" do
          before(:each) do
            @node.add(10)
          end
          it "should be inserted on the right" do
            @node.right_child.should_not be_empty
            @node.right_child.value.should == 10
            @node.left_child.should == nil
          end
          it "should have a height of 1" do
            @node.should_not be_empty
            @node.right_child.should_not be_nil
            @node.right_child.should be_leaf
            @node.left_child.should == nil
            @node.should be_root
            @node.should_not be_leaf
            @node.height.should == 1
          end
        end

        context "A lower value than root's value" do
          before(:each) do
            @node.add(1)
          end
          it "should be inserted on the left" do
            @node.left_child.should_not be_empty
            @node.left_child.value.should == 1
            @node.right_child.should == nil
          end
          it "should have a height of 1" do
            @node.should_not be_leaf
            @node.height.should == 1
          end
        end

      end

      context "To a non empty tree" do
        before(:each) do
          @node = Node.new(5)
          @node.add(3)
          @node.add(7)
        end

        context "A greater value than root's value" do
          context "A greater value than the current max value" do
            before(:each) do
              @node.add(8)
            end

            it "should be inserted on the right of the current right'est' node" do
              @node.right_child.right_child.value.should == 8
            end
            it "should be the max" do
              @node.max.value.should == 8
            end
            it "should be a leaf" do
              @node.right_child.right_child.should be_leaf
            end
            it "should have a height of 2" do
              @node.height.should == 2
            end
          end

          context "A lower value than the current max value but greater than root's" do
            before(:each) do
              @node.add(6)
            end

            it "should be inserted on the left of the current right'est' node" do
              @node.right_child.left_child.value.should == 6
            end
            it "should be a leaf" do
              @node.right_child.left_child.should be_leaf
            end
            it "should have a height of 2" do
              @node.height.should == 2
            end
          end

        end

        context "A lower value than root's value" do
          context "A lower value than current min" do
            before(:each) do
              @node.add(1)
            end
            it "should be inserted on the left of the current left'est' node " do
              @node.left_child.left_child.value.should == 1
            end

            it "should be a leaf" do
              @node.left_child.left_child.should be_leaf
            end

            it "should be the min" do
              @node.min.value.should == 1
            end

            it "should have a height of 2" do
              @node.height.should == 2
            end
          end

          context "A greater value than current min but still lower than root's " do
            before(:each) do
              @node.add(4)
            end
            it "should be inserted on the right of the current left'est' node" do
              @node.left_child.right_child.value.should == 4
            end
            it "should be a leaf" do
              @node.left_child.right_child.should be_leaf
            end
            it "should have a height of 2" do
              @node.height.should == 2
            end
          end
        end

      end
    end

    describe "#find" do
      context "A value which is not present in the tree" do

      end

      context "The minimum value of the tree" do

      end

      context "The maximum value of the tree" do

      end

      context "A value which is lower than the root's value" do

      end

      context "A value which is greater than the root" do

      end
    end

    describe "#delete" do
      context "The root value" do
      end

      context "A value which is not present in the tree" do
      end

      context "The minimum value of the tree" do
      end

      context "The maximum value of the tree" do
      end

      context "A value which is lower than the root's value" do
      end

      context "A value which is greater than the root" do
      end
    end

  end
end
