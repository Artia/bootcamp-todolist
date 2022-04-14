class TaskService < ApplicationService
    def create_task(task)
        is_saved = task.save
        is_saved
    end

    def destroy_task(task_id:)        
        task = find_task(task_id: task_id)
        raise TaskNotFoundException if task.blank?
        task.destroy
    end

    def edit_task(task_id:, task_params:)
        task = find_task(task_id: task_id)
        raise TaskNotFoundException if task.blank?
        task = task_update(task, task_params)
        task
    end
    
    def change_status(task_id:)
        task = find_task(task_id: task_id)
        raise TaskNotFoundException if task.blank?
        task = task_update(task, state: !task.state)
        task.save
    end
    
    private 

    def find_task(task_id:)
        Task.find_by(id: task_id)
    end

    def task_update(task, args = {})
        task.assign_attributes(args)
        task
    end
end