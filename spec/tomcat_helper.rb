require 'pathname'
require 'rest_client'
require 'tmpdir'

shared_context 'tomcat_helper' do

  let(:tmp_dir) { Pathname.new(Dir.mktmpdir) }
  let(:tomcat_version) { '7.0.50' }
  let(:cache_file) { Pathname.new("vendor/apache-tomcat-#{tomcat_version}.tar.gz") }
  let(:tomcat_url) { "http://mirror.gopotato.co.uk/apache/tomcat/tomcat-7/v#{tomcat_version}/bin/apache-tomcat-#{tomcat_version}.tar.gz" }

  before do
    unless cache_file.exist?
      response = RestClient.get tomcat_url
      cache_file.write response
    end
  end

  before do
    system "tar zxf #{cache_file} --strip 1 -C #{tmp_dir}"
  end

  after do
    tmp_dir.rmtree
  end
end
