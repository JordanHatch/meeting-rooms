require 'rails_helper'

RSpec.describe CalendarApi do

  let(:mock_api_client) { double("ApiClient", discovered_api: double('Google::APIClient::API').as_null_object) }
  let(:mock_signing_key) { double("SigningKey") }

  describe '#client' do
    it 'builds an instance of the Google API client' do
      allow(Google::APIClient).to receive(:new).and_return(mock_api_client)

      # We're stubbing the key loading here as it's over-complex to try building
      # our own PKCS12 key as part of these tests.
      #
      expect(Google::APIClient::KeyUtils).to receive(:load_from_pkcs12).with(
        'a key', 'notasecret'
      ).and_return(mock_signing_key)

      expect(mock_api_client).to receive(:authorization=) do |arg|
        expect(arg.issuer).to eq('foobar_issuer_id')
        expect(arg.signing_key).to eq(mock_signing_key)
      end
      expect(mock_api_client).to receive(:authorization).and_return(
        double(:fetch_access_token! => true)
      )

      service = CalendarApi.new(
        signing_key: Base64.encode64('a key'),
        issuer: 'foobar_issuer_id'
      )
      service.client
    end

    it 'raises an exception if signing_key or issuer are missing' do
      service = CalendarApi.new(signing_key: nil, issuer: nil)

      expect{ service.client }.to raise_error(ArgumentError)
    end
  end

  describe '#execute' do
    it 'delegates to the client' do
      expect(mock_api_client).to receive(:execute).with('foo')

      service = CalendarApi.new(client: mock_api_client)
      service.execute('foo')
    end
  end

  describe '#events' do
    it 'requests a list of events for a given calendar' do
      expect(mock_api_client).to receive(:execute).with(
        hash_including(parameters: {
          'calendarId' => 'example',
          'orderBy' => 'startTime',
          'timeMin' => '2015-01-01T00:00:00+00:00',
          'timeMax' => '2015-01-02T00:00:00+00:00', # 24 hours after the frozen time
          'singleEvents' => true,
        })
      ).and_return(
        OpenStruct.new(
          data: OpenStruct.new(
            items: ['one', 'two', 'three']
          )
        )
      )

      Timecop.freeze(Time.parse('2015-01-01 00:00:00 +00:00')) do
        service = CalendarApi.new(client: mock_api_client)
        events = service.events(calendar_id: 'example')
      end
    end
  end

end
