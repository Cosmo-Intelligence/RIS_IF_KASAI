unit myInitInf;
{
■機能説明（使用予定：あり）
  ①ﾌﾟﾛｼﾞｪｸﾄ（EXE）の端末固有の
    イニシャライズ情報（INI情報）にアクセスする機能を提供する。
    現状はレジストリは未サポートINIファイルのみ。
    Gvalより移設。
  ②共通のイニシャライズ情報（INI情報）の定義(固有情報はpdct_ini.pas)
  ③イニシャライズ情報の一括読み込み

//● メインINIファイルの指定セクション／キーの値を読む。
function func_ReadIniKeyVale(arg_SecName:string;
                              arg_KeyName:string;
                              arg_Vale:string
                                   ):String;
//● メインINIファイルの指定セクション／キーの値を書く。
procedure func_WriteIniKeyVale(arg_SecName:string;
                              arg_KeyName:string;
                              arg_Vale:string
                                  ):boolean;
● 環境ﾊﾟｽのINIファイルのセクションを読込んでKeyの一覧をTStringsに取り出す。
function func_ReadIniSecKeyToTStrings(
   arg_IniFname:string;環境ﾊﾟｽのINIﾌｧｲﾙ名
   arg_SecName:string  ｾｸｼｮﾝ名文字列
   ):TStrings;         ｷｰ文字列の一覧

●環境ﾊﾟｽのIniﾌｧｲﾙのｾｸｼｮﾝのKey一覧から、各Keyの（ｶﾝﾏ区切り）値の一覧を
  TStrings配列で作成する。
function func_ReadIniSecToATStrings(
   arg_IniFname:string;         環境ﾊﾟｽのINIﾌｧｲﾙ名
   arg_SecName:string;          ｾｸｼｮﾝ名文字列
   arg_KeyList:TStrings;        ReadIniSecKeyToTStringsで作る
   var arg_Res: TAarrayTStrings 結果
    ):boolean;                  復帰値
● INIファイルのセクションを読込んでKeyの一覧をTStringsに取り出す。
function func_ReadIniSecKeyToTStrings2(
   arg_IniFname:string;INIﾌｧｲﾙ名 検索ｼｰｹﾝｽはWINの仕様と同じ
   arg_SecName:string  ｾｸｼｮﾝ名文字列
   ):TStrings;         ｷｰ文字列の一覧
●IniﾌｧｲﾙのｾｸｼｮﾝのKey一覧から、各Keyの値一覧のTStrings配列を作成する。
function func_ReadIniSecToATStrings2(
   arg_IniFname:string;       環境ﾊﾟｽのINIﾌｧｲﾙ名 検索ｼｰｹﾝｽはWINの仕様と同じ
   arg_SecName:string;        ｾｸｼｮﾝ名文字列
   arg_KeyList:TStrings;      ReadIniSecKeyToTStringsで作る
   var arg_Res: TAarrayTStrings 結果
    ):boolean;                復帰値
//● キーの値の環境変数部分を置き換える。
function func_ChngVal(
                      arg_Vale:string        //読取り値
                                   ):String; //変換結果

●ReadIniSecToATStringsとReadIniSecKeyToTStringsの結果よりｷｰ値を取り出す
function func_IniKeyValue(
   arg_KeyList:TStrings;         ReadIniSecKeyToTStringsで作る
   arg_KeyVlist:TAarrayTStrings; ReadIniSecToATStringsで作る
   arg_Key:string;               ｷｰ文字列
   arg_Index:Integer;            arg_KeyVlistの位置0から
   arg_defoult:string            取り出せない時のﾃﾞﾌｫﾙﾄ値
   ):string;                     結果の字列

■履歴
新規作成：00.04.10：担当いわい

修正00：05：11 : iwai
ini情報アクセス関数を追加
function func_ReadIniKeyVale():String;
procedure func_WriteIniKeyVale();
function func_ChngVal();
各画面が個別にINI情報にアクセスする可能性があり
将来INIからレジストリになる時にこの関数を書き換えればすむので。

修正00：10：27 : iwai
ini情報への初期化アクセス機能のみに分離
情報の定義はpdct_com.pasに移設

修正01：02：21 : iwai
RIG接続情報を追加
修正01：03：13 : iwai
符号化方式を追加

}
interface //*****************************************************************
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
//プロダクト開発共通－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－
  Gval,
  pdct_ini
  ;
