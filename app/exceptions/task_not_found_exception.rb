class TaskNotFoundException < StandardError 
    def initialize(message = 'Task not found')
        super(message)
    end
end