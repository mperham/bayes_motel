module BayesMotel
  module Mongomapper
    class Classifier
      include MongoMapper::Document
      key :name , String
      key :total_count , Integer
    end
  end
end
