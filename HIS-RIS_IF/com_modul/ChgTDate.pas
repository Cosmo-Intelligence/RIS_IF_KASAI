unit ChgTDate;
{
■機能説明
		日付処理関数
     	●日付形式文字列をTDateTime型（Double）に変換
      			func_SeirekiStrToDouble
      ●日付形式文字列が（西暦:'yyyy/mm/dd'）であるかチェック
      			func_StrSeirekiDateChk
     	●指定月の最大日数を取得
      			func_GetMaxDays
     	●指定年（西暦）を閏年かチェック
      			func_ChkLeapYear

■履歴
新規作成：99.07.15：担当 水野
修正：99.09.03：担当 水野
修正：00.04.28：担当 増田 func_SeirekiStrToDoubleのエラーメッセージを削除
}
interface //*****************************************************************
//使用ユニット---------------------------------------------------------------
uses
////型クラス宣言-------------------------------------------------------------
  Windows,
  Messages,
  SysUtils,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  IniFiles,
  FileCtrl,
  ExtCtrls,
  Gval;
//type
//定数宣言-------------------------------------------------------------------
const
  gdouble_ERRDATE: Double = -693594; // エラー時戻り値
  																	 // -693594 西暦前
//変数宣言-------------------------------------------------------------------
//var
//関数手続き宣言-------------------------------------------------------------
function func_SeirekiStrToDouble(arg_SStr: String):	Double;
function func_WarekiStrToDouble(arg_WStr: String;
																arg_wareki:TAarrayTStrings):	Double;
function func_StrSeirekiDateChk(arg_chkStr: String):	Boolean;
function func_GetMaxDays(arg_year: Integer; arg_mon: Integer): Integer;
function func_ChkLeapYear(arg_ChkYear: Integer):	Boolean;
function func_DateToWarekiStr(arg_Date:TDateTime;
															arg_wareki:TAarrayTStrings): String;

implementation //**************************************************************
//定数宣言       -------------------------------------------------------------
const
	wi_DATE_YEAR: Integer = 1899;
	wi_DATE_MON: Integer = 12;
	wi_DATE_DAY: Integer = 30;
{$HINTS OFF}
//関数手続き宣言--------------------------------------------------------------
//************************************************************
//●機能
//  		文字列（西暦）に該当するDouble（TDateTime型）を返す
//      arg_SStr := 'yyyy/mm/dd'（指定文字列）
//				注：時間の指定まではできない
//			エラー時   を返す
//************************************************************
function func_SeirekiStrToDouble(arg_SStr: String):	Double;
var
	wi,wi_year,wi_mon,wi_day,wi_Y_count: Integer;
  wr_ymd1,wr_ymd2,wr_wk1: Real;
