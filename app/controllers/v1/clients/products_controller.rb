class V1::Clients::ProductsController < ApplicationController
  before_action :set_client, only: %i[create]
  before_action :check_products, only: %i[create]

  def create
    @products.each do |product|
      Client::Product.create!(client: @client, product:, user: current_user)
    end

    render json:
      @client.to_json(
        only: %i[name email payout_rate], include: { products: { only: %i[name price currency] } }
      ), status: :created
  end

  private

  def check_products
    @products = Product.includes(:brand).where(id: params[:product_ids] - @client.products.pluck(:id))
    invalid = @products.find { !_1.available? }

    render json: { message: "Product id #{invalid.id} was unavailable" }, status: :unprocessable_entity if invalid
  end

  def set_client
    @client = Client.find_by(id: params[:client_id])

    render status: :no_content unless @client
  end
end
