require "spec_helper"

module Binarytree
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
          subject.parent.should == nil
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
            subject.left_child.should == nil
          end

          it "should have a height of 1" do
            subject.should_not be_empty
            subject.right_child.should_not be_nil
            subject.right_child.should be_leaf
            subject.left_child.should == nil

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
            subject.right_child.should == nil
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
