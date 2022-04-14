class ProjectNotFoundException < StandardError
    def initialize(message = 'Project not found')
        super(message)
    end
end