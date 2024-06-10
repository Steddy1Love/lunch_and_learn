class ApplicationController < ActionController::API
  # before_action :authorized

  # def current_user
  #   @current_user ||= User.find_by(api_key: request.headers['Authorization'])
  # end

  # def logged_in?
  #   !!current_user
  # end

  # def authorized
  #   render json: { message: 'Please log in' }, status: :unauthorized unless logged_in?
  # end
end
