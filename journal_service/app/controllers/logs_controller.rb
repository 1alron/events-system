class LogsController < ApplicationController
  def index
    logs = EntryLog.all

    logs = logs.where(ticket_id: params[:ticket_id]) if params[:ticket_id]
    logs = logs.where(action: params[:type]) if params[:type]
    logs = logs.where(successful: params[:successful]) if params[:successful]
    logs = logs.where("full_name ILIKE ?", "%#{params[:full_name]}%") if params[:full_name]
    logs = logs.where("occurred_at >= ?", params[:from]) if params[:from]
    logs = logs.where("occurred_at <= ?", params[:to]) if params[:to]

    render json: {
      logs: logs.order(occurred_at: :desc).map do |log|
        {
          time: log.occurred_at,
          full_name: log.full_name,
          type: log.action,
          successful: log.successful,
          message: log.message
        }
      end
    }
  end
end