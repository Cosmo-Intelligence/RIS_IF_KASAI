unit pdct_shema;
{
■機能説明 （使用予定：あり）
 EXEプロジェクトのシェーマ共通ルーチン
■履歴
修正  ：2002.11.05：増田
修正　：2003.02.07：増田 友
　　　　　　　　　　オーダNO変更に伴う修正
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
  IniFiles,
  FileCtrl,
  jis2sjis,
//プロダクト開発共通－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－
  //NMFtp,
  Gval,
  risftp;

////型クラス宣言-------------------------------------------------------------
//type
//定数宣言-------------------------------------------------------------------

const
CST_SHEMA_DIR = 'shema'; //クライアントのシェーマ格納先ディレクトリ(起動ディレクトリ+)
CST_SHEMA_HTML_ORIGINAL = 'shemaoriginal.html';
CST_SHEMA_HTML_ORDER = 'shemaorder.html';
CST_SHEMA_END_TITLE = 'SHEMA'; //シェーマ用ブラウザ終了タイトル検索文字列

CST_END_MODULE: string = '';
CST_END_TITLE_PTN1: string = '';
CST_END_TITLE_PTN2: string = '';

//変数宣言-------------------------------------------------------------------
var
//●シェーマ関数の戻り
  wg_Ret: Boolean;
  wg_Shema_Ret_Count: integer;
  wg_Shema_Ret_Code: string;
  wg_Shema_Ret_Message: string;
  //ブラウザ終了用タイトル検索文字列リスト
  wg_EndTitle_List: array of string;
  wg_EndTitle_Count: integer;

//関数手続き宣言-------------------------------------------------------------

//●FTP関係
  //シェーマ情報チェック
  function func_FTP_Data_Check(
           arg_FtpInfo : TFtp_Info;  //Ftp情報
           arg_Shema_File: string;
           arg_MAIN_DIR: string;
           arg_SUB_DIR : string;
           arg_Local_File: string;
           var arg_Error_Code:string;    //エラーコード
           var arg_Error_Message:string  //エラーメッセージ
           ):Boolean;
  //オーダメイン更新
  function func_FTP_Update(
           arg_RIS_ID: string;
           arg_MAIN_DIR: string;
           arg_SUB_DIR : string;
           var arg_count: integer;
           var arg_Error_Code:string;    //エラーコード
           var arg_Error_Message:string  //エラーメッセージ
           ):Boolean;
//●ｼｪｰﾏ表示関係
  //ローカルファイル名(HIS→RISｻｰﾊﾞ)作成
  function func_Shema_Make_FileName(
           arg_RIS_ID: string;
           var arg_count: integer;
           var arg_Error_Code:string;    //エラーコード
           var arg_Error_Message:string  //エラーメッセージ
           ):Boolean;
  //シェーマファイルコピー(RISｻｰﾊﾞ→RISｸﾗｲｱﾝﾄ)
  function func_Shema_Copy_File(
           var arg_count: integer;
           var arg_Error_Code:string;    //エラーコード
           var arg_Error_Message:string  //エラーメッセージ
           ):Boolean;
  //HTMLファイル作成
  function func_Shema_Make_HTML(
           arg_Mode: integer;            //ファイル位置(0:ｸﾗｲｱﾝﾄにｺﾋﾟｰ済、1:ﾛｰｶﾙをそのまま使用)
           arg_OrderNO: string;
           arg_KanjaID: string;
           arg_KanjaName: string;
           arg_KensaDate: string;
           arg_KensaType: string;
           arg_IraiSection: string;
           arg_IraiDoctor: string;
           var arg_Error_Code:string;    //エラーコード
           var arg_Error_Message:string  //エラーメッセージ
           ):Boolean;


implementation

uses DB;

//uses DB; //**************************************************************

//使用ユニット---------------------------------------------------------------
//uses

//定数宣言       -------------------------------------------------------------
//const

//変数宣言     ---------------------------------------------------------------
//var
//関数手続き宣言--------------------------------------------------------------
//使用可能関数－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－

//******************************************************************************
// シェーマ情報チェック
//******************************************************************************
function func_FTP_Data_Check(
         arg_FtpInfo : TFtp_Info;  //Ftp情報
         arg_Shema_File: string;
         arg_MAIN_DIR: string;
         arg_SUB_DIR : string;
         arg_Local_File: string;
         var arg_Error_Code:string;    //エラーコード
         var arg_Error_Message:string  //エラーメッセージ
         ):Boolean;
begin
  Result := False;
  arg_Error_Code := '';
  arg_Error_Message := '';

  if arg_FtpInfo.f_FtpServerName = '' then begin
    arg_Error_Message := #13#10+'サーバ名：'+arg_FtpInfo.f_FtpServerName;
    Exit;
  end;
  if arg_FtpInfo.f_FtpServerUID = '' then begin
    arg_Error_Message := #13#10+'ユーザＩＤ：'+arg_FtpInfo.f_FtpServerUID;
    Exit;
  end;
{
  if arg_FtpInfo.f_FtpServerPSW = '' then begin
    arg_Error_Message := #13#10+'パスワード：'+arg_FtpInfo.f_FtpServerPSW;
    Exit;
  end;
}
  if arg_Shema_File = '' then begin
    arg_Error_Message := #13#10+'シェーマファイル：'+arg_Shema_File;
    Exit;
  end;

  if (arg_MAIN_DIR = '') and (arg_SUB_DIR = '') then begin
    arg_Error_Message := #13#10+'ローカルディレクトリ：'+arg_MAIN_DIR+arg_SUB_DIR;
    Exit;
  end;
  if arg_Local_File = '' then begin
    arg_Error_Message := #13#10+'ローカルファイル：'+arg_Local_File;
    Exit;
  end;

  Result := True;
end;
//******************************************************************************
// オーダメイン更新処理
//******************************************************************************
function func_FTP_Update(
         arg_RIS_ID: string;
         arg_MAIN_DIR: string;
         arg_SUB_DIR : string;
         var arg_count: integer;
         var arg_Error_Code:string;    //エラーコード
         var arg_Error_Message:string  //エラーメッセージ
         ):Boolean;
var
  w_DateTime:String;
  w_Ris_ID:String;
  SQL:TStrings;
  SetData:TStrings;
  ValueData:TStrings;
const
  CST_ERRCOD_00 = '00';
  CST_ERRMSG_00 = 'RIS_IDに誤りがあります';
  CST_ERRCOD_01 = '01';
  CST_ERRMSG_01 = 'シェーマ画像がありません';
  CST_ERRCOD_02 = '02';
  CST_ERRMSG_02 = 'シェーマ画像が取得されていません';
begin
{
  Result := False;
  arg_count := 0;
  arg_Error_Code := '';
  arg_Error_Message := '';

  if arg_RIS_ID = '' then begin
    arg_Error_Code    := CST_ERRCOD_00;
    arg_Error_Message := CST_ERRMSG_00;
    Exit;
  end;
  w_DateTime := FormatDateTime(CST_FORMATDATE_4, func_GetDBSysDate);
//更新処理
  ProcDBTranStart;
  //2003.02.07
  //RIS_IDの取得
  w_Ris_ID := arg_RIS_ID;
  SQL := TStringList.Create;
  SetData := TStringList.Create;
  ValueData := TStringList.Create;
  try
    //オーダメインテーブル
    SQL.Add('UPDATE ORDERMAINTABLE SET ');
    SQL.Add(' SHEMA_DIR    = :PSHEMA_DIR ');
    SQL.Add(',SHEMA_SUBDIR = :PSHEMA_SUBDIR ');
    SQL.Add('WHERE RIS_ID = :PRIS_ID ');
    SetData.Add('PSHEMA_DIR');
    SetData.Add('PSHEMA_DIR');

    ValueData.Add(arg_MAIN_DIR)
    ValueData.Add(arg_SUB_DIR)
    ParamByName('PSHEMA_DIR').AsString     := arg_MAIN_DIR;
    ParamByName('PSHEMA_SUBDIR').AsString  := arg_SUB_DIR;
    ParamByName('PRIS_ID').AsString       := w_Ris_ID;


    ExecSQL;



    if w_Ris_ID <> '' then begin
      //実績メインテーブル
      with arg_Query do begin
        Close;
        SQL.Clear;
        SQL.Add('UPDATE EXMAINTABLE SET ');
        SQL.Add(' SHEMA_SYUTOKU_DATE = :PSHEMA_SYUTOKU_DATE ');
        SQL.Add('WHERE RIS_ID = :PRIS_ID ');
        if not Prepared then Prepare;
        ParamByName('PSHEMA_SYUTOKU_DATE').AsDateTime := w_DateTime;
        ParamByName('PRIS_ID').AsString               := w_Ris_ID;

        ExecSQL;
      end;

    end;
    SQL.Free;
    SetData.Free;
    ValueData.Free;
    try
      ProcCommitDB; // 成功した場合，変更をコミットする
    except
      on E: Exception do begin
        procRollBackDB; // コミットで失敗した場合，変更を取り消す
        arg_Error_Code    := CST_ERRCOD_01;
        arg_Error_Message := '(COMMIT)'+E.Message;
        Exit;
      end;
    end;
  except
    on E: Exception do begin
      procRollBackDB; // 失敗した場合，変更を取り消す
      arg_Error_Code    := CST_ERRCOD_01;
      arg_Error_Message := E.Message;
      Exit;
    end;
  end;
  }
  Result := True;
end;

//－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－
//******************************************************************************
// ローカルファイル名(HIS→RISｻｰﾊﾞ)作成
//******************************************************************************
function func_Shema_Make_FileName(
         arg_RIS_ID: string;
         var arg_count: integer;
         var arg_Error_Code:string;    //エラーコード
         var arg_Error_Message:string  //エラーメッセージ
         ):Boolean;
var
  i: integer;
  w_OrderNO: string;
  w_Bui_File: string;
  w_Bui_Name: string;
  w_Bui_Comment: string;
  w_ShemaPass: string;
  w_ShemaDirM,w_ShemaDirS: string;
  w_Set_Count: integer;
  wPos0,wPos1,wPos2{,wPosLoop}: integer;
  wPos: integer;
  w_Comment: string;
  //2003.02.07
  w_Hakko_Date:String;
  SQL:TStrings;
//  SelectData:TArrayofString;
  SelectResult:integer;  //SQL実行結果
const
  CST_ERRCOD_00 = '00';
  CST_ERRMSG_00 = 'オーダNOに誤りがあります';
  CST_ERRCOD_01 = '01';
  CST_ERRMSG_01 = 'シェーマ画像がありません';
  CST_ERRCOD_02 = '02';
  CST_ERRMSG_02 = 'シェーマ画像が取得されていません';
begin
(*
  Result := False;
  arg_count := 0;
  arg_Error_Code := '';
  arg_Error_Message := '';

  g_Shema_OrderNO := '';
  g_Shema_KanjaID := '';
  g_Shema_KanjaName := '';
  for i := 0 to 9 do begin
    g_Shema_Bui_File[i] := '';
    g_Shema_Bui_Name[i] := '';
    g_Shema_Bui_Comment[i] := '';
    g_Shema_DirM[i] := '';
    g_Shema_DirS[i] := '';
    g_Shema_File[i] := '';
  end;

  if arg_RIS_ID = '' then begin
    arg_Error_Code    := CST_ERRCOD_00;
    arg_Error_Message := CST_ERRMSG_00;
    Exit;
  end;

  SQL := TStringList.Create;
  try
    w_Set_Count := 0;
    try
      SQL.Add ('SELECT od.ORDERNO, ');
      SQL.Add ('       od.SHEMAPASS_01,od.SHEMAPASS_02,od.SHEMAPASS_03,od.SHEMAPASS_04,od.SHEMAPASS_05, ');
      SQL.Add ('       od.SHEMAPASS_06,od.SHEMAPASS_07,od.SHEMAPASS_08,od.SHEMAPASS_09,od.SHEMAPASS_10, ');
      SQL.Add ('       od.SHEMAJOUHOU_01,od.SHEMAJOUHOU_02,od.SHEMAJOUHOU_03,od.SHEMAJOUHOU_04, od.SHEMAJOUHOU_05, ');
      SQL.Add ('       od.SHEMAJOUHOU_06,od.SHEMAJOUHOU_07,od.SHEMAJOUHOU_08,od.SHEMAJOUHOU_09, od.SHEMAJOUHOU_10, ');
      SQL.Add ('       od.SHEMABUIJOUHOU_01,od.SHEMABUIJOUHOU_02, od.SHEMABUIJOUHOU_03,od.SHEMABUIJOUHOU_04, od.SHEMABUIJOUHOU_05, ');
      SQL.Add ('       od.SHEMABUIJOUHOU_06,od.SHEMABUIJOUHOU_07, od.SHEMABUIJOUHOU_08,od.SHEMABUIJOUHOU_09, od.SHEMABUIJOUHOU_10, ');
//        SQL.Add ('       od.SHEMA_DIR, od.SHEMA_SUBDIR,');
      SQL.Add ('       od.SHEMA_DIR, od.SHEMA_SUBDIR, TO_CHAR(od.HIS_HAKKO_DATE,''YYYYMMDD'') AS HIS_HAKKO_DATE,');
      SQL.Add ('       km.KANJAID,km.KANJISIMEI ');
      SQL.Add (' FROM '+GOrderMainTable+' od,'+ GPatient +' km');
      //2003.02.07
//        SQL.Add ('WHERE od.ORDERNO = ''' + arg_OrderNO + '''' );
      SQL.Add ('WHERE od.RIS_ID = ''' + arg_RIS_ID + '''' );
      SQL.Add ('  AND km.KANJAID = od.KANJAID ' );


      try
        //SQL実行
        SelectResult:=FuncSelectDB(SQL,nil,nil,SelectData);
      except
        raise;
        //Exit;
      end;


      if (SelectResult > 0) then begin
        g_Shema_OrderNO := SelectData[0][0];
        g_Shema_KanjaID := SelectData[0][34];
        g_Shema_KanjaName := SelectData[0][35];

        w_OrderNO   := SelectData[0][0];
        w_ShemaDirM := SelectData[0][31];
        w_ShemaDirS := SelectData[0][32];
        //2003.02.07
        w_Hakko_Date := SelectData[0][33];
        if w_OrderNO = '' then begin
          arg_Error_Code    := CST_ERRCOD_00;
          arg_Error_Message := CST_ERRMSG_00;
          Exit;
        end;
        //2002.11.05
        {if (w_ShemaDirM = '') and (w_ShemaDirS = '') then begin
          arg_Error_Code    := CST_ERRCOD_02;
          arg_Error_Message := CST_ERRMSG_02;
          Exit;
        end;}
        //既に格納済みの場合、その存在をチェックする
        for i := 0 to 9 do begin
          w_Bui_File := SelectData[0][i+1];
          w_Bui_Name := SelectData[0][i+21];
          w_Bui_Comment := SelectData[0][i+11];

          if w_Bui_File <> '' then begin
            //サーバのローカルファイル名作成
            w_ShemaPass := func_Make_ShemaName(w_OrderNO + w_Hakko_Date,
                                               w_Bui_File,
                                               i+1
                                               );
            if w_ShemaPass <> '' then begin
              g_Shema_Bui_File[i]   := w_Bui_File;
              g_Shema_Bui_Name[i]   := w_Bui_Name;
//2002.12.26
              //g_Shema_Bui_Comment[i]:= w_Bui_Comment;
              g_Shema_Bui_Comment[i]:= '';
              while AnsiPos('</COMMENT>',w_Bui_Comment) > 0 do begin
                wPos:=AnsiPos('</COMMENT>',w_Bui_Comment);
                wPos0:=AnsiPos('<COMMENT',w_Bui_Comment);
                if wPos0 > 0 then begin
                  w_Bui_Comment := Copy(w_Bui_Comment,wPos0+8,Length(w_Bui_Comment));
                  wPos1:=AnsiPos('>',w_Bui_Comment);
                  wPos2:=AnsiPos('<',w_Bui_Comment);
                  w_Comment := Copy(w_Bui_Comment,wPos1+1,wPos2-wPos1-1);
                  if g_Shema_Bui_Comment[i] = '' then
                    g_Shema_Bui_Comment[i]:=w_Comment
                  else
                    g_Shema_Bui_Comment[i]:=g_Shema_Bui_Comment[i]
                                           +#13#10
                                           +w_Comment;
                end;
                w_Bui_Comment := Copy(w_Bui_Comment,AnsiPos('</COMMENT>',w_Bui_Comment)+10,Length(w_Bui_Comment));
              end;

              g_Shema_DirM[i] := w_ShemaDirM;
              g_Shema_DirS[i] := w_ShemaDirS;
              g_Shema_File[i] := w_ShemaPass;
              w_Set_Count := w_Set_Count + 1;
              //部位名称を求める
              if w_Bui_Name <> '' then begin
                SQL.Clear;
                SQL.Add ('SELECT bm.BUI_ID,bm.BUI_NAME ');
                SQL.Add (' FROM '+GBuiMaster +' bm');
                SQL.Add ('WHERE bm.BUI_ID = ''' + w_Bui_Name + '''' );
                try
                  //SQL実行
                  SelectResult:=FuncSelectDB(SQL,nil,nil,SelectData);
                except
                  raise;
                  //Exit;
                end;
                if (SelectResult > 0) then begin
                  g_Shema_Bui_Name[i]   := SelectData[0][1];
                end;
              end;
            end;
          end;
        end;
      end;
    except
      on E: Exception do begin
        arg_Error_Code    := CST_ERRCOD_00;
        arg_Error_Message := CST_ERRMSG_00 + E.Message;
        Exit;
      end;
    end;
  finally
  end;

  //ファイルが存在しない場合、エラーとする
  if w_Set_Count = 0 then begin
    arg_Error_Code    := CST_ERRCOD_01;
    arg_Error_Message := CST_ERRMSG_01;
    Exit;
  end;

  arg_count := w_Set_Count;
  SQL.free;
  *)
  Result := True;
end;
//******************************************************************************
// シェーマファイルコピー(RISｻｰﾊﾞ→RISｸﾗｲｱﾝﾄ)
//******************************************************************************
function func_Shema_Copy_File(
         var arg_count: integer;
         var arg_Error_Code:string;    //エラーコード
         var arg_Error_Message:string  //エラーメッセージ
         ):Boolean;
var
  i: integer;
  w_ClientDir: string;
  w_FileName: string;
  sr: TSearchRec;

  w_P: integer;
  w_Kakuchosi: string;

  w_ShemaFile: string;
  w_ClientFile: string;
  w_Set_Count: integer;
const
  CST_ERRCOD_01 = '01';
  CST_ERRMSG_01 = 'シェーマ画像がありません';
  CST_ERRCOD_02 = '02';
  CST_ERRMSG_02 = 'シェーマ画像の拡張子が取得できません';
  CST_ERRCOD_03 = '03';
  CST_ERRMSG_03 = 'クライアントへのコピーに失敗しました';
begin
  Result := False;
  arg_count := 0;
  arg_Error_Code := '';
  arg_Error_Message := '';
  (*
  for i := 0 to 9 do begin
    g_Shema_Client_File[i] := '';
  end;
//クライアントの格納先フォルダ内のファイルを削除
  w_ClientDir := G_RunPath + CST_SHEMA_DIR + '\';
  if not DirectoryExists(w_ClientDir) then
    ForceDirectories(w_ClientDir);
  i := FindFirst(w_ClientDir+'*.*', faAnyFile, sr);
  try
    if i = 0 then begin
      repeat
        w_FileName := w_ClientDir+sr.Name;
        if FileExists(w_FileName) then
          DeleteFile(w_FileName);
      until FindNext(sr) <> 0;
    end;
  finally
    FindClose(sr);
  end;

//コピー処理
  w_Set_Count := 0;
  for i := 0 to 9 do begin
    if g_Shema_File[i] <> '' then begin
      if g_Shema_DirM[i] <> '' then
        if '\' <> Copy(g_Shema_DirM[i],Length(g_Shema_DirM[i]),1) then
          g_Shema_DirM[i] := g_Shema_DirM[i] + '\';
      if g_Shema_DirS[i] <> '' then
        if '\' <> Copy(g_Shema_DirS[i],Length(g_Shema_DirS[i]),1) then
          g_Shema_DirS[i] := g_Shema_DirS[i] + '\';
      //コピー元ファイル名
      w_ShemaFile := g_Shema_DirM[i] + g_Shema_DirS[i] + g_Shema_File[i];
      if FileExists(w_ShemaFile) then begin
        //コピー元ファイル名より拡張子位置取得
        w_P := Pos('.',w_ShemaFile);
        if w_P <= 0 then begin
          arg_Error_Code    := CST_ERRCOD_02;
          arg_Error_Message := CST_ERRMSG_02;
          Exit;
        end;
        w_Kakuchosi := Copy(w_ShemaFile,w_P,Length(w_ShemaFile)-w_P+1);
        //コピー先ファイル名
        w_ClientFile := w_ClientDir + '\' + FormatFloat('00',i) + '_' + w_Kakuchosi;
        //コピー
        if not CopyFile(PChar(w_ShemaFile), PChar(w_ClientFile), True) then begin
          arg_Error_Code    := CST_ERRCOD_03;
          arg_Error_Message := CST_ERRMSG_03;
          Exit;
        end;
        g_Shema_Client_File[i] := w_ClientFile;
        w_Set_Count := w_Set_Count + 1;
      end;
    end;
  end;

  //ファイルが存在しない場合、エラーとする
  if w_Set_Count = 0 then begin
    arg_Error_Code    := CST_ERRCOD_01;
    arg_Error_Message := CST_ERRMSG_01;
    Exit;
  end;

  arg_count := w_Set_Count;
  Result := True;
  *)
end;
//******************************************************************************
// HTMLファイル作成
//******************************************************************************
function func_Shema_Make_HTML(
         arg_Mode: integer;            //ファイル位置(0:ｸﾗｲｱﾝﾄにｺﾋﾟｰ済、1:ﾛｰｶﾙをそのまま使用)
         arg_OrderNO: string;
         arg_KanjaID: string;
         arg_KanjaName: string;
         arg_KensaDate: string;
         arg_KensaType: string;
         arg_IraiSection: string;
         arg_IraiDoctor: string;
         var arg_Error_Code:string;    //エラーコード
         var arg_Error_Message:string  //エラーメッセージ
         ):Boolean;
var
  TxtFile: TextFile;
  w_Record: string;
  w_GouNO: integer;
  w_HTML_Text: string;

  w_ShemaFile: string;
  w_Local_File: string;
  w_Bui_Name: string;
  w_Bui_Comment: string;
  i: integer;
  w_No: string;
  w_Name: string;
  ws_HTML_SHEMA:String;
  SQL:TStrings;
  SetData:TStrings;
  ValueData:TStrings;
//  SelectData:TArrayofString;
  SelectResult:integer;  //SQL実行結果
const
  CST_ERRCOD_01 = '01';
  CST_ERRMSG_01 = 'シェーマ画像がありません';
  CST_ERRCOD_02 = '02';
  CST_ERRMSG_02 = 'ファイルの読み込みに失敗しました';
  CST_ERRCOD_03 = '03';
  CST_ERRMSG_03 = 'HTMLファイルの作成に失敗しました';
  CST_ERRCOD_04 = '04';
  CST_ERRMSG_04 = 'HTMLファイルが存在しません';
begin
  Result := False;
  (*
  arg_Error_Code := '';
  arg_Error_Message := '';
//サーバのローカルファイルをそのまま使用する場合
  if arg_Mode = 1 then begin
    for i := 0 to 9 do begin
      g_Shema_Client_File[i] := '';
      //ﾛｰｶﾙﾌｧｲﾙ名をｸﾗｲｱﾝﾄﾌｧｲﾙ名にｺﾋﾟｰ
      if g_Shema_File[i] <> '' then begin
        if g_Shema_DirM[i] <> '' then begin
          if ('\' <> Copy(g_Shema_DirM[i],Length(g_Shema_DirM[i]),1)) then
            g_Shema_DirM[i] := g_Shema_DirM[i] + '\';
        end;
        if g_Shema_DirS[i] <> '' then begin
          if ('\' <> Copy(g_Shema_DirS[i],Length(g_Shema_DirS[i]),1)) then
            g_Shema_DirS[i] := g_Shema_DirS[i] + '\';
          if ('\' = Copy(g_Shema_DirS[i],1,1)) then
            g_Shema_DirS[i] := Copy(g_Shema_DirS[i],2,Length(g_Shema_DirS[i])-1);
        end;
        //コピー元ファイル名をそのままクライアントファイル名に格納
        w_ShemaFile := g_Shema_DirM[i] + g_Shema_DirS[i] + g_Shema_File[i];
        if FileExists(w_ShemaFile) then begin
          g_Shema_Client_File[i] := w_ShemaFile;
        end else begin
{2003.01.29
          arg_Error_Code    := CST_ERRCOD_04;
          arg_Error_Message := CST_ERRMSG_04+#13#10+'HTML：'+w_ShemaFile;
          Exit;
2003.01.29}
{2003.01.29 start}
          g_Shema_Client_File[i] := w_ShemaFile;
{2003.01.29 end}
        end;
      end;
    end;
  end;

//HTMLファイル名作成
  SQL :=TStringList.Create;
  SetData :=TStringList.Create;
  ValueData :=TStringList.Create;
  try
    SQL.Add ('SELECT Data ');
    SQL.Add ('FROM   '+GWinMaster );
    SQL.Add ('WHERE  WINKEY = :PWINKEY ');
    SQL.Add ('  AND  SECTION_KEY = :PSECTION_KEY ');
    SQL.Add ('  AND  DATA_KEY = :PDATA_KEY ');

    SetData.Add('PWINKEY');
    SetData.Add('PSECTION_KEY');
    SetData.Add('PDATA_KEY');

    ValueData.Add(g_SYSTEM);
    ValueData.Add(g_SHEMA);
    ValueData.Add(g_SHEMA_FILE_PASS);

    try
      //SQL実行
      SelectResult:=FuncSelectDB(SQL,SetData,ValueData,SelectData);
    except
      raise;
      //Exit;
    end;
    if (SelectResult > 0) then begin
        ws_HTML_SHEMA := SelectData[0][0];
    end;

    //...オリジナル
    if ws_HTML_SHEMA <> '' then
      g_Shema_HTML_Original_File := ws_HTML_SHEMA
    else
      g_Shema_HTML_Original_File := G_RunPath + CST_SHEMA_HTML_ORIGINAL;
    if not FileExists(g_Shema_HTML_Original_File) then begin
      arg_Error_Code    := CST_ERRCOD_01;
      arg_Error_Message := CST_ERRMSG_01+#13#10+'HTML：'+g_Shema_HTML_Original_File;
      Exit;
    end;
    //...格納先
    g_Shema_HTML_File := ExtractFileDir(g_Shema_HTML_Original_File) + '\' + CST_SHEMA_HTML_ORDER;
  //HTMLオリジナルの内容をコピー
    w_GouNO := 0;
    w_HTML_Text := '';
    AssignFile(TxtFile, g_Shema_HTML_Original_File);
    Reset(TxtFile);
    try
      while not Eof(TxtFile) do
      begin
        w_GouNO := w_GouNO + 1;
        try
          Readln(TxtFile, w_Record);
        except
          on E:EInOutError do begin
            arg_Error_Code    := CST_ERRCOD_02;
            arg_Error_Message := g_Shema_HTML_Original_File +'の読み込みに失敗しました。行：'+IntToStr(w_GouNO)+E.Message;
            Exit;
          end;
        end;
        //置き換え処理
        if (Pos('<!--', w_Record) > 0) or
           (Pos('-->', w_Record) > 0) then begin
        end
        else begin
{
          //タイトル
          if Pos('*ブラウザタイトル*', w_Record) > 0 then begin
            w_Record := StringReplace(w_Record,'*ブラウザタイトル*',CST_END_SYORI1,[rfReplaceAll])
          end;
}
  {
          //色
          if Pos('*画面背景色*', w_Record) > 0 then begin
            w_Record := StringReplace(w_Record,'*画面背景色*','#FFFFCC',[rfReplaceAll])
          end;
          if Pos('*テーブル背景色*', w_Record) > 0 then begin
            w_Record := StringReplace(w_Record,'*テーブル背景色*','#FFCC66',[rfReplaceAll])
          end;
          if Pos('*タイトル色*;', w_Record) > 0 then begin
            w_Record := StringReplace(w_Record,'*タイトル色*;','#FFFF99',[rfReplaceAll])
          end;
          if Pos('*データヘダー色*', w_Record) > 0 then begin
            w_Record := StringReplace(w_Record,'*データヘダー色*','#FFFF99',[rfReplaceAll])
          end;
          if Pos('*データ色*', w_Record) > 0 then begin
            w_Record := StringReplace(w_Record,'*データ色*','#FFFFFF',[rfReplaceAll])
          end;
          if Pos('*部位行色*', w_Record) > 0 then begin
            w_Record := StringReplace(w_Record,'*部位行色*','#FFFF99',[rfReplaceAll])
          end;
          if Pos('*画像行色*', w_Record) > 0 then begin
            w_Record := StringReplace(w_Record,'*画像行色*','#FFFFFF',[rfReplaceAll])
          end;
          if Pos('*部位コメント行色*', w_Record) > 0 then begin
            w_Record := StringReplace(w_Record,'*部位コメント行色*','#DCDCDC',[rfReplaceAll])
          end;
  }
          //ヘダー
          if Pos('*患者ID*', w_Record) > 0 then begin
            if arg_KanjaID <> '' then
              w_Record := StringReplace(w_Record,'*患者ID*',arg_KanjaID,[rfReplaceAll])
            else
              w_Record := StringReplace(w_Record,'*患者ID*','<span class=dmy_txt></span>',[rfReplaceAll]);
          end;
          if Pos('*氏名*', w_Record) > 0 then begin
            if arg_KanjaName <> '' then
              w_Record := StringReplace(w_Record,'*氏名*',arg_KanjaName,[rfReplaceAll])
            else
              w_Record := StringReplace(w_Record,'*氏名*','<span class=dmy_txt></span>',[rfReplaceAll]);
          end;
          if Pos('*実施検査日*', w_Record) > 0 then begin
            if arg_KensaDate <> '' then
              w_Record := StringReplace(w_Record,'*実施検査日*',arg_KensaDate,[rfReplaceAll])
            else
              w_Record := StringReplace(w_Record,'*実施検査日*','<span class=dmy_txt></span>',[rfReplaceAll]);
          end;
          if Pos('*検査種別*', w_Record) > 0 then begin
            if arg_KensaType <> '' then
              w_Record := StringReplace(w_Record,'*検査種別*',arg_KensaType,[rfReplaceAll])
            else
              w_Record := StringReplace(w_Record,'*検査種別*','<span class=dmy_txt></span>',[rfReplaceAll]);
          end;
          if Pos('*ｵｰﾀﾞNO*', w_Record) > 0 then begin
            if arg_OrderNO <> '' then
              w_Record := StringReplace(w_Record,'*ｵｰﾀﾞNO*',arg_OrderNO,[rfReplaceAll])
            else
              w_Record := StringReplace(w_Record,'*ｵｰﾀﾞNO*','<span class=dmy_txt></span>',[rfReplaceAll]);
          end;
          if Pos('*依頼科*', w_Record) > 0 then begin
            if arg_IraiSection <> '' then
              w_Record := StringReplace(w_Record,'*依頼科*',arg_IraiSection,[rfReplaceAll])
            else
              w_Record := StringReplace(w_Record,'*依頼科*','<span class=dmy_txt></span>',[rfReplaceAll]);
          end;
          if Pos('*依頼医*', w_Record) > 0 then begin
            if arg_IraiDoctor <> '' then
              w_Record := StringReplace(w_Record,'*依頼医*',arg_IraiDoctor,[rfReplaceAll])
            else
              w_Record := StringReplace(w_Record,'*依頼医*','<span class=dmy_txt></span>',[rfReplaceAll]);
          end;
          //部位、シェーマ画像、部位コメント
          for i := 0 to 9 do begin
            w_Local_File  := g_Shema_Client_File[i];
            w_Bui_Name    := g_Shema_Bui_Name[i];
            w_Bui_Comment := g_Shema_Bui_Comment[i];
            w_No := FormatFloat('00', i + 1);
            //部位名
            w_Name := '*部位'+w_No+'*';
            if Pos(w_Name, w_Record) > 0 then begin
              if w_Bui_Name <> '' then
                w_Record := StringReplace(w_Record,w_Name,w_Bui_Name,[rfReplaceAll])
              else
                w_Record := '<TD><span class=dmy_gazou></span></TD>';
            end;
            //シェーマ画像
            w_Name := '*ｼｪｰﾏ画像'+w_No+'*';
            if Pos(w_Name, w_Record) > 0 then begin
              if w_Local_File <> '' then
                w_Record := StringReplace(w_Record,w_Name,w_Local_File,[rfReplaceAll])
              else
                w_Record := '<TD><span class=dmy_gazou></span></TD>';
            end;
            //部位コメント
            w_Name := '*部位ｺﾒﾝﾄ'+w_No+'*';
            if Pos(w_Name, w_Record) > 0 then begin
              if w_Bui_Comment <> '' then
                w_Record := StringReplace(w_Record,w_Name,w_Bui_Comment,[rfReplaceAll])
              else
                w_Record := '<TD><span class=dmy_gazou></span></TD>';
            end;
          end;
        end;
        // 読み込んだ行にﾃﾞｰﾀが存在する場合
        if w_HTML_Text = '' then
          w_HTML_Text := w_HTML_Text + w_Record
        else
          w_HTML_Text := w_HTML_Text + #13#10 + w_Record;
      end;
    finally
      CloseFile(TxtFile);
    end;

  //HTMLファイル作成
    try
      AssignFile(TxtFile, g_Shema_HTML_File);
      Rewrite(TxtFile);
    except
      on E:EInOutError do begin
        arg_Error_Code    := CST_ERRCOD_03;
        arg_Error_Message := g_Shema_HTML_File +'のアサインに失敗しました。'+E.Message;
        Exit;
      end;
    end;
    try
      try
        Writeln(TxtFile, w_HTML_Text);
      except
        on E:EInOutError do begin
          arg_Error_Code    := CST_ERRCOD_03;
          arg_Error_Message := g_Shema_HTML_File +'の書き込みに失敗しました。'+E.Message;
          Exit;
        end;
      END;
    finally
      Flush(TxtFile);
      CloseFile(TxtFile);
    end;
  finally
    FreeAndNil(SQL);
    FreeAndNil(SetData);
    FreeAndNil(ValueData);

  end;
  Result := True;
  *)
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
