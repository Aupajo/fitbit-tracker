class FitbitUser < ApplicationRecord
  has_one :authenticated_user
end
