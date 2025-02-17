class ChangeUserAgentColumnPosition < ActiveRecord::Migration[8.0]
  def up
    # 새로운 sequence 생성
    execute <<-SQL
      CREATE SEQUENCE IF NOT EXISTS page_views_new_id_seq;
      
      CREATE TABLE page_views_new (
        id bigint PRIMARY KEY DEFAULT nextval('page_views_new_id_seq'),
        phone_number_id bigint,
        ip character varying,
        referrer character varying,
        user_agent character varying,
        viewed_at timestamp(6) without time zone,
        created_at timestamp(6) without time zone NOT NULL,
        updated_at timestamp(6) without time zone NOT NULL
      );
      
      -- 데이터 복사
      INSERT INTO page_views_new 
      SELECT id, phone_number_id, ip, referrer, user_agent, viewed_at, created_at, updated_at 
      FROM page_views;
      
      -- 외래키 추가
      ALTER TABLE page_views_new
      ADD CONSTRAINT fk_page_views_phone_number
      FOREIGN KEY (phone_number_id)
      REFERENCES phone_numbers(id);
      
      -- sequence 값 맞추기
      SELECT setval('page_views_new_id_seq', (SELECT MAX(id) FROM page_views_new));
      
      -- 이전 테이블 삭제
      DROP TABLE page_views CASCADE;
      
      -- 새 테이블 이름 변경
      ALTER TABLE page_views_new RENAME TO page_views;
      ALTER SEQUENCE page_views_new_id_seq RENAME TO page_views_id_seq;
    SQL
  end

  def down
    # 돌리기가 필요한 경우 추가
  end
end
