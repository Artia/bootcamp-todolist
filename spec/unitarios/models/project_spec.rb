require 'rails_helper'

# DESAFIO
RSpec.describe Project, type: :model do
  describe 'associações' do
    it { is_expected.to have_many(:tasks) }
  end

  describe 'fromated_percentage' do
    before do
      @project = Project.new
    end

    it 'Deve formatar o número' do
      
    end
  end
end