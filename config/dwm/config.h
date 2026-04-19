/* See LICENSE file for copyright and license details. */

/* appearance - i3bar style */
static const unsigned int borderpx = 1; /* border pixel of windows */
static const unsigned int snap = 32;    /* snap pixel */
static const int showbar = 1;           /* 0 means no bar */
static const int topbar = 0;            /* 0 means bottom bar */
static const float baralpha = 1.0;      /* bar transparency (i3bar is opaque) */
static const int barpadding = 1;        /* extra padding (like i3 bar ~19px) */
/* i3bar default font: DejaVu Sans Mono 10 */
static const char *fonts[] = {"DejaVu Sans Mono:size=8"};
static const char dmenufont[] = "DejaVu Sans Mono:size=8";
/* i3bar default colors */
static const char col_bg[]       = "#000000";  /* bar background (i3bar default) */
static const char col_fg[]       = "#ceecee";  /* statusline / text (i3bar default) */
static const char col_border[]   = "#000000";  /* border matches background */
static const char col_sel_bg[]   = "#285577";  /* focused workspace (i3 default blue) */
static const char col_sel_fg[]   = "#ffffff";  /* focused workspace text */
static const char col_cyan[]     = "#285577";  /* accent / separator tone */
/* i3bar-style status: green = available, red = unavailable */
static const char col_good[]     = "#00ff00";  /* available (IPv4, IPv6, WiFi, E) */
static const char col_bad[]      = "#ff0000";  /* unavailable */
static const char *colors[][3] = {
    /*               fg         bg         border   */
    [SchemeNorm] = {col_fg, col_bg, col_border},
    [SchemeSel]  = {col_sel_fg, col_sel_bg, col_cyan},
    [SchemeGood] = {col_good, col_bg, col_border},
    [SchemeBad]  = {col_bad, col_bg, col_border},
};

/* tagging */
static const char *tags[] = {"1", "2", "3", "4", "5", "6", "7", "8", "9"};

static const Rule rules[] = {
    /* xprop(1):
     *	WM_CLASS(STRING) = instance, class
     *	WM_NAME(STRING) = title
     */
    /* class      instance    title       tags mask     isfloating   monitor */
    {"Gimp", NULL, NULL, 0, 1, -1},
    {"Firefox", NULL, NULL, 1 << 8, 0, -1},
};

/* layout(s) */
static const float mfact = 0.55; /* factor of master area size [0.05..0.95] */
static const int nmaster = 1;    /* number of clients in master area */
static const int resizehints =
    1; /* 1 means respect size hints in tiled resizals */
static const int lockfullscreen =
    1; /* 1 will force focus on the fullscreen window */

static const Layout layouts[] = {
    /* symbol     arrange function */
    {"[]=", tile}, /* first entry is default */
    {"><>", NULL}, /* no layout function means floating behavior */
    {"[M]", monocle},
};

/* key definitions */
#define MODKEY Mod1Mask
#define TAGKEYS(KEY, TAG)                                                      \
  {MODKEY, KEY, view, {.ui = 1 << TAG}},                                       \
      {MODKEY | ControlMask, KEY, toggleview, {.ui = 1 << TAG}},               \
      {MODKEY | ShiftMask, KEY, tag, {.ui = 1 << TAG}},                        \
      {MODKEY | ControlMask | ShiftMask, KEY, toggletag, {.ui = 1 << TAG}},

/* helper for spawning shell commands in the pre dwm-5.0 fashion */
#define SHCMD(cmd)                                                             \
  {                                                                            \
    .v = (const char *[]) { "/bin/sh", "-c", cmd, NULL }                       \
  }

/* commands */
static char dmenumon[2] =
    "0"; /* component of dmenucmd, manipulated in spawn() */
static const char *dmenucmd[] = {
    "dmenu_run", "-b", "-m", dmenumon, "-fn", dmenufont,
    "-nb", col_bg,           /* normal background */
    "-nf", col_fg,           /* normal foreground */
    "-sb", col_sel_bg,       /* selected background */
    "-sf", col_sel_fg,       /* selected foreground */
    NULL};
static const char *termcmd[] = {
    "st", "-e", "sh", "-c", "tmux attach || tmux new", NULL};
static const char *increaseVolume[] = {"amixer", "-D",     "pulse",
                                       "sset",   "Master", "10%+"};
