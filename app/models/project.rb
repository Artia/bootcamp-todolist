class Project < ApplicationRecord
    has_many :tasks, :dependent => :delete_all

    validates :title, presence: true, length: { maximum: 255 }

    def formated_percentage
        "#{self.completed_percent.to_f}%"
    end
end
