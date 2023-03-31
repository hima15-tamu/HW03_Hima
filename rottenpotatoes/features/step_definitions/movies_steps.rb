# frozen_string_literal: true

Given(/the following movies exist/) do |movies_table|
  movies_table.hashes.each do |movie|
    Movie.create movie
  end
end

Then(/I should see "(.*)" before "(.*)"/) do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.body is the entire content of the page as a string.
  expect(page.body.index(e1) < page.body.index(e2))
end

When(/I (un)?check the following ratings: (.*)/) do |uncheck, rating_list|
  rating_list.split(', ').each do |rating|
    step %(I #{uncheck.nil? ? '' : 'un'}check "ratings_#{rating}")
  end
end

Then(/I should see all the movies/) do
  # Make sure that all the movies in the app are visible in the table
  Movie.all.each do |movie|
    step %(I should see "#{movie.title}")
  end
end

Then(/the director of "(.*)" should be "(.*)"/) do |movie_title, movie_director|
  expect(Movie.find_by(title: movie_title).director).to eq movie_director
end

When('I go to the edit page for {string}') do |movie_name|
  movie = Movie.find_by(title: movie_name)
  visit edit_movie_path(movie)
end

When('I fill in {string} with {string}') do |movie_name, name|
  fill_in(movie_name, with: name)
end

When('I press {string}') do |button|
  click_button(button)
end

Given(/I am on the details page for "(.*)"/) do |movie_name|
  movie = Movie.find_by(title: movie_name)
  visit movie_path(movie)
end

When('I follow {string}') do |my_link|
  click_link(my_link)
end

Then('I should be on the Similar Movies page for {string}') do |string|
  expect(show_by_director_path(Movie.find_by(title: string))).to eq current_path
end

Then('I should not see {string}') do |name|
  expect(page).not_to have_content(name)
end
Then('I should see {string}') do |name|
  expect(page).to have_content(name)
end

Then('I should be on the home page') do
  expect(page).to have_current_path(movies_path)
end
