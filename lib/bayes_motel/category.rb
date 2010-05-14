module BayesMotel
  module Mongo
    class Category
      include MongoMapper::Document
      key :name , String
      key :classifier_id , :class_name => 'Mongo::ObjectID'
    end
  end
end
