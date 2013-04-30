Given(/^an admin is logged in$/) do
  @user = FactoryGirl.create(:user, groups:["super-admin"])
  step "logged in user"
end

Given(/^an artist, recording, release, and work$/) do
  @artist = FactoryGirl.create(:artist)
  @recording = FactoryGirl.create(:recording)
  @release = FactoryGirl.create(:release)
  @work = FactoryGirl.create(:work)
end

When(/^I visit each of these$/) do
  @places_to_vist = [artist_path(@artist), recording_path(@recording), release_path(@release), work_path(@work)]
end

Then(/^I should see a delete link$/) do
  @places_to_vist.each do |place|
    visit place
    page.should have_link I18n.t('delete')
  end
end