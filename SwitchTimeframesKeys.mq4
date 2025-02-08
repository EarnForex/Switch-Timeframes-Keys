//+------------------------------------------------------------------+
//|                                         SwitchTimeframesKeys.mq4 |
//|                                  Copyright © 2025, EarnForex.com |
//|                                       https://www.earnforex.com/ |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2025, www.EarnForex.com"
#property link      "https://www.earnforex.com/metatrader-indicators/SwitchTimeframesKeys/"
#property version   "1.00"
#property strict

#property description "Switches timeframes using keyboard shortcuts."
#property description "Use the input parameters to set your preferred hotkeys."
#property description "1 = M1, 2 = M5, 3 = M15, 4 = M30, 5 = H1, 6 = H4, 7 = D1, 8 = W1, 9 = MN"
#property description "Z = cycle left, X = cycle right"

#property indicator_chart_window
#property indicator_plots 0

input string ____Keyboard_Shortcuts = "Case-insensitive hotkeys. Support Ctrl, Shift.";
input string M1  = "1";
input string M5  = "2";
input string M15 = "3";
input string M30 = "4";
input string H1  = "5";
input string H4  = "6";
input string D1  = "7";
input string W1  = "8";
input string MN  = "9";
input string SwitchDown = "Z";
input string SwitchUp   = "X";
input string SwitchThrough = "M1, M5, M15, M30, H1, H4, D1, W1, MN";

ENUM_TIMEFRAMES TF_Array[];
uchar MainKey_M1 = 0, MainKey_M5 = 0, MainKey_M15 = 0, MainKey_M30 = 0, MainKey_H1 = 0, MainKey_H4 = 0, MainKey_D1 = 0, MainKey_W1 = 0, MainKey_MN = 0, MainKey_SwitchDown = 0, MainKey_SwitchUp = 0;
bool CtrlRequired_M1 = false, CtrlRequired_M5 = false, CtrlRequired_M15 = false, CtrlRequired_M30 = false, CtrlRequired_H1 = false, CtrlRequired_H4 = false, CtrlRequired_D1 = false, CtrlRequired_W1 = false, CtrlRequired_MN = false, CtrlRequired_SwitchDown = false, CtrlRequired_SwitchUp = false;
bool ShiftRequired_M1 = false, ShiftRequired_M5 = false, ShiftRequired_M15 = false, ShiftRequired_M30 = false, ShiftRequired_H1 = false, ShiftRequired_H4 = false, ShiftRequired_D1 = false, ShiftRequired_W1 = false, ShiftRequired_MN = false, ShiftRequired_SwitchDown = false, ShiftRequired_SwitchUp = false;

void OnInit()
{
    // If a hotkey is given, break up the string to check for hotkey presses in OnChartEvent().
    if (M1 != "") DissectHotKeyCombination(M1, ShiftRequired_M1, CtrlRequired_M1, MainKey_M1);
    else MainKey_M1 = 0;
    if (M5 != "") DissectHotKeyCombination(M5, ShiftRequired_M5, CtrlRequired_M5, MainKey_M5);
    else MainKey_M5 = 0;
    if (M15 != "") DissectHotKeyCombination(M15, ShiftRequired_M15, CtrlRequired_M15, MainKey_M15);
    else MainKey_M15 = 0;
    if (M30 != "") DissectHotKeyCombination(M30, ShiftRequired_M30, CtrlRequired_M30, MainKey_M30);
    else MainKey_M30 = 0;
    if (H1 != "") DissectHotKeyCombination(H1, ShiftRequired_H1, CtrlRequired_H1, MainKey_H1);
    else MainKey_H1 = 0;
    if (H4 != "") DissectHotKeyCombination(H4, ShiftRequired_H4, CtrlRequired_H4, MainKey_H4);
    else MainKey_H4 = 0;
    if (D1 != "") DissectHotKeyCombination(D1, ShiftRequired_D1, CtrlRequired_D1, MainKey_D1);
    else MainKey_D1 = 0;
    if (W1 != "") DissectHotKeyCombination(W1, ShiftRequired_W1, CtrlRequired_W1, MainKey_W1);
    else MainKey_W1 = 0;
    if (MN != "") DissectHotKeyCombination(MN, ShiftRequired_MN, CtrlRequired_MN, MainKey_MN);
    else MainKey_MN = 0;
    if (SwitchDown != "") DissectHotKeyCombination(SwitchDown, ShiftRequired_SwitchDown, CtrlRequired_SwitchDown, MainKey_SwitchDown);
    else MainKey_SwitchDown = 0;
    if (SwitchUp != "") DissectHotKeyCombination(SwitchUp, ShiftRequired_SwitchUp, CtrlRequired_SwitchUp, MainKey_SwitchUp);
    else MainKey_SwitchUp = 0;
    
    PrepareSwitchThroughArray();
}

