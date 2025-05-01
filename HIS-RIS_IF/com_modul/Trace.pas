unit Trace;
{
■機能説明（使用予定：あり）
  トレースルーチン用
  －inisiarizeでファイル等の初期化
  －出力先：環境パスまたは実行パスのDOCTRC.SYS
例
proc_EntTrace('MA010','XXXX, XXXXXXX,XXXX ,XXXXxX');
proc_DumpTrace('SQL文','XXXXXXXXXXXXXXXX',length('XXXXXXXXXXXXXXXX'));
proc_EndTrace( 'MA010' );

トレースイメージ
*********+*********+*********+*********+*********+*********+*********+*********+
Start: MA010 ---------------------------------------------------------------
      Time(12/11/14 午後 12:14:46)
      TimeStamp[ 44086226]
      param:"1","01","$00FFFFFF","1","0","1","0","",
      [MemoryLoad][TotalPhys][AvailPhys][TotalPageFile][AvailPageFile][TotalVirtual][AvailVirtual]
DUMP : Message
      TimeStamp[ 44086226]
      XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
END  : MA010 ---------------------------------------------------------------------
      Time(12/11/14 午後 12:14:46)
      TimeStamp[ 44086226]
      [MemoryLoad][TotalPhys][AvailPhys][TotalPageFile][AvailPageFile][TotalVirtual][AvailVirtual]

*********+*********+*********+*********+*********+*********+*********+*********+

■履歴
新規作成：99.06.17：担当 iwai
修正    ：99.10.20：担当 iwai
  例外処理発生時のログ出力を追加  proc_TraceException

修正    ：00.06.09：担当 iwai
w_TraceModeを追加
w_TraceMode：iniの値をそのまま保存初期値は０
０：なし
１：詳細
   proc_EntTrace proc_EndTrace proc_DumpTrace
２：入口と出口と例外と指定のみ
   proc_EntTrace proc_EndTrace proc_TraceException proc_TraceMsgLog
関数追加
   procedure proc_TraceMsgLog(arg_place:string; arg_msg:string; arg_tracemode:string);

移設作成：2000.11.08：担当 iwai
  検索キー：追加RIS     //★追加RIS★
起動時に、Logファイルが指定サイズを超えたときに
Logファイルをシリアル番号をカウントして新規に作成する。
proc_MemSpaceTrace:メモリスペースを出力する。
レイアウトを変更
}

interface //*******************************************************************
//使用ユニット---------------------------------------------------------------
uses
//システム－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－
    Forms,
    Windows,
    Classes,
    SysUtils,
    FileCtrl,
//プロダクト開発共通－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－
    Gval,
    myInitInf
    ;

////型クラス宣言-------------------------------------------------------------
//type
//定数宣言-------------------------------------------------------------------
const
  wCST_TRAC_MODE0 = '0';
  wCST_TRAC_MODE1 = '1';
  wCST_TRAC_MODE2 = '2';
  wCST_TRAC_MODE3 = '3';
//変数宣言-------------------------------------------------------------------
var
 wi_int:integer;
//関数手続き宣言-------------------------------------------------------------
//●機能：メモリＤＵＭＰ（各画面は適宜呼ぶ）
//（継承元）呼出し元:com00.pas
procedure proc_DumpTrace(
                        arg_Msg:string;   //見出し（例：SQL文）
                        arg_point:string;//先頭アドレス（例：XXXXXXXXXXXXXXXX）
                        arg_lLen:Longint  //長さ上記の長さ
                         );

//●機能：処理の始まりで呼ぶ入り口トレース
//（継承元で使用各画面は意識不要）呼出し元:com00.pas
procedure proc_EntTrace(
                        arg_Pid:string;  // プログラムＩＤを指定（例：MA010）
                        arg_Param:string // パラメタを指定する
                                         //（例：XXXX, XXXXXXX,XXXX ,XXXXxX）
                        );
//●機能：処理の終わりで呼ぶ出口トレース
//（継承元で使用各画面は意識不要）呼出し元:com00.pas
procedure proc_EndTrace(
                        arg_Pid : string // プログラムＩＤを指定（例：MA010）
                        );
//●機能：例外のログ出力（各画面は意識不要）
//（アプリケーション出口で呼び出すのでﾒｲﾝから呼ばれる買う画面は意識不要）
//  Application.OnException := xxxxxxxxx; として登録して使用する。
procedure proc_TraceException(
                        Sender: TObject; //例外発生ｵﾌﾞｼﾞｪｸﾄ nilでもよい
                        E: Exception     //発生例外
                        );
