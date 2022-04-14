require 'rails_helper'

RSpec.describe Task, type: :model do
    let(:task) { Task.new(title: 'Nova Tarefa') }

    describe 'associação' do
        it { is_expected.to belong_to(:project) } 
    end
    
    describe 'validação' do
        describe 'title' do
            it { is_expected.to validate_presence_of(:title) }
            it { is_expected.to validate_length_of(:title).is_at_most(255) }
        end

        describe 'date' do 
            it { is_expected.to validate_presence_of(:date_start) }
            it { is_expected.to validate_presence_of(:date_end) }
    
            it 'não deve aceitar data de inicio maior que data de fim' do
                #setup
                task.date_start = Time.now
                task.date_end = Time.now - 1.day
    
                task.valid?
                
                expect(task.errors.added?(:date_start, 'cannot be greater than the end date')).to eq(true)  
            end
        end

        describe 'human_state' do 
            it 'nil' do
                expect(task.human_state).to eq('Pending')
            end
            
            it 'false' do
                task.stub(state: false)
                expect(task.human_state).to eq('Pending')
            end

            it 'true' do
                task.stub(state: true)
                expect(task.human_state).to eq('Concluded')
            end
        end

        describe 'datas user friendly' do
            it 'date start' do
                task.stub(date_start: '2022-04-09 11:13:00')
                expect(task.human_date_start).to eq('09/04/2022 at 11:13')
            end
            it 'date end' do
                task.stub(date_end: '2022-12-19 13:15:00')
                expect(task.human_date_end).to eq('19/12/2022 at 13:15')
            end
        end

        describe 'verifica se a tarefa esta atrasada' do
            context 'esta no prazo' do
                before do
                    task.stub(date_start: Time.now - 1.day)
                    task.stub(date_end: Time.now + 1.day)
                end
                it 'concluida' do
                    task.stub(state: true)
                    expect(task.is_task_late).to eq(false)
                end

                it 'pendente' do
                    task.stub(state: false)
                    expect(task.is_task_late).to eq(false)
                end
            end

            context 'esta fora do prazo' do
                before do
                    task.stub(date_start: Time.now - 2.day)
                    task.stub(date_end: Time.now - 1.day)
                end

                it 'concluida' do
                    task.stub(state: true)
                    expect(task.is_task_late).to eq(false)
                end

                it 'pendente' do
                    task.stub(state: false)
                    expect(task.is_task_late).to eq(true)
                end
            end

        end
    end
end