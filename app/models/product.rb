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

  def likeability_index_for(user)
    user_product = user_products.where(user: user).first
    if user_product.present? && user_product.try(:predicted_likability).present?
      return user_product.try(:predicted_likability)
    else
      return 0.0
    end
  end
end