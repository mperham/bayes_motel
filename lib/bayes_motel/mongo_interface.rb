module BayesMotel
  module Persistence
    class MongoInterface
      def initialize(name)
        @classifier = BayesMotel::Mongo::Classifier.find_by_name(name) || create_classifier(name)
      end
      def raw_counts(node)
        nodes = BayesMotel::Mongo::Node.all(:classifier=>@classifier.id, :name=> node)
        map_nodes = {}
        #format the nodes like so: {category_name=>{value, incidence}}
        nodes.map {|node| map_nodes[cat_name(node.category)] ? map_nodes[cat_name(node.category)].store(node.value,node.incidence) : map_nodes[cat_name(node.category)] = {node.value,node.incidence} }
        map_nodes
      end
      def save_training(category, node_name, score, polarity)
        category = BayesMotel::Mongo::Category.first(:conditions=>{:classifier=>@classifier.id, :name=> category}) || create_category(category)
        node = BayesMotel::Mongo::Node.first(:conditions=>{:classifier=>@classifier.id, :category=>category.id, :name=>node_name, :value=>score}) || create_node(category.id,node_name,score)
        polarity == "positive" ? node.incidence += 1 : node.incidence -= 1
        node.save
      end
      def create_document(doc_id, category_name)
        category = BayesMotel::Mongo::Category.first(:conditions=>{:classifier=>@classifier.id, :name=> category_name}) || create_category(category_name)
        BayesMotel::Mongo::RawDocument.new(:doc_id=>doc_id, :category=>category.id, :classifier=>@classifier.id).save
      end
      def edit_document(doc_id, category_name)
        category = BayesMotel::Mongo::Category.first(:conditions=>{:classifier=>@classifier.id, :name=> category_name}) || create_category(category_name)
        doc = BayesMotel::Mongo::RawDocument.first(:conditions=>{:doc_id=>doc_id, :classifier=>@classifier.id})
        doc.category = category.id
        doc.save
      end
      def document_category(doc_id)
        doc = BayesMotel::Mongo::RawDocument.first(:conditions=>{:doc_id=>doc_id,:classifier=>@classifier.id} )
        doc ? BayesMotel::Mongo::Category.find(doc.category).name : nil
      end
      def destroy_classifier 
        BayesMotel::Mongo::Node.all(:classifier=>@classifier.id).each do |n| n.destroy end
        BayesMotel::Mongo::Category.all(:classifier=>@classifier.id).each do |c| c.destroy end
        BayesMotel::Mongo::RawDocument.all(:classifier=>@classifier.id).each do |r| r.destroy end 
        @classifier.destroy
      end
      def destroy_document(doc_id)
        #call BayesMotel::Corpus.destroy_document in order to decrement the training corpus - this method only destroys the document link itself
        BayesMotel::Mongo::RawDocument.first(:conditions=>{:classifier=>@classifier.id,:doc_id=>doc_id}).destroy
      end
      def increment_total
        @classifier.total_count += 1
        @classifier.save
      end
      def total_count
        @classifier.total_count
      end
      
      private
      
      def create_category(category_name)
       category = BayesMotel::Mongo::Category.new(:classifier=>@classifier.id, :name=>category_name)
       category.save
       category
     end
     def create_node(category, node_name, score)
       node = BayesMotel::Mongo::Node.new(:classifier=>@classifier.id, :category=>category, :name=>node_name, :value=>score, :incidence=>0)
       node.save
       node
     end
     def create_classifier(name)
       classifier = BayesMotel::Mongo::Classifier.new(:name=>name, :total_count=> 0)
       classifier.save
       classifier
     end
     def cat_name(id)
       BayesMotel::Mongo::Category.find(id).name
     end
     
    end
  end
end