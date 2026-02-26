class AddValidatedToEvents < ActiveRecord::Migration[8.1]
  def change
    add_column :events, :validated, :boolean
  end
end
