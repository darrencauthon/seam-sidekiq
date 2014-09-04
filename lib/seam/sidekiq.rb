require 'seam'

module Seam
  module Sidekiq
    def self.setup
      ::Seam::Worker.class_eval do
        include ::Sidekiq::Worker

        def perform effort_id
          effort = Seam::Effort.find effort_id
          execute effort
        end
      end
    end
  end
end
