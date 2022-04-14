class Project < ApplicationRecord
    has_many :tasks

    validates :title, presence: true, length: { maximum: 255}
end
