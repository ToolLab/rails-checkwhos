class SitemapsController < ApplicationController
  # 정적 페이지 상수 정의
  STATIC_PAGES = %w[privacy terms about].freeze
  CACHE_DURATION = 14400 # 4시간
  BATCH_SIZE = 500 # 배치 크기

  skip_before_action :verify_authenticity_token
  before_action :set_headers
  
  def show
    set_variables
    set_caching_headers
    
    # HTTP 캐싱 적용
    fresh_when(
      etag: cache_key,
      last_modified: @last_modified,
      public: true
    )
  end

  private

  def set_variables
    @host = request.protocol + request.host_with_port
    @phone_numbers = PhoneNumber
      .select(:number, :updated_at)
      .order(updated_at: :desc)
      .includes(:comments) # N+1 쿼리 방지
    
    @last_modified = [
      @phone_numbers.first&.updated_at,
      Time.current.beginning_of_day
    ].compact.max
  end

  def set_headers
    headers.merge!({
      "Content-Type" => "application/xml",
      "Cache-Control" => "public, max-age=#{CACHE_DURATION}",
      "X-Robots-Tag" => "noindex"
    })
  end

  def cache_key
    [
      "sitemap",
      @phone_numbers.cache_key_with_version,
      @last_modified.to_i,
      STATIC_PAGES.hash
    ]
  end
    
    respond_to do |format|
      format.xml
    end
  end
end
