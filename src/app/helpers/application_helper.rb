module ApplicationHelper

  def ontology_link_generator(type, id)
    id = id.sub ":", "_" # necessary beacause the url uses _ instead of : in the id                  
    url = "https://www.ebi.ac.uk/ols4/ontologies/#{type}/classes/http%253A%252F%252Fpurl.obolibrary.org%252Fobo%252F#{id}"
    return(url)
  end
  
  def display_study s
    html = s.first_author + ", " + s.year.to_s
    return html
  end

  def display_nber_cells n
    return Basic.format_number_with_apostrophes(n)
  end
  
  def display_field f, d, h
    vals = d[f] #.uniq ### why to put a uniq? should be already uniq no?
    html = ''
    if vals.length > 1 
      
      #html += "<button class='btn dropdown-toggle' type='button' data-bs-toggle='dropdown' aria-expanded='false'>"
      html += "<span class='dropdown-toggle pointer' data-bs-toggle='dropdown' aria-expanded='false'>"
      html += "<i> #{vals.length} #{h[f][:label].to_s.downcase.pluralize}</i>"
      #    html += "</button>
       html += "</span> 
                 <ul class='dropdown-menu'>"
      
      for i in (0 .. vals.length - 1)
        html += "<li class='px-2 py-1'>"
         case f
         when :tissue
           html += link_to vals[i], "#{ontology_link_generator "uberon", d[:tissue_uberon][i]}", target: "_blank"
         when :development_stage
           type =  d[f][0].split(":")[0].downcase
           html += link_to vals[i], "#{ontology_link_generator type, d[:developmental_stage_id][i]}", target: "_blank"
        else
           html += vals[i]
         end
        html += " </li>"
      end
      html += "</ul>"

    else

      if !(vals.length == 0)                                                                                                                   
        empty = (d[f][0].nil?) ? true : false                                                                                               
        #   html += "<td class='text-center " + ((empty) ? "bg-light": "" ) + "'>"
        case f                                                                                                                                        
        when :tissue                                                                                                                               
          html += "<i>#{h[f][:label].to_s.downcase}</i>: " + link_to(d[f][0], "#{ontology_link_generator "uberon", d[:tissue_uberon][0]}", target: "_blank")                             
        when :developmental_stage                                                                                                                       
          type =  d[f][0].split(":")[0].downcase                                                                                         
          html +=  "<i>#{h[f][:label].to_s.downcase}</i>: " + link_to(d[f][0], "#{ontology_link_generator type, d[:developmental_stage_id][0]}", target: "_blank")                                 
          else
          html += "<i>#{h[f][:label].to_s.downcase}</i>: " + d[f][0]                                                                                                                      
        end   
      #else                                                                                                                                                           
      #  html += "<td class='bg-light'>                                                                                                                                          
      #                      </td>"
      end             
      
    end
    return html
    
  end
  
end
