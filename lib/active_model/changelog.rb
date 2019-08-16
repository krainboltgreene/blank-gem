module ActiveModel
  module Changelog
    extend ActiveSupport::Concern

    def self.store
      Thread.current[:audited_store] ||= {}
    end

    def self.with_context(actor: nil, metadata: {})
      store[:actor] = actor
      store[:metadata] = metadata
      yield
    ensure
      store.clear
    end

    included do

    end

    class_methods do

    end
  end
end
