class ProjectService < ApplicationService

    def update_percent_complete(project_id:)
        find_project(project_id: project_id).update(completed_percent: complete_percentage(project_id: project_id))
    end

    def complete_percentage(project_id:)
        info_tasks = Task.select("COUNT(*) as total_tasks, SUM(if(state = true, 1, 0)) as task_concluded").where(project_id: project_id).first
        return 0 if info_tasks.total_tasks.zero?
        (info_tasks.task_concluded.to_f / info_tasks.total_tasks.to_f) * 100
    end

    def create(project_params:)
        project = Project.new(project_params)
        project
    end

    def update
        project = find_project(project_id: params[:id])
        raise ProjectNotFoundException if project.blank?
        project.update(params)
        project
    end

    def destroy
        project = Project.find(params[:id])
        project.destroy
    end
    
    private
    def find_project(project_id:)
        Project.find_by(id: project_id)
    end

    def project_params
        params.require(:project).permit(:title, :completed_percent)
    end

    def set_project
        @project = Project.find_by(id: params[:project_id].to_i)
    end
  
    def task_service
        @task_service ||= TaskService.new
    end
  
    def project_service
        @project ||= ProjectService.new
    end
end
