class ChangeSaleColumnDefault < ActiveRecord::Migration[7.0]
  def change
    change_column_default :sales, :price, nil
  end
end
