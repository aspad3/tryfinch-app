class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  after_create :create_customer
  has_one :customer

  def create_customer
    customer = Customer.new
    customer.user_id = id
    customer.save
  end

  def fullname
    "#{first_name} #{last_name}"
  end
end
