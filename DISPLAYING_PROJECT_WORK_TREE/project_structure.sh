# add aliases to the system file(use ~/.bashrc if you have that)
cat >> ~/.zshrc << 'EOF'          
alias tree="tree -a -I '.git|__pycache__|node_modules|.venv' -L 3"
alias gtree="git ls-tree -r --name-only HEAD | head -20"
alias bigfiles="find . -type f -size +50M -exec ls -lh {} + 2>/dev/null"
EOF
source ~/.zshrc

# run this command within the desired working space(root)
tree -a -I '.git|__pycache__' -L 2