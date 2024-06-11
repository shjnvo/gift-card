class V1::BrandsController < ApplicationController
  include Activatable

  def create
    brand = Brand.new(brand_params)
    if brand.save
      render json: brand.to_json(only: %i[name state customize_fields]), status: :created
    else
      render json: { message: brand.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def brand_params
    params.permit(:name, :state, customize_fields: {})
  end
end
