class AddArticlesTagsBinding < ActiveRecord::Migration
  def up
    create_join_table :tags, :articles
  end

  def down
    drop_table :articles_tags
  end
end
