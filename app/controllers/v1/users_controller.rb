class V1::UsersController < ApplicationController
  skip_before_action :authenticate_user!

  def create
    user = User.new(user_params)
    if user.save
      render json: {
        email: user.email
      }, status: :created
    else
      render json: { message: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.permit(:email, :password)
  end
end
