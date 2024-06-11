class User < ApplicationRecord
  has_secure_password
  before_create :generate_api_key

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, confirmation: true
  validates :password_confirmation, presence: true

  def initialize(user_params)
    @name = user_params[:name]
    @email = user_params[:email]
    @password = user_params[:password]
  end
  private

  def generate_api_key
    self.api_key = SecureRandom.hex(24)
  end
end
