require 'sinatra'
require 'mysql2'

unless settings.development?
  set :show_exceptions, false
end

# Метод для отображения всех таблиц в базе данных.
get '/' do
  client = Mysql2::Client.new(host: '127.0.0.1', username: 'root', password: '', database: 'Observatory', encoding: 'utf8')
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

	html += "<h1>Обновить Объект</h1>"
	html += <<-HTML 
    <form 
      action="/update_object" 
      method="post" 
      style="display: flex; flex-direction: column; gap: 10px; width: 200px;"
    > 
      <label for="p_id"><b>ID:</b></label> 
      <input type="text" name="p_id"> 
      <label for="p_type">Тип:</label> 
      <input type="text" name="p_type"> 
      <label for="p_determination_accuracy">Точность:</label> 
      <input type="text" name="p_determination_accuracy"> 
      <label for="p_quantity">Количество:</label> 
      <input type="text" name="p_quantity"> 
      <label for="p_time">Время:</label> 
      <input type="text" name="p_time"> 
      <label for="p_date">Дата:</label> 
      <input type="text" name="p_date"> 
      <label for="p_notes">Примечания:</label> 
      <input type="text" name="p_notes"> 
      
      <input type="submit" value="Обновить Объект">
    </form>
  HTML
	
  html
end

post '/update_object' do
  client = Mysql2::Client.new(host: '127.0.0.1', username: 'root', password: '', database: 'Observatory', encoding: 'utf8')
  client.query("CALL update_objects(
    '#{params['p_id']}', 
    '#{params['p_type']}', 
    '#{params['p_determination_accuracy']}', 
    '#{params['p_quantity']}', 
    '#{params['p_time']}', 
    '#{params['p_date']}', 
    '#{params['p_notes']}')"
  )
end
