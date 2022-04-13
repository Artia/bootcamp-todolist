json.extract! task, :id, :title, :date_start, :date_end, :state, :project_id, :created_at, :updated_at
json.url task_url(task, format: :json)
