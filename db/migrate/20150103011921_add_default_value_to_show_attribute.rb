class AddDefaultValueToShowAttribute < ActiveRecord::Migration
  def up
    change_column :events, :approved, :boolean, :default => false
  end

  def down
    change_column :events, :approved, :boolean, :default => nil
  end
end