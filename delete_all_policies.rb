require_relative 'setup'

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
