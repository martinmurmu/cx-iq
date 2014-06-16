require 'spec_helper'

describe "/user_messages/new.html.erb" do
  include UserMessagesHelper

  before(:each) do
    assigns[:user_messages] = stub_model(UserMessages,
      :new_record? => true,
      :name => "value for name",
      :email => "value for email",
      :company => "value for company",
      :message => "value for message"
    )
  end

  it "renders new user_messages form" do
    render

    response.should have_tag("form[action=?][method=post]", user_messages_path) do
      with_tag("input#user_messages_name[name=?]", "user_messages[name]")
      with_tag("input#user_messages_email[name=?]", "user_messages[email]")
      with_tag("input#user_messages_company[name=?]", "user_messages[company]")
      with_tag("textarea#user_messages_message[name=?]", "user_messages[message]")
    end
  end
end
