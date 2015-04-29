class Event < ActiveRecord::Base
  belongs_to :room

  scope :current, -> {
    where(['start_at <= ? AND end_at > ?', Time.now, Time.now])
  }
  scope :future, -> {
    where(['start_at > ?', Time.now])
  }
  scope :today, -> {
    where(['start_at >= ? AND end_at <= ?', Time.now.beginning_of_day, Time.now.end_of_day])
  }

  default_scope { order('start_at ASC') }

  validates :start_at, :end_at, presence: true
end
