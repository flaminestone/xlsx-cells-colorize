require 'rubygems'
require 'chunky_png'
require 'image_size'
require 'rmagick'
open('main.js', 'w') do |f|
  f << "
builder.CreateFile(\"xlsx\");
var oWorksheet = Api.GetActiveSheet();

for (var i = 0; i < 1000; i++) {
    oWorksheet.SetColumnWidth(i, 2,25028038);
}\n"
end
def get_column_name(number)
  (number.to_i > 0 ? ('A'..'Z').to_a[(number.to_i - 1) % 26] + get_column_name((number.to_i - 1) / 26).reverse : '').reverse
end
filepath = 'image.bmp'
body = ''
image_size = ImageSize.new(File.open(filepath).read).size
pixels = Magick::ImageList.new(filepath).get_pixels(0, 0, image_size.first, image_size.last).each_slice(image_size.first).to_a
pixels.each_with_index do |current_column, pixel_number|
  current_column.each_with_index do |cell, j|
    r = cell.to_color(Magick::AllCompliance, false, 8, true).match(/#(..)(..)(..)/)[1].hex
    g = cell.to_color(Magick::AllCompliance, false, 8, true).match(/#(..)(..)(..)/)[2].hex
    b = cell.to_color(Magick::AllCompliance, false, 8, true).match(/#(..)(..)(..)/)[3].hex
    body += "oWorksheet.GetRange('" + get_column_name(j + 1) + (pixel_number + 1).to_s + "').SetFillColor(Api.CreateColorFromRGB(#{r}, #{g}, #{b})); \n"
    puts(get_column_name(j + 1) + (pixel_number + 1).to_s)
  end
end
open('main.js', 'a') { |f| f << body }
open('main.js', 'a') do |f|
  f << "builder.SaveFile(\"xlsx\", \"SetFillColor.xlsx\");
builder.CloseFile();"
end
`documentbuilder main.js`
