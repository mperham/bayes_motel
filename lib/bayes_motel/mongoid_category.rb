module BayesMotel
  module Mongoid
    class Category
      include ::Mongoid::Document
      field :name
      field :classifier
    end
  end
end
