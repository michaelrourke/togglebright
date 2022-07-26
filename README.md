# togglebright
Toggle screen brightness a few seconds after each macOS system wakeup.

This is a workaround to the problem of screen brightness being increased after wakeup 
(seen with an LG Ultrafine monitor with MacOS 12.3, 12.4, 12.5 on Mac Studio).

Build with Xcode.

Start when logging on (via Users & Groups/Login Items), togglebright forks and puts itself into the background. Restarting kills old instances.
