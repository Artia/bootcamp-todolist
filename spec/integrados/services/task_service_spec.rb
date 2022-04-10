require 'rails_helper'

RSpec.describe 'TaskService', type: :service do
  before do
    @task_service = TaskService.new
    @project = Project.new(title: 'Novo Projeto')
    @project.save
    @task = Task.new(title: 'Nova tarefa', date_start: Time.now, date_end: Time.now + 2.days, project_id: @project.id)
    @task.save
  end

  describe '#create' do
  end

  describe '#update' do
  end

  describe '#destroy' do
  end

  describe '#change_status' do
    it "deve atualizar o state da tarefa para concluido quando entrada é nil" do
      @task_service.change_status(task_id: @task.id)
      expect(@task.reload.state).to eq(true)
    end

    it "deve atualizar o state da tarefa para concluido quando entrada é false" do
      @task.update(state: false)
      @task_service.change_status(task_id: @task.id)
      expect(@task.reload.state).to be_truthy
    end

    it "deve atualizar o state da tarefa para pendente quando entrada é true" do
      @task.update(state: true)
      @task_service.change_status(task_id: @task.id)
      expect(@task.reload.state).to be_falsy
    end

    it 'retorna erro quando não encontra a tarefa' do
      expect { @task_service.change_status(task_id: -1) }.to raise_error(TaskNotFoundException)
    end
  end
end