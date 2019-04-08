require_relative 'setup'

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
