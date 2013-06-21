class AddSlugToUser < ActiveRecord::Migration
  def up
    add_column :users, :slug, :string
    add_index :users, :slug

    User.find_each(&:save)
  end

  def down
    remove_column :users, :slug
  end
end
