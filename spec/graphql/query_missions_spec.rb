require 'spec_helper'
require_relative '../../app'

RSpec.describe 'GraphQL Query: missions', type: :request do
  include Rack::Test::Methods

  def app
    App
  end

  let(:query) do
    <<~GQL
      {
        missions {
          id
          name
          success
        }
      }
    GQL
  end

  it 'returns a list of missions' do
    allow(Resolvers::MissionResolver).to receive(:fetch_all).and_return([
      { 'id' => 'm-001', 'name' => 'Apollo 11', 'success' => true }
    ])

    post '/graphql', { query: query }.to_json, { "CONTENT_TYPE" => "application/json" }

    expect(last_response.status).to eq(200)

    data = JSON.parse(last_response.body)["data"]["missions"]
    expect(data).to be_an(Array)
    expect(data.first["name"]).to eq("Apollo 11")
  end
end
