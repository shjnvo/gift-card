# frozen_string_literal: true

class ApplicationController < ActionController::API
  before_action :authenticate_user!

  private

  def authenticate_user!
    render json: { message: I18n.t('responce_message.please_login') }, status: :unauthorized if current_user.blank?
  end

  def current_user
    token = request.headers['Authentication'].presence
    decode = JwtService.decode token
    return if decode.blank?

    @current_user ||= User.find_by(token: decode['user_token'])
  end
end
