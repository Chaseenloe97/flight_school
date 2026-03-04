class Aircraft < ApplicationRecord
  belongs_to :flight_school
  has_many :downtime_events, dependent: :destroy
  has_many :maintenance_logs, dependent: :destroy

  validates :tail_number, presence: true
  validates :model, presence: true
  validates :status, inclusion: { in: %w[available down], allow_blank: true }

  before_validation :set_default_status, on: :create

  def available?
    !currently_down?
  end

  def currently_down?
    downtime_events.where("started_at <= ? AND (ended_at IS NULL OR ended_at >= ?)", Time.current, Time.current).exists?
  end

  def current_status
    currently_down? ? "down" : "available"
  end

  def active_downtime_event
    downtime_events.where("started_at <= ? AND (ended_at IS NULL OR ended_at >= ?)", Time.current, Time.current).order(started_at: :desc).first
  end

  private

  def set_default_status
    self.status ||= "available"
  end
end
