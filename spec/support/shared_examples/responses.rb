# frozen_string_literal: true

RSpec.shared_examples 'successful response' do
  it 'returns a success response' do
    expect(response).to be_successful
  end
end

RSpec.shared_examples 'unauthorized response' do
  it 'returns a unauthorized response' do
    expect(response).to be_unauthorized
  end
end

RSpec.shared_examples 'unprocessable response' do
  it 'returns a unprocessable response' do
    expect(response).to be_unprocessable
  end
end

RSpec.shared_examples 'not found response' do
  it 'returns a not_found response' do
    expect(response).to be_not_found
  end
end

RSpec.shared_examples 'created response' do
  it 'returns a created response' do
    expect(response).to be_created
    expect(response.location).to eq(location)
  end
end

RSpec.shared_examples 'json response' do
  it 'returns a json response' do
    expect(response.content_type).to eq('application/json')
  end
end

RSpec.shared_examples 'forbidden response' do
  it 'returns a forbidden response' do
    expect(response).to be_forbidden
  end
end

RSpec.shared_examples 'match schema' do |schema|
  it { expect(response).to match_response_schema(schema) }
end
