class CreateTags < ActiveRecord::Migration[5.0]
  def change
    create_table :tags do |t|
      t.string :subject, limit: 25

      t.timestamps
      end
    end
end
