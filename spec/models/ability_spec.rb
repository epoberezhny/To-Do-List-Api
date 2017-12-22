RSpec.describe 'Ability' do
  describe "abilities of loggined user" do
    subject(:ability)   { Ability.new(user) }

    let(:user)          { build_stubbed(:user) }

    let(:project)       { build_stubbed(:project, user: user) }
    let(:other_project) { build_stubbed(:project) }

    let(:task)          { build_stubbed(:task, project: project) }
    let(:other_task)    { build_stubbed(:task, project: other_project) }

    let(:comment)       { build_stubbed(:comment, task: task) }
    let(:other_comment) { build_stubbed(:comment, task: other_task) }

    context 'for projects' do
      it { is_expected.to be_able_to(:manage, project) }

      it { is_expected.not_to be_able_to(:manage, other_project) }
    end

    context 'for tasks' do
      it { is_expected.to be_able_to(:manage, task) }

      it { is_expected.not_to be_able_to(:manage, other_task) }
    end

    context 'for comments' do
      it { is_expected.to be_able_to(:manage, comment) }

      it { is_expected.not_to be_able_to(:manage, other_comment) }
    end
  end
end