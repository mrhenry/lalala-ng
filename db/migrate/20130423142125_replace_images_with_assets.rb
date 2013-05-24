class ReplaceImagesWithAssets < ActiveRecord::Migration
  def change

    create_table :assets do |t|
      t.string     :asset
      t.string     :type
      t.references :asset_owner, polymorphic: true
      t.string     :asset_owner_section

      t.timestamps
    end

    add_index :assets, [:asset_owner_id, :asset_owner_type, :asset_owner_section], name: 'asset_owner_idx'

    create_table :asset_translations do |t|
      t.string     :locale
      t.references :asset

      t.string     :title
      t.text       :caption
    end

  end
end
