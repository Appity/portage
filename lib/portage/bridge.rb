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
      yield(Async::Task.current)
    else
      queue = Queue.new

      @reactor << Operation.new do
        @reactor.async do |task|
          queue << block.call(task)
        end
      end

      @reactor.wakeup

      queue.pop
    end
  end
end

require_relative 'bridge/operation'
