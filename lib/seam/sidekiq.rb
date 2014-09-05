require 'seam'

module Seam

  module Sidekiq

    def self.setup
      ::Seam::Worker.class_eval do
        include ::Sidekiq::Worker

        def perform effort_id
          effort = Seam::Effort.find effort_id
          execute effort
          ::Seam::Sidekiq.fire_the_worker_for_the_next_step_of effort
        end
      end
    end

    def self.fire_the_worker_for_the_next_step_of effort
      return unless worker = the_next_worker_for(effort)
      this_should_be_executed_in_the_future(effort) ?
        execute_this_in_the_future(worker, effort) :
        execute_this_now(worker, effort)
    end

    class << self

      private

      def execute_this_in_the_future worker, effort
        worker.class.perform_in time_until(effort), effort.id
      end

      def execute_this_now worker, effort
        worker.class.perform_async effort.id
      end

      def the_next_worker_for effort
        Seam::Worker.handler_for effort.next_step
      end

      def time_until effort
        effort.next_execute_at - Time.now
      end

      def this_should_be_executed_in_the_future effort
        effort.next_execute_at > Time.now
      end

    end

  end

end
