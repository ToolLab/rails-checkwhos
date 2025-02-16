class SitemapsController < ApplicationController
  # 인증이나 CSRF 체크 비활성화
  skip_before_action :verify_authenticity_token
  skip_before_action :authenticate_user!

  def show
    # ETag과 Last-Modified를 이용한 HTTP 캐싱
    @phone_numbers = PhoneNumber.select(:number, :updated_at).order(updated_at: :desc)
    @last_modified = [@phone_numbers.first&.updated_at, Time.current.beginning_of_day].compact.max

    fresh_when(
      etag: [@phone_numbers.cache_key_with_version, @last_modified],
      last_modified: @last_modified,
      public: true
    )

    # 캐시 헤더 설정 (이미 fresh_when에서 설정되었지만, 명시적으로 추가)
    headers["Content-Type"] = "application/xml"
    headers["Cache-Control"] = "public, max-age=14400" # 4시간 캐시

    @host = request.protocol + request.host_with_port
    
    respond_to do |format|
      format.xml
    end
  end
end
