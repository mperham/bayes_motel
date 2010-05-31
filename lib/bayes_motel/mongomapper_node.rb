module BayesMotel
  module Mongomapper
    class Node
      include MongoMapper::Document
      key :name , String
      key :value , Integer
      key :incidence, Integer
      key :category ,  :class_name => 'Mongo::ObjectID'
      key :classifier ,:class_name => 'Mongo::ObjectID'
    end
  end
end
