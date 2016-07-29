require 'csv'
require 'sunlight/congress' 
require 'erb'
require 'date'

Sunlight::Congress.api_key = '260cdfeda2a04229a8c987edc87a5fd8'

def clean_zipcode(zipcode)
  zipcode.to_s.rjust(5,'0')[0..4]
end

def legislators_by_zipcode(zipcode)
  legislators = Sunlight::Congress::Legislator.by_zipcode(zipcode)
end

def save_thank_you_letters(id,form_letter)
  Dir.mkdir('output') unless Dir.exists? 'output'

  filename = 'output/thanks_#{id}.html'

  File.open(filename, 'w') do |file|
    file.puts form_letter
  end
end

def clean_number(number)
  phone_number= number
  phone_number_int = phone_number.gsub(/[\D+]/, '')
  if phone_number_int.length == 10
    home_phone = phone_number_int
  elsif phone_number_int.length == 11 && phone_number_int[0] == 1
    home_phone = phone_number_int[1..10] 
  else
    home_phone = '0000000000'
  end
  home_phone
end

puts 'EventManager initialized.'

#template_letter = File.read 'form_letter.erb'

contents = CSV.open 'event_attendees.csv', headers: true, header_converters: :symbol

def most_hours(datetime) 
    $hours[datetime.hour] ||= 1 
    $hours[datetime.hour] += 1
end

def most_days(datetime)
$days[datetime.wday] ||= 1
$days[datetime.wday] += 1
end


contents = CSV.open 'event_attendees.csv', headers: true, header_converters: :symbol




#template_letter = File.read 'form_letter.erb'
#erb_template = ERB.new template_letter

$hours = {}
$days = {}
contents.each do |row|
  id = row[0]
  name = row[:first_name]

  zipcode = clean_zipcode(row[:zipcode])
  number = clean_number(row[:homephone])

    date = row[:regdate]
    datetime = DateTime.strptime(date, '%m/%d/%Y %H:%M')
      most_hours(datetime)
most_days(datetime)
  #  legislators = legislators_by_zipcode(zipcode)

  #  form_letter = erb_template.result(binding)

  #  save_thank_you_letters(id,form_letter)
end

p 'hours with the most registration: '
  p $hours.sort_by { |key, value| value}.reverse
  p 'days (Sunday is zero)  with the most registrations: '
  p $days.sort_by { |days, count| count}.reverse

