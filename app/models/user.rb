class User < ApplicationRecord
  has_secure_password

  has_many :flight_schools, dependent: :destroy

  validates :email, presence: true, uniqueness: true,
            format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :role, inclusion: { in: %w[owner], allow_blank: true }

  before_validation :set_default_role, on: :create

  private

  def set_default_role
    self.role ||= "owner"
  end
end
