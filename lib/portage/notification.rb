class Portage::Notification < Async::Condition
  # == Constants ============================================================
  
  # == Extensions ===========================================================
  
  # == Properties ===========================================================
  
  # == Class Methods ========================================================
  
  # == Instance Methods =====================================================
  
  # Signal to a given task that it should resume operations.
  # @return [void]
  def signal(value = nil, task: Task.current)
    @value = value

    return if (@waiting.empty?)
    
    task.reactor << Signal.new(@waiting, value)
    
    @waiting = [ ]
    
    nil
  end

  def wait
    return @value if (defined?(@value))

    super
  end

  Signal = Struct.new(:waiting, :value) do
    def alive?
      true
    end
    
    def resume
      waiting.each do |fiber|
        fiber.resume(value) if fiber.alive?
      end
    end
  end
end
