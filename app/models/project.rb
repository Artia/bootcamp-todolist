class Project < ApplicationRecord
    has_many :tasks, dependent: :destroy

    validates :title, presence: true, length: { maximum: 255 }

    def format_percent 
        "#{self.completed_percent.to_f.round(2)}%"
    end
end
