require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'Validations' do
    it "Valid password with confirmation and email" do
      @user = User.create(email: "1@1.com", password: '123123', 
      password_confirmation: '123123')
      expect(@user).to be_valid
    end
    it "it should pass with invalid password, confirmation and email" do
      @user = User.create(email: nil, password: nil, 
      password_confirmation: nil)
      expect(@user).to_not be_valid
    end
    it "should pass if invalid password length given" do
      @user = User.create(email: "1@1.com", password: '12312', 
      password_confirmation: '12312')
      expect(@user).to_not be_valid
    end
    it "should pass if unequal password confirmation given" do
      @user = User.create(email: "1@1.com", password: '123123', 
      password_confirmation: '1231234')
      expect(@user).to_not be_valid
    end
    it "should pass if email already in DB; ignoring case and white space" do
      @user = User.create(email: "  HARRY@1.com", password: '123123', 
      password_confirmation: '1231234')
      @user_other = User.create(email: "  harry@1.com ", password: '123123', 
      password_confirmation: '1231234')
      expect(@user_other).to_not be_valid
    end
  end
  describe '.authenticate_with_credentials' do
    it "authenticates user with correct email and password" do
      @user = User.create(email: "1@1.com", password: '123123', 
      password_confirmation: '123123')
      expect(User.authenticate_with_credentials(@user.email, @user.password)).to be_valid
    end
    it "should pass if unable to authenticate user" do
      @user = User.create(email: "1@1.com", password: '123123', 
      password_confirmation: '123123')
      expect(User.authenticate_with_credentials(@user.email, "1231234")).to be_nil
    end
  end  
end
