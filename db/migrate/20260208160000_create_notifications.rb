class CreateNotifications < ActiveRecord::Migration[7.1]
  def change
    create_table :notifications do |t|
      t.references :user, null: false, foreign_key: true
      t.string :message, null: false
      t.boolean :read, default: false, null: false
      t.string :link

      t.timestamps
    end
  end
end
