class AddUserAgentToPageViews < ActiveRecord::Migration[8.0]
  def change
    add_column :page_views, :user_agent, :string
  end
end
