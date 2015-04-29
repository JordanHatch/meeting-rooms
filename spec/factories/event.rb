FactoryGirl.define do

  factory(:event) do
    sequence(:source_id) {|n|
      "calendar-event-#{n}@google.com"
    }
    sequence(:title) {|n|
      "Event #{n}"
    }
    creator "Jed Bartlet"
    start_at { Time.now + 10.minutes }
    end_at { Time.now + 30.minutes }
    private false

    room

    trait :current do
      start_at { Time.now }
      end_at { 30.minutes.from_now }
    end

    trait :past do
      start_at { 1.hour.ago }
      end_at { 30.minutes.ago }
    end

    trait :future do
      start_at { 30.minutes.from_now }
      end_at { 1.hour.from_now }
    end

    factory :current_event, traits: [:current]
    factory :past_event, traits: [:past]
    factory :future_event, traits: [:future]
  end

end
