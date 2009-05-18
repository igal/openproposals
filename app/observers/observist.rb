class Observist < ActiveRecord::Observer
  observe \
    Comment,
    Event,
    Proposal,
    Snippet
  # User is never cached and thus unobserved

  def self.expire(*args)
    RAILS_DEFAULT_LOGGER.info("Observist: expiring cache")
    Rails.cache.delete_matched(//) rescue nil
  end

  def expire(*args)
    self.class.expire
  end

  alias_method :after_save,    :expire
  alias_method :after_destroy, :expire
end
