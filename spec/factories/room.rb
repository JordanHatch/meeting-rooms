FactoryGirl.define do

  factory(:room) do
    sequence(:title) {|n|
      "Meeting Room #{n}"
    }
    sequence(:short_title)
    sequence(:calendar_id) {|n|
      "calendar-#{n}@google.com"
    }

    trait :in_use do
      after(:create) do |room|
        create(:current_event, room: room)
      end
    end

    factory :room_in_use, traits: [:in_use]
  end

end