begin

	Result := 0;

     //--- 指定文字列かチェック ---//
  if func_StrSeirekiDateChk(arg_SStr) then begin
  	try
    	wi_year := StrToInt(Copy(arg_SStr,1,4));
    	wi_mon := StrToInt(Copy(arg_SStr,6,2));
    	wi_day := StrToInt(Copy(arg_SStr,9,2));
    except
    	Result := gdouble_ERRDATE;
    	Exit;
    end;

    wr_ymd1 := (wi_DATE_YEAR * 10000) + (wi_DATE_MON * 100) + (wi_DATE_DAY);
    wr_ymd2 := (wi_year * 10000) + (wi_mon * 100) + (wi_day);
    wi_Y_count := wi_year - (wi_DATE_YEAR + 1);

    if wr_ymd1 > wr_ymd2 then begin
    	//--- 基準年（doble(0)）以前 ---//
      wr_wk1 := 0;
      for wi := -1 downto wi_Y_count do begin
      	//--- 年数分（基準年からの差）ループ ---//
      	if wi = wi_Y_count then begin
        	if func_ChkLeapYear(wi_year) and (wi_mon < 3) then
          	wr_wk1 := wr_wk1 - 1;
        	case wi_mon of
          	1:	wr_wk1 := wr_wk1 + (wi_day - 364);
            2:	wr_wk1 := wr_wk1 + (wi_day - 333);
            3:  wr_wk1 := wr_wk1 + (wi_day - 305);
            4:  wr_wk1 := wr_wk1 + (wi_day - 274);
            5:  wr_wk1 := wr_wk1 + (wi_day - 244);
            6:  wr_wk1 := wr_wk1 + (wi_day - 213);
            7:  wr_wk1 := wr_wk1 + (wi_day - 183);
            8:  wr_wk1 := wr_wk1 + (wi_day - 152);
            9:  wr_wk1 := wr_wk1 + (wi_day - 121);
            10: wr_wk1 := wr_wk1 + (wi_day - 91);
            11: wr_wk1 := wr_wk1 + (wi_day - 60);
            12: wr_wk1 := wr_wk1 + (wi_day - 30);
          end;
        end
        else begin
        	wr_wk1 := wr_wk1 - 365;
          if ((wi mod -4) = 0) and func_ChkLeapYear(wi_DATE_YEAR + 1 + wi) then
          	wr_wk1 := wr_wk1 - 1;
        end;
      end;
      Result := wr_wk1;
    end
    else if wr_ymd1 <> wr_ymd2 then begin
    	//--- 基準年（doble(0)）以降 ---//
    	wr_wk1 := 1;
    	for wi := 0 to wi_Y_count do begin
      	//--- 年数分（基準年からの差）ループ ---//
    		if wi_Y_count = wi then begin
        	if func_ChkLeapYear(wi_year) and (wi_mon > 2) then
          	wr_wk1 := wr_wk1 + 1;
      		case wi_mon of
        		1:	wr_wk1 := wr_wk1 + wi_day;
         		2:	wr_wk1 := wr_wk1 + wi_day + 31;
          	3:  wr_wk1 := wr_wk1 + wi_day + 59;
          	4:  wr_wk1 := wr_wk1 + wi_day + 90;
          	5:  wr_wk1 := wr_wk1 + wi_day + 120;
          	6:  wr_wk1 := wr_wk1 + wi_day + 151;
          	7:  wr_wk1 := wr_wk1 + wi_day + 181;
          	8:  wr_wk1 := wr_wk1 + wi_day + 212;
          	9:  wr_wk1 := wr_wk1 + wi_day + 243;
          	10: wr_wk1 := wr_wk1 + wi_day + 273;
          	11: wr_wk1 := wr_wk1 + wi_day + 304;
          	12: wr_wk1 := wr_wk1 + wi_day + 334;
        	end;
        end
        else begin
        	wr_wk1 := wr_wk1 + 365;
          if ((wi mod 4) = 0) and func_ChkLeapYear(wi_DATE_YEAR + 1 + wi) then
          	wr_wk1 := wr_wk1 + 1;
      	end;
      end;
      Result := wr_wk1;
 		end;
  end
  else begin
  	Result := gdouble_ERRDATE;
   { 00.04.28
    beep; 
    Application.MessageBox(PChar(arg_SStr + ' は、日付に変換できません'),
    				'ユニットChgTDate 関数func_SeirekiStrToDouble エラー',
            MB_ICONSTOP); }
  end;

end;
//************************************************************
// ●機能
//       文字列（和暦）に該当するDouble（TDateTime型）を返す
//      arg_WStr := 'ＧＧYY年MM月DD日'（指定文字列16桁）
//
//************************************************************
function func_WarekiStrToDouble(arg_WStr: String;
																arg_wareki:TAarrayTStrings): Double;
var
	ws_Gengo,ws_Sstr:String;
  wi,wi_w_y,wi_s_y:Integer;
begin
  try
  	wi_w_y := 0;
    wi_s_y := 0;
		ws_Gengo := Copy(arg_WStr,1,4);
    wi_w_y := StrToInt(Copy(arg_WStr,5,2));
  	for wi := 0 to High(arg_wareki) do
  		if arg_wareki[wi][2] = ws_Gengo then
      begin
      	wi_s_y := StrToInt(Copy(arg_wareki[wi][3],1,4));
      	Break;
    	end;

    ws_Sstr := Format('%0.4d',[wi_s_y + wi_w_y - 1]) + '/' +
      				 Copy(arg_WStr,9,2) + '/' + Copy(arg_WStr,13,2);
    result := func_SeirekiStrToDouble(ws_Sstr);
  except
  	raise;
  end;
