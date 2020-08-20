set -o vi

EDITOR=vi
TERM=xterm

alias myscreen='screen -S matrix -h 10000'
alias xterm='xterm -bg black -fg white -geometry 90x40 -cr green'
alias rootsh='sudo rootsh -u root'
alias powershell='/usr/local/bin/pwsh'

PATH=/bin:/sbin:/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/ucb:/etc:/usr/openwin/bin:/usr/sbin:
#PATH=~/Library/Python/3.6/bin:$PATH
PATH=$PATH:~/Source/terraform:~/Source/terragrunt
REQUESTS_CA_BUNDLE=/Users/nicholsry/Documents/certnew.cer

export PATH EDITOR TERM REQUESTS_CA_BUNDLE

# get current branch in git repo
function parse_git_branch() {
  BRANCH=`git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`
  if [ ! "${BRANCH}" == "" ]
  then
    STAT=`parse_git_dirty`
    echo "[${BRANCH}${STAT}]"
  else
    echo ""
  fi
}

# get current status of git repo
function parse_git_dirty {
  status=`git status 2>&1 | tee`
  dirty=`echo -n "${status}" 2> /dev/null | grep "modified:" &> /dev/null; echo "$?"`
  untracked=`echo -n "${status}" 2> /dev/null | grep "Untracked files" &> /dev/null; echo "$?"`
  ahead=`echo -n "${status}" 2> /dev/null | grep "Your branch is ahead of" &> /dev/null; echo "$?"`
  newfile=`echo -n "${status}" 2> /dev/null | grep "new file:" &> /dev/null; echo "$?"`
  renamed=`echo -n "${status}" 2> /dev/null | grep "renamed:" &> /dev/null; echo "$?"`
  deleted=`echo -n "${status}" 2> /dev/null | grep "deleted:" &> /dev/null; echo "$?"`
  bits=''
  if [ "${renamed}" == "0" ]; then
    bits=">${bits}"
  fi
  if [ "${ahead}" == "0" ]; then
    bits="*${bits}"
  fi
  if [ "${newfile}" == "0" ]; then
    bits="+${bits}"
  fi
  if [ "${untracked}" == "0" ]; then
    bits="?${bits}"
  fi
  if [ "${deleted}" == "0" ]; then
    bits="x${bits}"
  fi
  if [ "${dirty}" == "0" ]; then
    bits="!${bits}"
  fi
  if [ ! "${bits}" == "" ]; then
    echo " ${bits}"
  else
    echo ""
  fi
}

##
# Setup AWS envs
##
export AWSUSER="nicholsry"
export AWSPW=""
function ac {
    echo "Please enter the account name:"
    read acct
    if [[ $acct == "appdev" ]]; then
      export AWSACCTNAME="mkglobalappdev"
      export AWSACCTNUM="514248975949"
    fi
}

PS1="\u@\h\-W% \[\e[32m\]\`parse_git_branch\`\[\e[m\]: "
