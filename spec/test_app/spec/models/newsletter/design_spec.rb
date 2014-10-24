require 'spec_helper'

describe Newsletter::Design do
  before(:each) do 
    @design = import_design(nil,"My Design")
  end

  it "sets the name correctly" do
    expect(@design.name).to eq("My Design")
  end
end
