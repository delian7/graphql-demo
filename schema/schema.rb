require_relative 'query_type'
require_relative 'mutation_type'

class Schema < GraphQL::Schema
  query Types::QueryType
  mutation Types::MutationType
end
