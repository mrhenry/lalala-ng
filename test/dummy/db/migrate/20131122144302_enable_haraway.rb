class EnableHaraway < ActiveRecord::Migration
  def up
    unless column_exists?(:articles, :haraway_metadata)
      add_column(:articles, :haraway_metadata, :text)
    end

    unless column_exists?(:pages, :haraway_metadata)
      add_column(:pages, :haraway_metadata, :text)
    end
  end

  def down
    remove_column :articles, :haraway_metadata
    remove_column :pages, :haraway_metadata
  end
end
