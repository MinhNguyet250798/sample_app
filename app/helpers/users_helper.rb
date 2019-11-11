module UsersHelper
  def gravatar_for user, options = {size: Settings.size}
    size = options[:size]
    gravatar_id = Digest::MD5.hexdigest user.email.downcase
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag gravatar_url, alt: user.name, class: "gravatar"
  end

  def find_following_user id
    @relationship = current_user.active_relationships.find_by followed_id: id
    return @relationship if @relationship
    flash[:danger] = t "follow_did_not_succeed"
    redirect_to root_url
  end

  def active_relationships_user
    current_user.active_relationships.build
  end
end
