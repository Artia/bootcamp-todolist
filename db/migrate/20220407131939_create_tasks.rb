class CreateTasks < ActiveRecord::Migration[7.0]
  def change
    create_table :tasks do |t|
      t.string :title
      t.datetime :date_start
      t.datetime :date_end
      t.boolean :state
      t.references :project, null: false, foreign_key: true
      t.timestamps
    end
  end
end
