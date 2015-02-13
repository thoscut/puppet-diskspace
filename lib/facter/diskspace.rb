require 'facter'

case Facter.value(:kernel)
when 'Linux','AIX'
  df      = '/bin/df -P'
  pattern = '^([/\w\-\.:]+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)%\s+([/\w\-\.:]+)'
  dmatch  = 6
  umatch  = 5
when 'Darwin'
  df      = '/usr/bin/df -P'
  pattern = '^(?:map )?([/\w\-\.:\-]+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)%\s+([/\w\-\.:]+)'
  dmatch  = 9
  umatch  = 5
end

mounts = Facter::Core::Execution.exec(df)
mounts_array = mounts.split("\n")
mounts_array.each do |line|
  m = /#{pattern}/.match(line)
  if m
    fs = m[dmatch].gsub(/^\/$/, 'root')
    fs = fs.gsub(/[\/\.:\-]/, '')
    Facter.add("diskspace_#{fs}") do
      setcode do
        m[umatch].to_i
      end
    end
    Facter.add("diskspacefree_#{fs}") do
      setcode do
        100 - m[umatch].to_i
      end
    end
  end
end

