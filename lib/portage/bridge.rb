require 'async/queue'

class Portage::Bridge
  # == Constants ============================================================
  
  # == Extensions ===========================================================
  
  # == Properties ===========================================================

  attr_reader :reactor

  # == Class Methods ========================================================
  
  # == Instance Methods =====================================================
  
  def initialize(task: nil)
    task ||= Async::Task.current
    @reactor = task.reactor
  end

  def async(&block)
    if (Async::Task.current?)
      Async do
        yield
      end
    else
      queue = Queue.new

      @reactor << Operation.new do
        queue << Async do |task|
          block.call(task)
        end.wait
      end

      @reactor.wakeup

      queue.pop
    end
  end
end

require_relative 'bridge/operation'
