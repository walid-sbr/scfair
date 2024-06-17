require 'set'

namespace :obo do
  desc "Retrieve all parents and children for available tissues and developmental stages, update ontologies table"
  task :update_adjacency_lists => :environment do
    def fetch_all_parents(root_id)
      return Set.new if root_id == "nil"

      parents = Set.new
      stack = [root_id]

      until stack.empty?
        current_id = stack.pop

        next if current_id == "nil" || parents.include?(current_id)

        parents.add(current_id)


        parent_list = OntologyTerm.where(identifier: current_id).pluck(:parents).flatten.compact.uniq

        parent_list.each do |parent_ids_str|
          next if parent_ids_str.nil?

          parent_ids = parent_ids_str.split(',').map(&:strip)


          parent_ids.each do |parent_id|
            stack.push(parent_id) unless parents.include?(parent_id)
          end
        end
      end

      parents
    end

    def fetch_all_children(root_id)
      return Set.new if root_id.nil?

      children = Set.new
      stack = [root_id]

      until stack.empty?
        current_id = stack.pop

        next if current_id.nil? || children.include?(current_id)

        children.add(current_id)


        child_list = OntologyTerm.where(identifier: current_id).pluck(:children).first
        next unless child_list

        child_ids = child_list.split(',').map(&:strip)


        child_ids.each do |child_id|
          stack.push(child_id) unless children.include?(child_id)
        end
      end

      children
    end

    tissue_uberons = Dataset.pluck(:tissue_uberon).flatten.compact.uniq
    developmental_stage_ids = Dataset.pluck(:developmental_stage_id).flatten.compact.uniq

    all_ids = (tissue_uberons + developmental_stage_ids).uniq

    all_ids.each do |id|
      all_parents = fetch_all_parents(id)
      all_children = fetch_all_children(id)

    ontology_record = OntologyTerm.find_or_initialize_by(identifier: id)
      ontology_record.update(
        all_parents: all_parents.to_a.uniq.join(','),
        all_children: all_children.to_a.uniq.join(','),
        exists_in_datasets: true
      )
    end

    # Mark all other ontologies as not existing in datasets
    OntologyTerm.where.not(identifier: all_ids).update_all(exists_in_datasets: false)

    puts "Ontology table updated with all parents and children for available tissues and developmental stages."
  end
end
