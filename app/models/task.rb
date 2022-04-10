class Task < ApplicationRecord
  belongs_to :project

  validates :title, presence: true, length: { maximum: 255 }
  validates :date_start, presence: true
  validates :date_end, presence: true
  validate :validate_dates

  def human_state
    self.state ? 'Concluded': 'Pending'
  end

  def human_date_start
    format_date(self.date_start)
  end

  def human_date_end
    format_date(self.date_end)
  end

  def is_task_late
    if self.state == true
      return 'bg-success bg-gradient'
    end
    if self.date_end < Time.now.utc 
      return 'bg-danger bg-gradient'
    end
    'bg-warning bg-gradient'
  end

  private

  def validate_dates
    if self.date_start.present? && self.date_end.present? && self.date_start > date_end
      self.errors.add(:date_start, 'cannot be greater than the end date')
    end
  end

  def format_date(date)
    date.strftime('%d/%m/%Y at %H:%M')
  end
end
