require 'posix-spawn'

module RuCaptcha
  class Captcha
    class << self
      def rand_color
        [rand(100).to_s(8), rand(100).to_s(8), rand(100).to_s(8)]
      end

      def random_chars
        chars = SecureRandom.hex(RuCaptcha.config.len / 2).downcase
        chars.gsub!(/[0ol1]/i, (rand(8) + 2).to_s)
        chars
      end

      def rand_line_top(text_top, font_size)
        text_top + rand(font_size * 0.7).to_i
      end

      # Create Captcha image by code
      def create(code)
        chars        = code.split('')
        all_left     = 20
        font_size    = RuCaptcha.config.font_size
        full_height  = font_size
        full_width   = font_size * chars.size
        size         = "#{full_width}x#{full_height}"
        half_width   = full_width / 2
        full_height  = full_height
        half_height  = full_height / 2
        text_top     = 0
        text_left    = 0 - (font_size * 0.28).to_i
        stroke_width  = (font_size * 0.08).to_i + 1
        text_width   = font_size + text_left
        label = "=#{' ' * (chars.size - 1)}="

        text_opts = []
        line_opts = []
        chars.each_with_index do |char, i|
          rgb = rand_color
          text_color = "rgba(#{rgb.join(',')}, 1)"
          line_color = "rgba(#{rgb.join(',')}, 0.6)"
          text_opts << %(-fill '#{text_color}' -draw 'text #{(text_left + text_width) * i + all_left},#{text_top} "#{char}"')
          left_y = rand_line_top(text_top, font_size)
          right_x = half_width + (half_width * 0.3).to_i
          right_y = rand_line_top(text_top, font_size)
          line_opts << %(-draw 'stroke #{line_color} line #{rand(10)},#{left_y} #{right_x},#{right_y}')
        end

        command = <<-CODE
          convert -size #{size} \
          -strokewidth #{stroke_width} \
          #{line_opts.join(' ')} \
          -pointsize #{font_size} -weight 500 \
          #{text_opts.join(' ')}  \
          -wave #{rand(2) + 3}x#{rand(2) + 1} \
          -rotate #{rand(10) - 5} \
          -gravity NorthWest -sketch 1x10+#{rand(2)} \
          -fill none \
          -implode #{RuCaptcha.config.implode} -trim label:- png:-
        CODE

        if Gem.win_platform?
          png_file_path = Rails.root.join('tmp', 'cache', "#{code}.png")
          command = "convert -size #{size} xc:White -gravity Center -weight 12 -pointsize 20 -annotate 0 \"#{code}\" -trim #{png_file_path}"
          require 'open3'
          _stdout_str, stderr_str = Open3.capture3(command)
          raise "RuCaptcha: #{stderr_str.strip}" if stderr_str != nil && stderr_str.length > 0
          png_file_path
        else
          command.strip!
          pid, stdin, stdout, stderr = POSIX::Spawn.popen4(command)
          Process.waitpid(pid)
          err = stderr.read
          raise "RuCaptcha: #{err.strip}" if err != nil && err.length > 0
          stdout.read
        end
      end
    end
  end
end