// A dummy function because everything is handled in OnChartEvent().
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime& time[],
                const double& open[],
                const double& high[],
                const double& low[],
                const double& close[],
                const long& tick_volume[],
                const long& volume[],
                const int& Spread[]
)
{
    return rates_total;
}

void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
{
    if (id != CHARTEVENT_KEYDOWN) return;
    
    if ((MainKey_M1 != 0) && (lparam == MainKey_M1)
        && ((((!ShiftRequired_M1) && (TerminalInfoInteger(TERMINAL_KEYSTATE_SHIFT) >= 0))   || ((ShiftRequired_M1) && (TerminalInfoInteger(TERMINAL_KEYSTATE_SHIFT) < 0))) // Shift
        &&  (((!CtrlRequired_M1)  && (TerminalInfoInteger(TERMINAL_KEYSTATE_CONTROL) >= 0)) || ((CtrlRequired_M1)  && (TerminalInfoInteger(TERMINAL_KEYSTATE_CONTROL) < 0)))) // Control
       )
    {
        ChartSetSymbolPeriod(ChartID(), Symbol(), PERIOD_M1);
    }
    else if ((MainKey_M5 != 0) && (lparam == MainKey_M5)
        && ((((!ShiftRequired_M5) && (TerminalInfoInteger(TERMINAL_KEYSTATE_SHIFT) >= 0))   || ((ShiftRequired_M5) && (TerminalInfoInteger(TERMINAL_KEYSTATE_SHIFT) < 0))) // Shift
        &&  (((!CtrlRequired_M5)  && (TerminalInfoInteger(TERMINAL_KEYSTATE_CONTROL) >= 0)) || ((CtrlRequired_M5)  && (TerminalInfoInteger(TERMINAL_KEYSTATE_CONTROL) < 0)))) // Control
       )
    {
        ChartSetSymbolPeriod(ChartID(), Symbol(), PERIOD_M5);
    }
    else if ((MainKey_M15 != 0) && (lparam == MainKey_M15)
        && ((((!ShiftRequired_M15) && (TerminalInfoInteger(TERMINAL_KEYSTATE_SHIFT) >= 0))   || ((ShiftRequired_M15) && (TerminalInfoInteger(TERMINAL_KEYSTATE_SHIFT) < 0))) // Shift
        &&  (((!CtrlRequired_M15)  && (TerminalInfoInteger(TERMINAL_KEYSTATE_CONTROL) >= 0)) || ((CtrlRequired_M15)  && (TerminalInfoInteger(TERMINAL_KEYSTATE_CONTROL) < 0)))) // Control
       )
    {
        ChartSetSymbolPeriod(ChartID(), Symbol(), PERIOD_M15);
    }
    else if ((MainKey_M30 != 0) && (lparam == MainKey_M30)
        && ((((!ShiftRequired_M30) && (TerminalInfoInteger(TERMINAL_KEYSTATE_SHIFT) >= 0))   || ((ShiftRequired_M30) && (TerminalInfoInteger(TERMINAL_KEYSTATE_SHIFT) < 0))) // Shift
        &&  (((!CtrlRequired_M30)  && (TerminalInfoInteger(TERMINAL_KEYSTATE_CONTROL) >= 0)) || ((CtrlRequired_M30)  && (TerminalInfoInteger(TERMINAL_KEYSTATE_CONTROL) < 0)))) // Control
       )
    {
        ChartSetSymbolPeriod(ChartID(), Symbol(), PERIOD_M30);
    }
    else if ((MainKey_H1 != 0) && (lparam == MainKey_H1)
        && ((((!ShiftRequired_H1) && (TerminalInfoInteger(TERMINAL_KEYSTATE_SHIFT) >= 0))   || ((ShiftRequired_H1) && (TerminalInfoInteger(TERMINAL_KEYSTATE_SHIFT) < 0))) // Shift
        &&  (((!CtrlRequired_H1)  && (TerminalInfoInteger(TERMINAL_KEYSTATE_CONTROL) >= 0)) || ((CtrlRequired_H1)  && (TerminalInfoInteger(TERMINAL_KEYSTATE_CONTROL) < 0)))) // Control
       )
    {
        ChartSetSymbolPeriod(ChartID(), Symbol(), PERIOD_H1);
    }
    else if ((MainKey_H4 != 0) && (lparam == MainKey_H4)
        && ((((!ShiftRequired_H4) && (TerminalInfoInteger(TERMINAL_KEYSTATE_SHIFT) >= 0))   || ((ShiftRequired_H4) && (TerminalInfoInteger(TERMINAL_KEYSTATE_SHIFT) < 0))) // Shift
        &&  (((!CtrlRequired_H4)  && (TerminalInfoInteger(TERMINAL_KEYSTATE_CONTROL) >= 0)) || ((CtrlRequired_H4)  && (TerminalInfoInteger(TERMINAL_KEYSTATE_CONTROL) < 0)))) // Control
       )
    {
        ChartSetSymbolPeriod(ChartID(), Symbol(), PERIOD_H4);
    }
    else if ((MainKey_D1 != 0) && (lparam == MainKey_D1)
        && ((((!ShiftRequired_D1) && (TerminalInfoInteger(TERMINAL_KEYSTATE_SHIFT) >= 0))   || ((ShiftRequired_D1) && (TerminalInfoInteger(TERMINAL_KEYSTATE_SHIFT) < 0))) // Shift
        &&  (((!CtrlRequired_D1)  && (TerminalInfoInteger(TERMINAL_KEYSTATE_CONTROL) >= 0)) || ((CtrlRequired_D1)  && (TerminalInfoInteger(TERMINAL_KEYSTATE_CONTROL) < 0)))) // Control
       )
    {
        ChartSetSymbolPeriod(ChartID(), Symbol(), PERIOD_D1);
    }
    else if ((MainKey_W1 != 0) && (lparam == MainKey_W1)
        && ((((!ShiftRequired_W1) && (TerminalInfoInteger(TERMINAL_KEYSTATE_SHIFT) >= 0))   || ((ShiftRequired_W1) && (TerminalInfoInteger(TERMINAL_KEYSTATE_SHIFT) < 0))) // Shift
        &&  (((!CtrlRequired_W1)  && (TerminalInfoInteger(TERMINAL_KEYSTATE_CONTROL) >= 0)) || ((CtrlRequired_W1)  && (TerminalInfoInteger(TERMINAL_KEYSTATE_CONTROL) < 0)))) // Control
       )
    {
        ChartSetSymbolPeriod(ChartID(), Symbol(), PERIOD_W1);
    }
    else if ((MainKey_MN != 0) && (lparam == MainKey_MN)
        && ((((!ShiftRequired_MN) && (TerminalInfoInteger(TERMINAL_KEYSTATE_SHIFT) >= 0))   || ((ShiftRequired_MN) && (TerminalInfoInteger(TERMINAL_KEYSTATE_SHIFT) < 0))) // Shift
        &&  (((!CtrlRequired_MN)  && (TerminalInfoInteger(TERMINAL_KEYSTATE_CONTROL) >= 0)) || ((CtrlRequired_MN)  && (TerminalInfoInteger(TERMINAL_KEYSTATE_CONTROL) < 0)))) // Control
       )
    {
        ChartSetSymbolPeriod(ChartID(), Symbol(), PERIOD_MN1);
    }
    else if ((MainKey_SwitchDown != 0) && (lparam == MainKey_SwitchDown)
        && ((((!ShiftRequired_SwitchDown) && (TerminalInfoInteger(TERMINAL_KEYSTATE_SHIFT) >= 0))   || ((ShiftRequired_SwitchDown) && (TerminalInfoInteger(TERMINAL_KEYSTATE_SHIFT) < 0))) // Shift
        &&  (((!CtrlRequired_SwitchDown)  && (TerminalInfoInteger(TERMINAL_KEYSTATE_CONTROL) >= 0)) || ((CtrlRequired_SwitchDown)  && (TerminalInfoInteger(TERMINAL_KEYSTATE_CONTROL) < 0)))) // Control
       )
    {
        if (ArraySize(TF_Array) == 0) return;
        bool tf_found = false;
        for (int i = 0; i < ArraySize(TF_Array); i++)
        {
            if (Period() == TF_Array[i]) // Easy - the TF has been found.
            {
                if (i > 0) i--;
                else i = ArraySize(TF_Array) - 1;
                ChartSetSymbolPeriod(ChartID(), Symbol(), TF_Array[i]);
                tf_found = true;
                break;
            }
        }
        if (!tf_found) // Difficult - TF not found.
        {
            // Find the first TF > current one:
            for (int i = 0; i < ArraySize(TF_Array); i++)
            {
                if (PeriodSeconds() < PeriodSeconds(TF_Array[i]))
                {
                    if (i > 0) i--;
                    else i = ArraySize(TF_Array) - 1;
                    ChartSetSymbolPeriod(ChartID(), Symbol(), TF_Array[i]);
                    tf_found = true;
                    break;
                }
            }
            if (!tf_found) // If once again not found - i.e., all TFs are below the current one:
            {
                // Switch to the last one.
                ChartSetSymbolPeriod(ChartID(), Symbol(), TF_Array[ArraySize(TF_Array) - 1]);
            }
        }
    }
    else if ((MainKey_SwitchUp != 0) && (lparam == MainKey_SwitchUp)
        && ((((!ShiftRequired_SwitchUp) && (TerminalInfoInteger(TERMINAL_KEYSTATE_SHIFT) >= 0))   || ((ShiftRequired_SwitchUp) && (TerminalInfoInteger(TERMINAL_KEYSTATE_SHIFT) < 0))) // Shift
        &&  (((!CtrlRequired_SwitchUp)  && (TerminalInfoInteger(TERMINAL_KEYSTATE_CONTROL) >= 0)) || ((CtrlRequired_SwitchUp)  && (TerminalInfoInteger(TERMINAL_KEYSTATE_CONTROL) < 0)))) // Control
       )
    {
        if (ArraySize(TF_Array) == 0) return;
        bool tf_found = false;
        for (int i = 0; i < ArraySize(TF_Array); i++)
        {
            if (Period() == TF_Array[i]) // Easy - the TF has been found.
            {
                if (i < ArraySize(TF_Array) - 1) i++;
                else i = 0;
                ChartSetSymbolPeriod(ChartID(), Symbol(), TF_Array[i]);
                tf_found = true;
                break;
            }
        }
        if (!tf_found) // Difficult - TF not found.
        {
            // Find the first TF < current one:
            for (int i = ArraySize(TF_Array) - 1; i >= 0 ; i--)
            {
                if (PeriodSeconds() > PeriodSeconds(TF_Array[i]))
                {
                    if (i < ArraySize(TF_Array) - 1) i++;
                    else i = 0;
                    ChartSetSymbolPeriod(ChartID(), Symbol(), TF_Array[i]);
                    tf_found = true;
                    break;
                }
            }
            if (!tf_found) // If once again not found - i.e., all TFs are above the current one:
            {
                // Switch to the first one.
                ChartSetSymbolPeriod(ChartID(), Symbol(), TF_Array[0]);
            }
        }
    }
}

