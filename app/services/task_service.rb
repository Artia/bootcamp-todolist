class TaskService < ApplicationService
  def change_status(task_id:)
    task = find_task(task_id: task_id)
    raise TaskNotFoundException if task.blank?
    task = task_update(task, state: !task.state)
    task.save
    project_service.update_percent_complete(project_id: task.project_id)
  end

  def find_task(task_id:)
    Task.find_by(id: task_id)
  end

  def task_update(task, args = {})
    task.assign_attributes(args)
    task
  end

  def create(params:, project_id:)
    task = Task.new(params)
    task.project_id = project_id
    task
  end

  def update(params:, task_id:)
    task = find_task(task_id: task_id)
    raise TaskNotFoundException if task.blank?
    task.update(params)
    task    
  end

  def destroy
    task = Task.find(params[:id])
    task.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_task
      @task = Task.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def task_params
      params.require(:task).permit(:title, :date_start, :date_end, :state, :project_id)
    end

    def set_project
      @project = Project.find_by(id: params[:project_id].to_i)
    end

    def task_service
      @task_service ||= TaskService.new
    end

    def project_service
      @project_service ||= ProjectService.new
    end
  end