require "spec_helper"

module Albizia
  describe Node do
    describe "#init" do
      context "Without params" do
        subject { Node.new }

        it { should be_empty }

        it "should have a height of -1" do
          subject.height.should == -1
        end
      end

      context "With an integer param" do
        subject { Node.new(@v) }
        before(:each) { @v = 0 }

        it { should_not be_empty }
        it { should be_root }
        it { should be_leaf }

        it "should have length equals to 0" do
          subject.height.should == 0
        end

        it "should have the assigned value" do
          subject.value.should == @v
        end
      end
    end

    describe "#add" do
      context "To an empty tree" do
        subject { Node.new }
        before(:each) { subject.add(5) }

        it "should be inserted at the root" do
          subject.value.should == 5
          subject.parent.should be_nil
        end

        it { should be_leaf }

        it "should have a height of 0" do
          subject.height.should == 0
        end
      end

      context "To an almost empty tree" do
        subject { Node.new(5) }

        context "A greater value than root's value" do
          before(:each) do
            subject.add(10)
          end

          it { should be_root }
          it { should_not be_leaf }

          it "should be inserted on the right" do
            subject.right_child.should_not be_empty
            subject.right_child.value.should == 10
            subject.left_child.should be_nil
          end

          it "should have a height of 1" do
            subject.should_not be_empty
            subject.right_child.should_not be_nil
            subject.right_child.should be_leaf
            subject.left_child.should be_nil

            subject.height.should == 1
          end
        end

        context "A lower value than root's value" do
          before(:each) do
            subject.add(1)
          end

          it { should_not be_leaf }

          it "should be inserted on the left" do
            subject.left_child.should_not be_empty
            subject.left_child.value.should == 1
            subject.right_child.should be_nil
          end

          it "should have a height of 1" do
            subject.height.should == 1
          end
        end

      end

      context "To a non empty tree" do
        subject { Node.new(5) }
        before(:each) do
          subject.add(3)
          subject.add(7)
        end

        context "A greater value than root's value" do
          context "A greater value than the current max value" do
            before(:each) do
              subject.add(8)
            end

            it "should be inserted on the right of the current right'est' node" do
              subject.right_child.right_child.value.should == 8
            end
            it "should be the max" do
              subject.max.value.should == 8
            end
            it "should be a leaf" do
              subject.right_child.right_child.should be_leaf
            end
            it "should have a height of 2" do
              subject.height.should == 2
            end
          end

          context "A lower value than the current max value but greater than root's" do
            before(:each) do
              subject.add(6)
            end

            it "should be inserted on the left of the current right'est' node" do
              subject.right_child.left_child.value.should == 6
            end
            it "should be a leaf" do
              subject.right_child.left_child.should be_leaf
            end
            it "should have a height of 2" do
              subject.height.should == 2
            end
          end

        end

        context "A lower value than root's value" do
          context "A lower value than current min" do
            before(:each) do
              subject.add(1)
            end
            it "should be inserted on the left of the current left'est' node " do
              subject.left_child.left_child.value.should == 1
            end

            it "should be a leaf" do
              subject.left_child.left_child.should be_leaf
            end

            it "should be the min" do
              subject.min.value.should == 1
            end

            it "should have a height of 2" do
              subject.height.should == 2
            end
          end

          context "A greater value than current min but still lower than root's " do
            before(:each) do
              subject.add(4)
            end
            it "should be inserted on the right of the current left'est' node" do
              subject.left_child.right_child.value.should == 4
            end
            it "should be a leaf" do
              subject.left_child.right_child.should be_leaf
            end
            it "should have a height of 2" do
              subject.height.should == 2
            end
          end
        end

      end
    end

    describe "#root" do
      subject { Node.new 10 }

      context "Empty tree" do
        it "should return self" do
          subject.root.should == subject
        end
      end

      context "Tree with one element" do
        before(:each) do
          subject.parent = Node.new(20)
        end

        it "should return subject's parent" do
          subject.root.should == subject.parent
        end
      end

      context "Tree with more than one element" do

        it "should return the same root for each descendant" do
          5.times.map do |i|
            node = subject.add(i)
            node.root.should == subject
          end
        end
      end

    end
    describe "#depth" do
      context "Empty tree" do
        subject { Node.new }

        it "should have a depth of 0" do
          subject.depth.should == 0
        end

      end

      context "Not empty tree" do
        subject do
          parent = Node.new(10)
          Node.new(4).tap {|n| n.parent = parent }
        end

        it "should have a depth of 1" do
          subject.depth.should == 1
        end

        it "should have a depth of 2" do
          subject.parent.parent = Node.new(20)
          subject.depth.should == 2
        end

        it "should still have a depth of 2 after adding a child" do
          subject.parent.parent = Node.new(20)
          subject.add(2)
          subject.depth.should == 2
        end
      end
    end

    describe "#height" do
      context "Empty tree" do
        subject { Node.new }

        it "should have a height of -1" do
          subject.height.should == -1
        end
      end

      context "Tree with one element" do
        subject { Node.new 10 }

        it "should have a height of 0" do
          subject.height.should == 0
        end
      end

      context "Tree with more than one element" do
        subject { Node.new(10).tap { |n| n.add 4 } }

        context "Tree's root" do
          it "should have a height of 1 after initialization" do
            subject.height.should == 1
          end

          it "should have a height of 1 after adding a new element at the same depth" do
            subject.add 15
            subject.height.should == 1
          end

          it "should have a height of 2 after adding a child on the right" do
            subject.add 15
            subject.add 20
            subject.height.should == 2
          end
        end

        context "Nodes in a tree ('initial' option)" do

          it "should return a height of 2 for the parent of a leaf's parent" do
            subject.add 15
            node = subject.add 20
            subject.add 25
            subject.add 30

            node.should_not be_leaf
            node.height(initial: true).should == 2
          end

          it "should return a height of 1 for the parent of a leaf" do
            subject.add 15
            node = subject.add 20
            subject.add 30

            node.should_not be_leaf
            node.height(initial: true).should == 1
          end

          it "should return a height of 0 for a leaf" do
            subject.add 15
            subject.add 20
            node = subject.add 30

            node.should be_leaf
            node.height(initial: true).should == 0
          end
        end
      end

    end

    describe "#find" do
      context "A value which is not present in the tree" do
        it "should raise an Exception"
      end

      context "The minimum value of the tree" do
        it "should return the correct value"
      end

      context "The maximum value of the tree" do
        it "should return the correct value"
      end

      context "A value which is lower than the root's value" do
        it "should return the correct value"
      end

      context "A value which is greater than the root" do
        it "should return the correct value"
      end
    end

    describe "#delete" do
      context "The root value" do
        it "should delete the value"
      end

      context "A value which is not present in the tree" do
        it "should raise an Exception"
      end

      context "The minimum value of the tree" do
        it "should delete the value"
      end

      context "The maximum value of the tree" do
        it "should delete the value"
      end

      context "A value which is lower than the root's value" do
        it "should delete the value"
      end

      context "A value which is greater than the root" do
        it "should delete the value"
      end
    end

  end
end
