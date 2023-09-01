# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/home/mingbo/.oh-my-zsh"
export PATH=$PATH:/usr/local/go/bin:/home/mingbo/.local/bin:/home/linuxbrew/.linuxbrew/bin
export GTK_IM_MODULE=ibus
export XMODIFIERS=ibus
export QT_IM_MODULE=ibus
export XDG_DATA_DIRS=$XDG_DATA_DIRS:/home/mingbo/.local
source $HOME/.cargo/env
#export GTK_IM_MODULE="fcitx"
#export QT_IM_MODULE="fcitx"
#export XMODIFIERS="@im=fcitx"
# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"


plugins=(git autojump zsh-autosuggestions zsh-syntax-highlighting k)


source $ZSH/oh-my-zsh.sh

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# print_color() {
#        printf '\e]4;1;%s\a\e[0;41m                                     \n                                     \n\e[m' $1
#}
#


function pdf2crop_()
{
        # Convert PDF to encapsulated PostScript.
        # usage:
        # pdf2eps <page number> <pdf file without ext>

        pdfcrop "$1.pdf" "${1}-temp.pdf"
        #mv "$1-temp.pdf" "$1.pdf"

        #pdftk  "$1-temp.pdf" cat 1 output "$1.pdf"
        #pdfjam "$1-temp.pdf"  1 -o "$1.pdf"
        gs -sDEVICE=pdfwrite -dNOPAUSE -dBATCH -dFirstPage=1 -dLastPage=1 -sOutputFile="${1}.pdf" "${1}-temp.pdf"
        rm "${1}-temp.pdf"
}

function pdf2page_()
{
        input="$1"
        page="$2"
        directory=$3

        if test -f "$input"; then
            echo
        else
            echo "file $input does not exist."
            exit 1
        fi
        base_name=`basename ${input}`
        base_predix="${base_name%.*}"
        parent_dir=`dirname "$input"`


        output="${parent_dir}/${base_predix}_${page}.pdf"

        if [ -z "$3" ]
        then
          #empty
          echo
        else
          output="${3}/${base_predix}_${page}.pdf"
        fi

        #echo pdftk "${input}" cat "$page" "$output"
        #pdftk "${input}" cat "$page" output "$output"
        echo gs -sDEVICE=pdfwrite -dNOPAUSE -dBATCH -dFirstPage=$page -dLastPage=${page} -sOutputFile="${output}" "${input}"
        gs -sDEVICE=pdfwrite -dNOPAUSE -dBATCH -dFirstPage=${page} -dLastPage=${page} -sOutputFile="${output}" "${input}"
}


function pdf2cpage_()
{
        input="$1"
        page="$2"
        directory=$3

        if test -f "$input"; then
            echo
        else
            echo "file $input does not exist."
            exit 1
        fi
        base_name=`basename ${input}`
        base_predix="${base_name%.*}"
        parent_dir=`dirname "$input"`


        output="${parent_dir}/${base_predix}_${page}.pdf"

        if [ -z "$3" ]
        then
          #empty
          echo
        else
          output="${3}/${base_predix}_${page}.pdf"
        fi

        #echo pdftk "${input}" cat "$page" "$output"
        #pdftk "${input}" cat "$page" output "$output"
        echo "extracting page_${page}"
        gs -sDEVICE=pdfwrite -dNOPAUSE -dBATCH -dFirstPage=${page} -dLastPage=${page} -sOutputFile="${output}-temp" "${input}"

        echo "crop the pdf"
        pdfcrop "${output}-temp" "${output}"
        rm "${output}-temp"
        #pdftk  "$1-temp.pdf" cat 1 output "$1.pdf"
        #pdfjam "$1-temp.pdf"  1 -o "$1.pdf"
}

