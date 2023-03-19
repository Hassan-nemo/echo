class Endpoint < ApplicationRecord
  # Validations
  validates :uuid, presence: true, uniqueness: true
  validates :verb, presence: true, inclusion: { in: Constants::ALLOWED_VERBS }
  validates :path, presence: true, format: { with: Constants::PATH_REGEX }
  validates :response, presence: true, json: { message: ->(errors) { errors }, schema: Constants::RESPONSE_SCHEMA }
  validates :path, uniqueness: { scope: :verb }

  # callbacks
  after_initialize :set_uuid

  private

  # Another possible option is to use verb + path as the string id
  def set_uuid
    return unless new_record?

    self.uuid = generate_uniq_uuid
  end

  def generate_uniq_uuid
    loop do
      random_token = SecureRandom.urlsafe_base64
      break random_token unless self.class.exists?(uuid: random_token)
    end
  end
end
