class AddPreAndPostpendTestColumnsToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :url, :string
    add_column :articles, :price, :string
  end
end
