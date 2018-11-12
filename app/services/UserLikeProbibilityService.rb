class RecommendationService

  # def self.update_all_user_comparisons
  #   User.all.each do |user|
  #     User.all.each do |compared_user|
  #       comparison = UserComparison.find_or_create_by(user: user, compared_user: compared_user)
  #       comparison.jaccard_index = calculate_jaccard_index(user, compared_user)
  #       comparison.save
  #     end
  #   end
  # end

  # def self.calculate_jaccard_index(user, compared_user)
  # end


  

  def self.calculate_likability(user, product)
    return product_user_similarity_index(user, product) / product.users.count
  end

  def self.product_user_similarity_index(user, product)
    likers_similarity_total = 0
    product.likers.each do |liker|
      comparison = UserComparison.where(user: user, compared_user: liker).first
      likers_similarity_total += comparison.jaccard_index
    end

    dislikers_similarity_total = 0
    product.dislikers.each do |disliker|
      comparison = UserComparison.where(user: user, compared_user: disliker).first
      dislikers_similarity_total += comparison.jaccard_index
    end

    return likers_similarity_total - dislikers_similarity_total
  end
end
