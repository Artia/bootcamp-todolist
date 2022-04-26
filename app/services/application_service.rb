class ApplicationService
    def time
        @time = Time.new
        self.strftime("%d/%m/%Y %H:%M:%S")
        self.zone("-03:00")
        self.localtime
    end
end