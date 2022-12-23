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
class BookingSerializer
  include FastJsonapi::ObjectSerializer
  set_key_transform :camel_lower

  attributes :id, :start_date, :end_date, :status, :total_price_cents

  attribute :bike do |booking|
    BikeSerializer.new(booking.bike, is_collection: false).serializable_hash[:data][:attributes]
  end

  attribute :user do |booking|
    UserSerializer.new(booking.user).serializable_hash[:data][:attributes]
  end
end
