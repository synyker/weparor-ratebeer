class User < ActiveRecord::Base
	include RatingAverage

	has_secure_password

	validates :username, uniqueness: true,
		length: { minimum: 3, 
				  maximum: 15 }
	validates :password, length: { minimum: 4}
	validates :password, format: { :with => /[A-Z]/, message: "at least one capital letter required" }
	validates :password, format: { :with => /[0-9]/, message: "at least one number required" }

	has_many :ratings
	has_many :raters, -> { uniq }, through: :ratings, source: :user
	has_many :memberships
	has_many :beer_clubs, through: :memberships
end
