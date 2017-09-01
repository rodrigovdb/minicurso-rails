class CreatePeople < ActiveRecord::Migration[5.1]
  def change
    create_table :people do |t|
      t.string :name, null: false
      t.date   :birth_date
      t.string :email
      t.string :phone

      t.timestamps
    end
  end
end
