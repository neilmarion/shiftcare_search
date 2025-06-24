module ShiftcareSearch
  module Domain
    class Search
      attr_reader :query, :data

      def initialize(data:)
        @data = data
      end

      def search(query)
        data.select do |datum|
          datum["full_name"].to_s.downcase.include?(query.to_s.downcase)
        end
      end
    end
  end
end
