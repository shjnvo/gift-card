class V1::Brands::ProductsController < ApplicationController
  include Activatable

  before_action :set_product, only: %i[update destroy]

  def create
    product = Product.new(product_params)
    if product.save
      render json: product.to_json(only: %i[name price currency state customize_fields]), status: :created
    else
      render json: { message: product.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @product.update(product_params)
      render json: @product.to_json(only: %i[name price currency state customize_fields]), status: :ok
    else
      render json: { message: @product.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @product.destroy

    render json: { message: I18n.t('responce_message.product.deleted') }, status: :ok
  end

  private

  def product_params
    params.permit(:name, :brand_id, :price, :currency, :state, customize_fields: {})
  end

  def set_product
    @product = Product.find_by(id: params[:id])

    render status: :no_content unless @product
  end
end
