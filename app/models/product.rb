class Product < ActiveRecord::Base
  has_many :user_products
  has_many :users, through: :user_products

  def active_users
    users.select{ |u| u.likes_or_dislikes(self) }
  end

  def likers
    users.select{ |u| u.likes(self) }
  end

  def dislikers
    users.select{ |u| u.dislikes(self) }
  end

end