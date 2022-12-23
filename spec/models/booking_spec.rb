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
require 'rails_helper'

RSpec.describe Booking, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:bike) }
    it { should have_many(:reviews) }
    it { should have_many(:notifications) }
    it { should have_many(:messages) }
  end

  describe 'validations' do
    it { should validate_presence_of(:start_date) }
    it { should validate_presence_of(:end_date) }
    it { should validate_presence_of(:total_price_cents) }
  end

  describe 'custom validations' do
    let(:existing_booking) { create(:booking, start_date: '11-06-2023', end_date: '14-06-2023') }
    let(:new_booking)      { build(:booking, start_date: '10-06-2023', end_date: '13-06-2023') }

    it 'should not be valid on create when a bike is not available' do
      expect(new_booking.valid?).to be(false)
      expect(new_booking.errors.full_messages).should include('is not available')
    end
  end
end
