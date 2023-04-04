#!C:\Ruby32-x64\bin\ruby.exe

# создание един. объекта подключения.
require 'mysql2'
client = Mysql2::Client.new(
	:host     => '127.0.0.1',
	:username => 'root',
	:password => '',
	:database => 'test',
	:encoding => 'utf8'
	)

# обработка значений из формы.
require "cgi"
cgi = CGI.new
if cgi['col1'] != '' && cgi['col2'] != '' && cgi['col2'] != ''
	client.query("INSERT INTO myarttable (text, description, keywords) VALUES (\""+cgi['col1']+"\",\""+cgi['col2']+"\",\""+cgi['col3']+"\")")
end
		
# главная функция для показа строк, работает всегда.
def viewSelect(client)
	results = client.query("SHOW COLUMNS FROM myarttable")
	puts '<tr>'
	results.each do |row|
	  puts '<td>'+row['Field'].to_s+'</td>'
	end
	puts '</tr>'

	results = client.query("SELECT * FROM myarttable WHERE id>14 ORDER BY id DESC")
	results.each do |row|
	  puts '<tr><td>'+row['id'].to_s+'</td><td>'+row['text']+'</td><td>'+row['description']+'</td><td>'+row['keywords']+'</td></tr>'
	end
end

# подпись.
def viewVer(client)
	results = client.query("SELECT VERSION() AS ver")
	results.each do |row|
	  puts row['ver']
	end
end

# чтение шаблона и отображение на экране.
puts "Content-type: text/html\n\n"
File.readlines('select.html').each do |line|

	s = String.new(line)
	s.gsub!(/[^0-9A-Za-z @]/, '')

	if s != "@tr" && s != "@ver"
		puts(line)
	end
	if s == "@tr"
		viewSelect(client)
	end
	if s == "@ver"
		viewVer(client)
	end
end