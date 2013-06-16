require_relative '../spec_helper'

describe User do
  it "does not validate with an invalid email address" do
    user = User.new(email: "malformed email address")
    user.save.should == false
    (user.errors[:email].length > 0).should == true
  end
end
