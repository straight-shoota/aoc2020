passports = [] of Hash(String, String)

ARGF.each_line("\n\n", chomp: true) do |line|
  data = Hash(String, String).new
  line.split(/ |\n/) do |field|
    key, _, value = field.partition(":")
    data[key] = value
  end
  passports << data
end

required_fields = ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"]
count = passports.count do |data|
  required_fields.all? { |field| data.has_key?(field) }
end

count2 = passports.count do |data|
  data["byr"]?.try(&.to_i?).try(&.in?(1920..2002)) &&
    data["iyr"]?.try(&.to_i?).try(&.in?(2010..2020)) &&
    data["eyr"]?.try(&.to_i?).try(&.in?(2020..2030)) &&
    data["hgt"]?.try do |hgt|
      if h = hgt.rchop?("cm")
        h.to_i?(whitespace: false).try(&.in?(150..193))
      elsif h = hgt.rchop?("in")
        h.to_i?(whitespace: false).try(&.in?(59..76))
      else
        false
      end
    end &&
    data["hcl"]?.try do |hcl|
      (hcl = hcl.lchop?("#")) && hcl.size == 6 && hcl.to_i?(16, whitespace: false)
    end &&
    data["ecl"]?.in?(%w(amb blu brn gry grn hzl oth)) &&
    data["pid"]?.try do |pid|
      pid.size == 9 && pid.to_i?(whitespace: false)
    end
end

p! count
p! count2
