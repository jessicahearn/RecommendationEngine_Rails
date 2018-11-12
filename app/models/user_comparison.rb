class UserComparison < ActiveRecord::Base
  belongs_to :user
  belongs_to :compared_user
end