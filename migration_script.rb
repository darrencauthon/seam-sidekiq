class CreateSeamEfforts < ActiveRecord::Migration
  def change
    create_table :seam_efforts do |t|
      t.string :effort_id
      t.string :next_step
      t.datetime :next_execute_at
      t.boolean :complete
      t.text :data

      t.timestamps
    end
  end
end
