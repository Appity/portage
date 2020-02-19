require 'thread'

require 'async/notification'

class Portage::ThreadPool
  # == Constants ============================================================

  SIZE_DEFAULT = 5
  
  # == Extensions ===========================================================
  
  # == Class Methods ========================================================
  
  # == Instance Methods =====================================================
  
  def initialize(reactor: nil, size: nil)
    @reactor = reactor || Async::Task.current.reactor
    size ||= SIZE_DEFAULT

    @queue = Queue.new

    @threads = size.times.map do
      Thread.new do
        Thread.abort_on_exception = true
        
        while ((proc, task) = @queue.pop)
          begin
            result = proc.call
  
          rescue => e
            e
          end
        end
      end
    end
  end

  # Call #task inside the same reactor to define an Async::Task
  def task(**options, &block)
    notification = Async::Notification.new

    task = Async do
      case (result = notification.wait)
      when Exception
        raise result
      else
        result
      end
    end

    @queue << -> do
      task.reactor << Async::Notification::Signal.new([ task.fiber ], block.call)
      task.reactor.wakeup
    end

    task
  end

  def wait
    @threads.count.times do
      @queue << nil
    end

    @threads.each(&:join)
  end
end
