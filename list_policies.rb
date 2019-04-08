require_relative 'setup'

api_instance = RBACApiClient::PolicyApi.new
RBAC::Paginate.call(api_instance, :list_policies, {}).each do |item|
  puts item
end
