require_relative 'spec_helper'

class SendEmailWorker < Seam::Worker
end

describe "testing the sidekiq integration into seam" do
  it "should make the worker a sidekiq worker" do
    SendEmailWorker.new.is_a?(Sidekiq::Worker).must_equal true
  end

  describe "the perform method" do
    it "should look up the effort, then execute it" do
      effort, effort_id = Object.new, Object.new
      Seam::Effort.stubs(:find).with(effort_id).returns effort

      worker = SendEmailWorker.new
      worker.expects(:execute).with effort

      worker.perform effort_id
    end
  end
end
