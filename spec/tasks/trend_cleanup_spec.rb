# frozen_string_literal: true

require "rails_helper"
require "rake"

RSpec.describe("cleanup:expired_gtrends", type: :task) do
  let(:task) { Rake::Task["cleanup:expired_gtrends"] }

  before do
    Rake::Task.define_task(:environment)
    Rails.application.load_tasks

    @expired_gtrend = create(:gtrend, :created_by_guest, created_at: 2.days.ago)
    @active_gtrend  = create(:gtrend, :created_by_guest, created_at: 1.hour.ago)
    @user_gtrend    = create(:gtrend, :created_by_user,  created_at: 2.days.ago)
  end

  after { task.reenable }

  it "deletes gtrends created by guests more than one day ago" do
    expect { task.invoke }.to change(Gtrend, :count).from(3).to(2)
    expect(Gtrend.find_by(id: @expired_gtrend.id)).to be_nil
    expect(Gtrend.find_by(id: @active_gtrend.id)).to be_present
    expect(Gtrend.find_by(id: @user_gtrend.id)).to be_present
  end
end
