class Task < ApplicationRecord
  belongs_to :project

  def human_state
    self.state ? "Concluded" : "Pending"
  end
end