////型クラス宣言-------------------------------------------------------------
//type
//定数宣言-------------------------------------------------------------------
const
//INIファイル情報
g_DOCSYS_INI_NAME = 'RIS_SYS.INI';      //実行単位のINIファイル名（環境パス）
g_LGSYS_INI_NAME = 'RIS_LG.INI';      //実行単位のINIファイル名（環境パス）
G_PRODUCT_INI_NAME=g_DOCSYS_INI_NAME;
//INI情報の無い時のデフォルト値↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓
CST_COREP_DIR_NAME='co_rep\';
CST_COREPORT_DIR_NAME='co_reptemp\';
CST_COREPVIEWER_DIR_NAME='CrViewer.exe';
CST_COREPCID_DIR_NAME='co_rep\cid\';
CST_COLUMN_DIR_NAME='Columns\';
CST_SHEMA_DIR_NAME='she-ma\';
CST_WAVE_FILE_NAME='wave\otokokuti.wav';
//↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑ ↑↑↑↑↑↑
//共通INIファイル情報定義↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓
 //セクション：環境変数
  g_COMMON_SECSION = 'COMMON';
    g_HOMEDIR_KEY = 'HOMEDIR';//ホームディレクトリ
 //セクション：ウィンドウ情報
  g_WINDOW_SECSION = 'WINDOW';
    g_MENU_WIN_MAX_H_KEY      = 'MENU_WIN_MAX_H';//キー
     G_CONST_MAX_MENUWINDOW_H='735'; //ｳｨﾝﾄﾞｳ縦
    g_MENU_WIN_MAX_W_KEY      = 'MENU_WIN_MAX_W';//キー
     G_CONST_MAX_MENUWINDOW_W='300'; //ｳｨﾝﾄﾞｳ横
    g_SUB_WIN_MAX_H_KEY       = 'SUB_WIN_MAX_H' ;//キー
     G_CONST_MAX_SUBWINDOW_H ='735'; //ｻﾌﾞｳｨﾝﾄﾞｳ縦
    g_SUB_WIN_MAX_W_KEY       = 'SUB_WIN_MAX_W' ;//キー
     G_CONST_MAX_SUBWINDOW_W ='980'; //ｻﾌﾞｳｨﾝﾄﾞｳ横
    g_MENU_WIN_ALIMENT_KEY   = 'MENU_WIN_ALIMENT';//キー
    g_SUB_WIN_ALIMENT_KEY    = 'SUB_WIN_ALIMENT' ;//キー
 //セクション：和暦情報
  g_WAREKI_SECSION = 'WAREKI';
 //セクション：トレース制御
  g_TRACE_SECSION  = 'TRACE';
    g_MODE_KEY     = 'mode';    //キートレースモード
    g_PATH_KEY     = 'path';    //キートレースPATH
    g_FILESIZE_KEY = 'filesize';//キーファイルサイズ
    G_FILESIZE     = '1048576';
 //セクション：ユーザ端末情報
  g_USRINF_SECSION = 'USRINF';
    g_CTNAME_KEY      = 'ctname'    ;//キー端末説明
    g_USERID_KEY      = 'userid'    ;//キーユーザＩＤ
 //セクション：メインDBシステム情報
  g_DBINF_SECSION = 'DBINF';
    g_SYSNAME_KEY     = 'dbuid'     ;//キーDB接続ユーザID
        g_DB_ACCOUNT  = 'ris'   ;//デフォルト INIで設定可変となるため使用不可
    g_USERPSS_KEY     = 'dbpss'     ;//キーユーザパスワード
        g_DB_PASS     = 'huris'   ;//デフォルト INIで設定可変となるため使用不可
    g_DBNAME_KEY      = 'dbname'    ;//キーDBname
        g_DB_NAME     = 'ris_sv';//デフォルト INIで設定可変となるため使用不可
    g_DB_CONECT_KEY   = 'dbcntmax'  ;//キーDB初期接続最大数
        g_DB_CONECT_N = '4'         ;//デフォルトDB初期接続最大数
 //セクション：ディレクトリ情報
  g_DIRINF_SECSION = 'DIRINF';
    g_COREP_DIR_KEY   = 'corepdir'  ;//キーCoReportのフォームディレクトリ
        g_COREP_DIR   = ''          ;//デフォルトCoReportのフォームディレクトリ
    g_COREPVIEWER_DIR_KEY = 'corepviewerdir';//キーCoReportsViewerのフォームディレクトリ
        g_COREPVIEWER_DIR = ''              ;//デフォルトCoReportsViewerのフォームディレクトリ
    g_COREPVIEWER_FLG_KEY = 'corepviewerflg';//キーCoReportsViewerのON,OFF
        g_COREPVIEWER_FLG = ''              ;//CoReportsViewerのON,OFF
    g_COREPCID_DIR_KEY = 'corepciddir';//キーCoReportsViewer用cidファイル作成のフォームディレクトリ
        g_COREPCID_DIR = ''           ;//デフォルトCoReportsViewer用cidファイル作成のフォームディレクトリ

    g_columndir_DIR_KEY = 'columndir';//キーカラム幅ファイル作成のフォームディレクトリ
        g_columndir_DIR = ''           ;//デフォルトカラム幅用ファイル作成のフォームディレクトリ
    g_shemadir_DIR_KEY = 'shemadir';  //キーシェーマオリジナルファイル、編集HTML格納先ディレクトリ
        g_shemadir_DIR = ''           ;//シェーマオリジナルファイル、編集HTML格納先ディレクトリ

    g_wavedir_DIR_KEY = 'wavedir';  //キーシェーマオリジナルファイル、編集HTML格納先ディレクトリ
        g_wavedir_DIR = ''           ;//シェーマオリジナルファイル、編集HTML格納先ディレクトリ

 //セクション：メニュー画面画像 2003.10.15
  g_IMAGE_SECSION = 'IMAGE';
    g_IMAGE_DIR_KEY   = 'imagedir' ;    //キー背景画像の格納先ディレクトリ
        g_IMAGE_DIR   = ''         ;    //デフォルト
    g_IMAGE_FILE_KEY  = 'imagefile';    //背景画像の格納先ファイル名
        g_IMAGE_FILE  = ''         ;    //デフォルト

  g_REPORTINF_SECSION = 'REPORTINF';
    g_REPORTINF_ID_KEY = 'id';
    gi_REPORTINF_DEF   = '';

