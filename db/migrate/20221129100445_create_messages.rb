class CreateMessages < ActiveRecord::Migration[7.0]
  def change
    create_table :messages do |t|
      t.text :content
      t.references :author, null: false, foreign_key: { to_table: :users }
      t.references :booking, null: false, foreign_key: true

      t.timestamps
    end
  end
end
