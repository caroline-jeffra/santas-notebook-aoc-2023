inputs = "input.txt"
total = 0
if File.exist?(inputs)
  File.open(inputs).each do |line|
    all_digits = []
    chars = line.split('')
    chars.each do |char|
      if /[0-9]/.match?(char)
        all_digits.push(char)
      end
    end
    p all_digits
    cal_digits = []
    cal_digits[0] = all_digits[0]
    cal_digits[1] = all_digits[-1]
    calibration = cal_digits.join().to_i
    p calibration
    total += calibration
  end
  p total
end
