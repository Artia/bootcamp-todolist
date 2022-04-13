require 'rails_helper'

RSpec.describe Task, type: :model do   
    let(:task) { Task.new(title: 'Nova Tarefa') }
    # before :all do
    #     @task = Task.new(title: 'Nova Tarefa')
    # end

    describe 'associação' do
        it {is_expected.to belong_to(:project)}
    end

    describe 'Validates' do
        describe 'title' do
            it {is_expected.to validate_presence_of(:title) }
            it {is_expected.to validate_length_of(:title).is_at_most(255) }
        end

        describe 'dates' do
            it { is_expected.to validate_presence_of(:date_start) }
            it { is_expected.to validate_presence_of(:date_end) }
            

            it 'não deve aceitar data de início maior que data de fim' do
                #setup
                task.date_start = Time.now
                task.date_end = Time.now - 1.day

                task.valid?
                expect(task.errors.added?(:date_start, 'cannot be greater than the end date')).to eq(true)
            end
        end
    end

    describe 'human_state' do
        it 'status deve ser nulo' do 
            expect(task.human_state).to eq('Pending')
        end
        it 'status deve ser pendente ' do 
            task.stub(state: false)
            expect(task.human_state).to eq('Pending')   
        end
        it 'status deve ser concoluido' do 
            task.stub(state: true)
            expect(task.human_state).to eq('Concluded')
        end
    end
end