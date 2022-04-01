
require 'rails_helper'

RSpec.describe 'TaskService', type: :model do
  let(:project) { Project.create(title: 'Integração') }
  let(:task) { Task.create(title: "Task 1", date_start: Time.now, date_end: Time.now + 2.days, project_id: project.id) }

  before do
    @task_service = TaskService.new
  end

  describe '#create' do
    before do
      params = { title: "Levantamento de Requisitos", date_start: "2022-02-15T18:00", date_end: "2022-02-16T18:00", state: "1" } 
      @task = @task_service.create(params, project: project)
    end

    it 'valida os atributos da tarefa criada' do
      expect(@task).to have_attributes(
        id: be_a_kind_of(Integer),
        date_start: Time.zone.parse('2022-02-15 18:00'), 
        date_end: Time.zone.parse('2022-02-16 18:00'),
        state: true,
        project_id: project.id
      )
    end
  end

  describe '#update' do
    before do
      @params = { title: "Desenvolvendo Testes", date_start: "2022-03-08T08:00", date_end: "2022-03-09T12:00", state: "1" } 
    end

    context 'sucesso' do
      before do
        @task = @task_service.update(@params, task_id: task.id)
      end

      # DESAFIO
      it 'valida os atributos da tarefa atualizada' do
        expect(task.reload).to have_attributes(
          date_start: Time.zone.parse('2022-03-08 08:00'), 
          date_end: Time.zone.parse('2022-03-09 12:00'),
          state: true,
          project_id: project.id
        )
      end
    end

    context 'erro' do
      it 'tarefa não encontrada' do
        expect { 
          @task_service.update(@params, task_id: 9999999) 
        }.to raise_error(TaskNotFoundException)
      end
    end
  end

  describe '#destroy' do
    context 'sucesso' do
      it "deve apagar a tarefa" do
        @task_service.destroy(task_id: task.id, project_id: task.project_id)
        expect(Task.where(id: task.id).present?).to eq(false)
      end
    end

    # DESAFIO
    context 'erro' do
      it 'tarefa não encontrada' do
        expect { 
          @task_service.destroy(task_id: 9999999, project_id: task.project_id)
        }.to raise_error(TaskNotFoundException)
      end
    end
  end

  describe '#change_status' do
    context 'sucesso' do
      it 'deve encerrar a tarefa' do
        @task_service.change_status(task_id: task.id)
        expect(task.reload.state).to eq(true)
      end
  
      it 'deve reabrir a tarefa' do
        task.update(state: 1)
        @task_service.change_status(task_id: task.id)
        expect(task.reload.state).to eq(false)
      end
    end

    # DESAFIO
    context 'erro' do
      it 'tarefa não encontrada' do
        expect { 
          @task_service.change_status(task_id: 9999999)
        }.to raise_error(TaskNotFoundException)
      end
    end
  end
end