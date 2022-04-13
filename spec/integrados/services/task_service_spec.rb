require 'rails_helper'

RSpec.describe 'TaskService', type: :service do
  
  before do
    @task_service = TaskService.new

    @project = Project.new(title: 'Novo projeto')
    @project.save

    @task = Task.create(title: 'Tarefa', date_start: Time.now, date_end: Time.now + 2.days, project_id: @project.id)
  end


  describe'#change_status' do
    # Pendente -> Encerrada
    # Encerrada -> Pendente
    it "deve trocar status quando o state for nil" do

      # nil -> true
      @task_service.change_status(task_id: @task.id)
      expect(@task.reload.state).to eq(true)
    end

    it "deve trocar status quando o state for false" do

      # false -> true
      @task.update(state: false)
      @task_service.change_status(task_id: @task.id)
      expect(@task.reload.state).to be_truthy
    end

    it 'deve transformar em pendente a tarefa quando for true' do
      @task.update(state: true)
      @task_service.change_status(task_id: @task.id)
      expect(@task.reload.state).to be_falsey
    end
  end

  it 'retorna erro para tarefa não encontrada' do
    expect {
      @task_service.change_status(task_id: 150)
    }.to raise_error(TaskNotFoundException)
  end
end