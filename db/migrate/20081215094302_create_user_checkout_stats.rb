class CreateUserCheckoutStats < ActiveRecord::Migration
  def change
    create_table :user_checkout_stats do |t|
      t.datetime :start_date
      t.datetime :end_date
      t.text :note
      t.string :state

      t.timestamps
    end
  end
end
