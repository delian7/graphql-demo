require_relative 'base_object'

module Types
  class AstronautType < BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :nationality, String, null: false
  end
end
