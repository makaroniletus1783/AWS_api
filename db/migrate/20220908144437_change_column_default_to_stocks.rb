class ChangeColumnDefaultToStocks < ActiveRecord::Migration[7.0]
  def change
    change_column_default :stocks, :amount, from: nil, to: "0"
  end
end
