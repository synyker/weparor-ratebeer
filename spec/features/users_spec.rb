require 'rails_helper'

describe "User page" do
  let!(:brewery) { FactoryGirl.create :brewery, name:"Koff" }
  let!(:beer1) { FactoryGirl.create :beer, name:"iso 3", brewery:brewery }
  let!(:beer2) { FactoryGirl.create :beer, name:"Karhu", brewery:brewery }
  
  before :each do
    user = FactoryGirl.create :user
  end

  describe "who has signed up" do
    it "can sign in with right credentials" do
      sign_in(username:"Pekka", password:"Foobar1")

      expect(page).to have_content 'Welcome back!'
      expect(page).to have_content 'Pekka'
    end

    it "is redirected back to signin form if wrong credentials given" do
      sign_in(username:"Pekka", password:"wrong")

      expect(current_path).to eq(signin_path)
      expect(page).to have_content 'Username and/or password mismatch'
    end

  end

  it "when signed up with good credentials, is added to the system" do
    visit signup_path
    fill_in('user_username', with:'Brian')
    fill_in('user_password', with:'Secret55')
    fill_in('user_password_confirmation', with:'Secret55')

    expect{
      click_button('Create User')
    }.to change{User.count}.by(1)
  end

  it "only shows own ratings" do
    user2 = FactoryGirl.create(:user2)

    FactoryGirl.create(:rating, score:10, beer:beer1, user:User.first)
    FactoryGirl.create(:rating, score:20, beer:beer2, user:user2)

    sign_in(username:"Matti", password:"Secret1")
    visit user_path(user2)

    expect(page).to have_content "#{beer2.name} 20"
    expect(page).not_to have_content "#{beer1.name} 10"

  end

  it "has favorite beer, style and brewery on user page if ratings added" do
    user2 = FactoryGirl.create(:user2)
    brewery2 = FactoryGirl.create :brewery, name:"Malmgard"
    beer3 = FactoryGirl.create :beer, name:"Kalia", brewery:brewery2, style:"IPA"

    sign_in(username:"Pekka", password:"Foobar1")

    FactoryGirl.create(:rating, score:10, beer:beer1, user:user2)
    FactoryGirl.create(:rating, score:10, beer:beer2, user:user2)
    FactoryGirl.create(:rating, score:30, beer:beer3, user:user2)

    visit user_path(user2)

    expect(page).to have_content "Favorite beer: #{beer3.name}"
    expect(page).to have_content "Favorite beer style: #{beer3.style}"
    expect(page).to have_content "Favorite brewery: #{brewery2.name}"
  end

  it "has no favorite beer, style or brewery if no ratings are added" do
    user2 = FactoryGirl.create(:user2)
    sign_in(username:"Pekka", password:"Foobar1")

    visit user_path(user2)

    expect(page).not_to have_content "Favorite beer"
    expect(page).not_to have_content "Favorite beer style"
    expect(page).not_to have_content "Favorite brewery"
  end

end