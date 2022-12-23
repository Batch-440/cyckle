# == Schema Information
#
# Table name: bikes
#
#  id                  :bigint           not null, primary key
#  battery_life        :integer
#  brand               :string
#  category            :string
#  city                :string
#  color               :string
#  description         :text
#  gender              :string
#  groupset            :string
#  is_electric         :boolean
#  latitude            :float
#  longitude           :float
#  min_days            :integer
#  model               :string
#  name                :string
#  postal_code         :string
#  price_per_day_cents :integer          default(0), not null
#  release_year        :integer
#  size                :string
#  status              :string
#  street              :string
#  weight              :float
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  owner_id            :bigint           not null
#
# Indexes
#
#  index_bikes_on_owner_id  (owner_id)
#
# Foreign Keys
#
#  fk_rails_...  (owner_id => users.id)
#
class Bike < ApplicationRecord
  CATEGORIES = %w[road city mountain gravel touring].freeze
  GENDER     = %w[male female unisex].freeze

  monetize :price_per_day_cents

  enum status: %i[available unavailable booked].index_with(&:to_s)

  validates :name,                presence: true
  validates :brand,               presence: true
  validates :category,            presence: true, inclusion: { in: CATEGORIES }
  validates :gender,              presence: true, inclusion: { in: GENDER }
  validates :size,                presence: true
  validates :min_days,            presence: true
  validates :price_per_day_cents, presence: true
  validates :street,              presence: true, length: { minimum: 5 }
  validates :postal_code,         presence: true, length: { minimum: 3 }
  validates :city,                presence: true, length: { minimum: 2 }

  belongs_to :owner, class_name: 'User', foreign_key: 'owner_id', required: true

  has_many :bookings
  has_many :reviews, through: :bookings
  has_many_attached :photos

  geocoded_by      :address
  after_validation :geocode, if: :will_save_change_to_street?
  after_validation :geocode, if: :will_save_change_to_postal_code?
  after_validation :geocode, if: :will_save_change_to_city?

  def address
    [street, postal_code, city].compact.join(', ')
  end

  def average_rating
    reviews.average(:rating).to_f
  end

  def unavailable_dates
    bookings.pluck(:start_date, :end_date).map do |range|
      { from: range[0], to: range[1] }
    end
  end
end
