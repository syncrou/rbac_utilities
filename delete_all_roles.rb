# load the gem
require 'rbac-api-client'
require 'yaml'
require 'byebug'
require_relative 'rbac_pagination'
include RBAC::Paginate
# setup authorization
RBACApiClient.configure do |config|
  hash  = YAML.load_file('./config.yml')
  hash.keys.each do |key|
    config.send("#{key}=".to_sym, hash[key])
  end
end

api_instance = RBACApiClient::RoleApi.new
roles = RBAC::Paginate.call(api_instance, :list_roles, {})

begin
  roles.each do |role|
    next unless role.name.downcase.start_with?('catalog')
    #Delete a role in the tenant
    puts "Deleting role #{role.name}"
    api_instance.delete_role(role.uuid)
  end
rescue RBACApiClient::ApiError => e
  puts "Exception when calling RoleApi->delete_role: #{e}"
end


