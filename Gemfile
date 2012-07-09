source :rubygems

gem "rdoc"
gem "rake"

gem "rails", "2.1.2"
gem "facets", "2.8.4", :require => false # Required piecemeal in 'config/preinitializer.rb'
gem "ruby-openid", "2.0.4"
gem "RedCloth", "4.2.9"
gem "hpricot", "0.8.6"

gem "sqlite3-ruby"

group :development do
  gem "capistrano", :require => false
  gem "capistrano-ext", :require => false

  # Optional libraries add debugging and code coverage functionality, but are not
  # needed otherwise. These are not activated by default because they may cause
  # Ruby or RVM to hang, complicate installation, and upset travis-ci. To
  # activate them, create a `.dev` file and rerun Bundler, e.g.:
  #
  #   touch .dev && bundle
  if File.exist?(File.join(File.dirname(File.expand_path(__FILE__)), ".dev"))
    platform :mri_18 do
      gem 'ruby-debug'
      gem 'rcov'
    end

    platform :mri_19 do
      gem 'debugger'
      gem 'debugger-ruby_core_source'
      gem 'simplecov'
    end
  end
end

group :test do
  gem "rspec-rails", "1.3.4", :require => false
end
