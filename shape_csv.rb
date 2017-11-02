require 'csv'


def shape file_name
  outcsv = CSV.open(output_file_name(file_name),'w')
  nonamecsv = CSV.open(output_file_name_for_noname(file_name),'w')
  overseacsv = CSV.open(output_file_name_for_oversea(file_name),'w')

  CSV.foreach(file_name,headers:true) do |row|
    address = row[3]
    
    address.scan(/\[[^\]]*\|[^\]]*\]./).each do |part|
      address.gsub!(part,"[[#{part&.split('|')&.last}")
    end
    address = address.gsub(/\[|\]/,'')&.gsub(/\A{{.*}}/,'')&.gsub(/&lt;.*&gt;|&[a-zA-Z]*;/,'')&.split(/&.t|\(|（|\|/)&.first&.strip
    address = address&.gsub(/\Ahttp.* /,'')&.gsub(/\{\{ウィキ.*/,'')&.gsub(/\{\{Location.*/,'')
    row[3] = address

    row[1]&.gsub!(/&lt;.*&gt;|&[a-zA-Z]*;/,'')

    url = row[4]
    url = url&.split(/URL\||url\|/).last&.gsub(/\[|\]|\{|\}/,'')&.gsub(/&lt;.*&gt;|&[a-zA-Z]*;/,' ')&.split(' ')&.first&.strip
    url = url&.gsub(/　|official\||Official\||&lt;nowiki&gt;|&lt;\/nowiki&gt;&lt;|=/,"")
    row[4] = url

    if row[3]&.match(/\A(\p{katakana}|[a-zA-Z]|[0-9]+ [a-zA-Z]|[0-9]+,|〒[0-9]+-[0-9]+ \p{katakana})/) || row[4]&.match(/(\.kr|\.kr\/)\z/)
      overseacsv.puts(row)
    elsif row[1] == '' || row[1] == nil || row[3] == '' || row[3] == nil
      nonamecsv.puts(row)
    else
      outcsv.puts(row)
    end
  end
  outcsv.close
  overseacsv.close
  nonamecsv.close
end

def output_file_name file_name
  file_name.gsub('.csv','_shaped.csv')
end

def output_file_name_for_oversea file_name
  file_name.gsub('.csv','_oversea.csv')
end

def output_file_name_for_noname file_name
  file_name.gsub('.csv','_noname.csv')
end


file_names = Dir.glob('data/*_full.csv')
file_names.each do |file_name|
  shape(file_name)
end