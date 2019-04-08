# load the gem
require 'rbac-api-client'
require 'yaml'
require_relative 'rbac_pagination'
include RBAC::Paginate
require 'byebug'

# setup authorization
RBACApiClient.configure do |config|
  hash  = YAML.load_file('./rbac_config.yml')
  hash.keys.each do |key|
    config.send("#{key}=".to_sym, hash[key])
  end
end

api_instance = RBACApiClient::PolicyApi.new
RBAC::Paginate.call(api_instance, :list_policies, {}).each do |item|
  puts item
end
