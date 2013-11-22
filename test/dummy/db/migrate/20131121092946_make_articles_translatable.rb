class MakeArticlesTranslatable < ActiveRecord::Migration
  def up
    change_table :articles do |t|
      t.remove :title
      t.remove :body
    end

    Article.create_translation_table!(title: :string, body: :text)
  end

  def down
    change_table :articles do |t|
      t.string :title
      t.text :body
    end

    drop_table :article_translations
  end
end
