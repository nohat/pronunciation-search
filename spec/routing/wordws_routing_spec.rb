require "spec_helper"

describe WordwsController do
  describe "routing" do

    it "routes to #index" do
      get("/wordws").should route_to("wordws#index")
    end

    it "routes to #new" do
      get("/wordws/new").should route_to("wordws#new")
    end

    it "routes to #show" do
      get("/wordws/1").should route_to("wordws#show", :id => "1")
    end

    it "routes to #edit" do
      get("/wordws/1/edit").should route_to("wordws#edit", :id => "1")
    end

    it "routes to #create" do
      post("/wordws").should route_to("wordws#create")
    end

    it "routes to #update" do
      put("/wordws/1").should route_to("wordws#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/wordws/1").should route_to("wordws#destroy", :id => "1")
    end

  end
end