function pdf2pages_()
{
 input="$1"
 pages="$2"
 directory=$3

 if test -f "$input"; then
     echo
 else
     echo "file $input does not exist."
     exit 1
 fi
 base_name=`basename ${input}`
 base_predix="${base_name%.*}"
 parent_dir=`dirname "$input"`

 if [[ $pages == *-* ]]
 then
   page_start=$(echo "$pages" | cut -d- -f1)
   page_end=$(echo "$pages" | cut -d- -f2)
   echo $page_start
   echo $page_end
   #for page in {$page_start..$page_end}
   for (( page=$page_start; page<=$page_end; page++ ))
   do
     echo "$page"
     output="${parent_dir}/${base_predix}_${page}.pdf"
     if [ -z "$3" ]
     then
       #empty
       echo
     else
       output="${3}/${base_predix}_${page}.pdf"
     fi

     echo pdftk "${input}" cat "$page" output "$output"
     gs -sdevice=pdfwrite -dnopause -dbatch -dfirstpage=${page} -dlastpage=${page} -soutputfile="${output}" "${input}"

   done
 else
   echo
   ifs=','
   read -r -a page_array <<< "$pages"
   for page in "${page_array[@]}"
   do
     output="${parent_dir}/${base_predix}_${page}.pdf"
     if [ -z "$3" ]
     then
       #empty
       echo
     else
       output="${3}/${base_predix}_${page}.pdf"
     fi

     echo pdftk "${input}" cat "$page" output "$output"
     gs -sdevice=pdfwrite -dnopause -dbatch -dfirstpage=${page} -dlastpage=${page} -soutputfile="${output}" "${input}"
   done
   ## comma
   #page_start=$(echo "$page" | cut -d- -f1)
   #page_end=$(echo "$page" | cut -d- -f2)
 fi
}


function pdf2cpages_()
{
 input="$1"
 pages="$2"
 directory=$3

 if test -f "$input"; then
     echo
 else
     echo "file $input does not exist."
     exit 1
 fi
 base_name=`basename ${input}`
 base_predix="${base_name%.*}"
 parent_dir=`dirname "$input"`

 if [[ $pages == *-* ]]
 then
   page_start=$(echo "$pages" | cut -d- -f1)
   page_end=$(echo "$pages" | cut -d- -f2)
   echo $page_start
   echo $page_end
   #for page in {$page_start..$page_end}
   for (( page=$page_start; page<=$page_end; page++ ))
   do
     echo "$page"
     output="${parent_dir}/${base_predix}_${page}.pdf"
     if [ -z "$3" ]
     then
       #empty
       echo
     else
       output="${3}/${base_predix}_${page}.pdf"
     fi

     #echo pdftk "${input}" cat "$page" output "$output"
     gs -sdevice=pdfwrite -dnopause -dbatch -dfirstpage=${page} -dlastpage=${page} -soutputfile="${output}-temp" "${input}"
     pdfcrop "${output}-temp" "${output}"
     rm "${output}-temp"

   done
 else
   echo
   ifs=','
   read -r -a page_array <<< "$pages"
   for page in "${page_array[@]}"
   do
     output="${parent_dir}/${base_predix}_${page}.pdf"
     if [ -z "$3" ]
     then
       #empty
       echo
     else
       output="${3}/${base_predix}_${page}.pdf"
     fi

     #echo pdftk "${input}" cat "$page" output "$output"
     gs -sdevice=pdfwrite -dnopause -dbatch -dfirstpage=${page} -dlastpage=${page} -soutputfile="${output}-temp" "${input}"
     pdfcrop "${output}-temp" "${output}"
     rm "${output}-temp"
   done
   ## comma
   #page_start=$(echo "$page" | cut -d- -f1)
   #page_end=$(echo "$page" | cut -d- -f2)
 fi
}

show_colour() {
    perl -e 'foreach $a(@ARGV){print "\e[48;2;".join(";",unpack("C*",pack("H*",$a)))."m \e[49m "};print "\n"' "$@"
}

function creadlink()
{
   readlink -f $1 | xargs echo -n |xclip -selection c  && readlink -f $1  
}
function cj_ ()
{
   j $1 
   pwd | xargs echo -n |xclip -selection c 
}



function openf(){
   xdg-open $1 >/dev/null 2>&1 
}

function lc(){
   linkchecker -ocsv $1 | tee errors.csv
   rm errors.csv
}

function evenpdf(){
    pdftk $1 cat 1-endeven output even_$1 
}

function oddpdf(){
    pdftk $1 cat 1-endodd output odd_$1 
}
function cluster2local(){
  echo $1 | sed -e 's/\/hpcwork/~\/cluster_dirs/g' | tee "$(tty)"| xclip -i -selection clipboard &&  
}

function fpskill(){
    ps ux|grep $1 |awk '{print $2}' | xargs kill -9
}

dcd_(){
  cd $1
  pwd|xargs echo -n|xclip -selection c && pwd
}
ccd_(){
  cd $1
  pwd|xargs echo -n|xclip -selection c && pwd
}


