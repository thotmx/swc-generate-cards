# Generate the SVG files
number_to_replace = 1
number_of_file = 1
text = File.read('prototype.svg')
File.open('letters_for_cards.txt').each do |line|
  letters = line.split
  puts "#{letters[0] || ' ' } - #{letters[1] || ' '}"
  text.gsub!(/\>#{number_to_replace.to_s}\</, ">#{letters[0] || ' '}<")
  text.gsub!(/\>#{(number_to_replace + 1).to_s}\</, ">#{letters[1] || ' '}<")
  number_to_replace += 2
  if (number_to_replace > 8)
    File.open("#{number_of_file}.svg", "w") {|file| file.puts text}
    number_to_replace = 1
    number_of_file += 1
    text = File.read('prototype.svg')
  end
end

File.open("#{number_of_file}.svg", "w") {|file| file.puts text}

# Convert to PDF
(1..number_of_file).each do |file|
  `inkscape -f #{file}.svg -A #{file}.pdf`
end

# Join into the final file
File.delete('cards_new.pdf') if File.exists?('cards_new.pdf')
`pdftk *.pdf cat output cards_new.pdf`
