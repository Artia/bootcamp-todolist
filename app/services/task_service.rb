class TaskService < ApplicationService

  def create(params, project:)
    task = Task.new(params)
    task.project = project
    update_project_completed_percent(project_id: task.project_id) if task.save
    task
  end

  def update(params, task_id:)
    task = find_task(task_id: task_id)
    task.update(params)
    update_project_completed_percent(project_id: task.project_id)
    task
  end

  def destroy(task_id:, project_id:)
    task = find_task(task_id: task_id)
    task.destroy
    update_project_completed_percent(project_id: project_id)
  end

  def change_status(task_id:)
    task = find_task(task_id: task_id)
    raise TaskNotFoundException if task.blank?
    task_update(task, state: !task.state)
    update_project_completed_percent(project_id: task.project_id)
  end

  private

  def find_task(task_id:)
    Task.find_by(id: task_id)
  end

  def task_update(task, args)
    task.update(args)
    task
  end

  def update_project_completed_percent(project_id:)
    project_service.update_completed_percent(project_id: project_id)
  end

  def project_service
    ProjectService.new
  end
end