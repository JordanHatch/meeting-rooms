FactoryGirl.define do

  factory(:room) do
    sequence(:title) {|n|
      "Meeting Room #{n}"
    }
    sequence(:short_title)
  end

end
