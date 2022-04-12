class ProjectService < ApplicationService

    def project_create(project) 
        project.save ? true : false
    end

    def project_update(project_params, project_id:)
        project = find_project(project_id: project_id)
        if project.update(project_params)
            return true
        end
        false
    end

    def project_destroy(project)
        has_tasks = Task.select("COUNT(*)").where(project_id: project.id).first
        if (has_tasks)
            Task.where(project_id: project.id).destroy_all
        end
        project.destroy
    end

    def update_percent_complete(project_id:)
        find_project(project_id: project_id).update(completed_percent: complete_percentage(project_id: project_id))
    end

    def complete_percentage(project_id:)
        info_tasks = Task.select("COUNT(*) as total_tasks, SUM(if(state = true, 1, 0)) as task_concluded").where(project_id: project_id).first
        return 0 if info_tasks.total_tasks.to_f.zero?

        (info_tasks.task_concluded.to_f / info_tasks.total_tasks.to_f) * 100
    end

    private 
    def find_project(project_id:)
        Project.find_by(id: project_id)
    end
end