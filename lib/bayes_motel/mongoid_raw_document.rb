module BayesMotel
  module Mongoid
    class RawDocument
      include ::Mongoid::Document
      field :doc_id, :type => Integer
      field :category
      field :classifier
    end
  end
end
