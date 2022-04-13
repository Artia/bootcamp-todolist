class Project < ApplicationRecord
    has_many :tasks, dependent: :destroy

    #Faz uma validação para que o nome do projeto seja inserido e não em branco
    validates :title, presence: true, length: { maximum: 255 }
end
