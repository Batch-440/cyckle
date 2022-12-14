# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  city                   :string
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  first_name             :string
#  gender                 :string
#  height                 :integer
#  jti                    :string           not null
#  last_name              :string
#  phone                  :string
#  postal_code            :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  street                 :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_jti                   (jti) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  GENDER = %w[male female non-binary].freeze
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self

  validates :first_name,  presence: true, length:       { minimum: 3 }
  validates :last_name,   presence: true, length:       { minimum: 2 }
  validates :phone,       presence: true, length:       { minimum: 10, maximum: 15 }
  validates :gender,      presence: true, inclusion:    { in: GENDER }
  validates :height,      presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 100, less_than_or_equal_to: 250 }

  has_many :bikes,         class_name: 'Bike',         foreign_key: 'owner_id'
  has_many :notifications, class_name: 'Notification', foreign_key: 'receiver_id'
  has_many :messages,      class_name: 'Message',      foreign_key: 'author_id'
  has_many :bookings
  has_many :reviews

  has_one_attached :avatar

  def address
    [street, postal_code, city].compact.join(', ')
  end
end
