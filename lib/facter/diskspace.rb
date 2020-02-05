supported_os = ['Linux', 'AIX', 'FreeBSD', 'Darwin', 'windows', 'SunOS']
kernel       = Facter.value(:kernel)

case kernel
when 'Linux', 'AIX', 'FreeBSD'
  df      = '/bin/df -P| sed -n "1p;/^\//p;"'
  pattern = '^(?:map )?([/\w\-\.:\-]+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)%\s+([/\w\-\.:]+)'
  dmatch  = 6
  umatch  = 5
  fmatch  = 4
  tmatch  = 2  # total size
when 'Darwin'
  df      = '/bin/df -P'
  pattern = '^(?:map )?([/\w\-\.:\-]+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)%\s+([/\w\-\.:]+)'
  dmatch  = 6
  umatch  = 5
  fmatch  = 4
  tmatch  = 2  # total size
when 'SunOS'
  df      = '/usr/bin/df -k'
  pattern = '^(?:map )?([/\w\-\.:\-]+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)%\s+([/\w\-\.:]+)'
  dmatch  = 6
  umatch  = 5
  fmatch  = 4
  tmatch  = 2  # total size
when 'windows'
  df      = 'C:\Windows\System32\wbem\WMIC.exe logicaldisk get deviceid,freespace,size'
  pattern = '^([A-Z]:)\s+(\d+)\s+(\d+)'
  dmatch  = 1
  fmatch  = 2
  tmatch  = 3  # total size
end

if supported_os.include? kernel
  mounts = Facter::Util::Resolution.exec(df)
  mounts_array = mounts.split(%r{[\r\n]})
  mounts_array.each do |line|
    m = %r{#{pattern}}.match(line)
    next unless m
    fs = m[dmatch].gsub(%r{^\/$}, 'root')
    fs = fs.gsub(%r{[\/\.:\-]}, '')
    if kernel == 'windows'
      # Windows doesn't report percentages but bytes
      # Choosing to do the math and round down
      used    = ((1 - (m[fmatch].to_f / m[tmatch].to_f)) * 100).floor
      freekb  = (m[fmatch].to_f / 1024).floor
      totalkb = (m[tmatch].to_f / 1024).floor
      usedkb  = (totalkb - freekb).floor
    else
      used    = m[umatch].to_i
      freekb  = m[fmatch].to_i
      totalkb = m[tmatch].to_i
      usedkb  = (totalkb - freekb).to_i

    end
    Facter.add("diskspace_used_percent_#{fs}") do
      confine kernel: supported_os
      setcode do
        used
      end
    end
    Facter.add("diskspace_used_kb_#{fs}") do
      confine kernel: supported_os
      setcode do
        usedkb
      end
    end
    Facter.add("diskspace_total_kb_#{fs}") do
      confine kernel: supported_os
      setcode do
        totalkb
      end
    end
    Facter.add("diskspace_free_percent_#{fs}") do
      confine kernel: supported_os
      setcode do
        100 - used
      end
    end
    Facter.add("diskspace_free_kb_#{fs}") do
      confine kernel: supported_os
      setcode do
        freekb
      end
    end
  end
end
