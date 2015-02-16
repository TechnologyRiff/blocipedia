class CreateAmounts < ActiveRecord::Migration
  def change
    create_table :amounts do |t|
      t.integer     :amount, default: 1500
      t.timestamps
    end
  end
endr
