class V1::Clients::ApplicationController < ApplicationController
  skip_before_action :authenticate_user!

  private

  def set_client
    @client = Client.find_by(id: params[:client_id], serect_key: params[:serect_key])
    json = { message: I18n.t('responce_message.card.client_incorrect') }

    render json:, status: :unprocessable_entity unless @client
  end
end
