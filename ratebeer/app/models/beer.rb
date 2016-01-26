class Beer < ActiveRecord::Base
	include RatingAverage

	belongs_to :brewery
	has_many :ratings, dependent: :destroy
	
	def to_s
		"#{name} by #{brewery.name}"
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
