require 'rails_helper'

RSpec.describe 'TaskService', type: :service do
  before do
    @task_service = TaskService.new
    
    @project = Project.new(title: 'Novo Projeto')
    @project.save
    
    @task = Task.create(title: 'Tarefa', date_start: Time.now, date_end: Time.now + 2.days, project_id: @project.id)
  end

  describe '#change_status' do
    context 'Sucesso' do
      it 'Deve concluir a tarefa quando o state for nil' do
        @task_service.change_status(task_id: @task.id)
        expect(@task.reload.state).to eq(true)
      end
  
      it 'Deve concluir a tarefa quando o state for false' do
        @task.update(state: false)
        @task_service.change_status(task_id: @task.id)
        expect(@task.reload.state).to be_truthy
      end
    end
    
    context 'Desmarcar tarefa' do
      it 'Deve transformar a tarefa quando o state for true' do
        @task.update(state: true)
        @task_service.change_status(task_id: @task.id)
        expect(@task.reload.state).to be_falsy
      end
    end

    it 'Deve retornar erro para tarefa não encontrada' do
      expect {
        @task_service.change_status(task_id: 99999)
      }.to raise_error(TaskNotFoundException)
    end

  end
end