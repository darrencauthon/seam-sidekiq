require_relative 'spec_helper'

class SendEmailWorker < Seam::Worker
end

describe "testing the sidekiq integration into seam" do
  it "should make the worker a sidekiq worker" do
    SendEmailWorker.new.is_a?(Sidekiq::Worker).must_equal true
  end
end
