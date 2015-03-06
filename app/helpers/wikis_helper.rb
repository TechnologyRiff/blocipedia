module WikisHelper
  
  def private_checkbox
    form_for wiki do |f|
      if current_user.not_standard?
        f.label :private, class: 'checkbox' do
          link_to auth_wiki_path(wiki), method: :put, class: 'btn btn-sm' do
            f.check_box :private 
            Private
            end 
          end 
      elsif wiki.public? && current_user.standard?
        Public Wiki
      end
    end
  end

end
