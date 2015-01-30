class Room < ActiveRecord::Base
  has_many :events

  validates :title, :short_title, :calendar_id, presence: true
end
