# load the gem
require 'rbac-api-client'
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

api_instance = RBACApiClient::PolicyApi.new
policies = RBAC::Paginate.call(api_instance, :list_policies, {})

begin
  #Delete the groups
  policies.each do |policy|
    next unless policy.name.downcase.start_with?('catalog')
    puts "Deleting Policy #{policy.name}"
    api_instance.delete_policy(policy.uuid)
  end
rescue RBACApiClient::ApiError => e
  puts "Exception when calling GroupApi->delete_policy: #{e}"
end
