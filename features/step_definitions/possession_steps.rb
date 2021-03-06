Given(/^a release exists$/) do
  @release = FactoryGirl.create(:release)
end

Given(/^a user who is logged in and looking at a release$/) do
  step "a release exists"
  step "a user who is logged in"
  step "I go to a release"
end

Given(/^a user with multiple possessions who logs in$/) do
  step "a user who is logged in"
  (1..3).each do |num|
    title = "test#{num}"
    release = FactoryGirl.create(:release, title:title)
    Possession.where(release_wiki_link:ReleaseWikiLink.new(release_id:release.id, 
    reference_text:"oid:#{release.id}", title:release.title), owner:@user).create!
  end
end

When(/^I click on "(.*?)" and confirm$/) do |link|
  click_link link
  find('a#confirmaddmusic', text:link).click
end

When(/^I add this release to my collection$/) do
  click_link "Add to My Music"
end

When(/^I fill in a few labels$/) do
  label = "test"
  fill_in "token-input-labels", with: label
  select_fb_token label
  find('a#confirmaddmusic').click
end

When(/^I remove a random possession$/) do
  poss = @user.possessions.sample
  find(:xpath, "//a[@href='#{possession_path poss}' and @data-method='delete']").click
  @removed_poss = poss.release_wiki_link.title
end

When(/^I fill in possession info and submit$/) do
  @release = Release.first.title
  fill_in "token-input-possession_release_wiki_link_text", with: @release[0,3]
  select_token @release
  @label = "test"
  fill_in "token-input-possession_labels_text", with: @label
  select_fb_token @label
  fill_in "Comments", with: "This album rocks!"
end

Then(/^the release should be in my possession$/) do
  count = 0
  while count < 30
    break if @user.reload.possessions.all.size > 0
    count += 1
    sleep 1
  end
  @user.possessions.all.size.should eq 1
end

Then(/^my possession should be labeled$/) do
  step "the release should be in my possession"
  poss = @user.possessions.first
  poss.labels.size.should eq 1
  poss.labels.should include "test"
end

Then(/^I should see all of my possessions$/) do
  @user.possessions.each do |poss|
    page.should have_content poss.release_wiki_link.title
  end
end

Then(/^it should not be shown in My Music$/) do
  page.should_not have_content @removed_poss
end

Then(/^I should see my new possession$/) do
  page.should have_content @release
  page.should have_content @label
end
