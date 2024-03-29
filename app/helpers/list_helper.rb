require 'http'

module ListHelper

  def is_movie_id_valid(id)
    movie_details = (HTTP.get("https://api.themoviedb.org/3/movie/#{id}?api_key=#{ENV['TMDB_API_KEY']}&language=en-US")).parse

    if movie_details['original_title'] != nil && movie_details['adult'] == false
      return true
    end
    
    false
  
  end

  def get_list_index_info(lists)
    output = []
    
    lists.each do |list|
      output.push({
        id: list["_id"],
        title: list["title"],
        username: User.find(list["user_id"])["username"],
        created_on: list["created_on"],
        index_poster: list["movies"].length == 0 ? nil : extract_movie_info(list["movies"][0])[:poster_path]
      })
    end
    
    output
  end

  def get_directors(movie)
    output = []
    
    if movie == nil
      return
    end

    movie["credits"]["crew"].each do |crew_member|
      if crew_member["job"] == "Director"
        output.push(crew_member["name"])
      end
    end
    
    output
  end

  def get_cast(movie)
    output = []

    if movie == nil
      return
    end

    5.times do |index|
      if movie["credits"]["cast"][index] != nil
        output.push(movie["credits"]["cast"][index]["name"])
      end
    end

    output
  end

  def extract_movie_info(id)
    if id == nil
      return
    end
    
    movie_details = (HTTP.get("https://api.themoviedb.org/3/movie/#{id}?api_key=#{ENV['TMDB_API_KEY']}&&append_to_response=credits")).parse
    
    return {
      id: movie_details['id'],
      original_title: movie_details['original_title'],
      overview: movie_details['overview'],
      poster_path: movie_details['poster_path'] != nil ? "https://image.tmdb.org/t/p/original#{movie_details['poster_path']}" : "https://res.cloudinary.com/djv3yhbok/image/upload/v1658030155/1665px-No-Image-Placeholder.svg_jgp6ma.png" ,
      release_date: movie_details['release_date'],
      runtime: movie_details['runtime'],
      directed_by: get_directors(movie_details),
      cast: get_cast(movie_details)
    }
  end

  def add_movie(id, list)
    if is_movie_id_valid(id)
      list["movies"].push(id)
    end
  end

  def remove_movie(id, list)
    movie_index = list["movies"].find_index(id)

    if movie_index != nil
      list["movies"].delete_at(movie_index)
    end
  end

  def move_up(arr, index)
    if index > 0
      arr[index - 1, 2] = arr[index - 1, 2].reverse
      arr
    end

    arr
  end

  def move_down(arr, index)
    if index < arr.length - 1
      arr[index, 2] = arr[index, 2].reverse
    end

    arr
  end

end