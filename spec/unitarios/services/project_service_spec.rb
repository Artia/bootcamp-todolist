
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
      allow(Task).to receive_message_chain(:select, :where, :first) { double('Task', total_tasks: 1, tasks_concluded: 0) }
      expect(@project_service.completed_percent(project_id: 1)).to eq(0)
    end

    it 'projeto com 1 atividade encerrada' do
      allow(Task).to receive_message_chain(:select, :where, :first) { double('Task', total_tasks: 1, tasks_concluded: 1) }
      expect(@project_service.completed_percent(project_id: 1)).to eq(100)
    end

    it 'projeto com 2 atividade(s) pendente(s) e 2 encerrada(s)' do
      allow(Task).to receive_message_chain(:select, :where, :first) { double('Task', total_tasks: 4, tasks_concluded: 2) }
      expect(@project_service.completed_percent(project_id: 1)).to eq(50)
    end

    it 'projeto com 6 atividade(s) pendente(s) e 1 encerrada(s)' do
      #allow(Task).to receive_message_chain(:select, :where, :first) { double('Task', total_tasks: 7, tasks_concluded: 1) }
      allow(@project_service).to receive(:info_tasks).with(project_id: @project_id).and_return(double('Task', total_tasks: 7, tasks_concluded: 1))
      expect(@project_service.completed_percent(project_id: 1).round(2)).to eq(14.29)
    end
  end
end