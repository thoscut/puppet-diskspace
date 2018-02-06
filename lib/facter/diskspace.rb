require 'facter'

$supported_os = [ 'Linux', 'AIX', 'FreeBSD', 'Darwin',  'windows', 'SunOS' ]
kernel = Facter.value(:kernel)

case kernel
when 'Linux','AIX','FreeBSD'
  df      = '/bin/df -P'
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

if $supported_os.include? kernel
  mounts = Facter::Util::Resolution.exec(df)
  mounts_array = mounts.split(/[\r\n]+/)
  mounts_array.each do |line|
    m = /#{pattern}/.match(line)
    if m
      fs = m[dmatch].gsub(/^\/$/, 'root')
      fs = fs.gsub(/[\/\.:\-]/, '')
      if kernel == 'windows' 
        # Windows doesn't report percentages but bytes
        # Choosing to do the math and round down
        used = ((1 - (m[fmatch].to_f/m[tmatch].to_f))*100).floor
        freekb = (m[fmatch].to_f/1024).floor
        totalkb = (m[tmatch].to_f/1024).floor
      else
        used = m[umatch].to_i
        freekb = m[fmatch].to_i
        totalkb= m[tmatch].to_i
      end
      Facter.add("diskspace_#{fs}") do
        confine :kernel => $supported_os
        setcode do
          used
        end
      end
      Facter.add("diskspacetotalkb_#{fs}") do
        confine :kernel => $supported_os
        setcode do
          totalkb
        end
      end
      Facter.add("diskspacefree_#{fs}") do
        confine :kernel => $supported_os
        setcode do
          100 - used
        end
      end
      Facter.add("diskspacefreekb_#{fs}") do
        confine :kernel => $supported_os
        setcode do
          freekb
        end
      end
    end
  end
end
