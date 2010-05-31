module BayesMotel
  module Mongoid
    class Category
      include ::Mongoid::Document
      field :name
      field :classifier_id
    end
  end
end
