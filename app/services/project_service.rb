class  ProjectService < ApplicationService

  def change_status(task_id:)
    task = find_task(task_id: task_id)
    raise TaskNotFoundException if task.blank?
    task = task_update(task, state: !task.state)
    task.save
  end

  def update_percent_complete(project_id:)
    find_project(project_id: project_id).update(completed_percent: completed_percent(project_id: project_id))
  end

  def completed_percent(project_id:)
    info_tasks = Task.select("COUNT(*) as total_tasks, SUM(if(state = true, 1, 0)) as task_concluded").where(project_id: project_id).first
    
    return 0 if info_tasks.total_tasks.to_f.zero?
    # byebug
    (info_tasks.task_concluded.to_f / info_tasks.total_tasks.to_f) * 100
  end
  
  private
  
  def find_project(project_id:)
    Project.find_by(id: project_id)
  end
end

