1. Don't forget to run `:PlugInstall` after you've copied everything in your homedir.
2. Install ccls on your system, it's better than clangd because it allows multiple subprojects to have their own `compile_commands.json` or `.ccls` file
3. For your own sanity when using Autotools projects or ones that just use make also install `bear` in order to 
get a compile_commands.json file. Alternatively use `compiledb` and look on the project website for ways of dry-running and gettin a build log from it.
4. [IF USING YCM] For `YouCompleteMe` you need python3-dev build-essential and cmake3 on ubuntu. Find equivalent for your distro. On Fedora you need 
   clang-tools-extra, it'll pull in all the other dependencies, aside from that also install python3-devel and for usual build stuff `dnf group install
   'Development Tools'`, oh and CMake, you need to `sudo dnf/apt install cmake`
   a. You need to run the following command in the YouCompleteMe folder install.py --clangd-completer.
6. [IF USIGN CCLS] Install `npm` and `yarn`. (See project git page tor installation of dependencies).
7. If you're using linux try Cascadia Code Light Font, hope you like it
8. Don't forget to `mkdir ~/.zsh && ln -s $PWD .git-completion.zsh ~/.zsh/_git` to have zsh completions
