module ApplicationHelper

  # When on .mrhenry.eu domain, we don't want a search crawler to index
  #
  # @return {String}
  def meta_name_robots
    if request.host.match /.*\.a\.mrhenry\.eu.*/
      tag("meta", name: "robots", content: "noindex, nofollow")

    else
      tag("meta", name: "robots", content: "index, follow")

    end
  end

end
