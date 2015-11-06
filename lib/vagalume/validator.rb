module Vagalume
  class Validator

      VALID_PARAMS    = [:mus, :art, :musid, :nolyrics, :ytid]
      MINIMUM_SEARCH  = [:mus, :art]
      MINIMUM_GET     = [:musid]

      def confirm(criteria)
        valid_format?(criteria)
        @criteria = symbolize_keys(criteria)

        remove_empty_and_non_valid_params
        minimum_param_present?

        validate_mus
        validate_art
        validate_musid
        validate_nolyrics
        validate_ytid

        @criteria
      end

      def valid_format?(criteria)
        raise ArgumentError.new(
          "give an hash as search criteria"
        ) unless( criteria.is_a? Hash )
      end

      def symbolize_keys(hash)
        hash.inject({}){|result, (key, value)|
          new_key = case key
                    when String then key.to_sym
                    else key
                    end
          new_value = case value
                      when Hash then symbolize_keys(value)
                      else value
                      end
          result[new_key] = new_value
          result
        }
      end

      def remove_empty_and_non_valid_params
        @criteria.keep_if{|k,v| ( (VALID_PARAMS.include? k) ) }
      end

      def minimum_param_present?
        if @criteria.none?{|k,_| MINIMUM_SEARCH.include? k} and @criteria.none?{|k,_| MINIMUM_GET.include? k}
          raise ArgumentError.new(
            "minimum params to start a search is at least one of: #{MINIMUM_SEARCH.join(',')} or #{MINIMUM_GET.join(',')}"
          )
        end
      end

      def check_type(var, type)
        if not var.is_a? type
          raise ArgumentError.new("#{var} param should be a #{type}")
        end
      end

      def check_boolean(var)
        unless !!var == var
          raise ArgumentError.new("#{var} param should be a #{type}")
        end
      end

      def validate_mus
        if @criteria.has_key? :mus
          check_type(@criteria[:mus],String)
        end
      end

      def validate_art
        if @criteria.has_key? :art
          check_type(@criteria[:art],String)
        end
      end

      def validate_musid
        if @criteria.has_key? :musid
          check_type(@criteria[:musid],String)
        end
      end

      def validate_nolyrics
        if @criteria.has_key? :nolyrics
          check_boolean(@criteria[:nolyrics])
          @criteria[:nolyrics] = @criteria[:nolyrics] ? "1" : "0"
        end
      end

      def validate_ytid
        if @criteria.has_key? :ytid
          check_boolean(@criteria[:ytid])
          @criteria[:extra] = @criteria.delete(:ytid) ? "ytid" : ""
        end
      end
  end
end
