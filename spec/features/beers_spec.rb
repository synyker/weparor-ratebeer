require 'rails_helper'

describe "Beers page" do
  let!(:user) { FactoryGirl.create :user }

  before :each do
    sign_in(username:"Pekka", password:"Foobar1")
    FactoryGirl.create(:brewery, name: "Malmgard", year: 1900)
  end

  it "should allow creation of beers with a valid name when signed in" do
    visit new_beer_path
    fill_in('beer[name]', with:'Testikalja')
    select('IPA', from:'beer[style]')
    select('Malmgard', from:'beer[brewery_id]')
    
    expect{
      click_button "Create Beer"
    }.to change{Beer.count}.from(0).to(1)
  end

  it "should return to new_beer_path if name is invalid when signed in" do
    visit new_beer_path
    fill_in('beer[name]', with:'')
    select('IPA', from:'beer[style]')
    select('Malmgard', from:'beer[brewery_id]')

    click_button "Create Beer"

    expect(page).to have_content "Name can't be blank"
    expect(Beer.count).to eq(0)
    
  end

end