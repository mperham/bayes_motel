module BayesMotel
  module Mongoid
    class Node
      include ::Mongoid::Document
      field :name
      field :value #, :type => Integer
      field :incidence, :type => Integer
      field :category
      field :classifier
    end
  end
end
