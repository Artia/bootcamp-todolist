
require 'rails_helper'

RSpec.describe Task, type: :model do
  let(:task) { Task.new }

  describe 'associação' do
    it { is_expected.to belong_to(:project) }
  end

  describe 'validações' do
    context 'título' do
      it { is_expected.to validate_presence_of(:title) }
      it { is_expected.to validate_length_of(:title).is_at_most(255)  }
    end

    context 'datas' do
      it { is_expected.to validate_presence_of(:date_start) }
      it { is_expected.to validate_presence_of(:date_end) }

      it 'data de início não pode ser maior que a data de fim' do
        task.date_start = Time.now
        task.date_end = Time.now - 1.day

        task.valid?
        expect(task.errors.added?(:date_start, 'cannot be greater than the end date')).to eq(true)
      end
    end

    context 'tarefa válida' do
      before do
        project = Project.new(title: 'Projeto1')
        project.stub(:save).and_return(true)

        task.title = "Tarefa válida"
        task.project = project
        task.date_start = Time.now
        task.date_end = Time.now + 2.days
      end

      it 'tarefa é válida com título, datas e projeto' do
        expect(task).to be_valid
      end
    end
  end

  describe 'human_state' do
    it 'retorna Pending para tarefa pendente (state: nil)' do
      task.state = nil
      expect(task.human_state).to eq('Pending')
    end

    # Desafio
    it 'retorna Pending para tarefa pendente (state: 0)' do
      task.state = 0
      expect(task.human_state).to eq('Pending')
    end
    
    # Desafio
    it 'retorna Concluded para tarefa encerrada (state: 1)' do
      task.state = 1
      expect(task.human_state).to eq('Concluded')
    end
  end
end

