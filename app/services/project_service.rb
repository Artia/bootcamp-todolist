class  ProjectService < ApplicationService

  def update_percent_complete(project_id:)
    find_project(project_id: project_id).update(completed_percent: completed_percent(project_id: project_id))
  end

  def project_destroy(project)
    has_tasks = Task.select("COUNT(*)").where(project_id: project.id).first
    if (has_tasks)
        Task.where(project_id: project.id).destroy_all
    end
    project.destroy
  end

  def destroy
    project = Project.find(params[:id])
    project.destroy
end

  private

  def find_project(project_id:)
    Project.find_by(id: project_id)
  end
end