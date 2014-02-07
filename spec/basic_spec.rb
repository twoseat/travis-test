require 'spec_helper'
require 'tomcat_helper'

describe 'Deploy' do
  include_context 'tomcat_helper'

  it 'expects a bin/catalina.sh file for Tomcat',
     fixture: 'server' do
    tomcat_metadatas.each { |tomcat_metadata| expect(tomcat_metadata[:location] + 'bin/catalina.sh').to exist }
  end

  it 'expects session data to be stored and retrieved from a single instance',
     fixture: 'server' do
    tomcat_metadatas.each do |tomcat_metadata|
      session_data = 'Session_data_stored_in_' + tomcat_metadata[:name]
      location = "http://localhost:#{tomcat_metadata[:http_port]}/session"
      response = RestClient.post location, session_data
      cookies = response.cookies
      expect(RestClient.get location, {:cookies => cookies}).to eq(session_data + "=")
    end
  end
end
