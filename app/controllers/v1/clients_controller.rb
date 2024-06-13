class V1::ClientsController < ApplicationController
  def create
    client = current_user.clients.build(client_params)
    if client.save
      # assign_client_products(client) if params[:product_ids]
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

  # def assign_client_products(client)
  #   products = Product.includes(:brand).where(id: params[:product_ids] - client.products.pluck(:id))
  #   products.each do |product|
  #     Client::Product.create!(client:, product:, user: current_user)
  #   end
  # end
end
