# == Schema Information
#
# Table name: bookings
#
#  id                :bigint           not null, primary key
#  end_date          :date
#  start_date        :date
#  status            :string           default("pending")
#  total_price_cents :integer          default(0), not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  bike_id           :bigint           not null
#  user_id           :bigint           not null
#
# Indexes
#
#  index_bookings_on_bike_id  (bike_id)
#  index_bookings_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (bike_id => bikes.id)
#  fk_rails_...  (user_id => users.id)
#
class Booking < ApplicationRecord
  monetize :total_price_cents

  enum status: %i[pending accepted refused canceled].index_with(&:to_s)

  belongs_to :user
  belongs_to :bike

  has_many :reviews
  has_many :notifications
  has_many :messages

  validates :start_date,                 presence: true
  validates :end_date,                   presence: true
  validates :total_price_cents,          presence: true
  validate  :check_if_bike_is_available, on: :create

  private

  # Add a validation: a booking should not be valid
  # if there is already a an accepted booking on the bike between the start_date and the end_date
  def check_if_bike_is_available
    # TODO: implement this validation
    # errors.add(:bike_id, 'is not available') unless bike.bookings.where('start_date >= ? AND end_date <= ?',
                                                                        # start_date, start_date).empty?
  end
end
