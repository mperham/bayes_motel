module BayesMotel
  module Persistence
    class MongoidInterface
      def initialize(name)        
        @classifier = BayesMotel::Mongoid::Classifier.where(:name => name).first || create_classifier(name)
      end
      def raw_counts(node)
        nodes = BayesMotel::Mongoid::Node.where(:classifier => @classifier.id, :name => node)
        map_nodes = {}
        #format the nodes like so: {category_name=>{value, incidence}}
        nodes.map { |node| 
          if map_nodes[cat_name(node.category)]
            map_nodes[cat_name(node.category)].store(node.value, node.incidence)
          else
            map_nodes[cat_name(node.category)] = {node.value => node.incidence}
          end
        }
        map_nodes
      end
      def save_training(category, node_name, score, polarity)
        category = BayesMotel::Mongoid::Category.where(:classifier => @classifier.id, :name => category).first || create_category(category)
        node = BayesMotel::Mongoid::Node.where(:classifier => @classifier.id, :category => category.id, :name => node_name, :value => score).first || create_node(category.id, node_name, score)
        # puts "node: #{node.inspect}"
        polarity == "positive" ? node.incidence += 1 : node.incidence -= 1
        node.save
      end
      def create_document(doc_id, category_name)
        category = BayesMotel::Mongoid::Category.where(:classifier=>@classifier.id, :name=> category_name).first || create_category(category_name)
        BayesMotel::Mongoid::RawDocument.new(:doc_id => doc_id, :category => category.id, :classifier => @classifier.id).save
      end
      def edit_document(doc_id, category_name)
        category = BayesMotel::Mongoid::Category.where(:classifier=>@classifier.id, :name=> category_name).first || create_category(category_name)
        doc = BayesMotel::Mongoid::RawDocument.where(:doc_id=>doc_id, :classifier=>@classifier.id).first
        doc.category = category.id
        doc.save
      end
      def document_category(doc_id)
        doc = BayesMotel::Mongoid::RawDocument.where(:doc_id => doc_id, :classifier => @classifier.id ).first
        doc ? BayesMotel::Mongoid::Category.find(doc.category).name : nil
      end
      def destroy_classifier 
        BayesMotel::Mongoid::Node.where(:classifier => @classifier.id).each do |n| n.destroy end
        BayesMotel::Mongoid::Category.where(:classifier => @classifier.id).each do |c| c.destroy end
        BayesMotel::Mongoid::RawDocument.where(:classifier => @classifier.id).each do |r| r.destroy end 
        @classifier.destroy
      end
      def destroy_document(doc_id)
        #call BayesMotel::Corpus.destroy_document in order to decrement the training corpus - this method only destroys the document link itself
        BayesMotel::Mongoid::RawDocument.where(:classifier => @classifier.id, :doc_id => doc_id).first.destroy
      end
      def increment_total
        @classifier.total_count += 1
        @classifier.save
      end
      
      def total_count
        @classifier.total_count
      end
      
      def cleanup
        destroy_classifier
      end
      
      private
      
      def create_category(category_name)
       category = BayesMotel::Mongoid::Category.new(:classifier => @classifier.id, :name => category_name)
       category.save
       category
     end
     def create_node(category, node_name, score)
       node = BayesMotel::Mongoid::Node.new(:classifier => @classifier.id, :category => category, :name => node_name, :value => score, :incidence => 0)
       node.save
       node
     end
     def create_classifier(name)
       classifier = BayesMotel::Mongoid::Classifier.new(:name => name, :total_count => 0)
       classifier.save
       classifier
     end
     def cat_name(id)
       BayesMotel::Mongoid::Category.find(id).name
     end
     
    end
  end
end