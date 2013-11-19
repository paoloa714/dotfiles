# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac


function parse_git_branch {
    git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\ \[\1\]/'
}

PS1="\[\e[1;32m\]\u\[\e[1;32m\]@\[\e[1;32m\]\h\[\e[1;37m\]:\[\e[1;34m\]\w\[\e[1;31m\]\$(parse_git_branch) \[\e[1;37m\]$ \[\e[0m\]"

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

alias errlog="tail -f /var/log/apache2/error.log"

function sugarlog {
	if [ -z $1 ]
	then
		DIR="SugarPro7.0"
	else
		DIR=${1}
	fi
	tail -f /var/log/${DIR}/sugarcrm.log
}

alias gocode="cd /var/www/"
alias manifest="php /home/paolo/sugartools/faybus-sugartools/PackageCreator/create.php"

alias manifestdir="mkdir SugarModules&&
		mkdir SugarModules/relationships&&
		mkdir SugarModules/relationships/relationships&&
		mkdir SugarModules/relationships/vardefs&&
		mkdir SugarModules/relationships/language&&
		mkdir SugarModules/relationships/layoutdefs&&
		mkdir SugarModules/modules&&
		mkdir SugarModules/custom;"
		
alias editbash="vim /home/paolo/.bashrc"
alias loadbash=". /home/paolo/.bashrc"

alias rapache="sudo /etc/init.d/apache2 restart"
alias sharevm="sudo mount -t vboxsf -o uid=33,gid=33,rw VM /var/www/"

alias perm="sudo chmod -R 775 `pwd`;sudo chgrp -R www-data `pwd`;sudo chown -R www-data `pwd`"

alias db="mysql -u root -p -A"




SSH_ENV=$HOME/.ssh/environment
   
# start the ssh-agent
function start_agent {
    echo "Initializing new SSH agent..."
    # spawn ssh-agent
    /usr/bin/ssh-agent | sed 's/^echo/#echo/' > ${SSH_ENV}
    echo succeeded
    chmod 600 ${SSH_ENV}
    . ${SSH_ENV} > /dev/null
    /usr/bin/ssh-add
}
   
if [ -f "${SSH_ENV}" ]; then
     . ${SSH_ENV} > /dev/null
     ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
        start_agent;
    }
else
    start_agent;
fi


PATH_TO_SUGAR_BUILD="/home/paolo/sugarbuild/build.php"

alias sugar_build="mkdir -p build; php $PATH_TO_SUGAR_BUILD --basedir=./ --specpath=./build_spec.php"

PATH_TO_TOOLS_DIR="/var/www/workdir/tools"

alias list_convert="php $PATH_TO_TOOLS_DIR/listconvert.php --basedir=./ --filepath=./listviewdefs.php"

alias detail_convert="php $PATH_TO_TOOLS_DIR/detailconvert.php --basedir=./ --filepath=./detailviewdefs.php"

alias subpanel_convert="php $PATH_TO_TOOLS_DIR/subpanelconvert.php --basedir=./ --filepath=./subpanels/default.php"

alias build_spec_create="php $PATH_TO_TOOLS_DIR/build_spec_create.php --basedir=./"

alias build_spec="build_spec_create > build_spec.php"

alias zip_create="build_spec;sugar_build"

function layoutdef_convert {
	php $PATH_TO_TOOLS_DIR/layoutdefconvert.php --basedir=./ --filepath=./${1}
}

function getmodstring {
	php $PATH_TO_TOOLS_DIR/getmodstringforsubpanel.php --basedir=./ --filepath=./${1}
}

function convert {
	CURRENT_DIRECTORY=$(pwd)
	echo "====================================================================="
	echo "Converting module....";
	cd metadata
	if [ -f ./detailviewdefs.php ]; then
		echo "Creating clients/base/views/record directory if it doesnt exist";
		mkdir -p ../clients/base/views/record
		echo "Creating record.php";
		detail_convert > ../clients/base/views/record/record.php
		echo "Saved as clients/base/views/record/record.php";
	else
		echo "./metadata/detailviewdefs.php doesn't exist, skipping creation of record.php"
	fi
	if [ -f ./listviewdefs.php ]; 
	then
		mkdir -p ../clients/base/views/list
		echo "Creating clients/base/views/list/ directory if it doesnt exist";
		echo "Creating list.php";
		list_convert > ../clients/base/views/list/list.php
		echo "Saved as clients/base/views/list/list.php"
	else
		echo "./metadata/listviewdefs.php doesn't exist, skipping creation of list.php"
	fi
	if [ -f ./subpanels/default.php ];
	then
		mkdir -p ../clients/base/views/subpanel-list
		echo "Creating clients/base/views/subpanel-list";
		echo "Creating subpanel-list.php";
		subpanel_convert > ../clients/base/views/subpanel-list/subpanel-list.php
		echo "Saved as clents/base/views/subpanel-list.php";
	else
		echo "./metadata/subpanels/default.php doesn't exist, skipping creation of subpanel-list.php"
	fi
	cd ..
	if [ -z "$1" ]
		then
			echo "Done!!"
			echo "====================================================================="
		else
			cd ../../relationships/layoutdefs
			if [ -f ./${1} ] 
			then
				echo "Creating subpanelbaselayout"
				echo "Creating sidecarsubpanelbaselayout directory"
				mkdir -p ../sidecarsubpanelbaselayout
				layoutdef_convert ${1} > ../sidecarsubpanelbaselayout/${1}
				echo "Saved layout!";
				echo ""
				echo "Please add the entry for the layout in the manifest"
				getmodstring ${1}
			else
				echo "../../relationships/layoutdefs/${1} doesn't exist, skipping creation of ${1}"
			fi
			echo "Done!!"
			echo "====================================================================="
	fi
	cd ${CURRENT_DIRECTORY}
}


function convert_all {
	CUR_DIR=$(pwd)
	echo "======================================================================"
	echo "starting package convert"
	echo "Converting module metadata"
	echo "======================================================================"
	cd SugarModules/modules/
	for d in * 
	do
		echo "Changing directory to module "$d
		cd ${d}
		convert
		cd ..
	done
	if [ -d ../relationships/layoutdefs ] 
	then	
		cd ../relationships/layoutdefs
		echo "Creating sidecar subpanel definitions"
		echo "Creating ../sidecarsubpanelbaselayout"
		mkdir -p ../sidecarsubpanelbaselayout
		for ld in *.php
		do
			echo "Converting "${ld}
			layoutdef_convert ${ld} > ../sidecarsubpanelbaselayout/${ld}
			echo "Saved layout "${ld}"!!"
			echo ""
			echo "Please add the entry for the layout in the manifest"
			getmodstring ${ld}
		done
	else
		echo "../relationships/layoutdefs folder does not exist"
	fi
	echo "Done converting module metadata and subpanel layoutdefs"
	echo "======================================================================"
	cd ${CUR_DIR}
}


function convert_all_layoutdefs {
	echo "Creating sidecar subpanel definitions"
        echo "Creating ../sidecarsubpanelbaselayout"
        mkdir -p ../sidecarsubpanelbaselayout
        for ld in *.php
        do
             echo "Converting "${ld}
             layoutdef_convert ${ld} > ../sidecarsubpanelbaselayout/${ld}
             echo "Saved layout "${ld}"!!"
             echo ""
             echo "Please add the entry for the layout in the manifest"
             getmodstring ${ld}
        done
	echo "DONE"
}



