class BeerClub < ActiveRecord::Base
	has_many :memberships, dependent: :destroy
	has_many :users, through: :memberships
	
	validates :name, presence: true
	validates :city, presence: true
	validates :founded, numericality: {only_integer: true }
end
