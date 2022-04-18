class TaskService < ApplicationService
    def create_task(task_params:, project_id:)
        puts task_params[:timezone]
        task_params = normalize_time(task_params)
        task = Task.new(task_params)
        task.project_id = project_id
        task
    end

    def destroy_task(task_id:)        
        task = find_task(task_id: task_id)
        raise TaskNotFoundException if task.blank?
        task.destroy
    end

    def edit_task(task_id:, task_params:)
        task_params = normalize_time(task_params)
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

    def normalize_time(task_params) 
        task_params[:date_start] = Time.zone.parse(task_params[:date_start])
        task_params[:date_end] = Time.zone.parse(task_params[:date_end])
        task_params
    end
end