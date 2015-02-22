class Beer < ActiveRecord::Base
	include RatingAverage
	belongs_to :brewery
	belongs_to :style
	has_many :ratings, dependent: :destroy
	has_many :users, through: :ratings

	validates :name, :style, presence: true

	def self.top(n)
	   sorted_by_rating_in_desc_order = Beer.all.sort_by{ |b| -(b.average_rating||0) }
	   top = sorted_by_rating_in_desc_order[0..n-1]
	end

	def to_s
		"#{self.name} (#{self.brewery.name})"
	end
end
