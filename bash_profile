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

## java home
alias java6="export JAVA_HOME=\$(/usr/libexec/java_home -v 1.6);echo 'using Java 6'"
alias java7="export JAVA_HOME=\$(/usr/libexec/java_home -v 1.7);echo 'using Java 7'"
alias java8="export JAVA_HOME=\$(/usr/libexec/java_home -v 1.8);echo 'using Java 8'"
## manual switch for 1.6 or 1.7
java8 ## enable java 6 (or just run j6 in terminal)
## java7 ## enable java 7 (or just run j7 in terminal)

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"
export SSL_CERT_FILE=/usr/local/etc/openssl/cert.pem
