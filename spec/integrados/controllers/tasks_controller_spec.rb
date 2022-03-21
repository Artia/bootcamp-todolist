require 'rails_helper'

RSpec.describe TasksController, type: :controller do
  let(:project) { Project.create(title: 'Nova Release') }
  let(:task) { Task.create(title: "Gerar versão", date_start: Time.now, date_end: Time.now + 2.days, project_id: project.id) }

  describe 'GET#index' do
    before do
      get :index, params: { project_id: project.id }
    end

    it 'retorna status 200' do
      expect(response.status).to eq(200)
    end

    it 'renderiza o template index' do
      expect(response).to render_template(:index)
    end
  end

  describe 'GET#new' do
    before do
      get :new, params: { project_id: project.id }
    end

    it 'retorna status 200' do
      expect(response.status).to eq(200)
    end

    it 'renderiza o template new' do
      expect(response).to render_template(:new)
    end
  end

  describe 'POST#create' do
    context 'sucesso' do
      before do
        @params = { task: { title: 'tarefa1', date_start: '2022-03-15T08:00', date_end: '2022-03-16T09:00', state: '0' }, project_id: project.id }
      end

      it 'deve criar um registro' do
        expect {  
          post :create, params: @params 
        }.to change(Task, :count).by(1)
      end

      it 'retorna mensagem de sucesso' do
        post :create, params: @params 
        expect(response.request.flash[:notice]).to eq('Task was successfully created.')
      end
    end

    context 'erro' do
      before do
        @params = { task: { title: '', date_start: '2022-03-15T08:00', date_end: '2022-03-16T09:00', state: '0' }, project_id: project.id }
      end

      it 'não deve criar um registro' do
        expect {  
          post :create, params: @params 
        }.to change(Task, :count).by(0)
      end

      it 'retorna status 422' do
        post :create, params: @params
        expect(response.status).to eq(422)
      end

      it 'renderiza o template new' do
        post :create, params: @params
        expect(response).to render_template(:new)
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

    it 'renderiza o template show' do
      expect(response).to render_template(:show)
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

  describe 'PATCH#update' do
    context 'sucesso' do
      before do
        @params = { task: { title: "tarefa1", date_start: "2022-03-15T08:00", date_end: "2022-03-16T09:00", state: "1" }, project_id: project.id, id: task.id }
        patch :update, params: @params 
      end

      it 'retorna mensagem de sucesso' do
        expect(response.request.flash[:notice]).to eq('Task was successfully updated.')
      end
    end

    context 'erro' do
      before do
        @params = { task: { title: "tarefa1", date_start: "2022-03-15T08:00", date_end: "2022-03-14T09:00", state: "1" }, project_id: project.id, id: task.id }
        patch :update, params: @params 
      end

      it 'retorna status 422' do
        expect(response.status).to eq(422)
      end

      it 'renderiza o template edit' do
        expect(response).to render_template(:edit)
      end
    end
  end

  describe 'DELETE#destroy' do
    it 'deve apagar um registro' do
      expect {  
        delete :destroy, params: { project_id: project.id, id: task.id }
      }.to change(Task, :count).by(0)
    end

    it 'retorna mensagem de sucesso' do
      delete :destroy, params: { project_id: project.id, id: task.id }
      expect(response.request.flash[:notice]).to eq('Task was successfully destroyed.')
    end
  end

  describe 'PUT#change_status' do
    context 'sucesso' do
      before do
        put :change_status, params: { project_id: project.id, task_id: task.id }
      end

      it 'encerra a tarefa' do
        expect(task.reload.state).to eq(true)
      end

      it 'retorna mensagem de sucesso' do
        expect(response.request.flash[:notice]).to eq('Task was successfully updated.')
      end
    end

    context 'erro' do
      before do
        put :change_status, params: { project_id: project.id, task_id: 99999 }
      end

      it 'retorna mensagem de erro para tarefa não encontrada' do
        expect(response.request.flash[:alert]).to eq('Task not found')
      end
    end
  end
end