class AddApprovedColumnToEvents < ActiveRecord::Migration
  def change
    add_column :events, :approved, :boolean
  end
end
