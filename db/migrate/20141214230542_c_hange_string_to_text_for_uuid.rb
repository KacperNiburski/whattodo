class CHangeStringToTextForUuid < ActiveRecord::Migration
  def change
    change_column :events, :uuid, :text
  end
end
