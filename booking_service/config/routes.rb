require_relative "../app/api/base"


Rails.application.routes.draw do
    mount API::Base => "/"
    if Rails.env.development?
        get "/routes" => redirect("/rails/info/routes")
    end
end
