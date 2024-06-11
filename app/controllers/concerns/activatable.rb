module Activatable
  extend ActiveSupport::Concern

  included do
    before_action :set_resource, only: %i[activate inactivate]
  end

  def activate
    @resource.update(state: true)
    render json: { message: "#{resource_name} was successfully activated." }, status: :ok
  end

  def inactivate
    @resource.update(state: false)
    render json: { message: "#{resource_name} was successfully inactivated." }, status: :ok
  end

  private

  def set_resource
    @resource = controller_name.classify.constantize.find(params[:id])
  end

  def resource_name
    controller_name.singularize.capitalize
  end
end
