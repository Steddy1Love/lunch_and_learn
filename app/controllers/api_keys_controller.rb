class ApiKeysController < ApplicationController
  def show
    render json: { api_key: @user.api_key }
  end

  def regenerate
    @user.update(api_key: SecureRandom.hex(20))
    render json: { api_key: @user.api_key }
  end

  private

  # def set_user
  #   @user = User.find(params[:id])
  # end
end
