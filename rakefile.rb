require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new

require 'rubocop/rake_task'
Rubocop::RakeTask.new

require 'rake/clean'
CLOBBER.include 'test-application/target', 'vendor'

file 'test-application/target/application.war' =>
         FileList['test-application/src/main/java/**/*.java', 'test-application/pom.xml'] do
  Dir.chdir('test-application') { system 'mvn package' }
end

require 'fileutils'
require 'rest_client'
file 'vendor/tomcat.tar.gz' do |f|
  tomcat_version = '7.0.50'
  tomcat_url     = "http://mirror.gopotato.co.uk/apache/tomcat/tomcat-7/v#{tomcat_version}/bin/apache-tomcat-#{tomcat_version}.tar.gz"

  cache_file = Pathname.new(f.name)
  FileUtils.makedirs cache_file.parent unless cache_file.parent.exist?
  cache_file.write(RestClient.get(tomcat_url)) unless cache_file.exist?
end

task spec: %w(test-application/target/application.war vendor/tomcat.tar.gz)
task warfile: 'test-application/target/application.war'
task default: [:rubocop, :spec]
