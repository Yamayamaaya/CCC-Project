class Rocords < ActiveRecord::Migration[6.1]
  def change
    drop_table :parent_children
  end
end
