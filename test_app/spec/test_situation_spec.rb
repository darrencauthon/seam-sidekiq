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
      Struct.new(:id, :next_step, :next_execute_at)
            .new effort_id, Object.new, next_execute_at
    end

    let(:next_execute_at) { now }

    let(:worker) do
      w = SendEmailWorker.new
      w.stubs(:execute)
      w
    end

    let(:next_worker_class) do
      c = Object.new
      c
    end

    let(:next_worker) do
      w = Object.new
      w.stubs(:class).returns next_worker_class
      w
    end

    let(:now) { Time.now }

    before do
      Timecop.freeze now
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

      describe "and the next date is now" do

        it "should pass it to sidekiq" do
          next_worker_class.expects(:perform_async).with effort_id
          worker.perform effort_id
        end

      end

      describe "and the next date is sometime in the future" do

        let(:next_execute_at) { now + 5.days }

        it "should pass it to sidekiq" do
          next_worker_class.expects(:perform_in).with 5.days, effort_id
          worker.perform effort_id
        end
      end

      describe "and the next date is in the past" do

        let(:next_execute_at) { now - 5.days }

        it "should pass it to sidekiq" do
          next_worker_class.expects(:perform_async).with effort_id
          worker.perform effort_id
        end

      end

    end

  end
end
