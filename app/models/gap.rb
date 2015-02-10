class Gap
  include Comparable

  def initialize(start_at:, end_at:)
    @start_at = start_at
    @end_at = end_at
  end

  attr_reader :start_at, :end_at
  
  def <=>(other)
    start_at <=> other.start_at &&
      end_at <=> other.end_at
  end

  def title
    'Not in use'
  end
end
