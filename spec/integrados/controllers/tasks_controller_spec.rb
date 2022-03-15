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

    xit 'renderiza o template index' do
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

    xit 'renderiza o template new' do
      expect(response).to render_template(:new)
    end
  end

  describe 'POST#create' do
    #{"authenticity_token"=>"[FILTERED]", "task"=>{"title"=>"tarefa 1", "date_start"=>"2022-03-15T08:00", "date_end"=>"2022-03-16T10:00", "state"=>"1"}, "commit"=>"Save", "project_id"=>"43"}
  end

  describe 'GET#show' do
    before do
      get :show, params: { project_id: project.id, id: task.id }
    end

    it 'retorna status 200' do
      expect(response.status).to eq(200)
    end

    xit 'renderiza o template show' do
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

    xit 'renderiza o template edit' do
      expect(response).to render_template(:edit)
    end
  end

  describe 'PATCH#update' do
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
  end
end