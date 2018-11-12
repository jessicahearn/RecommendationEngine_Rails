class UserComparison < ActiveRecord::Base
  belongs_to :user

  # TODO: Possibly eliminate this? We can probably calculate this one the fly...
end