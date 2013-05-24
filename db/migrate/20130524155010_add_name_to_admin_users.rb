class AddNameToAdminUsers < ActiveRecord::Migration
  def change
    change_table :admin_users do |t|
      t.string :name
    end
  end
end
