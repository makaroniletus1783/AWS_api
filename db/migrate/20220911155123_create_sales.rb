class CreateSales < ActiveRecord::Migration[7.0]
  def change
    create_table :sales do |t|
      t.string :name
      t.integer :amount, default: 1
      t.integer :price, default: 0


      t.timestamps
    end
  end
end