//●機能：レベルログ出力（各画面は意識不要）
//
procedure proc_TraceMsgLog(
                        arg_place:string;     //場所コード
                        arg_msg:string;       //メッセージ
                        arg_tracemode:string  //ログ出力レベル トレースモード
                        );
//●機能：メモリ情報（必要なところ）
procedure proc_MemSpaceTrace;

implementation //**************************************************************

//定数宣言       -------------------------------------------------------------
const
  G_TRACE_FILE_PREFIX = 'SysTRC';
  G_TRACE_FILE_EXT    = '.log';
//変数宣言     ---------------------------------------------------------------
var
  wini_TRACE_Key: TStrings;  // トレースiniきー
  wini_TRACE: TAarrayTStrings;// トレース情報

  w_FileList: TStringList;  // リスト
  g_TRACE_FILENAME:string;
  w_TraceFlg: boolean;
  w_TraceFile: TextFile;
  w_FILENAME:string;
  w_FILENO:string;
  w_FileSize:Longint;
  //INI情報の取得
  w_TracePath: string;
  w_TraceMode: string;
  w_TraceFileSize:string;
  wi_TraceFileSize:Longint;

//関数手続き宣言--------------------------------------------------------------
//●機能処理の始まり
//例外は発生させない
procedure proc_EntTrace(
                        arg_Pid:string;  // プログラムＩＤを指定（例：MA010）
                        arg_Param:string // パラメタを指定する
                                         //（例：XXXX, XXXXXXX,XXXX ,XXXXxX）
                        );
var
  w_Str: string;
  w_DateTimm:TDateTime;
  w_MemoryInf: TMEMORYSTATUS;

begin
{レイアウト
Start: M0000 ---------------------------------------------------------------
      Time(12/11/14 午後 12:14:46)
      TimeStamp[ 44086226]
      param:"1","01","$00FFFFFF","1","0","1","0","",
      [MemoryLoad][TotalPhys][AvailPhys][TotalPageFile][AvailPageFile][TotalVirtual][AvailVirtual]

MemoryLoad;	/* 使用中のメモリの割合	*/
TotalPhys;	/* 物理メモリのバイト数	*/
AvailPhys;	/* 空き物理メモリのバイト数	*/
TotalPageFile;	/* ページング ファイルのバイト数	*/
AvailPageFile;	/* ページング ファイルの空きバイト数	*/
TotalVirtual;	/* アドレス空間のユーザー バイト数	*/
AvailVirtual;	/* 空きユーザー バイト数	*/

}
try
  if  w_TraceFlg<> true  then exit;
  if (wCST_TRAC_MODE1 <> w_TraceMode)
     and
     (wCST_TRAC_MODE2 <> w_TraceMode)
   then exit;
  //メモリ情報取得
  GlobalMemoryStatus(w_MemoryInf);
  //時間の取得
  w_DateTimm:=Now;
  //出力
  w_Str:= 'START: '
         + arg_Pid
         + ' ------------------------------------------------------------------------';
  Writeln(w_TraceFile,
          w_Str);

  w_Str:= '      Time'
         + '(' + DateTimeToStr (w_DateTimm) + ')';
  Writeln(w_TraceFile,
          w_Str);

  w_Str:= '      TimeStamp'
         + '[ '
         + IntToStr(DateTimeToTimeStamp(w_DateTimm).Time)
         + ']';
  Writeln(w_TraceFile,
          w_Str);

  w_Str:= '      Param:' + arg_Param;
  Writeln(w_TraceFile,
          w_Str);

  w_Str:= '      '
        +'['+IntToStr(w_MemoryInf.dwMemoryLoad)+']'
        +'['+IntToStr(w_MemoryInf.dwTotalPhys)+']'
        +'['+IntToStr(w_MemoryInf.dwAvailPhys)+']'
        +'['+IntToStr(w_MemoryInf.dwTotalPageFile)+']'
        +'['+IntToStr(w_MemoryInf.dwAvailPageFile)+']'
        +'['+IntToStr(w_MemoryInf.dwTotalVirtual)+']'
        +'['+IntToStr(w_MemoryInf.dwAvailVirtual)+']'
           ;

  Writeln(w_TraceFile,
          w_Str);

  Writeln(w_TraceFile);
