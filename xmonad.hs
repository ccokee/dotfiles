-- ###### Imports ###### --
-- ### Xmonad ### --
import XMonad
import XMonad.Util.Run 
import XMonad.Actions.CycleWS
import XMonad.Actions.SpawnOn
import XMonad.Actions.GridSelect
import qualified Data.Map as M
import qualified XMonad.StackSet as W
import Data.Bits ((.|.))
import Data.Monoid
import Data.Ratio ((%))
import Graphics.X11.Xlib
import Graphics.X11.Xlib.Extras 

-- ### System ### --
import System.IO
import System.Exit

-- ### Prompt ### --
import XMonad.Prompt
import XMonad.Prompt.RunOrRaise (runOrRaisePrompt)
import XMonad.Prompt.AppendFile (appendFilePrompt)

-- ### Hooks ### --
import XMonad.ManageHook
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.SetWMName
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.UrgencyHook
import XMonad.Hooks.FadeInactive
import XMonad.Hooks.EwmhDesktops
import XMonad.Operations
 
-- ### Layout ### --
import XMonad.Layout
import XMonad.Layout.NoBorders (smartBorders, noBorders)
import XMonad.Layout.PerWorkspace (onWorkspace, onWorkspaces)
import XMonad.Layout.Reflect (reflectHoriz)
import XMonad.Layout.IM
import XMonad.Layout.SimpleFloat
import XMonad.Layout.Spacing
import XMonad.Layout.ResizableTile
import XMonad.Layout.LayoutHints
import XMonad.Layout.LayoutModifier
import XMonad.Layout.Grid
import XMonad.Layout.Tabbed
import XMonad.Layout.TrackFloating

-- ### GSconfig --

-- ### Terminal ### --
myTerminal = "xfce4-terminal"

-- ### modMask ### -- 
mymodMask :: KeyMask
mymodMask = mod4Mask

-- ### Workspaces ### --
myWorkspaces = ["1:cKlap","2:www","3:dev","4:file","5:virt","6:mayhem","7:media","8:com"]

-- ### Bars/Dzen2  ### --
myXmonadBar = "dzen2 -dock -x '0' -y '0' -h '18' -w '900' -ta 'l' -fg '#999999' -bg '#000000' -fn '-*-fixed-medium-*-*-*-12-*-*-*-*-*-iso8859-1'"
myTrayBar = "~/.xmonad/dzen/status_bars/dzen_secondary.sh | dzen2 -dock -x '900' -y '0' -h '18' -w '466' -ta 'r' -fg '#999999' -bg '#000000' -fn '-*-fixed-medium-*-*-*-12-*-*-*-*-*-iso8859-1'"
myStatusBar = "~/.xmonad/dzen/status_bars/dzen_main.sh | dzen2 -dock -x '0' -w '900' -y '750' -h '18' -fg '#999999' -bg '#000000' -ta 'l' -fn '-*-fixed-medium-*-*-*-12-*-*-*-*-*-iso8859-1'"
myMpdBar = "~/.xmonad/dzen/status_bars/dzen_audio.sh | dzen2 -dock -x '900' -w '466' -y '750' -h '18' -fg '#999999' -bg '#000000' -ta 'r' -fn '-*-fixed-medium-*-*-*-12-*-*-*-*-*-iso8859-1'"
myBitmapsDir = ".xmonad/dzen/icons"

-- ### Main ### --
main = do
    dzenLeftBar <- spawnPipe myXmonadBar
    dzenStatusBar <- spawnPipe myStatusBar
    dzenTrayBar <- spawnPipe myTrayBar
    dzenMpdBar <- spawnPipe myMpdBar
    xmonad $ docks def {
      terminal            = myTerminal
    , workspaces          = myWorkspaces
    , keys                = myKeys
    , modMask             = mymodMask
    , layoutHook          = myLayoutHook
    , manageHook          = manageSpawn <+> myManageHook
    , logHook             = myLogHook dzenLeftBar
    , normalBorderColor   = colorNormalBorder
    , focusedBorderColor  = colorFocusedBorder
    , borderWidth         = 0 
    , startupHook  = myStartupHook }

