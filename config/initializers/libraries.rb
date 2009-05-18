# Local libraries
require 'lib/ext/active_support_cache_filestore'

# Local gems
begin
  # FIXME why is this causing exception some times, but not at others?
  require 'RedCloth' # Make #textilize will work w/ RedCloth 4.1.x
rescue
  # Ignore
end
