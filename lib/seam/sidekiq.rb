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
      next_worker = Seam::Worker.handler_for effort.next_step
      return unless next_worker
      if effort.next_execute_at <= Time.now
        next_worker.class.perform_async effort.id
      else
        next_worker.class.perform_in effort.next_execute_at - Time.now, effort.id
      end
    end
  end
end
