class ProjectService < ApplicationService

    def create(params:)
        project = Project.new(params)
        project.completed_percent = 0
        
        project
    end

    def update(params:, project_id:)
        project = find_project(project_id: project_id)
        project.assign_attributes(params)
        project.save

        project
    end

    def destroy(project_id:)
        project = find_project(project_id: project_id)
        project.destroy
    end
    
    def update_percent_complete(project_id)
        find_project(project_id: project_id)
            .update(completed_percent: complete_percentage(project_id: project_id))
    end

    def complete_percentage(project_id:)
        info_tasks = Task.select("COUNT(*) as total_tasks, SUM(if(state = true, 1, 0)) as task_concluded").where(project_id: project_id).first

        return 0 if info_tasks.total_tasks == 0

        (info_tasks.task_concluded.to_f / info_tasks.total_tasks.to_f) * 100
    end

    private
    
    def find_project(project_id:)
        Project.find_by(id: project_id)
    end
end