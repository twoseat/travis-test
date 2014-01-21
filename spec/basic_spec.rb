require 'spec_helper'
require 'tomcat_helper'

describe 'Deploy' do
  include_context 'tomcat_helper'

  it 'expects a bin/catalina.sh file' do
    expect(tmp_dir + 'bin/catalina.sh').to exist
  end
end
