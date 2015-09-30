require 'rails_helper'
require 'spec_helper'

describe User do
  before(:each) do
    user = User.create(
      first_name: 'Brandon',
      last_name: 'Hay',
      email: 'brandon.a.hay@gmail.com',
      password: 'password123',
      password_confirmation: 'password123')
  end
  it "should successfully sign up a new user" do
    expect(user.first_name).to eq('Brandon')
  end
  describe Spree::Supplier do
    it "should succesfully sign up a new supplier" do
      supplier = Spree::Supplier.create(
        email: user.email,
        name: user.full_name,
        store_name: 'my store'
        )
    end
  end
end
