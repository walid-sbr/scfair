desc '####################### load ext_sources'
task load_ext_sources: :environment do
  puts 'Executing...'

  ## load existing ext_sources

  ext_sources = ExtSource.all
  broken_links = []
  Dataset.all.each do |d|

    ext_source_ids = []
    if d.link_to_raw_data.size > 0
      d.link_to_raw_data.each_with_index do |l, i|
        es = nil
        id = nil
        ext_sources.each do |tmp_es|
          tmp_es.url_mask.split(" ").each do |url_mask|
            re = url_mask.gsub(/[\/=\?]/){|match| "\\" + match}.gsub("\#ID", "(.+?)")
            #          puts re
            if m = l.match(/^#{re}\/?$/)
              puts "#{l} matches #{re} step1 => #{m[1]} #{tmp_es.id_regexp}"
              if tmp_es.id_regexp != ''
                if m[1].match(/#{tmp_es.id_regexp}/)
                  id = m[1]
                  puts "#{l} matches #{tmp_es.name} step2"
                  es = tmp_es
                  break
                end
              else
                es = tmp_es
                break
              end
            end
            break if es
          end
        end

        #        puts "testing link #{l}..."
        #        if Basic.link_alive_quick?(l)
        
        ext_source_ids.push (es) ? "#{es.id}|#{id || ''}" : nil
        #       else
        #         ext_source_ids.push "-1"
        #         puts "broken link #{l}"
        #         broken_links.push [id, l]
        #       end
      end
      if ext_source_ids.compact.size > 0
        puts ext_source_ids.to_json
        d.update({:ext_source_ids => ext_source_ids})
      end
    end

  end
  puts "BROKEN LINKS: "
  puts broken_links.to_json
    
  
end
