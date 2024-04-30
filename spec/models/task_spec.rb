# frozen_string_literal: true

RSpec.describe Task do
  describe 'associations' do
    describe 'belongs to' do
      it { is_expected.to belong_to(:project) }
    end

    describe 'has many' do
      it { is_expected.to have_many(:comments).dependent(:destroy) }
    end
  end

  describe 'validations' do
    describe 'presence' do
      it { is_expected.to validate_presence_of(:name) }
    end
  end

  describe 'columns' do
    it { is_expected.to have_db_column(:comments_count) }
  end
end
