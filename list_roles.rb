require_relative 'setup'

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
