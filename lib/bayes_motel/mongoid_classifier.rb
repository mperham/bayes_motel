module BayesMotel
  module Mongoid
    class Classifier
      include ::Mongoid::Document
      field :name
      field :total_count, :type => Integer
    end
  end
end
