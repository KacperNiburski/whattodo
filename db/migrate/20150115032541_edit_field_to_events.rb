class EditFieldToEvents < ActiveRecord::Migration
  def change
    add_column :events, :edited, :boolean, default: false
  end
end
