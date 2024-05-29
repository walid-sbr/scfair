require 'rake'

namespace :obo do
  desc "Parse .obo file and update Ontology table with adjacency lists"
  task :parse, [:file_path] => :environment do |t, args|
    file_path = args[:file_path]

    if file_path.nil?
      puts "Usage: rake obo:parse[file_path]"
      exit
    end

    id_to_name = {}
    children = Hash.new { |hash, key| hash[key] = [] }
    parents = Hash.new { |hash, key| hash[key] = [] }

    current_term = {}
    File.foreach(file_path) do |line|
      line.chomp!
      if line == "[Term]"
        if current_term.any?
          id = current_term[:id]
          name = current_term[:name].to_s.strip.empty? ? "nil" : current_term[:name]
          id_to_name[id] = name

          if current_term[:is_a]
            parent_id = current_term[:is_a]
            children[parent_id] << id
            parents[id] << parent_id
          end

          if current_term[:part_of]
            parent_id = current_term[:part_of]
            children[parent_id] << id
            parents[id] << parent_id
          end
        end
        current_term = {}
      elsif line.start_with?("id: ")
        current_term[:id] = line.split('id: ').last
      elsif line.start_with?("name: ")
        current_term[:name] = line.split('name: ').last
      elsif line.start_with?("is_a: ")
        current_term[:is_a] = line.split('is_a: ').last.split(' ! ').first
      elsif line.start_with?("relationship: part_of ")
        current_term[:part_of] = line.split('relationship: part_of ').last.split(' ! ').first
      end
    end

    # Insert the last term
    if current_term.any?
      id = current_term[:id]
      name = current_term[:name].to_s.strip.empty? ? "nil" : current_term[:name]
      id_to_name[id] = name

      if current_term[:is_a]
        parent_id = current_term[:is_a]
        children[parent_id] << id
        parents[id] << parent_id
      end

      if current_term[:part_of]
        parent_id = current_term[:part_of]
        children[parent_id] << id
        parents[id] << parent_id
      end
    end

    # Store the results in the database
    id_to_name.each do |id, name|
      child_list = children[id].uniq.empty? ? "nil" : children[id].uniq.join(',')
      parent_list = parents[id].uniq.empty? ? "nil" : parents[id].uniq.join(',')

      ontology_record = Ontology.find_or_initialize_by(id: id)
      ontology_record.update(
        name: name,
        children: child_list,
        parents: parent_list
      )
    end

    puts "Ontology table updated with adjacency lists successfully."
  end
end
