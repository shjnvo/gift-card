class V1::Clients::CardsController < V1::Clients::ApplicationController
  before_action :set_client, only: %i[create cancel]
  before_action :check_product, only: %i[create]
  before_action :set_card, only: %i[cancel]

  def create
    card = @client.cards.build(card_params)
    if card.save
      render json: card.to_json(only: %i[id price currency pin_code]), status: :created
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
    params.permit(:client_id, :product_id, :pin_code)
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