end;
//************************************************************
//●機能
//  		文字列が（西暦:'yyyy/mm/dd'）であるかチェック
//      True / False
//************************************************************
function func_StrSeirekiDateChk(arg_chkStr: String):	Boolean;
var
	wi,wi_Y,wi_M,wi_D: Integer;
begin

	Result := True;
  if Length(arg_chkStr) <> 10 then begin
  	Result := False;
    Exit;
  end;

  try
		for wi := 1 to Length(arg_chkStr) do begin
    	Case wi of
      	1,2,3,4,6,7,9,10:
        begin
					if (integer(arg_chkStr[wi]) < 48) or (integer(arg_chkStr[wi]) > 57) then begin
      			Result := False;
    				Break;
    			end;
        end;
        5,8:
        begin
        	if arg_chkStr[wi] <> '/' then begin
      			Result := False;
    				Break;
          end;
        end;
      end;
  	end;
  except
  	Result := False;
  end;

  if Result then begin
  	try
    	wi_Y := StrToInt(Copy(arg_chkStr,1,4));
  		wi_M := StrToInt(Copy(arg_chkStr,6,2));
  		wi_D := StrToInt(Copy(arg_chkStr,9,2));
    except
    	Result := False;
      Exit;
    end;

  	if (wi_M < 1) or (wi_M > 12) then begin
    	Result := False;
      Exit;
    end;

    if (wi_D < 1) or (wi_D > func_GetMaxDays(wi_Y,wi_M)) then
    	Result := False;
  end;

end;
//************************************************************
//●機能
//  		閏年かチェックして月の最大日数を取得
//      	arg_year 西暦年を指定
//        arg_mon      月を指定
//************************************************************
function func_GetMaxDays(arg_year: Integer; arg_mon: Integer): Integer;
var
	wi_FbMaxDay: Integer;
begin

	Result := 31;

	if func_ChkLeapYear(arg_year) then
  	wi_FbMaxDay := 29
  else
  	wi_FbMaxDay := 28;

  Case arg_mon of
  	2:
    		Result := wi_FbMaxDay;
    4,6,9,11:
    		Result := 30;
  end;

end;
//************************************************************
//●機能
//  		閏年かチェック
//				arg_ChkYear 	西暦年を指定
//      	閏年：True	以外：False
//************************************************************
function func_ChkLeapYear(arg_ChkYear: Integer): Boolean;
begin

	Result := False;

  //--- 閏年チェック
	if (arg_ChkYear mod 4) = 0 then begin
  	Result := True;
    if ((arg_ChkYear mod 400) <> 0) and ((arg_ChkYear mod 100) = 0) then
    	Result := False;
  end;

end;
//************************************************************
//●機能
// 			日付型を文字列の和暦へ変換

//************************************************************
function func_DateToWarekiStr(arg_Date:TDateTime;
															arg_wareki:TAarrayTStrings): String;
var
	wi: Integer;
  wi_year1,wi_year2,wi_yyyymmdd1,wi_yyyymmdd2: Integer;
  ws_year: String;
begin

	try
		wi_year1 := StrToInt(FormatDateTime('yyyy',arg_Date));
  	wi_yyyymmdd1 := StrToInt(FormatDateTime('yyyymmdd',arg_Date));

		for wi := 0 to High(arg_wareki) do begin
    	wi_yyyymmdd2 := StrToInt(Copy(arg_wareki[wi][3],1,4) +
    									Copy(arg_wareki[wi][3],6,2) +
                    	Copy(arg_wareki[wi][3],9,2));
  		if wi_yyyymmdd2 > wi_yyyymmdd1 then
    		Break;
  	end;

  	if wi > 0 then wi := wi - 1;

  	wi_year2 := StrToInt(Copy(arg_wareki[wi][3],1,4));
  	ws_year := IntToStr((wi_year1 - wi_year2) + 1);
  	if Length(ws_year) = 1 then ws_year := '0' + ws_year;

  	Result := arg_wareki[wi][2] + ws_year + FormatDateTime('"年"mm"月"dd"日"',arg_Date);
  except
  	Result := '';
  end;
end;

initialization
begin
//
end;

finalization
begin
//
end;

end.
