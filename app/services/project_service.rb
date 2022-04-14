class ProjectService < ApplicationService 

    def create (project_params)
        Project.new(project_params)
    end

    def update (project_params, id)
        project = find_project(project_id: id).update(project_params)
        if project
            return true
        else 
            return false
        end
    end

    def destroy (id)
        find_project(project_id: id).destroy
    end

    def update_percent_complete(project_id:)
        find_project(project_id: project_id).update(completed_percent: completed_percentage(project_id: project_id))
    end

    def completed_percentage(project_id:)
        info_tasks = Task.select("COUNT(*) as total_tasks, SUM(if(state=true, 1, 0)) as task_concluded").where(project_id: project_id).first
        
        return 0 if info_tasks.total_tasks.to_f.zero?
        
        (info_tasks.task_concluded.to_f / info_tasks.total_tasks.to_f) * 100
    end

    private

    def find_project(project_id:)
        Project.find_by(id: project_id)
    end
end