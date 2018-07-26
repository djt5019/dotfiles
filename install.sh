for f in gitconfig zshrc vimrc irbrc psqlrc; do
    ln -v -s "$(pwd)/.${f}" "${HOME}/.${f}" ;
done


