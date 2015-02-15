class Beer < ActiveRecord::Base
	include RatingAverage
	belongs_to :brewery
	belongs_to :style
	has_many :ratings, dependent: :destroy
	has_many :users, through: :ratings

	validates :name, :style, presence: true

	def to_s
		"#{self.name} (#{self.brewery.name})"
	end
end