except
   exit;
end;

end;
//●機能メモリＤＵＭＰ
//例外は発生させない
procedure proc_DumpTrace(
                        arg_Msg:string;   //見出し（例：SQL文）
                        arg_point:string;//先頭アドレス（例：XXXXXXXXXXXXXXXX）
                        arg_lLen:Longint  //長さ上記の長さ
                         );
var
  w_Str: string;
  w_DateTimm:TDateTime;
begin
{レイアウト
DUMP : MA010
      Time(12/11/14 午後 12:14:46)
      XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
}
try
  if  w_TraceFlg<> true  then exit;
  if (wCST_TRAC_MODE1 <> w_TraceMode)
  then exit;

  w_DateTimm:=Now;
  w_Str := 'DUMP : '+ arg_Msg ;
  Writeln(w_TraceFile,
          w_Str);

  w_Str:= '      TimeStamp'
         + '[ '
         + IntToStr(DateTimeToTimeStamp(w_DateTimm).Time)
         + ']';
  Writeln(w_TraceFile,
          w_Str);

  w_Str := '       ' + copy(arg_point,1,arg_lLen);
  Writeln(w_TraceFile,
          w_Str);

  Writeln(w_TraceFile);
except
   exit;
end;
end;
//●機能処理の終わり
//例外は発生させない
procedure proc_EndTrace(
                        arg_Pid : string // プログラムＩＤを指定（例：MA010）
                        );
var
  w_Str: string;
  w_DateTimm:TDateTime;
  w_MemoryInf: TMEMORYSTATUS;
begin
{レイアウト
END  : MA010 ---------------------------------------------------------------------
      Time(12/11/14 午後 12:14:46)
      TimeStamp[ 44086226]
      [MemoryLoad][TotalPhys][AvailPhys][TotalPageFile][AvailPageFile][TotalVirtual][AvailVirtual]

}
try
  if  w_TraceFlg<> true  then exit;
  if (wCST_TRAC_MODE1 <> w_TraceMode)
     and
     (wCST_TRAC_MODE2 <> w_TraceMode)
   then exit;

  //メモリ情報取得
  GlobalMemoryStatus(w_MemoryInf);
  //時間の取得
  w_DateTimm:=Now;

  //出力
  w_Str:= 'END  : ' + arg_Pid
         + ' ------------------------------------------------------------------------';
  Writeln(w_TraceFile,
          w_Str);

  w_Str:= '      Time'
         + '(' + DateTimeToStr (w_DateTimm) + ')';
  Writeln(w_TraceFile,
          w_Str);

  w_Str:= '      TimeStamp'
         + '[ '
         + IntToStr(DateTimeToTimeStamp(w_DateTimm).Time)
         + ']';
  Writeln(w_TraceFile,
          w_Str);

  w_Str:= '      '
        +'['+IntToStr(w_MemoryInf.dwMemoryLoad)+']'
        +'['+IntToStr(w_MemoryInf.dwTotalPhys)+']'
        +'['+IntToStr(w_MemoryInf.dwAvailPhys)+']'
        +'['+IntToStr(w_MemoryInf.dwTotalPageFile)+']'
        +'['+IntToStr(w_MemoryInf.dwAvailPageFile)+']'
        +'['+IntToStr(w_MemoryInf.dwTotalVirtual)+']'
        +'['+IntToStr(w_MemoryInf.dwAvailVirtual)+']'
           ;

  Writeln(w_TraceFile,
          w_Str);

  Writeln(w_TraceFile);
except
   exit;
end;
end;

//●機能処理の始まり
//例外は発生させない
procedure proc_MemSpaceTrace;
var
  w_Str: string;
  w_MemoryInf: TMEMORYSTATUS;
