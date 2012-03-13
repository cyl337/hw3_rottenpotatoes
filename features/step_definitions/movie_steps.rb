# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  @movies_tot = movies_table.hashes.size
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    Movie.create(movie)
  end
  # assert false, "Unimplmemented"
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.content  is the entire content of the page as a string.
  assert page.body =~ /<td>#{e1}<\/td>.*<td>#{e2}<\/td>/m, "#{e1} is not before #{e2}."
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  rating_list.split(/\s*,\s*/).each do |rating|
    step %{I #{uncheck ? 'un' : ''}check "ratings_#{rating}"}
  end
end

Then /I should see (all|none) of the movies/ do |isAll|
  actual_num = page.all(:css, 'table#movies tbody tr').size
  expected_num = isAll == 'all' ? @movies_tot : 0
  if actual_num.respond_to? :should
    actual_num.should == expected_num
  else
    assert actual_num == expected_num, "Number of movies - actual: #{actual_num}, expected: #{expected_num}"
  end
end
