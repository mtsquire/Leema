require 'rails_helper'
require 'spec_helper'

describe User do

  it "should sign up as a new user" do
    user = FactoryGirl.create(:user)
    expect(user.first_name).to eq('Brandon')
    expect(user.display_name).to_not be_nil
  end

  # it "should be able to sign up as a new supplier and update the display name" do
  #   user = FactoryGirl.create(:user)
  #   supplier = FactoryGirl.create(:supplier)
  #   expect(supplier.name).to eq('Brandon Hay')
  #   expect(supplier.users.first.display_name).to eq('brandons-bagels')
  # end
end
