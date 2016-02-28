class Brewery < ActiveRecord::Base
	include RatingAverage
	
	validates :name, presence: true
	validates :year, numericality: { greater_than_or_equal_to: 1042,
                                    only_integer: true }
	validate :no_future_years
	
	has_many :beers, dependent: :destroy
	has_many :ratings, through: :beers

	scope :active, -> { where active:true }
	scope :retired, -> { where active:[nil,false] }

	def print_report
		puts name
		puts "established at year #{year}"
		puts "number of beers #{beers.count}"
	end
	
	def restart
		self.year = 2016
		puts "changed year to #{year}"
	end
	
	
	def no_future_years
		if year>Time.now.year
			errors.add(:year, "can't be future year")
		end
	end

	def self.top(n)
		sorted_by_rating_in_desc_order = Brewery.all.sort_by{ |b| -(b.average_rating||0) }
		sorted_by_rating_in_desc_order[0..n-1]
		# palauta listalta parhaat n kappaletta
		# miten? ks. http://www.ruby-doc.org/core-2.1.0/Array.html
	end

	def to_s
		"#{name}"
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
