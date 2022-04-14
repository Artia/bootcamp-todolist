require 'rails_helper'

RSpec.describe ProjectService, type: :service do
    before :all do
       @project_service = ProjectService.new 
       @project_id = 1
    end

    describe 'complete_project' do
        it "projeto sem atividade" do
            allow(Task).to receive_message_chain(:select, :where, :first) { double('Task', total_tasks: 0, task_concluded: 0)}
            expect(@project_service.complete_percentage(project_id: @project_id)).to eq(0)
        end

        it "projeto com atividade pendente" do
            allow(Task).to receive_message_chain(:select, :where, :first) {double('Task', total_tasks: 1, task_concluded: 0)}
            expect(@project_service.complete_percentage(project_id: @project_id)).to eq(0)
        end

        it "projeto com atividade concluida" do
            allow(Task).to receive_message_chain(:select, :where, :first) {double('Task', total_tasks: 1, task_concluded: 1)}
            expect(@project_service.complete_percentage(project_id: @project_id)).to eq(100)
        end


        # DESAFIOS
        # OUTRAS CONDIÇÕES DE TESTE

        it "projeto com atividade concluida e com atividade pendente" do
            allow(Task).to receive_message_chain(:select, :where, :first) {double('Task', total_tasks: 2, task_concluded: 1)}
            expect(@project_service.complete_percentage(project_id: @project_id)).to eq(50)
        end

        
        it 'projeto com 2 atividades concluidas com 1 pendente' do
            allow(Task).to receive_message_chain(:select, :where, :first) {double('Task', total_tasks: 3, task_concluded: 2)}
            expect(@project_service.complete_percentage(project_id: @project_id)).to eq(66.66666666666666)
        end

        it 'projeto com 5 atividades e nenhuma concluida' do
            allow(Task).to receive_message_chain(:select, :where, :first) {double('Task', total_tasks: 5, task_concluded: 0)}
            expect(@project_service.complete_percentage(project_id: @project_id)).to eq(0)
        end


    end
end