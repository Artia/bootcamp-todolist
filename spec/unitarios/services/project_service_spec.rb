require 'rails_helper'

RSpec.describe ProjectService, type: :service do
    before :all do
        @project_service = ProjectService.new

        @project = Project.new(title: 'Novo Projeto')
        @project.save
        
        @project_id = 1
    end

    describe 'complete_percentage' do
        it 'Não deve conter tarefa' do
            allow(Task).to receive_message_chain(:select, :where, :first) { double('Task', total_tasks: 0, task_concluded: 0) }
            expect(@project_service.complete_percentage(project_id: @project_id)).to eq(0)
        end
        
        it 'Deve resultar em 0% completo' do
            allow(Task).to receive_message_chain(:select, :where, :first) { double('Task', total_tasks: 1, task_concluded: 0) }
            expect(@project_service.complete_percentage(project_id: @project_id)).to eq(0)
        end

        it 'Deve resultar em 100% completo' do
            allow(Task).to receive_message_chain(:select, :where, :first) { double('Task', total_tasks: 1, task_concluded: 1) }
            expect(@project_service.complete_percentage(project_id: @project_id)).to eq(100)
        end

        it 'Deve resultar em 50% completo' do
            allow(Task).to receive_message_chain(:select, :where, :first) { double('Task', total_tasks: 2, task_concluded: 1) }
            expect(@project_service.complete_percentage(project_id: @project_id)).to eq(50)
        end

        it 'Deve resultar em 33.33% completo' do
            allow(Task).to receive_message_chain(:select, :where, :first) { double('Task', total_tasks: 3, task_concluded: 1) }
            expect(@project_service.complete_percentage(project_id: @project_id)).to eq(33.33)
        end
    end
end