class ChangeJobStatusToEnumInGtrends < ActiveRecord::Migration[7.1]
  def up
    change_column_default :gtrends, :job_status, nil
    Gtrend.where(job_status: "queued").update_all(job_status: 0)
    Gtrend.where(job_status: "failed").update_all(job_status: 1)
    Gtrend.where(job_status: [nil, "done", "completed"]).update_all(job_status: 2)
    change_column :gtrends, :job_status, :integer, using: "job_status::integer"
  end

  def down
    change_column :gtrends, :job_status, :string
  end
end
