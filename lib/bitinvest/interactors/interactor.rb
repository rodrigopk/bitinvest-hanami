# frozen_string_literal: true

require 'hanami/interactor'

module Bitinvest
  module Interactor
    def self.included(base)
      base.class_eval do
        include Hanami::Interactor
      end
      base.prepend Interface
      base.extend(ClassMethods)
    end

    module Interface
      def _call
        catch :fail do
          validate!
          yield
        end

        _prepare!
      end
    end

    module ClassMethods
      def call(*args)
        new(*args).call
      end
    end
  end
end
