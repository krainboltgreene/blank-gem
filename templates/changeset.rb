class Changeset < ApplicationRecord
  belongs_to :auditable, polymorphic: true
  belongs_to :associated, polymorphic: true
  belongs_to :actor

  before_create :associate_actor
  before_create :assign_metadata
  before_create :set_remote_address

  scope :ascending, ->{ reorder(version: :asc) }
  scope :descending, ->{ reorder(version: :desc)}
  scope :creates, ->{ where(action: :create)}
  scope :updates, ->{ where(action: :update)}
  scope :destroys, ->{ where(action: :destroy)}
  scope :up_until, ->(timestamp){ where(%("change_sets"."created_at" <= ?), timestamp) }
  scope :from_version, ->(id){ where(%("change_sets"."version" >= ?), id) }
  scope :to_version, ->(id){ where(%("change_sets"."version" <= ?), id) }
  scope :auditable_finder, ->(auditable_id, auditable_type){ where(auditable_id: auditable_id, auditable_type: auditable_type)}

  cattr_accessor :audited_class_names
  self.audited_class_names = Set.new

  # Returns the list of classes that are being audited
  def self.audited_classes
    audited_class_names.map(&:constantize)
  end

  def self.collection_cache_key(collection = all, timestamp_column = :created_at)
    super(collection, :created_at)
  end

  # Returns a hash of the changed attributes with the new values
  def new_attributes
    (audited_changes || {}).inject({}.with_indifferent_access) do |attrs, (attr, values)|
      attrs[attr] = values.is_a?(Array) ? values.last : values
      attrs
    end
  end

  # Returns a hash of the changed attributes with the old values
  def old_attributes
    (differences || {}).inject({}.with_indifferent_access) do |attrs, (attr, values)|
      attrs[attr] = Array(values).first

      attrs
    end
  end

  # Return an instance of what the object looked like at this revision. If
  # the object has been destroyed, this will be a new record.
  def revision
    clazz = auditable_type.constantize
    (clazz.find_by_id(auditable_id) || clazz.new).tap do |m|
      self.class.assign_revision_attributes(m, self.class.reconstruct_attributes(ancestors).merge(version: version))
    end
  end

  # Allows user to undo changes
  def undo
    case action
    when 'create'
      # destroys a newly created record
      auditable.destroy!
    when 'destroy'
      # creates a new record with the destroyed record attributes
      auditable_type.constantize.create!(differences)
    when 'update'
      # changes back attributes
      auditable.update_attributes!(differences.transform_values(&:first))
    else
      raise StandardError, "invalid action given #{action}"
    end
  end

  private def associate_actor
    assign_attributes(actor: if ::Audited.store[:actor].respond_to?(:call)
      ::Audited.store[:actor].call()
    else
      ::Audited.store[:actor]
    end)
  end

  private def assign_metadata
    assign_attributes(metadata: if Audited.store[:metadata].respond_to?(:call)
      ::Audited.store[:metadata].call()
    else
      ::Audited.store[:metadata]
    end)
  end
end
