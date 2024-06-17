require 'rake'

namespace :obo do
  desc "Parse .obo file and update Ontology table with adjacency lists"
  task :parse, [:file_path] => :environment do |t, args|
    file_path = args[:file_path]

    if file_path.nil?
      puts "Usage: rake obo:parse[file_path]"
      exit
    end

    identifier_to_name = {}
    children = Hash.new { |hash, key| hash[key] = [] }
    parents = Hash.new { |hash, key| hash[key] = [] }

    current_term = {}
    File.foreach(file_path) do |line|
      line.chomp!
      if line == "[Term]"
        if current_term.any?
          identifier = current_term[:identifier]
          name = current_term[:name].to_s.strip.empty? ? "nil" : current_term[:name]
          identifier_to_name[identifier] = name

          if current_term[:is_a]
            parent_identifier = current_term[:is_a]
            children[parent_identifier] << identifier
            parents[identifier] << parent_identifier
          end

          if current_term[:part_of]
            parent_identifier = current_term[:part_of]
            children[parent_identifier] << identifier
            parents[identifier] << parent_identifier
          end
        end
        current_term = {}
      elsif line.start_with?("id: ")
        id = line.split(' ')[1].strip
        current_term[:identifier] = id if id.match?(/^[A-Za-z]+:\d+$/)
      elsif line.start_with?("name: ")
        current_term[:name] = line.split(' ', 2)[1].strip
      elsif line.start_with?("is_a: ")
        is_a = line.split(' ')[1].strip
        current_term[:is_a] = is_a if is_a.match?(/^[A-Za-z]+:\d+$/) && is_a != current_term[:identifier]
      elsif line.start_with?("relationship: part_of ")
        part_of = line.split(' ')[2].strip
        current_term[:part_of] = part_of if part_of.match?(/^[A-Za-z]+:\d+$/) && part_of != current_term[:identifier]
      end
    end

    # Insert the last term
    if current_term.any?
      identifier = current_term[:identifier]
      name = current_term[:name].to_s.strip.empty? ? "nil" : current_term[:name]
      identifier_to_name[identifier] = name

      if current_term[:is_a]
        parent_identifier = current_term[:is_a]
        children[parent_identifier] << identifier
        parents[identifier] << parent_identifier
      end

      if current_term[:part_of]
        parent_identifier = current_term[:part_of]
        children[parent_identifier] << identifier
        parents[identifier] << parent_identifier
      end
    end

    # Store the results in the database
    identifier_to_name.each do |identifier, name|
      child_list = children[identifier].uniq.empty? ? "nil" : children[identifier].uniq.join(',')
      parent_list = parents[identifier].uniq.empty? ? "nil" : parents[identifier].uniq.join(',')

      puts "add/update ontology term #{identifier}"
      ontology_record = OntologyTerm.find_or_initialize_by(identifier: identifier)
      ontology_record.update(
        name: name,
        children: child_list,
        parents: parent_list
      )
    end

    puts "Ontology table updated with adjacency lists successfully."
  end
end
