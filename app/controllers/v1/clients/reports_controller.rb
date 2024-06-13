class V1::Clients::ReportsController < V1::Clients::ApplicationController
  before_action :set_client, only: :index

  def index
    spendings = @client.cards.spending.where(updated_at: date_ranges)
    cancellations = @client.cards.cancelled.where(updated_at: date_ranges)

    render json: {
      total_spendings: spendings.count,
      total_cancellations: cancellations.count,
      spendings: spendings.to_json,
      cancellations: cancellations.to_json
    }
  end

  private

  def date_ranges
    start_date = params[:start_date] || 1.month.ago.to_date
    end_date = params[:end_date] || Date.current
    start_date.to_date..end_date.to_date
  end
end
