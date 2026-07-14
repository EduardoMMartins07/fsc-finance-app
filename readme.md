## Comando para criar o container docker:

docker run -d \
--name finance-app-postgres \
-e POSTGRES_PASSWORD=password \
-e POSTGRES_USER=root \
-e POSTGRES_DB=financeapp \
-v ~/finance-app-api/.postgres:/var/lib/postgresql \
-p 5432:5432 \
postgres
