require 'rest_client'

describe 'Deploy' do

  let(:tomcat_version) { '7.0.50' }

  before do
    response = RestClient.get "http://mirror.gopotato.co.uk/apache/tomcat/tomcat-7/v#{tomcat_version}/bin/apache-tomcat-#{tomcat_version}.tar.gz"
    File.open("/tmp/apache-tomcat-#{tomcat_version}.tar.gz", 'w').write response
    system "tar zxf /tmp/apache-tomcat-#{tomcat_version}.tar.gz -C /tmp"
  end

  it ' expects a /bin/catalina.sh file ' do
    expect(File).to exist("/tmp/apache-tomcat-#{tomcat_version}/bin/catalina.sh")
  end

  after do
    FileUtils.rm_r "/tmp/apache-tomcat-#{tomcat_version}"
    FileUtils.rm_r "/tmp/apache-tomcat-#{tomcat_version}.tar.gz"
  end

end
