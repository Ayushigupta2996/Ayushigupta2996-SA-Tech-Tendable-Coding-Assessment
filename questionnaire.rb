require "pstore" # https://github.com/ruby/pstore

STORE_NAME = "tendable.pstore"
STORE = PStore.new(STORE_NAME)

QUESTIONS = {
  "q1" => "Can you code in Ruby?",
  "q2" => "Can you code in JavaScript?",
  "q3" => "Can you code in Swift?",
  "q4" => "Can you code in Java?",
  "q5" => "Can you code in C#?"
}.freeze

ANSWERS = []

def do_prompt
  puts "Please answer the following questions with Yes/No (or Y/N):"
  QUESTIONS.each_key do |question_key|
    puts QUESTIONS[question_key]
    # Taking inputs from users
    # Downcase is used to convert inputs in lowercase
    ans = gets.chomp.strip.downcase
    until ["yes", "no", "y", "n"].include?(ans)
      # To check the inputs whether it is in yes or no format or not
      puts "Invalid input. Please answer with Yes/No (or Y/N):"
      ans = gets&.chomp&.strip&.downcase
    end
    ANSWERS << ans
  end
  save_answers
end

def calculate_rating(answers)
  # calculating count of yes response
  yes_count = answers.count { |ans| ["yes", "y"].include?(ans) }
  (100.0 * yes_count / QUESTIONS.size).round(2)
end

def save_answers
  # Storing number of times events occur
  STORE.transaction do
    STORE[:results] ||= []
    STORE[:results] << ANSWERS
  end
end

def do_report
  # Generating report for current and average rating
  current_rating = calculate_rating(ANSWERS)
  avg_rating = average_rating

  puts "Your rating for this run is: #{current_rating}%"
  puts "Your average rating across all runs is: #{avg_rating}%"
end

def average_rating
  # Calculating average rating based on output of save_answers method
  STORE.transaction(true) do
    all_ratings = STORE[:results].map { |answers| calculate_rating(answers) }
    return 0 if all_ratings.empty?
    (all_ratings.sum / all_ratings.size).round(2)
  end
end

do_prompt
do_report
