class Customer < ApplicationRecord
  belongs_to :user
  has_many :archive_payrolls

  def customer_id
  	user_id.to_s
  end

  def customer_name
  	user.fullname
  end

  def email
  	user.email
  end
end
