require 'sinatra'
require 'mysql2'

unless settings.development?
  set :show_exceptions, false
end

# Метод для отображения всех таблиц в базе данных.
get '/' do
  client = Mysql2::Client.new(host: '127.0.0.1', username: 'root', password: '', database: 'BankDatabase', encoding: 'utf8')
  tables = client.query('SHOW TABLES')
  
  html = "<h1>Tables:</h1>"
  tables.each do |table|
    table_name = table.values.first
    html += "<h2>#{table_name}</h2>"
    results = client.query("SELECT * FROM #{table_name}")

    html += "<table border='1'><tr>"
    results.fields.each do |field|
      html += "<th>#{field}</th>"
    end
    html += "</tr>"
    
    results.each do |row|
      html += "<tr>"
      row.each do |key, value|
        html += "<td>#{value}</td>"
      end
      html += "</tr>"
    end
    html += "</table>"
  end
  html
end