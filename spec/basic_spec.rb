require 'rest_client'
require 'tmpdir'

describe 'Deploy' do

  let(:tomcat_version) { '7.0.50' }
  let(:tmp_dir_name) { Dir.mktmpdir }

  before do
    unless File.exist?("vendor/apache-tomcat-#{tomcat_version}.tar.gz")
      response = RestClient.get "http://mirror.gopotato.co.uk/apache/tomcat/tomcat-7/v#{tomcat_version}/bin/apache-tomcat-#{tomcat_version}.tar.gz"
      File.open("vendor/apache-tomcat-#{tomcat_version}.tar.gz", 'w').write response
    end
  end

  before do
    system "tar zxf vendor/apache-tomcat-#{tomcat_version}.tar.gz -C #{tmp_dir_name}"
  end

  it ' expects a /bin/catalina.sh file ' do
    expect(File).to exist("#{tmp_dir_name}/apache-tomcat-#{tomcat_version}/bin/catalina.sh")
  end

  after do
    FileUtils.rm_r "#{tmp_dir_name}"
  end
end
