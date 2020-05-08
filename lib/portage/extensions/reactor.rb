module Portage::Extensions::Reactor
  def wakeup
    @selector.wakeup if (defined?(@selector) and @selector)
  end
end
