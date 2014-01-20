require 'rest_client'

describe 'Deploy' do

  let(:tomcat_version) { '7.0.50' }

  before do
    retrieve_tomcat unless File.exist?("vendor/apache-tomcat-#{tomcat_version}.tar.gz")
  end

  before do
    system "tar zxf vendor/apache-tomcat-#{tomcat_version}.tar.gz -C vendor"
  end

  it ' expects a /bin/catalina.sh file ' do
    expect(File).to exist("vendor/apache-tomcat-#{tomcat_version}/bin/catalina.sh")
  end

  after do
    FileUtils.rm_r "vendor/apache-tomcat-#{tomcat_version}"
  end

  def retrieve_tomcat
    response = RestClient.get "http://mirror.gopotato.co.uk/apache/tomcat/tomcat-7/v#{tomcat_version}/bin/apache-tomcat-#{tomcat_version}.tar.gz"
    File.open("vendor/apache-tomcat-#{tomcat_version}.tar.gz", 'w').write response
  end

end
