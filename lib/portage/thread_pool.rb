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
        
        while (proc = @queue.pop)
          proc.call
        end
      end
    end
  end

  def exec(&block)
    @queue << -> do
      block.call
    end
  end

  # Call #task inside the same reactor to define an Async::Task
  def task(annotate: nil, &block)
    notification = Async::Notification.new

    task = Async do |t|
      t.annotate(annotate) if (annotate)

      notification.wait
    end

    @queue << -> do
      result = begin
        block.call(task)

      rescue => e
        e
      end

      @reactor << Async::Notification::Signal.new([ task.fiber ], result)
      @reactor.wakeup
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
