require_relative 'base_object'

module Types
  class RocketType < BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :manufacturer, String, null: false
  end
end