begin
{レイアウト
-------------------------------------------------------------------------------------
MEMIF:[MemoryLoad][TotalPhys][AvailPhys][TotalPageFile][AvailPageFile][TotalVirtual][AvailVirtual]
-------------------------------------------------------------------------------------

MemoryLoad;	/* 使用中のメモリの割合	*/
TotalPhys;	/* 物理メモリのバイト数	*/
AvailPhys;	/* 空き物理メモリのバイト数	*/
TotalPageFile;	/* ページング ファイルのバイト数	*/
AvailPageFile;	/* ページング ファイルの空きバイト数	*/
TotalVirtual;	/* アドレス空間のユーザー バイト数	*/
AvailVirtual;	/* 空きユーザー バイト数	*/

}
try
  if  w_TraceFlg<> true  then exit;
  if (wCST_TRAC_MODE1 <> w_TraceMode) then exit;
  //メモリ情報取得
  GlobalMemoryStatus(w_MemoryInf);
  //出力
  w_Str:= '-------------------------------------------------------------------------------------';
  Writeln(w_TraceFile,
          w_Str);

  w_Str:= 'MEMIF:'
        +'['+IntToStr(w_MemoryInf.dwMemoryLoad)+']'
        +'['+IntToStr(w_MemoryInf.dwTotalPhys)+']'
        +'['+IntToStr(w_MemoryInf.dwAvailPhys)+']'
        +'['+IntToStr(w_MemoryInf.dwTotalPageFile)+']'
        +'['+IntToStr(w_MemoryInf.dwAvailPageFile)+']'
        +'['+IntToStr(w_MemoryInf.dwTotalVirtual)+']'
        +'['+IntToStr(w_MemoryInf.dwAvailVirtual)+']' ;
  Writeln(w_TraceFile,
          w_Str);

  w_Str:= '-------------------------------------------------------------------------------------';
  Writeln(w_TraceFile,
          w_Str);

  Writeln(w_TraceFile);

except
   exit;
end;
end;

//●機能：例外のログ出力
//例外は発生させない
procedure proc_TraceException(Sender: TObject; E: Exception);
var
  w_Str: string;
  w_DateTimm:TDateTime;
  w_heaher:string;
  w_msg:string;
begin
  //例外はそのまま表示
  //Application.ShowException(E);
try
  if  w_TraceFlg<> true  then exit;
  w_heaher:= '！！！！！ 例外発生 ！！！！！' +
             '(' + DateTimeToStr (now) + ')';
  w_msg := E.Message;

  w_DateTimm:=Now;
  w_Str:= w_heaher + ':['+IntToStr(DateTimeToTimeStamp(w_DateTimm).Time) +']';
  Writeln(w_TraceFile,
          w_Str);
  w_Str := copy(w_msg,1,Length(w_msg));
  Writeln(w_TraceFile,
          w_Str);
  Writeln(w_TraceFile);

except
   exit;
end;
   exit;
end;

//●機能：レベルログ出力
//例外は発生させない
procedure proc_TraceMsgLog(arg_place:string; arg_msg:string; arg_tracemode:string);
var
  w_Str: string;
  w_DateTimm:TDateTime;
  w_heaher:string;
begin
  //例外はそのまま表示
  //Application.ShowException(E);
try
  if  w_TraceFlg<> true  then exit;
  if  0 >= length(trim(arg_tracemode))  then exit;

  if (StrToIntDef(arg_tracemode,3) < StrToInt(w_TraceMode)) then exit;
  w_heaher:= '＊＊＊＊＊ メッセージログ ＊＊＊＊＊' +
             '(' + DateTimeToStr (now) + ')';
  w_DateTimm:=Now;
  w_Str:= w_heaher + ':['+IntToStr(DateTimeToTimeStamp(w_DateTimm).Time) +']';
  Writeln(w_TraceFile,
          w_Str);
  w_Str:= arg_place + ' : ';
  Writeln(w_TraceFile,
          w_Str);
  w_Str:= arg_msg  ;
  Writeln(w_TraceFile,
          w_Str);
  Writeln(w_TraceFile);

except
   exit;
end;
   exit;
end;
//●機能
{
function func_XXX( arg_XXXXXX: string):Txxxx;

begin

end;
}

initialization
begin
//*********+*********+*********+*********+*********+*********+*********+*********+
//①動作情報初期値設定
    w_TraceFlg:= false;
    w_TraceMode:= wCST_TRAC_MODE0;
//②TRACE INI情報読み込み
     wini_TRACE_Key :=
            func_ReadIniSecKeyToTStrings(
                                      g_product_inifile_name,
                                      g_TRACE_SECSION
                                                         );
     //INIがなければ動かない。
     if (wini_TRACE_Key= nil) or
        (wini_TRACE_Key.Count=0)then Exit;
     //情報格納域配列の大きさ設定   gini_Wareki  wa_KeyValues
     SetLength ( wini_TRACE ,wini_TRACE_Key.Count);
     if wini_TRACE_Key.Count < 1 then exit;
     if False=func_ReadIniSecToATStrings(
                                g_product_inifile_name,
                                g_TRACE_SECSION,
                                wini_TRACE_Key,
                                wini_TRACE
                                                   ) then Exit;
    //トレースモード判定
    if (high(wini_TRACE)<0) then exit;
    w_TraceMode:=func_IniKeyValue(wini_TRACE_Key,
                                   wini_TRACE,
                                   g_MODE_KEY,
                                   0,
                                   wCST_TRAC_MODE0);
    if (wCST_TRAC_MODE1 <> w_TraceMode)
       and
       (wCST_TRAC_MODE2 <> w_TraceMode)
       and
       (wCST_TRAC_MODE3 <> w_TraceMode)
    then exit;
