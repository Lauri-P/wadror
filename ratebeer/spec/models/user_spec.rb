require 'rails_helper'


RSpec.describe User, type: :model do
  it "has the username set correctly" do
    user = User.new username:"Pekka"

    expect(user.username).to eq("Pekka")
  end

  it "is not saved without a password" do
    user = User.create username:"Pekka"

    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  it "denies numberless passwords" do
    user = User.create username:"Pekka", password:"Secret", password_confirmation:"Secret"

    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  it "denies short passwords" do
    user = User.create username:"Pekka", password:"Se1", password_confirmation:"Se1"

    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  describe "with a proper password" do
    let(:user){ FactoryGirl.create(:user) }

    it "is saved" do
      expect(user).to be_valid
      expect(User.count).to eq(1)
    end

    it "and with two ratings, has the correct average rating" do
      user.ratings << FactoryGirl.create(:rating)
      user.ratings << FactoryGirl.create(:rating2)

      expect(user.ratings.count).to eq(2)
      expect(user.average_rating).to eq(15.0)
    end

  end


  describe "favorite beer" do
    let(:user){FactoryGirl.create(:user) }

    it "has method for determining one" do
      expect(user).to respond_to(:favorite_beer)
    end

    it "without ratings does not have one" do
      expect(user.favorite_beer).to eq(nil)
    end

    it "is the only rated if only one rating" do
      beer = create_beer_with_rating(user, 10)

      expect(user.favorite_beer).to eq(beer)
    end

    it "is the one with highest rating if several rated" do
      create_beers_with_ratings(user, 10, 20, 15, 7, 9)
      best = create_beer_with_rating(user, 25)

      expect(user.favorite_beer).to eq(best)
    end
  end

  describe "favorite style" do
    let(:user){FactoryGirl.create(:user) }

    it "has method for determining one" do
      expect(user).to respond_to(:favorite_style)
    end

    it "without ratings does not have one" do
      expect(user.favorite_style).to eq(nil)
    end

    it "is the style of the only rated if only one rating" do
      beer = create_beer_with_rating(user, 10)

      expect(user.favorite_style).to eq(beer.style)
    end

    it "is the style with highest average rating" do
      create_beers_with_ratings(user, 10, 20, 15, 7, 9)
      create_beer2_with_rating(user, 19)
      create_beer2_with_rating(user, 18)

      expect(user.favorite_style).to eq("Beer")
    end
  end

  describe "favorite brewery" do
    let(:user){FactoryGirl.create(:user) }

    it "has method for determining one" do
      expect(user).to respond_to(:favorite_brewery)
    end

    it "without ratings does not have one" do
      expect(user.favorite_brewery).to eq(nil)
    end

    it "is the brewery of the only rated if only one rating" do
      beer = create_beer_with_rating(user, 10)

      expect(user.favorite_brewery).to eq(beer.brewery.name)
    end

    it "is the brewery with highest average rating" do
      create_beers_with_ratings(user, 10, 20, 15, 7, 9)
      create_beer2_with_rating(user, 19)
      create_beer3_with_rating(user, 18)

      expect(user.favorite_brewery).to eq("Muu")
    end
  end

end

def create_beer_with_rating(user, score)
  beer = FactoryGirl.create(:beer)
  FactoryGirl.create(:rating, score:score, beer:beer, user:user)
  beer
end

def create_beers_with_ratings(user, *scores)
  scores.each do |score|
    create_beer_with_rating(user, score)
  end
end

def create_beer2_with_rating(user, score)
  beer = FactoryGirl.create(:beer, style:"Beer")
  FactoryGirl.create(:rating, score:score, beer:beer, user:user)
  beer
end

def create_beer3_with_rating(user, score)
  beer = FactoryGirl.create(:beer, style:"Beer", brewery:FactoryGirl.create(:brewery, name:"Muu"))
  FactoryGirl.create(:rating, score:score, beer:beer, user:user)
  beer
end
