docker-compose exec mariadb mysql --user=root --password=mariadb -e "DROP USER IF EXISTS '%1'@'localhost', '%1'@'%';"
docker-compose exec mariadb mysql --user=root --password=mariadb -e "DROP DATABASE IF EXISTS %1;"
docker-compose exec mariadb mysql --user=root --password=mariadb -e "SHOW DATABASES;"
