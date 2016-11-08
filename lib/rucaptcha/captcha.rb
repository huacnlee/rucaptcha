require 'open3'

module RuCaptcha
  class Captcha
    class << self
      # Genrate ranom RGB color
      def random_color
        if RuCaptcha.config.style == :colorful
          color1 = rand(56) + 15
          color2 = rand(10) + 140
          color = [color1, color2, rand(15)]
          color.shuffle!
          color
        else
          color_seed = rand(40) + 10
          [color_seed, color_seed, color_seed]
        end
      end

      # Genrate random Captcha code
      def random_chars
        chars = SecureRandom.hex(RuCaptcha.config.len / 2).downcase
        chars.gsub!(/[0ol1]/i, (rand(8) + 2).to_s)
        chars
      end

      # Create Captcha image by code
      def create(code)
        chars        = code.split('')
        full_width   = RuCaptcha.config.font_size * chars.size
        full_height  = RuCaptcha.config.font_size
        size         = "#{full_width}x#{full_height}"

        return convert_for_windows(size, code) if Gem.win_platform?

        opts = command_line_opts(chars, full_width)
        convert(size, opts)
      end

      private

      def command_line_opts(chars, full_width)
        font_size    = RuCaptcha.config.font_size
        all_left     = 20
        half_width   = full_width / 2
        text_top     = 0
        text_left    = 0 - (font_size * 0.28).to_i
        text_width   = font_size + text_left

        opts = { text: [], line: [] }
        rgbs = uniq_rgbs_for_each_chars(chars)

        chars.each_with_index do |char, i|
          rgb = RuCaptcha.config.style == :colorful ? rgbs[i] : rgbs[0]
          text_color = "rgba(#{rgb.join(',')}, 1)"
          line_color = "rgba(#{rgb.join(',')}, 0.6)"
          opts[:text] << %(-fill '#{text_color}' -draw 'text #{(text_left + text_width) * i + all_left},#{text_top} "#{char}"')

          left_y = rand_line_top(text_top, font_size)
          right_x = half_width + (half_width * 0.3).to_i
          right_y = rand_line_top(text_top, font_size)
          opts[:line] << %(-draw 'stroke #{line_color} line #{rand(10)},#{left_y} #{right_x},#{right_y}')
        end
        opts
      end

      def convert(size, opts)
        stroke_width = (RuCaptcha.config.font_size * 0.05).to_i + 1
        command = <<-CODE
          convert -size #{size} \
          -strokewidth #{stroke_width} \
          #{opts[:line].join(' ')} \
          -pointsize #{RuCaptcha.config.font_size} -weight 500 \
          #{opts[:text].join(' ')}  \
          -wave #{rand(2) + 3}x#{rand(2) + 1} \
          -rotate #{rand(10) - 5} \
          -gravity NorthWest -sketch 1x10+#{rand(2)} \
          -fill none \
          -implode #{RuCaptcha.config.implode} -trim label:- png:-
        CODE
        command.strip!
        out, err, _st = Open3.capture3(command)
        warn "  RuCaptcha #{err.strip}" if err.present?
        out
      end

      # Generate a simple captcha image for Windows Platform
      def convert_for_windows(size, code)
        png_file_path = Rails.root.join('tmp', 'cache', "#{code}.png")
        command = "convert -size #{size} xc:White -gravity Center -weight 12 -pointsize 20 -annotate 0 \"#{code}\" -trim #{png_file_path}"
        _out, err, _st = Open3.capture3(command)
        warn "  RuCaptcha #{err.strip}" if err.present?
        png_file_path
      end

      # Geneate a uniq rgba colors for each chars
      def uniq_rgbs_for_each_chars(chars)
        rgbs = []
        chars.count.times do |i|
          color = random_color
          if i > 0
            preview_color = rgbs[i - 1]
            # Avoid color same as preview color
            if color.index(color.min) == preview_color.index(preview_color.min) &&
               color.index(color.max) == preview_color.index(preview_color.max)
              # adjust RGB order
              color = [color[1], color[2], color[0]]
            end
          end
          rgbs << color
        end
        rgbs
      end

      def rand_line_top(text_top, font_size)
        text_top + rand(font_size * 0.7).to_i
      end

      def warn(msg)
        msg = "  RuCaptcha #{msg}"
        Rails.logger.error(msg)
      end
    end
  end
end
