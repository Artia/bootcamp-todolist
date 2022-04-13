require 'rails_helper'

RSpec.describe ProjectService, type: :service do
    before :all do
        @project_service = ProjectService.new
        @project_id = 1
    end

    describe "complete_percentage" do
        it "Projeto sem tarefa" do
            allow(Task).to receive_message_chain(:select, :where, :first) { double('Task', total_tasks: 0,task_concluded: 0)}
            expect(@project_service.complete_percentage(project_id:@project_id)).to eq(0)
        end

        it "Projeto só com 1 tarefa pendente" do
            allow(Task).to receive_message_chain(:select, :where, :first) { double('Task', total_tasks: 1,task_concluded: 0)} 
            expect(@project_service.complete_percentage(project_id:@project_id)).to eq(0)  
        end

        it "Projeto só com 1 tarefa encerrada" do
            allow(Task).to receive_message_chain(:select, :where, :first) { double('Task', total_tasks: 1,task_concluded: 1)} 
            expect(@project_service.complete_percentage(project_id:@project_id)).to eq(100)  
        end

        it "Projeto com 1 tarefa encerrada e 1 tarefa pendente" do
            allow(Task).to receive_message_chain(:select, :where, :first) { double('Task', total_tasks: 2,task_concluded: 1)} 
            expect(@project_service.complete_percentage(project_id:@project_id)).to eq(50)  
        end

        it "Projeto com 4 tarefas no total e 1 delas esta encerrada" do
            allow(Task).to receive_message_chain(:select, :where, :first) { double('Task', total_tasks: 4,task_concluded: 1)} 
            expect(@project_service.complete_percentage(project_id:@project_id)).to eq(25)  
        end
    end
end