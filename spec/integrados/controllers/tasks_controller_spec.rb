require 'rails_helper'

RSpec.describe TasksController, type: :controller do
    let(:project) { Project.create(title: 'Testando Controller')}
    let(:task) { Task.create(title: 'Teste automatizado', date_start: Time.now, date_end: Time.now + 2.days, project_id: project.id) }

    describe 'GET#index' do
        it 'retorna status 200' do
            get :index, params: {project_id: project.id}
            expect(response.status).to eq(200)
        end
        it 'deve renderizar o template index' do
            get :index, params: {project_id: project.id}
            expect(response).to render_template(:index)
        end
    
    describe 'GET#show' do
            it 'retorna status 200' do
                get :show, params: {project_id: project.id, id: task.id}
                expect(response.status).to eq(200)
            end
            it 'deve renderizar o template show' do
                expect(response).to render_template(:show)
            end
    end

    describe 'GET#new' do
            it 'retorna status 200' do
                get :new, params: {project_id: project.id}
                expect(response.status).to eq(200)
            end
            it 'deve renderizar o template index' do
                expect(response).to render_template(:new)
            end
    end

    describe 'POST#create' do
            before do
                @params = {"task"=>{"title"=>"criação", "date_start"=>"2022-04-08T09:00", "date_end"=>"2022-04-08T16:00", "state"=>"0"}, "commit"=>"Save", "project_id"=> project.id}
                post :create, params: params
            end

            context 'sucesso' do
                it 'deve criar um registro na tabela de tarefas' do
                    expect {
                          post :create, params: @params
                    }.to change(Task, :count).by(1) 
                 end

                 it 'deve retornar status' do
                     post :create, params: @params
                     expect(response.status).to eq(302)
                 end

                 it 'deve renderizar o template new' do
                    expect(response).to render_template(:new)
                 end


                 it 'deve retornar mensagem de sucesso' do
                     post :create, params: @params
                     expect(response.request.flash[:notice]).to eq('Tarefa criada com sucesso')
                 end
               end
            end
        end

    describe 'GET#show' do

            before do
                get :show, params: { project_id: project.id, id: task.id }
            end

            it 'retorna status 200' do
                expect(response.status).to eq(200)
            end

            it 'deve renderizar o template show' do
                expect(response).to render_template(:show)
            end
        end
        
    describe 'DELETE#destroy' do
            it 'deve apagar no registro na tabela de tarefas' do
                expect {
                    delete :destroy, params: { project_id: project.id, id: task.id }
                }.to change(Task, :count).by(-1)
            end

            it 'deve retornar mensagem de sucesso' do
                delete :destroy, params: @params
                expect(response.request.flash[:notice]).to eq('Tarefa apagada com sucesso')
        end
    end

    describe 'PATCH#update' do
        before do
            @params = {"task"=>{"title"=>"teste", 
                "date_start"=>"2022-04-01T10:00", 
                "date_end"=>"2022-04-15T11:00", 
                "state"=>"1"}, "commit"=>"Save", 
                "project_id"=>project.id, 
                "id"=>task.id}
            patch :update, params: @params
        end
        
        it "" do
            expect(task.reload).to have_attributes(
                title: "teste", 
                date_start: "2022-04-01T10:00", 
                date_end: "2022-04-15T11:00", 
                state: "1")
        end

        it "" do
            expect(task.state).to eq(1)
        end

        end
    end
