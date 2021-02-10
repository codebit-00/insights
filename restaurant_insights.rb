require "colorize"
require "terminal-table"
require "readline"
require_relative "dbmanager"
require_relative "colorization"

class Insight
  MENU = {
    "1" => {
      title: "List of restaurants",
      description: "List of restaurants included in the research filter by[''| category=string | city=string]",
      method: "list_restaurants"
    },
    "2" => {
      title: "List of dishes",
      description: "List of unique dishes included in the research",
      method: "list_dishes"
    },
    "3" => {
      title: "Number and distribution of clients",
      description: "Number and distribution (%) of clients by [group=[age | gender | occupation | nationality]]",
      method: "distribution_clients_by"
    },
    "4" => {
      title: "Top 10 restaurants by visitors",
      description: "Top 10 restaurants by the number of visitors.",
      method: "top_by_visitors"
    },
    "5" => {
      title: "Top 10 restaurants by sales",
      description: "Top 10 restaurants by the sum of sales.",
      method: "top_by_sales"
    },
    "6" => {
      title: "Top 10 restaurants by average expense per user",
      description: "Top 10 restaurants by the average expense of their clients.",
      method: "top_by_average_expense_user"
    },
    "7" => {
      title: " Average consumer expenses",
      description: "The average consumer expense group by [group=[age | gender | occupation | nationality]]",
      method: "average_consumer_expenses_by"
    },
    "8" => {
      title: "Total sales by month",
      description: "The total sales of all the restaurants group by month [order=[asc | desc]]",
      method: "total_sales"
    },
    "9" => {
      title: "Best price for dish",
      description: "The list of dishes and the restaurant where you can find it at a lower price",
      method: "price_by_dish"
    },
    "10" => {
      title: "Favorite dish",
      description: "The favorite dish for [age=number | gender=string | occupation=string | nationality=string]",
      method: "find_favourite_dish_by"
    }
  }.freeze

  def initialize
    @dbmanager = DBManager.new
  end

  def print_welcome
    puts "Welcome to the Restaurants Insights!"
    puts "Write 'menu' at any moment to print the menu again and 'quit' to exit."
  end

  def print_menu
    puts "---
    1. List of restaurants included in the research filter by[''| category=string | city=string]
    2. List of unique dishes included in the research
    3. Number and distribution (%) of clients by [group=[age | gender | occupation | nationality]]
    4. Top 10 restaurants by the number of visitors.
    5. Top 10 restaurants by the sum of sales.
    6. Top 10 restaurants by the average expense of their clients.
    ---
    Pick a number from the list and an [option] if neccesary".colorize_text
  end

  def start
    print_welcome
    print_menu
    while (line = Readline.readline("> ", true))
      action, parameter = line.split
      case action
      when "menu" then print_menu
      when "quit" then exit(1)
      else run_query(action, parameter)
      end
      print_menu
    end
  end

  def run_query(action, parameter)
    if MENU.key? action
      method = MENU[action][:method]
      params = parameter ? [method, parameter] : [method]
      res = @dbmanager.send(*params)
      puts Terminal::Table.new(title: MENU[action][:title], headings: res.fields, rows: res.values).to_s.colorize_table
    else
      puts "Invalid option"
    end
  end
end

app = Insight.new
app.start
