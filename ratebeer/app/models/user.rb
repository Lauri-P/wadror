class User < ActiveRecord::Base
	include RatingAverage
	
	has_secure_password
	validates :password, :format => {:with => /(?=.*[A-Z])(?=.*[0-9]).{4,}/, message: "must be at least 4 characters and include one number and one capital letter."}
	
	validates :username, uniqueness: true
	validates :username, length: { minimum: 3, maximum: 15 }
	has_many :ratings, dependent: :destroy   # käyttäjällä on monta ratingia
	has_many :beers, through: :ratings
	has_many :memberships, dependent: :destroy
	has_many :beer_clubs, through: :memberships
end
