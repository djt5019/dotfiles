for f in gitconfig zshrc vimrc irbrc psqlrc; do
    ln -v -s "$(pwd)/.${f}" "${HOME}/.${f}" ;
done


if ! command -v asdf &> /dev/null; then
    echo "I didnt find asdf installed or in your $$PATH; might need to brew install asdf"
else
    # Install erlang first then elixir
    asdf plugin add erlang
    asdf install erlang latest
    asdf global erlang latest

    asdf plugin add elixir
    asdf install elixir latest
    asdf global elixir latest
fi
