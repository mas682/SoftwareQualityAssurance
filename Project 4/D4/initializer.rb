








file = File.open("INIT.txt", "w")
i = 40
while i < 125
  value = ((i**3000)+(i**i)-(3**i))*(7**i)
  file.puts(value)
  i = i + 1
end
file.close
