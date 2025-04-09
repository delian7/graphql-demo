module Types
  class QueryType < BaseObject
    field :missions, [ MissionType ], null: false do
      argument :success, Boolean, required: false
    end

    def missions(success: nil)
      require_relative '../resolvers/mission_resolver'
      Resolvers::MissionResolver.new.fetch_all
    end
  end
end
