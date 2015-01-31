class Event < ActiveRecord::Base
  belongs_to :room

  scope :current, -> {
    where(['start_at < ? AND end_at > ?', Time.now, Time.now])
  }
end
