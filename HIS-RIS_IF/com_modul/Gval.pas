unit Gval;
{
■機能説明
－グローバル変数と共通関数のユニット
  他の開発Ｕｎｉｔより先にUSESする(一番最初にUSES)
－グローバル変数
  －起動PATH等
－共通関数
  追加するのは自由です。みんなで使えそうなのはドンドン追加して下さい。
  ただし、
  ■共通関数の機能仕様
  ■履歴
  に、必ず追加記述して下さい。
  追加する前に属性を変えて、追加後に元に戻してください 

■共通関数の機能仕様－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－
●機能:文字列を空判定する（ '' or '  '）
function func_IsNullStr(arg_Str: string):Boolean;
● DBからシステム日付時刻を取得する(LOWLEVEL)HILEVELはDB_ACCのfunc_DBSysDate
function  func_GetDBSysDate(
   arg_Q_Pass:TQuery //DB接続済みのTQuery
   ):TDateTime;
● バリアントNULLを空文字列に変換。
function func_VarToString(
   arg_VarString: Variant //文字列のvariant
           ):string;
● プログラムの起動。
function func_WinExec(
   arg_ExeFile: string; //EXEファイル名 フルパス指定
   arg_CmdLine: string; //コマンドライン
           );
● プログラムの起動。終了を待つ
function func_WinExecWait(
    arg_ExeFile: string;
    arg_CmdLine: string
    ):Boolean;
● 指定時間待ち。
procedure proc_delay(
   arg_timer: DWORD MSEC単位の待ち時間
           );
● 文字列を右から取り出す。
function Right(
   const s:String;元文字列
   l:integer      取り出す長さ
   ):string;      結果文字列
● 文字列を左から取り出す。
function Left(
   const s:String;元文字列
   l:integer      取り出す長さ
   ):string;      結果文字列
● STRINGからTStringListを作成する。
function func_StrToTStrList(
   arg_Value: string 文字列
   ):TStrings;
● TStringListからSTRINGを取り出す。
function func_TStrListToStr(
   Value: TStrings 元値
   ):string;
//●両端に空白をつけた文字列を作成する。（元の文字列削除あり）
function func_UnTrim(
   arg_Str: string; 元の文字列
   arg_BLen:integer ﾊﾞｲﾄ単位の全体の文字列長
   ):string;
//●両端に空白をつけた文字列を作成する。
function func_UnTrim2(
   arg_Str: string;  //元の文字列
   arg_BLen:integer  //両端の空白の長さ
   ):String;         //
//●両端に空白をつけた文字列を作成する。（元の文字列削除なし）
function func_UnTrim3(
   arg_Str: string;  //元の文字列
   arg_BLen:integer  //ﾊﾞｲﾄ単位の全体の文字列長
   ):String;         //

●文字列をﾊﾞｲﾄ単位で複写するただしかけ文字は除く
function func_BCopy(
   arg_Str: string;対象の文字列
   arg_BLen:integer長さ
   );String;       結果文字列

function func_LeftSpace(
                 intCapa : Integer;
                 EditStr : String
                 ): String;
function func_RigthSpace(
                 intCapa : Integer;
                 EditStr : String
                 ): String;
●現ｺﾝﾋﾟｭｰﾀ名称を取得する（１５ﾊﾞｲﾄ）
function func_GetMachineName:string;

●生年月日と日付を元に年齢を計算する
function func_GetAge(
   arg_BirthDay:date; //誕生日
   arg_Day:date       //日付
  ):integer;          //満年齢
●日付を変換する
function func_ChngDate(
   arg_Day:Tdate;  //変換前値
   arg_Case:integer//基準
   0:JUSIN_D      そのまま
   1:JUSIN_D0401  年度始め
   2:JUSIN_DN0331 年度末
   3:JUSIN_D1231  年末
   4:JUSIN_D0101  年始
   5:JUSIN_DN0101 来年始
   6:JUSIN_D01    月初
   7:JUSIN_DME    月末
   ):TDate; 変換後値

●基準から4/1年度日付に変換
function func_ChngDate41(
   arg_Day:Tdate 変換前値
     ):Tdate;    変換後値

●生年月日と日付と基準を元に年齢を計算する
function func_GetAgeofCase(
   arg_BirthDay:date; //誕生日
   arg_Day:date;      //日付
   arg_Case:integer   //基準
   0:JUSIN_D      そのまま
   1:JUSIN_D0401  年度始め
   2:JUSIN_DN0331 年度末
   3:JUSIN_D1231  年末
   4:JUSIN_D0101  年始
   5:JUSIN_DN0101 来年始
   6:JUSIN_D01    月初
   7:JUSIN_DME    月末
  ):integer;          //満年齢

//●日付文字列を日付にする
function func_StrToDate(
   arg_Str: string; 元の文字列
  ):TDate;          //日付

//●日付文字列を日付時刻にする
function func_StrToDateTime(
   arg_Str: string; 日付の文字列
  ):TDateTime;          //日付

//●日付を日付文字列にする
function func_DateToStr(
   arg_Date: TDate; 日付の文字列
  ):string;          //日付

//●日付時刻を日付文字列にする
function func_DateTimeToStr(
   arg_Date: TDateTime; 日付の文字列
  ):string;          //日付

//●日付を最終時刻にする
function func_DateToLastTime(
   arg_Date: TDate;     //日付
  ):TDateTime;          //日付時刻

//●日付を最初時刻にする
function func_DateToFirstTime(
   arg_Date: TDate;     //日付
  ):TDateTime;          //日付時刻

//●日付文字YYYY/MM/DDを日付文字YYYYMMDDにする
function func_Date10ToDate8(
   arg_Date10: string// 日付の文字列 YYYY/MM/DD 以外はエラー
  ):string;          //日付 エラーは ''文字

//●日付文字YYYYMMDDを日付文字YYYY/MM/DDにする
function func_Date8ToDate10(
   arg_Date8: string// 日付の文字列  YYYYMMDD 以外はエラー
  ):string;          //日付  エラーは ''文字

//●時刻文字HHMMSSを時刻文字HH:MM:SSにする
function func_Time6To8(
   arg_Data: string// 日付の文字列  HHMMSS 以外はエラー
  ):string;          //日付  エラーは ''文字

//●時刻文字HH:MM:SSを時刻文字HHMMSSにする
function func_Time8To6(
   arg_Data: string// 日付の文字列  HH:MM:SS 以外はエラー
  ):string;          //日付  エラーは ''文字

//●フォルダを作成する
function func_MakeDirectories(
   arg_Directory: string;   //作成フォルダ
   arg_FileDelete: integer; //ファイル削除フラグ(０：なし、１：あり)
  ):Boolean;                //復帰値
//●フォルダの全ファイルを削除する
function func_DeleteFileAt(
   arg_Directory: string;   //対象フォルダ
  ):Boolean;                //復帰値

//●メタファイル-->JPEGファイル
function func_MetafileToJpeg(
   arg_MetaFile: string;    //コピー元のメタファイル名
   arg_JpegFile: string;    //コピー先のJPEGファイル名
  ): Boolean;

//●JPEGファイル-->BMPファイル
function func_JpegfileToBmp(
   arg_JpegFile: string;    //コピー元のJPEGファイル名
   arg_BmpFile: string;     //コピー先のBMPファイル名
  ): Boolean;

//●ｳｨﾝﾄﾞｳのｾﾝﾀﾘﾝｸﾞ
procedure func_FromCenter(
   arg_Form: TForm; フォーム
  );
//●ファイルコピー
procedure proc_CopyFile( arg_SrcName: string; arg_DesName: string );
//●ﾃﾞｨﾚｸﾄﾘファイルコピー
procedure proc_CopyFileEx(
  arg_SrcName: string;
  arg_DesName: string);

//●小数点以下１位四捨五入 長整数  範囲有り
function Roundoff(X: Extended): Longint;
//●小数点以下１位四捨五入 実数    範囲有り
function RoundoffE(X: Extended): Extended;
//●小数点以下１位四捨五入 実数    範囲無し
function Roundoff2(X: Extended): Extended;
//●小数点以下１位四捨五入 文字列  範囲有り
function StrRoundoff(X: Extended): string;
//●文字列を実数に変換  カンマ三桁区切り対応
function MyStrToFload(X: string): Extended;
//●実数を文字列に変換  カンマ三桁区切り対応
function MyFloadToStr(X: Extended): string;
//●カンマを消去
function delcomm(X: string): string;
//●arg_str1がarg_str2の構成文字列だけで構成されるか
function func_IsInstr(arg_str1:string;arg_str2: string): BOOlean;
//●文字列を実数として変換可能か
function func_IsFloat(arg_str1:string): BOOlean;
//●ｳｨﾝﾄﾞｳのアラメント設定
procedure proc_FrmAlign(arg_Form: TForm; arg_Align:string   );
//●ファイルのサイズ取得
function func_FileSize(arg_FilePath: string): Longint;
//●ファイルの一覧取得
function func_FileList(arg_FilePath: string): TstringList;
//●コンピュータ名からIPアドレス取得
function func_MachineNameToIP(arg_MName:string):string;
//●IPアドレス取得
function func_GetThisMachineIPAdrr:string;
//●コンピュータ名取得
function func_GetThisMachineName:string;
//●文字列が数値のみかチェック
function func_IsNumber(arg_str1:string): Boolean;
//－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－
■履歴
新規作成：99.06.17：担当 iwai
修正    ：99.06.24：担当 iwai ｴﾗｰの追加
修正    ：99.07.07：担当 iwai 関数追加
修正    ：99.08.05：担当 iwai 年齢計算関数を追加
修正    ：99.09.14：担当 増田 TGridRectの名前変更(TGridRect1)
修正    ：99.09.16：担当 岩井 TGridRect TGridCoordのｺﾒﾝﾄｱｳﾄ
修正    ：99.11.19：担当 岩井 TDynamicStringArrayの追加
修正    ：99.11.26：担当 岩井 文字列空判定の関数を追加
修正    ：2000.01.6：担当 岩井
 function func_GetAgeで年を取出す関数を２桁用から４桁用に変更
  StrToDate/StrToDateTime/DateToStr/DateTimeToStr
 は２桁のみと判明
  DateTimeToString／FormatDateTime／func_StrToDate
 は４けた
  func_StrToDateを追加
修正    ：2000.01.20：担当 岩井
日付変換関数func_ChngDateとfunc_ChngDate41を追加

修正    ：2000.01.31：担当 岩井
GetMachinName2を追加（DBの定義10ﾊﾞｲﾄとあわせるため）
修正    ：2000.04.03：担当 岩井
func_StrToDateを時間まで対応させる
★修正    ：2000.04.11：担当 岩井
新規開発着手
ini情報をINITINF.PASに移設
修正    ：2000.05.01：担当 岩井
function func_StrToDateTime( arg_Str: string  ):TDateTime;
function func_DateTimeToStr(arg_Date: TDateTime  ):string;
function func_DateToStr( arg_Date: TDate  ):string;
を追加
修正    ：2000.05.09：担当 岩井
function func_DateToFirstTime ( arg_Date: TDate ):TDateTime;
function func_DateToLastTime  ( arg_Date: TDate ):TDateTime;
を追加
修正    ：2000.05.11：担当 岩井
function func_UnTrim2(arg_Str: string;arg_BLen:integer):String;
function func_UnTrim3(arg_Str: string;arg_BLen:integer):String;
修正    ：2000.05.24：担当 杉山
function func_MakeDirectories(arg_Directory: string; arg_FileDelete: integer):Boolean;
function func_DeleteFileAt(arg_Directory: string):Boolean;
を追加
修正    ：2000.05.25：担当 山中
function func_JpegfileToBmp(arg_JpegFile: string; arg_BmpFile: string;): Boolean;
を追加
修正    ：2000.08.15：担当 岩井
proc_CopyFile proc_CopyFileEx を追加
修正    ：2000.09.01：担当 岩井
function Roundoff(X: Extended): Longint;
function StrRoundoff(X: Extended): string;
function MyStrToFload(X: string): Extended;
function delcomm(X: string): string;
function func_IsInstr(arg_str1:string;arg_str2: string): BOOlean;
function func_IsFloat(arg_str1:string): BOOlean;
 を追加
修正    ：2000.10.10：担当 岩井
function RoundoffE(X: Extended): Extended;
function MyFloadToStr(X: Extended): string;
 を追加
修正    ：2000.11.01：担当 岩井
procedure proc_FrmAlign(arg_Form: TForm; arg_Align:string   );
function func_FileSize(arg_FilePath: string): Longint;
function func_FileList(arg_FilePath: string): TstringList;
追加
修正    ：2000.11.13：担当 岩井
function func_MachineNameToIP(arg_MName:string):string;
function func_GetThisMachineIPAdrr:string;
function func_GetThisMachineName:string;
function func_WinExecWait(arg_ExeFile: string; arg_CmdLine: string):Boolean;
func_Date8To10
func_Date10To8
func_Time6To8
func_Time8To6
修正    ：2001.03.19：担当 杉山
function func_IsNumber(arg_str1:string): Boolean;
追加
修正    ：2001.10.24：担当 iwai
func_BCopyのバグ修正
追加：2003.03.11●プロセスを完全停止せずに待ち受けを行う
function WaitTime(const t: integer): Boolean;
}