void DissectHotKeyCombination(const string hotkey, bool &shift_required, bool &ctrl_required, uchar &main_key)
{
    ushort separator;
    if (StringFind(hotkey, "+") > -1) separator = StringGetCharacter("+", 0);
    else if (StringFind(hotkey, "-") > -1) separator = StringGetCharacter("-", 0);
    else separator = 0;
    string keys[];
    int n = StringSplit(hotkey, separator, keys);
    if (n < 1) return; // Wrong or empty.
    if (n > 1) // A key with a modifier.
    {
        for (int i = 0; i < n - 1; i++)
        {
            StringToUpper(keys[i]);
            if (keys[i] == "SHIFT") shift_required = true;
            else if (keys[i] == "CTRL") ctrl_required = true;
        }
    }
    StringToUpper(keys[n - 1]);
    if (keys[n - 1] == "TAB") main_key = 9;
    else if ((keys[n - 1] == "ESC") || (keys[n - 1] == "ESCAPE")) main_key = 27;
    else if ((keys[n - 1] == "BACKSPACE") || (keys[n - 1] == "BACK") || (keys[n - 1] == "BS") || (keys[n - 1] == "BKSP")) main_key = 8;
    else if ((keys[n - 1] == "CAPS") || (keys[n - 1] == "CAPS LOCK") || (keys[n - 1] == "CAPSLOCK") || (keys[n - 1] == "CAPSLK")) main_key = 20;
    else main_key = (uchar)StringGetCharacter(keys[n - 1], 0);
    if (main_key == 96) main_key = 192; // A hack to use ` as a hotkey.
}

