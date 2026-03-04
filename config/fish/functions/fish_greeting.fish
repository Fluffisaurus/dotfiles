function fish_greeting
    set CURRENT_THEME $(gsettings get org.gnome.desktop.interface color-scheme)

    if test "$CURRENT_THEME" = "'prefer-dark'"
        or test "$CURRENT_THEME" = "'default'"
        set MAIN_COLOUR brblue
        set SECONDARY_COLOUR brpurple
        set ACCENT_COLOUR brcyan
        set TEXT_COLOUR white
    else
        set MAIN_COLOUR blue
        set SECONDARY_COLOUR purple
        set ACCENT_COLOUR cyan
        set TEXT_COLOUR black
    end

    set INFO_LAST_LOGIN $(echo 'Last login: '(set_color $TEXT_COLOUR)(last -F -n 1 -R $USER | head -n 1 | awk '{$1=$2=$3=$NF=""; print $0}' | xargs echo))

    set INFO_DATE $(echo 'Date:       '(set_color $TEXT_COLOUR)(date +"%A, %b %d, %Y"))
    set INFO_TIME $(echo 'Time:       '(set_color $TEXT_COLOUR)(date +"%R, %Z %:z"))
    set INFO_UPTIME $(echo 'Uptime:     '(set_color $TEXT_COLOUR)(uptime -p | sed 's/^[^up]*up //'))

    set INFO_HARDWARE $(echo 'Hardware:   '(set_color $TEXT_COLOUR)(hostnamectl | grep "Hardware Model: " | sed 's/[^:]*:[[:space:]]*//'))
    set INFO_OS $(echo 'OS:         '(set_color $TEXT_COLOUR)(hostnamectl | grep "Operating System: " | sed 's/[^:]*:[[:space:]]*//'))
    set INFO_VERSION $(echo 'Kernel:     '(set_color $TEXT_COLOUR)(hostnamectl | grep "Kernel: " | sed 's/[^:]*:[[:space:]]Linux *//'))

    set_color --dim --italics 808080
    echo -e $INFO_LAST_LOGIN '\n'
    set_color normal

    set_color $TEXT_COLOUR
    echo 'Welcome back, '(set_color --bold $MAIN_COLOUR)(whoami)'@'(hostname)(set_color normal)(set_color $TEXT_COLOUR)', ya silly 🪿💨💨💨'

    echo '                 '(set_color $MAIN_COLOUR)'___
  ___======____='(set_color $ACCENT_COLOUR)'-'(set_color $SECONDARY_COLOUR)'-'(set_color $ACCENT_COLOUR)'-='(set_color $MAIN_COLOUR)')     '(set_color $SECONDARY_COLOUR)''(echo $INFO_DATE)''(set_color $MAIN_COLOUR)'
/T            \_'(set_color $SECONDARY_COLOUR)'--='(set_color $ACCENT_COLOUR)'=='(set_color $MAIN_COLOUR)')    '(set_color $SECONDARY_COLOUR)''(echo $INFO_TIME)''(set_color $MAIN_COLOUR)'
[ \ '(set_color $ACCENT_COLOUR)'('(set_color $SECONDARY_COLOUR)'0'(set_color $ACCENT_COLOUR)')   '(set_color $MAIN_COLOUR)'\~    \_'(set_color $SECONDARY_COLOUR)'-='(set_color $ACCENT_COLOUR)'='(set_color $MAIN_COLOUR)')'(set_color $SECONDARY_COLOUR)'    '(echo $INFO_UPTIME)''(set_color $MAIN_COLOUR)'
 \      / )J'(set_color $ACCENT_COLOUR)'~~    \\'(set_color $SECONDARY_COLOUR)'-='(set_color $MAIN_COLOUR)')    '(set_color $SECONDARY_COLOUR)''(echo '')''(set_color $MAIN_COLOUR)'
  \\\\___/  )JJ'(set_color $ACCENT_COLOUR)'~'(set_color $SECONDARY_COLOUR)'~~   '(set_color $MAIN_COLOUR)'\)     '(set_color $SECONDARY_COLOUR)''(echo $INFO_HARDWARE)''(set_color $MAIN_COLOUR)'
   \_____/JJJ'(set_color $ACCENT_COLOUR)'~~'(set_color $SECONDARY_COLOUR)'~~    '(set_color $MAIN_COLOUR)'\\    '(set_color $SECONDARY_COLOUR)''(echo $INFO_OS)''(set_color $MAIN_COLOUR)'
   '(set_color $ACCENT_COLOUR)'/ '(set_color $SECONDARY_COLOUR)'\  '(set_color $SECONDARY_COLOUR)', \\'(set_color $MAIN_COLOUR)'J'(set_color $ACCENT_COLOUR)'~~~'(set_color $SECONDARY_COLOUR)'~~     '(set_color $ACCENT_COLOUR)'\\   '(set_color $SECONDARY_COLOUR)''(echo $INFO_VERSION)''(set_color $ACCENT_COLOUR)'
  (-'(set_color $SECONDARY_COLOUR)'\)'(set_color $MAIN_COLOUR)'\='(set_color $ACCENT_COLOUR)'|'(set_color $SECONDARY_COLOUR)'\\\\\\'(set_color $ACCENT_COLOUR)'~~'(set_color $SECONDARY_COLOUR)'~~       '(set_color $ACCENT_COLOUR)'L_'(set_color $SECONDARY_COLOUR)'_
  '(set_color $ACCENT_COLOUR)'('(set_color $MAIN_COLOUR)'\\'(set_color $ACCENT_COLOUR)'\\)  ('(set_color $SECONDARY_COLOUR)'\\'(set_color $ACCENT_COLOUR)'\\\)'(set_color $MAIN_COLOUR)'_           '(set_color $SECONDARY_COLOUR)'\=='(set_color $ACCENT_COLOUR)'__
   '(set_color $MAIN_COLOUR)'\V    '(set_color $ACCENT_COLOUR)'\\\\'(set_color $MAIN_COLOUR)'\) =='(set_color $ACCENT_COLOUR)'=_____   '(set_color $SECONDARY_COLOUR)'\\\\\\\\'(set_color $ACCENT_COLOUR)'\\\\
          '(set_color $MAIN_COLOUR)'\V)     \_) '(set_color $ACCENT_COLOUR)'\\\\'(set_color $SECONDARY_COLOUR)'\\\\JJ\\'(set_color $ACCENT_COLOUR)'J\)
                      '(set_color $MAIN_COLOUR)'/'(set_color $ACCENT_COLOUR)'J'(set_color $SECONDARY_COLOUR)'\\'(set_color $ACCENT_COLOUR)'J'(set_color $MAIN_COLOUR)'T\\'(set_color $ACCENT_COLOUR)'JJJ'(set_color $MAIN_COLOUR)'J)
                      (J'(set_color $ACCENT_COLOUR)'JJ'(set_color $MAIN_COLOUR)'| \UUU)
                       (UU)'(set_color normal)

    echo ''
end
