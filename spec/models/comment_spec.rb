RSpec.describe Comment, type: :model do
  context 'associations' do
    context 'belongs to' do
      it { is_expected.to belong_to(:task).counter_cache(true) }
    end
  end

  context 'validations' do
    context 'presence' do
      context 'text blank' do
        subject(:comment) { build_stubbed(:comment, text: nil) }

        it { is_expected.to validate_presence_of(:attachment) }
      end

      context 'attachment blank' do
        subject(:comment) { build_stubbed(:comment, attachment: nil) }
        
        it { is_expected.to validate_presence_of(:text) }
      end 
    end
  end

  context 'columns' do
    it { is_expected.to have_db_column(:attachment) }
  end
end