-- ### StartupHook ### --
myStartupHook :: X ()
myStartupHook = do
    setWMName "LG3D"
    spawn "feh --bg-tile /home/coke/Imágenes/Wallpapers/mr-ro.jpg"
    spawn "compton -cfb -D 1 -r 10 -l -15 -t -12 -o 0.6 -e 1.0 -i 1.0"
    spawn "xscreensaver -nosplash"
    spawn "xsetroot -cursor_name left_ptr"
    spawn "synergy-core --client --name cKlap --daemon --restart 192.168.1.2"
    spawn "ck-launch-session dbus-session --exit-with-session"
    spawn "setxkbmap es"
    spawn "dropbox start"
    spawn "~/.xmonad/dzen/status_checks/checker.sh"
    -- spawnOn "1:cKlap" "xfce4-terminal -T connman -e 'screen connman_ncurses' --tab -T alsa -e 'alsamixer --card=0' --tab -T ncmpcpp -x ncmpcpp"
    -- spawnOn "1:cKlap" "xfce4-terminal -x wicd-curses"
    spawnOn "2:www" "google-chrome-stable"
    spawnOn "4:file" "thunar /home/coke/"
    -- spawnOn "4:file" "thunar /"
    spawnOn "6:mayhem" "xfce4-terminal -e '/home/coke/.xmonad/waitcon.sh 2'"
    spawnOn "6:mayhem" "xfce4-terminal -e '/home/coke/.xmonad/waitcon.sh 3'"
    spawnOn "6:mayhem" "xfce4-terminal -e '/home/coke/.xmonad/waitcon.sh 4'"
    spawnOn "6:mayhem" "xfce4-terminal"
    spawnOn "8:com" "telegram-desktop"
    spawnOn "1:cKlap" "xfce4-terminal -T htop -e 'htop' --tab -T irssi -e '/home/coke/.xmonad/waitcon.sh 1'"
    -- #spawnOn "1:cKlap" "xfce4-terminal -T htop -x htop"
    spawnOn "1:cKlap" "xfce4-terminal -T ncmpcpp -e '/home/coke/.xmonad/music.sh'"
    spawnOn "1:cKlap" "xfce4-terminal -T connman -e 'screen wicd-curses' --tab -T audio -e 'alsamixer --card=0' --tab -T bash"

-- ### ManageHook ### --
myManageHook :: ManageHook
myManageHook = (composeAll . concat $
    [ [resource     =? r            --> doIgnore                |   r   <- myIgnores] -- ignore desktop
    , [className    =? c            --> doShift  "3:develop"    |   c   <- myDev    ] -- move myDev to dev
    , [className    =? c            --> doShift  "4:file"       |   c   <- myFiles  ] -- move myFiles to file
    , [className    =? c            --> doShift  "7:media"      |   c   <- myMedia  ] -- move myMedia to media
    , [className    =? c            --> doShift  "8:com"        |   c   <- myChat   ] -- move myChat  to com
    , [className    =? c            --> doShift  "5:virt"       |   c   <- myVBox   ] -- move myVBox  to virt
    , [className    =? c            --> doCenterFloat           |   c   <- myFloats ] -- float my floats
    , [name         =? n            --> doCenterFloat           |   n   <- myNames  ] -- float my names
    , [isFullscreen                 --> myDoFullFloat                           ]]) 
 
    where
 
        role      = stringProperty "WM_WINDOW_ROLE"
        name      = stringProperty "WM_NAME"
        -- classnames
        myTerms   = ["aterm","urxvt","terminator","xfce4-terminal"]
        myFloats  = ["vlc","gimp","VirtualBox","skype"]
        myWebs    = ["Firefox","google-chrome-stable"]
        myMedia   = ["Spotify","vlc","kodi"]
        myChat    = ["skype"]
        myFiles   = ["nautilus","thunar","mc"]
        myDev     = ["gvim","eclipse","ADT","emacs"]
        myVBox    = ["VirtualBox","Virtualbox-bin","vbox","qemu"]
        -- resources
        myIgnores = ["desktop","desktop_window","notify-osd","stalonetray","trayer"]
        -- names
        myNames   = ["bashrun","Google Chrome Options","Chromium Options"]

