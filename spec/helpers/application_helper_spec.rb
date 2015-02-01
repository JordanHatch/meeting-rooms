require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do

  describe '#app_title' do
    it 'returns the value of the APP_TITLE environment variable' do
      expect(ENV).to receive(:[]).with('APP_TITLE').and_return('Foo')

      expect(helper.app_title).to eq('Foo')
    end

    it 'returns a default when the environment variable is missing' do
      expect(ENV).to receive(:[]).with('APP_TITLE').and_return(nil)

      expect(helper.app_title).to eq('Meeting Rooms')
    end
  end

end
