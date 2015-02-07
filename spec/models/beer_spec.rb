require 'rails_helper'

describe Beer do

	it "is saved if name and style are set" do
		beer = Beer.create name:"Kalja", style:"Lager"

		expect(beer).to be_valid
		expect(Beer.count).to eq(1)
	end

	it "is not created without a name" do
		beer = Beer.create style:"Lager"

		expect(beer).not_to be_valid
		expect(Beer.count).to eq(0)
	end

	it "is not created without a style" do
		beer = Beer.create name:"Kalja"

		expect(beer).not_to be_valid
		expect(Beer.count).to eq(0)		
	end

end
