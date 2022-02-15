
require 'rails_helper'

RSpec.describe 'ProjectService', type: :model do
  before do
    @project_service = ProjectService.new
    @project_id = 1
  end

  describe '#completed_percent' do
    it 'projeto sem atividades' do
      expect(@project_service.completed_percent(project_id: @project_id)).to eq(0)
    end

    it 'projeto com 1 atividade pendente' do
      expect(@project_service.completed_percent(project_id: 1)).to eq(0)
    end

    it 'projeto com 1 atividade encerrada' do
      expect(@project_service.completed_percent(project_id: 1)).to eq(100)
    end

    it 'projeto com atividade(s) pendente(s) e encerrada(s)' do
      expect(@project_service.completed_percent(project_id: 1)).to eq('100')
    end
  end
end