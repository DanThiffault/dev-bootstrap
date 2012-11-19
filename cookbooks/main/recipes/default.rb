package("zsh")
package("exuberant-ctags")
package("tmux")
package("ncurses-term")
package("ec2-api-tools")
package("s3cmd")

# install mercurial, for fetching the vim source
package "mercurial"

# dependency for vim
package "libncurses5-dev"

# need to compile vim from scratch in order to support ruby interpreter
script "install vim from source with ruby and multibyte support" do
  interpreter "zsh"
  user "root"
  cwd "/usr/src"
  not_if "vim --version | grep +ruby"
  code <<-EOH
  hg clone https://vim.googlecode.com/hg/ vim
  cd vim
  ./configure --enable-rubyinterp --enable-multibyte --enable-pythoninterp --enable-perlinterp
  make
  cd src
  make install
  EOH
end

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

template "/home/ubuntu/.s3cfg" do
  user "ubuntu"
  group "ubuntu"
  source "s3cfg.erb"
end

directory "/home/ubuntu/development" do                                                                                                                                                                             
  user "ubuntu"                                                                                                                                                                                                     
  group "ubuntu"                                                                                                                                                                                                    
  action :create                                                                                                                                                                                                    
end                                                                                                                                                                                                                 

execute "pull dev bucket" do                                                                                                                                                                                        
  user "ubuntu"                                                                                                                                                                                                     
  group "ubuntu"                                                                                                                                                                                                    
  command "s3cmd sync s3://119labs-dev-ap /home/ubuntu/development"                                                                                                                                                 
  action :run                                                                                                                                                                                                       
end   

script "compile command-t for vim" do
  interpreter "zsh"
  user "root"
  cwd "/home/ubuntu/.vim/ruby/command-t"
  code <<-EOH
  ruby extconf.rb
  make clean
  make
  make install
  chown -R ubuntu:ubuntu /home/ubuntu/.vim
  EOH
end

