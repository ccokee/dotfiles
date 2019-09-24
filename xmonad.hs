-- ###### Imports ###### --
-- ### Xmonad ### --
--{-# LANGUAGE NoMonomorphismRestriction #-}
import XMonad
import XMonad.Util.Run 
import XMonad.Util.EZConfig (additionalMouseBindings)
import XMonad.Actions.CycleWS
import XMonad.Actions.SpawnOn
import XMonad.Actions.GridSelect
import XMonad.Actions.MouseGestures
import XMonad.Actions.SwapWorkspaces
import XMonad.Actions.WorkspaceNames
import XMonad.Actions.CopyWindow
import XMonad.Actions.WithAll
import XMonad.Actions.WindowGo
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
greenColorizer = colorRangeFromClassName
                     black            -- lowest inactive bg
                     (0x70,0xFF,0x70) -- highest inactive bg
                     black            -- active bg
                     white            -- inactive fg
                     white            -- active fg
  where black = minBound
        white = maxBound
                     
--spawnConf colorizer = (buildDefaultGSConfig greenColorizer) {gs_cellheight =30, gs_cellwidth = 100}
   
--conf = spawnConf greenColorizer

spawnSelected' :: [(String, String)] -> X ()
spawnSelected' lst = gridselect conf lst >>= flip whenJust spawn
 --   where conf = spawnConf greenColorizer
  where conf = defaultGSConfig 
-- ### Terminal ### --
myTerminal = "xfce4-terminal"

-- ### modMask ### -- 
mymodMask :: KeyMask
mymodMask = mod4Mask

-- ### Workspaces ### --
myWorkspaces = ["cKlap","www","dev","com","file","net","vm","media"]

-- ### Bars/Dzen2  ### --
myXmonadBar = "dzen2 -dock -x '0' -y '0' -h '18' -w '900' -ta 'l' -fg '#999999' -bg '#000000' -fn '-*-fixed-medium-*-*-*-12-*-*-*-*-*-iso8859-1' -e 'button2=;'"
myTrayBar = "~/.xmonad/dzen/status_bars/dzen_secondary.sh | dzen2 -dock -x '900' -y '0' -h '18' -w '466' -ta 'r' -fg '#999999' -bg '#000000' -fn '-*-fixed-medium-*-*-*-12-*-*-*-*-*-iso8859-1' -e 'button2=;'"
myStatusBar = "~/.xmonad/dzen/status_bars/dzen_main.sh | dzen2 -dock -x '0' -w '866' -y '750' -h '18' -fg '#999999' -bg '#000000' -ta 'l' -fn '-*-fixed-medium-*-*-*-12-*-*-*-*-*-iso8859-1' -e 'button2=;'"
myMpdBar = "~/.xmonad/dzen/status_bars/dzen_audio.sh | dzen2 -dock -x '866' -w '500' -y '750' -h '18' -fg '#999999' -bg '#000000' -ta 'r' -fn '-*-fixed-medium-*-*-*-12-*-*-*-*-*-iso8859-1' -e 'button2=;'"
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
    , startupHook  = myStartupHook } `additionalMouseBindings` myMouse

-- ### StartupHook ### --
myStartupHook :: X ()
myStartupHook = do
    setWMName "LG3D"
    spawn "feh --bg-scale /home/coke/Imágenes/Wallpapers/mr-ro4k.jpg"
    spawn "compton -cfb -D 1 -r 10 -l -15 -t -12 -o 0.6 -e 1.0 -i 1.0"
    spawn "setxkbmap es"
    spawn "xscreensaver -nosplash"
    spawn "xsetroot -cursor_name left_ptr"
    spawn "synergy-core --client --name cKlap --daemon --restart 192.168.1.2"
    spawn "ck-launch-session dbus-session --exit-with-session"
    spawn "dropbox start"
    spawn "npm run start --prefix /home/coke/git/Odrive"
    spawn "~/.xmonad/dzen/status_checks/checker.sh"
    spawnOn "www" "google-chrome-stable -restore-last-session"
    spawnOn "file" "thunar /home/coke/"
    spawnOn "file" "thunar /"
    spawnOn "net" "xfce4-terminal -e '/home/coke/.xmonad/waitcon.sh 2'"
    spawnOn "net" "xfce4-terminal -e '/home/coke/.xmonad/waitcon.sh 3'"
    spawnOn "net" "xfce4-terminal -e '/home/coke/.xmonad/waitcon.sh 4'"
    spawnOn "net" "xfce4-terminal -e '/home/coke/.xmonad/waitcon.sh 5'"
    spawnOn "net" "xfce4-terminal"
    spawnOn "com" "/home/coke/git/station/AppRun"
    spawnOn "com" "telegram-desktop"
    --spawnOn "com" "skypeforlinux"
    spawnOn "cKlap" "xfce4-terminal -T Proc -e 'gotop' --tab -T bitchX -e '/home/coke/.xmonad/waitcon.sh 1'"
    -- #spawnOn "cKlap" "xfce4-terminal -T htop -x htop"
    spawnOn "cKlap" "xfce4-terminal -T net -e 'screen wicd-curses' --tab -T audio -e 'alsamixer --card=0' --tab -T 'headset' -e 'alsamixer -D bluealsa' --tab -T ncmpcpp -e '/home/coke/.xmonad/music.sh'"
    spawnOn "cKlap" "xfce4-terminal -T cKterm"

