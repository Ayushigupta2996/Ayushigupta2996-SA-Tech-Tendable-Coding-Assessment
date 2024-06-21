# Tendable Coding Assessment

## Usage

```sh
bundle
ruby questionnaire.rb
```

## Goal

The goal is to implement a survey where a user should be able to answer a series of Yes/No questions. After each run, a rating is calculated to let them know how they did. Another rating is also calculated to provide an overall score for all runs.

## Requirements

Possible question answers are: "Yes", "No", "Y", or "N" case insensitively to answer each question prompt.

The answers will need to be **persisted** so they can be used in calculations for subsequent runs >> it is proposed you use the pstore for this, already included in the Gemfile

After _each_ run the program should calculate and print a rating. The calculation for the rating is: `100 * number of yes answers / number of questions`.

The program should also print an average rating for all runs.

The questions can be found in questionnaire.rb

Ensure we can run your exercise

## Bonus Points

Updated readme with an explanation of your approach

Unit Tests

Code Comments

Dockerfile / Bash script if needed for us to run the exercise

## Approach
This Ruby code, questionnaire.rb, is designed to prompt users with a series of questions about their coding abilities in various programming languages. It then calculates and reports the ratings based on the answers provided by the users. Below is an explanation of the approach taken in the code:

## Components and Functionality
1. PStore Integration:

The code utilizes Ruby's PStore module for persistent storage (tendable.pstore). This allows it to store and retrieve user responses across multiple runs.

2. Questions Definition:

The QUESTIONS constant defines a set of questions regarding programming languages (Ruby, JavaScript, Swift, Java, C#). Each question is associated with a key (q1 to q5).

3. User Prompting (do_prompt function):

The do_prompt function iterates through each question defined in QUESTIONS. It prompts the user to answer each question with "Yes" or "No" (accepted as "Y" or "N" as well).
User input validation ensures that only valid responses are accepted. Invalid inputs prompt the user to retry until a valid response is provided.

4. Rating Calculation (calculate_rating function):

Once all questions are answered and stored in ANSWERS, the calculate_rating function calculates the rating based on the percentage of "yes" answers (yes or y).
It computes the percentage as (yes_count / total_questions) * 100 and rounds it to two decimal places.

5. Saving Answers (save_answers function):

After collecting and validating all responses (ANSWERS), the save_answers function stores them in the STORE[:results] array within a PStore transaction.
It ensures that each set of answers is appended to the existing results, preserving a history of all questionnaire runs.

6. Generating Report (do_report function):

The do_report function provides immediate feedback to the user after completing the questionnaire.
It calculates the rating for the current run using calculate_rating and displays it along with the average rating across all runs stored in the PStore.

7. Average Rating Calculation (average_rating function):

The average_rating function computes the average rating from all stored results.
It retrieves all stored sets of answers (results) from the PStore, calculates their ratings using calculate_rating, and then computes the average of these ratings.
Usage

8. Running the Application:

Execute ruby questionnaire.rb in your terminal to start the questionnaire.
Follow the prompts to answer each question about your coding abilities.
After completing the questionnaire, the application will display your rating for the current run and the average rating across all runs.

##  Testing:

The application includes test cases to verify its functionality using RSpec (spec/questionnaire_spec.rb). Ensure you have RSpec installed (bundle install) and run the tests with bundle exec rspec.
Tests cover prompt behavior, rating calculation, database storage, and report generation.

## Files Structure:
questionnaire.rb: Main Ruby script containing the questionnaire logic.
spec/questionnaire_spec.rb: RSpec tests for the application's functionality.
tendable.pstore: PStore database file storing results of each questionnaire run.

