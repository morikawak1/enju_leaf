class CreateBookstores < ActiveRecord::Migration[5.1]
  def change
    create_table :bookstores, id: :uuid, default: 'gen_random_uuid()' do |t|
      t.string :name, null: false
      t.string :zip_code
      t.text :address
      t.text :note
      t.string :telephone_number
      t.string :fax_number
      t.string :url
      t.integer :position

      t.timestamps
    end
  end
end
