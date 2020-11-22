class ChangeFirstCallDefault < ActiveRecord::Migration[5.0]
  def change
    change_column_default :projects, :first_call, false
  end
end