//共通INIファイル情報定義↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑
//変数宣言-------------------------------------------------------------------
var
//以下はﾌﾟﾛｼﾞｪｸﾄのiniの情報
   gini_ProjectIni: TIniFile;
   g_product_inifile_name:string;
//ini情報読込域 ↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓
//環境変数格納域
   gini_Common_Key  : TStrings;
   gini_Common: TAarrayTStrings;
   { 例             [0]       [1]
      gini_Common[0] HOMEDIR   C:\
      gini_Common[1] XXXXXXX   C:\

      gini_Common[0][0] 'HOMEDIR'
   }
//main用DB
   gi_DB_Name       : string ; //BDEで設定されたｱﾘｱｽ名
   gi_DB_Account    : string ;//ORACLのアカウント
   gi_DB_Pass       : string ;   //ORACLのPASSWORD
   gi_ctname        : string ;       //
   gi_UserID        : string ;       //UID
   gi_UserPassWord  : string ; //PASSWORD
   g_DB_CONECT_MAX  : integer;   //DB初期接続最大数
//CoReport重宝定義体格納域
   gi_COREP_DIR     : string ;
   gi_COREPORT_TEMPDIR:String;
//CoReportsViewer重宝定義体格納域
   gi_COREPVIEWER_EXE : string ;
//CoReportsViewer重宝定義体格納域
   gi_COREPVIEWER_FLG : string ;
//CoReportsViewer用cidファイル名重宝定義体格納域
   gi_COREPCID_DIR    : string ;
//columnファイル名重宝定義体格納域
   gi_columndir_DIR    : string ;
//シェーマ重宝定義体格納域
   gi_SHEMADIR_DIR  : string;
//音告知用Waveファイル重宝定義体格納域
   gi_WAVEDIR_DIR  : string;
//背景画像の格納先ディレクトリ定義体格納域   2003.10.15
   gi_image_dir  : string;
//背景画像の格納先ファイル名定義体格納域     2003.10.15
   gi_image_file : string;
//受付票コメントＩＤ     2004.04.09
   gi_Disp_CommentID : string;

//和暦情報格納域
   gini_Wareki_Key  : TStrings;
   gini_Wareki: TAarrayTStrings;
   { 例             [0] [1] [2]   [3]
      gini_Wareki[0] 1   M  明治  1867/01/01
      gini_Wareki[1] 2   T  大正  1912/01/01
      gini_Wareki[2] 3   S  昭和  1927/01/01
      gini_Wareki[3] 4   H  平成  1989/01/01

      gini_Wareki[0][0] '1'
   }
//ｳｨﾝﾄﾞｳのサイズと配置
   gi_MenuWinMax_H:string;
   gi_MenuWinMax_W:string;
   gi_SubWinMax_H:string;
   gi_SubWinMax_W:string;
   gi_MenuWinAlin:string;
   gi_SubWinAlin:string;

   g_MenuWinMax_H:integer;
   g_MenuWinMax_W:integer;
   g_SubWinMax_H:integer;
   g_SubWinMax_W:integer;

//ini情報読込域 ↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑

//関数手続き宣言-------------------------------------------------------------
function func_ChngVal(
                      arg_Vale:string        //読取り値
                                   ):String; //変換結果
function func_ReadIniKeyVale(arg_SecName:string;
                              arg_KeyName:string;
                              arg_Vale:string
                                   ):String;
procedure func_WriteIniKeyVale(arg_SecName:string;
                              arg_KeyName:string;
                              arg_Vale:string
                                  );
function func_ReadIniSecKeyToTStrings(arg_IniFname:string;
                                   arg_SecName:string
                                   ):TStrings;
