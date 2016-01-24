class ChangeApprovedInEventsToTrue < ActiveRecord::Migration
  def change
    change_column_default :events, :approved, true
  end
end
