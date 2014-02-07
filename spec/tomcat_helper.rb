require 'format_duration'
require 'pathname'
require 'rest_client'
require 'tmpdir'

shared_context 'tomcat_helper' do

  let(:tomcat_metadata) { { location: Pathname.new(Dir.mktmpdir), http_port: 8081, shutdown_port: 8001 } }

  let(:cache_file) { Pathname.new('vendor/tomcat.tar.gz') }

  before do |example|
    with_timing('Starting Tomcat...') do
      untar_tomcat tomcat_metadata[:location]
      replace_server_xml example.metadata[:fixture], tomcat_metadata[:location]
      deploy_war tomcat_metadata[:location]
      start_tomcat tomcat_metadata[:location], tomcat_metadata[:shutdown_port], tomcat_metadata[:http_port]
    end
  end

  after do
    with_timing('Stopping Tomcat...') do
      stop_tomcat tomcat_metadata[:location], tomcat_metadata[:shutdown_port]
      tomcat_metadata[:location].rmtree
    end
  end

  def replace_server_xml(server_xml, dir)
    FileUtils.copy "spec/fixtures/#{server_xml}.xml", "#{dir}/conf/server.xml"
  end

  def start_tomcat(dir, shutdown_port, http_port)
    `JAVA_OPTS=\"-Dshutdown.port=#{shutdown_port} -Dhttp.port=#{http_port}\" #{dir}/bin/catalina.sh start`
    wait_for_start(http_port)
  end

  def stop_tomcat(dir, shutdown_port)
    `JAVA_OPTS=\"-Dshutdown.port=#{shutdown_port}\" #{dir}/bin/catalina.sh stop`
  end

  def untar_tomcat(dir)
    `tar zxf #{cache_file} --strip 1 --exclude \'webapps\' -C #{dir}`
  end

  def deploy_war(dir)
    FileUtils.makedirs "#{dir}/webapps" unless Dir.exist? "#{dir}/webapps"
    FileUtils.copy 'test-application/target/application.war', "#{dir}/webapps/ROOT.war"
  end

  def wait_for_start(http_port)
    response = nil
    until response && response.body == 'ok'
      response = RestClient.get "http://localhost:#{http_port}"
    end
  rescue Errno::ECONNREFUSED
    retry
  end

  def with_timing(caption)
    start_time = Time.now
    print "#{caption} "

    yield

    puts "(#{(Time.now - start_time).duration})"
  end

end
