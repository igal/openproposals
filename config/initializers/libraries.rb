# Local libraries
require 'lib/ext/object_logit'
require 'lib/ext/active_support_cache_filestore'
require 'lib/defer_proxy'

# Local gems
# FIXME why is this causing exception some times, but not at others?
require 'RedCloth' rescue nil # Make #textilize will work w/ RedCloth 4.1.x
