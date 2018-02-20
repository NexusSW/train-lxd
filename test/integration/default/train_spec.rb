
# Quick smoke tests to verify transport execute & file operations are wired up

describe command('ls -al /') do
  its('stdout') { should match(/ home$/) }
end

describe passwd do
  its('users') { should include 'ubuntu' }
end
