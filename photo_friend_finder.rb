require 'koala'
require 'json'
require 'nokogiri'

def flatten_nested_hash(content)
  content.flat_map{|k, v| [k, *(v.respond_to?(:flat_map) ? flatten_nested_hash(v): v)]}
end


ACCESS_TOKEN="your access token goes here"
COOKIES = "your FB cookies go here"


@graph = Koala::Facebook::API.new(ACCESS_TOKEN)

file = ARGV[0]
puts "uploading file: #{file}"
photo = @graph.put_picture(file, {:published => false, :temporary=> true})
puts "upload response: #{photo}"
puts "waiting for photo to get processed"
found = false

3.times do
    sleep(3)
    puts "calling api to get friends in photo"
    cmd = "curl -s 'https://www.facebook.com/ajax/pagelet/generic.php/PhotoViewerInitPagelet?dpr=2&data=%7B%22fbid%22%3A%22#{photo['id']}%22%2C%22data_ft%22%3A%7B%7D%7D&__a=1&__req=jsonp_4&__pc=PHASED%3ADEFAULT' -H '#{COOKIES}'"
    response = %x(#{cmd})
    content = JSON.parse(response.sub(/^[^{]*/,''))
    content = flatten_nested_hash(content)
    content = content.select{|x| x if x.respond_to?(:index) && x.index("fbPhotosPhotoTagboxes")}[0]
    content = Nokogiri::HTML(content)
    people_in_photo = content.css(".fbPhotosPhotoTagboxBase.faceBox").length
    identified_friends_in_photo = content.css(".faceboxSuggestion").map{|x| x.attributes["data-text"].value}
    if people_in_photo > 0
        puts "Found #{people_in_photo} people in the photo"
        puts "identified people in the photo: #{identified_friends_in_photo * ", "}"
        found = true
        break
    end
end

puts "tried 3 times couldn't find any friends in photo. Some problem." if !found
puts "deleting photo. response : #{@graph.delete_object(photo["id"])}"