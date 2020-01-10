class CreateMorningActivityResults < ActiveRecord::Migration[5.2]
  def change
    create_table :morning_activity_results do |t|
      t.references :user, foreign_key: true
      t.datetime :execution_at
      t.integer :state

      t.timestamps
    end
  end
end
