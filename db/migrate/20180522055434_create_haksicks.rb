class CreateHaksicks < ActiveRecord::Migration[5.0]
  def change
    create_table :haksicks do |t|
    t.string :day
    t.string :date
    t.string :morning_a
    t.string :morning_b
    t.string :take_out
    t.string :lunch_a
    t.string :set
    t.string :dinner
    t.timestamps
    end
  end
end
