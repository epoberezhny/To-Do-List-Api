RSpec.describe Project, type: :model do
  context 'associations' do
    context 'belongs to' do
      it { is_expected.to belong_to(:user) }
    end

    context 'has many' do
      it { is_expected.to have_many(:tasks).dependent(:destroy) }
    end
  end

  context 'validations' do
    context 'presence' do
      it { is_expected.to validate_presence_of(:name) }      
    end
    
    context 'uniqueness' do
      it { is_expected.to validate_uniqueness_of(:name).scoped_to(:user_id) }      
    end
  end
end
