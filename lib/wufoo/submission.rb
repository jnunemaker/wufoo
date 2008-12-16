module Wufoo
  class Submission
    attr_accessor :client, :form, :params
    
    def initialize(client, form, params={})
      @client = client
      @form = form
      @params = {}.merge(params || {})
    end
    
    def add_params(new_params)
      @params.merge!(new_params)
      self
    end

    def process
      Response.new(@client.post('/api/insert/', params.merge({:w_form => form})))
    end
    
    class Response    
      attr_accessor :data

      def initialize(data)
        @data = data
        populate
      end

      def success?
        return false if data.nil? || data == {}
        data['wufoo_submit'].first['success'] == 'true'
      end

      def fail?
        return true if data.nil? || data == {}
        error.size > 0
      end

      def valid?
        errors.size == 0
      end

      def error
        @error || ''
      end

      def errors
        @errors || []
      end

      def message
        @message || ''
      end

      def entry_id
        @entry_id
      end

      private
        def populate
          @message  = data['wufoo_submit'].first['confirmation_message']
          @entry_id = data['wufoo_submit'].first['entry_id']
          @error    = data['wufoo_submit'].first['error']
          @raw_errors   = data['wufoo_submit'].first['field_errors']

          if @raw_errors && @raw_errors.size > 0
            @errors = @raw_errors.inject([]) { |acc, error| acc << FieldError.new(error) }
          end
        end
    end

    class FieldError
      attr_accessor :field_id, :code, :message

      def initialize(attrs)
        @field_id = attrs['field_id']
        @code     = attrs['error_code']
        @message  = attrs['error_message']
      end
    end
  end
end