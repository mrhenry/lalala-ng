class CreateTags < ActiveRecord::Migration

  def up
    create_table :tags do |t|
      t.timestamps
    end
    Tag.create_translation_table!(
      title:       :string
    )
  end

  def down
    drop_table :tags
    Tag.drop_translation_table!
  end

end
