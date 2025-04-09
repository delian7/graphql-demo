require 'rack'
require 'graphql'
require_relative 'schema/types/base_object'
require_relative 'schema/types/rocket_type'
require_relative 'schema/types/astronaut_type'
require_relative 'schema/types/mission_type'
require_relative './schema/schema'
require_relative 'resolvers/mission_resolver'


class App
  def self.call(env)
    req = Rack::Request.new(env)
    if req.post? || req.get?
      body = req.post? ? JSON.parse(req.body.read) : req.params

      result = Schema.execute(
        body["query"],
        variables: body["variables"],
        context: {},
        operation_name: body["operationName"]
      )

      [ 200, { "Content-Type" => "application/json" }, [ result.to_json ] ]
    else
      [ 405, {}, [ "Method Not Allowed" ] ]
    end
  end
end
