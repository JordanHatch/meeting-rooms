class Gap
  include Comparable

  def initialize(start_at:, end_at:)
    @start_at = start_at
    @end_at = end_at
  end

  attr_reader :start_at, :end_at

  def <=>(other)
    start_at.to_i <=> other.start_at.to_i &&
      end_at.to_i <=> other.end_at.to_i
  end

  def title
    'Not in use'
  end
end
