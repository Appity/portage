class Portage::Bridge::Operation
  # == Constants ============================================================
  
  # == Extensions ===========================================================
  
  # == Properties ===========================================================

  # == Class Methods ========================================================
  
  # == Instance Methods =====================================================

  # NOTE: This may be more efficient as a Proc wrapper with Fiber-compatible
  #       methods attached.
  def initialize(&block)
    @block = block
  end

  def alive?
    true
  end

  def resume
    Async do
      @block.call
    end
  end
end
