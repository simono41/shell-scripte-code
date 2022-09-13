while true do
  turtle.attack()
  sleep(0.1)
  for i=1, 16, 1 do
    turtle.select(i)
    turtle.dropDown()
  end
end