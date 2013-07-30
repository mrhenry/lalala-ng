class CreateHomePage < ActiveRecord::Migration
  def up
    HomePage.create!
  end

  def down
  end
end
