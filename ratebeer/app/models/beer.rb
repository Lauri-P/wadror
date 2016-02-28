class Beer < ActiveRecord::Base
	include RatingAverage
	validates :name, presence: true
	validates :style, presence: true
	belongs_to :brewery
	has_many :ratings, dependent: :destroy
	has_many :raters, -> { uniq }, through: :ratings, source: :user
	belongs_to :style
	
	def to_s
		"#{name} by #{brewery.name}"
	end

	def self.top(n)
		sorted_by_rating_in_desc_order = Beer.all.sort_by{ |b| -(b.average_rating||0) }
		sorted_by_rating_in_desc_order[0..n-1]
		# palauta listalta parhaat n kappaletta
		# miten? ks. http://www.ruby-doc.org/core-2.1.0/Array.html
	end
	
	#def average_rating
	#	if ratings.empty?
	#		"NaN"
	#	else
	#		sum=ratings.inject(0) {|memo, rating| memo+rating.score}
	#		sum/(1.0*ratings.count)
	#	end
	#end
end
