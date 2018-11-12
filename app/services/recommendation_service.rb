class RecommendationService

  def self.calculate_similarity_index_for(user, compared_user)
    liked_by_both = user.liked_products & compared_user.liked_products
    disliked_by_both = user.disliked_products & compared_user.disliked_products
    negated_likes = user.liked_products & compared_user.disliked_products
    negated_dislikes = user.disliked_products & compared_user.liked_products
    total_liked_or_disliked = user.liked_or_disliked_products + compared_user.liked_or_disliked_products

    numerator = (liked_by_both.count + disliked_by_both.count) - (negated_likes.count + negated_dislikes.count)
    denominator = total_liked_or_disliked.count

    answer = numerator.to_f / denominator.to_f
    return answer
  end

  def self.similarity_with_likers(user, product)
    sum = 0.0

    if product.likers.any?
      product.likers.each do |compared_user|
        sum += calculate_similarity_index_for(user, compared_user)
      end
    end

    return sum
  end

  def self.similarity_with_dislikers(user, product)
    sum = 0.0

    if product.dislikers.any?
      product.dislikers.each do |compared_user|
        sum += calculate_similarity_index_for(user, compared_user)
      end
    end

    return sum
  end

  def self.calculate_likeability_index_for(user, product)
    if user.liked_products.include? product
      return 1.0
    elsif user.disliked_products.include? product
      return -1.0
    else
      answer = 0.0
      overall_user_similarity = similarity_with_likers(user, product) - similarity_with_dislikers(user, product)
      likeability = overall_user_similarity / product.active_users.count.to_f

      unless likeability.nan?
        answer = likeability
      end

      return answer
    end
  end

  def self.recommendations_for(user)
    recommendations = []
    user.unknown_products.each do |product|
      recommendations << { name: product.name, index: calculate_likeability_index_for(user, product)}
    end

    return sorted_recs = recommendations.sort_by { |rec| -rec[:index] }
  end
end
