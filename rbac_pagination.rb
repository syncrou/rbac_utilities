module RBAC
  module Paginate
  def call(obj, method, pagination_options, *method_args)
    Enumerator.new do |enum|
      opts = pagination_options.dup.merge({
        limit: 10, # Integer | Parameter for selecting the amount of data in a page.
        offset: 0 # Integer | Parameter for selecting the page of data.
      })

      count = nil
      fetched = 0
      begin
        loop do
          args = [method_args, opts].flatten.compact
          result = obj.send(method, *args)
          count ||= result.meta.count
          opts[:offset] = opts[:offset] + result.data.count
          result.data.each do |element|
            enum.yield element
          end
          fetched += result.data.count
          break if count == fetched || result.data.empty?
        end
      rescue StandardError => e
        puts "Exception when calling pagination on #{method} #{e}"
        raise
      end
    end
  end
  end
end