interface  //*****************************************************************
//使用ユニット---------------------------------------------------------------
 uses
//システム－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－
  Windows,
  Messages,
  SysUtils,
  Classes,
  DBTables,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  IniFiles,
  FileCtrl,
  Registry,
  ExtCtrls,
  Math,
  WinSock,
  Jpeg,
  Variants,
  Unit_Log, Unit_DB;

//型クラス宣言-----------------------------------------------------------
 //主にパラメタ復帰値など値の受け渡しで使用する．
 type
    TAarrayTStrings = array of TStrings;
    TDynamicStringArray = array of String;
    T_ErrSysExcep  = class(Exception);

//定数宣言-----------------------------------------------------------
 const
 //ウィンドウ位置
 g_WIN_ALIMENT_TOP    = 'T' ; //
 g_WIN_ALIMENT_BOTTOM = 'B' ; //
 g_WIN_ALIMENT_RIGTH  = 'R' ; //
 g_WIN_ALIMENT_LEFT   = 'L' ; //
 g_WIN_ALIMENT_TR     = g_WIN_ALIMENT_TOP   + g_WIN_ALIMENT_RIGTH; //TopRight/
 g_WIN_ALIMENT_TL     = g_WIN_ALIMENT_TOP   + g_WIN_ALIMENT_LEFT ; //TopLeft
 g_WIN_ALIMENT_BR     = g_WIN_ALIMENT_BOTTOM+ g_WIN_ALIMENT_RIGTH; //BottomRight
 g_WIN_ALIMENT_BL     = g_WIN_ALIMENT_BOTTOM+ g_WIN_ALIMENT_LEFT ; //BottomLeft
 //長さ
 g_PROCIDLEN = 8;//プログラムIDの長さ
 g_PrgID_BASE =3;//プログラムIDの位置
 //年齢計算基準タイプ
 JUSIN_D      = 0;
 JUSIN_D0401  = 1;
 JUSIN_DN0331 = 2;
 JUSIN_D1231  = 3;
 JUSIN_D0101  = 4;
 JUSIN_DN0101 = 5;
 JUSIN_D01    = 6;
 JUSIN_DME    = 7;
 gval_datefmtYY  = 'yyyy';           //日付のﾌｫｰﾏｯﾄ形式
 gval_datefmtMM  = 'mm';             //日付のﾌｫｰﾏｯﾄ形式
 gval_datefmtDD  = 'dd';             //日付のﾌｫｰﾏｯﾄ形式
 gval_timefmtHH  = 'hh';             //日付のﾌｫｰﾏｯﾄ形式
 gval_timefmtNN  = 'nn';             //日付のﾌｫｰﾏｯﾄ形式
 gval_timefmtSS  = 'ss';             //日付のﾌｫｰﾏｯﾄ形式
 //MRDrawの戻り値(00.05.24 杉山)
 WM_SCHEMAEDITOREXIT = WM_USER + 1000;

