require_relative 'setup'

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


