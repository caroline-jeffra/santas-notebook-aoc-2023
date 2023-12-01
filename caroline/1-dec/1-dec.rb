def num_word_filter(string)
  string.gsub!(/(one)/, 'o1e')
  string.gsub!(/(two)/, 't2o')
  string.gsub!(/(three)/, 't3e')
  string.gsub!(/(four)/, 'f4r')
  string.gsub!(/(five)/, 'f5e')
  string.gsub!(/(six)/, 's6x')
  string.gsub!(/(seven)/, 's7n')
  string.gsub!(/(eight)/, 'e8t')
  string.gsub!(/(nine)/, 'n9e')
  return string
end

inputs = "input.txt"
total = 0
if File.exist?(inputs)
  File.open(inputs).each do |line|
    all_digits = []
    line = num_word_filter(line)
    chars = line.split('')
    chars.each do |char|
      if /[0-9]/.match?(char)
        all_digits.push(char)
      end
    end
    cal_digits = []
    cal_digits[0] = all_digits[0]
    cal_digits[1] = all_digits[-1]
    calibration = cal_digits.join().to_i
    total += calibration
  end
end
