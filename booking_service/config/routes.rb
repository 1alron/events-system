require_relative "../app/api/base"


Rails.application.routes.draw do
    mount API::Base => "/"
end
