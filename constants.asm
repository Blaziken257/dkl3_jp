; TODO: Figure out some missing HRAM values

DEF H_Life_Counter EQU $FFA9
DEF H_Banana_Counter EQU $FFAA
DEF H_Current_Kong EQU $FFAB
DEF H_Hit_Count EQU $FFAC
DEF H_Current_World EQU $FFAD
DEF H_Current_Level EQU $FFAE
DEF H_Hour_Count EQU $FFAF
DEF H_Minute_Count EQU $FFB0
DEF H_Second_Count EQU $FFB1
DEF H_Bear_Coin_Count EQU $FFB2
DEF H_Bonus_Coin_Count EQU $FFB3
DEF H_DK_Coin_Count EQU $FFB4
DEF H_Watch_Count EQU $FFB5
; Most recent sprite data, located at FFD6-FFDD
DEF H_Boss_Stage_Flag EQU $FFDE
DEF H_Demo_Pointer_High EQU $FFE1 ; Yes, this is big-endian... not sure of a better way to use DEF with 16-bit values
DEF H_Demo_Pointer_Low EQU $FFE2
DEF H_Demo_Frame_Count EQU $FFE3
DEF H_Demo_Button_Presses EQU $FFE4
DEF H_Cur_Level_Data EQU $FFE8
DEF H_Cheat_Codes EQU $FFF8
DEF H_Demo_Index EQU $FFFB
DEF H_Time_Attack_Cursor EQU $FFFB ;The same HRAM address is used for 2 different things

DEF W_Stage_Type EQU $C5ED
DEF W_Bonus_Timer EQU $C5EE
DEF W_Bonus_Obj_Counter EQU $C5EF ; Stars/enemies
DEF W_Frame_Counter EQU $DE9E
DEF W_Sound_Effect EQU $DF57
DEF W_Map_Anim_Counter EQU $DF8B

; Level/bonus stage IDS
DEF M_Bonus_Find_Token EQU 0
DEF M_Bonus_Collect_Stars EQU 1
DEF M_Bonus_Bash_Baddies EQU 2
DEF M_Warp_Area EQU 3
DEF M_Level_After_Bonus EQU 254 ; Normal level after leaving bonus stage
DEF M_Level_Normal EQU 255