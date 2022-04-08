class Task < ApplicationRecord
  belongs_to :project

  validates :title, presence: true, length: { maximum: 255 }
  validates :date_start, presence: true
  validates :date_end, presence: true
  validate :validate_dates

  def human_state
    self.state ? "Concluído" : "Pendente"
  end

  def deadline_status
    return "Finalizada" if self.human_state == "Concluído"

    return "Prazo expirado" if self.date_end < Date.today

    return "Dentro do prazo"
  end

  private 

  def validate_dates
    if self.date_start.present? && self.date_end.present? && self.date_start > self.date_end
      self.errors.add(:date_start, "Can't be greater than date end")
    end
  end
end
