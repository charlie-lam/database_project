#require 'album'
require 'album_repository'

def reset_albums_table
    seed_sql = File.read('spec/seeds_music_library.sql')
    connection = PG.connect({ host: '127.0.0.1', dbname: 'music_library_test' })
    connection.exec(seed_sql)
end
  
describe AlbumRepository do
    before(:each) do 
      reset_albums_table
    end
  
    # (your tests will go here).
    it "Gets all entries" do
        repo = AlbumRepository.new
        albums = repo.all
        expect(albums).to eq [{"artist_id"=>"1", "id"=>"1", "release_year"=>"1989", "title"=>"Doolittle"},{"artist_id"=>"1", "id"=>"2", "release_year"=>"1988", "title"=>"Surfer Rosa"},{"artist_id"=>"2", "id"=>"3", "release_year"=>"1974", "title"=>"Waterloo"}]
    end
end