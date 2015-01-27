require 'google/api_client'

class CalendarApi
  extend Forwardable

  def initialize(client: nil, signing_key: nil, issuer: nil)
    @signing_key = signing_key
    @issuer = issuer
    @client = client
  end

  def events(calendar_id:)
    execute(:api_method => service.events.list, :parameters => {
      'calendarId' => calendar_id,
      'timeMin' => Time.now.to_datetime.to_s,
      'timeMax' => (Time.now + 24.hours).to_datetime.to_s,
      'orderBy' => 'startTime',
      'singleEvents' => true
    }).data.items
  end

  def client
    @client ||= build_client
  end

  def service
    client.discovered_api('calendar', 'v3')
  end

  def_delegators :client, :execute

private
  attr_reader :signing_key, :issuer

  def build_client
    if signing_key.blank? || issuer.blank?
      raise ArgumentError, 'signing_key and issuer must be provided -
        check you have configured your environment variables correctly'
    end

    Google::APIClient.new.tap {|client|
      client.authorization = Signet::OAuth2::Client.new(
        token_credential_uri: 'https://accounts.google.com/o/oauth2/token',
        audience: 'https://accounts.google.com/o/oauth2/token',
        scope: 'https://www.googleapis.com/auth/calendar.readonly',
        issuer: issuer,
        signing_key: loaded_signing_key
      )
      client.authorization.fetch_access_token!
    }
  end

  def decoded_signing_key
    Base64.decode64(signing_key)
  end

  def loaded_signing_key
    Google::APIClient::KeyUtils.load_from_pkcs12(decoded_signing_key, 'notasecret')
  end
end