//変数宣言-----------------------------------------------------------
 var
//＊＊ 以下のグーバル変数はアプリケーション実行時のみ有効＊＊
   gval_datefmt: string ;
   gval_datetimefmt: string ;
   G_RunPath: string ; //起動PASS アプリケーションの実行パス
   G_EnvPath: string ; //環境パス コマンドライン指定のPASS または
                       //         起動PASS
   g_DB_CONECT_MAX:integer;   //DB初期接続最大数
   g_PC_Name:string;        //端末名
   g_CrntUserID:string ;       //UID
   g_CrntUserPassWord:string ; //PASSWORD
   g_Save_Cursor:TCursor;
//2001.02.09
   g_CrntUserCLS:string ;      //権限
//2002.12.09
   g_CrntUserCode:string ;     //ログイン職員ID

  //ログ
  FLog:         T_FileLog;
  FDebug:       T_FileLog;

  //DB
  FDB:          T_DB;
  FQ_SEL:       T_Query;
  FQ_SEL_ORD:   T_Query;
  FQ_SEL_BUI:   T_Query;
  FQ_ALT:       T_Query;

//関数手続き宣言--------------------------------------------------------------
function func_IsNullStr(arg_Str: string):Boolean;
function func_GetDBSysDate(arg_Q_Pass:TQuery):TDateTime;
function func_VarToString( arg_VarString: Variant ):string;
function func_WinExec(arg_ExeFile: string; arg_CmdLine: string):Boolean;
function func_WinExecWait(arg_ExeFile: string; arg_CmdLine: string):Boolean;
function Right(const s:String; l:integer):string;
function Left(const s:String; l:integer):string;
function func_StrToTStrList(arg_Value: string):TStrings;
function func_TStrListToStr(Value: TStrings):string;
function func_UnTrim(arg_Str: string;arg_BLen:integer):string;
function func_UnTrim2(arg_Str: string;arg_BLen:integer):String;
function func_UnTrim3(arg_Str: string;arg_BLen:integer):String;
function func_BCopy(arg_Str: string;arg_BLen:integer):string;
function func_LeftSpace(
                 intCapa : Integer;
                 EditStr : String
                 ): String;
function func_RigthSpace(
                 intCapa : Integer;
                 EditStr : String
                 ): String;
function func_GetMachineName:string;
function func_GetMachineName2:string;

function func_GetAge(arg_BirthDay:Tdate; arg_Day:Tdate):integer;
function func_ChngDate(arg_Day:Tdate; arg_Case:integer  ):TDate;
function func_GetAgeofCase(arg_BirthDay:Tdate; arg_Day:Tdate; arg_Case:integer ):integer;
function func_ChngDate41(arg_Day:Tdate  ):Tdate;
function func_StrToDate( arg_Str: string  ):TDate;
function func_StrToDateTime( arg_Str: string  ):TDateTime;
function func_DateTimeToStr(arg_Date: TDateTime  ):string;
function func_DateToStr( arg_Date: TDate  ):string;
function func_DateToFirstTime ( arg_Date: TDate ):TDateTime;
function func_DateToLastTime  ( arg_Date: TDate ):TDateTime;
procedure proc_delay(arg_timer: DWORD);
procedure proc_FrmCenter(arg_Form: TForm   );
procedure proc_FrmAlign(arg_Form: TForm; arg_Align:string   );


function func_MakeDirectories(arg_Directory: string; arg_FileDelete: integer):Boolean;
function func_DeleteFileAt(arg_Directory: string):Boolean;

function func_MetafileToJpeg(arg_MetaFile: string;arg_JpegFile: string): Boolean;
function func_JpegfileToBmp(arg_JpegFile: string;arg_BmpFile: string): Boolean;

procedure proc_CopyFile( arg_SrcName: string; arg_DesName: string );
procedure proc_CopyFileEx(
  arg_SrcName: string;
  arg_DesName: string);
function Roundoff(X: Extended): Longint;
function RoundoffE(X: Extended): Extended;
{00.09.09}
function Roundoff2(X: Extended): Extended;
function StrRoundoff(X: Extended): string;
function MyStrToFload(X: string): Extended;
function MyFloadToStr(X: Extended): string;
function delcomm(X: string): string;
function func_IsInstr(arg_str1:string;arg_str2: string): BOOlean;
function func_IsFloat(arg_str1:string): BOOlean;
function func_FileSize(arg_FilePath: string): Longint;
function func_FileList(arg_FilePath: string): TstringList;
function func_MachineNameToIP(arg_MName:string):string;
function func_GetThisMachineIPAdrr:string;
function func_GetThisMachineName:string;

function func_Date10To8(arg_Date10: string ):string;
function func_Date8To10(arg_Date8: string ):string;
function func_Time6To8(arg_Data: string ):string;
function func_Time8To6(arg_Data: string ):string;

//●プロセスを完全停止せずに待ち受けを行う
function WaitTime(const t,s: integer): Boolean;

//一応動作するが不完全
function func_ComponentToString(Component: TComponent): string;
function func_StringToComponent(Value: string): TComponent;

function func_IsNumber(arg_str1:string): Boolean;
function func_LeftZero( intCapa : Integer ; EditStr : String  ): String;

implementation //**************************************************************

//変数宣言-----------------------------------------------------------
//var
//定数宣言       -------------------------------------------------------------
// const
{
}

//関数手続き宣言--------------------------------------------------------------
//●時刻文字HHMMSSを時刻文字HH:MM:SSにする
function func_Time6To8(
   arg_Data: string// 日付の文字列
  ):string;          //日付
var
  w_s:string;
begin
  if length(arg_Data)<>6 then
  begin
    result:='';
    exit;
  end;
  w_s:=copy(arg_Data,1,2) + TimeSeparator + copy(arg_Data,3,2) + TimeSeparator + copy(arg_Data,5,2);
  result:=w_s;
end;
//●時刻文字HH:MM:SSを時刻文字HHMMSSにする
function func_Time8To6(
   arg_Data: string// 日付の文字列
  ):string;          //日付
var
  w_s:string;
begin
  if length(arg_Data)<>8 then
  begin
    result:='';
    exit;
  end;
  w_s:=copy(arg_Data,1,2) + copy(arg_Data,4,2) + copy(arg_Data,7,2);
  result:=w_s;
end;

//●日付文字YYYYMMDDを日付文字YYYY/MM/DDにする
function func_Date8To10(
   arg_Date8: string// 日付の文字列
  ):string;          //日付
var
  w_s:string;
begin
  if length(arg_Date8)<>8 then
  begin
    result:='';
    exit;
  end;
  w_s:=copy(arg_Date8,1,4) + DateSeparator + copy(arg_Date8,5,2) + DateSeparator + copy(arg_Date8,7,2);
  result:=w_s;
end;
//●日付文字YYYY/MM/DDを日付文字YYYYMMDDにする
function func_Date10To8(
   arg_Date10: string// 日付の文字列
  ):string;          //日付
var
  w_s:string;
begin
  if length(arg_Date10)<>10 then
  begin
    result:='';
    exit;
  end;
  w_s:=copy(arg_Date10,1,4) + copy(arg_Date10,6,2) +  copy(arg_Date10,9,2);
  result:=w_s;
end;

