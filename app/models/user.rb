class User < ApplicationRecord
  before_create :generate_api_key
  validate_presence_of :password_digest
  
  private

  def generate_api_key
    self.api_key = SecureRandom.hex(20)
  end
end
