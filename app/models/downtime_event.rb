class DowntimeEvent < ApplicationRecord
  belongs_to :aircraft
  belongs_to :created_by, class_name: "User", foreign_key: :created_by_id

  validates :started_at, presence: true
  validates :reason_type, presence: true,
            inclusion: { in: %w[maintenance breakdown inspection other] }

  scope :active, -> { where("started_at <= ? AND (ended_at IS NULL OR ended_at >= ?)", Time.current, Time.current) }
  scope :past, -> { where("ended_at < ?", Time.current) }
  scope :upcoming, -> { where("started_at > ?", Time.current) }

  after_save :update_aircraft_status
  after_destroy :update_aircraft_status

  private

  def update_aircraft_status
    aircraft.update_column(:status, aircraft.current_status)
  end
end
