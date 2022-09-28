class ChangeColumnToStock < ActiveRecord::Migration[7.0]
  def up
    change_column :stocks, :name, :string, null: false, collation: 'utf8mb4_bin'
  end
  # 変更前の状態
  def down
    change_column :stocks, :name, :string, null: false
  end
end
