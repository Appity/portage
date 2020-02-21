class Portage::Queue::Injector
  # # == Constants ============================================================
  
  # == Extensions ===========================================================
  
  # == Properties ===========================================================

  # == Support Classes ======================================================

  class Operation
    # NOTE: This may be more efficient as a Proc wrapper with Fiber-compatible
    #       methods attached.
    def initialize(task, queue, item)
      @task = task
      @queue = queue
      @item = item
    end

    def alive?
      true
    end

    def resume
      @queue.items << @item
      @queue.signal(task: @task)
    end
  end

  # == Class Methods ========================================================
  
  # == Instance Methods =====================================================
  
  def initialize(queue:, task: nil)
    @queue = queue
    @task = task || Async::Task.current
  end
  
  def <<(item)
    @task.reactor << Operation.new(@task, @queue, item)
    @task.reactor.wakeup
  end
end
