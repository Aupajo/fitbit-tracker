class RenameMonthlyStepsToLast7DaysSteps < ActiveRecord::Migration[5.0]
  def change
    rename_column :readings, :monthly_steps, :last_7_days_steps
  end
end
