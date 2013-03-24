require File.join(File.dirname(__FILE__), 'application')

set :run, false
set :environment, :production

FileUtils.mkdir_p 'log' unless File.exists?('log')
log = File.new("log/sinatra.log", "a+")
$stdout.reopen(log)
$stderr.reopen(log)

run Sinatra::Application

module MyConfig

def config
 environment = ENV["RACK_ENV"] || "development"
 YAML.load_file("./config/config.yml")[environment]
end
end