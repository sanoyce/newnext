module Stateful
  extend ActiveSupport::Concern

  included do
    validate :status_in_statuses
    before_save :set_status_ats
  end

  STATUSES = Hash['Active', 1, 'Done', 3, 'Someday', 2, 'Cancelled', 4]
    
  def allowed_statuses
    if children.any?{|c| c.status == 'Active'}
      ['Active']
    else
      STATUSES.keys
    end
  end

  def status_in_statuses
    errors.add(:base, "Status must exist in allowed statuses") unless allowed_statuses.include?(self.status)
  end

  def status_sort
    STATUSES[status]
  end
  
  def set_status_ats
    self.send("#{self.status.downcase}_at=", DateTime.now) unless self.send("#{self.status.downcase}_at")
    (STATUSES.keys - [self.status]).each do |s|
      self.send("#{s.downcase}_at=", nil) if self.send("#{s.downcase}_at")
    end
  end
end