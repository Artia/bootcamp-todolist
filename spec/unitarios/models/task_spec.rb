require 'rails_helper'

RSpec.describe Task, type: :model do
    let(:task) { Task.new(title: 'Nova tarefa')}
    #before :all do
    #    puts "\n\n passa aqui"
    #    @task = Task.new(title: 'Nova tarefa')
    #end

    describe 'validação' do
        
        describe 'title' do
            it { is_expected.to validate_presence_of(:title) }
            it { is_expected.to validate_length_of(:title).is_at_most(255) }    
        end
        
        describe 'dates' do
            it { is_expected.to validate_presence_of(:date_start) }
            it { is_expected.to validate_presence_of(:date_end) }
        
            it 'não deve aceitar data de início maior que data de fim' do
                #Setup
            task.date_start = Time.now
            task.date_end = Time.now - 1.day

            task.valid?

            expect(task.errors.added?(:date_start, 'cannot be greater than the end date')).to eq(true)
            end
        end

        describe 'associação' do
            it { is_expected.to belong_to(:project) }
        end

        describe 'validação' do
        end

        describe 'human_state' do
            it 'state nil' do
                expect(task.human_state).to eq('Pending')
            end

            it 'state false' do
                task.stub(state: false)
                expect(task.human_state).to eq('Pending')  
            end

            it 'state true' do
                task.stub(state: true)
                expect(task.human_state).to eq('Concluded')
            end
        end
    end
end