//●ファイルの一覧取得
{$HINTS OFF}
function func_FileList(arg_FilePath: string): TstringList;
var
  w_FileName:string;
  w_Sr:TSearchRec;
  w_FileAttrs: Integer;
begin
  Result := TStringList.Create;
  w_FileAttrs:=faReadOnly+faHidden+faSysFile+faVolumeID+faArchive;
  if FindFirst(arg_FilePath, w_FileAttrs, w_Sr) = 0 then
  begin
    repeat
      w_FileName:=w_Sr.Name;
      Result.Add(w_FileName);
    until FindNext(w_Sr) <> 0;
    FindClose(w_Sr);
  end;
end;
{$HINTS ON}

//●ファイルのサイズ取得
{$HINTS OFF}
function func_FileSize(arg_FilePath: string): Longint;
var
  w_f: file of Byte;
  size : Longint;
begin
  result:=0;
  {$I-}
    AssignFile(w_f, arg_FilePath);
    Reset(w_f);
    size := FileSize(w_f);
    CloseFile(w_f);
  {$I+}
  result:=size;
end;
{$HINTS ON}

//●arg_str1がarg_str2の構成文字列だけで構成されるか
function func_IsInstr(arg_str1:string;arg_str2: string): BOOlean;
var
 w_s:string;
 w_i:integer;
begin
  result:=true;
  for w_i:=1 to length(arg_str1) do
  begin
     w_s:=Copy(arg_str1,w_i,1) ;
     if 0=Pos(w_s,arg_str2) then
     begin
       result:=false;
       exit
     end;
  end;
end;

//●文字列を実数として変換可能か
function func_IsFloat(arg_str1:string): BOOlean;
begin
  result:=func_IsInstr(arg_str1,'+-0123456789E,.');
end;

{$HINTS OFF}
//●文字列が数値のみかチェック
function func_IsNumber(arg_str1:string): Boolean;
var
  I,Code: integer;
begin
  Val(arg_str1, I, Code);
  if Code<>0 then
    result:=false
  else
    result:=true;
end;
{$HINTS ON}

//●カンマを消去
function delcomm(X: string): string;
begin
  while  AnsiPos(',',X)> 0 do
  begin
     delete(X,AnsiPos(',',X),1);
  end;
  result:=x;
end;

//●実数を文字列に変換  カンマ三桁区切り対応
function MyFloadToStr(X: Extended): string;
begin
  Result := FormatFloat('###,###,###,###,###,##0',X);
end;

//●文字列を実数に変換  カンマ三桁区切り対応
function MyStrToFload(X: string): Extended;
begin
  try
    x:=delcomm(x);
    if length(Trim(x)) > 0 then
    begin
      result:=StrToFloat(x);
    end else
    begin
      result:=0;
    end;
  except
    result:=0;
    exit;
  end;
end;

//●小数点以下１位四捨五入
function Roundoff(X: Extended): Longint;
var
   w_Maxinteger:Extended;
   w_Mininteger:Extended;
begin
  w_Maxinteger:= 2147483646;
  w_Mininteger:=-2147483647;
  x:=min(max(x,w_Mininteger),w_Maxinteger);

  if x >= 0 then
  begin
    Result := Trunc(min(max((x + 0.5),w_Mininteger),w_Maxinteger));
  end
  else
  begin
    Result := Trunc(min(max((x - 0.5),w_Mininteger),w_Maxinteger));
  end;
end;

//●小数点以下１位四捨五入
function RoundoffE(X: Extended): Extended;
var
   w_Maxinteger:Extended;
   w_Mininteger:Extended;
begin
  w_Maxinteger:=  9223372036854775;
  w_Mininteger:= -9223372036854775;
  x:=min(max(x,w_Mininteger),w_Maxinteger);

  if x >= 0 then
  begin
    Result := Trunc(min(max((x + 0.5),w_Mininteger),w_Maxinteger));
  end
  else
  begin
    Result := Trunc(min(max((x - 0.5),w_Mininteger),w_Maxinteger));
  end;
end;

function StrRoundoff(X: Extended): string;
var
  y: Extended;
   w_MaxExtended:Extended;
   w_MinExtended:Extended;
begin
  w_MaxExtended := 9223372036854775;//1.7 * Power(10,308) ;
  w_MinExtended :=-9223372036854775;//5.0 * Power(10,-324);
  if x >= 0 then
  begin
    y := Trunc(min(max((x + 0.5),w_MinExtended),w_MaxExtended) );
  end
  else
  begin
    y := Trunc(min(max((x - 0.5),w_MinExtended),w_MaxExtended) );
  end;
  Result := FormatFloat('###,###,###,###,###,##0',y);
end;

//●小数点以下１位四捨五入
function Roundoff2(X: Extended): Extended;
begin
  if x >= 0 then Result := Trunc(x + 0.5)
  else Result := Trunc(x - 0.5);
end;
//●日付を最初時刻にする
function func_DateToFirstTime(
   arg_Date: TDate     //日付
  ):TDateTime;          //日付時刻
var
  w_s:string;
begin
   w_s := func_DateToStr(arg_Date) + ' ' ;
   w_s := w_s + '00' + TimeSeparator;
   w_s := w_s + '00' + TimeSeparator;
   w_s := w_s + '00' ;
   result:=func_StrToDateTime( w_s );
end;

//●日付を最終時刻にする
function func_DateToLastTime(
   arg_Date: TDate     //日付
  ):TDateTime;          //日付時刻
var
  w_s:string;
begin
   w_s := func_DateToStr(arg_Date) + ' ' ;
   w_s := w_s + '23' + TimeSeparator;
   w_s := w_s + '59' + TimeSeparator;
   w_s := w_s + '59' ;
   result:=func_StrToDateTime( w_s );
end;

//●日付時刻を日付文字列にする
function func_DateTimeToStr(
   arg_Date: TDateTime// 日付の文字列
  ):string;          //日付
begin
  result:=FormatDateTime(gval_datetimefmt,arg_Date);
end;
//●日付を日付文字列にする
function func_DateToStr(
   arg_Date: TDate //日付
  ):string;          //
begin
  result:=FormatDateTime(gval_datefmt,arg_Date);
end;
//●日付文字列を日付時刻にする
function func_StrToDateTime(
   arg_Str: string //日付の文字列
  ):TDateTime;          //日付
var
  rtDateTime:TDateTime;
  w_Str:string;
begin
     w_Str:=arg_Str;
     rtDateTime:=func_StrToDate(w_Str);
     Delete(w_Str,1,11);
     rtDateTime:= rtDateTime + StrToTime(w_Str);
     result:=rtDateTime;
end;
//●日付文字列を日付にする
function func_StrToDate(
   arg_Str: string //元の文字列
  ):TDate;          //満年齢
var
  w_Date:TDate;
  w_Str:string;

  wi_yy:integer;
  wi_mm:integer;
  ws_yy:string;
  ws_mm:string;
  ws_dd:string;
  w_yy:word;
  w_mm:word;
  w_dd:word;
begin
  w_yy:=0;
  w_mm:=0;
  w_dd:=0;
  w_Str := arg_Str;
  wi_yy:=Pos(DateSeparator,w_Str) ;
  if wi_yy > 0 then
  begin
    ws_yy:=Copy(arg_Str,1,wi_yy - 1);
    w_yy:=StrToIntDef(ws_yy,0);
    Delete(w_Str,1,wi_yy);
    wi_mm:=Pos(DateSeparator,w_Str) ;
    if wi_mm > 0 then
    begin
      ws_mm:=Copy(w_Str,1,wi_mm - 1);
      w_mm:=StrToIntDef(ws_mm,0);
      Delete(w_Str,1,wi_mm);
      ws_dd := Copy(w_Str,1,2); //時間対応のため追加
      w_dd:=StrToIntDef(ws_dd,0);
    end;
  end;
  w_Date:=EncodeDate(w_yy,w_mm,w_dd);
  result := w_Date; //
