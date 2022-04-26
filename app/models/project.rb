class Project < ApplicationRecord
    has_many :tasks, dependent: :destroy # https://guides.rubyonrails.org/association_basics.html Tenho um projeto que detém tasks, não posso deletar o projeto sem deletar as tasks. Indicar que ele vai destruir os dependentes.

    validates :title, presence: true, length: { maximum: 255 }
end
