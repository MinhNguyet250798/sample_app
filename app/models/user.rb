class User < ApplicationRecord
  before_save {self.email = email.downcase }
  validates :name, presence: true, length: { maximum: Setting.max50 }
  VALID_EMAIL_REGEX = Settings.string_regex
  validates :email, presence: true, length: { maximum: Setting.max255 }
    format: { with: VALID_EMAIL_REGEX },
    uniqueness: true
    has_secure_password
    validates :password, presence: true, length: { minimum: Setting.min6 }
end