-- ### ManageHook ### --
myManageHook :: ManageHook
myManageHook = (composeAll . concat $
    [ [resource     =? r            --> doIgnore                |   r   <- myIgnores] -- ignore desktop
    , [className    =? c            --> doShift  "dev"    |   c   <- myDev    ] -- move myDev to dev
    , [className    =? c            --> doShift  "file"       |   c   <- myFiles  ] -- move myFiles to file
    , [className    =? c            --> doShift  "media"      |   c   <- myMedia  ] -- move myMedia to media
    , [className    =? c            --> doShift  "com"        |   c   <- myChat   ] -- move myChat  to com
    , [className    =? c            --> doShift  "vm"       |   c   <- myVBox   ] -- move myVBox  to virt
    , [className    =? c            --> doCenterFloat           |   c   <- myFloats ] -- float my floats
    , [name         =? n            --> doCenterFloat           |   n   <- myNames  ] -- float my names
    , [isFullscreen                 --> myDoFullFloat                           ]]) 
 
    where
 
        role      = stringProperty "WM_WINDOW_ROLE"
        name      = stringProperty "WM_NAME"
        -- classnames
        myTerms   = ["aterm","urxvt","terminator","xfce4-terminal"]
        myFloats  = ["vlc","gimp","VirtualBox","skype"]
        myWebs    = ["Firefox","google-chrome","chrome"]
        myMedia   = ["Spotify","vlc","VLC","kodi","Kodi"]
        myChat    = ["skype"]
        myFiles   = ["nautilus","Thunar","thunar","mc"]
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
      , ppVisible           =   dzenColor "#00aa6c" "#000000" . wrap "^fg(#ffffff)[^fg(#00aa6c)" 
"^fg(#ffffff)]"
      , ppHidden            =   dzenColor "#cccccc" "#000000" . pad
      , ppHiddenNoWindows   =   dzenColor "#999999" "#000000" . pad
      , ppUrgent            =   dzenColor "#ff0000" "#000000" . pad
      , ppWsSep             =   " "
      , ppSep               =   " · "
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
myLayoutHook  = onWorkspaces ["cKlap"] cKlapLayout $ 
                onWorkspaces ["web"] wwwLayout $
                onWorkspaces ["dev"] simpLayout $
                onWorkspaces ["com"] chatLayout $
                onWorkspaces ["file"] simpLayout $
                onWorkspaces ["net"] netLayout $
                onWorkspaces ["vm"] vBoxLayout $
                onWorkspaces ["media"] mediaLayout $
                simpLayout

-- ### Layouts ### --

cKlapLayout = avoidStruts $ tiled ||| Mirror tiled ||| noBorders Full ||| simpleFloat
 where
   tiled = spacing  4 $ ResizableTall 1 (2/100) (1.70/3) []

wwwLayout = avoidStruts $ tiled ||| noBorders Full ||| Mirror tiled ||| simpleFloat
  where
    tiled = spacing 4 $ ResizableTall 1 (2/100) (1/2) []
 
simpLayout = avoidStruts $ tiled ||| noBorders Full ||| Mirror tiled ||| simpleFloat
  where
    tiled = spacing 4 $ ResizableTall 1 (2/100) (1/2) []
 
vBoxLayout = avoidStruts $ noBorders simpleFloat ||| noBorders Full
 
netLayout = avoidStruts $ smartBorders $ spacing 4 $ Grid ||| simpleFloat
    
mediaLayout = avoidStruts $ smartBorders $ reflectHoriz Full

chatLayout = avoidStruts $ noBorders Full

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


