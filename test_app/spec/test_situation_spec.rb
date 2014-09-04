require_relative 'spec_helper'

class SendEmailWorker < Seam::Worker
end

describe "testing the sidekiq integration into seam" do
  it "should make the worker a sidekiq worker" do
    SendEmailWorker.new.is_a?(Sidekiq::Worker).must_equal true
  end

  describe "the perform method" do

    let(:effort_id) { Object.new }

    let(:effort) do
      Struct.new(:id, :next_step).new effort_id, Object.new
    end

    let(:worker) do
      w = SendEmailWorker.new
      w.stubs(:execute)
      w
    end

    let(:next_worker_class) do
      c = Object.new
      c.stubs(:perform_async)
      c.stubs(:perform_in)
      c
    end

    let(:next_worker) do
      w = Object.new
      w.stubs(:class).returns next_worker_class
      w
    end

    before do
      Seam::Effort.stubs(:find).with(effort_id).returns effort
      Seam::Worker.stubs(:handler_for).returns nil
    end

    it "should look up the effort, then execute it" do
      worker.expects(:execute).with effort

      worker.perform effort_id
    end

    describe "and there is a next step to execute" do

      before do
        Seam::Worker.stubs(:handler_for).with(effort.next_step).returns next_worker
      end

      it "should pass it to sidekiq" do
        next_worker_class.expects(:perform_async).with effort_id
        worker.perform effort_id
      end
    end

  end
end
