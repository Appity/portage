require 'async/condition'
require 'async/task'

class Portage::ThreadTask
  # == Constants ============================================================
  
  # == Extensions ===========================================================
  
  # == Properties ===========================================================
  
  # == Class Methods ========================================================
  
  # == Instance Methods =====================================================

  def initialize(annotate: nil)
    @task = Async do |task|
      if (annotate)
        task.annotation = annotate
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
      end.join

      condition.wait
    end
  end

  def wait
    @task.wait
  end
end
