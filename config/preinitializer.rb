# Bundler integration from http://gist.github.com/302406
begin
  # Require the preresolved locked set of gems.
  require File.expand_path('../../.bundle/environment', __FILE__)
rescue LoadError
  # Fallback on doing the resolve at runtime.
  require "rubygems"
  require "bundler"
  if Gem::Version.new(Bundler::VERSION) <= Gem::Version.new("0.9.5")
    raise RuntimeError, "Bundler incompatible.\n" +
      "Your bundler version is incompatible with Rails 2.3 and an unlocked bundle.\n" +
      "Run `gem install bundler` to upgrade or `bundle lock` to lock."
  else
    Bundler.setup
  end
end

# Standard librarires
require 'csv'
require 'ostruct'
require 'stringio'
require 'uri'
require 'fileutils'

# Gems
require 'rubygems'

# Facets
# NOTE: Facets 2.8.4 is the last version to include the dictionary class
require 'facets/dictionary'
require 'facets/enumerable/mash'
require 'facets/file/write'
require 'facets/kernel/ergo'
#IK# require 'facets/kernel/tap'
require 'facets/kernel/with'

# See also config/initializers/libraries
