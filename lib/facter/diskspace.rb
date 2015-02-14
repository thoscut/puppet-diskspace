require 'facter'

$supported_os = [ 'Linux', 'AIX', 'Darwin',  'windows' ]
kernel = Facter.value(:kernel)

case kernel
when 'Linux','AIX'
  df      = '/bin/df -P'
  pattern = '^(?:map )?([/\w\-\.:\-]+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)%\s+([/\w\-\.:]+)'
  dmatch  = 6
  umatch  = 5
when 'Darwin'
  df      = '/usr/bin/df -P'
  pattern = '^(?:map )?([/\w\-\.:\-]+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)%\s+([/\w\-\.:]+)'
  dmatch  = 9
  umatch  = 5
when 'windows'
  df      = 'C:\Windows\System32\wbem\WMIC.exe logicaldisk get deviceid,freespace,size'
  pattern = '^([A-Z]:)\s+(\d+)\s+(\d+)'
  dmatch  = 1
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
        used = ((1 - (m[2].to_f/m[3].to_f))*100).floor
      else
        used = m[umatch].to_i
      end
      Facter.add("diskspace_#{fs}") do
        confine :kernel => $supported_os
        setcode do
          used
        end
      end
      Facter.add("diskspacefree_#{fs}") do
        confine :kernel => $supported_os
        setcode do
          100 - used
        end
      end
    end
  end
end
