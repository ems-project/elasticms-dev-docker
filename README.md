#Development environment for elasticms
##About this repository
This project contains a ready to use elasticms environment for development purposes with the following stack:

- elasticsearch (the heart of the solution)
- kibana (to see what happening in the heart)
- traefik (as middelware)
- postgres (as RDBMS)
- mariadb (as RDMBS in low cost infrastructure)
- sqlite (as "RDBMS" for portable, and single user, use)
- Apache Tika (to extract asset's contents)
- minio (as file storage, compatible with the AWS S3 API)
- redis (to store and share PHP session)
- elasticms (the ems content management application)
- skeleton (the ems content delivery application)

To work with the elastic stack version you want, from 5 and 7, open a console in one of the following folders:
- elastic5
- elastic7

If you want to switch from one version to the other execute ```docker-compose down``` before changing working directory. In order to ensure there is no conflict in processes name.

#Requirements
In order to have a working elasticsearch cluster you must have at least [4GB dedicated to you docker environment](https://github.com/elastic/elasticsearch/issues/51196). And you might also wants to check those [production recomandations](https://www.elastic.co/guide/en/elasticsearch/reference/current/docker.html#docker-prod-prerequisites).

##Baby step
###Launch docker-compose
The first thing to do is to start your environment:

```docker-compose up -d```

You can follow that everything is starting smoothly with:

```docker-compose logs -f```

Once it's started check that all is working:

```docker-compose ps```

Check the image's versions with the following command: ```docker-compose images```.

You might have notice that there are 3 instances of the elasticms: ems_mysql, ems_pgsql and ems_sqlite. The reason is that Symfony (the PHP framework behind elasticms), for performance reasons, generates cache files specific to the DB driver used. So you can't use the same instance of elasticms with different RDBMS. 


###Check elasticsearch cluster's health
Go to the [Kibana dev console](http://kibana.localhost/app/dev_tools#/console) and check the cluster health:
```json
GET _cluster/health
```

You should see something like:
```json
{
  "cluster_name" : "es-docker-cluster",
  "status" : "green",
  "timed_out" : false,
  "number_of_nodes" : 3,
  "number_of_data_nodes" : 3,
  "active_primary_shards" : 6,
  "active_shards" : 12,
  "relocating_shards" : 0,
  "initializing_shards" : 0,
  "unassigned_shards" : 0,
  "delayed_unassigned_shards" : 0,
  "number_of_pending_tasks" : 0,
  "number_of_in_flight_fetch" : 0,
  "task_max_waiting_in_queue_millis" : 0,
  "active_shards_percent_as_number" : 100.0
}
```
Note that you can also check cluster's health from the command line: ```docker-compose exec es01 curl http://localhost:9200/_cluster/health```

If the Kibana url is not working you should check that its route has been correctly registered in [Traefik](http://localhost:8888/dashboard/#/http/routers). On that page you should see those host rules:
- kibana.localhost
- tika.localhost
- minio.localhost
- es.localhost
- demo-admin.localhost

###Initiate databases
Here we will just initiate the database and the user. The database schema will be initiated later with the Symfony console. 
 
####Postgres
To initiate a postgres DB run ```../init_pgsql.sh demo``` or you can launch those commands:

```
docker-compose exec -e PGUSER=postgres -e PGPASSWORD=adminpg -T postgres psql -c "CREATE DATABASE demo;"
docker-compose exec -e PGUSER=postgres -e PGPASSWORD=adminpg -T postgres psql -c "CREATE USER demo WITH ENCRYPTED PASSWORD 'demo';"
docker-compose exec -e PGUSER=postgres -e PGPASSWORD=adminpg -T postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE demo TO demo;"
```

You can use the ``../drop_pgsql.sh demo`` to drop the database.

####MySQL
To initiate a postgres DB run ```./init_mysql.sh demo``` or you can launch those commands:

```
docker-compose exec mariadb mysql --user=root --password=mariadb -e "CREATE DATABASE IF NOT EXISTS demo;"
docker-compose exec mariadb mysql --user=root --password=mariadb -e "CREATE USER demo@'%' IDENTIFIED BY 'demo';"
docker-compose exec mariadb mysql --user=root --password=mariadb -e "GRANT ALL PRIVILEGES ON demo.* TO demo@'%';"
docker-compose exec mariadb mysql --user=root --password=mariadb -e "CREATE USER demo@'localhost' IDENTIFIED BY 'demo';"
docker-compose exec mariadb mysql --user=root --password=mariadb -e "GRANT ALL PRIVILEGES ON demo.* TO demo@'localhost';"
docker-compose exec mariadb mysql --user=root --password=mariadb -e "show databases;"
```
You can use the ``./drop_mysql.sh demo`` to drop the database.

###SQLite
There is nothing to do at this time.

###Other RDBMS
There is currently no support for other RDBMS, but if the RDBMS considered is currently [supported by doctrine](https://www.doctrine-project.org/projects/doctrine-dbal/en/2.10/reference/platforms.html) you will be able to easily generate the database schema as well. So up to you to create DB.      

##Instantiate the database's schema
To initialize an elasticms schema we will use the Symfony console to execute the doctrine migration scripts.


##To do's
- Add an email server docker image image in order to be able to debug emails
- Add a elastic6 docker-compose.yml file