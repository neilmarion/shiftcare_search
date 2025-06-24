module ShiftcareSearch
  module Domain
    class FindDuplicates
      attr_reader :query, :data

      def initialize(data:)
        @data = data
      end

      def find_dupes
        email_map = Hash.new { |hash, key| hash[key] = [] }
        @data.each { |datum| email_map[datum["email"]] << datum }

        email_map.select { |_, list| list.size > 1 }
      end
    end
  end
end
