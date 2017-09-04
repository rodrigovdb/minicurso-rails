class CreatePhones < ActiveRecord::Migration[5.1]
  def change
    create_table :phones do |t|
      t.string :number
      t.references :person, foreign_key: true

      t.timestamps
    end
  end
end
