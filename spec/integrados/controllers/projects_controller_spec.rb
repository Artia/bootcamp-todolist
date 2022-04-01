require 'rails_helper'

RSpec.describe ProjectsController, type: :controller do
  let(:project) { Project.create(title: 'Automação de Testes') }

  describe 'GET#index' do
    before do
      get :index
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
      get :new
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
        @params = { project: { title: 'Projeto 1' } }
      end

      it 'deve criar um registro' do
        expect {  
          post :create, params: @params 
        }.to change(Project, :count).by(1)
      end

      it 'retorna mensagem de sucesso' do
        post :create, params: @params 
        expect(response.request.flash[:notice]).to eq('Project was successfully created.')
      end
    end

    context 'erro' do
      before do
        @params = { project: { title: '' } }
      end

      it 'não deve criar um registro' do
        expect {  
          post :create, params: @params 
        }.to change(Project, :count).by(0)
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
      get :show, params: { id: project.id }
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
      get :edit, params: { id: project.id }
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
        params = { project: { title: 'Testes automatizados' }, id: project.id }
        patch :update, params: params 
      end

      it 'deve atualizar o título do projeto' do
        expect(project.reload.title).to eq('Testes automatizados')
      end

      it 'retorna mensagem de sucesso' do
        expect(response.request.flash[:notice]).to eq('Project was successfully updated.')
      end
    end

    context 'erro' do
      before do
        @params = { project: { title: "" }, id: project.id }
        patch :update, params: @params 
      end

      it 'não deve atualizar o título do projeto' do
        expect(project.reload.title).to eq('Automação de Testes')
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
        delete :destroy, params: { id: project.id }
      }.to change(Project, :count).by(0)
    end

    it 'retorna mensagem de sucesso' do
      delete :destroy, params: { id: project.id }
      expect(response.request.flash[:notice]).to eq('Project was successfully destroyed.')
    end
  end
end 