{
  "patcher": {
    "fileversion": 1,
    "appversion": {
      "major": 8,
      "minor": 6,
      "revision": 5,
      "architecture": "x64",
      "modernui": 1
    },
    "classnamespace": "box",
    "rect": [
      60,
      60,
      1120,
      750
    ],
    "default_fontsize": 12,
    "default_fontname": "Arial",
    "boxes": [
      {
        "box": {
          "id": "panel",
          "maxclass": "jsui",
          "patching_rect": [
            0,
            0,
            1120,
            750
          ],
          "presentation": 1,
          "presentation_rect": [
            0,
            0,
            1120,
            750
          ],
          "filename": "aurora_ui.js",
          "jsarguments": [
            "#0-source"
          ],
          "numinlets": 1,
          "numoutlets": 2,
          "outlettype": [
            "",
            ""
          ],
          "border": 0,
          "varname": "panel"
        }
      },
      {
        "box": {
          "id": "engine",
          "maxclass": "newobj",
          "patching_rect": [
            30,
            840,
            190,
            22
          ],
          "numinlets": 1,
          "numoutlets": 4,
          "outlettype": [
            "signal",
            "signal",
            "signal",
            "signal"
          ],
          "text": "gen~ aurora_engine_v2"
        }
      },
      {
        "box": {
          "id": "source",
          "maxclass": "newobj",
          "patching_rect": [
            300,
            840,
            265,
            22
          ],
          "numinlets": 1,
          "numoutlets": 2,
          "outlettype": [
            "float",
            "bang"
          ],
          "text": "buffer~ #0-source AURORA_Source.wav"
        }
      },
      {
        "box": {
          "id": "loaded",
          "maxclass": "message",
          "patching_rect": [
            300,
            880,
            60,
            22
          ],
          "text": "loaded"
        }
      },
      {
        "box": {
          "id": "commands",
          "maxclass": "newobj",
          "patching_rect": [
            30,
            780,
            540,
            22
          ],
          "numinlets": 1,
          "numoutlets": 8,
          "outlettype": [
            "",
            "",
            "",
            "",
            "",
            "",
            "",
            ""
          ],
          "text": "route audio load demo save recall recopen recstop"
        }
      },
      {
        "box": {
          "id": "limiter",
          "maxclass": "newobj",
          "patching_rect": [
            30,
            970,
            430,
            22
          ],
          "numinlets": 2,
          "numoutlets": 2,
          "outlettype": [
            "signal",
            "signal"
          ],
          "text": "limi~ 2 @threshold -1. @lookahead 128 @release 100 @dcblock 1"
        }
      },
      {
        "box": {
          "id": "dac",
          "maxclass": "newobj",
          "patching_rect": [
            30,
            1100,
            45,
            45
          ],
          "numinlets": 2,
          "numoutlets": 0,
          "text": "ezdac~"
        }
      },
      {
        "box": {
          "id": "replace",
          "maxclass": "message",
          "patching_rect": [
            610,
            840,
            70,
            22
          ],
          "text": "replace"
        }
      },
      {
        "box": {
          "id": "demo",
          "maxclass": "message",
          "patching_rect": [
            610,
            880,
            210,
            22
          ],
          "text": "replace AURORA_Source.wav"
        }
      },
      {
        "box": {
          "id": "bind",
          "maxclass": "newobj",
          "patching_rect": [
            30,
            900,
            195,
            22
          ],
          "text": "loadmess source #0-source"
        }
      },
      {
        "box": {
          "id": "init",
          "maxclass": "newobj",
          "patching_rect": [
            850,
            790,
            70,
            22
          ],
          "text": "loadbang"
        }
      },
      {
        "box": {
          "id": "defer",
          "maxclass": "newobj",
          "patching_rect": [
            850,
            830,
            70,
            22
          ],
          "text": "deferlow"
        }
      },
      {
        "box": {
          "id": "initmsg",
          "maxclass": "message",
          "patching_rect": [
            850,
            870,
            70,
            22
          ],
          "text": "loadbang"
        }
      },
      {
        "box": {
          "id": "dspstate",
          "maxclass": "newobj",
          "patching_rect": [
            600,
            950,
            75,
            22
          ],
          "numinlets": 1,
          "numoutlets": 4,
          "outlettype": [
            "int",
            "float",
            "int",
            "int"
          ],
          "text": "dspstate~"
        }
      },
      {
        "box": {
          "id": "dspmsg",
          "maxclass": "newobj",
          "patching_rect": [
            600,
            990,
            110,
            22
          ],
          "text": "prepend dspstate"
        }
      },
      {
        "box": {
          "id": "cursorsnap",
          "maxclass": "newobj",
          "patching_rect": [
            30,
            930,
            100,
            22
          ],
          "text": "snapshot~ 50"
        }
      },
      {
        "box": {
          "id": "cursormsg",
          "maxclass": "newobj",
          "patching_rect": [
            980,
            930,
            110,
            22
          ],
          "text": "prepend cursor"
        }
      },
      {
        "box": {
          "id": "voicessnap",
          "maxclass": "newobj",
          "patching_rect": [
            220,
            930,
            100,
            22
          ],
          "text": "snapshot~ 50"
        }
      },
      {
        "box": {
          "id": "voicesmsg",
          "maxclass": "newobj",
          "patching_rect": [
            1170,
            930,
            110,
            22
          ],
          "text": "prepend voices"
        }
      },
      {
        "box": {
          "id": "peak0",
          "maxclass": "newobj",
          "patching_rect": [
            300,
            1020,
            100,
            22
          ],
          "text": "peakamp~ 50"
        }
      },
      {
        "box": {
          "id": "peak1",
          "maxclass": "newobj",
          "patching_rect": [
            450,
            1020,
            100,
            22
          ],
          "text": "peakamp~ 50"
        }
      },
      {
        "box": {
          "id": "levels",
          "maxclass": "newobj",
          "patching_rect": [
            300,
            1060,
            100,
            22
          ],
          "text": "pak 0. 0."
        }
      },
      {
        "box": {
          "id": "levelmsg",
          "maxclass": "newobj",
          "patching_rect": [
            300,
            1100,
            100,
            22
          ],
          "text": "prepend levels"
        }
      },
      {
        "box": {
          "id": "savedialog",
          "maxclass": "newobj",
          "patching_rect": [
            600,
            1190,
            145,
            22
          ],
          "text": "savedialog WAVE"
        }
      },
      {
        "box": {
          "id": "saveorder",
          "maxclass": "newobj",
          "patching_rect": [
            600,
            1230,
            50,
            22
          ],
          "text": "t b s"
        }
      },
      {
        "box": {
          "id": "openwav",
          "maxclass": "message",
          "patching_rect": [
            730,
            1230,
            100,
            22
          ],
          "text": "open $1 wave"
        }
      },
      {
        "box": {
          "id": "recorddelay",
          "maxclass": "newobj",
          "patching_rect": [
            600,
            1270,
            80,
            22
          ],
          "text": "delay 100"
        }
      },
      {
        "box": {
          "id": "recordone",
          "maxclass": "message",
          "patching_rect": [
            600,
            1310,
            30,
            22
          ],
          "text": "1"
        }
      },
      {
        "box": {
          "id": "reczero",
          "maxclass": "message",
          "patching_rect": [
            690,
            1310,
            30,
            22
          ],
          "text": "0"
        }
      },
      {
        "box": {
          "id": "recorder",
          "maxclass": "newobj",
          "patching_rect": [
            300,
            1230,
            180,
            22
          ],
          "numinlets": 2,
          "numoutlets": 1,
          "outlettype": [
            "signal"
          ],
          "text": "sfrecord~ 2 @bitdepth 24"
        }
      },
      {
        "box": {
          "id": "recordstatus",
          "maxclass": "message",
          "patching_rect": [
            780,
            1310,
            80,
            22
          ],
          "text": "recstarted"
        }
      },
      {
        "box": {
          "id": "note",
          "maxclass": "comment",
          "patching_rect": [
            30,
            1190,
            245,
            100
          ],
          "text": "AURORA / Audio path: 64-voice Gen → linked stereo limiter → output & 24-bit recorder.\nEdit aurora_engine_v2.gendsp for DSP and aurora_ui.js for the interface. No third-party externals."
        }
      },
      {
        "box": {
          "id": "key",
          "maxclass": "newobj",
          "patching_rect": [
            30,
            1370,
            50,
            22
          ],
          "text": "key"
        }
      },
      {
        "box": {
          "id": "active",
          "maxclass": "newobj",
          "patching_rect": [
            100,
            1370,
            50,
            22
          ],
          "text": "active"
        }
      },
      {
        "box": {
          "id": "keygate",
          "maxclass": "newobj",
          "patching_rect": [
            30,
            1410,
            50,
            22
          ],
          "text": "gate"
        }
      },
      {
        "box": {
          "id": "keysel",
          "maxclass": "newobj",
          "patching_rect": [
            30,
            1450,
            220,
            22
          ],
          "text": "sel 32 102 49 50 51 52 53"
        }
      },
      {
        "box": {
          "id": "keymsg0",
          "maxclass": "message",
          "patching_rect": [
            30,
            1490,
            110,
            22
          ],
          "text": "action run"
        }
      },
      {
        "box": {
          "id": "keymsg1",
          "maxclass": "message",
          "patching_rect": [
            150,
            1490,
            110,
            22
          ],
          "text": "action freeze"
        }
      },
      {
        "box": {
          "id": "keymsg2",
          "maxclass": "message",
          "patching_rect": [
            270,
            1490,
            110,
            22
          ],
          "text": "preset 0"
        }
      },
      {
        "box": {
          "id": "keymsg3",
          "maxclass": "message",
          "patching_rect": [
            390,
            1490,
            110,
            22
          ],
          "text": "preset 1"
        }
      },
      {
        "box": {
          "id": "keymsg4",
          "maxclass": "message",
          "patching_rect": [
            510,
            1490,
            110,
            22
          ],
          "text": "preset 2"
        }
      },
      {
        "box": {
          "id": "keymsg5",
          "maxclass": "message",
          "patching_rect": [
            630,
            1490,
            110,
            22
          ],
          "text": "preset 3"
        }
      },
      {
        "box": {
          "id": "keymsg6",
          "maxclass": "message",
          "patching_rect": [
            750,
            1490,
            110,
            22
          ],
          "text": "preset 4"
        }
      },
      {
        "box": {
          "id": "stsave",
          "maxclass": "newobj",
          "patching_rect": [
            600,
            1050,
            140,
            22
          ],
          "text": "savedialog JSON"
        }
      },
      {
        "box": {
          "id": "stsavepath",
          "maxclass": "newobj",
          "patching_rect": [
            600,
            1090,
            170,
            22
          ],
          "text": "prepend savestatepath"
        }
      },
      {
        "box": {
          "id": "stload",
          "maxclass": "newobj",
          "patching_rect": [
            800,
            1050,
            140,
            22
          ],
          "text": "opendialog JSON"
        }
      },
      {
        "box": {
          "id": "stloadpath",
          "maxclass": "newobj",
          "patching_rect": [
            800,
            1090,
            170,
            22
          ],
          "text": "prepend loadstatepath"
        }
      }
    ],
    "lines": [
      {
        "patchline": {
          "source": [
            "source",
            1
          ],
          "destination": [
            "loaded",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "loaded",
            0
          ],
          "destination": [
            "panel",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "panel",
            0
          ],
          "destination": [
            "engine",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "panel",
            1
          ],
          "destination": [
            "commands",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "engine",
            0
          ],
          "destination": [
            "limiter",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "engine",
            1
          ],
          "destination": [
            "limiter",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "limiter",
            0
          ],
          "destination": [
            "dac",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "limiter",
            1
          ],
          "destination": [
            "dac",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "commands",
            0
          ],
          "destination": [
            "dac",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "commands",
            1
          ],
          "destination": [
            "replace",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "replace",
            0
          ],
          "destination": [
            "source",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "commands",
            2
          ],
          "destination": [
            "demo",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "demo",
            0
          ],
          "destination": [
            "source",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "bind",
            0
          ],
          "destination": [
            "engine",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "init",
            0
          ],
          "destination": [
            "defer",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "defer",
            0
          ],
          "destination": [
            "initmsg",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "initmsg",
            0
          ],
          "destination": [
            "panel",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "dspstate",
            0
          ],
          "destination": [
            "dspmsg",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "dspmsg",
            0
          ],
          "destination": [
            "panel",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "engine",
            2
          ],
          "destination": [
            "cursorsnap",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "cursorsnap",
            0
          ],
          "destination": [
            "cursormsg",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "cursormsg",
            0
          ],
          "destination": [
            "panel",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "engine",
            3
          ],
          "destination": [
            "voicessnap",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "voicessnap",
            0
          ],
          "destination": [
            "voicesmsg",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "voicesmsg",
            0
          ],
          "destination": [
            "panel",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "limiter",
            0
          ],
          "destination": [
            "peak0",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "limiter",
            1
          ],
          "destination": [
            "peak1",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "peak0",
            0
          ],
          "destination": [
            "levels",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "peak1",
            0
          ],
          "destination": [
            "levels",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "levels",
            0
          ],
          "destination": [
            "levelmsg",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "levelmsg",
            0
          ],
          "destination": [
            "panel",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "commands",
            5
          ],
          "destination": [
            "savedialog",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "savedialog",
            0
          ],
          "destination": [
            "saveorder",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "saveorder",
            1
          ],
          "destination": [
            "openwav",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "saveorder",
            0
          ],
          "destination": [
            "recorddelay",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "recorddelay",
            0
          ],
          "destination": [
            "recordone",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "commands",
            6
          ],
          "destination": [
            "reczero",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "limiter",
            0
          ],
          "destination": [
            "recorder",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "limiter",
            1
          ],
          "destination": [
            "recorder",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "openwav",
            0
          ],
          "destination": [
            "recorder",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "recordone",
            0
          ],
          "destination": [
            "recorder",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "reczero",
            0
          ],
          "destination": [
            "recorder",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "recorddelay",
            0
          ],
          "destination": [
            "recordstatus",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "recordstatus",
            0
          ],
          "destination": [
            "panel",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "active",
            0
          ],
          "destination": [
            "keygate",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "key",
            0
          ],
          "destination": [
            "keygate",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "keygate",
            0
          ],
          "destination": [
            "keysel",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "keysel",
            0
          ],
          "destination": [
            "keymsg0",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "keymsg0",
            0
          ],
          "destination": [
            "panel",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "keysel",
            1
          ],
          "destination": [
            "keymsg1",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "keymsg1",
            0
          ],
          "destination": [
            "panel",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "keysel",
            2
          ],
          "destination": [
            "keymsg2",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "keymsg2",
            0
          ],
          "destination": [
            "panel",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "keysel",
            3
          ],
          "destination": [
            "keymsg3",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "keymsg3",
            0
          ],
          "destination": [
            "panel",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "keysel",
            4
          ],
          "destination": [
            "keymsg4",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "keymsg4",
            0
          ],
          "destination": [
            "panel",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "keysel",
            5
          ],
          "destination": [
            "keymsg5",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "keymsg5",
            0
          ],
          "destination": [
            "panel",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "keysel",
            6
          ],
          "destination": [
            "keymsg6",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "keymsg6",
            0
          ],
          "destination": [
            "panel",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "commands",
            3
          ],
          "destination": [
            "stsave",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "stsave",
            0
          ],
          "destination": [
            "stsavepath",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "stsavepath",
            0
          ],
          "destination": [
            "panel",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "commands",
            4
          ],
          "destination": [
            "stload",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "stload",
            0
          ],
          "destination": [
            "stloadpath",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "stloadpath",
            0
          ],
          "destination": [
            "panel",
            0
          ]
        }
      }
    ],
    "openinpresentation": 1,
    "bglocked": 1,
    "bgcolor": [
      0.035,
      0.047,
      0.061,
      1
    ],
    "presentation_rect": [
      0,
      0,
      1120,
      750
    ],
    "enablehscroll": 0,
    "enablevscroll": 0,
    "toolbarvisible": 0,
    "statusbarvisible": 0,
    "description": "AURORA — a 64-voice stereo granular instrument for Max 8.",
    "title": "AURORA | Granular Instrument"
  }
}