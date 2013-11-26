class EnableHaraway < ActiveRecord::Migration
  def up
    add_column :articles, :haraway_metadata, :text
    add_column :pages, :haraway_metadata, :text
  end

  def down
    remove_column :articles, :haraway_metadata
    remove_column :pages, :haraway_metadata
  end
end
