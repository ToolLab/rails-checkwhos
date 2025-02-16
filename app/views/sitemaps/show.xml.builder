# Fragment 캐싱 적용
cache ["sitemap", @phone_numbers.cache_key_with_version, @last_modified.to_i] do
  xml.instruct!

  xml.urlset(
    "xmlns" => "http://www.sitemaps.org/schemas/sitemap/0.9",
    "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance",
    "xsi:schemaLocation" => "http://www.sitemaps.org/schemas/sitemap/0.9 http://www.sitemaps.org/schemas/sitemap/0.9/sitemap.xsd"
  ) do
    # 메인 페이지
    xml.url do
      xml.loc @host
      xml.lastmod @last_modified.iso8601
      xml.changefreq "daily"
      xml.priority 1.0
    end

    # 전화번호 페이지들 (100개씩 배치 처리)
    @phone_numbers.in_batches(of: 100) do |batch|
      batch.each do |phone|
        xml.url do
          xml.loc "#{@host}/kr/search/#{phone.number}"
          xml.lastmod phone.updated_at.iso8601
          xml.changefreq "daily"
          xml.priority 0.9
        end
      end
    end

    # 정적 페이지들 (배열 상수화)
    STATIC_PAGES = %w[privacy terms about].freeze
    STATIC_PAGES.each do |page|
      xml.url do
        xml.loc "#{@host}/#{page}"
        xml.lastmod @last_modified.iso8601
        xml.changefreq "monthly"
        xml.priority 0.3
      end
    end
  end
end
