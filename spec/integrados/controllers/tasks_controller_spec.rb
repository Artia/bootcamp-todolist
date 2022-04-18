require 'rails_helper'

RSpec.describe TasksController, type: :controller do
    
    let(:project) { Project.create(title: 'Testando Controller') }
    let(:task) { Task.create(title: 'Teste automatizado', date_start: Time.now, date_end: Time.now + 2.days, project_id: project.id)}
    
    describe 'GET#index' do
        before do
            get :index, params: {project_id: project.id}
        end
        
        it 'retorna status 200' do
            expect(response.status).to eq(200)
        end

        it 'deve renderizar o template index' do
            expect(response).to render_template(:index)
        end
    end

    describe 'GET#new' do
        before do
            get :new, params: {project_id: project.id}
        end

        it 'retorna status 200' do
            expect(response.status).to eq(200)
        end

        it 'renderiza o template new' do
            expect(response).to render_template(:new)
        end
    end
    
    describe 'POST#create' do
        context "success" do
            before do
                @params = {"task":{"title"=>"criação", "date_start"=>"2022-04-08T09:00", "date_end"=>"2022-04-08T16:00", "state"=>"0"}, "commit"=>"Save", "project_id"=> project.id}
            end
    
            it 'deve criar um registro na tabela de tarefas' do
                expect {
                    post :create, params: @params
                }.to change(Task,  :count).by(1)
            end
    
            it 'deve retornar  mensagem de sucesso' do
                post :create, params: @params 
                expect(response.request.flash[:notice]).to eq("Task was successfully created.")
            end
        end
        
        context "error" do
            before do
                @params = {"task":{"title"=>"", "date_start"=>"2022-04-08T09:00", "date_end"=>"2022-04-08T16:00", "state"=>"0"}, "commit"=>"Save", "project_id"=> project.id}
            end
            
            it 'não deve criar um registro na tabela de tarefas' do
                expect {
                    post :create, params: @params
                }.to change(Task,  :count).by(0)
            end
            
            it 'deve retornar status' do
                post :create, params: @params
                expect(response.status).to eq(422)
            end

            it 'deve renderizar o template new' do
                post :create, params: @params
                expect(response).to render_template(:new)
            end
        end
    end 

    describe 'GET#show' do
        before do
          get :show, params: { project_id: project.id, id: task.id }
        end
    
        it 'deve retornar status 200' do
          expect(response.status).to eq(200)
        end
    
        it 'deve renderizar o template show' do
          expect(response).to render_template(:show)
        end
    end
    
    describe "DELETE#destroy" do
        context 'success' do
            before do
                @params = { project_id: project.id, id: task.id }
            end 

            it 'deve apagar um regristro da tabela de tarefas' do
                expect {
                    delete :destroy, params: @params
                }.to change(Task,  :count).by(-1)
            end

            it 'deve retornar mensagem de sucesso' do
                delete :destroy, params: @params
                expect(response.request.flash[:notice]).to eq("Task was successfully destroyed.")
            end
        end

        context 'error' do 
            before do 
                @params = { project_id: project.id, id: 9999999 }
            end

            it 'nao deve apagar um regristro da tabela de tarefas' do
                expect {
                    delete :destroy, params: @params
                }.to change(Task,  :count).by(0)
            end

            it 'deve retornar mensagem de falha' do
                delete :destroy, params: @params
                expect(response.request.flash[:notice]).to eq("Task not found")
            end
        end
    end

    describe 'GET#edit' do
        before do
          get :edit, params: { project_id: project.id, id: task.id }
        end
    
        it 'retorna status 200' do
          expect(response.status).to eq(200)
        end
    
        it 'renderiza o template edit' do
          expect(response).to render_template(:edit)
        end
    end
    
    describe "PATCH#update" do 
        context 'success' do 
            before do
                @params = {"task"=>{"title"=>"teste", "date_start"=>"2022-04-01T10:00", "date_end"=>"2022-04-15T11:00", "state"=>"1"}, "commit"=>"Save", "project_id"=>project.id, "id"=>task.id}
                patch :update, params: @params
            end

            it "valida campo atualizado" do
                expect(task.reload).to  have_attributes(
                    title: 'teste',
                    state: true,
                    project_id: project.id
                )
            end
              
            it 'retorna mensagem de sucesso' do
                expect(response.request.flash[:notice]).to eq("Task was successfully updated.")
            end
        end

        context 'error' do            
            before do
                @params = {"task"=>{"title"=>"", "date_start"=>"2022-04-01T10:00", "date_end"=>"2022-04-15T11:00", "state"=>"1"}, "commit"=>"Save", "project_id"=>project.id, "id"=>task.id}
                patch :update, params: @params
            end

            it "nao atualiza campo" do
                expect(task.reload).to  have_attributes(
                    title: 'Teste automatizado',
                )
            end

            it 'retorna status 422' do
                expect(response.status).to eq(422)
              end
              
              it 'renderiza o template edit' do
                expect(response).to render_template(:edit)
            end
        end
    end

    describe 'PUT#change_status' do
        context 'success' do
            context 'quando entrada é default' do
                before do
                    put :change_status, params: { project_id: project.id, task_id: task.id }
                end

                it "valor de saida é concluida" do
                    expect(task.reload.state).to eq(true)
                end

                it 'retorna mensagem de sucesso' do
                    expect(response.request.flash[:notice]).to eq("Task was successfully updated.")
                end
            end

            context 'quando entrada é concluida' do
                before do
                    task.state = true
                    task.save
                    put :change_status, params: { project_id: project.id, task_id: task.id }
                end

                it "valor de saida é pendente" do
                    expect(task.reload.state).to eq(false)
                end

                it 'retorna mensagem de sucesso' do
                    expect(response.request.flash[:notice]).to eq("Task was successfully updated.")
                end
            end
            
            context 'quando entrada é pendente' do
                before do
                    task.state = false
                    task.save
                    put :change_status, params: { project_id: project.id, task_id: task.id }
                end

                it "valor de saida é concluida" do
                    expect(task.reload.state).to eq(true)
                end

                it 'retorna mensagem de sucesso' do
                    expect(response.request.flash[:notice]).to eq("Task was successfully updated.")
                end
            end
        end
        
        context 'error' do            
            before do
                @old_state = task.state
                put :change_status, params: { project_id: project.id, task_id: 999999}
            end

            it "quando a tarefa nao existe" do
                expect(task.reload).to  have_attributes(
                    state: @old_state
                )
            end

            it 'retorna mensagem de falha' do
                expect(response.request.flash[:notice]).to eq("Task not found")
            end            
        end
    end
end