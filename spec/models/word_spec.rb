require 'spec_helper'

describe Word do
  it "has a name" do
    word = FactoryGirl.create :word
    word.name.should be_present
  end
  
  it "finds spelling matches" do
    exact_match   = FactoryGirl.create :word, :name => 'exact_match'
    inexact_match = FactoryGirl.create :word, :name => 'inexact_match'
    not_a_match   = FactoryGirl.create :word, :name => 'not_a_match'
    @matches = Word.matches 'exact_match'
    @matches.should     include exact_match
    @matches.should     include inexact_match
    @matches.should_not include not_a_match
  end
  
  it "orders exact matches before inexact matches" do
    inexact_match = FactoryGirl.create :word, :name => 'inexact_match'
    exact_match   = FactoryGirl.create :word, :name => 'exact_match'
    @matches = Word.matches 'exact_match'
    @matches.should == [exact_match, inexact_match]
  end
end
