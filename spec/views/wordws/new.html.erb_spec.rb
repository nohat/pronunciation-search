require 'spec_helper'

describe "wordws/new.html.erb" do
  before(:each) do
    assign(:wordw, stub_model(Wordw,
      :name => "MyString"
    ).as_new_record)
  end

  it "renders new wordw form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => wordws_path, :method => "post" do
      assert_select "input#wordw_name", :name => "wordw[name]"
    end
  end
end