end;

//●機能:文字列を空判定する（ '' or '  '）
function func_IsNullStr(arg_Str: string):Boolean;
begin
result:=false;
if length(trim(arg_Str)) = 0 then result:=true;
end;

//●機能:DBのシステム時間
function  func_GetDBSysDate(arg_Q_Pass:TQuery):TDateTime;
//res:string
begin
   arg_Q_Pass.close;
   arg_Q_Pass.SQL.Clear;
   arg_Q_Pass.SQL.Add('SELECT SYSDATE FROM DUAL');
   arg_Q_Pass.Prepare;
   arg_Q_Pass.Open;
   result := arg_Q_Pass.FieldValues['SYSDATE']
end;

//● バリアントNULLを空文字列に変換。
function func_VarToString( arg_VarString: Variant ):string;
begin
  if VarIsNull(arg_VarString) then
    result := ''
  else if VarType(arg_VarString) and varTypeMask = varString then
    result := VarAsType(arg_VarString,varString)
  else
    result := '';
end;

//●機能プロセスの実行(終了を待つ)
//Error:なし 例外
{$HINTS OFF}
function func_WinExecWait(arg_ExeFile: string; arg_CmdLine: string):Boolean;
var
  StartInfo: TStartupInfo;
  ProcInfo: TProcessInformation;
  w_Param:string;
begin
  result:=false;

 //構造体の初期化

  FillChar(StartInfo, SizeOf(TStartupInfo), 0);
  FillChar(ProcInfo, SizeOf(TProcessInformation), 0);
  w_Param:=arg_ExeFile + ' ' + arg_CmdLine;
 //メンバの設定

  StartInfo.dwFlags:= STARTF_USESHOWWINDOW;
  StartInfo.wShowWindow:= SW_SHOWNORMAL;

 //プロセスの生成
  result:=CreateProcess(nil,
                        PChar(w_Param),
                        nil,
                        nil,
                        false,
                        NORMAL_PRIORITY_CLASS,
                        nil,
                        nil,
                        StartINfo,
                        ProcINfo);


  //プロセスの終了を待つ時
  if result then
  begin
    while WaitForSingleObject(ProcINfo.hProcess,0) = WAIT_TIMEOUT Do
       Application.ProcessMessages;
    CloseHandle(ProcINfo.hProcess);
  end;



end;
{$HINTS ON}
//●機能プロセスの実行
//Error:なし 例外
{$HINTS OFF}
function func_WinExec(arg_ExeFile: string; arg_CmdLine: string):Boolean;
var
  StartInfo: TStartupInfo;
  ProcInfo: TProcessInformation;
  w_Param:string;
begin
  result:=false;

 //構造体の初期化

  FillChar(StartInfo, SizeOf(TStartupInfo), 0);
  FillChar(ProcInfo, SizeOf(TProcessInformation), 0);
  w_Param:=arg_ExeFile + ' ' + arg_CmdLine;
 //メンバの設定

  StartInfo.dwFlags:= STARTF_USESHOWWINDOW;
  StartInfo.wShowWindow:= SW_SHOWNORMAL;

 //プロセスの生成
  result:=CreateProcess(nil,
                        PChar(w_Param),
                        nil,
                        nil,
                        false,
                        NORMAL_PRIORITY_CLASS,
                        nil,
                        nil,
                        StartINfo,
                        ProcINfo);

end;
{$HINTS ON}

procedure proc_FrmCenter(   arg_Form: TForm   );
begin
  arg_Form.left := (screen.Width  - arg_Form.Width  ) div 2;
  arg_Form.top  := (screen.Height - arg_Form.Height ) div 2;

end;
procedure proc_FrmAlign(arg_Form: TForm; arg_Align:string   );
begin
  if func_IsNullStr(arg_Align)
     and (not(arg_Align = g_WIN_ALIMENT_TR))
     and (not(arg_Align = g_WIN_ALIMENT_TL))
     and (not(arg_Align = g_WIN_ALIMENT_BR))
     and (not(arg_Align = g_WIN_ALIMENT_BL))
  then
  begin
  //無指定はなにもしない
//    arg_Form.left := (screen.Width  - arg_Form.Width  ) div 2;
//    arg_Form.top  := (screen.Height - arg_Form.Height ) div 2;
    exit;
  end;
  if  arg_Align[1]=g_WIN_ALIMENT_TOP then
  begin
     arg_Form.top  := 0;
  end;
  if  arg_Align[1]=g_WIN_ALIMENT_BOTTOM then
  begin
     arg_Form.top  := screen.Height - arg_Form.Height;
  end;
  if  arg_Align[2]=g_WIN_ALIMENT_LEFT then
  begin
     arg_Form.left  := 0;
  end;
  if  arg_Align[2]=g_WIN_ALIMENT_RIGTH then
  begin
     arg_Form.left  := screen.Width - arg_Form.Width;
  end;

end;


//●機能時間待ち
//Error:なし 例外
procedure proc_delay( arg_timer: DWORD);
var w_finish:DWORD;
begin
  w_finish:= GetTickCount +  arg_timer;
  repeat
    Application.ProcessMessages
  until GetTickCount > w_finish
end;
//●機能VBのRight()のエンハンス
//Error:bottom up 各種処理例外
function Right(const s:String; l:integer):string;
begin
  if  l>0 then
    if  Length(s) <l then Result := S
    else Result:=Copy(s,Length(s)-l+1,l)
  else Result:=''
end;
//●機能VBのLeft()のエンハンス
//Error:bottom up 各種処理例外
function Left(const s:String; l:integer):string;
begin
  Result:=Copy(s,1,l)
end;
//●機能コンポーネントを文字列に変換
//Error:bottom up 各種処理例外
function func_ComponentToString(Component: TComponent): string;

var
  BinStream:TMemoryStream;
  StrStream: TStringStream;
  s: string;
begin
  BinStream := TMemoryStream.Create;
  try
    StrStream := TStringStream.Create(s);
    try
      BinStream.WriteComponent(Component);
      BinStream.Seek(0, soFromBeginning);
      ObjectBinaryToText(BinStream, StrStream);
      StrStream.Seek(0, soFromBeginning);
      Result:= StrStream.DataString;
    finally
      StrStream.Free;
    end;

  finally
    BinStream.Free
  end;
end;
//●機能文字列をコンポーネントに変換
//Error:bottom up 各種処理例外
function func_StringToComponent(Value: string): TComponent;
var
  StrStream:TStringStream;
  BinStream: TMemoryStream;
begin
  StrStream := TStringStream.Create(Value);
  try
    BinStream := TMemoryStream.Create;
    try
      ObjectTextToBinary(StrStream, BinStream);
      BinStream.Seek(0, soFromBeginning);
      Result := BinStream.ReadComponent(nil);

    finally
      BinStream.Free;
    end;
  finally
    StrStream.Free;
  end;
end;

//●StringをTStringListに変換
//Error:bottom up 各種処理例外
function func_StrToTStrList(arg_Value: string):TStrings;
begin
  Result := TStringList.Create;
  Result.CommaText := arg_Value;
end;

//●TStringListをStringに変換
//Error:bottom up 各種処理例外
function func_TStrListToStr(Value: TStrings):string;
begin
  Result := Value.CommaText;
end;


//●arg_Strから途切れることの無いようにarg_BLenバイト以下の文字列を返す
//Error:No
function func_BCopy(arg_Str: string;arg_BLen:integer):String;
Var
w_i:integer;
w_R:string;
w_Rl:integer;
w_X:string;
w_Xl:integer;

begin
  Result:='';
  w_R:='';

  for w_i := 1 to length(WideString(arg_Str)) do
  begin
    w_X:=copy(WideString(arg_Str),w_i,1);
    w_Rl:=Length(AnsiString(w_R));
    w_Xl:=Length(AnsiString(w_X));
    if (w_Rl+w_Xl)>arg_BLen then break;
    w_R:=w_R + w_X;
  end;
   result:=w_R;
