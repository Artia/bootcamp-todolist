require 'rails_helper'

RSpec.describe ProjectService, type: :service do
    
    before do
        @project_service = ProjectService.new

        @project = Project.new(title: 'Novo Projeto')
        @project.save
    end

    describe 'create' do
        it 'Deve criar um projeto' do
            @params = { title: 'Projeto Teste' }

            project = @project_service.create(params: @params)
            expect(project).to have_attributes(:title => 'Projeto Teste')
        end
    end

    describe 'update' do
        it 'Deve alterar um projeto' do
            @project_service.update(params: { title: 'Projeto atualizado' }, project_id: @project.id)
            
            expect(@project.reload.title).to eq('Projeto atualizado')
        end
    end

    describe 'destroy' do
        it 'Deve deletar um projeto' do
            @project_service.destroy(project_id: @project.id)

            expect(Project.all.count) == 0
        end
    end

    describe 'update_percent_complete' do
        
    end
end