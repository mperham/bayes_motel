module BayesMotel
  module Mongoid
    class Node
      include ::Mongoid::Document
      field :name
      field :value, :field => Integer
      field :incidence, :field => Integer
      field :category
      field :classifier
    end
  end
end
