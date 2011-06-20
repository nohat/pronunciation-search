require 'spec_helper'

describe Pronunciation do
  context "#parse_query" do
    it "handles pronunciations inside slashes" do
      Pronunciation.parse_query("/F UW1/").should == ["arpabet REGEXP ?", ["F UW1"]]
    end

    it "handles negation of pronunciations" do
      Pronunciation.parse_query("~/F UW1/").should == ["arpabet NOT REGEXP ?", ["F UW1"]]
    end

    it "handles spellings inside angle brackets" do
      Pronunciation.parse_query("<men>").should == ["words.name REGEXP ?", ["men"]]
    end

    it "handles negation of spelling" do
      Pronunciation.parse_query("~<men>").should == ["words.name NOT REGEXP ?", ["men"]]
    end

    it "returns an empty query if nothing inside slashes or brackets" do
      Pronunciation.parse_query("|foo|").should == ["", []]
    end

    it "converts vowels with no stress to a wildcard stress search" do
      Pronunciation.parse_query("/F UW/").should == ["arpabet REGEXP ?", ["F UW."]]
    end

    it "converts multiple vowels with no stress to a wildcard stress search" do
      Pronunciation.parse_query("/AH B AA B/").should == ["arpabet REGEXP ?", ["AH. B AA. B"]]
    end
  end
end