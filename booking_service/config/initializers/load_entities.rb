entities_path = Rails.root.join("app/api/entities")

# Сначала загружаем базовые entity
require entities_path.join("base.rb") if File.exist?(entities_path.join("base.rb"))

# Затем загружаем остальные в алфавитном порядке
Dir[entities_path.join("**/*.rb")].sort.each do |file|
  next if file.end_with?("base.rb")  # Пропускаем base.rb, если уже загрузили
  require file
end
