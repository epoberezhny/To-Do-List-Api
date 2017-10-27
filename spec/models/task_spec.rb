RSpec.describe Task, type: :model do
  context 'associations' do
    context 'belongs to' do
      it { is_expected.to belong_to(:project) }
    end

    context 'has many' do
      it { is_expected.to have_many(:comments).dependent(:destroy) }
    end
  end
end
