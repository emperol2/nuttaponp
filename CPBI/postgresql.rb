gem 'pg'
require 'pg'

conn = PG::Connection.open(:dbname => 'test')
res  = conn.exec('SELECT * from table1')
res.each do |row|
  row.each do |column|
    puts column
  end
end
p conn
conn.close