RSpec.describe Comment, type: :model do
  context 'associations' do
    context 'belongs to' do
      it { is_expected.to belong_to(:task).counter_cache(true) }
    end
  end

  # context 'validations' do
  #   context 'presence' do
  #     it { is_expected.to validate_presence_of(:text) }      
  #   end
  # end

  context 'columns' do
    it { is_expected.to have_db_column(:attachment) }
  end
end
