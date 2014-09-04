require 'seam'
require_relative '../seam_effort'
require_relative "active_record/version"

module Seam
  module ActiveRecord
    def self.setup
      overwrite_the_persistence_layer
    end

    def self.overwrite_the_persistence_layer
      Seam::Persistence.class_eval do
        def self.find_by_effort_id effort_id
          record = SeamEffort.where(effort_id: effort_id).first
          return nil unless record
          data = HashWithIndifferentAccess.new record.data
          Seam::Effort.parse data
        end

        def self.find_all_pending_executions_by_step step
          SeamEffort.where(next_step: step)
                    .where('next_execute_at <= ?', Time.now)
                    .map do |record|
                      Seam::Effort.parse HashWithIndifferentAccess.new(record.data)
                    end
        end

        def self.find_something_to_do
          #record = Seam::Mongodb.collection
                     #.find( { 
                              #next_execute_at: { '$lte' => Time.now }, 
                              #next_step:       { '$ne'  => nil },
                              #complete:        { '$in'  => [nil, false] },
                            #} )
                     #.first
          record = SeamEffort.where('next_execute_at <= ?', Time.now)
                             .where.not(next_step: nil)
                             .where(complete: false)
                             .first
          return [] unless record
          [record].map do |x|
            Seam::Effort.parse HashWithIndifferentAccess.new(x.data)
          end
        end

        def self.save effort
          record = SeamEffort.where(effort_id: effort.id).first
          record.next_step = effort.next_step
          record.next_execute_at = effort.next_execute_at
          record.complete = effort.complete || false
          record.data = effort.to_hash
          record.save!
        end

        def self.create effort
          record = SeamEffort.new
          record.effort_id = effort.id
          record.next_step = effort.next_step
          record.next_execute_at = effort.next_execute_at
          record.complete = effort.complete || false
          record.data = effort.to_hash
          record.save!
        end

        def self.all
          SeamEffort.all
        end

        def self.destroy
          SeamEffort.delete_all
        end
      end
    end
  end
end
