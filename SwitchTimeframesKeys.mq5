//+------------------------------------------------------------------+
//|                                         SwitchTimeFramesKeys.mq5 |
//|                                  Copyright © 2025, EarnForex.com |
//|                                       https://www.earnforex.com/ |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2025, www.EarnForex.com"
#property link      "https://www.earnforex.com/metatrader-indicators/SwitchTimeframesKeys/"
#property version   "1.00"


#property description "Switches timeframes using keyboard shortcuts."
#property description "Use the input parameters to set your preferred hotkeys."
#property description "1 = M1, 2 = M5, 3 = M15, 4 = M30, 5 = H1, 6 = H4, 7 = D1, 8 = W1, 9 = MN"
#property description "Z = cycle left, X = cycle right"

#property indicator_chart_window
#property indicator_plots 0

input string ____Keyboard_Shortcuts = "Case-insensitive hotkeys. Support Ctrl, Shift.";
input string M1  = "1";
input string M2  = "";
input string M3  = "";
input string M4  = "";
input string M5  = "2";
input string M6  = "";
input string M10 = "";
input string M12 = "";
input string M15 = "3";
input string M20 = "";
input string M30 = "4";
input string H1  = "5";
input string H2  = "";
input string H3  = "";
input string H4  = "6";
input string H6  = "";
input string H8  = "";
input string H12 = "";
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

