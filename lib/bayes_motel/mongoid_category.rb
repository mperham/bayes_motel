module BayesMotel
  module Mongoid
    class Category
      include ::Mongoid::Document
      field :name
      field :classifier

      def classifier_object
        Classifier.find(classifier)
      end

    end
  end
end
