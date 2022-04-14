class TaskService < ApplicationService

    def create task_params, project_id
        task = Task.new(task_params)
        task.project_id = project_id
        task.save
        project_service.update_percent_complete(project_id: task.project_id)
        task
    end

    def update(task_params, task_id, project_id)
        task = find_task(task_id: task_id)
        if task.update(task_params)
            task.save
            project_service.update_percent_complete(project_id: task.project_id)
            return true
        else
            return false
        end
    end

    def destroy (task_id, project_id)
        task = find_task(task_id: task_id)
        task.destroy
        project_service.update_percent_complete(project_id: project_id)
    end


    def change_status(task_id:)
        task = find_task(task_id: task_id)
        raise TaskNotFoundException if task.blank?
        task = task_update(task, state: !task.state)
        task.save
        project_service.update_percent_complete(project_id: task.project_id)
    end

    private

    def find_task(task_id:)
        Task.find_by(id: task_id)
    end

    def task_update(task, args = {})
        task.assign_attributes(args)
        task 
    end

    def project_service 
        @project_service ||= ProjectService.new 
    end
end