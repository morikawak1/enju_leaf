class CreateProduces < ActiveRecord::Migration
  def change
    create_table :produces do |t|
      t.references :patron, :null => false
      t.references :manifestation, :null => false
      t.integer :position
      t.string :type
      t.timestamps
    end
    add_index :produces, :patron_id
    add_index :produces, :manifestation_id
    add_index :produces, :type
  end
end
