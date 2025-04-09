require_relative 'base_object'

module Types
  class MissionType < BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :year, Integer, null: false
    field :success, Boolean, null: false
    field :rocket, Types::RocketType, null: true
    field :astronauts, [ Types::AstronautType ], null: true
  end
end
