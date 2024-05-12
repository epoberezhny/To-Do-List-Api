# frozen_string_literal: true

RSpec.shared_examples 'success response' do
  response '200', 'Success' do
    schema(composed_schema)

    run_test!
  end
end

RSpec.shared_examples 'no content response' do
  response '204', 'No content' do
    run_test!
  end
end

RSpec.shared_examples 'created response' do
  response '201', 'Created' do
    schema(composed_schema)
    header 'Location', schema: { type: :string }

    run_test! do
      expect(response.location).to eq(location)
    end
  end
end

RSpec.shared_examples 'bad request response' do
  response '400', 'Bad request' do
    schema('$ref' => '#/components/schemas/errors_schema')

    run_test!
  end
end

RSpec.shared_examples 'unauthorized response' do
  response '401', 'Unauthorized' do
    schema('$ref' => '#/components/schemas/errors_schema')

    before do
      if respond_to?(:Authorization)
        public_send(:Authorization)
        Timecop.travel(30.minutes.after)
      end
    end

    run_test!(timecop: true)
  end
end

RSpec.shared_examples 'forbidden response' do
  response '403', 'Forbidden' do
    run_test!
  end
end

RSpec.shared_examples 'not found response' do
  response '404', 'Not found' do
    run_test!
  end
end

RSpec.shared_examples 'unprocessable response' do
  response '422', 'Unprocessable' do
    schema('$ref' => '#/components/schemas/errors_schema')

    run_test!
  end
end

RSpec.shared_examples 'failed token auth' do
  describe '400' do
    let(:Authorization) { nil }

    include_examples 'bad request response'
  end

  describe '401' do
    include_examples 'unauthorized response'
  end
end
