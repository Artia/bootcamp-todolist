require 'rails_helper'

RSpec.describe TasksController, type: :controller do
    let(:project) { Project.create(title: 'Testando Controller') }
    let(:task) { task.create(title: 'Teste automatizado', date_start: Time.now, date_end: Time.now + 2.days, project_id: project.id)}
    
    describe 'GET#index' do
        
        it 'retorna status 200' do
            get :index, params: {project_id: project.id}
            expect(response.status).to eq(200)
        end

        it 'deve renderizar o template index' do
            get :index, params: {project_id: project.id}
            expect(response).to render_template(:index)
        end
    end

    describe 'GET#Show' do        
        it 'retorna status 200' do
            get :show, params: { project_id: project.id, id: task.id }
            expect(response.status).to eq(200)
        end

        it 'deve renderizar o template show' do
            get :show, params: { project_id: project.id, id: task.id }
            expect(response).to render_template(:show)
        end
    end

    
    # describe 'GET#Show' do
    #     before do
    #         get :show, params: { project_id: project.id, id:task.id }
    #     end
        
    #     it 'retorna status 200' do
    #         expect(response.status).to eq(200)
    #     end

    #     it 'deve renderizar o template show' do
    #         expect(response).to render_template(:show)
    #     end
    # end

    describe 'GET#new' do
        
        it 'retorna status 200' do
            get :new, params: {project_id: project.id}
            expect(response.status).to eq(200)
        end

        it 'deve renderizar o template new' do
            get :new, params: {project_id: project.id}
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
        
        # describe "DELETE#destroy" do
        #     before do
        #         @params = { project_id: project.id, id: task.id }
        #     end
        #     byebug
        #     it 'deve apagar um regristro da tabela de tarefas' do
        #         expect {
        #             delete :destroy, params: @params
        #         }.to change(Task,  :count).by(-1)
        #     end

        #     it 'deve retornar mensagem de sucesso' do
        #         delete :destroy, params: @params
        #         expect(response.request.flash[:notice]).to eq("Task was successfully destroyed.")
        #     end
        # end
        describe "PATCH#update" do 
            before do
                @params = {"task"=>{"title"=>"teste", "date_start"=>"2022-04-01T10:00", "date_end"=>"2022-04-15T11:00", "state"=>"1"}, "commit"=>"Save", "project_id"=>project.id, "id"=>task.id}
                patch :update, params: @params
            end

            it "" do
                expect(task.reload).to  have_attributes(
                    title: 'teste',
                    state: true,
                    project_id: project.id
                )
            end
        end
    end
end