require 'rails_helper'

RSpec.describe Beer, type: :model do
  it "is not saved without name" do
    beer = Beer.create style:"beer"

    expect(beer).not_to be_valid
    expect(Beer.count).to eq(0)
  end

  it "is not saved without style" do
    beer = Beer.create name:"beer"

    expect(beer).not_to be_valid
    expect(Beer.count).to eq(0)
  end

  it "is saved with name and style" do
    beer = Beer.create name:"Beer", style:"beer"

    expect(beer).to be_valid
    expect(Beer.count).to eq(1)
  end
end
