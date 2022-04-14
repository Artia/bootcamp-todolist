require 'rails_helper'

RSpec.describe Task, type: :model do
    let(:task) { Task.new(title: 'Nova tarefa')}
    #before :all do
    #    puts "\n\n passa aqui"
    #    @task = Task.new(title: 'Nova tarefa')
    #end

    describe 'Validação' do
        
        describe 'Title' do
            it { is_expected.to validate_presence_of(:title) }
            it { is_expected.to validate_length_of(:title).is_at_most(255) }    
        end
        
        describe 'Dates' do
            it { is_expected.to validate_presence_of(:date_start) }
            it { is_expected.to validate_presence_of(:date_end) }
        
            it 'Não deve aceitar data de início maior que data de fim' do
                #Setup
                task.date_start = Time.now
                task.date_end = Time.now - 1.day

                task.valid?

                expect(task.errors.added?(:date_start, 'cannot be greater than the end date')).to eq(true)
            end
        end

        describe 'Associação' do
            it { is_expected.to belong_to(:project) }
        end

        describe 'Validação' do
            context 'human_state' do
                it 'State nil' do
                    expect(task.human_state).to eq('Pending')
                end
    
                it 'State false' do
                    task.stub(state: false)
                    expect(task.human_state).to eq('Pending')  
                end
    
                it 'State true' do
                    task.stub(state: true)
                    expect(task.human_state).to eq('Concluded')
                end
            end

            context 'deadline_status' do
                it 'Deve retornar Tarefa atrasada' do
                    task.stub(date_end: Time.now - 1.day)
                    task.stub(state: false)

                    expect(task.deadline_status).to eq("Tarefa atrasada")
                end

                it 'Deve retornar Tarefa finalizada' do
                    task.stub(date_end: Time.now - 1.day)
                    task.stub(state: true)

                    expect(task.deadline_status).to eq("Tarefa finalizada")
                end

                it 'Deve retornar Tarefa em dia' do
                    task.stub(date_end: Time.now + 1.day)
                    task.stub(state: false)

                    expect(task.deadline_status).to eq("Tarefa em dia")
                end
            end

            context 'formated_start_date' do
                it 'Deve retornar data inicial formatada' do
                    task.stub(date_start: Time.new(2022, 04, 14))

                    expect(task.formated_start_date).to start_with('14/04/2022')
                end
            end

            context 'formated_end_date' do
                it 'Deve retornar data final formatada' do
                    task.stub(date_end: Time.new(2022, 04, 14))
                    
                    expect(task.formated_end_date).to start_with('14/04/2022')
                end
            end
        end
    end
end