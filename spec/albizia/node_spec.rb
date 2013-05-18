require "spec_helper"

module Albizia
  describe Node do
    describe '#init' do
      context 'Without params' do
        subject { Node.new }

        it { should be_empty }
        it { subject.height.should == -1 }
      end

      context 'With an integer param' do
        subject { Node.new(v) }
        let(:v) { 0 }

        it { should_not be_empty }
        it { should be_root }
        it { should be_leaf }
        its(:height) { should == 0 }
        its(:value) { should == v }
      end
    end

    describe '#add' do
      context 'To an empty tree' do
        subject { Node.new }
        before(:each) { subject.add(5) }

        it { should be_leaf }
        its(:value) { should == 5 }
        its(:parent) { should be_nil }
        its(:height) { should == 0 }
      end

      context "To an almost empty tree" do
        subject { Node.new(5) }

        context "A greater value than root's value" do
          before(:each) { subject.add(10) }

          it { should be_root }
          it { should_not be_leaf }

          its(:right_child) { should_not be_empty }
          its(:left_child) { should be_nil }
          its('right_child.value') { should == 10 }

          it { should_not be_empty }
          its(:right_child) { should_not be_nil }
          its(:right_child) { should be_leaf }
          its(:height) { should == 1 }
        end

        context "A lower value than root's value" do
          before(:each) do
            subject.add(1)
          end

          it { should_not be_leaf }
          its(:left_child) { should_not be_empty }
          its('left_child.value') { should == 1 }
          its(:right_child) { should be_nil }

          it { subject.height.should == 1 }
        end

      end

      context "To a non empty tree" do
        subject { Node.new(5) }
        before(:each) do
          subject.add [3, 7]
        end

        context "A greater value than root's value" do
          context "A greater value than the current max value" do
            before(:each) { subject.add(8) }

            its('right_child.right_child.value') { should == 8 }
            its('max.value') { should == 8 }
            its('right_child.right_child') { should be_leaf }
            its(:height) { should == 2 }
          end

          context "A lower value than the current max value but greater than root's" do
            before(:each) { subject.add(6) }

            its('right_child.left_child.value') { should == 6 }
            its('right_child.left_child') { should be_leaf }
            its(:height) { should == 2 }
          end
        end

        context "A lower value than root's value" do
          context "A lower value than current min" do
            before(:each) { subject.add(1) }

            its('left_child.left_child.value') { should == 1 }
            its('left_child.left_child') { should be_leaf }
            its('min.value') { should == 1 }
            its(:height) { should == 2 }
          end

          context "A greater value than current min but still lower than root's " do
            before(:each) { subject.add(4) }

            its('left_child.right_child.value') { should == 4 }
            its('left_child.right_child') { should be_leaf }
            its(:height) { should == 2 }
          end
        end

        context "Private method #insert_node" do
          it "should call the method 6 times" do
            node = Node.new 5
            node.expects(:insert_node).times(6)
            node.add 6.times
          end
        end

      end
    end

    describe "#root" do
      subject { Node.new 10 }

      context "Empty tree" do
        its(:root) { should == subject }
      end

      context "Tree with one element" do
        before(:each) { subject.parent = Node.new(20) }

        it { subject.root.should == subject.parent }
      end

      context "Tree with more than one element" do

        context "should return the same root for each descendant" do
          5.times.map do |i|
            let(:node) { subject.add(i) }

            it { node.root.should == subject }
          end
        end
      end

    end
    describe "#depth" do
      context "Empty tree" do
        subject { Node.new }

        its(:depth) { should == 0 }
      end

      context "Not empty tree" do
        subject do
          parent = Node.new(10)
          Node.new(4).tap {|n| n.parent = parent }
        end

        its(:depth) { should == 1 }

        context "should have a depth of 2" do
          before(:each) { subject.parent.parent = Node.new(20) }

          its(:depth) { should == 2 }
        end

        context "should still have a depth of 2 after adding a child" do
          before(:each) do
            subject.parent.parent = Node.new(20)
            subject.add(2)
          end

          its(:depth) { should == 2 }
        end
      end
    end

    describe "#height" do
      context "Empty tree" do
        subject { Node.new }

        its(:height) { should == -1 }
      end

      context "Tree with one element" do
        subject { Node.new 10 }

        its(:height) { should == 0 }
      end

      context "Tree with more than one element" do
        subject { Node.new(10).tap { |n| n.add 4 } }

        context "Tree's root" do

          its(:height) { should == 1 }

          context "should have a height of 1 after adding a new element at the same depth" do
            before(:each) { subject.add 15 }

            its(:height) { should == 1 }
          end

          context "should have a height of 2 after adding a child on the right" do
            before(:each) do
              subject.add [15, 20]
            end

            its(:height) { should == 2 }
          end
        end

        context "Nodes in a tree ('initial' option)" do

          context "should return a height of 2 for the parent of a leaf's parent" do
            before(:each) do
              subject.add 15
              @node = subject.add 20
              subject.add [25, 30]
            end

            it { @node.should_not be_leaf }
            it { @node.height(initial: true).should == 2 }
          end

          context "should return a height of 1 for the parent of a leaf" do
            before(:each) do
              subject.add 15
              @node = subject.add 20
              subject.add 30
            end

            it { @node.should_not be_leaf }
            it { @node.height(initial: true).should == 1 }
          end

          context "should return a height of 0 for a leaf" do
            before(:each) do
              subject.add [15, 20]
              @node = subject.add 30
            end

            it { @node.should be_leaf }
            it { @node.height(initial: true).should == 0 }
          end
        end
      end
    end

    describe "#height" do
      context "Empty tree" do
        subject { Node.new }

        its(:size) { should == 0 }
      end

      context "Tree with one element" do
        subject { Node.new 5 }

        its(:size) { should == 1 }
      end

      context "Not empty tree" do
        subject { Node.new 4 }

        context ' with 2 elements ' do
          before(:each) { subject.add 10 }

          its(:size) { should == 2 }
        end

        context "should have a size of 3 after adding an element" do
          before(:each) do
            subject.add [10, 20]
          end

          its(:size) { should == 3 }
        end

        context "should have a size of 4 after adding another child" do
          before(:each) do
            subject.add [10, 20, 2]
          end

          its(:size) { should == 4 }
        end
      end
    end

    describe "#find" do
      subject do
        Node.new(5).tap do |n|
          n.add [2,4,10,15]
        end
      end

      context "A value which is not present in the tree" do
        it "should raise an Exception" do
          lambda { subject.find(3) }.should raise_error NodeNotFoundError
        end
      end

      context "The minimum value of the tree" do
        context "should return the correct value" do
          let!(:node) { subject.add 1 }

          it { subject.find(1).should == node }
        end
      end

      context "The maximum value of the tree" do
        context "should return the correct value" do
          let!(:node) { subject.add 20 }

          it { subject.find(20).should == node }
        end
      end

      context "A value which is lower than the root's value" do
        context "should return the correct value" do
          let!(:node) { subject.add 3 }

          it { subject.find(3).should == node }
        end
      end

      context "A value which is greater than the root" do
        context "should return the correct value"do
          let!(:node) { subject.add 12 }

          it { subject.find(12).should == node }
        end
      end
    end

    describe "#delete" do
      subject { Node.new 5 }

      context "The root value" do
        context "should delete the value" do
          before(:each) do
            node = subject.add 2
            @deleted_node = subject.delete 2
          end

          it { lambda { subject.find 2 }.should raise_error NodeNotFoundError }
          its(:size) { should == 1 }
          it { should be_root }
          it { should be_valid }
          it { should be_leaf }
          it { @deleted_node.should be_detached }
        end
      end

      context "A value which is not present in the tree" do
        it "should raise a NodeNotFoundError Exception" do
          lambda { subject.find 2 }.should raise_error NodeNotFoundError
        end
      end

      context "The minimum value of the tree" do
        context "should delete the value" do
          before(:each) do
            subject.add [2, 15, 10]
            @deleted_node = subject.delete 2
          end

          it { lambda { subject.find 2 }.should raise_error NodeNotFoundError }
          it { should be_valid }
          its(:size) { should == 3 }
          it { @deleted_node.should be_detached }
        end
      end

      context "The maximum value of the tree" do
        context "should delete the value" do
          before(:each) do
            subject.add [2, 15, 20]
            @deleted_node = subject.delete 20
          end

          it { should be_valid }
          it { lambda { subject.find 20 }.should raise_error NodeNotFoundError }
          its(:size) { should == 3 }
          it { @deleted_node.should be_detached }
        end
      end

      context "A value which is lower than the root's value" do
        context "should delete the value" do
          before(:each) do
            subject.add [2, 4, 20]
            @deleted_node = subject.delete 4
          end

          its(:size) { should == 3 }
          it { should be_valid }
          it { lambda { subject.find 4 }.should raise_error NodeNotFoundError }
          it { @deleted_node.should be_detached }
        end
      end

      context "A value which is greater than the root" do
        context "should delete the value" do
          before(:each) do
            subject.add [2, 10, 12]
            @deleted_node = subject.delete 10
          end

          it { lambda { subject.find 10 }.should raise_error NodeNotFoundError }
          it { should be_valid }
          its(:size) { should == 3 }
          it { @deleted_node.should be_detached }
        end
      end
    end

    describe "ordered?" do
      subject { Node.new 10 }

      context "list with one element" do
        it { should be_ordered }
      end

      context "list with more than one element" do

        context "ordered list" do
          before(:each) do
            subject.add [5, 15]
          end

          it { should be_ordered }
        end

        context "unordered list" do
          before(:each) do
            subject.add [5, 15]
            subject.left_child.value = 20
          end

          it { should_not be_ordered }
        end
      end
    end

    describe '#to_a' do
      subject(:node) { Node.new 5 }
      before(:each) { node.add [1,2,10,20] }

      it { node.to_a.map(&:value).should eq([1,2,5,10,20]) }
    end

    describe '#siblings' do
      subject(:node) { Node.new 5 }
      before(:each) do
        @node2 = node.add 2
        @node10 = node.add 10
        @node6 = node.add 6
        @node1 = node.add 1
      end
      let!(:new_node) { node.add 12 }

      it { new_node.siblings.should match_array([@node1, @node6]) }
      it { @node10.siblings.should match_array([@node2]) }
    end
  end
end
