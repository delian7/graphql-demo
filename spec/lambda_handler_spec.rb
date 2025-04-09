require 'json'
require_relative '../lambda_function'

RSpec.describe 'lambda_handler' do
  let(:context) { {} }

  describe 'when invoked with a valid GET event' do
    subject(:response) { lambda_handler(event: event, context: context) }

    let(:dummy_missions) { [{ 'id' => '1', 'name' => 'Apollo', 'success' => true }] }
    let(:event) { { 'httpMethod' => 'GET', 'message' => 'Hello, world!' } }

    before do
      allow_any_instance_of(Object).to receive(:fetch_missions).and_return(dummy_missions)
    end

    it 'returns a status code of 200' do
      expect(response['statusCode']).to eq(200)
    end

    it 'returns a body that is valid JSON' do
      expect(response).to include('body')
      expect { JSON.parse(response['body']) }.not_to raise_error
    end

    it 'returns the dummy missions in the body' do
      body = JSON.parse(response['body'])
      expect(body).to eq(dummy_missions)
    end
  end

  describe 'when invoked with a valid POST event' do
    subject(:response) { lambda_handler(event: event, context: context) }

    let(:graphql_query) { "{ missions { id name success } }" }
    let(:dummy_result) { { 'data' => { 'missions' => [] } } }
    let(:event) do
      {
        'httpMethod' => 'POST',
        'body' => JSON.generate({
          query: graphql_query,
          variables: {},
          operationName: nil
        })
      }
    end

    before do
      dummy = dummy_result
      stub_const("Schema", Class.new do
        define_singleton_method(:execute) do |_query, variables:, context:, operation_name:|
          dummy
        end
      end)
    end

    it 'returns a status code of 200' do
      expect(response['statusCode']).to eq(200)
    end

    it 'returns a valid JSON body' do
      expect(response).to include('body')
      expect { JSON.parse(response['body']) }.not_to raise_error
    end

    it 'returns the dummy GraphQL result in the body' do
      body = JSON.parse(response['body'])
      expect(body).to eq(dummy_result)
    end
  end

  describe 'when invoked with an invalid event' do
    subject(:response) { lambda_handler(event: event, context: context) }

    let(:event) { { 'invalid_key' => 'unexpected data' } }

    it 'returns a status code of 405' do
      expect(response).to include('statusCode')
      expect(response['statusCode']).to eq(405)
    end

    it 'returns a body containing an error message' do
      body = JSON.parse(response['body'])
      expect(body).to include('error')
    end
  end

  describe 'when an exception is raised' do
    subject(:response) { lambda_handler(event: event, context: context) }

    let(:event) { nil }

    it 'returns a status code of 405' do
      expect(response).to include('statusCode')
      expect(response['statusCode']).to eq(405)
    end

    it 'returns a body with error details' do
      body = JSON.parse(response['body'])
      expect(body).to include('error')
    end
  end
end