module ActiveModel
  module Changelog
    module Changset
      extend ActiveSupport::Concern

      class_methods do
        private def reconstruct_attributes(changesets)
          changesets.reduce({}) do |changeset, audit|
            attributes.merge(audit.new_attributes).merge(version: changeset.version)
          end
        end

        private def assign_revision_attributes(record, attributes)
          if record.frozen?
            record.dup.assign_attributes(attributes)
          else
            record.assign_attributes(attributes)
          end
        end
      end
    end
  end
end
