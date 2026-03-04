class MaintenanceLog < ApplicationRecord
  belongs_to :aircraft

  validates :logged_at, presence: true
  validates :log_type, presence: true,
            inclusion: { in: %w[routine inspection repair overhaul other] }
end