static const char *decreaseVolume[] = {"amixer", "-D",     "pulse",
                                       "sset",   "Master", "10%-"};
static const char *increaseBrightness[] = {"/usr/bin/brightnessctl", "-d",
                                           "intel_backlight", "set", "10%+"};
static const char *decreaseBrightness[] = {"/usr/bin/brightnessctl", "-d",
                                           "intel_backlight", "set", "10%-"};

static const Key keys[] = {
    /* modifier                     key        function        argument */
    {MODKEY, XK_p, spawn, {.v = dmenucmd}},
    {MODKEY | ShiftMask, XK_Return, spawn, {.v = termcmd}},
    {MODKEY, XK_F12, spawn, {.v = increaseVolume}},
    {MODKEY, XK_F11, spawn, {.v = decreaseVolume}},
    {MODKEY | ShiftMask, XK_F12, spawn, {.v = increaseBrightness}},
    {MODKEY | ShiftMask, XK_F11, spawn, {.v = decreaseBrightness}},
    {0, XK_Print, spawn, SHCMD("/usr/local/bin/shotclip")},
    {MODKEY, XK_w, spawn,
     SHCMD("/home/xentixar/.config/dwm/scripts/wg-quick-dmenu.sh up")},
    {MODKEY | ShiftMask, XK_w, spawn,
     SHCMD("/home/xentixar/.config/dwm/scripts/wg-quick-dmenu.sh down")},
    {MODKEY, XK_b, togglebar, {0}},
    {MODKEY, XK_j, focusstack, {.i = +1}},
    {MODKEY, XK_k, focusstack, {.i = -1}},
    {MODKEY, XK_i, incnmaster, {.i = +1}},
    {MODKEY, XK_d, incnmaster, {.i = -1}},
    {MODKEY, XK_h, setmfact, {.f = -0.05}},
    {MODKEY, XK_l, setmfact, {.f = +0.05}},
    {MODKEY, XK_Return, zoom, {0}},
    {MODKEY, XK_Tab, view, {0}},
    {MODKEY | ShiftMask, XK_c, killclient, {0}},
    {MODKEY, XK_t, setlayout, {.v = &layouts[0]}},
    {MODKEY, XK_f, setlayout, {.v = &layouts[1]}},
    {MODKEY, XK_m, setlayout, {.v = &layouts[2]}},
    {MODKEY, XK_space, setlayout, {0}},
    {MODKEY | ShiftMask, XK_space, togglefloating, {0}},
    {MODKEY, XK_0, view, {.ui = ~0}},
    {MODKEY | ShiftMask, XK_0, tag, {.ui = ~0}},
    {MODKEY, XK_comma, focusmon, {.i = -1}},
    {MODKEY, XK_period, focusmon, {.i = +1}},
    {MODKEY | ShiftMask, XK_comma, tagmon, {.i = -1}},
    {MODKEY | ShiftMask, XK_period, tagmon, {.i = +1}},
    TAGKEYS(XK_1, 0) TAGKEYS(XK_2, 1) TAGKEYS(XK_3, 2) TAGKEYS(XK_4, 3)
        TAGKEYS(XK_5, 4) TAGKEYS(XK_6, 5) TAGKEYS(XK_7, 6) TAGKEYS(XK_8, 7)
            TAGKEYS(XK_9, 8){MODKEY | ShiftMask, XK_q, quit, {0}},
};

/* button definitions */
/* click can be ClkTagBar, ClkLtSymbol, ClkStatusText, ClkWinTitle,
 * ClkClientWin, or ClkRootWin */
static const Button buttons[] = {
    /* click                event mask      button          function argument */
    {ClkLtSymbol, 0, Button1, setlayout, {0}},
    {ClkLtSymbol, 0, Button3, setlayout, {.v = &layouts[2]}},
    {ClkWinTitle, 0, Button2, zoom, {0}},
    {ClkStatusText, 0, Button2, spawn, {.v = termcmd}},
    {ClkClientWin, MODKEY, Button1, movemouse, {0}},
    {ClkClientWin, MODKEY, Button2, togglefloating, {0}},
    {ClkClientWin, MODKEY, Button3, resizemouse, {0}},
    {ClkTagBar, 0, Button1, view, {0}},
    {ClkTagBar, 0, Button3, toggleview, {0}},
    {ClkTagBar, MODKEY, Button1, tag, {0}},
    {ClkTagBar, MODKEY, Button3, toggletag, {0}},
};