myKeys conf@(XConfig {XMonad.modMask = modMask}) = M.fromList $
    [ ((modMask,                    xK_w        ), spawn "ooffice")
    , ((modMask,                    xK_k        ), spawn $ XMonad.terminal conf)
    , ((modMask .|. controlMask,    xK_k        ), runOrRaise "xfce4-terminal" (className =? "xfce4-terminal"))
    , ((modMask,                    xK_F2       ), spawn "xscreensaver-command -lock && sudo s2ram")
    , ((modMask,                    xK_F12      ), spawn "sudo halt")
    , ((modMask,                    xK_F11      ), spawn "sudo reboot")
    , ((modMask,                    xK_KP_Insert ), spawn "sudo /home/coke/.xmonad/mountswitch.sh")
    , ((modMask,                    xK_z    ), goToSelected defaultGSConfig)
    , ((modMask,                    xK_x    ), spawnSelected' [("Halt","sudo halt"),("Reboot","sudo reboot"),("Suspend","xscreensaver-command -lock && sudo s2ram"),("Exit","")])
    , ((modMask .|. shiftMask,      xK_c        ), spawn "firefox")
    , ((modMask .|. shiftMask,      xK_l        ), spawn "xscreensaver-command -lock")
    
    , ((0,                          xK_Print    ), spawn "scrot $HOME/screenshots/`date +%d-%m-%Y_%H:%M:%S`.png -e 'xclip -selection clipboard -t image/png -i $f'")
    , ((modMask .|. controlMask,    xK_s        ), spawn "sleep 0.5; scrot -s $HOME/screenshots/`date +%d-%m-%Y_%H:%M:%S`.png -e 'xclip -selection clipboard -t image/png -i $f'")
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
    , ((modMask .|. shiftMask,      xK_v        ), spawn "VirtualBox")
    , ((modMask .|. shiftMask,      xK_w        ), spawn "sudo wireshark")
    , ((modMask .|. controlMask,    xK_w        ), spawn "sudo zenmap")
    , ((modMask,                    xK_o        ), spawn "~/tor-browser_es-ES/Browser/start-tor-browser")
    , ((modMask,                    xK_r    ), spawnSelected'                 [("cKdesk",     "xfce4-terminal -e '/home/coke/.xmonad/waitcon.sh 2'")
                                                                              ,("cKpi",       "xfce4-terminal -e '/home/coke/.xmonad/waitcon.sh 3'")
                                                                              ,("cKws",       "xfce4-terminal -e '/home/coke/.xmonad/waitcon.sh 4'")
                                                                              ,("cKvpn",      "xfce4-terminal -e '/home/coke/.xmonad/waitcon.sh 5'")
                                                                              ,("cKsas",      "xfce4-terminal -e '/home/coke/.xmonad/waitcon.sh 6'")
                                                                              ,("cKboard",    "xfce4-terminal -e '/home/coke/.xmonad/waitcon.sh 7'")
                                                                              ,("tun0",       "xfce4-terminal -e '/home/coke/.xmonad/waitcon.sh 8'")
                                                                              ,("tun1",       "xfce4-terminal -e '/home/coke/.xmonad/waitcon.sh 9'")
                                                                              ,("Exit",           "")
                                                                              ])
    , ((modMask .|. shiftMask,      xK_r    ), spawnSelected'                 [("desk.wol",        "xfce4-terminal -e '/home/coke/.xmonad/wol.sh'")
                                                                              ,("desk.vnc",        "xfce4-terminal -e '/home/coke/.xmonad/vnc-conn.sh'")
                                                                              ,("vpn.wol",         "xfce4-terminal -e '/home/coke/.xmonad/wol.sh 2'")
                                                                              ,("vpn.route",       "xfce4-terminal -e '/home/coke/.xmonad/routeswitch.sh'")
                                                                              ,("nas.plex",        "google-chrome-stable 'http://doctorbit.sytes.net:8002'")
                                                                              ,("nas.deluge",      "google-chrome-stable 'http://doctorbit.sytes.net:8112'")
                                                                              ,("net.monitor",     "google-chrome-stable 'http://doctorbit.sytes.net:8030'")
                                                                              ,("dns.webui",       "google-chrome-stable 'http://doctorbit.sytes.net:8005'")
                                                                              ,("kodi.remote",     "google-chorme-stable 'http://doctorbit.sytes.net:8004'")
                                                                              ,("Panic Button!",   "google-chrome-stable 'http://doctorbit.sytes.net:8020'")
                                                                              ,("Exit",           "")
                                                                              ])
    , ((modMask,                    xK_v    ), spawnSelected' [("Windows 10",     "VBoxManage startvm 'Windows 10'")
                                                                              ,("Aderall",        "VBoxManage startvm 'Aderall'")
                                                                              ,("Stratera",       "VBoxManage startvm 'Stratera'")
                                                                              ,("Exit",           "")
                                                                              ])
    , ((modMask,                    xK_s    ), spawnSelected' [("Vpn",           "sudo /home/coke/.xmonad/vpnswitch.sh")
                                                                              ,("Tor",           "sudo /home/coke/.xmonad/torswitch.sh")
                                                                              ,("Nat forward",   "sudo /home/coke/.xmonad/natswitch.sh")
                                                                              ,("Host AP",       "sudo /home/coke/.xmonad/hostapdswitch.sh")
                                                                              ,("VNC Desk",      "/home/coke/.xmonad/vnc-conn.sh")
                                                                              ,("Exit",           "")
                                                                              ])
    , ((modMask,                    xK_a    ), spawnSelected' [("Headphones",    "sudo /home/coke/.xmonad/audioswitch.sh")
                                                                              ,("Speakers",      "sudo /home/coke/.xmonad/torswitch.sh")
                                                                              ,("H & S",         "sudo /home/coke/.xmonad/natswitch.sh")
                                                                              ,("Mute all",      "sudo /home/coke/.xmonad/hostapdswitch.sh")
                                                                              ,("Exit",           "")
                                                                              ])
    , ((modMask,        xK_KP_Insert        ), spawn "/home/coke/.xmonad/audioswitch.sh")
    , ((modMask,                    xK_m        ), spawn "vlc")
    , ((modMask .|. shiftMask,      xK_m        ), spawn "kodi")
    , ((modMask,                    xK_e        ), spawn "visual-studio-code")
    , ((modMask .|. shiftMask,      xK_e        ), spawn "gedit --new-window") 
    , ((modMask .|. controlMask,       xK_e        ), spawn "eclipse-bin-4.6")
    , ((modMask,                    xK_space    ), sendMessage NextLayout)
    , ((modMask .|. shiftMask,      xK_space    ), setLayout $ XMonad.layoutHook conf)          -- reset layout on current desktop to default
    , ((modMask,                    xK_b        ), sendMessage ToggleStruts)
    , ((modMask .|. mod1Mask,       xK_r        ), spawn "gmrun")
    , ((modMask,                    xK_Tab      ), windows W.focusDown)                       
    -- , ((modMask .|. shiftMask,      xK_j        ), windows W.focusDown)
    -- , ((modMask .|. shiftMask,      xK_k        ), windows W.focusUp  )
    , ((modMask .|. shiftMask,      xK_k        ), kill)
    , ((modMask .|. mod1Mask,       xK_k	), kill1)
    , ((modMask .|. mod1Mask .|. shiftMask,       xK_k        ), killAllOtherCopies)
    , ((modMask .|. shiftMask,      xK_Down        ), windows W.swapDown)                          -- swap the focused window with the next window
    , ((modMask .|. shiftMask,      xK_Up        ), windows W.swapUp)                            -- swap the focused window with the previous window
    , ((modMask,                    xK_Return   ), windows W.swapMaster)
    , ((modMask .|. controlMask,    xK_t        ), sinkAll)
    , ((modMask,                    xK_t        ), withFocused $ windows . W.sink)              -- Push window back into tiling
    , ((modMask,                    xK_h        ), sendMessage Shrink)                          -- %! Shrink a master area
    , ((modMask,                    xK_l        ), sendMessage Expand)                          -- %! Expand a master area
    , ((modMask,                    xK_comma    ), sendMessage (IncMasterN 1))
    , ((modMask,                    xK_period   ), sendMessage (IncMasterN (-1)))
 
    -- workspaces
    , ((modMask,                    xK_Right     ), nextWS)
    , ((modMask .|. shiftMask,      xK_Right     ), shiftToNext)
    , ((modMask,                    xK_Left      ), prevWS)
    , ((modMask .|. shiftMask,      xK_Left      ), shiftToPrev)
 
    -- quit, or restart
    , ((modMask .|. shiftMask,      xK_q        ), io (exitWith ExitSuccess))
    , ((modMask,                    xK_q        ), spawn "killall dzen2 && ~/.xmonad/reload.sh")
    ]
    ++
    [((m .|. modMask, k), windows $ f i)
    | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
    , (f, m) <- [(W.view, 0), (W.shift, shiftMask), (copy, shiftMask .|. mod1Mask)]]
    ++
    [((modMask .|. mod1Mask, k), windows $ XMonad.Actions.SwapWorkspaces.swapWithCurrent i)
    | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]]
    -- ++
    --
    -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
    --
    -- [((m .|. modMask, key), screenWorkspace sc >>= flip whenJust (windows . f))
    --    | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
    --    , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]
myMouse = 
    [ ((mod4Mask .|. mod1Mask, button4), (\_ -> XMonad.Actions.WorkspaceNames.swapTo Next))
    , ((mod4Mask, button4), (\_ -> nextWS))
    , ((mod4Mask .|. mod1Mask, button5), (\_ -> XMonad.Actions.WorkspaceNames.swapTo Prev))
    , ((mod4Mask, button5), (\_ -> prevWS ))
    , ((mod1Mask, button2), (\_ -> spawnOn "8:com" "xfce4-terminal -T VoIP -e 'baresip -f ~/git/baresip/'"))
    ]
-- ###### End Config ###### ---

