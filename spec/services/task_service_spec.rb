
require 'rails_helper'

RSpec.describe 'TaskService', type: :model do
  before do
    @task_service = TaskService.new
    @project = Project.create(title: 'Integração')
  end

  describe '#create' do
    before do
      params = { title: "Levantamento de Requisitos", date_start: "2022-02-15T18:00", date_end: "2022-02-16T18:00", state: "1" } 
      @task = @task_service.create(params, project: @project)
    end

    it 'valida os atributos da tarefa criada' do
      expect(@task).to have_attributes(
        id: be_a_kind_of(Integer),
        date_start: Time.zone.parse('2022-02-15 18:00'), 
        date_end: Time.zone.parse('2022-02-16 18:00'),
        state: true,
        project_id: @project.id
      )
    end
  end
end