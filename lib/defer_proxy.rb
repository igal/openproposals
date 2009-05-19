# = DeferProxy
#
# Creates a proxy object with a callback so that it's content can be lazy loaded when needed.
#
# = Examples
#   # Create an array using DeferProxy instance or the Defer helper:
#   @array = DeferProxy.new { p "zzzz"; sleep 1; p "yawn"; [1,2,3] }
#   @array = Defer { p "zzzz"; sleep 1; p "yawn"; [1,2,3] }
#
#   # Access the proxy the first time, it will execute the slow block and return results
#   @array.size
#
#   # Access the proxy again, it will instantly return cached results
#   @array.size
class DeferProxy
  raise LoadError, "Can't find Object#logit" unless self.respond_to?(:logit)

  attr_accessor :__called
  attr_accessor :__callback
  attr_accessor :__value

  def initialize(&block)
    @__callback = block
  end

  def method_missing(method, *args, &block)
    unless @__called
      logit "called by #{method}"
      @__value = @__callback.call
      @__called = true
    end
    return @__value.send(method, *args, &block)
  end
end

# Return a DeferProxy instance for the given +block+.
def Defer(&block)
  return DeferProxy.new(&block)
end

__END__

# Test
load 'lib/defer_proxy.rb'
x = Defer { [1,2,3] }
x.each{|v| p v}