-- ### LogHook ### --
myLogHook :: Handle -> X ()
myLogHook h = dynamicLogWithPP $ defaultPP
    {
        ppCurrent           =   dzenColor "#00aa6c" "#000000" . wrap "^fg(#00aa6c)[^fg(#ffffff)" 
"^fg(#00aa6c)]"
      , ppVisible           =   dzenColor "#000000" "#00aa6c" . wrap "^fg(#ffffff)[^fg(#00aa6c)" 
"^fg(#ffffff)]"
      , ppHidden            =   dzenColor "#cccccc" "#000000" . pad
      , ppHiddenNoWindows   =   dzenColor "#999999" "#000000" . pad
      , ppUrgent            =   dzenColor "#ff0000" "#000000" . pad
      , ppWsSep             =   " "
      , ppSep               =   "·"
      , ppLayout            =   dzenColor "#00aa6c" "#000000" .
                                (\x -> case x of
                                    "Spacing 7 ResizableTall"             ->      "^i(" ++ myBitmapsDir ++ "/tall.xbm)"
                                    "Mirror Spacing 7 ResizableTall"      ->      "^i(" ++ myBitmapsDir ++ "/mtall.xbm)"
                                    "Full"                      ->      "^i(" ++ myBitmapsDir ++ "/full.xbm)"
                                    "Simple Float"              ->      "~"
                                    "IM Simple Float"           ->      "^i(" ++ myBitmapsDir ++ "/full.xbm)"
                                    "ReflectX Spacing 7 ResizableTall"    ->      "^i(" ++ myBitmapsDir ++ "/tall.xbm)"
                                    "Spacing 7 Grid"            ->      "^i(" ++ myBitmapsDir ++ "/full.xbm"
                                    _                           ->      x
                                )
      , ppTitle             =   (" " ++) . dzenColor "#00aa6c" "#000000" . dzenEscape
      , ppOutput            =   hPutStrLn h
    }

-- ### LayoutHook ### --
myLayoutHook  = onWorkspaces ["1:cKlap"] cKlapLayout $ 
                onWorkspaces ["2:www"] wwwLayout $
                onWorkspaces ["3:develop"] simpLayout $
                onWorkspaces ["4:files"] wwwLayout $
                onWorkspaces ["5:virt"] vBoxLayout $
                onWorkspaces ["6:mayhem"] netLayout $
                onWorkspaces ["7:media"] mediaLayout $
                onWorkspaces ["8:com"] chatLayout $
                simpLayout

-- ### Layouts ### --

cKlapLayout = avoidStruts $ tiled ||| Mirror tiled ||| noBorders Full ||| simpleFloat
 where
   tiled = spacing  7 $ ResizableTall 1 (2/100) (1.70/3) []

wwwLayout = avoidStruts $ tiled ||| Mirror tiled ||| noBorders Full ||| simpleFloat
  where
    tiled = spacing 7 $ ResizableTall 1 (2/100) (1/2) []
 
simpLayout = avoidStruts $ tiled ||| noBorders Full ||| Mirror tiled ||| simpleFloat
  where
    tiled = spacing 7 $ ResizableTall 1 (2/100) (1/2) []
 
vBoxLayout = avoidStruts $ noBorders simpleFloat
 
netLayout = avoidStruts $ smartBorders $ spacing 7 $ Grid ||| simpleFloat
    
mediaLayout = avoidStruts $ smartBorders $ reflectHoriz tiled
   where 
     tiled = spacing 7 $ ResizableTall 1 (2/100) (1/2) []

chatLayout = avoidStruts $ withIM (1%5) (And (ClassName "skype") (Role "buddy_list")) simpleFloat

-- ### Theme ### --
colorOrange         = "#83bbf4"
colorDarkGray       = "#1B1D1E"
colorPink           = "#F92672"
colorGreen          = "#A6E22E"
colorBlue           = "#66D9EF"
colorYellow         = "#E6DB74"
colorWhite          = "#CCCCC6"
colorNormalBorder   = "#CCCCCC"
colorFocusedBorder  = "#EEEEEE"
 