void PrepareSwitchThroughArray()
{
    if (SwitchThrough == "") return;

    int array_counter = 0;

    // Split string with timeframes using all possible separators, getting an array with clean timeframes.
    string result[];
    int n = StringSplit(SwitchThrough, StringGetCharacter(",", 0), result);
    for (int i = 0; i < n; i++)
    {
        string second_result[];
        int m = StringSplit(result[i], StringGetCharacter(";", 0), second_result);
        for (int j = 0; j < m; j++)
        {
            StringReplace(second_result[j], " ", ""); // Remove spaces.
            if (second_result[j] == "") continue;
            // Third result, at this point, holds all the Instruments (strings) even if there was only one.
            // The problem is that it will vanish on next cycle iteration.
            ArrayResize(TF_Array, array_counter + 1, 9);
            TF_Array[array_counter] = StringToTimeframe(second_result[j]);
            array_counter++;
        }
    }
}

ENUM_TIMEFRAMES StringToTimeframe(string s)
{
    StringToUpper(s);
    if ((s == "MN") || (s == "MONTHLY") || (s == "MONTH") || (s == "1MN") || (s == "PERIOD_MN") || (s == "PERIOD_MN1") || (s == "MN1")) return PERIOD_MN1;
    if ((s == "W1") || (s == "WEEKLY") || (s == "WEEK") || (s == "1W") || (s == "PERIOD_W1")) return PERIOD_W1;
    if ((s == "D1") || (s == "DAILY") || (s == "DAY") || (s == "1D") || (s == "PERIOD_D1")) return PERIOD_D1;
    if ((s == "H4") || (s == "4-HOUR") || (s == "4H") || (s == "PERIOD_H4")) return PERIOD_H4;
    if ((s == "H1") || (s == "HOURLY") || (s == "HOUR") || (s == "1H") || (s == "PERIOD_H1")) return PERIOD_H1;
    if ((s == "M30") || (s == "30M") || (s == "PERIOD_M30")) return PERIOD_M30;
    if ((s == "M15") || (s == "15M") || (s == "PERIOD_M15")) return PERIOD_M15;
    if ((s == "M5") || (s == "5M") || (s == "PERIOD_M5")) return PERIOD_M5;
    if ((s == "M1") || (s == "1M") || (s == "PERIOD_M1")) return PERIOD_M1;
    return PERIOD_CURRENT;
}
//+------------------------------------------------------------------+