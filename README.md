recipe-nutrition-analyzer

Ruby CLI tool to get nutritional information for a recipe from EDAMAM's nutrition analysis API

TOC


- [Installation](#installation)
- [Usage](#usage)
- [Contribution](#contribution)
- [Next steps](#next-steps)

## Installation

1. Sign up for developer account at [EDAMAM](https://developer.edamam.com/edamam-nutrition-api)
2. In the developer portal, go navigate to Dashboard > Applications.
3. Create a new application using the Nutritional Analysis API.
4. Copy the Application ID and Application Keys.
5. Clone or copy this repo into your development environment.
6. In `config/` directory, create a `.env` file and add the following lines (replace x's with copied values):
   1. API_KEY="xxxxxxxxxxxxxxxxxxxxxxxxxxxx"
   2. APP_ID="xxxxxxxx"
7. Open up your terminal and type `bundle install`.

## Usage

1. After installing, in the terminal, type `bin/recipeAnalyzer`
   1. If you get an error saying something about not being able to execute the file, enter `chmod +x bin/recipeAnalyzer`.
   2. ⚠️⚠️[know what you are doing](https://en.wikipedia.org/wiki/Chmod) and what this does first!⚠️⚠️
2. The CLI application will welcome you and ask for a title. Enter a meaningful but short name.
3. The CLI will prompt for a number of servings. Enter a whole number greater than 0.
4. After asking for a title and number of servings, the CLI will prompt you for ingredients one at a time. The desired format is also printed out for reference.
   1. Typing "example" will make the CLI display a couple of sample ingredients.
   2. Typing "help" will display abbreviations for common weights and measures used in cooking.
5. Typing "finished" will finalize the recipe and send the information to EDAMAM.
6. When successful, the CLI will display the nutrition info of the entire recipe similar to an FDA food label. All numbers are given per serving.

## Contribution

Bottom line: I will be a kind human. Please be the same in return.

This is an early work in progress so I will be actively making changes. As such, please submit a contribution idea through opening an issue before working on a pull request. Don't submit a pull request at this unless it has been discussed through an issue ticket. I happily respond to all contructive inquiries.

As this project evolves, I will update this readme and how contributions are accepted.

## Next steps

- allow for recipe editing prior to competion
- confirm recipe ingredients before sending
- on completion, prompt to create new or exit
- on band responses, prompt to create new or exit
- allow user to see previous nutritional results
- scrape r-recipe microformatted pages for recipe list
- persist results to database
