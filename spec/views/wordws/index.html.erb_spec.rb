require 'spec_helper'

describe "wordws/index.html.erb" do
  before(:each) do
    assign(:wordws, [
      stub_model(Wordw,
        :name => "Name"
      ),
      stub_model(Wordw,
        :name => "Name"
      )
    ])
  end

  it "renders a list of wordws" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
  end
end