//③トレースパス設定
    w_TracePath:=G_EnvPath;
{
    w_TracePath:= func_IniKeyValue(wini_TRACE_Key,
                                   wini_TRACE,
                                   g_PATH_KEY,
                                   0,
                                   w_TracePath);
}
    w_TracePath:= func_ReadIniKeyVale(
                                   g_TRACE_SECSION,
                                   g_PATH_KEY,
                                   w_TracePath);

    if (length(w_TracePath)=0) or
       (DirectoryExists(w_TracePath)=False) then
       wini_TRACE[1][0]:=G_EnvPath;
//④ファイルサイズ設定  //★追加RIS★
    w_TraceFileSize:=G_FILESIZE;
    w_TraceFileSize:=func_ReadIniKeyVale(
                                   g_TRACE_SECSION,
                                   g_FILESIZE_KEY,
                                   w_TraceFileSize);
    if StrToIntDef(w_TraceFileSize,0)<=0 then
    begin
      w_TraceFileSize:=G_FILESIZE;
    end;
    wi_TraceFileSize:=StrToInt(w_TraceFileSize);
//⑥トレースファイル名決定  //★追加RIS★
    w_FileList:=func_FileList(w_TracePath+G_TRACE_FILE_PREFIX+'*'+G_TRACE_FILE_EXT);
    if (w_FileList<>nil)
      and
       (w_FileList.Count>=1)
    then
    begin
      w_FileList.Sort;
      w_FILENAME:=w_FileList[w_FileList.count-1];
      w_FileSize:=func_FileSize(w_TracePath+w_FILENAME);
      if w_FileSize>wi_TraceFileSize then
      begin
        w_FILENO:=Copy(w_FILENAME,length(G_TRACE_FILE_PREFIX)+1,2);
        w_FILENO:=FormatFloat('00',StrToInt(w_FILENO)+1);
        g_TRACE_FILENAME:= G_TRACE_FILE_PREFIX+w_FILENO+ G_TRACE_FILE_EXT;
      end else
      begin
        g_TRACE_FILENAME:=w_FILENAME;
      end;
    end else
    begin
      g_TRACE_FILENAME:= G_TRACE_FILE_PREFIX+'01'+ G_TRACE_FILE_EXT;
    end;

//⑥トレース初期化
    try
    AssignFile(w_TraceFile, w_TracePath + g_TRACE_FILENAME);
    try
      {$I-}
      if (FileExists(w_TracePath + g_TRACE_FILENAME)) then
        Append(w_TraceFile)
      else
        Rewrite(w_TraceFile);
      {$I+}
      if IOResult = 0 then
      Begin
        Writeln(w_TraceFile,
'*********+*********+*********+*********+*********+*********+*********+*********+'
         );
        Writeln(w_TraceFile);
        w_TraceFlg:= true;
      end;
    except
      CloseFile(w_TraceFile);
      exit;
    end;
    except
      exit;
    end;

end;

finalization
begin
//トレース終了化
  if  w_TraceFlg= true then
  begin
    w_TraceFlg:=false;
    Writeln(w_TraceFile,
'*********+*********+*********+*********+*********+*********+*********+*********+'
);
    Writeln(w_TraceFile);
    CloseFile(w_TraceFile);
  end;
//領域の解放
  if wini_TRACE_Key<> nil then
  begin
     wini_TRACE_Key.free;
     wini_TRACE_Key:=nil;
  end;
//領域の解放
  wi_int:=0 ;
  while  wi_int <= ( high(wini_TRACE) - 1 ) do
  begin
    if wini_TRACE[wi_int] <> nil then
    begin
      wini_TRACE[wi_int].Free;
      wini_TRACE[wi_int]:=nil;
    end;
    wi_int := wi_int + 1;
  end;
end;

end.
