class AddFavouriteToSeries < ActiveRecord::Migration[5.0]
  def change
    add_column :series, :favourite, :boolean, default: false
  end
end
