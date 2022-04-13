require 'rails_helper'

RSpec.describe TasksController, type: :controller do
    let(:project) { Project.create(title: 'Testando Controller') }
    let(:task) { Task.create(title: 'Teste automatizado', date_start: Time.now, date_end: Time.now + 1.day, project_id: project.id) }
    
    describe 'GET#index' do
        it 'Deve retornar status 200' do
            get :index, params: { project_id: project.id }
            expect(response.status).to eq(200)
        end

        it 'Deve renderizar o template index' do
            get :index, params: { project_id: project.id }
            expect(response).to render_template(:index)
        end
    end

    describe 'GET#new' do
        before do
            get :new, params: { project_id: project.id }
        end

        it 'Deve retornar status 200' do
            expect(response.status).to eq(200)
        end

        it 'Deve renderizar o template show' do
            expect(response).to render_template(:new)
        end
    end

    describe 'POST#create' do
        context 'Sucesso' do
            before do
                @params = {"task"=>{"title"=>"criação", "date_start"=>"2022-04-08T09:00", "date_end"=>"2022-04-08T16:00", "state"=>"0"}, "commit"=>"Save", "project_id"=> project.id}
            end

            it 'Deve criar um registro na tabela de tarefas' do
                expect {
                    post :create, params: @params
                }.to change(Task, :count).by(1)
            end
    
            it 'Deve retornar mensagem de sucesso' do
                post :create, params: @params
                expect(response.request.flash[:notice]).to eq("Task was successfully created.")
            end
        end

        context 'Erro' do
            before do
                @params = {"task"=>{"title"=>"", "date_start"=>"2022-04-08T09:00", "date_end"=>"2022-04-08T16:00", "state"=>"0"}, "commit"=>"Save", "project_id"=> project.id}
            end

            it 'Não deve criar um registro na tabela de tarefas' do
                expect {
                    post :create, params: @params
                }.to change(Task, :count).by(0)
            end

            it 'Deve retornar status' do
                post :create, params: @params
                expect(response.status).to eq(422)
            end

            it 'Deve renderizar o template new' do
                post :create, params: @params
                expect(response).to render_template(:new)
            end
        end
    end

    describe 'GET#show' do
        before do
            get :show, params: { project_id: project.id, id: task.id }
        end

        it 'Deve retornar status 200' do
            expect(response.status).to eq(200)
        end

        it 'Deve renderizar o template show' do
            expect(response).to render_template(:show)
        end
    end

    describe 'DELETE#destroy' do
        before do
            @params = { project_id: project.id, id: task.id }
        end

        it 'Deve apagar um registro da tabela de tarefas' do
            expect {
                delete :destroy, params: @params
            }.to change(Task, :count).by(-1)
        end

        it 'Deve retornar mensagem de sucesso' do
            delete :destroy, params: @params
            expect(response.request.flash[:notice]).to eq("Task was successfully destroyed.")
        end
    end

    describe 'PATCH#update' do
        context 'Sucesso' do
            before do
                @params = {"task"=>{"title"=>"teste", "date_start"=>"2022-04-01T10:00", "date_end"=>"2022-04-15T11:00", "state"=>"1"}, "commit"=>"Save", "project_id"=>project.id, "id"=>task.id}
                patch :update, params: @params
            end

            it 'Deve atualizar os campos' do
                expect(task.reload).to have_attributes(
                    title: "teste",
                    state: true,
                    project_id: project.id
                )
            end

            it 'Deve retornar mensagem de sucesso' do
                post :update, params: @params
                expect(response.request.flash[:notice]).to eq("Task was successfully updated.")
            end
        end

        context 'Erro' do
            before do
                @params = {"task"=>{"title"=>"", "date_start"=>"2022-04-01T10:00", "date_end"=>"2022-04-15T11:00", "state"=>"1"}, "commit"=>"Save", "project_id"=>project.id, "id"=>task.id}
                patch :update, params: @params
            end

            it 'Deve retornar status de erro' do
                expect(response.status).to eq(422)
            end
        end
    end

    describe 'PATCH#change_status' do
        context 'Sucesso' do
            context 'Quando o state for nil' do
                before do
                    @params = { task_id: task.id, project_id: project.id }
                    put :change_status, params: @params
                end
        
                it 'Deve alterar o status da tarefa para true' do
                    expect(task.reload.state).to eq(true)
                end

                it 'Deve retornar status 200' do
                    expect(response.request.flash[:notice]).to eq("Task was successfull updated.")
                end
            end

            context 'Quando o state for false' do
                before do
                    @params = { task_id: task.id, project_id: project.id }
                    task.update(state: false)
                    put :change_status, params: @params
                end
                
                it 'Deve alterar o status da tarefa para true' do
                    expect(task.reload.state).to be_truthy
                end

                it 'Deve retornar status 200' do
                    expect(response.request.flash[:notice]).to eq("Task was successfull updated.")
                end
            end

            context 'Quando o state for true' do
                before do
                    @params = { task_id: task.id, project_id: project.id }
                    task.update(state: true)
                    put :change_status, params: @params
                end

                it 'Deve alterar o status da tarefa para false' do
                    expect(task.reload.state).to be_falsy
                end

                it 'Deve retornar o status 200' do
                    expect(response.request.flash[:notice]).to eq("Task was successfull updated.")
                end
            end
        end

        context 'Erro' do
            before do
                @params = { task_id: 999999, project_id: project.id }
                put :change_status, params: @params
            end

            it 'Deve retornar status 422' do
                expect(response.request.flash[:notice]).to eq("Task not found")
            end
        end
    end
end