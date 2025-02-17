class HomeController < ApplicationController
  after_action :record_page_view, only: [ :search ]

  def index
    @recent_numbers = PhoneNumber.order(created_at: :desc).limit(100)
    @recent_comments = Comment.includes(:user, :phone_number).order(created_at: :desc).limit(100)
  end

  def search
    if params[:number].present?
      number = params[:number].gsub(/[^0-9]/, "")
      country_code = "82" # 한국 국가 코드
      country = "kr"

      @phone_number = PhoneNumber.find_by(
        country_code: country_code,
        country: country,
        number: number
      )

      if @phone_number
        @comments = @phone_number.comments.includes(:user).order(created_at: :desc).page(params[:page])
        @comment = Comment.new(phone_number: @phone_number)
      else
        @phone_number = PhoneNumber.new(
          country_code: country_code,
          country: country,
          number: number
        )
        @comments = Comment.none.page(params[:page])
        @comment = Comment.new(phone_number: @phone_number)
      end
    else
      @phone_number = nil
      @comments = Comment.none.page(params[:page])
      @comment = nil
    end
  end

  private

  def record_page_view
    return unless @phone_number&.persisted?

    @phone_number.page_views.create!(
      ip: request.remote_ip,
      referrer: request.referrer,
      viewed_at: Time.current
    )
  end
end
