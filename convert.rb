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

class CsvColumns
  attr_writer :pageTitle, :name, :mynumber, :url, :syurui, :ryakusyou, :address, :yuubinbangou, :hontensyozai,
              :hontenyuubinbangou, :gyousyu, :jigyounaiyou, :daihyousya, :shihonkin, :uriagedaka, :jyuugyouinsu, :shitennsu,
              :kabunushi, :kogaisya

  def initialize(csv_object)
    @output_csv = csv_object
    @pageTitle = '' # ページタイトル
    clear_contents
  end

  def clear_contents
    @name = '' # 会社名
    @mynumber = '' # 法人番号
    @url = '' # 外部リンク
    @syurui = '' # 種類
    @ryakusyou = '' # 略称
    @yuubinbangou = '' # 本社郵便番号
    @address = '' # 本社所在地
    @hontenyuubinbangou = '' # 本店郵便番号
    @hontensyozai = '' # 本店所在地
    @gyousyu = '' # 業種
    @jigyounaiyou = '' # 事業内容
    @daihyousya = '' # 代表者
    @shihonkin = '' # 資本金
    @uriagedaka = '' # 売上高
    @jyuugyouinsu = '' # 従業員数
    @shitennsu = '' # 支店舗数
    @kabunushi = '' # 主要株主
    @kogaisya = '' # 主要子会社
  end

  def write_header
    @output_csv.puts ['ページタイトル', '社名', '法人番号', '外部リンク', '種類',
                      '略称', '本社郵便番号', '本社所在地', '本店郵便番号', '本店所在地',
                      '業種', '事業内容', '代表者', '資本金', '売上高', '従業員数',
                      '支店舗数', '主要株主', '主要子会社']
  end

  def write_contents
    @output_csv.puts ["#{@pageTitle}", "#{@name}", "#{@mynumber}", "#{@url}", "#{@syurui}",
                      "#{@ryakusyou}", "#{@yuubinbangou}", "#{@address}", "#{@hontenyuubinbangou}", "#{@hontensyozai}",
                      "#{@gyousyu}", "#{@jigyounaiyou}", "#{@daihyousya}", "#{@shihonkin}", "#{@uriagedaka}", "#{@jyuugyouinsu}",
                      "#{@shitennsu}", "#{@kabunushi}", "#{@kogaisya}"]
  end

  def set_column(line, column, column_match_moji)
    if line.match(/\A\|.*#{column_match_moji}.*=/)
      tmp = line.gsub(/\A\|.*#{column_match_moji} *?=/, '').strip
      eval "#{column} = tmp"
    end
  end

  def set_column_company(line)
      if line.match(/\A\|\s*社名\s*?=/)
        @name = line.gsub(/\A\|\s*社名\s*?=/, '').strip
      end

      set_column(line, '@mynumber', '法人番号')
      set_column(line, '@url', '外部リンク')
      set_column(line, '@syurui', '種類')
      set_column(line, '@ryakusyou', '略称')
      set_column(line, '@yuubinbangou', '本社郵便番号')
      set_column(line, '@address', '本社所在地')
      set_column(line, '@hontenyuubinbangou', '本店郵便番号')
      set_column(line, '@hontensyozai', '本店所在地')
      set_column(line, '@gyousyu', '業種')
      set_column(line, '@jigyounaiyou', '事業内容')
      set_column(line, '@daihyousya', '代表者')
      set_column(line, '@shihonkin', '資本金')
      set_column(line, '@uriagedaka', '売上高')
      set_column(line, '@jyuugyouinsu', '従業員数')
      set_column(line, '@shitennsu', '支店舗数')
      set_column(line, '@kabunushi', '主要株主')
      set_column(line, '@kogaisya', '主要子会社')
  end

  def set_column_lab(line)
      if line.match(/\A\|\s*名称\s*?=/)
        @name = line.gsub(/\A\|\s*名称\s*?=/, '').strip
      end

      set_column(line, '@mynumber', '法人番号')
      set_column(line, '@url', '公式サイト')
      set_column(line, '@syurui', '組織形態')
      set_column(line, '@ryakusyou', '略称')
      set_column(line, '@yuubinbangou', '所在地郵便番号')
      set_column(line, '@address', '所在地')
      set_column(line, '@jigyounaiyou', '活動領域')
      set_column(line, '@daihyousya', '代表')
      set_column(line, '@jyuugyouinsu', '人数')
      set_column(line, '@kabunushi', '上位組織')
      set_column(line, '@kogaisya', '保有施設')
  end

  def set_column_npo(line)
      if line.match(/\A\|\s*組織名\s*?=/)
        @name = line.gsub(/\A\|\s*組織名\s*?=/, '').strip
      end

      set_column(line, '@mynumber', '法人番号')
      set_column(line, '@url', '外部リンク')
      set_column(line, '@ryakusyou', '略称')
      set_column(line, '@yuubinbangou', '郵便番号')
      set_column(line, '@address', '事務所')
      set_column(line, '@jigyounaiyou', '主な事業')
      set_column(line, '@daihyousya', '代表者')
      set_column(line, '@jyuugyouinsu', '事務局員')
      set_column(line, '@jyuugyouinsu', '会員')
  end

  def set_column_tv(line)
      if line.match(/\A\|\s*局名\s*?=/)
        @name = line.gsub(/\A\|\s*局名\s*?=/, '').strip
      end

      set_column(line, '@mynumber', '法人番号')
      set_column(line, '@url', 'リンク')
      set_column(line, '@syurui', '系列')
      set_column(line, '@ryakusyou', '愛称')
      set_column(line, '@yuubinbangou', '郵便番号')
      set_column(line, '@address', '本社')
  end

  def set_column_radio(line)
      if line.match(/\A\|\s*放送局\s*?=/)
        @name = line.gsub(/\A\|\s*放送局\s*?=/, '').strip
      end

      set_column(line, '@mynumber', '法人番号')
      set_column(line, '@url', 'リンク')
      set_column(line, '@syurui', '種別')
      set_column(line, '@syurui', '系列')
      set_column(line, '@ryakusyou', '愛称')
      set_column(line, '@yuubinbangou', '郵便番号')
      set_column(line, '@address', '本社')
  end
end

csv = CSV.open('./test.csv', 'w')
output_csv = CsvColumns.new(csv)

output_csv.write_header

puts "start!!! ->  #{Time.now}"
File.open('./jawiki-latest-pages-articles.xml', mode = 'rt'){|f|

  organization = { Company: false, Lab: false, NPO: false, TV: false, Radio: false }

  line_count = 0
  page_count = 0

  f.each_line{|line|
    if line.include?('<title>')
      output_csv.pageTitle = line.gsub(/<title>/, '').gsub(/<\/title>/, '').strip
    end

    if line.include?('</page>')
      if organization.value?(true)
        output_csv.write_contents
      end
      page_count += 1
      organization.each_key { |k| organization[k] = false }
      output_csv.clear_contents
      output_csv.pageTitle = ''
    end

    if line.match(/{{[ |　]*基礎情報[ |　]+会社/)
      organization[:Company] = true
    end

    if line.match(/{{[ |　]*Infobox[ |　]+研究所/)
      organization[:Lab] = true
    end

    if line.match(/{{[ |　]*基礎情報[ |　]+特定非営利活動法人/)
      organization[:NPO] = true
    end

    if line.match(/{{[ |　]*基礎情報[ |　]+日本のテレビ局/)
      organization[:TV] = true
    end

    if line.match(/{{[ |　]*基礎情報[ |　]+日本のラジオ局/)
      organization[:Radio] = true
    end

    if organization[:Company] == true
      output_csv.set_column_company(line)

      if line.match(/\A}}\n/)
        output_csv.write_contents
        output_csv.clear_contents
	organization.each_key { |k| organization[k] = false }
      end
    end

    if organization[:Lab] == true
      output_csv.set_column_lab(line)

      if line.match(/\A}}\n/)
        output_csv.write_contents
        output_csv.clear_contents
	organization.each_key { |k| organization[k] = false }
      end
    end

    if organization[:NPO] == true
      output_csv.set_column_npo(line)

      if line.match(/\A}}\n/)
        output_csv.write_contents
        output_csv.clear_contents
	organization.each_key { |k| organization[k] = false }
      end
    end

    if organization[:TV] == true
      output_csv.set_column_tv(line)

      if line.match(/\A}}\n/)
        output_csv.write_contents
        output_csv.clear_contents
	organization.each_key { |k| organization[k] = false }
      end
    end

    if organization[:Radio] == true
      output_csv.set_column_radio(line)

      if line.match(/\A}}\n/)
        output_csv.write_contents
        output_csv.clear_contents
	organization.each_key { |k| organization[k] = false }
      end
    end

    line_count += 1
    progress_bar(line_count, 159505228)
  }
puts ""
puts "page_count => #{page_count}"
}

csv.close
puts ''
puts "end!!! ->  #{Time.now}"
