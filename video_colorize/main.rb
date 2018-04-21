require 'json'
require 'rubygems'
require 'chunky_png'
require 'image_size'
require 'rmagick'
main_data = []
fit = 30
def get_column_name(number)
  (number.to_i > 0 ? ('A'..'Z').to_a[(number.to_i - 1) % 26] + get_column_name((number.to_i - 1) / 26).reverse : '').reverse
end

Dir['*.jpg'].sort_by(&:to_i).each_with_index do |image, frame_index|
  new_row = []
  image_size = ImageSize.new(File.open(image).read).size
  pixels = Magick::ImageList.new(image).flip.rotate(90).resize_to_fill(fit, fit).get_pixels(0, 0, fit, fit).each_slice(fit).to_a
  pixels.each_with_index do |row, pixel_index|
    row.each_with_index do |pixel, index|
      new_row.unshift [(get_column_name(pixel_index + 1) + (index + 1).to_s), [ pixel.to_color(Magick::AllCompliance, false, 8, true).match(/#(..)(..)(..)/)[1].hex,
                                                      pixel.to_color(Magick::AllCompliance, false, 8, true).match(/#(..)(..)(..)/)[2].hex,
                                                      pixel.to_color(Magick::AllCompliance, false, 8, true).match(/#(..)(..)(..)/)[3].hex ]]
    end
  end
  main_data << new_row.reverse
end
File.write('main_data.json', main_data.to_json)
p
