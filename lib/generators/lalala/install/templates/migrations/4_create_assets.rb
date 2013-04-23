class CreateAssets < ActiveRecord::Migration
  def up
    create_table :assets do |t|
      t.string :asset # carrierwave file mount
      t.string :type

      t.references :asset_owner, polymorphic: true
      t.string :asset_owner_section

      t.timestamps
    end

    add_index :assets, [:asset_owner_id, :asset_owner_type, :asset_owner_section], name: 'asset_owner_idx'

    ImageAsset.create_translation_table! title: :string, caption: :text
  end

  def down
    drop_table :assets

    ImageAsset.drop_translation_table!
  end
end
