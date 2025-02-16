class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def masked_email
    return "" if email.blank?

    local, domain = email.split("@")
    domain_parts = domain.split(".")

    # 로컬 파트: 처음 2글자만 보이고 나머지는 *로 마스킹
    masked_local = local[0..1] + "*" * (local.length - 2)

    # 도메인: 모두 *로 마스킹하고 길이는 유지
    masked_domain = domain_parts.map { |part| "*" * part.length }.join(".")

    "#{masked_local}@#{masked_domain}"
  end
end
