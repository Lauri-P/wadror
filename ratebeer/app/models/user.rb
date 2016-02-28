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

	def favorite_beer
		return nil if ratings.empty?
		ratings.order(score: :desc).limit(1).first.beer
	end

	def favorite_style
		return nil if ratings.empty?
		highest_average(ratings.map { |r| [r.beer.style, r.score] })
	end

	def highest_average (datamap)
		ha = Hash.new { |h, k| h[k] = [] }
		hb = Hash.new { |h, k| h[k] = [] }
		datamap.each { |r| ha[r[0]] << r[1] }
		ha.each { |k, value| hb[k] << value.sum/value.count.to_f }
		hb.key(hb.values.max)
	end

	def favorite_brewery
		return nil if ratings.empty?
		highest_average(ratings.map{|r| [r.beer.brewery, r.score]})
	end

	def to_s
		"#{username}"
	end

	def self.top(n)
		sorted_by_rating_in_desc_order = User.all.sort_by{ |b| -(b.ratings.count||0) }
		sorted_by_rating_in_desc_order[0..n-1]
		# palauta listalta parhaat n kappaletta
		# miten? ks. http://www.ruby-doc.org/core-2.1.0/Array.html
	end

end
