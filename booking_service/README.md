Первый запуск (development)
1. Билд образа

docker-compose build
```
2. Создание, миграция, заполнение БД

```
docker-compose run --rm booking rails db:create db:migrate db:seed
```

3. Запуск микросервиса

```
docker compose up booking
```
