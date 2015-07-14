require 'rails_helper'

feature 'User enters a  parking spearch', %Q{
   As a ParkingFinder user 
   I want to start a parking search by entering search criteria
} do
  # Acceptance Criteria:
  # * When I go to /parking_searches/new
  # * I must supply a location, time_start and time_end for a parking search
  # * location is defined by name, address, city, state

  scenario 'enter a parking search as an unsigned-in user' do 

    visit '/parking_searches/new'

    fill_in 'Address', with: '540 1st Street'
    fill_in 'City', with: 'New York'
    fill_in 'State', with: 'NY'

    click_button 'Search'

    expect(page).to have_content("Searching")
  end
  
=begin
  scenario 'create new dive site with just required fields' do

    user = FactoryGirl.create(:user)

    visit new_user_session_path

    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password

    click_button 'Log in'

    expect(page).to have_content('Signed in successfully')
    expect(page).to have_content('Sign Out')

    visit '/dive_sites/new'

    fill_in 'Name', with: 'really keen0 dive site 1'
    fill_in 'Location', with: 'east of nowhere'
    select 7, from: 'dive_site_rating'
    select 'expert', from: 'dive_site_difficulty'

    click_button 'Add Dive Site'

    expect(page).to have_content("Dive Site added.")

  end

  scenario 'attempt to create new dive site without required fields' do

    user = FactoryGirl.create(:user)

    visit new_user_session_path

    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password

    click_button 'Log in'

    expect(page).to have_content('Signed in successfully')
    expect(page).to have_content('Sign Out')

    visit '/dive_sites/new'

    fill_in 'Location', with: 'east of nowhere'
    select 7, from: 'dive_site_rating'
    select 'expert', from: 'dive_site_difficulty'

    click_button 'Add Dive Site'

    expect(page).to have_content("Name can't be blank")

  end
=end
  
end
