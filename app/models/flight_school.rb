class FlightSchool < ApplicationRecord
  belongs_to :user
  has_many :aircrafts, dependent: :destroy

  validates :name, presence: true
end