lslast_(){
  a=`ls -Art $1| tail -n 1`
  echo $1/$a
}

tailflast_(){
  a=`ls -Art $1| tail -n 1`
  tail -f $1/$a
}
multailflast_(){
  number=$2
  if [ -z "$2" ]
  then
    number=1
  fi  
  echo $number log files
  a=`ls -Art $1| tail -n $number`
  arr=()
  while IFS= read -r line; do arr+=("$line"); done <<<"$a"
  for (( i=1; i<=${#arr[@]}; i++ ))
  do
    echo "$i: ${arr[$i]}"
  done
  
  EXPANDED=("${arr[@]/#/logs/}")
    
  multitail "${EXPANDED[@]}"
}


alias pskill=fpskill
#alias ohmyzsh="mate ~/.oh-my-zsh"
alias cp="cp -p"
alias scp="scp -p"
alias ssh="autossh"
alias cluster="autossh sz753404@login18-1.hpc.itc.rwth-aachen.de"
alias gcluster="autossh sz753404@login18-g-1.hpc.itc.rwth-aachen.de"
alias cluster_gpu1="autossh sz753404@login18-g-1.hpc.itc.rwth-aachen.de"
alias cluster_gpu2="autossh sz753404@login18-g-1.hpc.itc.rwth-aachen.de"
alias cluster2="autossh sz753404@login18-2.hpc.itc.rwth-aachen.de"
alias cluster3="autossh sz753404@login18-3.hpc.itc.rwth-aachen.de"
alias cluster4="autossh sz753404@login18-4.hpc.itc.rwth-aachen.de"
alias ihpc="autossh sz753404@134.130.18.27"
alias vs="autossh -p 7890 lun@127.0.0.1"
alias ws="autossh mingbo@134.130.14.186"
alias cell="autossh mingbo@134.130.18.23"
alias t2="autossh mingbo@134.130.18.23"
alias zws="autossh mingbo@172.30.69.223"
alias cb="xargs echo -n | xclip -selection c"
alias cpwd="pwd|xargs echo -n|xclip -selection c && pwd"
alias ccd="ccd_"
alias arsync='rsync -rlptD'
alias yie="xargs echo -n |xclip -selection c"
alias rl="readlink -f"
alias crl='creadlink'
alias psgrep='ps ux|grep'
alias grep='grep --color'
alias o='xdg-open'
alias r2l="cluster2local"
alias open=openf
alias pdfeven=evenpdf
alias pdfodd=oddpdf
alias m='tldr'
alias cv='progress -w'
alias colt="awk -F'\t' '{print NF; exit}'"
alias colc="awk -F',' '{print NF; exit}'"
alias wea="curl http://wttr.in/aachen"
alias fname="find . -name"
alias ifc="ifconfig|grep inet"
alias rsync="rsync --info=progress2 --human-readable"
alias jupyter2script='jupyter nbconvert --to script'
#alias -s py=vim
alias -s c=vim
alias -s cpp=vim
alias -s R=vim
alias -s Rmd=vim
alias -s go=vim
alias -s md=vim
#R='R --no-save --no-restore-data'
alias r=radian
alias ctsv="column -t -s $'\t' -n \"$@\""
alias ccsv="column -t -s $',' -n \"$@\""
alias dcd=dcd_
alias tailflast=tailflast_
alias lslast=lslast_
alias cj=cj_
alias multitailflast=multailflast_


alias wea='curl http://wttr.in/aachen'

alias enhance='function ne() { docker run --rm -v "$(pwd)/`dirname ${@:$#}`":/ne/input -it alexjc/neural-enhance ${@:1:$#-1} "input/`basename ${@:$#}`"; }; ne'

#
## prompt
pipr="%{%}%{$fg[magenta]%}(%{%}asus%{%})%{$reset_color%} %{%}"

export PROMPT=$PROMPT$pipr


export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# -- START ACTIVESTATE INSTALLATION
export PATH="/home/mingbo/.komodoide/12.0/XRE/state/bin:$PATH"
# -- STOP ACTIVESTATE INSTALLATION
# -- START ACTIVESTATE DEFAULT RUNTIME ENVIRONMENT
export PATH="/home/mingbo/.cache/activestate/bin:$PATH"
# -- STOP ACTIVESTATE DEFAULT RUNTIME ENVIRONMENT
