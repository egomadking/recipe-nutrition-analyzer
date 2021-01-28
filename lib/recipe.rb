class Recipe
  attr_accessor :name, :ingredients, :serves, :nutrition_info

  @@all = []

  def initialize(name)
    @name = name
    @ingredients = []
    @@all << self
  end

  def self.all
    @@all
  end

  def format_req_body
    {
      "title" => name,
      "yield" => serves,
      "ingr" => ingredients
    }
  end

  def fetch
    resp = Fetcher.init_and_send(format_req_body)
    case resp.code
    when "200"
      self.nutrition_info = JSON.parse(resp.read_body)
      nil
    when "404"
      #not found
      "response_404"
    when "422"
      #unprocessable
      "response_422"
    when "555"
      #insufficient qalility
      "response_555"
    else
      "response_other"
    end
  end

  def validate_ingredient(ingredient)
    ingredient_split = ingredient.split(" ")
    if ingredient_split.length <=1 || ingredient_split[0].to_i <= 0
      false
    #match number or float
    elsif ingredient_split[0].match?(/\d+$/)
      ingredients << ingredient
    #match fraction
    elsif ingredient_split[0].match?(/\d*\/\d*$/)
      numerator, denominator = ingredient_split[0].split("/")
      ingredient_split[0] = (numerator.to_f / denominator.to_f).round(2)
      ingredient = ingredient_split.join(" ")
      ingredients << ingredient
    else
      false
    end
  end
end