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

opts = {
  limit: 10, # Integer | Parameter for selecting the amount of data in a page.
  offset: 0, # Integer | Parameter for selecting the page of data.
}
api_instance = RBACApiClient::RoleApi.new

begin
  #List the roles for a tenant
  result = RBAC::Paginate.call(api_instance, :list_roles, opts).to_a
  result.each do |role|
    puts api_instance.get_role(role.uuid)
  end
  puts "Found #{result.count} roles"
rescue RBACApiClient::ApiError => e
  puts "Exception when calling RoleApi->list_roles: #{e}"
end
