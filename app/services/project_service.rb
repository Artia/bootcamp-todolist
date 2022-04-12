class  ProjectService < ApplicationService

  def update_percent_complete(project_id:)
    find_project(project_id: project_id).update(completed_percent: completed_percent(project_id: project_id))
  end

  private

  def find_project(project_id:)
    Project.find_by(id: project_id)
  end
end
