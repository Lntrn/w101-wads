--[[ 

	Globals.lua

	This file holds global functions and basic variables that 
	will always remain constant throughout all scripts.
	
	Author: Tamir Nadav, Josh Szepietowski
	KingsIsle Entertainment
	Date: June 08, 2006
--]]

-- Global Variables --
----------------------

--[[ GUI Key codes, used by GM_KEYDOWN and GM_KEYUP ]]
GK_LBUTTON				=	01
GK_RBUTTON				=	02
GK_CANCEL				=	03
GK_MBUTTON				=	04    -- NOT contiguous with L & RBUTTON

GK_BACK					=	08
GK_TAB					=	09

GK_CLEAR				=	12
GK_RETURN				=	13

GK_SHIFT				=	16
GK_CONTROL				=	17
GK_MENU					=	18
GK_PAUSE				=	19
GK_CAPITAL				=	20

GK_KANA					=	21
GK_HANGEUL				=	21	-- old name - should be here for compatibility
GK_HANGUL				=	21
GK_JUNJA				=	23
GK_FINAL				=	24
GK_HANJA				=	25
GK_KANJI				=	25

GK_ESCAPE				=	27

GK_CONVERT				=	28
GK_NONCONVERT			=	29
GK_ACCEPT				=	30
GK_MODECHANGE			=	31

GK_SPACE				=	32
GK_PRIOR				=	33
GK_NEXT					=	34
GK_END					=	35
GK_HOME					=	36
GK_LEFT					=	37
GK_UP					=	38
GK_RIGHT				=	39
GK_DOWN					=	40
GK_SELECT				=	41
GK_PRINT				=	42
GK_EXECUTE				=	43
GK_SNAPSHOT				=	44
GK_INSERT				=	45
GK_DELETE				=	46
GK_HELP					=	47

GK_NUMPAD0				=	96
GK_NUMPAD1				=	97
GK_NUMPAD2				=	98
GK_NUMPAD3				=	99
GK_NUMPAD4				=	100
GK_NUMPAD5				=	101
GK_NUMPAD6				=	102
GK_NUMPAD7				=	103
GK_NUMPAD8				=	104
GK_NUMPAD9				=	105
GK_MULTIPLY				=	106
GK_ADD					=	107
GK_SEPARATOR			=	108
GK_SUBTRACT				=	109
GK_DECIMAL				=	110
GK_DIVIDE				=	111

GK_F1					=	112
GK_F2					=	113
GK_F3					=	114
GK_F4					=	115
GK_F5					=	116
GK_F6					=	117
GK_F7					=	118
GK_F8					=	119
GK_F9					=	120
GK_F10					=	121
GK_F11					=	122
GK_F12					=	123
GK_F13					=	124
GK_F14					=	125
GK_F15					=	126
GK_F16					=	127
GK_F17					=	128
GK_F18					=	129
GK_F19					=	130
GK_F20					=	131
GK_F21					=	132
GK_F22					=	133
GK_F23					=	134
GK_F24					=	135
GK_NUMLOCK				=	144
GK_SCROLL				=	145


-- KeyPresses...  NOTE: Wherever duplicate with above, use the GK_* instead. Below is obsolete and needs to be phased out --
KP_SPACE		= 32

KP_A			= 65
KP_B			= 66
KP_C			= 67
KP_D			= 68
KP_E			= 69
KP_F			= 70
KP_G			= 71
KP_H			= 72
KP_I			= 73
KP_J			= 74
KP_K			= 75
KP_L			= 76
KP_M			= 77
KP_N			= 78
KP_O			= 79
KP_P			= 80
KP_Q			= 81
KP_R			= 82
KP_S			= 83
KP_T			= 84
KP_U			= 85
KP_V			= 86
KP_W			= 87
KP_X			= 88
KP_Y			= 89
KP_Z			= 90

KP_HOME			= 303
KP_PGUP			= 305
KP_NUMPAD1		= 297
KP_NUMPAD2		= 298
KP_NUMPAD3		= 299
KP_NUMPAD4		= 300
KP_NUMPAD5		= 301
KP_NUMPAD6		= 302
KP_NUMPAD7		= 303
KP_NUMPAD8		= 304
KP_NUMPAD9		= 305

KP_SHIFT_ALONE  = 65792
KP_SHIFT_COMBO  = 65536
KP_CTRL_ALONE	= 131330
KP_CTRL_COMBO	= 131072
KP_ALT_ALONE	= 262404
KP_ALT_COMBO	= 262144

-- Global Functions
-- TODO: Remove this abomination! DO NOT USE IT!
function SendServerMessage(message, arg0,arg1,arg2,arg3,arg4,arg5,arg6,arg7,arg8,arg9)

	local msg = message;
	if(arg0) then
		msg = msg..arg0;
	end
	if(arg1) then
		msg = msg..arg1;
	end
	if(arg2) then
		msg = msg..arg2;
	end
	if(arg3) then
		msg = msg..arg3;
	end
	if(arg4) then
		msg = msg..arg4;
	end
	if(arg5) then
		msg = msg..arg5;
	end
	if(arg6) then
		msg = msg..arg6;
	end
	if(arg7) then
		msg = msg..arg7;
	end
	if(arg8) then
		msg = msg..arg8;
	end
	if(arg9) then
		msg = msg..arg9;
	end
	Server("ScriptEvent \""..msg.."\"");
	
end

function GetEvent(eventName, block)
	eventName = eventName or "";
	if block == nil then
		block = true;
	end

	local e;
	repeat
		e = GetEventInternal(eventName, block);
	until block == false or e ~= nil

	if e ~= nil then
		e.EventName = e.EventName or "";
		e.Name = e.Name or "";
	end

	return e;
end
