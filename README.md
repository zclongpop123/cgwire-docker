## Introduction

- Install docker

  https://mirrors.tuna.tsinghua.edu.cn/help/docker-ce/

- Install docker-compose

  https://docs.docker.com/compose/install/


- Clone this repo
  ```
  git clone https://github.com/zclongpop123/cgwire-docker.git
  ```

- Build image
  ```
  docker build -t cgwire .
  ```

- Start container
  ```
  docker-compose up -d cgwire
  ```
 
 - Create Database and DB user
   ```
   su - postgres
   ```
   ```
   psql
   ```
   ```
   CREATE USER cgwire_db_user;
   ```
   ```
   CREATE DATABASE cgwire;
   ```
   ```
   GRANT ALL PRIVILEGES ON DATABASE cgwire_db TO cgwire_db_user;
   ```
   ```
   \password cgwire_db_user;
   ```
