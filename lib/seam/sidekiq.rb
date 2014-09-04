require 'seam'

module Seam
  module Sidekiq
    def self.setup
      ::Seam::Worker.class_eval do
        include ::Sidekiq::Worker

        def perform effort_id
          effort = Seam::Effort.find effort_id
          next_worker = Seam::Worker.handler_for effort.next_step
          if next_worker
            if effort.next_execute_at <= Time.now
              next_worker.class.perform_async effort.id
            else
              next_worker.class.perform_in effort.next_execute_at - Time.now, effort.id
            end
          end
          execute effort
        end
      end
    end
  end
end
