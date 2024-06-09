require 'sinatra'
require 'mysql2'

unless settings.development?
  set :show_exceptions, false
end

# Метод для отображения всех таблиц в базе данных.
get '/' do
  client = Mysql2::Client.new(host: '127.0.0.1', username: 'root', password: '', database: 'BankDatabase', encoding: 'utf8')
  tables = client.query('SHOW TABLES')
  
  html = "<h1>Таблицы:</h1>"
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

	html += "<h1>Добавить Физлицо</h1>"
	html += <<-HTML 
    <form action="/add_person" method="post" style="display: flex; flex-direction: column; gap: 10px; width: 200px;"> 
      <label for="first_name">Имя:</label> 
      <input type="text" name="first_name"> 
      <label for="last_name">Фамилия:</label> 
      <input type="text" name="last_name"> 
      <label for="middle_name">Отчество:</label> 
      <input type="text" name="middle_name"> 
      <label for="passport_number">Паспорт:</label> 
      <input type="text" name="passport_number"> 
      <label for="inn">ИНН:</label> 
      <input type="text" name="inn"> 
      <label for="snils">СНИЛС:</label> 
      <input type="text" name="snils"> 
      <label for="driving_license">Вод. права:</label> 
      <input type="text" name="driving_license"> 
      <label for="additional_documents">Доп. документы:</label> 
      <input type="text" name="additional_documents"> 
      <label for="note">Примечание:</label> 
      <input type="text" name="note"> 
      <input type="submit" value="Добавить Физлицо"> 
    </form>
  HTML
	
  html
end

post '/add_person' do
  client = Mysql2::Client.new(host: '127.0.0.1', username: 'root', password: '', database: 'BankDatabase', encoding: 'utf8')
  client.query("INSERT INTO PhysicalPersons (first_name, last_name, middle_name, passport_number, inn, snils, driving_license, additional_documents, note) VALUES (
    '#{params['first_name']}', 
    '#{params['last_name']}', 
    '#{params['middle_name']}', 
    '#{params['passport_number']}', 
    '#{params['inn']}', 
    '#{params['snils']}', 
    '#{params['driving_license']}', 
    '#{params['additional_documents']}', 
    '#{params['note']}')"
  )
end
