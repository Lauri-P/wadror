module RatingAverage
	extend ActiveSupport::Concern
	
	def average_rating
		if ratings.empty?
			"NaN"
		else
			sum=ratings.inject(0) {|memo, rating| memo+rating.score}
			sum/(1.0*ratings.count)
		end
	end
end