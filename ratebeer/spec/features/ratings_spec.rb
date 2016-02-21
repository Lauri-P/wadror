require 'rails_helper'

include Helpers

describe "Rating" do
  let!(:brewery) { FactoryGirl.create :brewery, name:"Koff" }
  let!(:beer1) { FactoryGirl.create :beer, name:"iso 3", brewery:brewery, style:FactoryGirl.create(:style, style:"style2") }
  let!(:beer2) { FactoryGirl.create :beer, name:"Karhu", brewery:brewery, style:FactoryGirl.create(:style, style:"style3") }
  let!(:user) { FactoryGirl.create :user }

  before :each do
    sign_in(username:"Pekka", password:"Foobar1")
  end

  it "when given, is registered to the beer and user who is signed in" do
    visit new_rating_path
    select('iso 3', from:'rating[beer_id]')
    fill_in('rating[score]', with:'15')

    expect{
      click_button "Create Rating"
    }.to change{Rating.count}.from(0).to(1)

    expect(user.ratings.count).to eq(1)
    expect(beer1.ratings.count).to eq(1)
    expect(beer1.average_rating).to eq(15.0)
  end

  it "shows ratings on page" do
    create_beer_with_rating(user, 10)
    visit ratings_path
    expect(page).to have_content("Number of ratings: 1")
    expect(page).to have_content("anonymous: 10")
  end

  it "shows rating on users page" do
    create_beer_with_rating(user, 10)
    visit user_path(user)
    expect(page).to have_content("This user has made 1 rating")
    expect(page).to have_content("anonymous: 10")
  end

  it "doesn't show rating on other users page" do
    user2=FactoryGirl.create :user, username:"Antti"
    create_beer_with_rating(user2, 10)
    visit user_path(user)
    expect(page).to have_content("This user has made 0 rating")
    expect(Rating.count).to eq(1)
  end

  it "can be deleted by user" do
    create_beer_with_rating(user, 10)
    visit user_path(user)
    click_link 'delete'
    expect(page).to have_content("This user has made 0 rating")
    expect(Rating.count).to eq(0)

  end

  it "shows users favorite style in users page" do
    create_beer_with_rating(user, 10)
    visit user_path(user)
    expect(page).to have_content("Favorite style: Lager")
  end

  it "shows users favorite brewery in users page" do
    create_beer_with_rating(user, 10)
    visit user_path(user)
    expect(page).to have_content("Favorite brewery: anonymous")
  end

end

def create_beer_with_rating(user, score)
  beer = FactoryGirl.create(:beer)
  FactoryGirl.create(:rating, score:score, beer:beer, user:user)
  beer
end