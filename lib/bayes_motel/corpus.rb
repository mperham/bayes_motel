module BayesMotel
  class Corpus
    attr_reader :name
    attr_reader :total_count
    attr_reader :data

    def initialize(name)
      @name = name
      @total_count = 0
      @data = {}
    end
    
    def train(doc, category)
      @total_count += 1
      _training(doc, category)
    end
    
    def score(doc)
      _score(doc)
    end
      
    # The default classification algorithm just picks
    # the category with the highest score.
    def classify(doc)
      results = score(doc)
      max = [:none, 0]
      results.each_pair do |(k, v)|
        max = [k, v] if v > max[1]
      end
      max
    end
    
    def cleanup
      @data.each_pair do |k, v|
        clean(@data, k, v)
      end
    end
    
    private

    def _score(variables, name='', odds={})
      variables.each_pair do |k, v|
        case v
        when Hash
          _score(v, "#{name}_#{k}", odds)
        else
          @data.each_pair do |category, raw_counts|
            cat = odds[category] ||= {}
            keys = raw_counts["#{name}_#{k}"] || {}
            cat["#{name}_#{k}_#{v}"] = Float(keys[v] || 0) / @total_count
          end
        end
      end
      odds.inject({}) { |memo, (key, value)| memo[key] = value.inject(0) { |memo, (key, value)| memo += value }; memo }
    end
    
    def _training(variables, category, name='')
      variables.each_pair do |k, v|
        case v
        when Hash
          _training(v, category, "#{name}_#{k}")
        else
          cat = (@data[category] ||= {})
          values = (cat["#{name}_#{k}"] ||= {})
          values[v] ||= 0
          values[v] += 1
        end
      end
    end

    def clean(hash, k, v)
      case v
      when Hash
        v.each_pair do |key, value|
          clean(v, key, value)
        end
        if v.empty?
          hash.delete(k)
        elsif v.size == 1 and v['other']
          hash.delete(k)
        end
      else
        if v < (@total_count * 0.03).floor
          hash['other'] ||= 0
          hash['other'] += v
          hash.delete(k)
        end
      end
    end

  end
end