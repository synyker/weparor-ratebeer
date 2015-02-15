require 'rails_helper'

describe "Ratings page" do
  let!(:brewery) { FactoryGirl.create :brewery, name:"Koff" }
  let!(:beer1) { FactoryGirl.create :beer, name:"iso 3", brewery:brewery }
  let!(:beer2) { FactoryGirl.create :beer, name:"Karhu", brewery:brewery }
  let!(:user) { FactoryGirl.create :user }

  before :each do
    sign_in(username:"Pekka", password:"Foobar1")
  end

  it "when given, is registered to the beer and user who is signed in" do
    visit new_rating_path
    select('iso 3', from:'rating[beer_id]')
    fill_in('rating[score]', with:'15')

    expect{
      click_button "Create Rating"
    }.to change{Rating.count}.from(0).to(1)

    expect(user.ratings.count).to eq(1)
    expect(beer1.ratings.count).to eq(1)
    expect(beer1.average_rating).to eq(15.0)
  end

  it "should contain ratings from database and their count" do
    FactoryGirl.create(:rating, score:10, beer:beer1, user:user)
    FactoryGirl.create(:rating, score:20, beer:beer2, user:user)

    visit ratings_path

    expect(page).to have_content "Number of ratings #{Rating.count}"
    expect(page).to have_content "#{beer1.name} 10 #{user.username}"
    expect(page).to have_content "#{beer2.name} 20 #{user.username}"
    
  end

  it "can be removed by the user" do
    my_rating1 = FactoryGirl.create(:rating, score:10, beer:beer1, user:user)
    my_rating2 = FactoryGirl.create(:rating, score:30, beer:beer2, user:user)
    other_rating = FactoryGirl.create(:rating, score:20, beer:beer1)

    visit user_path(user.id)
    deleted_rating = page.all('li')[1].text

    expect{
      page.all('a', text:'delete' )[1].click
    }.to change{Rating.count}.from(3).to(2)

    visit user_path(user.id)
    expect(page).not_to have_content deleted_rating
  end

end