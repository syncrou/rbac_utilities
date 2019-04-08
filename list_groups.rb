# load the gem
require 'rbac-api-client'
require 'yaml'
require 'byebug'
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
  offset: 0 # Integer | Parameter for selecting the page of data.
}

begin
  #List the groups for a tenant
  api_instance = RBACApiClient::GroupApi.new
  uuids = SortedSet.new
  RBAC::Paginate.call(api_instance, :list_groups, opts).each do |group|
    uuids << group.uuid
  end
  puts "Number of groups #{uuids.count}"
  uuids.each do |uuid|
    puts "Fetching group #{uuid}"
    puts api_instance.get_group(uuid)
  end
rescue RBACApiClient::ApiError => e
  puts "Exception when calling GroupApi->list_groups: #{e}"
end
