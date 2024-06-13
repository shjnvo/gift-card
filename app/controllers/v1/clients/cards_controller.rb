class V1::Clients::CardsController < ApplicationController
  skip_before_action :authenticate_user!

  before_action :set_client, only: %i[create cancel]
  before_action :check_product, only: %i[create]
  before_action :set_card, only: %i[cancel]

  def create
    card = @client.cards.build(card_params)
    if card.save
      fields = %i[id price currency]
      fields << (card.pin_code? ? :pin_code : :active_number)
      render json: card.to_json(only: fields), status: :created
    else
      render json: { message: card.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def cancel
    @card.cancelled!

    render json: { message: I18n.t('responce_message.card.cancel') }, status: :ok
  end

  private

  def card_params
    params.permit(:client_id, :product_id, :active_method, :pin_code)
  end

  def set_client
    @client = Client.find_by(id: params[:client_id], serect_key: params[:serect_key])
    json = { message: I18n.t('responce_message.card.client_incorrect') }

    render json:, status: :unprocessable_entity unless @client
  end

  def check_product
    product = @client.products.find_by(id: params[:product_id])

    json = { message: I18n.t('responce_message.card.product_no_existed') }
    render json:, status: :unprocessable_entity unless product&.available?
  end

  def set_card
    @card = @client.cards.spending.find_by(id: params[:id])
    json = { message: I18n.t('responce_message.card.id_incorrect') }

    render json:, status: :unprocessable_entity unless @card
  end
end
