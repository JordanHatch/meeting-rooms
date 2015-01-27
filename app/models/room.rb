class Room < ActiveRecord::Base
  has_many :events

  validates :title, :short_title, presence: true
end
