# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    if !Movie.exists?('title' => movie['title'])
      entry = Movie.new;
      entry.title = movie['title'];
      entry.rating = movie['rating'];
      entry.release_date = movie['release_date'];
      entry.save
    end
  end
end

Then /(.*) seed movies should exist/ do | n_seeds |
  expect(Movie.count).to be n_seeds.to_i
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.body is the entire content of the page as a string.
  e1 = e1.tr('\"',"")
  e2 = e2.tr('\"',"")
  e1_index = page.body.index(e1)
  e2_index = page.body.index(e2)
  if e1_index != nil and e2_index != nil
    expect(e1_index).to be < e2_index
  else
    fail e1 + " does not occur before " + e2
  end
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  rating_split_list = rating_list.split(',');
  rating_split_list.each do |rating|
    if uncheck
      step "uncheck \"ratings[" +rating+"]\"" 
    else
    step "check \"ratings[" +rating+"]\"" 
    end
  end
end

Then /I should see all the movies/ do
  # Make sure that all the movies in the app are visible in the table
  step "10 seed movies should exist"
end
