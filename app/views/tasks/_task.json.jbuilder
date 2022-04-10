json.extract! task, :id, :title, :date_start, :date_end, :state, :Project_id, :created_at, :updated_at
json.url task_url(task, format: :json)
