class Task < ApplicationRecord
  belongs_to :project

  #Validar obrigatoriedade de preenchimento nos campos de criação de task, utilizando validação nativa
  validates :title, presence: true, length: { maximum: 255 }
  validates :date_end, presence: true
  validates :date_start, presence: true

  #Validate é uma validação customizada
  validate :validate_dates

  def human_state
    self.state ? 'Concluded' : 'Pending'
  end

  def taskIsOnDeadline
    self.date_end < Date.today && self.state == false ? 'Pendente' : 'No prazo'
  end

  #Validar se a data de inicio for posterior a data de fim 
  private
  def validate_dates
    if self.date_start.present? && self.date_end.present? && self.date_start > self.date_end
      self.errors.add(:date_start, 'Date start cannot be greater than the end date.')
    end
  end
end
