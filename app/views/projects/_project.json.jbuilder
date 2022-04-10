json.extract! project, :id, :title, :completed_percent, :created_at, :updated_at
json.url project_url(project, format: :json)
