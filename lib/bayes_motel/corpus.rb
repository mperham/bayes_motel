module BayesMotel
  class Corpus
    def initialize(persistence)
      @persistence = persistence
    end
    def train(doc, category, id=0)
      id == 0 ? id = @persistence.total_count : old_category = @persistence.document_category(id) 
      if old_category 
        if old_category.to_s != category.to_s
          @persistence.edit_document(id, category)
          _training(doc,old_category, "negative")
          _training(doc, category)
        end
      else
        @persistence.increment_total()
        @persistence.create_document(id, category)
        _training(doc, category)
      end
    end
    def score(doc)
      _score(doc)
    end
    def destroy_document(doc, id, category=nil )
      unless category
        category = @persistence.document_category(id)
      end
      @persistence.destroy_document(id)
      _training(doc, category, "negative")
    end
    def destroy_classifier
      @persistence.destroy_classifier
    end
    
    def cleanup
      # TODO
    end
    
    def total_count
      @persistence.total_count
    end
    
    def classify(doc)
      results = score(doc)
      max = [:none, 0]
      results.each_pair do |(k, v)|
        max = [k, v] if v > max[1]
      end
      max
    end
    
    private
    def _score(variables, name='', odds={})
      variables.each_pair do |k, v|
        case v
        when Hash
          _score(v, "#{name}_#{k}", odds)
        else
          @persistence.raw_counts("#{name}_#{k}").each do |category, keys|
            cat = odds[category] ||= {}
            cat["#{name}_#{k}_#{v}"] = Float(keys[v] || 0) / @persistence.total_count
          end
        end
      end
      odds.inject({}) { |memo, (key, value)| memo[key] = value.inject(0) { |acc_memo, (acc_key, acc_value)| acc_memo += acc_value }; memo }
    end
    def _training(variables, category, polarity="positive" , name='')
      variables.each_pair do |k, v|
        case v
        when Hash
          _training(v, category, polarity, "#{name}_#{k}")
        else
          @persistence.save_training(category, "#{name}_#{k}", v, polarity) 
        end
      end
    end
  end
end