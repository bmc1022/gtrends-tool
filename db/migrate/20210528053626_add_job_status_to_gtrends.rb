class AddJobStatusToGtrends < ActiveRecord::Migration[6.0]
  def change
    add_column :gtrends, :job_status, :string, default: ''
    add_index  :gtrends, :job_status
  end
end
