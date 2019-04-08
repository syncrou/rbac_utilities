# load the gem
require 'bundler/inline'
gemfile do
  source 'https://rubygems.org'
  gem 'rbac-api-client', :git => 'https://github.com/RedHatInsights/insights-rbac-api-client-ruby', :branch => 'master'
  gem 'byebug'
end
require 'byebug'
require 'yaml'
require_relative 'rbac_pagination'
include RBAC::Paginate

# setup authorization
RBACApiClient.configure do |config|
  hash  = YAML.load_file('./rbac_config.yml')
  hash.keys.each do |key|
    config.send("#{key}=".to_sym, hash[key])
  end
end

