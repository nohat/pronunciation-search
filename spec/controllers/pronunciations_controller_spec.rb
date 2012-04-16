require 'spec_helper'

describe PronunciationsController do
  describe "GET index with no parameters" do
    before do
      FactoryGirl.create(:word_with_pronunciation)
      get :index
    end

    it "is successful" do
      response.should be_successful
    end

    it "gets pronunciations" do
      assigns(:pronunciations).should_not be_empty
    end
  end

end
