class CLI

attr_accessor :start_resp

  def greet_user
    puts "Welcome to the Nutrition Analyzer. You can get nutritional info from a list of ingredients. \n\n"
    #@recipe_name = self.prompt_for_recipe_name
    recipe = Recipe.new(self.prompt_for_recipe_name)
    recipe.serves = self.prompt_for_yield
    self.prompt_for_ingredient(recipe)
  end
  
  def prompt_for_recipe_name
    puts "Please enter a recipe name:"
    title = gets.chomp
    title.length <=0 ? self.prompt_for_recipe_name : title
  end

  def prompt_for_yield
    puts "Please enter the number this recipe serves"
    serves = gets.chomp.to_i
    serves <= 0 ? self.prompt_for_yield : serves
  end

  def prompt_for_ingredient(recipe)
    puts "\n"
    puts 'Enter ingredient using the following format (exclude quotes): "qty" "unit_of_measure ingredient" -or- "count" "ingredient".'
    puts "Type \"help\" to see measurement abbreviations or \"example\" to see an example entry. Type \"finished\" to complete recipe.\n\n"
    unvalidated_ingredient = gets.chomp
    self.validate_ingredient(unvalidated_ingredient, recipe)
    #@controller.validate_ingredient(@ingredient_from_cli)
  end

  def validate_ingredient(ingredient, recipe)
    
    ingredient = ingredient.downcase
    if ingredient == "exit"
      puts "Good bye!"
    elsif ingredient == "help" || ingredient == "example"
      user_help_message("ingredient_#{ingredient}")
    elsif ingredient == "finished"
      self.finish_recipe(recipe)

      #need to validate the ingredient within the recipe object
    else
      validated = recipe.validate_ingredient(ingredient)
      if validated
        prompt_for_ingredient(recipe)
      else
        user_help_message("ingredient_reject")
      end

    end
    
  end

  def finish_recipe(recipe)
    puts "Here is the completed entry: \n\n"
    pp @ingredient_list
    puts "Sending recipe to EDAMAM's nutrition analyzer. Please stand by..."
    error = recipe.fetch

    if error
      user_help_message(error)
    else
      print_nutrition_info(recipe)
    end

  end
  

  def user_help_message(type)
    case type
    when "ingredient_help"
      puts "\n\nWeights: #{["mg", "gr", "oz", "lbs"]join(', ')} Volumes: #{["ml", "l", "tsp", "tbsp", "c"].join(', ')}.\n\n"
      self.prompt_for_ingredient
    when "ingredient_example"
      puts "\n\n\"3 tbsp brown sugar\" -or- \"1 carrot\" -or- \"1/2 medium onion\"\n\n"
      self.prompt_for_ingredient
    when "ingredient_reject"
      puts "validate_ingredient ELSE TRIGGERED by #{@ingredient_from_cli}"
      puts "\n\nThe last entry was invalid. Please try again...\n\n"
      self.prompt_for_ingredient
    when "url_mistyped"
      puts "\"#{@start_resp}\" invalid response. Please enter \"site\" or \"recipe\". To quit, type \"exit\"."
      @start_resp = gets.chomp
      self.select_workflow
    when "response_404"
      puts "The service is not found. Please try again later."
    when "response_422", "response_555"
      puts "the service could not processess the recipe. Please try again ensuring that you spell all ingredients properly"
    when "response_other"
      puts "The service errored out. Ensure that your APP_KEY and AP_ID are correct."
    end
  end

  def print_nutrition_info(recipe)

    info = recipe.nutrition_info
    
    total = info["totalNutrients"]
    daily = info["totalDaily"]
    print"\n"
    puts "Recipe Nutrition Info"
    puts "#{info["yield"]} servings"
    puts "Calories per serving: #{(total["ENERC_KCAL"]["quantity"]/recipe.serves).round(0)}"
    50.times { print "-"}
    print"\n"
    37.times {print " "}
    puts "% Daily Value"
    34.times {print " "}
    puts "of 2000 cal diet"
    print"\n"
    total.each do |key, val|
      if key != "ENERC_KCAL" && key != "WATER" && key != "FATRN" && key != "FAMS" && key !="FAPU" && key != "SUGAR" && key != "FOLFD" && key != "FOLAC"
      
        absolute  = "#{val['label']}: #{(val['quantity']/recipe.serves ).round(1)} #{val['unit']}"
        rda = "#{(daily[key]['quantity']/recipe.serves).round(1)}%"
        line_length = absolute.length + rda.length
        dots = ""
        if line_length < 50
          line_length = 50 - line_length
        end
        line_length.times { dots << "."}
        puts "#{absolute}#{dots}#{rda}"
      elsif key == "FATRN" || key == "FAMS" || key == "FAPU" || key == "SUGAR"
        puts "#{val['label']}: #{(val['quantity']/recipe.serves).round(1)} #{val['unit']}...BOOO!!"
      end
    end
  end

end