function func_ReadIniSecToATStrings(arg_IniFname:string;
                                   arg_SecName:string;
                                   arg_KeyList:TStrings;
                                   var arg_Res: TAarrayTStrings ):boolean;
function func_ReadIniSecKeyToTStrings2(arg_IniFname:string;
                                   arg_SecName:string
                                   ):TStrings;
function func_ReadIniSecToATStrings2(arg_IniFname:string;
                                   arg_SecName:string;
                                   arg_KeyList:TStrings;
                                   var arg_Res: TAarrayTStrings ):boolean;

function func_IniKeyValue(arg_KeyList:TStrings;
                          arg_KeyVlist:TAarrayTStrings;
                          arg_Key:string;
                          arg_Index:Integer;
                          arg_defoult:string
                          ):string;
//ポインタが不安定なので使わないこと
function func_ReadIniSecToTStrings(arg_IniFname:string;
                                   arg_SecName:string;
                                   arg_Res: Pointer):boolean;


implementation //**************************************************************

//使用ユニット---------------------------------------------------------------
//uses
//定数宣言       -------------------------------------------------------------
//const
//変数宣言     ---------------------------------------------------------------
var
  w_wfini: integer;
  w_string:string;
//関数手続き宣言--------------------------------------------------------------
//● キーの値の環境変数部分を置き換える。
function func_ChngVal(
                      arg_Vale:string        //読取り値
                                   ):String; //変換結果
var
  w_PrChr:string;
  w_CVal :string;
  w_Res  :string;
  w_i:integer;
begin
  w_Res := arg_Vale;
try
  if nil<>gini_Common_Key then
  begin
    for w_i:=0 to gini_Common_Key.Count-1 do
    begin
      w_PrChr:=gini_Common_Key[w_i];
      if  0 < Length(Trim(w_PrChr)) then
      begin
        w_CVal := func_IniKeyValue(
                            gini_Common_Key,
                            gini_Common,
                            w_PrChr,
                            0,
                            ''
                            );
        if w_PrChr=g_HOMEDIR_KEY then
        begin
          if func_IsNullStr(w_CVal)
             or
             not(DirectoryExists(w_CVal))
          then
          begin
             w_CVal:=G_EnvPath;
          end;
        end;
        if  0 < Length(Trim(w_CVal)) then
        begin
          w_Res := StringReplace(
                           w_Res,
                           '%' + w_PrChr + '%',
                           w_CVal,
                           [rfReplaceAll, rfIgnoreCase]
                           );
        end;
      end;
    end;
  end;
  result := w_Res;
except
  result := w_Res;
  exit;
end;
end;

//● メインINIファイルの指定セクション／キーの値を読む。
function func_ReadIniKeyVale(arg_SecName:string;
                             arg_KeyName:string;
                             arg_Vale:string
                                   ):String;
var
  w_s:string;
begin
     w_s := gini_ProjectIni.ReadString(
                    arg_SecName,
                    arg_KeyName,
                    arg_Vale);
     result := func_ChngVal(w_s);

end;
//● メインINIファイルの指定セクション／キーの値を書く。
procedure func_WriteIniKeyVale(arg_SecName:string;
                              arg_KeyName:string;
                              arg_Vale:string
                                  );
begin
     gini_ProjectIni.WriteString(
                    arg_SecName,
                    arg_KeyName,
                    arg_Vale);

end;
//●Iniのセクションを読込んでKeyの一覧をTStringsにする
//arg_IniFnameはフルパス指定 または ファイル名のみ
//Error:bottom up 各種処理例外
function func_ReadIniSecKeyToTStrings2(arg_IniFname:string;
                                   arg_SecName:string
                                   ):TStrings;
var
    wo_SysIni: TIniFile;
    wo_KeyNames: TStringList;
begin
  Result:=nil;
  // DOCSYS を読込みメニュを構成する。
  wo_SysIni := TIniFile.Create(arg_IniFname);
  if wo_SysIni = nil then Exit;
  try
    //keyの読み取り 。
    wo_KeyNames := TStringList.Create;
    try
      wo_SysIni.ReadSection(arg_SecName, wo_KeyNames);
    except
      wo_KeyNames.free;
      raise;
    end;
  // 終了処理
  finally
    wo_SysIni.Free;
  end;
  Result := wo_KeyNames;
end;
//●Iniのセクションを読込んでKeyの一覧をTStringsにする
//arg_IniFnameは環境パスG_EnvPathに存在する
//Error:bottom up
function func_ReadIniSecKeyToTStrings(arg_IniFname:string;
                                   arg_SecName:string
                                   ):TStrings;
begin
  Result :=
     func_ReadIniSecKeyToTStrings2(
               (G_EnvPath + arg_IniFname),
               arg_SecName
               );
end;

