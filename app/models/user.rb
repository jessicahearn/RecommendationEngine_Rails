class User < ActiveRecord::Base
  has_many :user_products
  has_many :user_comparisons

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
    RecommendationService.calculate_similarity_index_for(self, compared_user)
  end

  def estimated_likability_for(product)
    RecommendationService.calculate_likeability_index_for(self, product)
  end

  def recommendations
    RecommendationService.recommendations_for(self)
  end

end