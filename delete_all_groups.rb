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

api_instance = RBACApiClient::GroupApi.new
groups = RBAC::Paginate.call(api_instance, :list_groups, {})
begin
  #Delete the groups
  groups.each do |group|
    next unless group.name.downcase.start_with?('catalog')
    puts "Deleting group #{group.name}"
    api_instance.delete_group(group.uuid)
  end
rescue RBACApiClient::ApiError => e
  puts "Exception when calling GroupApi->delete_group: #{e}"
end
