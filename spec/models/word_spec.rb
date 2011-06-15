require 'spec_helper'

describe Word do
  it "has a name" do
    word = Factory :word
    word.name.should be_present
  end
  
  it "finds spelling matches" do
    exact_match   = Factory :word, :name => 'exact_match'
    inexact_match = Factory :word, :name => 'inexact_match'
    not_a_match   = Factory :word, :name => 'not_a_match'
    @matches = Word.spelling_matches 'exact_match'
    @results = @matches.map { |match| match[:result] }
    @results.should     include exact_match
    @results.should     include inexact_match
    @results.should_not include not_a_match
  end
  
  it "orders exact matches before inexact matches" do
    inexact_match = Factory :word, :name => 'inexact_match'
    exact_match   = Factory :word, :name => 'exact_match'
    @matches = Word.spelling_matches 'exact_match'
    @results = @matches.map { |match| match[:result] }
    @results.should be [exact_match, inexact_match]
  end
end
