class V1::SessionsController < ApplicationController
  skip_before_action :authenticate_user!, only: :create

  def create
    if (user = user_authenticaton!)
      jwt_token = JwtService.encode({ user_token: user&.generate_token! })
      render json: { email: user.email, token: jwt_token }, status: :ok
    else
      render json: { message: I18n.t('responce_message.uncorrect') }, status: :unauthorized
    end
  end

  def destroy
    current_user&.revoke_token!
    render json: { message: I18n.t('responce_message.logout_success') }, status: :ok
  end

  private

  def login_params
    params.permit(:email, :password)
  end

  def user_authenticaton!
    user = User.find_by(email: login_params[:email])
    user&.authenticate(login_params[:password])
  end
end
