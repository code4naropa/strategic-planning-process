class CreateIdeas < ActiveRecord::Migration[5.0]
  def change
    create_table :ideas, id: :uuid do |t|
      t.references :author
      t.text :content
      t.integer :likes_count, :default => 0

      t.timestamps
    end

    add_foreign_key :ideas, :users, column: :author_id

  end
end
