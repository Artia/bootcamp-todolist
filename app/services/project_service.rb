class ProjectService < ApplicationService
    def update_percent_complete(project_id:)
        find_project(project_id: project_id).update(completed_percent: complete_percetage(project_id: project_id))
    end

    def complete_percetage(project_id:)
        info_tasks = Task.select("COUNT(*) as total_tasks, SUM(if(state = true, 1, 0)) as task_concluded").where(project_id: project_id).first
        (info_tasks.task_concluded.to_f / info_tasks.total_tasks.to_f) * 100
    end

    def project_destroy(project)
        has_tasks = Task.select("COUNT(*)").where(project_id: project.id).first
        if (has_tasks)
            Task.where(project_id: project.id).destroy_all
        end
        project.destroy
    end

    def create(project_params:)
        project = Project.new(project_params)
        project
    end

    def update
        project = find_project(project_id: params[:id])
        project.update(params)
        project
    end

    def destroy(project_id:)
        project = find_project(project_id: project_id)
        project.destroy
    end


    private

    def find_project(project_id:)
        Project.find_by(id: project_id)
    end

end