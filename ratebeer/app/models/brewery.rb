class Brewery < ActiveRecord::Base
	include RatingAverage
	
	has_many :beers, dependent: :destroy
	has_many :ratings, through: :beers
	
	def print_report
		puts name
		puts "established at year #{year}"
		puts "number of beers #{beers.count}"
	end
	
	def restart
		self.year = 2016
		puts "changed year to #{year}"
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
