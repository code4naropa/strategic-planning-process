class User < ApplicationRecord
  has_secure_password
  has_secure_token :registration_token

  include Rails.application.routes.url_helpers

  # # Associations
  # ## Posts
  has_many :posts, :foreign_key => "author_id", dependent: :destroy

  # ## Comments
  has_many :comments, :foreign_key => "author_id", dependent: :destroy

  # ## Likes
  has_many :likes, :foreign_key => "liker_id", dependent: :destroy
  # has_many :likes_on_posts --> where(:likable_type => "Post")
  # has_many :likes_on_comments --> where(:likable_type => "Comments")
  # has_many :liked_posts, :through => :likes, :source => :likable,  :source_type => 'Post'
  # has_many :liked_comments, :through => :likes, :source => :likable,  :source_type => 'Comment'

  # # Validations
  # name
  validates :name, presence: true

  # Email
  validates :email, presence: true
  validates :email, format: {
    with: /\A\S+@\S+\.\S+\z/,
    message: "seems invalid"
  }
  validates :email, format: {
    with: /\A\S+@(\S+\.){0,1}naropa\.edu\z/,
    message: "must be a Naropa email address"
  }
  validates :email,
    uniqueness: { :case_sensitive => false }

  # Password
  validates :password, confirmation: true
  validates :password,
    length: { in: 8..50 }, unless: "password.nil?"


  # before_validation :create_profile_if_not_exists, on: :create

  # send the registration email
  def send_registration_email
    Mailjet::Send.create(
      "FromEmail": "fwoelm@students.naropa.edu",
      "FromName": "Strategic Planning Process (Demo)",
      "Subject": "Please Confirm Your Registration",
      "Mj-TemplateID": ENV['USER_REGISTRATION_EMAIL_TEMPLATE_ID'],
      "Mj-TemplateLanguage": "true",
      "Mj-trackclick": "1",
      recipients: [{
        'Email' => email,
        'Name' => name
        }],
      vars: {
        "NAME" => name,
        "CONFIRMATION_PATH" => registration_confirmation_path
      }
    )
  end

  # # Class Methods

  private
    # return the path for confirming the registration
    def registration_confirmation_path
      confirm_registration_path(
        :email => email,
        :registration_token => registration_token
      )
    end

  # protected
  # def create_profile_if_not_exists
  #   self.profile ||= Profile.new(:visibility => "is_network_only")
  # end
end