end;

{
-----------------------------------------------------------------------------
  名前 :func_LeftSpace
  引数 :
    intCapa:Integer バイト数
    EditStr:String  変更文字列
  復帰値：例外ない
  機能 :
    1. スペースを左側に必要分作成します。
 *
-----------------------------------------------------------------------------
}
function func_LeftSpace( intCapa : Integer ; EditStr : String  ): String;
var
  lp    : Integer;
  len   : Integer;
  wkbuf : String;   //合成した必要スペース
begin
  //スペースバイト数
  len := intCapa - Length(EditStr);
  //初期化
  wkBuf := '';
  //範囲内時
  if len > 0 then begin
    //スペースバイト数分の半角スペースの作成
    for lp := 1 to len do begin
      wkBuf := wkBuf + chr(32); //半角スペース
    end;
    //文字列と半角スペースの結合
    wkBuf := wkBuf+EditStr;
  //範囲オーバー時
  end else begin
    //範囲内に切り取り
    wkBuf := Copy(EditStr,1,intCapa);
  end;
  //戻り値
  Result := wkBuf;
end;
{
-----------------------------------------------------------------------------
  名前 :func_RigthSpace
  引数 :
    intCapa:Integer バイト数
    EditStr:String  変更文字列
  復帰値：例外ない
  機能 :
    1. スペースを右側に必要分作成します。
 *
-----------------------------------------------------------------------------
}
function func_RigthSpace( intCapa : Integer ; EditStr : String  ): String;
var
  lp    : Integer;
  len   : Integer;
  wkbuf : String;   //合成した必要スペース
begin
  //スペースバイト数
  len := intCapa - Length(EditStr);
  //初期化
  wkBuf := '';
  //範囲内時
  if len > 0 then begin
    //スペースバイト数分の半角スペースの作成
    for lp := 1 to len do begin
      wkBuf := wkBuf + chr(32); //半角スペース
    end;
    //文字列と半角スペースの結合
    wkBuf := EditStr + wkBuf;
  //範囲オーバー時
  end else begin
    //範囲内に切り取り
    wkBuf := TrimRight(func_BCopy(EditStr,intCapa));
    if Length(wkBuf) < intCapa then
    begin
      wkBuf := wkBuf + chr(32);
    end;
  end;
  //戻り値
  Result := wkBuf;
end;
//●TRIMの反対
//Error:No
function func_UnTrim(arg_Str: string;arg_BLen:integer):String;
Var
w_i,w_l:integer;
w_R:string;
begin
  Result:='';
  w_l:=Length(AnsiString(arg_Str));
  if w_l>= arg_BLen then
    w_R:= func_BCopy(arg_Str,arg_BLen)
  else
  begin
    w_i:=(arg_BLen - w_l) div 2;
    w_R:=StringOfChar(' ',w_i) + arg_Str + StringOfChar(' ',w_i +1);
    w_R:= func_BCopy(w_R,arg_BLen);
  end;
  Result:=w_R;
end;

function func_UnTrim2(arg_Str: string;arg_BLen:integer):String;
begin
  Result:=StringOfChar(' ',arg_BLen)
          + arg_Str
          + StringOfChar(' ',arg_BLen);
end;

function func_UnTrim3(arg_Str: string;arg_BLen:integer):String;
Var
w_i:integer;
begin
  w_i:= arg_BLen - length( AnsiString(arg_Str));
  if w_i<0 then w_i:=0;
  w_i:=w_i div 2;
  Result:=StringOfChar(' ',w_i)
          + arg_Str
          + StringOfChar(' ',w_i);
end;


//●コンピュータIPの取得
//復帰値：コンピュータ名
//Error:例外
function func_MachineNameToIP(arg_MName:string):string;
var
    wVersionReqested : WORD;
    wsaData : TWSAData;
    Status: Integer;
    s:array[0..255] of Char;
    p:PHostEnt;
    ip:PChar;
    w_s:string;
begin
  result :='';
  wVersionReqested := MAKEWORD(1,1);
  Status:=WSAStartup(wVersionReqested,wsaData);
  if Status<>0 then
  begin
    raise T_ErrSysExcep.Create(arg_MName + 'のIPアドレスは取得できません．');
    exit;
  end;
  try
     StrPCopy(s,arg_MName);
     p := GetHostByName(@s);
     if p<> nil then
     begin
       ip:= p^.h_addr_list^;
       w_s:=
            IntToStr(Integer(ip[0]))
           +'.'+IntToStr(Integer(ip[1]))
           +'.'+IntToStr(Integer(ip[2]))
           +'.'+IntToStr(Integer(ip[3]));
       result :=w_s;
     end;
  finally
  WSACleanup;
  end;
end;
//●コンピュータIPの取得
//復帰値：コンピュータ名
//Error:例外
function func_GetThisMachineIPAdrr:string;
var
    wVersionReqested : WORD;
    wsaData : TWSAData;
    Status: Integer;
    s:array[1..128] of char;
    p:PHostEnt;
    p2:PChar;

begin
  result :='';
  wVersionReqested := MAKEWORD(1,1);
  Status:=WSAStartup(wVersionReqested,wsaData);
  if Status<>0 then
  begin
    raise T_ErrSysExcep.Create('このマシンのIPアドレスは取得できません．');
    exit;
  end;
  try
     GetHostname(@s,128);
     p:=GetHostByName(@s);
     p2:= iNet_ntoa(PinAddr(p^.h_addr_list^)^);
     result:=p2;
  finally
  WSACleanup;
  end;
end;
//●コンピュータ名の取得
//復帰値：コンピュータ名
//Error:例外
function func_GetThisMachineName:string;
var
    wVersionReqested : WORD;
    wsaData : TWSAData;
    Status: Integer;
    s:array[1..128] of char;
    p:PHostEnt;

begin
  result :='';
  wVersionReqested := MAKEWORD(1,1);
  Status:=WSAStartup(wVersionReqested,wsaData);
  if Status<>0 then
  begin
    raise T_ErrSysExcep.Create('このマシンの名前は取得できません．');
    exit;
  end;
  try
     GetHostname(@s,128);
     p:=GetHostByName(@s);
     result:=p^.h_name;
  finally
  WSACleanup;
  end;
end;
//●コンピュータ名の取得
//復帰値：コンピュータ名
//Error:例外
function func_ReadMachineName:string;
var reg:TRegistry;
begin
  result :='';
  reg:=TRegistry.Create;
  try
    reg.RootKey := HKEY_LOCAL_MACHINE;
    if reg.OpenKeyReadOnly('SYSTEM\CurrentControlSet\'+
                           'Control\ComputerName\ComputerName')
    then
    begin
      result := reg.ReadString('ComputerName');
    end
    else
    begin
      result :=''; //
    end;
  finally
    reg.Free;
  end;
end;

//●コンピュータ名の取得開放系
//復帰値：コンピュータ名
//Error:例外
function func_GetMachineName:string;
begin
  result := ''; //
  if g_PC_Name = '' then
  begin
      g_PC_Name := func_ReadMachineName;
  end;
  result :=g_PC_Name; //
end;
function func_GetMachineName2:string;
begin
  result := ''; //
  if g_PC_Name = '' then
  begin
      g_PC_Name := func_ReadMachineName;
  end;
  result :=Left(g_PC_Name,10); //
end;

//●年齢計算
//復帰値：コンピュータ名
//Error:例外
{$HINTS OFF}
function func_GetAge(arg_BirthDay:TDate; arg_Day:TDate):integer;
var
  w_Date:TDate;
  w_i:integer;
  w_yy_B:word;
  w_mm_B:word;
  w_dd_B:word;
  w_yy_D:word;
  w_mm_D:word;
  w_dd_D:word;
  w_Flg:String;
  w_Flg2:String;
