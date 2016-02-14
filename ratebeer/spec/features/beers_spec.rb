require 'rails_helper'

include Helpers

describe "Beers" do

  before :each do
    FactoryGirl.create(:brewery)
    FactoryGirl.create :user
    sign_in(username:"Pekka", password:"Foobar1")
  end

  it "can't be added without proper name" do
    visit new_beer_path
    click_button('Create Beer')
    expect(page).to have_content "Name can't be blank"
    expect(Beer.count).to eq(0)
  end

  it "can be added with proper name" do
    visit new_beer_path
    fill_in('beer_name', with:'Testinimi')
    expect{
      click_button('Create Beer')
    }.to change{Beer.count}.by(1)
  end

end