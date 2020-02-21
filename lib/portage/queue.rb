require 'async/queue'

module Portage::Queue
  # == Module Methods =======================================================

  def self.pair(task: nil)
    task ||= Async::Task.current

    queue = Async::Queue.new(parent: task)

    [ Injector.new(task: task, queue: queue), queue ]
  end
end

require_relative 'queue/injector'