begin
  //戻り値
  result := 0;
  //時間を切り捨て（誕生日）
  DecodeDate(arg_BirthDay,w_yy_B,w_mm_B,w_dd_B);
  arg_BirthDay:=EncodeDate(w_yy_B,w_mm_B,w_dd_B);
  //arg_BirthDay:= StrToDate(DateToStr(arg_BirthDay));
  //時間を切り捨て（日付）
  DecodeDate(arg_Day,w_yy_D,w_mm_D,w_dd_D);
  arg_Day:=EncodeDate(w_yy_D,w_mm_D,w_dd_D);
  //arg_Day:= StrToDate(DateToStr(arg_Day));
  //誕生日を格納
  w_Date:=arg_BirthDay;
  //誕生日 >= 日付の場合'0'才表示
  if w_Date >= arg_Day then
    //処理終了
    Exit;
  //初期化
  w_i := 0;
  //フラグ（while文初期フラグ）
  w_Flg := '';
  //フラグ（閏日フラグ）
  w_Flg2 := '';
  //比較日付
  w_Date := w_Date + 1;
  //日付より大きくなるまで
  while w_Date <= arg_Day do
  begin
    //日付分解
    DecodeDate(w_Date,w_yy_D,w_mm_D,w_dd_D);
    //誕生日が閏日の場合
    if (w_mm_B = 2) and (w_dd_B = 29) then begin
      //2月29日がある場合
      if (w_mm_D = w_mm_B) and (w_dd_D = w_dd_B) then begin
        //1歳プラス
        w_i:= w_i + 1;
        //フラグ設定
        w_Flg2 := '1';
      end
      //3月1日の場合
      else if (w_mm_D = 3) and (w_dd_D = 1) then begin
        //フラグ確認
        if (w_Flg <> '') and (w_Flg2 = '')  then
          //1歳プラス
          w_i:= w_i + 1;
        //フラグ設定
        w_Flg2 := '';
      end;
    end
    //誕生日が閏日以外で誕生日と同じ日がきた場合
    else if (w_mm_D = w_mm_B) and (w_dd_D = w_dd_B) then begin
      //1歳プラス
      w_i:= w_i + 1;
    end;
    //次の日に移動
    w_Date := w_Date + 1;
    //フラグ設定
    w_Flg := '1';
  end;
  //戻り値
  result := w_i;

end;
{$HINTS ON}

//●基準から日付計算
//復帰値：
//Error:例外
{$HINTS OFF}
function func_ChngDate(
   arg_Day:Tdate; arg_Case:integer  ):TDate;
var
  w_Date:TDate;
  w_yy:word;
  w_mm:word;
  w_dd:word;
begin
  result := arg_Day; //
  case  arg_Case of
    JUSIN_D: w_Date:=arg_Day;
    JUSIN_D0401:
    begin
       DecodeDate(arg_Day, w_yy ,w_mm,w_dd);
       if w_mm < 4 then  w_yy := w_yy - 1;
       w_mm:=4;
       w_dd:=1;
       w_Date:=EncodeDate( w_yy ,w_mm,w_dd);
    end;
    JUSIN_DN0331:
    begin
       DecodeDate(arg_Day, w_yy ,w_mm,w_dd);
       if w_mm > 3 then  w_yy := w_yy+1;
       w_mm:=3;
       w_dd:=31;
       w_Date:=EncodeDate( w_yy ,w_mm,w_dd);
    end;
    JUSIN_D1231:
    begin
       DecodeDate(arg_Day, w_yy ,w_mm,w_dd);
       w_yy:=w_yy;
       w_mm:=12;
       w_dd:=31;
       w_Date:=EncodeDate( w_yy ,w_mm,w_dd);
    end;
    JUSIN_D0101:
    begin
       DecodeDate(arg_Day, w_yy ,w_mm,w_dd);
       w_yy:=w_yy;
       w_mm:=1;
       w_dd:=1;
       w_Date:=EncodeDate( w_yy ,w_mm,w_dd);
    end;
    JUSIN_DN0101:
    begin
       DecodeDate(arg_Day, w_yy ,w_mm,w_dd);
       w_yy:=w_yy+1;
       w_mm:=1;
       w_dd:=1;
       w_Date:=EncodeDate( w_yy ,w_mm,w_dd);
    end;
    JUSIN_D01:
    begin
       DecodeDate(arg_Day, w_yy ,w_mm,w_dd);
       w_yy:=w_yy;
       w_mm:=w_mm;
       w_dd:=1;
       w_Date:=EncodeDate( w_yy ,w_mm,w_dd);
       //w_Date:= arg_Day + 1;
    end;
    JUSIN_DME:
    begin
       w_Date:=IncMonth(arg_Day,1);
       DecodeDate(w_Date, w_yy ,w_mm,w_dd);
       w_yy:=w_yy;
       w_mm:=w_mm;
       w_dd:=1;
       w_Date:= EncodeDate( w_yy ,w_mm,w_dd);
       w_Date:= w_Date -1 ;
    end;

    else
      w_Date:=arg_Day;
  end;

  result :=w_Date; //

end;
{$HINTS ON}

//●基準から年齢計算
//復帰値：
//Error:例外
{$HINTS OFF}
function func_GetAgeofCase(
   arg_BirthDay:Tdate; arg_Day:Tdate; arg_Case:integer  ):integer;
var
  w_Date:TDate;
begin
  result := 0; //
  w_Date:=func_ChngDate(arg_Day, arg_Case);
  result :=func_GetAge(arg_BirthDay,w_Date); //
end;
{$HINTS ON}

//●基準から4/1年度日付に変換
//復帰値：
//Error:例外
function func_ChngDate41(
   arg_Day:Tdate  ):Tdate;
begin
  result:=func_ChngDate(arg_Day, JUSIN_D0401);
end;

//●フォルダを作成する
//  ファイル削除フラグ＝１の時、そのフォルダ内全てのファイルを削除する
//復帰値：
//Error:例外
function func_MakeDirectories(
   arg_Directory: string;   //作成フォルダ
   arg_FileDelete: integer  //ファイル削除フラグ(０：なし、１：あり)
  ):Boolean;                //復帰値
begin
  result:=True;
  if not DirectoryExists(arg_Directory) then
    ForceDirectories(arg_Directory);
  if arg_FileDelete = 1 then
    func_DeleteFileAt(arg_Directory);
end;
//●フォルダの全ファイルを削除する
//復帰値：
//Error:例外
function func_DeleteFileAt(
   arg_Directory: string    //対象フォルダ
  ):Boolean;                //復帰値
var
  SearchRec: TSearchRec;
  PathName: string;
begin
  result:=True;
  if not DirectoryExists(arg_Directory) then
  begin
    result:=False;
    Exit;
  end;
  // 指定されたフォルダにあるファイル名を取得する。
  SysUtils.FindFirst(arg_Directory+'*.*', faAnyFile, SearchRec);
  try
    if SearchRec.Name='' then Exit;
    // フォルダが空になるまで、ファイルを1つずつ削除する。
    repeat
      PathName:=arg_Directory+SearchRec.Name;
      if (SearchRec.Name<>'.') and (SearchRec.Name<>'..') then
        SysUtils.DeleteFile(PathName);
    until SysUtils.FindNext(SearchRec)<>0;
  finally
    SysUtils.FindClose(SearchRec);
  end;
end;

//●メタファイルからJPEGファイルを作成する
//復帰値：
//Error:例外
function func_MetafileToJpeg(
    arg_MetaFile:string;
    arg_JpegFile: string
   ): Boolean;
var
  LMetafile: TMetafile;
  LBitmap: TBitmap;
  LJpegImage: TJPEGImage;
  FileExt: string;
