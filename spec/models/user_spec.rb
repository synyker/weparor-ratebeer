require 'rails_helper'

describe User do
	it "has the username set correctly" do
		user = User.new username:"Pekka"

		expect(user.username).to eq("Pekka")
	end

	it "is not saved without a password" do
		user = User.create username:"Pekka"

		expect(user.valid?).to be(false)
		expect(User.count).to eq(0)
	end

	describe "with a proper password" do
		let(:user){ FactoryGirl.create(:user) }

		it "is saved with a proper password" do
			expect(user).to be_valid
			expect(User.count).to eq(1)
		end

		it "and with two ratings, has the correct average rating" do
			rating = Rating.new score:10
			rating2 = Rating.new score:20

			user.ratings << FactoryGirl.create(:rating)
			user.ratings << FactoryGirl.create(:rating2)

			expect(user.ratings.count).to eq(2)
			expect(user.average_rating).to eq(15.0)
		end

	end

	it "is not saved when the password is too short" do
		user = User.create username:"Pekka", password:"Sec", password_confirmation:"Sec"

    expect(user).not_to be_valid
		expect(User.count).to eq(0)
	end

	it "is not saved when the password contains no numbers" do
		user = User.create username:"Pekka", password:"Secret", password_confirmation:"Secret"

		expect(user).not_to be_valid
		expect(User.count).to eq(0)
	end
	
	describe "favorite beer" do
		let(:user){ FactoryGirl.create(:user) }

		it "has a method for determining the favorite_beer" do
			expect(user).to respond_to(:favorite_beer)
		end

		it "without ratings does not have a favorite beer" do
			expect(user.favorite_beer).to eq(nil)
		end

		it "is the only rated if only one rating" do
			beer = FactoryGirl.create(:beer)
			rating = FactoryGirl.create(:rating, beer:beer, user:user)

			expect(user.favorite_beer).to eq(beer)
		end

		it "is the one with highest rating if several rated" do
			create_beers_with_ratings(10, 20, 15, 7, 9, user)
      best = create_beer_with_rating(25, user)
      
      expect(user.favorite_beer).to eq(best)
    end

	end

	describe "favorite style" do
		let(:user){ FactoryGirl.create(:user) }

		it "has a method for determining favorite_style" do
			expect(user).to respond_to(:favorite_style)
		end

		it "without ratings does not have a favorite style" do
			expect(user.favorite_style).to eq(nil)
		end

		it "is the one with the highest average rating scores if several rated" do
			beer = FactoryGirl.create(:beer, style:"Lager")
			FactoryGirl.create(:rating, score:10, beer:beer, user:user)

			expect(user.favorite_style).to eq("Lager")
		end
	end

	describe "favorite brewery" do
		let(:user){ FactoryGirl.create(:user) }

		it "has a method for determining favorete_brewery" do
			expect(user).to respond_to(:favorite_brewery)
		end

		it "without ratings does not have a favorite brewery" do
			expect(user.favorite_brewery).to eq(nil)
		end

		it "is the one with the highest average rating scores if several rated" do
			beer = FactoryGirl.create(:beer)
			beer2 = FactoryGirl.create(:beer, name:"Kalja", style:"IPA")

			FactoryGirl.create(:rating, score:30, beer:beer, user:user)
			FactoryGirl.create(:rating, score:20, beer:beer2, user:user)
			expect(user.favorite_brewery.name).to eq(beer.brewery.name)
		end
	end

	def create_beer_with_rating(score, user)
		beer = FactoryGirl.create(:beer)
		FactoryGirl.create(:rating, score:score, beer:beer, user:user)
		beer
	end

	def create_beers_with_ratings(*scores, user)
		scores.each do |score|
			create_beer_with_rating(score, user)
		end
	end

end
