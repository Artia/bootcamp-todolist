class Task < ApplicationRecord
  belongs_to :project

  validates :title, presence: true, length: { maximum: 255 }
  validates :date_start, presence: true
  validates :date_end, presence: true
  validate :validate_dates

  def human_state 
    self.state ? 'Concluded' : 'Pending'
  end

  def formated_start_date
    "#{self.date_start.strftime("%d/%m/%Y %H:%M")}"
  end

  def formated_end_date
    "#{self.date_end.strftime("%d/%m/%Y %H:%M")}"
  end

  def deadline_status
    date_now = Time.now - 10800
    if self.formated_end_date < date_now && self.human_state == 'Pending'
      return "Tarefa atrasada"
    elsif self.human_state == 'Concluded'
      return "Tarefa finalizada"
    else
      return "Tarefa em dia"
    end
  end

  private

  def validate_dates
    if self.date_start.present? && self.date_end.present? && self.date_start > self.date_end
      self.errors.add(:date_start, 'cannot be greater than the end date')
    end
  end
end
