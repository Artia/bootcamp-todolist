class ProjectService < ApplicationService
    def update_percent_complete(project_id:)
        find_project(project_id: project_id).update(completed_percent: complete_percetage(project_id: project_id))
    end

    def complete_percetage(project_id:)
        info_tasks = Task.select("COUNT(*) as total_tasks, SUM(if(state = true, 1, 0)) as task_concluded").where(project_id: project_id).first
        (info_tasks.task_concluded.to_f / info_tasks.total_tasks.to_f) * 100
    end

    private

    def find_project(project_id:)
        Project.find_by(id: project_id)
    end
end