// MT5-specific:
uchar MainKey_M2 = 0, MainKey_M3 = 0, MainKey_M4 = 0, MainKey_M6 = 0, MainKey_M10 = 0, MainKey_M12 = 0, MainKey_M20 = 0, MainKey_H2 = 0, MainKey_H3 = 0, MainKey_H6 = 0, MainKey_H8 = 0, MainKey_H12 = 0;
bool CtrlRequired_M2 = false, CtrlRequired_M3 = false, CtrlRequired_M4 = false, CtrlRequired_M6 = false, CtrlRequired_M10 = false, CtrlRequired_M12 = false, CtrlRequired_M20 = false, CtrlRequired_H2 = false, CtrlRequired_H3 = false, CtrlRequired_H6 = false, CtrlRequired_H8 = false, CtrlRequired_H12 = false;
bool ShiftRequired_M2 = false, ShiftRequired_M3 = false, ShiftRequired_M4 = false, ShiftRequired_M6 = false, ShiftRequired_M10 = false, ShiftRequired_M12 = false, ShiftRequired_M20 = false, ShiftRequired_H2 = false, ShiftRequired_H3 = false, ShiftRequired_H6 = false, ShiftRequired_H8 = false, ShiftRequired_H12 = false;

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

    // MT5-specific:
    if (M2 != "") DissectHotKeyCombination(M2, ShiftRequired_M2, CtrlRequired_M2, MainKey_M2);
    else MainKey_M2 = 0;
    if (M3 != "") DissectHotKeyCombination(M3, ShiftRequired_M3, CtrlRequired_M3, MainKey_M3);
    else MainKey_M3 = 0;
    if (M4 != "") DissectHotKeyCombination(M4, ShiftRequired_M4, CtrlRequired_M4, MainKey_M4);
    else MainKey_M4 = 0;
    if (M6 != "") DissectHotKeyCombination(M6, ShiftRequired_M6, CtrlRequired_M6, MainKey_M6);
    else MainKey_M6 = 0;
    if (M10 != "") DissectHotKeyCombination(M10, ShiftRequired_M10, CtrlRequired_M10, MainKey_M10);
    else MainKey_M10 = 0;
    if (M12 != "") DissectHotKeyCombination(M12, ShiftRequired_M12, CtrlRequired_M12, MainKey_M12);
    else MainKey_M12 = 0;
    if (M20 != "") DissectHotKeyCombination(M20, ShiftRequired_M20, CtrlRequired_M20, MainKey_M20);
    else MainKey_M20 = 0;
    if (H2 != "") DissectHotKeyCombination(H2, ShiftRequired_H2, CtrlRequired_H2, MainKey_H2);
    else MainKey_H2 = 0;
    if (H3 != "") DissectHotKeyCombination(H3, ShiftRequired_H3, CtrlRequired_H3, MainKey_H3);
    else MainKey_H3 = 0;
    if (H6 != "") DissectHotKeyCombination(H6, ShiftRequired_H6, CtrlRequired_H6, MainKey_H6);
    else MainKey_H6 = 0;
    if (H8 != "") DissectHotKeyCombination(H8, ShiftRequired_H8, CtrlRequired_H8, MainKey_H8);
    else MainKey_H8 = 0;
    if (H12 != "") DissectHotKeyCombination(H12, ShiftRequired_H12, CtrlRequired_H12, MainKey_H12);
    else MainKey_H12 = 0;
    
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
    // MT5-specific:
    else if ((MainKey_M2 != 0) && (lparam == MainKey_M2)
        && ((((!ShiftRequired_M2) && (TerminalInfoInteger(TERMINAL_KEYSTATE_SHIFT) >= 0))   || ((ShiftRequired_M2) && (TerminalInfoInteger(TERMINAL_KEYSTATE_SHIFT) < 0))) // Shift
        &&  (((!CtrlRequired_M2)  && (TerminalInfoInteger(TERMINAL_KEYSTATE_CONTROL) >= 0)) || ((CtrlRequired_M2)  && (TerminalInfoInteger(TERMINAL_KEYSTATE_CONTROL) < 0)))) // Control
       )
    {
        ChartSetSymbolPeriod(ChartID(), Symbol(), PERIOD_M2);
    }
    else if ((MainKey_M3 != 0) && (lparam == MainKey_M3)
        && ((((!ShiftRequired_M3) && (TerminalInfoInteger(TERMINAL_KEYSTATE_SHIFT) >= 0))   || ((ShiftRequired_M3) && (TerminalInfoInteger(TERMINAL_KEYSTATE_SHIFT) < 0))) // Shift
        &&  (((!CtrlRequired_M3)  && (TerminalInfoInteger(TERMINAL_KEYSTATE_CONTROL) >= 0)) || ((CtrlRequired_M3)  && (TerminalInfoInteger(TERMINAL_KEYSTATE_CONTROL) < 0)))) // Control
       )
    {
        ChartSetSymbolPeriod(ChartID(), Symbol(), PERIOD_M3);
    }
    else if ((MainKey_M4 != 0) && (lparam == MainKey_M4)
        && ((((!ShiftRequired_M4) && (TerminalInfoInteger(TERMINAL_KEYSTATE_SHIFT) >= 0))   || ((ShiftRequired_M4) && (TerminalInfoInteger(TERMINAL_KEYSTATE_SHIFT) < 0))) // Shift
        &&  (((!CtrlRequired_M4)  && (TerminalInfoInteger(TERMINAL_KEYSTATE_CONTROL) >= 0)) || ((CtrlRequired_M4)  && (TerminalInfoInteger(TERMINAL_KEYSTATE_CONTROL) < 0)))) // Control
       )
    {
        ChartSetSymbolPeriod(ChartID(), Symbol(), PERIOD_M4);
    }
    else if ((MainKey_M6 != 0) && (lparam == MainKey_M6)
        && ((((!ShiftRequired_M6) && (TerminalInfoInteger(TERMINAL_KEYSTATE_SHIFT) >= 0))   || ((ShiftRequired_M6) && (TerminalInfoInteger(TERMINAL_KEYSTATE_SHIFT) < 0))) // Shift
        &&  (((!CtrlRequired_M6)  && (TerminalInfoInteger(TERMINAL_KEYSTATE_CONTROL) >= 0)) || ((CtrlRequired_M6)  && (TerminalInfoInteger(TERMINAL_KEYSTATE_CONTROL) < 0)))) // Control
       )
    {
        ChartSetSymbolPeriod(ChartID(), Symbol(), PERIOD_M6);
    }
    else if ((MainKey_M10 != 0) && (lparam == MainKey_M10)
        && ((((!ShiftRequired_M10) && (TerminalInfoInteger(TERMINAL_KEYSTATE_SHIFT) >= 0))   || ((ShiftRequired_M10) && (TerminalInfoInteger(TERMINAL_KEYSTATE_SHIFT) < 0))) // Shift
        &&  (((!CtrlRequired_M10)  && (TerminalInfoInteger(TERMINAL_KEYSTATE_CONTROL) >= 0)) || ((CtrlRequired_M10)  && (TerminalInfoInteger(TERMINAL_KEYSTATE_CONTROL) < 0)))) // Control
       )
    {
        ChartSetSymbolPeriod(ChartID(), Symbol(), PERIOD_M10);
    }
    else if ((MainKey_M12 != 0) && (lparam == MainKey_M12)
        && ((((!ShiftRequired_M12) && (TerminalInfoInteger(TERMINAL_KEYSTATE_SHIFT) >= 0))   || ((ShiftRequired_M12) && (TerminalInfoInteger(TERMINAL_KEYSTATE_SHIFT) < 0))) // Shift
        &&  (((!CtrlRequired_M12)  && (TerminalInfoInteger(TERMINAL_KEYSTATE_CONTROL) >= 0)) || ((CtrlRequired_M12)  && (TerminalInfoInteger(TERMINAL_KEYSTATE_CONTROL) < 0)))) // Control
       )
    {
        ChartSetSymbolPeriod(ChartID(), Symbol(), PERIOD_M12);
    }
    else if ((MainKey_M20 != 0) && (lparam == MainKey_M20)
        && ((((!ShiftRequired_M20) && (TerminalInfoInteger(TERMINAL_KEYSTATE_SHIFT) >= 0))   || ((ShiftRequired_M20) && (TerminalInfoInteger(TERMINAL_KEYSTATE_SHIFT) < 0))) // Shift
        &&  (((!CtrlRequired_M20)  && (TerminalInfoInteger(TERMINAL_KEYSTATE_CONTROL) >= 0)) || ((CtrlRequired_M20)  && (TerminalInfoInteger(TERMINAL_KEYSTATE_CONTROL) < 0)))) // Control
       )
    {
        ChartSetSymbolPeriod(ChartID(), Symbol(), PERIOD_M20);
    }
    else if ((MainKey_H2 != 0) && (lparam == MainKey_H2)
        && ((((!ShiftRequired_H2) && (TerminalInfoInteger(TERMINAL_KEYSTATE_SHIFT) >= 0))   || ((ShiftRequired_H2) && (TerminalInfoInteger(TERMINAL_KEYSTATE_SHIFT) < 0))) // Shift
        &&  (((!CtrlRequired_H2)  && (TerminalInfoInteger(TERMINAL_KEYSTATE_CONTROL) >= 0)) || ((CtrlRequired_H2)  && (TerminalInfoInteger(TERMINAL_KEYSTATE_CONTROL) < 0)))) // Control
       )
    {
        ChartSetSymbolPeriod(ChartID(), Symbol(), PERIOD_H2);
    }
    else if ((MainKey_H3 != 0) && (lparam == MainKey_H3)
        && ((((!ShiftRequired_H3) && (TerminalInfoInteger(TERMINAL_KEYSTATE_SHIFT) >= 0))   || ((ShiftRequired_H3) && (TerminalInfoInteger(TERMINAL_KEYSTATE_SHIFT) < 0))) // Shift
        &&  (((!CtrlRequired_H3)  && (TerminalInfoInteger(TERMINAL_KEYSTATE_CONTROL) >= 0)) || ((CtrlRequired_H3)  && (TerminalInfoInteger(TERMINAL_KEYSTATE_CONTROL) < 0)))) // Control
       )
    {
        ChartSetSymbolPeriod(ChartID(), Symbol(), PERIOD_H3);
    }
    else if ((MainKey_H6 != 0) && (lparam == MainKey_H6)
        && ((((!ShiftRequired_H6) && (TerminalInfoInteger(TERMINAL_KEYSTATE_SHIFT) >= 0))   || ((ShiftRequired_H6) && (TerminalInfoInteger(TERMINAL_KEYSTATE_SHIFT) < 0))) // Shift
        &&  (((!CtrlRequired_H6)  && (TerminalInfoInteger(TERMINAL_KEYSTATE_CONTROL) >= 0)) || ((CtrlRequired_H6)  && (TerminalInfoInteger(TERMINAL_KEYSTATE_CONTROL) < 0)))) // Control
       )
    {
        ChartSetSymbolPeriod(ChartID(), Symbol(), PERIOD_H6);
    }
    else if ((MainKey_H8 != 0) && (lparam == MainKey_H8)
        && ((((!ShiftRequired_H8) && (TerminalInfoInteger(TERMINAL_KEYSTATE_SHIFT) >= 0))   || ((ShiftRequired_H8) && (TerminalInfoInteger(TERMINAL_KEYSTATE_SHIFT) < 0))) // Shift
        &&  (((!CtrlRequired_H8)  && (TerminalInfoInteger(TERMINAL_KEYSTATE_CONTROL) >= 0)) || ((CtrlRequired_H8)  && (TerminalInfoInteger(TERMINAL_KEYSTATE_CONTROL) < 0)))) // Control
       )
    {
        ChartSetSymbolPeriod(ChartID(), Symbol(), PERIOD_H8);
    }
    else if ((MainKey_H12 != 0) && (lparam == MainKey_H12)
        && ((((!ShiftRequired_H12) && (TerminalInfoInteger(TERMINAL_KEYSTATE_SHIFT) >= 0))   || ((ShiftRequired_H12) && (TerminalInfoInteger(TERMINAL_KEYSTATE_SHIFT) < 0))) // Shift
        &&  (((!CtrlRequired_H12)  && (TerminalInfoInteger(TERMINAL_KEYSTATE_CONTROL) >= 0)) || ((CtrlRequired_H12)  && (TerminalInfoInteger(TERMINAL_KEYSTATE_CONTROL) < 0)))) // Control
       )
    {
        ChartSetSymbolPeriod(ChartID(), Symbol(), PERIOD_H12);
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
    // MT5-specific:
    if ((s == "H12") || (s == "12-HOUR") || (s == "12H") || (s == "PERIOD_H12")) return PERIOD_H12;
    if ((s == "H8") || (s == "8-HOUR") || (s == "8H") || (s == "PERIOD_H8")) return PERIOD_H8;
    if ((s == "H6") || (s == "6-HOUR") || (s == "6H") || (s == "PERIOD_H6")) return PERIOD_H6;
    if ((s == "H3") || (s == "3-HOUR") || (s == "3H") || (s == "PERIOD_H3")) return PERIOD_H3;
    if ((s == "H2") || (s == "2-HOUR") || (s == "2H") || (s == "PERIOD_H2")) return PERIOD_H2;
    if ((s == "M20") || (s == "20M") || (s == "PERIOD_M20")) return PERIOD_M20;
    if ((s == "M12") || (s == "12M") || (s == "PERIOD_M12")) return PERIOD_M12;
    if ((s == "M10") || (s == "10M") || (s == "PERIOD_M10")) return PERIOD_M10;
    if ((s == "M6") || (s == "6M") || (s == "PERIOD_M6")) return PERIOD_M6;
    if ((s == "M4") || (s == "4M") || (s == "PERIOD_M4")) return PERIOD_M4;
    if ((s == "M3") || (s == "3M") || (s == "PERIOD_M3")) return PERIOD_M3;
    if ((s == "M2") || (s == "2M") || (s == "PERIOD_M2")) return PERIOD_M2;
    return PERIOD_CURRENT;
}
//+------------------------------------------------------------------+