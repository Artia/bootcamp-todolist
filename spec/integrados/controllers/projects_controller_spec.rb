require 'rails_helper'

RSpec.describe ProjectsController, type: :controller do
  let(:project) { Project.create(title: 'Teste Projeto Controller') }

  describe 'GET#index' do
    before do
      get :index
    end

    it 'deve retornar status 200' do
      expect(response.status).to eq(200)
    end

    it 'deve renderizar o template index' do
      expect(response).to render_template(:index)
    end
  end

  describe 'GET#new' do
    before do
      get :new
    end

    it 'deve retornar status 200' do
      expect(response.status).to eq(200)
    end

    it 'deve renderizar o template new' do
      expect(response).to render_template(:new)
    end
  end

  describe 'POST#create' do
    context 'sucesso' do
      before do
        @params = { "project" => { "title" => "Um projeto" } }
      end

      it 'deve criar um registro' do
        expect {
          post :create, params: @params
        }.to change(Project, :count).by(1)
      end

      it 'deve retornar mensagem de sucesso' do
        post :create, params: @params
        expect(response.request.flash[:notice]).to eq("Project was successfully created.")
      end
    end

    context 'erro' do
      before do
        @params = { "project" => { "title" => ""} }
      end

      it 'não deve criar um registro' do
        expect {
          post :create, params: @params
        }.to change(Project, :count).by(0)
      end

      it 'deve retornar status 422' do
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
      get :show, params: { id: project.id }
    end

    it 'deve retornar status 200' do
      expect(response.status).to eq(200)
    end

    it 'deve renderizar o template show' do
      expect(response).to render_template(:show)
    end
  end

  describe 'GET#edit' do
    before do
      get :edit, params: { id: project.id }
    end

    it 'deve retornar status 200' do
      expect(response.status).to eq(200)
    end

    it 'deve renderizar o template edit' do
      expect(response).to render_template(:edit)
    end
  end

  describe 'PATCH#update' do
    context 'sucesso' do
      before do
        @params = { "project" => { "title" => "Other Project" }, "commit" => "Save", "id" => project.id }
        patch :update, params: @params
      end

      it 'deve atualizar o título do projeto' do
        expect(project.reload).to have_attributes(
          title: "Other Project"
        )
      end

      it 'deve retornar mensagem de sucesso' do
        post :update, params: @params
        expect(response.request.flash[:notice]).to eq("Project was successfully updated.")
      end
    end

    context 'erro' do
      before do
        @params = { "project" => { "title" => "" }, "commit" => "Save", "id" => project.id }
        patch :update, params: @params
      end

      it 'não deve atualizar o título do projeto' do
        expect(project.reload).to have_attributes(
          title: "Teste Projeto Controller"
        )
      end

      it 'deve retornar status 422' do
        expect(response.status).to eq(422)
      end

      it 'deve renderizar o template edit' do
        expect(response).to render_template(:edit)
      end
    end
  end

  describe 'DELETE#destroy' do
    before do
      @params = { id: project.id }
    end

    it 'deve apagar um registro' do
      expect {
        delete :destroy, params: @params
      }.to change(Project, :count).by(-1)
    end

    it 'deve retornar mensagem de sucesso' do
      delete :destroy, params: @params
      expect(response.request.flash[:notice]).to eq("Project was successfully destroyed.")
    end
  end
end