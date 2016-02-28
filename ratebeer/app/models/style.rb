class Style < ActiveRecord::Base
  include RatingAverage

  has_many :beers, dependent: :destroy
  has_many :ratings, through: :beers



  def self.top(n)
    sorted_by_rating_in_desc_order = Style.all.sort_by{ |b| -(b.average_rating||0) }
    sorted_by_rating_in_desc_order[0..n-1]
    # palauta listalta parhaat n kappaletta
    # miten? ks. http://www.ruby-doc.org/core-2.1.0/Array.html
    end

  def to_s
    "#{self.style}"
  end

end