//●Iniのセクションを読込んでKeyの値の一覧をTStrings配列にする
//arg_IniFnameはフルパス指定 または ファイル名のみ
//Error:bottom up 各種処理例外
function func_ReadIniSecToATStrings2(
                                   arg_IniFname:string;
                                   arg_SecName:string;
                                   arg_KeyList:TStrings;
                                   var arg_Res: TAarrayTStrings ):boolean;
var
    wo_SysIni: TIniFile;
    wi_Max_Key: integer;//
    wi_init: integer;//
    wo_KeyValue : TStringList;
begin
  Result:=false;
  // SYSini を読込みメニュを構成する。
  wo_SysIni := TIniFile.Create( arg_IniFname);
  if wo_SysIni = nil then Exit;
  try
    wo_KeyValue := TStringList.Create;
    try
      wo_SysIni.ReadSectionValues(arg_SecName, wo_KeyValue);
      wi_Max_Key := arg_KeyList.Count;
      try
        wi_init:=0 ;
        while  wi_init <= ( wi_Max_Key - 1 ) do
        begin
          arg_Res[wi_init] :=
            func_StrToTStrList(wo_KeyValue.Values[arg_KeyList[wi_init]]);
          wi_init := wi_init + 1;
        end;
      except
        wi_init:=0 ;
        while  wi_init <= ( wi_Max_Key - 1 ) do
        begin
          if arg_Res[wi_init] <> nil then
          begin
            arg_Res[wi_init].Free;
            arg_Res[wi_init]:=nil;
          end;
          wi_init := wi_init + 1;
        end;
        raise;
      end;
  // 終了処理
      finally
        wo_KeyValue.Free;
      end;
  finally
    wo_SysIni.Free;
  end;
  Result := true;
end;

//●Iniのセクションを読込んでKeyの値の一覧をTStrings配列にする
//arg_IniFnameは環境パスG_EnvPathに存在する
//Error:bottom up
function func_ReadIniSecToATStrings(arg_IniFname:string;
                                   arg_SecName:string;
                                   arg_KeyList:TStrings;
                                   var arg_Res: TAarrayTStrings ):boolean;
begin
  Result := func_ReadIniSecToATStrings2(
                                        ( G_EnvPath + arg_IniFname),
                                        arg_SecName,
                                        arg_KeyList,
                                        arg_Res
                                       );
end;

//●Iniのセクションを読込んでTStringsにする
//ポインタが不安定なので使わない
function func_ReadIniSecToTStrings(arg_IniFname:string;
                                   arg_SecName:string;
                                   arg_Res: Pointer):boolean;
var
    wo_SysIni: TIniFile;
    wo_KeyNames: TStringList;
    wi_Max_Key: integer;//
    wi_init: integer;//
    wo_KeyValue : TStringList;
    wa_KeyValues: ^TAarrayTStrings;
begin
  Result := false;
  // SYSini を読込みメニュを構成する。
  wo_SysIni := TIniFile.Create( G_EnvPath + arg_IniFname);
  if wo_SysIni=nil then exit;
  try
    //keyの読み取り 。
    wo_KeyNames := TStringList.Create;
    try
      wo_KeyValue := TStringList.Create;
      try
        wo_SysIni.ReadSection(arg_SecName, wo_KeyNames);
        wo_SysIni.ReadSectionValues(arg_SecName, wo_KeyValue);
        wi_Max_Key := wo_KeyNames.Count;
        //情報格納域配列の大きさ設定   gini_Wareki  wa_KeyValues
        wa_KeyValues:= arg_Res;
        SetLength ( wa_KeyValues^ ,wi_Max_Key);
        try
          wi_init:=0 ;
          while  wi_init <= ( wi_Max_Key - 1 ) do
          begin
            wa_KeyValues^[wi_init] :=
              func_StrToTStrList(wo_KeyValue.Values[wo_KeyNames[wi_init]]);
            wi_init := wi_init + 1;
          end;
        except
          wi_init:=0 ;
          while  wi_init <= ( wi_Max_Key - 1 ) do
          begin
            if wa_KeyValues^[wi_init] <> nil then
            begin
              wa_KeyValues^[wi_init].Free;
              wa_KeyValues^[wi_init]:=nil;
            end;
            wi_init := wi_init + 1;
          end;
          raise;
        end;
  // 終了処理
      finally
        wo_KeyValue.Free;
      end;
    finally
      wo_KeyNames.Free;
    end;
  finally
    wo_SysIni.Free;
  end;
  Result := true;
end;

//●INIファイルのKeyの値をListから取り出す（）
//Error:No
(**
 -------------------------------------------------------------------
 * @outline        ｿｰｽﾌｧｲﾙ名取得            <-- メソッド概要
 * @param Index ｿｰｽﾌｧｲﾙｲﾝﾃﾞｯｸｽ          <-- 引数概要（@paramのあとに、引数名が必要）
 * @return         ｿｰｽﾌｧｲﾙ名                  <-- 戻り値概要(functionのみ)

 * 説明文１                                           <-- メソッド説明文（複数行ＯＫ）
 * 説明文２                                           <-- メソッド説明文（複数行ＯＫ）
 -------------------------------------------------------------------
 *)
