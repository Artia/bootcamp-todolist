require 'rails_helper'

RSpec.describe 'TaskService', type: :service do
  before do
    @task_service ||= TaskService.new 

    @project = Project.new(title: 'novo projeto')
    @project.save 

    @task = Task.create(title: 'Tarefa', date_start: Time.now, date_end: Time.now + 2.days, project_id: @project.id)

  end
  
  describe '#create' do
    it 'deve criar uma tarefa' do
    # nova_task = @task_service.create({"title"=>"teste", "date_start"=>"2022-04-08T09:00", "date_end"=>"2022-04-08T16:00", "state"=>"0"}, @project.id)
    # # expect(nova_task).to be_a_new(Task.create(title: 'teste', date_start: '2022-04-08T09:00', date_end: "2022-04-08T16:00", project_id: @project.id))
    # # expect {@project}.to change(@project, :count).by(2)
    # expect {Task.all}.to change(Task, :count).by(+1)
    # # expect { @nova_task }.to change {@project.tasks.count}.by(1)
    end
  end

  describe '#update' do
  end

  describe '#destroy' do
    it 'deve deletar uma tarefa' do
      # @task_service.destroy(@task.id, @project.id)
      # expect {@project}.to change(Task, :count).by(1)
    end
  end

  describe '#change_status' do
  
    it 'deve concluir a tarefa quando o state for nil' do
      @task_service.change_status(task_id: @task.id)
      expect(@task.reload.state).to eq(true)  
    end

    it 'deve concluir a tarefa quando o state for false' do
      @task.update(state: false)
      @task_service.change_status(task_id: @task.id)
      expect(@task.reload.state).to be_truthy
    end

    it 'deve transformar em pendente a tarefa quando for true' do
      @task.update(state: true)
      @task_service.change_status(task_id: @task.id)
      expect(@task.reload.state).to be_falsy
    end

    it 'retorna erro para a tarefa não encontrada' do
      expect {@task_service.change_status(task_id: 999999)}.to raise_error 
      
    end
  end
end