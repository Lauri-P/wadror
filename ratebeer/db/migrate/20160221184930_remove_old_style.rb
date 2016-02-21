class RemoveOldStyle < ActiveRecord::Migration
  def change
    rename_column :beers, :style, :style_id
    remove_column :beers, :old_style, :string
  end
end
