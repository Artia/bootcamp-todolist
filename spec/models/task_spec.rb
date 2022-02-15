
require 'rails_helper'

RSpec.describe 'Task', type: :model do
  before do
    @task = Task.new
  end

  describe 'validates' do
    context 'título' do
      it 'não é válida sem título' do
        expect(@task).to_not be_valid
      end

      it 'título não pode ultrapassar 255 caracteres' do
        title = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged"
        @task.title = title
        
        @task.valid?
        #https://apidock.com/rails/v6.1.3.1/ActiveModel/Errors/added%3F
        expect(@task.errors.added?(:title, :too_long, count: 255)).to eq(true)
      end
    end

    context 'datas' do
      it 'não é válida sem data de início' do
        @task.valid?
        expect(@task.errors.added?(:date_start, :blank)).to eq(true)
      end
  
      it 'não é válida sem data de término' do
        @task.valid?
        expect(@task.errors.messages[:date_end]).to include("can't be blank")
      end

      it 'data de início não pode ser maior que a data de fim' do
        @task.date_start = Time.now
        @task.date_end = Time.now - 1.day

        @task.valid?
        expect(@task.errors.added?(:date_start, 'cannot be greater than the end date')).to eq(true)
      end
    end

    context 'tarefa válida' do
      before do
        project = Project.create(title: 'Projeto1')

        @task.title = "Tarefa válida"
        @task.project_id = project.id
        @task.date_start = Time.now
        @task.date_end = Time.now + 2.days
      end

      it 'tarefa é válida com título, datas e projeto' do
        expect(@task).to be_valid
      end
    end
  end

  describe 'human_state' do
    it 'retorna Pending para tarefa pendente (state: nil)' do
      @task.state = nil
      expect(@task.human_state).to eq('Pending')
    end

    it 'retorna Pending para tarefa pendente (state: 0)' do
      @task.state = 0
      expect(@task.human_state).to eq('Pending')
    end

    it 'retorna Concluded para tarefa encerrada (state: 1)' do
      @task.state = 1
      expect(@task.human_state).to eq('Concluded')
    end
  end
end