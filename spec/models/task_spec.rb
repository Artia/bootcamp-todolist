
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
        expect(@task).to_not be_valid
      end
    end

    context 'datas' do
      it 'não é válida sem data de início' do
      end
  
      it 'não é válida sem data de término' do
      end

      it 'data de início não pode ser maior que a data de fim' do
      end
    end
  end

  describe 'human_state' do
    it 'retorna Pending para tarefa pendente' do
      
    end

    it 'retorna Concluded para tarefa encerrada' do
      
    end
  end
end