require 'posix-spawn'

module RuCaptcha
  class Captcha
    class << self
      def create(code)
        color = "rgba(#{rand(100)},#{rand(100)},#{rand(100)}, 1)"
        size = "#{RuCaptcha.config.width}x#{RuCaptcha.config.height}"
        command = <<-CODE
          convert -size #{size} -fill "#{color}" -background white \
          -draw 'stroke #{color} line #{rand(20)},#{rand(28)} #{rand(30) + 10},#{rand(48)}' \
          -draw 'stroke #{color} line #{rand(50)},#{rand(28)} #{rand(180)},#{rand(48)}' \
          -wave #{2 + rand(2)}x#{80 + rand(20)} \
          -gravity Center -sketch 2x19+#{rand(6)} -pointsize #{RuCaptcha.config.font_size} -implode 0.3 label:#{code.upcase} png:-
        CODE
        command.strip!
        # puts command
        pid, stdin, stdout, stderr = POSIX::Spawn.popen4(command)
        Process.waitpid(pid)
        stdout.read
      end
    end
  end
end
