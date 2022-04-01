class ProjectService < ApplicationService
  def update_completed_percent(project_id:)
    project = find_project(project_id: project_id)

    if project.present?
      completed_percent = completed_percent(project_id: project_id)
      project.update(completed_percent: completed_percent)
    end
  end

  def completed_percent(project_id:)
    # Calculando pelo ruby
    # tasks = Task.where(project_id: project_id)
    # total = tasks.count
    # total_concluded = tasks.count { |t| t.state }
    # (total_concluded.to_f / total.to_f) * 100

    # Calculando pelo sql
    info_tasks = info_tasks(project_id: project_id)
    
    return 0 if info_tasks.total_tasks.to_f.zero?
    (info_tasks.tasks_concluded.to_f / info_tasks.total_tasks.to_f) * 100
  end

  private

  def info_tasks(project_id:)
    Task.select("COUNT(*) as total_tasks, SUM(if(state = true, 1, 0)) as tasks_concluded").where(project_id: project_id).first
  end

  def find_project(project_id:)
    Project.where(id: project_id).first
  end
end

  