class TaskService < ApplicationService
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