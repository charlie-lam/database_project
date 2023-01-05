require_relative 'lib/database_connection'

# We need to give the database name to the method `connect`.
DatabaseConnection.connect('music_library_test')

# Perform a SQL query on the database and get the result set.
sql = 'SELECT * FROM albums;'
result = DatabaseConnection.exec_params(sql, [])

# Print out each record from the result set .
p result.to_a