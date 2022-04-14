require 'rails_helper'

RSpec.describe ProjectService, type: :service do
  before :all do
    @project_service = ProjectService.new
    @project_id = 1
  end

  describe 'completed_percent' do
    it 'projeto sem tarefa' do
      allow(Task).to receive_message_chain(:select, :where, :first) { double('Task', total_tasks: 0, task_concluded: 0) }
      expect(@project_service.completed_percent(project_id: @project_id)).to eq(0)
    end 

    it 'projeto só com 1 tarefa pendente' do
      allow(Task).to receive_message_chain(:select, :where, :first) { double('Task', total_tasks: 1, task_concluded: 0) }
      expect(@project_service.completed_percent(project_id: @project_id)).to eq(0)
    end

    it 'projeto só com 1 tarefa concluida' do
      allow(Task).to receive_message_chain(:select, :where, :first) { double('Task', total_tasks: 1, task_concluded: 1) }
      expect(@project_service.completed_percent(project_id: @project_id)).to eq(100)
    end
  end 
end