class ProjectService < ApplicationService
    def update_completed_percent(project_id:)
      find_project(project_id: project_id).update(completed_percent: completed_percent(project_id: project_id))
    end
  
    def completed_percent(project_id:)
      # Calculando pelo ruby
      # tasks = Task.where(project_id: project_id)
      # total = tasks.count
      # total_concluded = tasks.count { |t| t.state }
      # (total_concluded.to_f / total.to_f) * 100
  
      # Calculando pelo sql
      info_tasks = Task.select("COUNT(*) as total_tasks, SUM(if(state = true, 1, 0)) as tasks_concluded").where(project_id: project_id).first
      (info_tasks.tasks_concluded.to_f / info_tasks.total_tasks.to_f) * 100
    end

    private

    def find_project(project_id:)
      Project.find_by(id: project_id)
    end
  end