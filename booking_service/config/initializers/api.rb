api_path = Rails.root.join("app/api/**/*.rb")
Dir[api_path].each { |file| require file }
