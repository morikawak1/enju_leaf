class CreateRealizeTypes < ActiveRecord::Migration[5.1]
  def change
    create_table :realize_types do |t|
      t.string :name
      t.text :display_name
      t.text :note
      t.integer :position

      t.timestamps
    end
  end
end
