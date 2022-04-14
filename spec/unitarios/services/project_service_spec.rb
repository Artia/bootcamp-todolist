require 'rails_helper'

RSpec.describe ProjectService, type: :service do
    before :all do
        @project_service = ProjectService.new 
        @project_id = 1
    end

    describe "complete_percentage" do
        it "projeto sem atividade" do
            allow(Task).to receive_message_chain(:select, :where, :first) { double('Task', total_tasks: 0, task_concluded: 0)}
            expect(@project_service.completed_percentage(project_id: @project_id)).to eq(0)  
        end

        it "projeto só com 1 tarefa pendente" do
            allow(Task).to receive_message_chain(:select, :where, :first) { double('Task', total_tasks: 1, task_concluded: 0)}
            expect(@project_service.completed_percentage(project_id: @project_id)).to eq(0)  
        end

        it "projeto só com 1 tarefa encerrada" do
            allow(Task).to receive_message_chain(:select, :where, :first) { double('Task', total_tasks: 1, task_concluded: 1)}
            expect(@project_service.completed_percentage(project_id: @project_id)).to eq(100)  
        end
    end
end
