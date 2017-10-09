require 'open-uri'
class MainController < ApplicationController
  def home
    image = MiniMagick::Image.open('http://24.media.tumblr.com/tumblr_lfp3qax6Lm1qfmtrbo1_1280.jpg')
    image.colorspace "Gray"

    mask = MiniMagick::Image.open('public/mask.png')
    mask.negate
    mask.write "public/mask_negate.png"

    MiniMagick::Tool::Convert.new do |convert|
      convert << "public/mask_negate.png"
      convert.fill("#FF0000")
      convert.opaque("#FFFFFF")
      convert.transparent("#000000")
      convert << "public/mask_red.png"
    end

    mask_red = MiniMagick::Image.open('public/mask_red.png')
    result = image.composite(mask_red) do |c|
      c.compose "Over"
    end

    result.write "public/output.jpg"

    render :text => result

  end
end
