#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'


get '/' do
	erb "Hello!"			
end

get '/about' do
	erb :about
end

get '/visit' do
	erb :visit
end

get '/contacts' do
	erb :contacts
end

post '/contacts' do
	require 'pony'
	@email = params[:email]
	@text = params[:text]

	hh = {  :email => 'Введите ваш электронный адрес',
			:text => 'Введите сообщение'}

	hh.each do |key, value|
		if params[key] == ''
			@error = hh[key]
			return erb :contacts
		end
	end

	#Pony.mail({:to => 'tanya.syrova.91@mail.ru',
	#	:subject => 'BarberShop new contact',
	#	:body => "#{@email}, #{@text}",
	#	:via => :smtp,
	#	:via_options => { 
	#	:address => 'smtp.mail.ru',
	#	:port => '587',
	#	:enable_starttls_auto => true,
	#	:user_name => 'tanya.syrova.91',
	#	:password => '54TVA7BeqB9ZknG6RjTK',
	#	:authentification => :plain,
	#	:domain => 'mail.ru'}
	#	}) 
		
	erb :contacts
end

post '/visit' do
	@username = params[:username]
	@phone = params[:phone]
	@date_time = params[:date_time]
	@barber = params[:barber]
	@color = params[:color]

	hh = { :username => 'Введите имя',
			:phone => 'Введите телефон',
			:date_time => 'Введите дату и время',
			:barber => 'Выберите парикмахера'}

	hh.each do |key, value|
		if params[key] == '' || params[key] == 'Выберите парикмахера'
			@error = hh[key]
			return erb :visit
		end
	end
	
	#@error = hh.select {|key,_| params[key] == ""}.values.join(", ")
	#if @error != ''
	# return erv :visit
	#endS

	f = File.open './public/users.txt', 'a'
	f.write "Имя: #{@username}, телефон: #{@phone}, дата и время записи: #{@date_time}, парикмахер: #{@barber}, цвет: #{@color} \n"
	f.close

	erb :record
end

post '/record' do
	erb :visit
end

get '/admin' do
	erb :admin
end

post '/admin' do
	@login = params[:login]
	@password = params[:password]

	if @login == 'admin' && @password == 'secret'
		@user_file = File.open('./public/users.txt', 'r')
		erb :users
	else
		erb 'Некорректные логин или пароль'
	end
end
