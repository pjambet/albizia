require "spec_helper"

module Albizia
  describe RBNode do
    subject(:node) { RBNode.new 10 }

    it { should be_black }
    it { should be_leaf }
    it { should be_valid }
  end
end
