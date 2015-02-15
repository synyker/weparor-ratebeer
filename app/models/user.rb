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

	def favorite_beer
		return nil if ratings.empty?
		ratings.order(score: :desc).limit(1).first.beer
	end

	def favorite_style
		return nil if ratings.empty?	
		return style_sorted_ratings(ratings.includes(:beer).order("beers.style_id asc"))
	end

	def style_sorted_ratings(sorted_ratings)
		highest = 0;
		favorite = "";

		sorted_ratings.chunk { |r| 
			r.beer.style_id
		}.each { |style, ratings|
			avg = ratings.map { |r| r.score }.sum / ratings.count.to_f
			if avg > highest
				highest = avg
				favorite = style
			end
		}

		return favorite
	end

	def favorite_brewery
		return nil if ratings.empty?
		id = brewery_sorted_ratings((ratings.includes(:beer).order("beers.brewery_id desc")))
		Brewery.find id
	end

	def brewery_sorted_ratings(sorted_ratings)
		highest = 0;
		favorite = "";

		sorted_ratings.chunk { |r| 
			r.beer.brewery_id
		}.each { |brewery, ratings|
			avg = ratings.map { |r| r.score }.sum / ratings.count.to_f
			if avg > highest
				highest = avg
				favorite = brewery
			end
		}

		return favorite
	end

end
