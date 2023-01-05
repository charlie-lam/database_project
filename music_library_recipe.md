# Music Library Model and Repository Classes Design Recipe

_Copy this recipe template to design and implement Model and Repository classes for a database table._

## 1. Design and create the Table

If the table is already created in the database, you can skip this step.

Otherwise, [follow this recipe to design and create the SQL schema for your table](./single_table_design_recipe_template.md).


## 2. Create Test SQL seeds

Your tests will depend on data stored in PostgreSQL to run.

If seed data is provided (or you already created it), you can skip this step.

```sql
  TRUNCATE TABLE albums RESTART IDENTITY
  TRUNCATE TABLE artists RESTART IDENTITY
  DROP TABLE IF EXISTS "public"."albums";
  -- This script only contains the table creation statements and does not fully represent the table in the database. It's still missing: indices, triggers. Do not use it as a backup.

  -- Sequence and defined type
  CREATE SEQUENCE IF NOT EXISTS albums_id_seq;

  -- Table Definition
  CREATE TABLE "public"."albums" (
      "id" SERIAL,
      "title" text,
      "release_year" int4,
      "Album_id" int4,
      PRIMARY KEY ("id")
  );

  DROP TABLE IF EXISTS "public"."albums
  ";
  -- This script only contains the table creation statements and does not fully represent the table in the database. It's still missing: indices, triggers. Do not use it as a backup.

  -- Sequence and defined type
  CREATE SEQUENCE IF NOT EXISTS albums
  _id_seq;

  -- Table Definition
  CREATE TABLE "public"."albums
  " (
      "id" SERIAL,
      "title" text,
      "genre" text,
      PRIMARY KEY ("id")
  );

  INSERT INTO "public"."albums" ("title", "release_year", "Album_id") VALUES
  ('Doolittle', 1989, 1),
  ('Surfer Rosa', 1988, 1),
  ('Waterloo', 1974, 2),
  ('Super Trouper', 1980, 2),
  ('Bossanova', 1990, 1),
  ('Lover', 2019, 3),
  ('Folklore', 2020, 3),
  ('I Put a Spell on You', 1965, 4),
  ('Baltimore', 1978, 4),
  ( 'Here Comes the Sun', 1971, 4),
  ( 'Fodder on My Wings', 1982, 4),
  ( 'Ring Ring', 1973, 2);

  INSERT INTO "public"."albums
  " ("title", "genre") VALUES
  ('Pixies', 'Rock'),
  ('ABBA', 'Pop'),
  ('Taylor Swift', 'Pop'),
  ('Nina Simone', 'Pop');
```

Run this SQL file on the database to truncate (empty) the table, and insert the seed data. Be mindful of the fact any existing records in the table will be deleted.

```bash
psql -h 127.0.0.1 music_library_test < seeds_music_library.sql
```

## 3. Define the class titles

Usually, the Model class title will be the capitalised table title (single instead of plural). The same title is then suffixed by `Repository` for the Repository class title.

```ruby
# EXAMPLE
# Table title: albums

# Model class
# (in lib/album.rb)
class Album
end

# Repository class
# (in lib/album_repository.rb)
class AlbumRepository
end
```

## 4. Implement the Model class

Define the attributes of your Model class. You can usually map the table columns to the attributes of the class, including primary and foreign keys.

```ruby
# Table title: albums

# Model class
# (in lib/album.rb)

class Album

  # Replace the attributes by your own columns.
  attr_accessor :id, :title, :release_year, artist_id:
end

# The keyword attr_accessor is a special Ruby feature
# which allows us to set and get attributes on an object,
# here's an example:
#
# album = album.new
# album.title = 'Jo'
# album.title
```

*You may choose to test-drive this class, but unless it contains any more logic than the example above, it is probably not needed.*

## 5. Define the Repository Class interface

Your Repository class will need to implement methods for each "read" or "write" operation you'd like to run against the database.

Using comments, define the method signatures (arguments and return value) and what they do - write up the SQL queries that will be used by each method.

```ruby
# EXAMPLE
# Table title: albums


# Repository class
# (in lib/album_repository.rb)

class AlbumRepository

  # Selecting all records
  # No arguments
  def all
    # Executes the SQL query:
    # SELECT id, title, release_year FROM albums;

    # Returns an array of Album objects.
  end

  # Gets a single record by its ID
  # One argument: the id (number)
  def find(id)
    # Executes the SQL query:
    # SELECT id, title, release_year FROM albums WHERE id = $1;

    # Returns a single Album object.
  end

  # Add more methods below for each operation you'd like to implement.

   def create(album, release_year)
    # Executes the SQL query:
    # INSERT INTO albums (title, release_year) VALUES (album.title, album.release_year)

    # Returns nothing

   end

   def update(album, column, new_data)
    # Executes the SQL query:
    # UPDATE albums SET column = album.column WHERE title = album.title
    
    # Returns nothing
   end

   def delete(album)
  
    # Executes the SQL query:
    # DELETE FROM albums WHERE title = album.title

    # Returns nothing
   end
end
```

## 6. Write Test Examples

Write Ruby code that defines the expected behaviour of the Repository class, following your design from the table written in step 5.

These examples will later be encoded as RSpec tests.

```ruby
# EXAMPLES

# 1
# Get all albums


repo = AlbumRepository.new

albums = repo.all

albums.length # =>  2

albums[0].id # =>  1
albums[0].title # =>  'Doolittle'
albums[0].release_year # =>  '1989'

albums[1].id # =>  2
albums[1].title # =>  'Surfer Rosa'
albums[1].release_year # =>  '1988'

# 2
# Get a single album

repo = AlbumRepository.new

album = repo.find(1)

album.id # =>  1
album.title # =>  'Doolittle'
album.release_year # =>  '1989'

# Add more examples for each method

#3
# Create an album

repo = AlbumRepository.new

queen = Album.create("Queen", 1973)
repo.create(queen)
album = repo.find(15)

album.title # => 'Queen'

#4
# Update an album

repo = AlbumRepository.new

repo.update("Doolittle", "release_year", 1998)

album = repo.find(1)
album.release_year # => 1998

#5
# Delete an album

repo = AlbumRepository.new

repo.delete("Doolittle")




```

Encode this example as a test.

## 7. Reload the SQL seeds before each test run

Running the SQL code present in the seed file will empty the table and re-insert the seed data.

This is so you get a fresh table contents every time you run the test suite.

```ruby
# EXAMPLE

# file: spec/album_repository_spec.rb

def reset_albums_table
  seed_sql = File.read('spec/seeds_albums.sql')
  connection = PG.connect({ host: '127.0.0.1', dbtitle: 'music_library_test' })
  connection.exec(seed_sql)
end

describe AlbumRepository do
  before(:each) do 
    reset_albums_table
  end

  # (your tests will go here).
end
```

## 8. Test-drive and implement the Repository class behaviour

_After each test you write, follow the test-driving process of red, green, refactor to implement the behaviour._
