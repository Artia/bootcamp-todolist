
require 'rails_helper'

RSpec.describe ProjectsController, type: :controller do
  let(:project) { Project.create(title: 'Project_controller') }
  # DESAFIO
  # adicionar os expects
  # substituir a constante VERBO_HTTP pelo verbo http GET, POST, DELETE, PUT....
  # substituir a constante STATUS_HTTP pelo código http 200, 201 ... (https://httpstatusdogs.com/)


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
        @params = {"project"=>{"title"=>"Teste"}, "commit"=>"Save", "project_id"=> project.id}
      end

      it 'deve criar um registro' do
        expect {post :create, params: @params}.to change(Project, :count).by(1)
      end

      it 'retorna mensagem de sucesso' do
        post :create, params: @params
        expect(response.request.flash[:notice]).to eq("Project was successfully create.")
      end
    end

    context 'erro' do
      before do
        @params = {"project"=>{"title"=>""}, "commit"=>"Save", "project_id"=> project.id}
      end

      it 'não deve criar um registro' do
        expect {post :create, params: @params}.to change(Project, :count).by(0)
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
      # get :show, params: :show
    end

    it 'retorna status STATUS_HTTP' do
      get :show, params: {"id"=>project.id}
      expect(response.status).to eq(200)
    end

    it 'renderiza o template show' do
      #---- VERIFICAR
      get :show, params: {"id"=>project.id}
      expect(response).to render_template(:show)
    end
  end


  describe 'GET#edit' do
    before do
      @params = {"project"=>{"title"=>"Teste","state"=>"1"}, "commit"=>"Save", "id"=> project.id}
    end

    it 'deve retorna status 200' do
      get :edit, params: @params
      expect(response.status).to eq(200)
    end

    it 'renderiza o template edit' do
      get :edit, params: @params
      expect(response).to render_template(:edit)
    end
  end


  describe 'PUT#update' do
    context 'sucesso' do
      before do
        @params = {"project"=>{"title"=>"Teste","state"=>"1"}, "commit"=>"Save", "id"=> project.id}
        put :update, params: @params
      end

      it 'deve atualizar o título do projeto' do
        expect(project.reload.title).to eq("Teste")
      end

      it 'retorna mensagem de sucesso' do
        post :create, params: @params
        expect(response.request.flash[:notice]).to eq("Project was successfully create.")
      end
    end

    context 'erro' do
      before do
        @params = {"project"=>{"title"=>""}, "commit"=>"Save", "id"=> project.id}
        put :update, params: @params
      end

      it 'não deve atualizar o título do projeto' do
        put :update, params: @params
        expect(project.reload.title).to eq('Project_controller')
      end

      it 'retorna status 422' do
        expect(response.status).to eq(422)
      end

      it 'renderiza o template edit' do
        get :edit, params: {"id"=>project.id}
        expect(response).to render_template(:edit)
      end
    end
  end


  describe 'DELETE#destroy' do
    before do
      @params = {"project"=>{"title"=>"teste"}, "commit"=>"Save", "id"=> project.id}
    end
    it 'deve apagar um registro' do
      expect {delete :destroy, params: @params}.to change(Project, :count).by(-1)
    end

    it 'retorna mensagem de sucesso' do
      delete :destroy, params: @params
      expect(response.request.flash[:notice]).to eq("Project was successfully destroyed.")
    end
  end
end