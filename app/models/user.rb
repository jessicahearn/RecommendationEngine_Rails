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
    liked_by_both = liked_products & compared_user.liked_products
    disliked_by_both = disliked_products & compared_user.disliked_products
    negated_likes = liked_products & compared_user.disliked_products
    negated_dislikes = disliked_products & compared_user.liked_products
    total_liked_or_disliked = liked_or_disliked_products + compared_user.liked_or_disliked_products

    numerator = (liked_by_both.count + disliked_by_both.count) - (negated_likes.count + negated_dislikes.count)
    denominator = total_liked_or_disliked.count

    answer = numerator.to_f / denominator.to_f
    return answer
  end

  def estimated_likability_for(product)
    if liked_products.include? product
      return 1.0
    elsif disliked_products.include? product
      return -1.0
    else
      answer = sum_of_product_user_similarity_indexes(product).to_f / product.active_users.count.to_f
      if answer.nan?
        answer = 0.0
      end
      return answer
    end
  end

  def sum_of_product_user_similarity_indexes(product)
    sum = 0.0

    product.active_users.each do |compared_user|
      sum += similarity_index_for(compared_user)
    end

    return sum
  end

  def recommendations
    recommendations = []
    unknown_products.each do |product|
      recommendations << { name: product.name, index: estimated_likability_for(product).to_f}
    end

    return sorted_recs = recommendations.sort_by { |rec| -rec[:index] }
    #return sorted_recs.map{ |rec| rec[:index].to_s }
  end

end