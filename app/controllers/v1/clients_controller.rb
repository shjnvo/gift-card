class V1::ClientsController < ApplicationController
  def create
    client = current_user.clients.build(client_params)
    if client.save
      render json:
        client.to_json(
          only: %i[name email payout_rate serect_key]
        ), status: :created
    else
      render json: { message: client.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def client_params
    params.permit(:email, :name, :payout_rate)
  end
end
