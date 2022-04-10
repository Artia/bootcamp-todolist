require 'rails_helper'

RSpec.describe Task, type: :model do
    before do
        puts "\n\n passa aqui"
        @task = Task.new(title: 'Nova Tarefa')
    end
    describe 'associação' do
        it { is_expected.to belong_to(:project) }
    end

    describe 'validação' do
        describe 'title' do
            it { is_expected.to validate_presence_of(:title) }
            it {is_expected.to validate_length_of(:title).is_at_most(255) }
        end
        it { is_expected.to validate_presence_of(:title) }
        it {is_expected.to validate_length_of(:title).is_at_most(255) }

        it { is_expected.to validate_presence_of(:date_start) }
        it {is_expected.to validate_presence_of(:date_end) }

        it 'não deve aceitar data de início maior que data de fim' do
            @task.date_start = Time.now
            @task.date_end = Time.now - 1.day
            
            @task.valid?

            expect(@task.errors.added?(:date_start, 'cannot be greater than the end date')).to eq(true)
        end
    end
end