module BayesMotel
  module Mongo
    class RawDocument
      include MongoMapper::Document
      key :doc_id, Integer
      key :category, :class_name => 'Mongo::ObjectID'
      key :classifier ,:class_name => 'Mongo::ObjectID'
    end
  end
end
