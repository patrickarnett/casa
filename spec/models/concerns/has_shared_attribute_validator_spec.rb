require "rails_helper"

class Klass
  include ActiveModel::Validations

  attr_reader :association1, :association2

  validates :association1, has_shared_attribute: {shared_attribute: :casa_org, shared_with: :association2}
end

RSpec.describe Klass do
  let(:object) { Klass.new }
  let(:casa_org1) { create(:casa_org) }
  let(:casa_org2) { create(:casa_org) }
  let(:association1) { double("association", casa_org: casa_org1) }

  before do
    allow(object).to receive(:association1).and_return association1
    allow(object).to receive(:association2).and_return association2
  end

  context "when both associations are present" do
    let(:association2) { double("association") }

    before { allow(association2).to receive(:casa_org).and_return other_casa_org }

    context "when associations share attribute" do
      let(:other_casa_org) { casa_org1 }

      it "is valid" do
        expect(object).to be_valid
      end
    end

    context "when associations do not share attribute" do
      let(:other_casa_org) { casa_org2 }

      it "is invalid" do
        expect(object).to be_invalid
      end
    end
  end

  context "when an association is blank" do
    let(:association2) { nil }

    it "is valid" do
      expect(object).to be_valid
    end
  end
end
