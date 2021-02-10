require "csv"
require "pg"

filename = ARGV.shift

DB = PG.connect(dbname: "insights")

def take_client_data(row)
  {
    name: row["client_name"],
    age: row["age"],
    gender: row["gender"],
    occupation: row["occupation"],
    nationality: row["nationality"]
  }
end

def take_restaurant_data(row)
  {
    name: row["restaurant_name"],
    category: row["category"],
    city: row["city"],
    address: row["address"]
  }
end

def take_dish_data(row)
  {
    name: row["dish"]
  }
end

def take_dish_restaurant_data(row, restaurant, dish)
  {
    price_dish: row["price"],
    dish_id: dish["id"],
    restaurant_id: restaurant["id"]
  }
end

def take_visit_data(row, client, dish_restaurant)
  {
    visit_date: row["visit_date"],
    client_id: client["id"],
    dishes_restaurants_id: dish_restaurant["id"]
  }
end

def create(table, data)
  data.transform_values! { |value| "'#{value.gsub("'", "''")}'" }
  res = DB.exec("INSERT INTO #{table} (#{data.keys.join(',')}) VALUES (#{data.values.join(',')}) RETURNING *;")
  res.first
end

def find(table, column, value)
  value = "'#{value.gsub("'", "''")}'"
  res = DB.exec("SELECT * from #{table} where #{column} = #{value};")
  res.first
end

def find_or_create(table, column, data)
  find(table, column, data[column.to_sym]) || create(table, data)
end

CSV.foreach(filename, headers: true) do |row|
  client_data = take_client_data(row)
  client = find_or_create("clients", "name", client_data)

  restaurant_data = take_restaurant_data(row)
  restaurant = find_or_create("restaurants", "name", restaurant_data)

  dish_data = take_dish_data(row)
  dish = find_or_create("dishes", "name", dish_data)

  dish_restaurant_data = take_dish_restaurant_data(row, restaurant, dish)
  dish_restaurant = create("dishes_restaurants", dish_restaurant_data)

  visits_data = take_visit_data(row, client, dish_restaurant)
  create("visits", visits_data)
end
