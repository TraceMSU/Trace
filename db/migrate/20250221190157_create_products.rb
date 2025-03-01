class CreateProducts < ActiveRecord::Migration[7.1]
  def change
    create_table :products do |t|
      t.string :brand
      t.string :owner
      t.string :ownershiptype

      t.timestamps
    end
  end
end
