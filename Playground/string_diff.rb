class String_diff

def string_difference_percent(a, b)
  longer = [a.size, b.size].max
  same = a.each_char.zip(b.each_char).select { |a,b| a == b }.size
  (longer - same) / a.size.to_f
end


  myObject = String_diff.new
  p myObject.string_difference_percent("WATCH JOE TAKE ON THE SCORPION THIS SATURDAY 13TH JUNE", "WATCH JOE TAKE ON THE SCORPION THIS SATURDAY 13THJUNE")

end
