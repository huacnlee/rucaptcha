require 'posix-spawn'

module RuCaptcha
  class Captcha
    def self.rand_color
      r = rand(129).to_s(8).to_i
      rgb = [rand(100).to_s(8), rand(100).to_s(8), rand(100).to_s(8)]

      "rgba(#{rgb.join(',')},1)"
    end

    def self.create(code)
      size = "#{RuCaptcha.config.width}x#{RuCaptcha.config.height}"
      font_size = (RuCaptcha.config.height * 0.8).to_i
      half_width = RuCaptcha.config.width / 2
      half_height = RuCaptcha.config.height / 2
      line_color = rand_color

      chars = code.split('')
      text_opts = []
      text_top = (RuCaptcha.config.height - font_size) / 2
      text_padding = 5
      text_width = (RuCaptcha.config.width / chars.size) - text_padding * 2
      text_left = 5
      chars.each_with_index do |char, i|
        text_opts << %(-fill '#{rand_color}' -draw 'text #{(text_left + text_width)  * i + text_left},#{text_top} "#{char}"')
      end

      command = <<-CODE
        convert -size #{size} #{text_opts.join(' ')}  \
        -draw 'stroke #{line_color} line #{rand(10)},#{rand(20)} #{half_width + rand(half_width)},#{rand(half_height)}' \
        -draw 'stroke #{line_color} line #{rand(10)},#{rand(25)} #{half_width + rand(half_width)},#{half_height + rand(half_height)}' \
        -draw 'stroke #{line_color} line #{rand(10)},#{rand(30)} #{half_width + rand(half_width)},#{half_height + rand(half_height)}' \
        -wave #{rand(2) + 2}x#{rand(2) + 1} \
        -gravity NorthWest -sketch 1x10+#{rand(1)} -pointsize #{font_size} -weight 700 \
        -implode #{RuCaptcha.config.implode} label:- png:-
      CODE
      command.strip!
      # puts command
      pid, stdin, stdout, stderr = POSIX::Spawn.popen4(command)
      Process.waitpid(pid)
      stdout.read
    end
  end
end
