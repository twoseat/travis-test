require 'spec_helper'
require 'tomcat_helper'

describe 'Deploy' do
  include_context 'tomcat_helper'

  it 'expects session data to be stored and retrieved from a single instance',
     fixture: 'server' do
    session_data = 'Session data stored in Tomcat'
    location     = "http://localhost:#{tomcat_metadata[:http_port]}/session"
    response     = RestClient.post location, session_data, content_type: 'text/plain'
    cookies      = response.cookies
    expect(RestClient.get location, cookies: cookies).to eq(session_data)
  end
end
