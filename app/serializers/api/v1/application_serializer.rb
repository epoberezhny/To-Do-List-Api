# frozen_string_literal: true

module Api
  module V1
    class ApplicationSerializer < Jserializer::Base
      def self.inherited(subclass)
        super
        subclass.root(:data)
      end

      def to_json(*)
        ActiveSupport::JSON.encode(as_json)
      end
    end
  end
end
