class Controller

  attr_accessor :cli, :ingredient_list, :fetcher, :req_body

  def initialize
    @ingredient_list = []
  end

  def validate_ingredient(ingredient)
    ingredient = ingredient.downcase
    if ingredient == "exit"
      puts "Good bye!"
    elsif ingredient == "help" || ingredient == "example"
      @cli.user_help_message("ingredient_#{ingredient}")
    elsif ingredient == "finished"
      self.finish_recipe
    else
      ingredient_split = ingredient.split(" ")
      #single word or entry that does not start with a number.
      if ingredient_split.length <=1 || ingredient_split[0].to_i <= 0
        @cli.user_help_message('ingredient_reject')

      #match number or float
      elsif ingredient_split[0].match?(/\d+$/)
        @ingredient_list << ingredient
        @cli.prompt_for_ingredient

      #match fraction
      elsif ingredient_split[0].match?(/\d*\/\d*$/)
        numerator, denominator = ingredient_split[0].split("/")
        ingredient_split[0] = (numerator.to_f / denominator.to_f).round(2)
        ingredient = ingredient_split.join(" ")
        @ingredient_list << ingredient
        @cli.prompt_for_ingredient
      else
        @cli.user_help_message('ingredient_reject')
      end
    end
    
  end

  def finish_recipe
    puts "Here is the completed entry: \n\n"
    pp @ingredient_list
    puts "Sending recipe to EDAMAM's nutrition analyzer. Please stand by..."
    self.fetch
  end

  def format_req_body
    @req_body = {
      "title" => @cli.recipe_name,
      "yield" => @cli.yield,
      "ingr" => []
    }
    @ingredient_list.each do |i|
      @req_body["ingr"] << i
    end
  end

  def fetch
    self.format_req_body
    @fetcher = Fetcher.init_and_send(self)
  end

  def response(resp)
    case resp.code
    when "200"
      @cli.print_nutrition_info(JSON.parse(resp.read_body))
    when "404"
      #not found
      @cli.user_help_message("response_404")
    when "422"
      #unprocessable
      @cli.user_help_message("response_422")
    when "555"
      #insufficient qalility
      @cli.user_help_message("response_555")
    else
      @cli.user_help_message("response_other")
    end
  end
end