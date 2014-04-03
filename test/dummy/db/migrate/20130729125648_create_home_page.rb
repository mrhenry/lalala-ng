class CreateHomePage < ActiveRecord::Migration
  def up
    unless column_exists?(:pages, :haraway_metadata)
      add_column(:pages, :haraway_metadata, :text)
    end

    HomePage.create!
  end

  def down
  end
end
