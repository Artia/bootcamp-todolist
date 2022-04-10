class TaskService < ApplicationService

    def create(params, project_id:)
        task = Task.new(params)
        task.project_id = project_id
        
        task
    end

    def update(task:, params:)
        task.update(params)

        task
    end

    def destroy(task:, project_id:)
        task = find_task(task_id: task.id)
        task.destroy 
        project_service.update_percent_complete(project_id)
    end
    
    def change_status(task_id:)
        task = find_task(task_id: task_id)

        raise TaskNotFoundException if task.blank?
        
        update_task(task, state: !task.state)
        task.save
        project_service.update_percent_complete(task.project_id)
    end

    private

    def find_task(task_id:)
        Task.find_by(id: task_id)
    end

    def update_task(task, args = {})
        task.assign_attributes(args)
        task
    end

    def project_service
        @project_service ||= ProjectService.new
    end
end