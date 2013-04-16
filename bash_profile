source ~/.common_aliases
source ~/.bash/aliases
source ~/.bash/completions
source ~/.bash/paths
source ~/.bash/config
source ~/.bash/prompt

if [ -f ~/.bashrc ]; then
  . ~/.bashrc
fi

if [ -f ~/.localrc ]; then
  . ~/.localrc
fi

JRUBY_OPTS='--1.9 -J-Dfile.encoding=UTF-8 -J-Djruby.jit.threshold=10 -J-Djruby.compile.mode=JIT -J-Xms1536m -J-Xmx1536m -J-XX:MaxPermSize=512m -J-server'
