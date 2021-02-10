DROP TABLE IF EXISTS clients CASCADE;
CREATE TABLE clients (
  id serial primary key,
  name varchar(50) not null,
  age int not null check(age > 0),
  gender varchar(25),
  occupation varchar(50),
  nationality varchar(50),
  check (gender in ('Male', 'Female'))
);

DROP TABLE IF EXISTS restaurants CASCADE;
CREATE TABLE restaurants (
  id serial primary key,
  name varchar(50) not null,
  category varchar(50) not null,
  city varchar(50) not null,
  address varchar(50) not null
);

DROP TABLE IF EXISTS dishes CASCADE;
CREATE TABLE dishes (
  id serial primary key,
  name varchar(50) not null
);

DROP TABLE IF EXISTS dishes_restaurants CASCADE;
CREATE TABLE dishes_restaurants (
  id serial primary key,
  price_dish int not null check(price_dish > 0),
  dish_id int not null references dishes(id),
  restaurant_id int not null references restaurants(id)
);

DROP TABLE IF EXISTS visits;
CREATE TABLE visits (
  id serial primary key,
  visit_date date not null,
  client_id int not null references clients(id),
  dishes_restaurants_id int not null references dishes_restaurants(id)
);