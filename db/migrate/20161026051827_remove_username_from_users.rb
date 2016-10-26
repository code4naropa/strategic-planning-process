class RemoveUsernameFromUsers < ActiveRecord::Migration[5.0]
  def up
    remove_column :users, :username
  end

  def down
    add_column :users, :username, :citext
  end
end
