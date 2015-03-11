class CollabMailer < ActionMailer::Base
  default from: "technologyriff@gmail.com"

  def colab_updated(user, wiki)
    headers["Message-ID"] = "<wikis/#{wiki.id}@blocipedia.example>"
    headers["In-Reply-To"] = "wikis/#{wiki.id}@blocipedia.example>"
    headers["References"] = "<wiki/#{wiki.id}@blocipedia.example>"

    @user = user
    @wiki = wiki

    mail(to: user.email, subject: "#{wiki.title} has been updated")
  end
  
end
