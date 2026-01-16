# events-system
### Сборка:
```docker compose build```
### Формирование БД для брони:
```docker-compose run --rm booking rails db:create db:migrate db:seed```
### Запуск:
```docker compose up```
### Если не сохраняются файлы
```sudo chown -R $USER:$USER .```

### Регистрация
Можно отправить запрос вида:
```
  curl -X POST http://localhost:3003/users/register -H "Content-Type: application/json" -d '{
      "first_name": "Ivan",
      "second_name": "Petrov",
      "family_name": "Ivanovich",
      "age": "1994-01-01",
      "document_type": "passport",
      "document_number": "111111",
      "password": "password"
  }'
```

### Авторизация
Запрос вида:
```
  curl -X POST http://localhost:3003/users/login -H "Content-Type: application/json" -d '{
      "document_type": "passport",
      "document_number": "111111",
      "password": "password"
  }'
```
В случае успеха получим ответ вида:
```
    {
      "result":true
      "token":"eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjo0fQ.UWmeJanF_bZekt-gYXhQRDAAv9XpRsQtKzLKnIN2ue4",
      "user_id":4
    }
```
После этого мы можем использовать данный токен при запросах в виде заголовка, например:
```
  curl -v -X GET http://localhost:3003/users/1/reservations \
  -H "Authorization: eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjo0fQ.UWmeJanF_bZekt-gYXhQRDAAv9XpRsQtKzLKnIN2ue4"
```
