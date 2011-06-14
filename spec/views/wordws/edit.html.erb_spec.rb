require 'spec_helper'

describe "wordws/edit.html.erb" do
  before(:each) do
    @wordw = assign(:wordw, stub_model(Wordw,
      :name => "MyString"
    ))
  end

  it "renders the edit wordw form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => wordws_path(@wordw), :method => "post" do
      assert_select "input#wordw_name", :name => "wordw[name]"
    end
  end
end
