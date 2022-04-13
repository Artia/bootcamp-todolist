require 'rails_helper'

# DESAFIO
RSpec.describe Project, type: :model do
  describe 'associações' do
    it { is_expected.to have_many(:tasks) }
  end

  describe 'fromated_percentage' do
    it 'Deve formatar o número com %' do
      project = Project.create(title: 'Projeto teste')
      project.stub(completed_percent: 50)

      expect(project.formated_percentage).to eq('50.0%')
    end
  end
end