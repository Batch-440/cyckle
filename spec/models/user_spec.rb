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
require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { should have_many(:bikes) }
    it { should have_many(:bookings) }
    it { should have_many(:reviews) }
    it { should have_many(:notifications) }
    it { should have_many(:messages) }
  end

  describe 'validations' do
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }
    it { should validate_presence_of(:gender) }
    it { should validate_presence_of(:height) }
    it { should validate_presence_of(:phone) }
    it { should validate_length_of(:first_name).is_at_least(3) }
    it { should validate_length_of(:last_name).is_at_least(2) }
    it do
      should validate_length_of(:phone)
        .is_at_least(10)
        .is_at_most(15)
    end
    it do
      should validate_inclusion_of(:gender)
        .in_array(%w[male female non-binary])
    end
    it do
      should validate_numericality_of(:height)
        .only_integer
        .is_greater_than_or_equal_to(100)
        .is_less_than_or_equal_to(250)
    end
  end

  describe 'instance methods' do
    let(:user) { build(:user) }

    describe '#address' do
      before do
        user.street      = '1 rue du chemin vert'
        user.postal_code = '75011'
        user.city        = 'Paris'
      end

      it 'should return a valid address' do
        expect(user.address).to eq('1 rue du chemin vert, 75011, Paris')
      end
    end
  end
end
