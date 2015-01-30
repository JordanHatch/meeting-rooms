FactoryGirl.define do

  factory(:event) do
    sequence(:source_id) {|n|
      "calendar-event-#{n}@google.com"
    }
    sequence(:title) {|n|
      "Event #{n}"
    }
    creator "Jed Bartlet"
    start_at { Time.now }
    end_at { Time.now + 30.minutes }
    room
  end

end
