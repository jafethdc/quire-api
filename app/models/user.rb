class User < ApplicationRecord
  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, format: { with: /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/ },
                    uniqueness: { case_sensitive: false }
  validates :full_name, presence: true
end