-- ### Fonts ### -- 
barFont  = "-*-fixed-*-*-*-*-8-*-*-*-*-*-iso8859-1"
barXFont = "fixed"
xftFont = "xft: fixed"

-- ### Prompt Config ### --
mXPConfig :: XPConfig
mXPConfig =
    defaultXPConfig { font                  = barFont
                    , bgColor               = colorDarkGray
                    , fgColor               = colorGreen
                    , bgHLight              = colorGreen
                    , fgHLight              = colorDarkGray
                    , promptBorderWidth     = 0
                    , height                = 12
                    , historyFilter         = deleteConsecutive
                    }
-- ### Run or Raise Menu ### --
largeXPConfig :: XPConfig
largeXPConfig = mXPConfig
                { font = xftFont
                , height = 12
                }
-- ### Trick for fullscreen switching windows ### --
myDoFullFloat :: ManageHook
myDoFullFloat = doF W.focusDown <+> doFullFloat


-- ### Key Bindings ### --
myKeys conf@(XConfig {XMonad.modMask = modMask}) = M.fromList $
    [ ((modMask,                    xK_w        ), spawn "ooffice")
    , ((modMask,                    xK_k        ), spawn $ XMonad.terminal conf)
    , ((modMask,                    xK_F2       ), spawn "sudo s2ram")
    , ((modMask,                    xK_F12      ), spawn "sudo halt")
    , ((modMask,                    xK_F11      ), spawn "sudo reboot")
    , ((modMask,                    xK_KP_Insert ), spawn "sudo /home/coke/.xmonad/mountswitch.sh")
    , ((modMask,                    xK_z    ), goToSelected defaultGSConfig)
    , ((modMask,                    xK_x    ), spawnSelected defaultGSConfig ["sudo halt","sudo reboot","sudo s2ram"])
    , ((modMask .|. shiftMask,      xK_c        ), kill)
    , ((modMask .|. shiftMask,      xK_l        ), spawn "xscreensaver-command -lock")
    
    , ((0,                          xK_Print    ), spawn "scrot $HOME/screenshots/`date +%d-%m-%Y_%H:%M:%S`.png -e 'xclip -selection clipboard -t image/png -i $f'")
    , ((modMask,                    xK_s        ), spawn "scrot -s $HOME/screenshots/`date +%d-%m-%Y_%H:%M:%S`.png -e 'xclip -selection clipboard -t image/png -i $f'")
    , ((modMask .|. shiftMask,      xK_s        ), spawn "scrot -u $HOME/screenshots/`date +%d-%m-%Y_%H:%M:%S`.png -e 'xclip -selection clipboard -t image/png -i $f'")
    , ((modMask,                    xK_c        ), spawn "google-chrome-stable")
    , ((modMask,                    xK_n        ), spawn "thunar")
    
    , ((0,                          0x1008ff12  ), spawn "amixer -c 0 sset Master toggle")        -- XF86AudioMute
    , ((0,                          0x1008ff11  ), spawn "amixer -c 0 sset Master 5%-")           -- XF86AudioLowerVolume
    , ((0,                          0x1008ff13  ), spawn "amixer -c 0 sset Master 5%+")  
    , ((0,                          0x1008ff14  ), spawn "mpc play")
    , ((0,                          0x1008ff15  ), spawn "mpc stop")
    , ((0,                          0x1008ff17  ), spawn "mpc next")
    , ((0,                          0x1008ff16  ), spawn "mpc prev")
    , ((modMask,                    xK_g        ), spawn "gimp")
    , ((modMask,                    xK_i        ), spawn "gedit --new-window") 
    , ((modMask,                    xK_v        ), spawn "VirtualBox")
    , ((modMask .|. controlMask,       xK_w        ), spawn "sudo wireshark")
    , ((modMask .|. shiftMask,      xK_w        ), spawn "sudo zenmap")
    , ((modMask,                    xK_o        ), spawn "/usr/bin/tor-browser_es-ES/start-tor-browser.desktop")
    , ((modMask .|. shiftMask,        xK_o        ), spawn "sudo /home/coke/.xmonad/torswitch.sh")
    , ((modMask .|. shiftMask,        xK_v        ), spawn "sudo /home/coke/.xmonad/vpnswitch.sh")
    , ((modMask .|. shiftMask,        xK_n        ), spawn "sudo /home/coke/.xmonad/natswitch.sh")
    , ((modMask .|. shiftMask,        xK_h        ), spawn "sudo /home/coke/.xmonad/hostapdswitch.sh")
    , ((modMask,        xK_KP_Insert        ), spawn "/home/coke/.xmonad/audioswitch.sh")
    , ((modMask,        xK_KP_Left          ), spawn "VBoxManage startvm 'CentOS 6.8 Sint'")
    , ((modMask,        xK_KP_Page_Down     ), spawn "VBoxManage startvm 'Aderall'")
    , ((modMask,        xK_KP_Down     ), spawn "VBoxManage startvm 'Stratera'")
    , ((modMask,        xK_KP_End     ), spawn "VBoxManage startvm 'Windows 10'")
    , ((modMask,                    xK_m        ), spawn "vlc")
    , ((modMask .|. shiftMask,      xK_m        ), spawn "kodi")
    , ((modMask,                    xK_d        ), spawn "deluge-gtk")
    , ((modMask,                    xK_e        ), spawn "eclipse-bin-4.6")
    , ((modMask .|. shiftMask,      xK_e        ), spawn "emacs")
    , ((modMask,                    xK_a        ), spawn "atom")
    , ((modMask,                    xK_space    ), sendMessage NextLayout)
    , ((modMask .|. shiftMask,      xK_space    ), setLayout $ XMonad.layoutHook conf)          -- reset layout on current desktop to default
    , ((modMask,                    xK_b        ), sendMessage ToggleStruts)
    , ((modMask,                    xK_r        ), spawn "gmrun")
    , ((modMask,                    xK_Tab      ), windows W.focusDown)                         -- move focus to next window
    , ((modMask .|. shiftMask,      xK_j        ), windows W.focusDown)
    , ((modMask .|. shiftMask,      xK_k        ), windows W.focusUp  )
    , ((modMask .|. shiftMask,      xK_Down        ), windows W.swapDown)                          -- swap the focused window with the next window
    , ((modMask .|. shiftMask,      xK_Up        ), windows W.swapUp)                            -- swap the focused window with the previous window
    , ((modMask,                    xK_Return   ), windows W.swapMaster)
    , ((modMask,                    xK_t        ), withFocused $ windows . W.sink)              -- Push window back into tiling
    , ((modMask,                    xK_h        ), sendMessage Shrink)                          -- %! Shrink a master area
    , ((modMask,                    xK_l        ), sendMessage Expand)                          -- %! Expand a master area
    , ((modMask,                    xK_comma    ), sendMessage (IncMasterN 1))
    , ((modMask,                    xK_period   ), sendMessage (IncMasterN (-1)))
 
    -- workspaces
    , ((modMask .|. controlMask,   xK_Right     ), nextWS)
    , ((modMask .|. shiftMask,     xK_Right     ), shiftToNext)
    , ((modMask .|. controlMask,   xK_Left      ), prevWS)
    , ((modMask .|. shiftMask,     xK_Left      ), shiftToPrev)
 
    -- quit, or restart
    , ((modMask .|. shiftMask,      xK_q        ), io (exitWith ExitSuccess))
    , ((modMask,                    xK_q        ), spawn "killall dzen2 && killall -TERM irssi && ~/.xmonad/reload.sh")
    ]
    ++
    -- mod-[1..9] %! Switch to workspace N
    -- mod-shift-[1..9] %! Move client to workspace N
    [((m .|. modMask, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    
    -- ++
    --
    -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
    --
    -- [((m .|. modMask, key), screenWorkspace sc >>= flip whenJust (windows . f))
    --    | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
    --    , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]
 
-- ###### End Config ###### --
