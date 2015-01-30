FactoryGirl.define do

  factory(:room) do
    sequence(:title) {|n|
      "Meeting Room #{n}"
    }
    sequence(:short_title)
    sequence(:calendar_id) {|n|
      "calendar-#{n}@google.com"
    }
  end

end
