class CreateMediaPage < ActiveRecord::Migration
  def up
    HomePage.first!.save
  end

  def down
  end
end
