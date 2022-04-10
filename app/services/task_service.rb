class TaskService < ApplicationService
    def change_status(task_id:)
        task = find_task(task_id: task_id)
        raise TaskNotFoundExeception if task.blank?
        task = task_update(task, state: !task.state)
        task.save
        project_service.update_percent_complete(project_id: task.project_id)
    end

    private

    def find_task(task_id:)
        Task.find_by(id: task_id)
    end

    def task_update(task, arg = {})
        task.assign_attributes(arg)
        task
    end

    def project_service
        @project_service ||= ProjectService.new
    end
end