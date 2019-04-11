require_relative 'setup'
username = ARGV[0]
group_name = ARGV[1]
if username.nil? || group_name.nil?
  puts "Requires a username and group name argument"
  puts "ruby ./delete_principal_from_group.rb 'username@blah.com' 'Group Name'"
  exit
end

api_instance = RBACApiClient::GroupApi.new
groups = RBAC::Paginate.call(api_instance, :list_groups, {:name => group_name})

begin
  if groups.count > 1
    puts "Found more than one group exiting..."
    exit
  end
  #Delete the principal from the specific passed in group
  groups.each do |group|
    next unless group.name.downcase.start_with?('catalog')
    puts "Deleting principal #{username} from group #{group.name} "
    api_instance.delete_principal_from_group(group.uuid, username)
  end
rescue RBACApiClient::ApiError => e
  puts "Exception when calling GroupApi->delete_group: #{e}"
end
