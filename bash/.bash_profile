
# User specific environment and startup programs
export TERM=linux
# export PS1="\[\e[36;1m\]\u@\[\e[32;1m\]\h:\[\e[31;1m\]\w:> \[\e[0m\]" ;
export EDITOR=vim
alias vi='vim $*'

alias mvn='/usr/local/apache-maven-3.0.4/bin/mvn'

PATH=$PATH:/usr/local/bin:$HOME/bin

export PATH

alias flyway='${HOME}/flyway/flyway-3.0/flyway'
#alias curl='curl -O $*'

#alias lv='tail -f $* /home/lesstif/atlassian/confluence-app-data/confluence/logs/
atlassian-confluence.log'
#alias lvi='vi /home/lesstif/atlassian/confluence-app-data/confluence/logs/atlassi
an-confluence.log'

alias lv='tail -f /home/lesstif/tsign-web/apache-tomcat-7.0.53/logs/catalina.out'
alias lvi='vi /home/lesstif/tsign-web/apache-tomcat-7.0.53/logs/catalina.out'
alias ant='/usr/local/apache-ant-1.9.4/bin/ant'

alias wp='cd /var/www/wordpress/wordpress-3.9.1/'

export PATH=$PATH:~/.composer/vendor/bin/

alias lala='cd /var/www/lesstif/php/'

function gi() {
    curl -L -s https://www.gitignore.io/api/$1 ;
}

alias gi-java="gi \"eclipse,java,vim,maven,windows,intellij\""

PY27=/usr/local/python2.7/
export PATH=$PATH:${PY27}/bin
export LD_LIBRARY_PATH=${PY27}/lib:${LD_LIBRARY_PATH}

## Python 3
PY35=/usr/local/python3.5/
export PATH=$PATH:${PY35}/bin
export LD_LIBRARY_PATH=${PY35}/lib:$LD_LIBRARY_PATH

alias h='http --follow'

alias cls='clear'

export ANSIBLE_INVENTORY=~/ansible/ansible_hosts

export JAVA_HOME=/usr/java/jdk1.8
export PATH=$JAVA_HOME/bin:$PATH

function jdk7 {
    export JAVA_HOME=/usr/java/jdk1.7
    export PATH=$JAVA_HOME/bin:$PATH
    java -version
}

function jdk8 {
    export JAVA_HOME=/usr/java/jdk1.8
    export PATH=$JAVA_HOME/bin:$PATH
    java -version
}

function jdk6 {
    export JAVA_HOME=/usr/java/jdk1.6
    export PATH=$JAVA_HOME/bin:$PATH
    java -version
}

export GOROOT=/usr/local/go
export PATH=$PATH:$GOROOT/bin

export GOPATH=/home/lesstif/gopath
export PATH=$PATH:$GOPATH/bin

## enable forward search
## http://vaab.blog.kal.fr/2010/11/11/enabling-ctrl-s-for-forward-history-search-in-bash/
stty stop ''
