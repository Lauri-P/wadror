class RenameBeerStyle < ActiveRecord::Migration
  def change

    rename_column :beers, :style, :old_style
    add_column :beers, :style, :integer
  end
end