function func_IniKeyValue(arg_KeyList:TStrings;
                          arg_KeyVlist:TAarrayTStrings;
                          arg_Key:string;
                          arg_Index:Integer;
                          arg_defoult:string
                          ):string;
var
  w_index:integer;
begin
try
  result:= arg_defoult;
  if (arg_KeyList=nil) or
     (high(arg_KeyVlist)<0) or
     (Length(arg_Key)=0) then exit;
  w_index:=arg_KeyList.IndexOf(arg_Key);
  if (w_index >= 0) and
     (high(arg_KeyVlist) >= w_index) and
     (arg_KeyVlist[w_index].Count>arg_Index)
     then

         result:=arg_KeyVlist[w_index][arg_Index];
except
  result:= '';
  exit;
end;
end;

initialization
begin
//1)デフォルト値の設定
      g_product_inifile_name := G_PRODUCT_INI_NAME;
   //1)-1)情報初期化()
      gi_MenuWinMax_H := G_CONST_MAX_MENUWINDOW_H;
      g_MenuWinMax_H := StrToInt(gi_MenuWinMax_H);

      gi_MenuWinMax_W := G_CONST_MAX_MENUWINDOW_W;
      g_MenuWinMax_W := StrToInt(gi_MenuWinMax_W);

      gi_SubWinMax_H  := G_CONST_MAX_SUBWINDOW_H;
      g_SubWinMax_H := StrToInt(gi_SubWinMax_H);

      gi_SubWinMax_W  := G_CONST_MAX_SUBWINDOW_W;
      g_SubWinMax_W := StrToInt(gi_SubWinMax_W);

      gi_MenuWinAlin  := '';
      gi_SubWinAlin   := '';
   //1)-2)ユーザ情報初期化
      gi_ctname       := 'Clint('+ func_GetMachineName + ')';
      gi_UserID       := '';
      gi_UserPassWord := '';
   //1)-3)DB情報初期化
      gi_DB_Name      := g_DB_NAME;
      gi_DB_Account   := g_DB_ACCOUNT;
      gi_DB_Pass      := g_DB_PASS;
      g_DB_CONECT_MAX := StrToInt(g_DB_CONECT_N);
   //1)-4)ディレクトリ情報初期化
      gi_COREP_DIR    := g_COREP_DIR;
