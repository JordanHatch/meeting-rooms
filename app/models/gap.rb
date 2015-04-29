class Gap
  include Comparable

  def initialize(start_at:, end_at:, title: nil)
    @start_at = start_at
    @end_at = end_at
    @title = title
  end

  attr_reader :start_at, :end_at, :title

  def <=>(other)
    start_at.to_i <=> other.start_at.to_i &&
      end_at.to_i <=> other.end_at.to_i
  end

  def private?
    false
  end

  def status
    :available
  end
end
