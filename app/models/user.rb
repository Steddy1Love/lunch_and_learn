class User < ApplicationRecord
  has_secure_password
  before_create :generate_api_key
  has_many :favorites, dependent: :destroy

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 10 }, confirmation: true
  validates :password_confirmation, presence: true

  private

  def generate_api_key
    self.api_key = SecureRandom.hex(24)
  end
end
