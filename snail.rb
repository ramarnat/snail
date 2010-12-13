#!/usr/bin/env ruby

# first, check required files so any user gets instant notification that something is wrong
CONFIG_FILE = "config/snail.yml"
def abort(msg); puts msg; exit(1); end
abort('Could not find config/snail.yml file.') if !File.exists?(CONFIG_FILE)

require 'rubygems'
# make sure we're using the right version of gems
gem 'sinatra', :version => '0.9.4'
gem 'right_aws', :version =>'1.10.0'
require 'sinatra'
require 'right_aws'
require 'yaml'
require 'ruby-debug'
require 'fog'
require 'json'
require 'pp'
require 'chef'


# load all files in lib
Dir["lib/*.rb"].each { |x| load x }
# load actions
Dir["lib/actions/*.rb"].each { |x| load x }

# set s3_config
config_file = YAML.load_file(CONFIG_FILE)
set :config, config_file
set :projects, config_file.keys

before do
  @projects = options.projects
  @project = request.path.split('/')[1]
  config = options.config[@project]
  if config
    @ec2 = RightAws::Ec2.new(config['aws_key'], config['aws_secret'])
    @s3 = RightAws::S3.new(config['aws_key'], config['aws_secret'])
    
    # Fog
    @ec2_compute = Fog::AWS::Compute.new(:aws_access_key_id => config['aws_key'], :aws_secret_access_key => config['aws_secret'])
    Chef::Config.from_file(config['knife_config'])
  else
    redirect '/projects' if @project != 'projects' and !File.exists?("public#{request.path}") and !request.path.include?('__sinatra__')
  end
end

helpers do
  include Helpers
end