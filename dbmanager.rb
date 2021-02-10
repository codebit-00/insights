require "pg"

class DBManager
  def initialize
    @db = PG.connect(dbname: "insights")
  end

  def list_restaurants(*params)
    query = %()
    if params.empty?
      query = %(SELECT name, category, city FROM restaurants)
    else
      column, value = params[0].split("=")
      query = %( SELECT name, category, city FROM restaurants
        WHERE LOWER\(#{column}\) LIKE LOWER\('#{value}'\))
    end
    @db.exec(query)
  end

  def list_dishes
    query = %(SELECT name FROM dishes)
    @db.exec(query)
  end

  def distribution_clients_by(param)
    _column, value = param.split("=")

    query = %(SELECT #{value}, COUNT(#{value}) AS count,
    CONCAT(ROUND(count(#{value})*100.00/499.00), '%') AS percentage
    FROM clients
    GROUP BY #{value}
    ORDER BY #{value};)

    @db.exec(query)
  end

  def top_by_visitors
    query = %(SELECT DISTINCT restaurants.name as name,
    COUNT(visits.visit_date) as visitors
    FROM visits
    JOIN dishes_restaurants
    ON visits.dishes_restaurants_id = dishes_restaurants.id
    JOIN restaurants
    ON dishes_restaurants.restaurant_id = restaurants.id
    GROUP BY restaurants.name
    ORDER BY visitors DESC LIMIT 10;)

    @db.exec(query)
  end

  def top_by_sales
    query = %(
      SELECT name, sum(price_dish) as sales FROM \(
        SELECT v.visit_date, r.name, dr.price_dish FROM restaurants as r
          JOIN dishes_restaurants as dr ON dr.restaurant_id=r.id
          JOIN visits as v ON v.dishes_restaurants_id=dr.id
      \) as tmp
      GROUP BY name
      ORDER BY sales desc LIMIT 10;
    )
    @db.exec(query)
  end

  def top_by_average_expense_user
    query = %(
      SELECT name, cast\(avg\(price_dish\) as decimal\(3,1\)\) as avg_expense FROM \(
        SELECT v.visit_date, r.name, dr.price_dish FROM restaurants as r
          JOIN dishes_restaurants as dr ON dr.restaurant_id=r.id
          JOIN visits as v ON v.dishes_restaurants_id=dr.id
      \) as tmp
      GROUP BY name
      ORDER BY avg_expense desc LIMIT 10;
    )
    @db.exec(query)
  end

  def average_consumer_expenses_by(param)
    _column, value = param.split("=")

    query = %(SELECT DISTINCT clients.#{value} AS #{value},
    ROUND(AVG(dishes_restaurants.price_dish),2) AS "avg expense"
    FROM visits
    JOIN dishes_restaurants
    ON visits.dishes_restaurants_id = dishes_restaurants.id
    JOIN clients
    ON visits.client_id = clients.id
    GROUP BY #{value};)

    @db.exec(query)
  end

  def total_sales(param)
    _column, value = param.split("=")

    query = %(SELECT
    to_char(v.visit_date, 'month') AS month,
    sum(dr.price_dish) AS total
    from visits v inner join dishes_restaurants dr on v.dishes_restaurants_id = dr.id
    GROUP BY 1 ORDER BY sum(dr.price_dish) #{value};)

    @db.exec(query)
  end

  def price_by_dish; end

  def find_favourite_dish_by; end
end

# db = DBManager.new
