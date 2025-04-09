require 'ostruct'

module Resolvers
  class MissionResolver
    def self.fetch_all(success: nil)
      missions = [
        OpenStruct.new(
          id: "1",
          name: "Apollo 11",
          year: 1969,
          success: true,
          rocket: OpenStruct.new(id: "r1", name: "Saturn V", manufacturer: "NASA"),
          astronauts: [
            OpenStruct.new(id: "a1", name: "Neil Armstrong", nationality: "USA"),
            OpenStruct.new(id: "a2", name: "Buzz Aldrin", nationality: "USA")
          ]
        ),
        OpenStruct.new(
          id: "2",
          name: "Challenger",
          year: 1986,
          success: false,
          rocket: OpenStruct.new(id: "r2", name: "Space Shuttle", manufacturer: "NASA"),
          astronauts: []
        )
      ]

      return missions if success.nil?
      missions.select { |m| m.success == success }
    end
  end
end
