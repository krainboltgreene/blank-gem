require "spec_helper"

RSpec.describe ActiveModel::Changelog::VERSION do
  it "should be a string" do
    expect(ActiveModel::Changelog::VERSION).to be_kind_of(String)
  end
end
