module BayesMotel
  module Persistence
    class MemoryInterface
      def initialize(name)
        @classifier = {:name=>name,:data=>{},:total_count=>0}
        @documents = {}
      end
      def delete 
        @classifier = {:name=>'',:data=>{},:total_count=>0}
      end
      def increment_total
        @classifier[:total_count] += 1
      end
      def total_count
        @classifier[:total_count]
      end
      def raw_counts(node)
        @classifier[:data][node] || []
      end
      def save_training(category, node, score, polarity)
        incrementer = polarity == "positive" ? 1 : -1 
        #If we haven't seen this v, we always treat polarity as positive.
        #Make it look like this: {@classifier=>{:data=>{node=>{category=>{score=>count,otherscore=>othercount}}}}
        #score/count clarification: score can be more than 1 if you have multiple incidences in the same doc. 
        #Count is the number of times we've seen that particular incidence.
        @classifier[:data][node] ? @classifier[:data][node][category] ? @classifier[:data][node][category][score] ? @classifier[:data][node][category][score] += incrementer : @classifier[:data][node][category].store(score,1) : @classifier[:data][node].store(category, {score=>1}) :  @classifier[:data].store(node, {category => {score=>1}})
      end
      def create_document(doc_id,category)
        @documents.store(doc_id,category)
      end
      def edit_document(doc_id,category)
        @documents[doc_id] = category
      end
      def document_category(doc_id)
        @documents[doc_id]
      end
      def destroy_document(doc_id)
      #call BayesMotel::Corpus.destroy_document in order to decrement the training corpus - this method only destroys the document link itself  
        @documents.delete(doc_id)
      end
      def destroy_classifier
        @classifier = nil
        @documents = nil
      end
      def save_to_mongo
        #note that checking for duplicates and changing categorization must be done using MongoInterface directly-
        #this batch job does not have the info to do a granular decrement.
        @mongo = BayesMotel::Persistence::MongomapperInterface.new(@classifier[:name])
        @documents.each do |doc_id, category_name|
          @mongo.increment_total
          @mongo.create_document(doc_id, category_name)
        end
        @classifier[:data].each do |node_name, category_hash|
          category_hash.each do |category_name, score_hash|
            score_hash.each do |score, count|
              count.times do
                @mongo.save_training(category_name, node_name, score, "positive")
              end  
            end
          end
        end
      end
    end
  end
end