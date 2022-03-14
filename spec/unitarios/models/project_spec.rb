
require 'rails_helper'

RSpec.describe Project, type: :model do
  let(:project) { Project.new }

  describe 'associações' do
    xit { is_expected.to have_many(:tasks).dependent(:destroy) }
  end

  describe 'validações' do
    it 'não é válido sem título' do
      expect(project).to_not be_valid
    end

    it 'título não pode ultrapassar 255 caracteres' do
      project.title = 'a' * 256
      expect(project.valid?).to eq(false)
      expect(project.errors.messages[:title]).to include(/is too long/)
    end
  end
end

