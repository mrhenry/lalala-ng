class CreatePages < ActiveRecord::Migration
  def migrate(direction)
    super
    if direction == :up
      # Reset the column info
      ApplicationPage.reset_column_information
    end
  end

  def change
    create_table :pages do |t|
      t.integer :parent_id
      t.integer :position
      t.string  :type
      t.string  :static_uuid

      t.timestamps
    end

    create_table :page_hierarchies, :id => false do |t|
      t.integer  :ancestor_id, :null => false   # ID of the parent/grandparent/great-grandparent/... tag
      t.integer  :descendant_id, :null => false # ID of the target tag
      t.integer  :generations, :null => false   # Number of generations between the ancestor and the descendant. Parent/child = 1, for example.
    end

    create_table :page_translations do |t|
      t.references :page
      t.string     :locale

      t.string :title
      t.string :path_component
      t.text   :body
    end

    add_index :page_hierarchies,  [:ancestor_id, :descendant_id], :unique => true
    add_index :page_hierarchies,  [:descendant_id]
    add_index :page_translations, [:page_id]
    add_index :page_translations, [:locale]
    add_index :page_translations, [:path_component]
  end
end
