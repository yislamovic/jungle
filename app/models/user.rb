class User < ApplicationRecord
  has_secure_password

  validates :password, presence: true, length: { minimum: 6, maximum: 20 }, on: :create
  validates :password_confirmation, presence: true, if: :equalToPass?, on: :create
  validates :email, presence: true, if: :regesteredEmail?, on: :create

  def self.authenticate_with_credentials (email, pass)
    user = User.find_by_email(email)
    if user && user.authenticate(pass)
      return user
    else
     return nil
    end
  end  

  def equalToPass?
    password.equal? password_confirmation
  end

  def regesteredEmail?
    if User.find_by_email(:email.to_s.downcase.strip)
      return false
    else
      return true
    end
  end

end
