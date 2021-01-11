# recipe-nutrition-analyzer

Ruby CLI tool to return nutritional information on a recipe from EDAMAM's nutrition analysis API

## Installation

1. Sign up for developer account at [EDAMAM](https://developer.edamam.com/edamam-nutrition-api)
2. Under the developer account under Dashboard > Applications, create a new application
3. Copy the Application ID and Application Keys
4. Clone or copy this repo into your local environment.
5. In config, create a `.env` file and add the following lines (replace x's with values from step 3):
   1. API_KEY="xxxxxxxxxxxxxxxxxxxxxxxxxxxx"
   2. APP_ID="xxxxxxxx"
6. Open up your terminal and type `bundle install`.
7. After all dependencies are installed, type `bin/recipeAnalyzer` into your terminal.
