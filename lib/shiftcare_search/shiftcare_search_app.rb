require "json"

module ShiftcareSearch
  class ShiftcareSearchApp
    def initialize(file_path)
      @data = load_data(file_path)
    end

    def search(query)
      results = @data.select { |datum| datum["full_name"].downcase.include?(query.downcase) }
      if results.any?
        puts "Search Results:"
        results.each { |datum| print(datum) }
      else
        puts "No data found matching '#{query}'."
      end
    end

    def find_dupes
      email_map = Hash.new { |hash, key| hash[key] = [] }
      @data.each { |datum| email_map[datum["email"]] << datum }

      duplicates = email_map.select { |_, list| list.size > 1 }
      if duplicates.any?
        puts "Duplicate Emails Found:"
        duplicates.each do |email, data|
          puts "\nEmail: #{email}"
          data.each { |datum| print(datum) }
        end
      else
        puts "No duplicate emails found."
      end
    end

    private

    def load_data(file_path)
      JSON.parse(File.read(file_path))
    rescue Errno::ENOENT
      puts "File not found: #{file_path}"
      exit
    rescue JSON::ParserError => e
      puts "Invalid JSON file: #{e.message}"
      exit
    end

    def print(datum)
      puts "- ID: #{datum['id']}, Full Name: #{datum['full_name']}, Email: #{datum['email']}"
    end
  end
end
