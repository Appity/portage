require 'async/condition'
require 'async/task'

module Portage::ThreadTask
  # == Constants ============================================================
  
  # == Extensions ===========================================================
  
  # == Module Methods =======================================================

  def async(parent: nil, annotate: nil, logger: nil)
    parent ||= Async::Task.current
    reactor ||= parent&.reactor

    Async do |task|
      if (annotate)
        task.annotate(annotate)
      end

      condition = Async::Condition.new

      Thread.new do
        result = begin
          yield
        rescue Object => e
          e
        end

        task.reactor << Async::Notification::Signal.new([ task.fiber ], result)
        task.reactor.wakeup
      end

      condition.wait
    end
  end

  extend self
end
