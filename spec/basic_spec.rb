require 'spec_helper'
require 'tomcat_helper'

describe 'Deploy' do
  include_context 'tomcat_helper'

  it 'expects a bin/catalina.sh file for Tomcat',
     fixture: 'server' do
    tomcat_metadatas.each { |tomcat_metadata| expect(tomcat_metadata[:location] + 'bin/catalina.sh').to exist }
  end

end
