#
# Custom Rails Application Template
#

# Remove the rdoc and replace with a markdown readme file
remove_file "README.rdoc"
create_file "README.md", "# TODO"

gem_group :test, :development do
  gem 'rspec-rails'
  gem 'capybara'
end

gem_group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'pry-rails'
end

# Update the gems installed so we can setup rspec
run "bundle install"

# Initialize rspec support and add in the spec/feature directory
# for Capybara
generate "rspec:install"
Dir.mkdir('spec/features')

#
# Better Errors
#
initializer 'better_errors.rb', <<-EOS
BetterErrors.editor = :sublime if defined? BetterErrors
EOS

#
# Insert viewport meta tags into application.html.erb
#
inject_into_file('app/views/layouts/application.html.erb', :before => /^  <title>/) do
<<-EOS

  <meta name="viewport" content="width=device-width, initial-scale=1.0" />

EOS
end

# Ask if we want a root controller created
if yes? "Do you want to generate a root controller?"
  name = ask("What should it be called?").underscore
  generate :controller, "#{name} index"
  route "root to: '#{name}\#index'"
end

#
# Git Setup
#
git :init
git add: "."
git commit: %Q{ -m "Initial commit" }

