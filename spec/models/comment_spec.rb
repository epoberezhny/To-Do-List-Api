# frozen_string_literal: true

RSpec.describe Comment do
  describe 'associations' do
    describe 'belongs to' do
      it { is_expected.to belong_to(:task).counter_cache(true) }
    end
  end

  describe 'validations' do
    describe 'presence' do
      describe 'text blank' do
        subject(:comment) { build_stubbed(:comment, text: nil) }

        it { is_expected.to validate_presence_of(:attachment) }
      end

      describe 'attachment blank' do
        subject(:comment) { build_stubbed(:comment, attachment: nil) }

        it { is_expected.to validate_presence_of(:text) }
      end
    end
  end
end
