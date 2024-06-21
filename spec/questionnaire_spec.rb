require 'spec_helper'
require 'stringio'
require 'pstore'

RSpec.describe 'Questionnaire' do
  describe "User Input Handling" do
    it "accepts valid inputs for each question" do
      allow($stdout).to receive(:puts)
      allow_any_instance_of(Object).to receive(:gets).and_return("yes\n", "no\n", "yes\n", "yes\n", "no\n")

      expect { do_prompt }.to change { ANSWERS.length }.from(0).to(5)
    end

    it "rejects invalid inputs and accepts valid inputs after retry" do
      allow($stdout).to receive(:puts)
      allow_any_instance_of(Object).to receive(:gets).and_return("invalid\n", "yes\n", "no\n", "y\n", "n\n")

      expect { do_prompt }.to change { ANSWERS.length }.from(0).to(5)
    end
  end

  describe "Rating Calculation" do
    it "calculates correct rating for all 'Yes' answers" do
      answers = ["yes", "yes", "yes", "yes", "yes"]
      expect(calculate_rating(answers)).to eq(100.0)
    end

    it "calculates correct rating for mixed 'Yes' and 'No' answers" do
      answers = ["yes", "no", "yes", "no", "yes"]
      expect(calculate_rating(answers)).to eq(60.0)
    end

    it "calculates correct rating for all 'No' answers" do
      answers = ["no", "no", "no", "no", "no"]
      expect(calculate_rating(answers)).to eq(0.0)
    end
  end

  describe "Storage Behavior" do
    before(:each) do
      allow(STORE).to receive(:transaction).and_yield
    end
  
    it "stores answers correctly" do
      answers = ["yes", "no", "yes", "no", "yes"]
      expect { save_answers(answers) }.to change { STORE[:results].length }.from(0).to(1)
    end
  
    it "calculates average rating correctly" do
      STORE[:results] = [["yes", "yes", "no", "no", "yes"], ["yes", "no", "no", "yes", "yes"]]
      expect(average_rating).to eq(70.0)
    end
  
    it "handles empty results gracefully" do
      STORE[:results] = []
      expect(average_rating).to eq(0.0)
    end
  end

  describe "Overall Report" do
    it "displays correct current and average ratings" do
      answers = ["yes", "no", "yes", "no", "yes"]
      allow_any_instance_of(Object).to receive(:do_prompt).and_return(answers)
      allow_any_instance_of(Object).to receive(:calculate_rating).and_return(60.0)
      allow_any_instance_of(Object).to receive(:average_rating).and_return(65.0)
  
      expected_output = "Your rating for this run is: 60.0%\nYour average rating across all runs is: 65.0%\n"
      expect { do_report }.to output(expected_output).to_stdout
    end
  end  
end