//2)read ini file.
     gini_ProjectIni := TIniFile.Create( G_EnvPath + g_product_inifile_name);
   //2)-0)環境変数読み込み
     gini_Common_Key :=
            func_ReadIniSecKeyToTStrings(g_product_inifile_name,
                                         g_COMMON_SECSION);
     if (gini_Common_Key<> nil) and
        (gini_Common_Key.Count>0)then
     begin
     //情報格納域配列の大きさ設定   gini_Wareki  wa_KeyValues
       SetLength ( gini_Common ,gini_Common_Key.Count);
       func_ReadIniSecToATStrings(g_product_inifile_name,
                                  g_COMMON_SECSION,
                                  gini_Common_Key,
                                  gini_Common);
     end;
   //2)-1)ウィンドウ情報読み込み
     w_string:=func_ReadIniKeyVale(g_WINDOW_SECSION,
                                          g_MENU_WIN_MAX_H_KEY,
                                          gi_MenuWinMax_H);
     if not(func_IsNullStr(w_string)) then gi_MenuWinMax_H :=w_string;
     g_MenuWinMax_H := StrToInt(gi_MenuWinMax_H);

     w_string:=func_ReadIniKeyVale(g_WINDOW_SECSION,
                                          g_MENU_WIN_MAX_W_KEY,
                                          gi_MenuWinMax_W);
     if not(func_IsNullStr(w_string)) then gi_MenuWinMax_W :=w_string;
     g_MenuWinMax_W := StrToInt(gi_MenuWinMax_W);

     w_string :=func_ReadIniKeyVale(g_WINDOW_SECSION,
                                          g_SUB_WIN_MAX_H_KEY,
                                          gi_SubWinMax_H);
     if not(func_IsNullStr(w_string)) then gi_SubWinMax_H :=w_string;
     g_SubWinMax_H := StrToInt(gi_SubWinMax_H);

     w_string :=func_ReadIniKeyVale(g_WINDOW_SECSION,
                                          g_SUB_WIN_MAX_W_KEY,
                                          gi_SubWinMax_W);
     if not(func_IsNullStr(w_string)) then gi_SubWinMax_W :=w_string;
     g_SubWinMax_W := StrToInt(gi_SubWinMax_W);

     gi_MenuWinAlin :=func_ReadIniKeyVale(g_WINDOW_SECSION,
                                          g_MENU_WIN_ALIMENT_KEY,
                                          gi_MenuWinAlin);

     gi_SubWinAlin :=func_ReadIniKeyVale(g_WINDOW_SECSION,
                                          g_SUB_WIN_ALIMENT_KEY,
                                          gi_SubWinAlin);

   //2)-2)和暦読み込み
     gini_Wareki_Key :=
            func_ReadIniSecKeyToTStrings(g_product_inifile_name,
                                         g_WAREKI_SECSION);
     if (gini_Wareki_Key<> nil) and
        (gini_Wareki_Key.Count>0)then
     begin
     //情報格納域配列の大きさ設定   gini_Wareki  wa_KeyValues
       SetLength ( gini_Wareki ,gini_Wareki_Key.Count);
       func_ReadIniSecToATStrings(g_product_inifile_name,
                                  g_WAREKI_SECSION,
                                  gini_Wareki_Key,
                                  gini_Wareki);
     end
     else
     begin
       //デフォルト
       if (gini_Wareki_Key<> nil) then gini_Wareki_Key:=TStringList.Create;
       SetLength ( gini_Wareki ,4);
       gini_Wareki[0]:=TStringList.Create;
       gini_Wareki[1]:=TStringList.Create;
       gini_Wareki[2]:=TStringList.Create;
       gini_Wareki[3]:=TStringList.Create;
       gini_Wareki[0].CommaText:= '1,M,明治,1868/01/01';
       gini_Wareki[1].CommaText:= '2,T,大正,1912/07/31';
       gini_Wareki[2].CommaText:= '3,S,昭和,1926/12/26';
       gini_Wareki[3].CommaText:= '4,H,平成,1989/01/08';
     end;
   //2)-3)ユーザ端末情報読み込み
     w_string:=func_ReadIniKeyVale(g_USRINF_SECSION,
                                    g_CTNAME_KEY,
                                    gi_ctname);
     if not(func_IsNullStr(w_string)) then gi_ctname :=w_string;
     gi_UserID:=gini_ProjectIni.ReadString(g_USRINF_SECSION,
                                           g_USERID_KEY,
                                           gi_UserID);
   //2)-4)DB情報読み込み
     w_string:=func_ReadIniKeyVale(g_DBINF_SECSION,
                                     g_DBNAME_KEY,
                                     gi_DB_Name);
     if not(func_IsNullStr(w_string)) then gi_DB_Name :=w_string;
     w_string:=func_ReadIniKeyVale(g_DBINF_SECSION,
                                        g_SYSNAME_KEY,
                                        gi_DB_Account);
     if not(func_IsNullStr(w_string)) then gi_DB_Account :=w_string;
     gi_DB_Pass:=gi_DB_Account;
     w_string:=func_ReadIniKeyVale(g_DBINF_SECSION,
                                     g_USERPSS_KEY,
                                     gi_DB_Pass);
     if not(func_IsNullStr(w_string)) then gi_DB_Pass :=w_string;
     g_DB_CONECT_MAX:=strtointdef(func_ReadIniKeyVale(g_DBINF_SECSION,
                                                      g_DB_CONECT_KEY,
                                                      g_DB_CONECT_N),
                                  g_DB_CONECT_MAX);
   //2)-5)ディレクトリ情報読み込み
     gi_COREP_DIR:=func_ReadIniKeyVale(g_DIRINF_SECSION,
                                       g_COREP_DIR_KEY,
                                       gi_COREP_DIR);
     if ( gi_COREP_DIR = '' )
        or
        not(DirectoryExists(gi_COREP_DIR))
     then
       gi_COREP_DIR :=G_EnvPath + CST_COREP_DIR_NAME;
   //2)-6)ディレクトリ(CoreportsViewer)情報読み込み
     gi_COREPVIEWER_EXE:=func_ReadIniKeyVale(g_DIRINF_SECSION,
                                             g_COREPVIEWER_DIR_KEY,
                                             g_COREPVIEWER_DIR);
     gi_COREPVIEWER_EXE := gi_COREPVIEWER_EXE + CST_COREPVIEWER_DIR_NAME;
   //2)-6)-1)CoreportsViewer起動情報読み込み
     gi_COREPVIEWER_FLG:=func_ReadIniKeyVale(g_DIRINF_SECSION,
                                             g_COREPVIEWER_FLG_KEY,
                                             g_COREPVIEWER_FLG);
   //2)-7)ディレクトリ情報読み込み
     gi_COREPCID_DIR:=func_ReadIniKeyVale(g_DIRINF_SECSION,
                                          g_COREPCID_DIR_KEY,
                                          gi_COREPCID_DIR);
     if ( gi_COREPCID_DIR = '' )
        or
        not(DirectoryExists(gi_COREPCID_DIR))
     then
       gi_COREPCID_DIR :=G_EnvPath + CST_COREPCID_DIR_NAME;

   //2)-8)サブDB情報読み込み
      gi_Pls1DB_Name      := g_PLS1_DB_NAME;
      gi_Pls1DB_Account   := g_PLS1_DB_ACCOUNT;
      gi_Pls1DB_Pass      := g_PLS1_DB_PASS;
      g_Pls1DB_CONECT_MAX := StrToInt(g_PLS1_DB_CONECT_N);
     w_string:=func_ReadIniKeyVale(g_PLS1_DB_SECSION,
                                     g_PLS1_DBNAME_KEY,
                                     gi_Pls1DB_Name);
     if not(func_IsNullStr(w_string)) then gi_Pls1DB_Name :=w_string;
     w_string:=func_ReadIniKeyVale(g_PLS1_DB_SECSION,
                                        g_PLS1_UID_KEY,
                                        gi_Pls1DB_Account);
     if not(func_IsNullStr(w_string)) then gi_Pls1DB_Account :=w_string;
     gi_Pls1DB_Pass:=gi_Pls1DB_Account;
     w_string:=func_ReadIniKeyVale(g_PLS1_DB_SECSION,
                                     g_PLS1_USERPSS_KEY,
                                     gi_Pls1DB_Pass);
     if not(func_IsNullStr(w_string)) then gi_Pls1DB_Pass :=w_string;
     g_Pls1DB_CONECT_MAX:=strtointdef(func_ReadIniKeyVale(g_PLS1_DB_SECSION,
                                                      g_PLS1_DB_CONECT_KEY,
                                                      g_PLS1_DB_CONECT_N),
                                  g_Pls1DB_CONECT_MAX);
   //2)-9)デフォルトカラム幅用ファイル作成のフォームディレクトリ情報読み込み
     gi_columndir_DIR:=func_ReadIniKeyVale(g_DIRINF_SECSION,
                                          g_columndir_DIR_KEY,
                                          g_columndir_DIR);
     if ( gi_columndir_DIR = '' )
        or
        not(DirectoryExists(gi_columndir_DIR))
     then
       gi_columndir_DIR :=G_EnvPath + CST_COLUMN_DIR_NAME;

   //2)-10)シェーマオリジナルファイル、編集HTML格納先ディレクトリ情報読み込み
     gi_SHEMADIR_DIR:=func_ReadIniKeyVale(g_DIRINF_SECSION,
                                          g_shemadir_DIR_KEY,
                                          g_shemadir_DIR);
     if ( gi_SHEMADIR_DIR = '' )
        or
        not(DirectoryExists(gi_SHEMADIR_DIR))
     then
       gi_SHEMADIR_DIR :=G_EnvPath + CST_SHEMA_DIR_NAME;

   //2)-11)シェーマオリジナルファイル、編集HTML格納先ディレクトリ情報読み込み
     gi_WAVEDIR_DIR:=func_ReadIniKeyVale(g_DIRINF_SECSION,
                                          g_wavedir_DIR_KEY,
                                          g_wavedir_DIR);
     if ( gi_WAVEDIR_DIR = '' )
        or
        not(DirectoryExists(gi_WAVEDIR_DIR))
     then
       gi_WAVEDIR_DIR :=G_EnvPath + CST_WAVE_FILE_NAME;

   //2)-12)メニュー画面画像ディレクトリ情報読み込み
     gi_image_dir:=func_ReadIniKeyVale(g_IMAGE_SECSION,
                                       g_IMAGE_DIR_KEY,
                                       g_IMAGE_DIR);
   //2)-13)-1)背景画像の格納先ファイル名読み込み
     gi_image_file:=func_ReadIniKeyVale(g_IMAGE_SECSION,
                                        g_IMAGE_FILE_KEY,
                                        g_IMAGE_FILE);
   //3)-1)受付票コメントＩＤ情報読み込み
     gi_Disp_CommentID:=func_ReadIniKeyVale(g_REPORTINF_SECSION,
                                       g_REPORTINF_ID_KEY,
                                       gi_REPORTINF_DEF);

end;

finalization
begin
    if gini_ProjectIni<> nil then
    begin
      gini_ProjectIni.Free;
      gini_ProjectIni:=nil;
    end;
    if gini_Wareki_Key<> nil then
    begin
      gini_Wareki_Key.Free;
      gini_Wareki_Key:=nil;
    end;
    w_wfini:=0 ;
    while  w_wfini <= ( high(gini_Wareki) ) do
    begin
      if gini_Wareki[w_wfini] <> nil then
      begin
        gini_Wareki[w_wfini].Free;
        gini_Wareki[w_wfini]:=nil;
      end;
      w_wfini := w_wfini + 1;
    end;
//
end;

end.
