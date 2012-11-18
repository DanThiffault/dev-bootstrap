package("zsh")
package("exuberant-ctags")
package("vim-nox")
package("tmux")
package("ncurses-term")
package("ec2-api-tools")
package("s3cmd")

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
  
template "/home/ubuntu/.zsh_secret" do
  user "ubuntu"
  group "ubuntu"
  source "zsh_secret.erb"
end

execute "pull dev bucket" do
  command "s3cmd s3://119labs-dev-ap ~/development"
  action :run
end
