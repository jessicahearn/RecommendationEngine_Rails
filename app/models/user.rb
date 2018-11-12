class User < ActiveRecord::Base
  has_many :user_products
  has_many :user_comparisons, foreign_key: :user_id, class_name: "UserComparison"
  has_many :compared_users, foreign_key: :compared_user_id, class_name: "UserComparison"

  def liked_products
    user_products.where(liked: true).map(&:product)
  end

  def disliked_products
    user_products.where(disliked: true).map(&:product)
  end

  def liked_or_disliked_products
    liked_products + disliked_products
  end

  def unknown_products
    user_products.where(liked: false, disliked: false).map(&:product)
  end

  def likes(product)
    self.user_products.where(product: product, liked: true).any?
  end

  def dislikes(product)
    self.user_products.where(product: product, disliked: true).any?
  end

  def likes_or_dislikes(product)
    self.likes(product) || self.dislikes(product)
  end

  def similarity_index_for(compared_user)
    user_comparison = user_comparisons.where(compared_user: compared_user).first

    if user_comparison.present? && user_comparison.try(:similarity_index).present?
      return user_comparison.try(:similarity_index)
    else
      return 0.0
    end
  end

  def estimated_likability_for(product)
    product.likeability_index_for(self)
  end

  def recommendations
    RecommendationService.recommendations_for(self)
  end

end