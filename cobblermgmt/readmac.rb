#check the arguments
if ARGV.length<1 then
  puts "USAGE: ruby readmac.rb mac_list_file"
  exit
end

#settings
mac_list_filename = ARGV[0]
index_file_name = "index"
profile_name = "ubuntu-precise-x86_64"

if FileTest.exist?(mac_list_filename) then
  puts "File #{mac_list_filename} found"
else
  puts "File #{mac_list_filename} was not found"
  exit
end

if FileTest.exist?(index_file_name) then
  puts "File #{index_file_name} found"
else
  puts "File #{index_file_name} was not found"
  exit
end


mac_list_file = File.open(mac_list_filename)
index_file = File.open(index_file_name, "r")


node_index = 0
index_file.each_line do |line|
  puts "index value is:#{line.chomp}"
  node_index = line.chomp.to_i
end

mac_list_file.each_line do |line|
  cmd="cobbler system add --name=#{"node"+node_index.to_s} --mac=#{line.chomp} --interface=eth0 --profile=#{profile_name}"
  puts cmd
  result = system("cobbler system add --name=#{"ruijie-node"+node_index.to_s} --mac=#{line.chomp} --interface=eth0 --profile=#{profile_name.to_s}")
  if result != true then
    puts "error while executing cmd:#{result}"
  end
  node_index += 1
end

mac_list_file.close


index_file.close
system("echo #{node_index} > #{index_file_name}")
