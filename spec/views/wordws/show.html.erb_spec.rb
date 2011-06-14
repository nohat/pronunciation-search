require 'spec_helper'

describe "wordws/show.html.erb" do
  before(:each) do
    @wordw = assign(:wordw, stub_model(Wordw,
      :name => "Name"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
  end
end
