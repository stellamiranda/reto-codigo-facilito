class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :validatable
  has_many :tasks

  def self.authenticate(email, user_token)
    # option: where("email = #{email} AND authentication_token = #{user_token}")
    where("email = ? AND authentication_token = ?", email, user_token)
  end
end
