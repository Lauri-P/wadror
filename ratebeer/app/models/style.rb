class Style < ActiveRecord::Base
  has_many :beers, dependent: :destroy
  validates :style, uniqueness: true
end
