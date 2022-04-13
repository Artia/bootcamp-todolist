class Project < ApplicationRecord
    has_many :tasks

    validates :title, presence: true, length: {minimum:3, maximum:255}

    def percentage_format
        "#{self.completed_percent.to_i}%"
    end
end
