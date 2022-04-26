class Task < ApplicationRecord
  belongs_to :project

  validates :title, presence: true, length: { maximum: 255 }
  validates :date_start, presence: true
  validates :date_end, presence: true
  validate :validate_dates

  def human_state
    self.state ? "Concluded" : "Pending"
  end

  def deadline_validation
    if self.state
      "Yay, you completed! check State!"
    elsif Time.now > self.date_end
      "Overdue, get ready for your supervisor's call!"
    else
      @diff_hours = ((self.date_end.to_time - Time.now.to_time) / 3600).round
      "No worries, you still have time. You have about #{@diff_hours} hours left ;)"
    end 
  end

  private

  def validate_dates
    if self.date_start.present? && self.date_end.present? && self.date_start > self.date_end
      self.errors.add(:date_start, 'cannot be greater than the end date')
    end
  end
end