begin
  result:=True;

  if (arg_MetaFile = '') or
     (arg_JpegFile = '') then
  begin
    result:=False;
    Exit;
  end;
  // メタファイルのチェック
  FileExt := AnsiUpperCase(ExtractFileExt(arg_MetaFile));
  if (FileExt <> '.WMF') then
  begin
    Result:=False;
    Exit;
  end;
  if not FileExists(arg_MetaFile) then
  begin
    result:=False;
    Exit;
  end;
  // JPEGファイルのチェック
  FileExt := AnsiUpperCase(ExtractFileExt(arg_JpegFile));
  if (FileExt <> '.JPG') and
     (FileExt <> '.JPEG') then
  begin
    Result:=False;
    Exit;
  end;
  if FileExists(arg_JpegFile) then
    SysUtils.DeleteFile(arg_JpegFile);
  // コピー
  LMetafile := TMetafile.Create;
  LBitmap := TBitmap.Create;
  LJpegImage := TJPEGImage.Create;
  try
    LMetafile.LoadFromFile(arg_MetaFile);
    //
    LBitmap.PixelFormat := pf24bit; {24bit Color}
    LBitmap.Width := LMetafile.Width;
    LBitmap.Height := LMetafile.Height;
    LBitmap.Canvas.Draw(0, 0, LMetafile);
    //
    LJpegImage.Grayscale := False; {24bit Color}
    LJpegImage.Assign(LBitmap);
    LJpegImage.SaveToFile(arg_JpegFile);
    //
    LBitmap.Dormant;
    LBitmap.FreeImage;
    LBitmap.ReleaseHandle;
  finally
    LMetafile.Free;
    LBitmap.Free;
    LJpegImage.Free;
  end;
end;

//●JPEGファイルからBMPファイルを作成する
//復帰値：
//Error:例外
function func_JpegfileToBmp(
    arg_JpegFile:string;
    arg_BmpFile: string
   ): Boolean;
var
  LBitmap: TBitmap;
  LJpegImage: TJPEGImage;
  FileExt: string;
begin
  result:=True;

  if (arg_BmpFile = '') or
     (arg_JpegFile = '') then
  begin
    result:=False;
    Exit;
  end;
  // JPEGファイルのチェック
  FileExt := AnsiUpperCase(ExtractFileExt(arg_JpegFile));
  if (FileExt <> '.JPG') and
     (FileExt <> '.JPEG') then
  begin
    Result:=False;
    Exit;
  end;
  if not FileExists(arg_JpegFile) then
  begin
    result:=False;
    Exit;
  end;
  // BMPファイルのチェック
  FileExt := AnsiUpperCase(ExtractFileExt(arg_BmpFile));
  if (FileExt <> '.BMP') then
  begin
    Result:=False;
    Exit;
  end;
  if FileExists(arg_BmpFile) then
    SysUtils.DeleteFile(arg_BmpFile);
  // コピー
  LBitmap := TBitmap.Create;
  LJpegImage := TJPEGImage.Create;
  try
    LJpegImage.LoadFromFile(arg_JpegFile);
    LBitmap.Assign(LJpegImage);
    LBitmap.SaveToFile(arg_BmpFile);
  finally
    LJpegImage.free;
    LBitmap.free;
  end;
end;

//●ファイルコピー
procedure proc_CopyFile( arg_SrcName: string; arg_DesName: string );
var
  w_StreamSrc: TFileStream;
  w_StreamDes: TFileStream;
begin
  if not (FileExists(arg_SrcName)) then exit;
  w_StreamSrc:=TFileStream.Create(arg_SrcName,fmShareDenyNone or fmOpenRead );
  try
    w_StreamDes:=TFileStream.Create(arg_DesName,
                                    fmOpenWrite or fmCreate or fmShareDenyNone  );
    try
      w_StreamDes.CopyFrom(w_StreamSrc,w_StreamSrc.Size);
    finally
      w_StreamDes.Free;
    end;
  finally
    w_StreamSrc.Free;
  end;
end;

//●ファイルコピー
procedure proc_CopyFileEx(
  arg_SrcName: string;
  arg_DesName: string
  );
var
  w_FileName:string;
  w_Sr:TSearchRec;
  w_FileAttrs: Integer;

begin
  if not(DirectoryExists(arg_SrcName)) then
  begin
    raise T_ErrSysExcep.Create(arg_SrcName + 'は存在しません．');
    exit;
  end;
  if not(DirectoryExists(arg_DesName)) then
  begin
    raise T_ErrSysExcep.Create(arg_DesName + 'は存在しません．');
    exit;
  end;
  w_FileAttrs:=faReadOnly+faHidden+faSysFile+faVolumeID+faArchive;
  if FindFirst(arg_SrcName+'*.*', w_FileAttrs, w_Sr) = 0 then
  begin
    repeat
      w_FileName:=w_Sr.Name;
      proc_CopyFile(arg_SrcName + w_FileName,
                    arg_DesName + w_FileName);
    until FindNext(w_Sr) <> 0;
    FindClose(w_Sr);
  end;
    //ディレクトリごとコピー
{
    w_TFileList:= TFileListBox.Create(w_Form);
    w_TFileList.Visible := False;
    w_TFileList.Directory := arg_SrcName;
    w_TFileList.Mask      := arg_Mask;
    w_TFileList.Update ;
    for w_i:=0 to w_TFileList.Items.Count-1 do
    begin
      w_FileName:=w_TFileList.Items[w_i];
      proc_CopyFile(arg_SrcName + w_FileName,
                    arg_DesName + w_FileName);
    end;
  finally
    w_TFileList.Free;
  end;
}
end;
//2003.10.27
{
-----------------------------------------------------------------------------
  名前 :func_LeftZero
  引数 :
    intCapa:Integer バイト数
    EditStr:String  変更文字列
  復帰値：例外ない
  機能 :
    1. '0'を左側に必要分作成します。
 *
-----------------------------------------------------------------------------
}
function func_LeftZero( intCapa : Integer ; EditStr : String  ): String;
var
  lp    : Integer;
  len   : Integer;
  wkbuf : String;   //合成した必要スペース
begin
  //'0'バイト数
  len := intCapa - Length(EditStr);
  //初期化
  wkBuf := '';
  //範囲内時
  if len > 0 then begin
    //バイト数分の'0'の作成
    for lp := 1 to len do begin
      wkBuf := wkBuf + '0'; //'0'
    end;
    //文字列と'0'の結合
    wkBuf := wkBuf+EditStr;
  //範囲オーバー時
  end else begin
    //範囲内に切り取り
    wkBuf := Copy(EditStr,1,intCapa);
  end;
  //戻り値
  Result := wkBuf;
end;

//●プロセスを完全停止せずに待ち受けを行う
function WaitTime(const t,s: integer): Boolean;
var
    Timeout: TDateTime;
    w_i: integer;
begin
    w_i := 10;
    if s < t then w_i := s;
    Timeout := Now + t/24/3600/1000;  // 終了時刻

    while (Now < Timeout) do begin
        Application.ProcessMessages;
        Sleep(w_i);                //精度が 10ms 以下で良い場合
    end;

    Result := True;
end;
//●初期化処理
initialization
begin
//1)起動PASSを確定
     G_RunPath := ExtractFilePath( ParamStr(0) );
     //環境PASSを確定
     //デフォルトとして起動PASS
     G_EnvPath := G_RunPath;
     if ParamCount>0 then
      //コマンドラインより取得
     if DirectoryExists(ParamStr(1)) then
          G_EnvPath := ParamStr(1);
//その他情報取得
     g_PC_Name:=func_ReadMachineName;
     DateSeparator:='/';
     TimeSeparator:=':';
     gval_datefmt:= gval_datefmtYY +DateSeparator+ gval_datefmtMM+DateSeparator+ gval_datefmtDD;
     gval_datetimefmt:= gval_datefmt+' '+gval_timefmtHH +TimeSeparator+ gval_timefmtNN+TimeSeparator+ gval_timefmtSS;
end;

//●終了化処理
finalization
begin

end;

end.
