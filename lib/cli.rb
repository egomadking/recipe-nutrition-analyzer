class CLI
  
  def quit
    puts "Good bye!".bold
    exit
  end

  def greet_user
    puts "                                                                 ".black.on_green
    puts "                    The Nutrition Analyzer.                      ".black.on_green
    puts "  This tool provides nutrition info from a list of ingredients.  ".black.on_green
    puts "                                                                 ".black.on_green
    puts "\n"
    recipe = Recipe.new(self.prompt_for_recipe_name)
    recipe.serves = self.prompt_for_yield
    self.prompt_for_ingredient(recipe)
  end
  
  def prompt_for_recipe_name
    puts "Please enter a recipe name to get started:"
    title = gets.chomp
    if title == "exit"
      self.quit
    end
      title.length <=0 ? self.prompt_for_recipe_name : title
  end

  def prompt_for_yield
    puts "Number of servings for this recipe:"
    serves = gets.chomp
    if serves == "exit"
      self.quit
    elsif  serves == serves.to_i.to_s
      serves.to_i
    else
      self.prompt_for_yield
    end

  end

  def prompt_for_ingredient(recipe)
    if recipe.ingredients.length == 0
      puts "\nType:".bold
      self.print_help
      puts "    -or- \n\n"
      puts "Enter ingredient using the following format (exclude quotes): " + "\"qty\" \"unit_of_measure ingredient\"".cyan.bold + " -or- " + "\"count\" \"ingredient\".".cyan.bold
    else
      puts "Enter next ingredient:"
    end
    input = gets.chomp
    puts "\n"
    self.process_ingredient_input(input, recipe)
  end

  def print_ingredients(recipe)
    puts "#{recipe.name}".green.bold
    recipe.name.length.times {print "-".green}
    puts " "
    puts "Serves: #{recipe.serves}".green.italic
    recipe.ingredients.each do |i|
      puts "#{i}".green
    end
    puts "\n"
  end

  def print_help
    puts "\"HELP\"".cyan.bold + " for help options"
    puts "\"MEASURES\"".cyan.bold + " to see measurement abbreviations"
    puts "\"EXAMPLE\"".cyan.bold + " to see an example entry"
    puts "\"LIST RECIPE\"".cyan.bold + " to see all ingredients already entered"
    puts "\"FINISHED\"".cyan.bold + " to complete recipe"
    puts "\n"
  end

  def process_ingredient_input(input, recipe)
    
    input = input.downcase
    if input == "exit"
      self.quit
    elsif input == "measures" || input == "example"
      help_message("ingredient_#{input}", recipe)
    elsif input == "finished"
      self.finish_recipe(recipe)
    elsif input == "list recipe"
      self.print_ingredients(recipe)
      prompt_for_ingredient(recipe)
    elsif input == "help"
      self.print_help
      prompt_for_ingredient(recipe)
    else
      validated = recipe.validate_ingredient(input)
      if validated
        prompt_for_ingredient(recipe)
      else
        help_message("ingredient_reject", recipe)
      end

    end
    
  end

  #TODO: confirm recipe ingredients
  def finish_recipe(recipe)
    puts "Here is the completed entry: \n\n".bold
    self.print_ingredients(recipe)
    puts "Sending recipe to EDAMAM's nutrition analyzer. Please stand by..."
    error = recipe.fetch

    if error
      help_message(error)
    else
      print_nutrition_info(recipe)
    end

  end
  

  #TODO: status errors: prompt for exit or start from beginning
  def help_message(type, recipe = nil)
    case type
    when "ingredient_measures"
      puts "\n" + "Weights: mg, gr, oz, lbs ||| Volumes: ml, l, tsp, tbsp, c.".cyan.bold + "\n\n"
      self.prompt_for_ingredient(recipe)
    when "ingredient_example"
      puts "\n\"" + "3 tbsp brown sugar\" -or- \"1 carrot\" -or- \"1/2 medium onion".cyan.bold + "\"\n\n"
      self.prompt_for_ingredient(recipe)
    when "ingredient_reject"
      puts "\n\n" + "The last ingredient was invalid. Please try again...".red.bold + "\n\n"
      self.prompt_for_ingredient(recipe)
    when "response_404"
      puts "The service cannot be found. Please ensure you have an internet connection or try again later.".red.bold
    when "response_422", "response_555"
      puts "The service could not processess the recipe. Please try again ensuring that you spell all ingredients properly".red.bold
    when "response_other"
      puts "The service errored out. If you installed this locally, ensure that your APP_KEY and AP_ID are correct.".red.bold
    end
  end

  #TODO: prompt for exit or start from beginning
  def print_nutrition_info(recipe)

    info = recipe.nutrition_info
    
    total = info["totalNutrients"]
    daily = info["totalDaily"]
    print"\n"
    puts "Recipe Nutrition Info".blue.bold
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
        puts "#{val['label']}: #{(val['quantity']/recipe.serves).round(1)} #{val['unit']}"
      end
    end
  end

  #TODO: #reset
  #TODO: #start_new
  #TODO: #fix_ingredients

end