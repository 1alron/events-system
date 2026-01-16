module API
  class Base < Grape::API
    prefix "api"
    format :json

    rescue_from ActiveRecord::RecordNotFound do |e|
      error!({ error: "Запись не найдена" }, 404)
    end

    rescue_from :all do |e|
      Rails.logger.error "API Error: #{e.message}\n#{e.backtrace.join("\n")}"
      error!({ error: "Внутренняя ошибка сервера" }, 500)
    end

    add_swagger_documentation(
      api_version: "v1",
      hide_documentation_path: true,
      hide_format: true,
      info: {
        title: "API",
        description: "API для системы мероприятий и билетов"
      }
    )

    # Явно загрузите модуль V1
    require_relative "v1/tickets"
    require_relative "v1/events"

    # Теперь можно монтировать
    mount API::V1::Tickets
    mount API::V1::Events

    # Дополнительные endpoint в base
    get :health do
      { status: "healthy", timestamp: Time.current.iso8601 }
    end
  end
end
