require 'csv'
require 'date'

$stdout.sync = true

def progress_bar(i, max = 100)
  i = max if i > max
  rest_size = 1 + 5 + 1      # space + progress_num + %
  bar_width = 79 - rest_size # (width - 1) - rest_size = 72
  percent = i * 100.0 / max
  bar_length = i * bar_width.to_f / max
  bar_str = ('#' * bar_length).ljust(bar_width)
  progress_num = '%3.1f' % percent
  print "\r#{bar_str} #{'%5s' % progress_num}%"
end

output_csv = CSV.open('./test.csv', 'w')
output_csv.puts ['ページタイトル', '社名', '法人番号', '本社所在地', '外部リンク']

puts "start!!! ->  #{Time.now}"
File.open('./jawiki-latest-pages-articles.xml', mode = 'rt'){|f|
  pageTitle = ''
  name = ''
  mynumber = ''
  address = ''
  url = ''

  isCompany = false

  line_count = 0
  f.each_line{|line|
    if line.include?('<title>')
      pageTitle = line.gsub(/<title>/, '')
      pageTitle = pageTitle.gsub(/<\/title>/, '').strip
    end

    if line.include?('</page>')
      if isCompany == true
        output_csv.puts ["#{pageTitle}", "#{name}", "#{mynumber}", "#{address}", "#{url}"]
      end
      isCompany = false
      pageTitle = ''
      name = ''
      mynumber = ''
      address = ''
      url = ''
    end

    if line.include?('{{基礎情報 会社')
      isCompany = true
    end

    if line.include?('|社名')  and line.include?('=')
      name = line.gsub(/\A.*=/, '').strip
    end

    if line.match(/\A.*法人番号.*=/)
      mynumber = line.gsub(/\A.*法人番号 *=/, '').strip
    end

    if line.match(/\A.*本社所在地.*=/)
      address = line.gsub(/\A.*本社所在地 *=/, '').strip
    end

    if line.match(/\A.*外部リンク.*=/)
      url = line.gsub(/\A.*外部リンク *=/, '').strip
    end

    if line.match(/\A}}\n/) and isCompany == true
      output_csv.puts ["#{pageTitle}", "#{name}", "#{mynumber}", "#{address}", "#{url}"]
      isCompany = false
    end

    line_count += 1
    progress_bar(line_count, 159505228)
  }
}

output_csv.close
puts "end!!! ->  #{Time.now}"
