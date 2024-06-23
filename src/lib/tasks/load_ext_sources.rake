desc '####################### load ext_sources'
task load_ext_sources: :environment do
  puts 'Executing...'

  ## load existing ext_sources

  ext_sources = ExtSource.all
  
  Dataset.all.each do |d|

    ext_source_ids = []
    if d.link_to_raw_data.size > 0
      d.link_to_raw_data.each_with_index do |l, i|
        es = nil
        ext_sources.each do |tmp_es|
          re = tmp_es.url_mask.gsub(/[\/=\?]/){|match| "\\" + match}.gsub("\#ID", "(.+?)")
          #          puts re
          if m = l.match(/^#{re}$/)
            puts "#{l} matches #{re} step1 => #{m[1]} #{tmp_es.id_regexp}"
            if m[1].match(/#{tmp_es.id_regexp}/)
              puts "#{l} matches #{tmp_es.name} step2"
              es = tmp_es
              break
            end
          end
        end
        
        ext_source_ids.push (es) ? es.id : nil
       
      end
      if ext_source_ids.compact.size > 0
        puts ext_source_ids.to_json
        d.update({:ext_source_ids => ext_source_ids})
      end
    end
    

  end
  
  
end
