module BayesMotel
  module Persistence
    class MongomapperInterface
      def initialize(name)
        @classifier = BayesMotel::Mongomapper::Classifier.find_by_name(name) || create_classifier(name)
      end
      def raw_counts(node)
        nodes = BayesMotel::Mongomapper::Node.all(:classifier=>@classifier.id, :name=> node)
        map_nodes = {}
        #format the nodes like so: {category_name=>{value, incidence}}
        nodes.map {|node| map_nodes[cat_name(node.category)] ? map_nodes[cat_name(node.category)].store(node.value,node.incidence) : map_nodes[cat_name(node.category)] = {node.value,node.incidence} }
        map_nodes
      end
      def save_training(category, node_name, score, polarity)
        category = BayesMotel::Mongomapper::Category.first(:conditions=>{:classifier=>@classifier.id, :name=> category}) || create_category(category)
        node = BayesMotel::Mongomapper::Node.first(:conditions=>{:classifier=>@classifier.id, :category=>category.id, :name=>node_name, :value=>score}) || create_node(category.id,node_name,score)
        polarity == "positive" ? node.incidence += 1 : node.incidence -= 1
        node.save
      end
      def create_document(doc_id, category_name)
        category = BayesMotel::Mongomapper::Category.first(:conditions=>{:classifier=>@classifier.id, :name=> category_name}) || create_category(category_name)
        BayesMotel::Mongomapper::RawDocument.new(:doc_id=>doc_id, :category=>category.id, :classifier=>@classifier.id).save
      end
      def edit_document(doc_id, category_name)
        category = BayesMotel::Mongomapper::Category.first(:conditions=>{:classifier=>@classifier.id, :name=> category_name}) || create_category(category_name)
        doc = BayesMotel::Mongomapper::RawDocument.first(:conditions=>{:doc_id=>doc_id, :classifier=>@classifier.id})
        doc.category = category.id
        doc.save
      end
      def document_category(doc_id)
        doc = BayesMotel::Mongomapper::RawDocument.first(:conditions=>{:doc_id=>doc_id,:classifier=>@classifier.id} )
        doc ? BayesMotel::Mongomapper::Category.find(doc.category).name : nil
      end
      def destroy_classifier 
        BayesMotel::Mongomapper::Node.all(:classifier=>@classifier.id).each do |n| n.destroy end
        BayesMotel::Mongomapper::Category.all(:classifier=>@classifier.id).each do |c| c.destroy end
        BayesMotel::Mongomapper::RawDocument.all(:classifier=>@classifier.id).each do |r| r.destroy end 
        @classifier.destroy
      end
      def destroy_document(doc_id)
        #call BayesMotel::Corpus.destroy_document in order to decrement the training corpus - this method only destroys the document link itself
        BayesMotel::Mongomapper::RawDocument.first(:conditions=>{:classifier=>@classifier.id,:doc_id=>doc_id}).destroy
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
       category = BayesMotel::Mongomapper::Category.new(:classifier=>@classifier.id, :name=>category_name)
       category.save
       category
     end
     def create_node(category, node_name, score)
       node = BayesMotel::Mongomapper::Node.new(:classifier=>@classifier.id, :category=>category, :name=>node_name, :value=>score, :incidence=>0)
       node.save
       node
     end
     def create_classifier(name)
       classifier = BayesMotel::Mongomapper::Classifier.new(:name=>name, :total_count=> 0)
       classifier.save
       classifier
     end
     def cat_name(id)
       BayesMotel::Mongomapper::Category.find(id).name
     end
     
    end
  end
end