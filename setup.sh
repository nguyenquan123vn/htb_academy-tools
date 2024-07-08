!/bin/bash

### VS Code setup ###

# add repo
sudo apt-get install -y wget gpg
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
rm -f packages.microsoft.gpg

# install code
sudo apt install -y apt-transport-https 
sudo apt update
sudo apt install -y code # or code-insiders

#get Burp Pro
html=$(curl -s https://portswigger.net/burp/releases)
version=$(echo $html | grep -Po '(?<=/burp/releases/professional-community-)[0-9]+\-[0-9]+\-[0-9]+' | head -n 1)
Link="https://portswigger-cdn.net/burp/releases/download?product=pro&type=Jar&version=&"
echo $version
wget "$Link" -O burpsuite_pro_v$version.jar --quiet --show-progress

### Github tools download
#install github cli
sudo apt install -y gh
mkdir github_tools 
#install caido
gh release download -D github_tools -R https://github.com/caido/caido --pattern *-linux-x86_64.tar.gz
tar -xvzf *.tar.gz

#install OWASP ZAP
gh release download -D github_tools -R https://github.com/zaproxy/zaproxy --pattern *.crossplatform.zip
unzip *.zip

#setup pwn-doc
git clone https://github.com/pwndoc-ng/pwndoc-ng.git
cd pwndoc-ng
sudo docker-compose up -d --build

### Tmux setup ###

#install xclip for tmux
sudo apt install -y xclip

# tmux plugins manager
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
touch .tmux.conf

# mkdir for tmux logging
mkdir ~/tmux_log

echo "# key binding
# use C-a, since it's on the home row and easier to hit than C-b
set-option -g prefix C-a
unbind-key C-a
bind-key C-a send-prefix
set -g base-index 1

# disable right mouse for terminal copy
unbind -n MouseDown3Pane

# vi is good
setw -g mode-keys vi

# mouse behavior
set -g mouse on

set -g default-terminal "screen-256color"
# set history to 50k to scroll
set -g history-limit 50000
set -g display-time 4000
set -g status-interval 5

# plugins
set -g @plugin 'tmux-plugins/tpm' 
set -g @plugin 'tmux-plugins/tmux-resurrect'
set -g @plugin 'tmux-plugins/tmux-continuum'
set -g @plugin 'tmux-plugins/tmux-yank'
set -g @plugin 'tmux-plugins/tmux-logging'

# plugin parameters
set -g @logging-path "~/tmux_log"

# run plugins
run '~/.tmux/plugins/tpm/tpm'
" >> .tmux.conf

tmux source ~/.tmux.conf 

# install pyenv kali
sudo apt install -y build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev xz-utils tk-dev libffi-dev liblzma-dev python3-openssl git
curl https://pyenv.run | bash
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.zshrc
echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.zshrc
echo -e 'if command -v pyenv 1>/dev/null 2>&1; then\n  eval "$(pyenv init --path)"\nfi' >> ~/.zshrc
exec $SHELL

# install python
pyenv install 2.7.18
pyenv install 3.6.15
