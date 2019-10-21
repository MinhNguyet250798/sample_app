class User < ApplicationRecord
  VALID_EMAIL_REGEX = Settings.string_regex
  before_save {email.downcase!}
  validates :name, presence: true, length: {maximum: Settings.max50}
  validates :email, presence: true, length: {maximum: Settings.max255},
    format: {with: VALID_EMAIL_REGEX}, uniqueness: true
  validates :password, presence: true, length: {minimum: Settings.min6}

  class << self
  def digest string
    cost = if ActiveModel::SecurePassword.min_cost
              BCrypt::Engine::MIN_COST
            else
               BCrypt::Engine.cost
            end
    BCrypt::Password.create(string, cost: cost)
  end
end

  has_secure_password
end
