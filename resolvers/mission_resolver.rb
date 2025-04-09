module Resolvers
  class MissionResolver
    def fetch_all
      missions = fetch_missions  # Call DynamoDB fetch_missions method
      missions.map do |mission|
        {
          id: mission['id'],
          name: mission['name'],
          description: mission['description']
        }
      end
    end
  end
end
