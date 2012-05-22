package("zsh")
package("vim")
package("tmux")

git "/home/ubuntu/dotfiles" do
  user "ubuntu"
  group "ubuntu"
  repository "git://github.com/DanThiffault/dotfiles.git"
  enable_submodules true
  reference "master"
  action :sync
end

execute "copy over dot files" do
  user "ubuntu"
  group "ubuntu"
  command "rsync --exclude \".git/\" --exclude \".DS_Store\" --exclude \"bootstrap.sh\" --exclude \"README.md\" -av /home/ubuntu/dotfiles/ /home/ubuntu" 
  action :run
end
  
execute "copy over secret dot files" do
  user "ubuntu"
  group "ubuntu"
  command "rsync --exclude \".git/\" --exclude \".DS_Store\" --exclude \"bootstrap.sh\" --exclude \"README.md\" -av /home/ubuntu/dev-bootstrap/secrets/ /home/ubuntu" 
  action :run
end

# execute "change shell to zsh" do
#   user "ubuntu"
#   group "ubuntu"
#   command "chsh -s /usr/bin/zsh ubuntu"
#   action :run
# end

