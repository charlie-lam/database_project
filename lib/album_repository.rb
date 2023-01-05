class AlbumRepository
    def all
        # Executes the SQL query:
        # SELECT id, title, release_year FROM albums;
        sql = 'SELECT id, title, release_year FROM albums;'
        result = DatabaseConnection.exec_params(sql, []).to_a
        # Returns an array of Album objects.
      end
end