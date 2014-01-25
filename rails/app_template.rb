#
# Custom Rails Application Template
# 


# Remove the rdoc and replace with a markdown readme file
remove_file "README.rdoc"
create_file "README.md", "# TODO"


# Add these gems into the gemfile
gem 'thin'
gem 'compass-rails'
gem 'modernizr-rails'
gem 'susy'

gem_group :test, :development do
  gem 'rspec-rails'
  gem 'capybara'
  gem 'capybara-webkit'
end

# Add support for better_errors, and RailsPanel
gem_group :development do
	gem 'better_errors'
	gem 'binding_of_caller'
	gem 'meta_request'
  gem 'pry-rails'
end

if yes? "Do you want to include Ember.JS support?"
	gem 'ember-rails'
	gem 'ember-source', '~> 1.2.0'
	doEmberInstall = true
end


# Update the gems installed so we can setup rspec
run "bundle install"

# Initialize rspec support and add in the spec/feature directory
# for Capybara
generate "rspec:install"
Dir.mkdir('spec/features')


# Replace application.css with proper application.css.scss with compass support
remove_file 'app/assets/stylesheets/application.css'
file 'app/assets/stylesheets/application.css.scss', <<-EOS
@import "compass";
@import "compass/reset";
@import "susy";

EOS


#
# Insert Capybara dependencies
#
inject_into_file('spec/spec_helper.rb', :after => /^require 'rspec\/autorun'/ ) do
<<-EOS

require 'capybara/rspec'

# Use the webkit javascript driver
Capybara.javascript_driver = :webkit
EOS
end

#
# Better Errors
# 
initializer 'better_errors.rb', <<-EOS
BetterErrors.editor = :sublime if defined? BetterErrors
EOS

#
# Insert HTML Boilerplate into application.html.erb
# 
inject_into_file('app/views/layouts/application.html.erb', :after => /^<!DOCTYPE html>/ ) do
<<-EOS

<!--[if lt IE 7]>      <html class="no-js lt-ie9 lt-ie8 lt-ie7"> <![endif]-->
<!--[if IE 7]>         <html class="no-js lt-ie9 lt-ie8"> <![endif]-->
<!--[if IE 8]>         <html class="no-js lt-ie9"> <![endif]-->
<!--[if gt IE 8]><!--> <html class="no-js"> <!--<![endif]-->
EOS
end
inject_into_file('app/views/layouts/application.html.erb', :after => /^<head>/) do
<<-EOS

  <meta charset="utf-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
EOS
end
inject_into_file('app/views/layouts/application.html.erb', :after => /^<body>/) do
<<-EOS

	<!--[if lt IE 7]>
	    <p class="browsehappy">You are using an <strong>outdated</strong> browser. Please <a href="http://browsehappy.com/">upgrade your browser</a> to improve your experience.</p>
	<![endif]-->
EOS
end
inject_into_file('app/views/layouts/application.html.erb', :before => /^<\/body>/) do
  # <script src="//ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js"></script>
  # <script>window.jQuery || document.write('<script src="js/vendor/jquery-1.10.2.min.js"><\/script>')</script>
<<-EOS
  <!-- Google Analytics: change UA-XXXXX-X to be your site's ID. -->
  <script>
      (function(b,o,i,l,e,r){b.GoogleAnalyticsObject=l;b[l]||(b[l]=
      function(){(b[l].q=b[l].q||[]).push(arguments)});b[l].l=+new Date;
      e=o.createElement(i);r=o.getElementsByTagName(i)[0];
      e.src='//www.google-analytics.com/analytics.js';
      r.parentNode.insertBefore(e,r)}(window,document,'script','ga'));
      ga('create','UA-XXXXX-X');ga('send','pageview');
  </script>
EOS
end


#
# Insert Modernizr dependencies
# 
inject_into_file('app/views/layouts/application.html.erb', :before => /^  <%= javascript_include_tag/) do
<<-EOS
  <%= javascript_include_tag :modernizr %>
EOS
end


#
# Insert viewport meta tags into application.html.erb
#
inject_into_file('app/views/layouts/application.html.erb', :before => /^  <title>/) do
<<-EOS

  <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />
  <meta name="apple-mobile-web-app-capable" content="yes" />
  <meta name="apple-mobile-web-app-status-bar-style" content="black" />
	<meta name="description" content="">

EOS
end


# If we added ember.js then do the ember install stage
if doEmberInstall
	`rails g ember:bootstrap`
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



