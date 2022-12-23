class Api::V1::BookingsController < Api::V1::BaseController
  before_action :authenticate_user!

  def index
    @bookings = policy_scope(Booking)
    render json: {
      status: { code: 200, message: 'Bookings successfully retrieved.' },
      data: BookingSerializer.new(@bookings, is_collection: true).serializable_hash[:data].map { |obj| obj[:attributes] }
    }
  end

  def show
    @booking = Booking.find(params[:id])
    render json: {
      status: { code: 200, message: 'Booking successfully retrieved.' },
      data: BookingSerializer.new(@booking).serializable_hash[:data][:attributes]
    }

    authorize @booking
  end

  def create
    @booking = Booking.new(booking_params)
    @booking.user = current_user
    @booking.bike = Bike.find(params[:bike_id])
    if @booking.save
      render json: {
        status: { code: 200, message: 'Booking successfully created.' },
        data: BookingSerializer.new(@booking).serializable_hash[:data][:attributes]
      }
    else
      render json: {
        status: { code: 422, message: 'Booking could not be created.' },
        data: @booking.errors
      }
    end

    authorize @booking
  end

  def update
    @booking = Booking.find(params[:id])
    if @booking.update(booking_params)
      render json: {
        status: { code: 200, message: 'Booking successfully updated.' },
        data: BookingSerializer.new(@booking).serializable_hash[:data][:attributes]
      }
    else
      render json: {
        status: { code: 422, message: 'Booking could not be updated.' },
        data: @booking.errors
      }
    end

    authorize @booking
  end

  def destroy
    @booking = Booking.find(params[:id])
    @booking.destroy
    render json: {
      status: { code: 200, message: 'Booking successfully destroyed.' },
      data: BookingSerializer.new(@booking).serializable_hash[:data][:attributes]
    }

    authorize @booking
  end

  private

  def booking_params
    params.require(:booking).permit(:start_date, :end_date, :status, :total_price_cents, :bike_id, :user_id)
  end
end
