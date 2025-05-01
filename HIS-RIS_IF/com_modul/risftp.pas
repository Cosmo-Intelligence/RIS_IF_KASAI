unit risftp;
{
■機能説明
 共通部
  1.INIファイル情報の読込み
    func_FtpReadiniFile();
  2.Ftpダウンロード
    func_FtpDLoad();
■履歴
新規作成：2002.02.07：担当 iwai

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
  Math,
  //NMFtp,
  IdFTP,
  IdFTPCommon,
//プロダクト開発共通－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－
  Gval
  ;

////型クラス宣言-------------------------------------------------------------
type   //Ftp通信情報タイプ
  TFtp_Info = record
     f_FtpServerName   :  string; //Ftpサーバ コンピュータDNS名またはIPアドレス
     f_FtpServerPort   :  string; //Ftpサーバポート番号
     f_FtpServerVender :  string; //Ftpサーバプラットフォーム種類
     f_FtpServerUID    :  string; //FtpサーバユーザID
     f_FtpServerPSW    :  string; //Ftpサーバユーザパスワード
     f_FtpServerTimeOut:  string; //Ftpサーバ LOGIN中無応答タイムウト
     f_FtpDevice       :  string; //Ftpサーバ 記憶装置名
     f_FtpPath         :  string; //Ftpサーバ ファイルパス
     f_FtpFileName     :  string; //Ftpサーバ ファイル名
     f_FtpFileMode     :  string; //Ftpサーバ ファイル転送モード
     f_FtpFwType       :  string; //Ftpサーバ ファイアウォールタイプ
     f_FtpFwUID        :  string; //Ftpサーバ ファイアウォールユーザID
     f_FtpFwPSW        :  string; //Ftpサーバ ファイアウォールパスワード
     f_FtpProxy        :  string; //Ftpサーバ プロクシー
     f_FtpProxyPort    :  string; //Ftpサーバ プロクシーポート番号
     f_FtpDPathM       :  string; //受け取りパス(メイン)
     f_FtpDPathS       :  string; //受け取りパス(サブ)
     f_FtpDFileName    :  string; //受け取りファイル名
     f_FtpDrive        :  string; //画像保存ドライブ
     f_FtpSleepTime    :  string; //待機時間
  end;

//定数宣言-------------------------------------------------------------------
const
//G_FTP_INI_FNAME = 'ris_sys.ini';
  G_FTP_INI_FNAME = 'ris_ftp.ini';
  //セクション：FTP情報
  g_FTP_SECSION    = 'FTP' ;
    g_FTP_SVR_NAME_KEY     = 'FtpServerName';//キー
      g_FTP_SVR_NAME_DEF   = '';//
    g_FTP_SVR_PORT_KEY     = 'FtpServerPort';//キー
      g_FTP_SVR_PORT_DEF   = '21';//
    g_FTP_SVR_VENDER_KEY   = 'FtpServerVender';//キー
      g_FTP_SVR_VENDER_DEF = '';//
    g_FTP_SVR_UID_KEY      = 'FtpServerUID';//キー
      g_FTP_SVR_UID_DEF    = '';//
    g_FTP_SVR_PSW_KEY      = 'FtpServerPSW';//キー
      g_FTP_SVR_PSW_DEF    = '';//
    g_FTP_SVR_TOUT_KEY     = 'FtpServerTimeOut';//キー
      g_FTP_SVR_TOUT_DEF   = '900';//秒
    g_FTP_DEV_KEY          = 'FtpDevice';//キー
      g_FTP_DEV_DEF        = '';//キー
    g_FTP_PATH_KEY         = 'FtpPath';//キー
      g_FTP_PATH_DEF       = '';//
    g_FTP_FNAME_KEY        = 'FtpFileName';//キー
      g_FTP_FNAME_DEF      = '';//
    g_FTP_DPATHM_KEY       = 'FtpDPathM';//キー
      g_FTP_DPATHM_DEF     = '';//
    g_FTP_DPATHS_KEY       = 'FtpDPathS';//キー
      g_FTP_DPATHS_DEF     = '';//
    g_FTP_DFNAME_KEY       = 'FtpDFileName';//キー
      g_FTP_DFNAME_DEF     = '';//
    g_FTP_FMODE_KEY        = 'FtpFileMode';//キー
      g_FTP_FMODE_DEF      = 'BIN';//
    g_FTP_FWTYPE_KEY       = 'FtpFwType';//キー
      g_FTP_FWTYPE_DEF     = '';//
    g_FTP_FWUID_KEY        = 'FtpFwUID';//キー
      g_FTP_FWUID_DEF      = '';//
    g_FTP_FWPSW_KEY        = 'FtpFwPSW';//キー
      g_FTP_FWPSW_DEF      = '';//
    g_FTP_PROXY_KEY        = 'FtpProxy';//キー
      g_FTP_PROXY_DEF      = '';//キー
    g_FTP_PROXY_PORT_KEY   = 'FtpProxyPort';//キー
      g_FTP_PROXY_PORT_DEF = '';//キー
    g_FTP_DRIVE_KEY   = 'FtpDrive';//キー
      g_FTP_DRIVE_DEF = 'D';//キー
    g_FTP_SLEEP_KEY   = 'FtpSleepTime';//キー
      g_FTP_SLEEP_DEF = '5';//キー

//参照定数-----------------------------------------------------------------

//変数宣言-------------------------------------------------------------------
var
//実行環境情報---------------------
   g_Exe_Name   : string;
   g_Exe_FName  : string;
//INIファイル場所-------------------
   g_FtpIniPath : string;
//INIファイル情報-------------------
//FTP情報域
   g_Ftp_Info          :  TFtp_Info;

//関数手続き宣言-------------------------------------------------------------
//Iniファイル情報読み出し
function  func_FtpReadiniFile(
      arg_IniFile:string;     //INIファイルの存在フルパス指定
  var arg_Ftp_Info:TFtp_Info  //Ftp情報格納域
      ): Boolean;             //True：正常 False：異常
//ファイルのダウンロード
function func_FtpDLoad(
      arg_FtpInfo : TFtp_Info;  //Ftp情報格納域
      arg_SrcFileName:string;   //ダウンロード元ファイル名
      arg_DesDirMName:string;   //ダウンロード先ディレクトリ名(メイン)
      arg_DesDirSName:string;   //ダウンロード先ディレクトリ名(サブ)
      arg_DesFileName:string;   //ダウンロード先ファイル名
      arg_FtpMode    :integer;  //Ftp転送モード 1 2 3
  var arg_ErrFlg     :string;   //エラー発生時の原因 '0':正常,'1':接続エラー,'2':取得失敗,'3':その他
  Var arg_ErrMsg:string         //エラー発生メッセージ
      //arg_F:TFailureEvent       //エラー発生通知イベント
      ):Boolean;                //True：正常 False：異常
function func_FtpConnect(
      arg_FtpInfo : TFtp_Info;  //Ftp情報
  var arg_ErrFlg  :string;   //エラー発生時の原因 '0':正常,'1':接続エラー,'2':取得失敗,'3':その他
  var arg_ErrMsg  :string    //エラー発生時の原因メッセージの蓄積
      //arg_F:TFailureEvent       //エラー発生通知イベント
      ):Boolean;                //True：正常 False：異常
//ファイルのアップロード
function func_FtpUPLoad(
      arg_FtpInfo : TFtp_Info;     //Ftp情報格納域
      arg_UpFolerMainName:string;  //アップロード先フォルダ名(メイン)
      arg_UpFolerSubName:string;   //アップロード先フォルダ名(サブ)
      arg_UpFolerSub2Name:string;  //アップロード先フォルダ名(サブ"患者番号")
      arg_UpFileFullPas:string;    //アップロードファイルフルパス（ファイル名含む）
      arg_FtpMode    :integer;     //Ftp転送モード 1 2 3
  var arg_ErrFlg     :string;   //エラー発生時の原因 '0':正常,'1':接続エラー,'2':転送失敗,'3':その他
  Var arg_ErrMsg:string         //エラー発生メッセージ
      //arg_F:TFailureEvent       //エラー発生通知イベント
      ):Boolean;                //True：正常 False：異常

implementation //**************************************************************

//使用ユニット---------------------------------------------------------------
//uses

//定数宣言       -------------------------------------------------------------
const
 G_VERSION_STR = 'Ver1.0.0.0';
 G_MODE_ASCII  = 'MODE_ASCII';
 G_MODE_IMAGE  = 'MODE_IMAGE';
 G_MODE_BYTE   = 'MODE_IMAGE';
//INIファイル情報定義---------------------------------------------------------
//const

//その他定数-----------------------------------------------------------------

//変数宣言     ---------------------------------------------------------------
//var

//関数手続き宣言--------------------------------------------------------------
//-----------------------------------------------------------------------------
//3.INIファイル系
//-----------------------------------------------------------------------------
(**
●機能INIファイル読込み 文字
引数：
  arg_Ini : TIniFile;
  arg_Section:string;
  arg_Key:string;
  arg_Def:string
例外：無し
復帰値：
**)
function func_IniReadString(
                            arg_Ini : TIniFile;
                            arg_Section:string;
                            arg_Key:string;
                            arg_Def:string
                            ):string;
var
  w_string:string;
begin
  w_string:=arg_Ini.ReadString(
                               arg_Section,
                               arg_Key,
                               arg_Def
                               );
  if not(func_IsNullStr(w_string)) then begin
    result := w_string;
  end
  else begin
    result := arg_Def;
  end;
end;
(**
●機能INIファイル読込み 数値
引数：
  arg_Ini : TIniFile;
  arg_Section:string;
  arg_Key:string;
  arg_Def:string
例外：無し
復帰値：
**)
function func_IniReadInt(
                         arg_Ini : TIniFile;
                         arg_Section:string;
                         arg_Key:string;
                         arg_Def:string
                         ):Longint;
var
  w_string:string;
begin
  w_string:=arg_Ini.ReadString(
                               arg_Section,
                               arg_Key,
                               arg_Def
                               );
  if not(func_IsNullStr(w_string)) then begin
    result := StrToIntDef(w_string,0);
  end
  else begin
    result := StrToIntDef(arg_Def,0);
  end;
end;

//●機能 INIファイルの読込み
//引数：arg_IniFile
//     arg_IniFile   INIファイルの存在フルパス指定
//     arg_Ftp_Info  Ftp情報格納域
//例外：なし
//復帰値：True：正常 False：異常
function func_FtpReadiniFile(
      arg_IniFile:string;
  var arg_Ftp_Info:TFtp_Info
      ):Boolean;
var
  w_ini: TIniFile;
begin
  Result:=True;
  try
    w_ini:=TIniFile.Create(arg_IniFile);
    try
      //FTP情報
      arg_Ftp_Info.f_FtpServerName :=
            func_IniReadString(
                               w_ini,
                               g_FTP_SECSION,
                               g_FTP_SVR_NAME_KEY,
                               g_FTP_SVR_NAME_DEF);
      arg_Ftp_Info.f_FtpServerPort :=
            func_IniReadString(
                               w_ini,
                               g_FTP_SECSION,
                               g_FTP_SVR_PORT_KEY,
                               g_FTP_SVR_PORT_DEF);
      arg_Ftp_Info.f_FtpServerVender :=
            func_IniReadString(
                               w_ini,
                               g_FTP_SECSION,
                               g_FTP_SVR_VENDER_KEY,
                               g_FTP_SVR_VENDER_DEF);
      arg_Ftp_Info.f_FtpServerUID :=
            func_IniReadString(
                               w_ini,
                               g_FTP_SECSION,
                               g_FTP_SVR_UID_KEY,
                               g_FTP_SVR_UID_DEF);
      arg_Ftp_Info.f_FtpServerPSW :=
            func_IniReadString(
                               w_ini,
                               g_FTP_SECSION,
                               g_FTP_SVR_PSW_KEY,
                               g_FTP_SVR_PSW_DEF);
      arg_Ftp_Info.f_FtpServerTimeOut :=
            func_IniReadString(
                               w_ini,
                               g_FTP_SECSION,
                               g_FTP_SVR_TOUT_KEY,
                               g_FTP_SVR_TOUT_DEF);
      arg_Ftp_Info.f_FtpDevice :=
            func_IniReadString(
                               w_ini,
                               g_FTP_SECSION,
                               g_FTP_DEV_KEY,
                               g_FTP_DEV_DEF);
      arg_Ftp_Info.f_FtpPath :=
            func_IniReadString(
                               w_ini,
                               g_FTP_SECSION,
                               g_FTP_PATH_KEY,
                               g_FTP_PATH_DEF);
      arg_Ftp_Info.f_FtpFileName :=
            func_IniReadString(
                               w_ini,
                               g_FTP_SECSION,
                               g_FTP_FNAME_KEY,
                               g_FTP_FNAME_DEF);
      arg_Ftp_Info.f_FtpDPathM :=
            func_IniReadString(
                               w_ini,
                               g_FTP_SECSION,
                               g_FTP_DPATHM_KEY,
                               g_FTP_DPATHM_DEF);
      arg_Ftp_Info.f_FtpDPathS :=
            func_IniReadString(
                               w_ini,
                               g_FTP_SECSION,
                               g_FTP_DPATHS_KEY,
                               g_FTP_DPATHS_DEF);
      arg_Ftp_Info.f_FtpDFileName :=
            func_IniReadString(
                               w_ini,
                               g_FTP_SECSION,
                               g_FTP_DFNAME_KEY,
                               g_FTP_DFNAME_DEF);

      arg_Ftp_Info.f_FtpDrive :=
            func_IniReadString(
                               w_ini,
                               g_FTP_SECSION,
                               g_FTP_DRIVE_KEY,
                               g_FTP_DRIVE_DEF);
      arg_Ftp_Info.f_FtpSleepTime :=
               IntToStr(func_IniReadInt(
                               w_ini,
                               g_FTP_SECSION,
                               g_FTP_SLEEP_KEY,
                               g_FTP_SLEEP_DEF));


      arg_Ftp_Info.f_FtpFileMode :=
            func_IniReadString(
                               w_ini,
                               g_FTP_SECSION,
                               g_FTP_FMODE_KEY,
                               g_FTP_FMODE_DEF);
      arg_Ftp_Info.f_FtpFwType :=
            func_IniReadString(
                               w_ini,
                               g_FTP_SECSION,
                               g_FTP_FWTYPE_KEY,
                               g_FTP_FWTYPE_DEF);
      arg_Ftp_Info.f_FtpFwUID :=
            func_IniReadString(
                               w_ini,
                               g_FTP_SECSION,
                               g_FTP_FWUID_KEY,
                               g_FTP_FWUID_DEF);
      arg_Ftp_Info.f_FtpFwPSW :=
            func_IniReadString(
                               w_ini,
                               g_FTP_SECSION,
                               g_FTP_FWPSW_KEY,
                               g_FTP_FWPSW_DEF);
      arg_Ftp_Info.f_FtpProxy :=
            func_IniReadString(
                               w_ini,
                               g_FTP_SECSION,
                               g_FTP_PROXY_KEY,
                               g_FTP_PROXY_DEF);
      arg_Ftp_Info.f_FtpProxyPort :=
            func_IniReadString(
                               w_ini,
                               g_FTP_SECSION,
                               g_FTP_PROXY_PORT_KEY,
                               g_FTP_PROXY_PORT_DEF);

    finally
      w_ini.Free;
    end;
    exit;
  except
    Result:=False;
    exit;
  end;

end;
(**
●機能 Ftpサーバからファイルのダウンロード
引数：
  arg_FtpInfo    :TFtp_Info;
  arg_SrcFileName:string;
  arg_DesDirMName:string;
  arg_DesDirSName:string;
  arg_DesFileName:string;
  arg_FtpMode    :string;
  arg_ErrFlg     :string;
  arg_ErrMsg     :string；

例外：あり
復帰値：True:正常 False：異常
**)
function func_FtpDLoad(
      arg_FtpInfo : TFtp_Info;  //Ftp情報
      arg_SrcFileName:string;   //ダウンロード対象ファイル名
      arg_DesDirMName:string;   //ダウンロード先ディレクトリ名(メイン)
      arg_DesDirSName:string;   //ダウンロード先ディレクトリ名(サブ)
      arg_DesFileName:string;   //ダウンロード先ローカルファイル名
      arg_FtpMode    :integer;  //転送モード123
  var arg_ErrFlg     :string;   //エラー発生時の原因 '0':正常,'1':接続エラー,'2':取得失敗,'3':その他
  var arg_ErrMsg     :string    //エラー発生時の原因メッセージの蓄積
      //arg_F:TFailureEvent       //エラー発生通知イベント
      ):Boolean;                //True：正常 False：異常
var
  //w_Ftp:TNMFTP;   //FTPオブジェクト
  w_Ftp:TIdFTP;   //FTPオブジェクト
  w_SPath:string; //ソースファイルパス
  w_SFile:string; //ソースファイル
  w_DPath:string; //デストファイルパス

  w_FileDir: string;
begin
//0.初期処理 クリア等処理
  arg_ErrMsg:='';
  w_SPath:='';
  arg_ErrFlg := '0';
  try
//1.FTPオブジェクトの作成
    w_Ftp:=TIdFTP.Create(nil);
    try
//2.情報の設定
      //w_Ftp.ParseList:=true;
      w_Ftp.Passive:=False;
      //w_Ftp.OnFailure:=arg_F;
   //2.1必須
      //相手側IPまたはマシン名
      w_Ftp.Host := arg_FtpInfo.f_FtpServerName;
      //相手側ログインユーザー
      w_Ftp.Username := arg_FtpInfo.f_FtpServerUID;
      //相手側ログインパスワード
      w_Ftp.Password := arg_FtpInfo.f_FtpServerPSW;
   //2.2オプション
      //使用ポート
      if not(func_IsNullStr(arg_FtpInfo.f_FtpServerPort)) then
        w_Ftp.Port := StrToIntDef(arg_FtpInfo.f_FtpServerPort,21);

      if not(func_IsNullStr(arg_FtpInfo.f_FtpDevice)) then begin
          w_SPath:=w_SPath+arg_FtpInfo.f_FtpDevice;
      end;
//3.FTPのConnect
      try
        w_Ftp.Connect;
      except
        on E: Exception do begin
          arg_ErrFlg := '1';
          arg_ErrMsg := 'サーバの接続に失敗しました。「'+ E.Message + '」';
          Result := False;
          Exit;
        end;
      end;
      try
//4.元と先のディレクトリを整える
//4.1 元：TNMFTP.ChangeDir
        if not(func_IsNullStr(arg_FtpInfo.f_FtpPath)) then begin
          w_SPath:=w_SPath+arg_FtpInfo.f_FtpPath;
          w_Ftp.ChangeDir(w_SPath);
        end;

        if (func_IsNullStr(arg_SrcFileName)) then begin
          w_SFile:=arg_FtpInfo.f_FtpPath;
        end
        else begin
          w_SFile:=arg_SrcFileName;
        end;
//4.2 先：ローカルドライブディレクトリの設定
        if (func_IsNullStr(arg_DesFileName)) then begin
          if (func_IsNullStr(arg_DesDirMName)) and
             (func_IsNullStr(arg_DesDirSName)) then begin
            w_DPath:=arg_FtpInfo.f_FtpDPathM+arg_FtpInfo.f_FtpDPathS+arg_FtpInfo.f_FtpDFileName;
          end
          else begin
            w_DPath:=arg_DesDirMName+arg_DesDirSName+arg_FtpInfo.f_FtpDFileName;
          end;
        end
        else begin
          if (func_IsNullStr(arg_DesDirMName)) and
             (func_IsNullStr(arg_DesDirSName)) then begin
            w_DPath:=arg_FtpInfo.f_FtpDPathM+arg_FtpInfo.f_FtpDPathS+arg_DesFileName;
          end
          else begin
            w_DPath:=arg_DesDirMName+arg_DesDirSName+arg_DesFileName;
          end;
        end;
//4.2.1 先ディレクトリ確認
        w_FileDir := ExtractFileDir(w_DPath);
        if not(DirectoryExists(w_FileDir)) then begin
          if not CreateDir(w_FileDir) then
            raise Exception.Create('Cannot create '+w_FileDir);
        end;
//4.3転送Mode設定
        if (arg_FtpMode<>1) and        //ASCII
           (arg_FtpMode<>2) and        //イメージ
           (arg_FtpMode<>3) then begin //バイト
          //イメージ・バイト
          w_Ftp.TransferType := ftBinary;
        end
        else begin
          if arg_FtpMode = 1 then
            //ASCII
            w_Ftp.TransferType := ftASCII
          else
            //イメージ・バイト
            w_Ftp.TransferType := ftBinary;
        end;
//5.ダウンロード
        try
          w_Ftp.Get(w_SFile,w_DPath,True);
        except
          on E: Exception do begin
            arg_ErrFlg := '2';
            arg_ErrMsg := 'FTPサーバに該当ファイルがありませんでした。ファイルパス名：' + arg_SrcFileName;
            Result := False;
            Exit;
          end;
        end;
//6.FTPのDisConnect
      Finally
        w_Ftp.Disconnect;
      end;
//7.FTPオブジェクトの解放
    Finally
      w_Ftp.Free;
    end;
//8.復帰値の設定
    result:=True;
    exit;
//10.エラー例外処理
  except
    on E: Exception do
    begin
      arg_ErrMsg := arg_ErrMsg+E.Message;
      arg_ErrFlg := '3';
      Result:=False;
      exit;
    end;
  end;

end;
(**
●機能 Ftpサーバの接続確認
引数：
  arg_FtpInfo    :TFtp_Info;
  arg_ErrFlg     :string;
  arg_ErrMsg     :string；

例外：あり
復帰値：True:正常 False：異常
**)
function func_FtpConnect(
      arg_FtpInfo : TFtp_Info;  //Ftp情報
  var arg_ErrFlg  :string;   //エラー発生時の原因 '0':正常,'1':接続エラー,'2':取得失敗,'3':その他
  var arg_ErrMsg  :string    //エラー発生時の原因メッセージの蓄積
      //arg_F:TFailureEvent       //エラー発生通知イベント
      ):Boolean;                //True：正常 False：異常
var
  //w_Ftp:TNMFTP;   //FTPオブジェクト
  w_Ftp:TIdFTP;   //FTPオブジェクト
  w_SPath:String;
begin
//0.初期処理 クリア等処理
  arg_ErrMsg:='';
  w_SPath:='';
  arg_ErrFlg := '0';
  try
//1.FTPオブジェクトの作成
    w_Ftp:=TIdFTP.Create(nil);
    try
//2.情報の設定
      //w_Ftp.ParseList:=true;
      w_Ftp.Passive:=False;
      //w_Ftp.OnFailure:=arg_F;
   //2.1必須
      //相手側IPまたはマシン名
      w_Ftp.Host := arg_FtpInfo.f_FtpServerName;
      //相手側ログインユーザー
      w_Ftp.Username := arg_FtpInfo.f_FtpServerUID;
      //相手側ログインパスワード
      w_Ftp.Password := arg_FtpInfo.f_FtpServerPSW;
   //2.2オプション
      //使用ポート
      if not(func_IsNullStr(arg_FtpInfo.f_FtpServerPort)) then
        w_Ftp.Port := StrToIntDef(arg_FtpInfo.f_FtpServerPort,21);

      if not(func_IsNullStr(arg_FtpInfo.f_FtpDevice)) then begin
          w_SPath:=w_SPath+arg_FtpInfo.f_FtpDevice;
      end;
      try
//3.FTPのConnect
        try
          w_Ftp.Connect;
        except
          on E: Exception do begin
            arg_ErrFlg := '1';
            arg_ErrMsg := 'サーバの接続に失敗しました。「'+ E.Message + '」';
            Result := False;
            Exit;
          end;
        end;
//6.FTPのDisConnect
      Finally
        w_Ftp.Disconnect;
      end;
//7.FTPオブジェクトの解放
    Finally
      w_Ftp.Free;
    end;
//8.復帰値の設定
    result:=True;
    exit;
//10.エラー例外処理
  except
    on E: Exception do
    begin
      arg_ErrMsg := arg_ErrMsg+E.Message;
      arg_ErrFlg := '3';
      Result:=False;
      exit;
    end;
  end;

end;
//ファイルのアップロード
function func_FtpUPLoad(
      arg_FtpInfo : TFtp_Info;     //Ftp情報格納域
      arg_UpFolerMainName:string;  //アップロード先フォルダ名(メイン)
      arg_UpFolerSubName:string;   //アップロード先フォルダ名(サブ"文書番号")
      arg_UpFolerSub2Name:string;  //アップロード先フォルダ名(サブ"患者番号")
      arg_UpFileFullPas:string;    //アップロードファイルフルパス（ファイル名含む）
      arg_FtpMode    :integer;     //Ftp転送モード 1 2 3
  var arg_ErrFlg     :string;   //エラー発生時の原因 '0':正常,'1':接続エラー,'2':転送失敗,'3':その他
  Var arg_ErrMsg:string         //エラー発生メッセージ
      ):Boolean;                //True：正常 False：異常
var
  w_Ftp:TIdFTP;   //FTPオブジェクト
  WSLDList: TStrings;
  w_SPath:String;
  WILoop: Integer;
  WBFlg: Boolean;
  WSImagePas: String;
begin
  //0.初期処理 クリア等処理
  arg_ErrMsg:='';
  arg_ErrFlg := '0';
  try
    //1.FTPオブジェクトの作成
    w_Ftp:=TIdFTP.Create(nil);
    try
      //2.情報の設定
      w_Ftp.Passive:=False;
      //2.1必須
      //相手側IPまたはマシン名
      w_Ftp.Host := arg_FtpInfo.f_FtpServerName;
      //相手側ログインユーザー
      w_Ftp.Username := arg_FtpInfo.f_FtpServerUID;
      //相手側ログインパスワード
      w_Ftp.Password := arg_FtpInfo.f_FtpServerPSW;
      //2.2オプション
      //使用ポート
      if not(func_IsNullStr(arg_FtpInfo.f_FtpServerPort)) then
        w_Ftp.Port := StrToIntDef(arg_FtpInfo.f_FtpServerPort,21);

      if not(func_IsNullStr(arg_FtpInfo.f_FtpDevice)) then begin
        w_SPath := w_SPath+arg_FtpInfo.f_FtpDevice;
      end;
      //3.FTPの接続確認
      try
        w_Ftp.Connect;
      except
        on E: Exception do begin
          arg_ErrFlg := '1';
          arg_ErrMsg := 'サーバの接続に失敗しました。「'+ E.Message + '」';
          Result := False;
          Exit;
        end;
      end;
      //4.カレントディレクトリの変更
      try
        w_Ftp.ChangeDir(arg_UpFolerMainName);
      except
        on E:Exception do
        begin
          arg_ErrFlg := '3';
          arg_ErrMsg := 'カレントディレクトリの変更に失敗しました。「' +
                        arg_UpFolerMainName + '」（' + E.Message + '）';
          Result := False;
          Exit;
        end;
      end;
      try
        WSLDList := TStringList.Create;

        //5.サブディレクトリの存在確認
        //5.1カレントディレクトリのフォルダまたはファイルをすべて取得
        w_Ftp.List(WSLDList, '', False);
        //初期化
        WBFlg := False;
        //取得データ分
        for WILoop := 0 to WSLDList.Count - 1 do
        begin
          //フォルダの場合
          if w_Ftp.Size(WSLDList.Strings[WILoop]) = -1 then
          begin
            //格納先フォルダがすでにある場合
            if WSLDList.Strings[WILoop] = arg_UpFolerSubName then
            begin
              //フラグ設定
              WBFlg := True;
              //処理終了
              Break;
            end;
          end;
        end;
        //同一名称フォルダがない場合
        if not WBFlg then
        begin
          try
            w_Ftp.MakeDir(arg_UpFolerSubName);
            w_Ftp.ChangeDir(arg_UpFolerSubName);
          except
            on E:Exception do
            begin
              arg_ErrFlg := '3';
              arg_ErrMsg := 'ディレクトリの作成に失敗しました。「' +
                            arg_UpFolerSubName + '」（' + E.Message + '）';
              Result := False;
              Exit;
            end;
          end;
        end
        //同一フォルダがある場合
        else
        begin
          //カレントディレクトリの変更
          try
            w_Ftp.ChangeDir(arg_UpFolerSubName);
          except
            on E:Exception do
            begin
              arg_ErrFlg := '3';
              arg_ErrMsg := 'カレントディレクトリの変更に失敗しました。「' +
                            arg_UpFolerSubName + '」（' + E.Message + '）';
              Result := False;
              Exit;
            end;
          end;
        end;

        {
        FreeAndNil(WSLDList);
        WSLDList := TStringList.Create;

        //5.サブディレクトリの存在確認
        //5.1カレントディレクトリのフォルダまたはファイルをすべて取得
        w_Ftp.List(WSLDList, '', False);
        //初期化
        WBFlg := False;
        //取得データ分
        for WILoop := 0 to WSLDList.Count - 1 do
        begin
          //フォルダの場合
          if w_Ftp.Size(WSLDList.Strings[WILoop]) = -1 then
          begin
            //格納先フォルダがすでにある場合
            if WSLDList.Strings[WILoop] = arg_UpFolerSub2Name then
            begin
              //フラグ設定
              WBFlg := True;
              //処理終了
              Break;
            end;
          end;
        end;
        //同一名称フォルダがない場合
        if not WBFlg then
        begin
          try
            w_Ftp.MakeDir(arg_UpFolerSub2Name);
            w_Ftp.ChangeDir(arg_UpFolerSub2Name);
          except
            on E:Exception do
            begin
              arg_ErrFlg := '3';
              arg_ErrMsg := 'ディレクトリの作成に失敗しました。「' +
                            arg_UpFolerSub2Name + '」（' + E.Message + '）';
              Result := False;
              Exit;
            end;
          end;
        end
        //同一フォルダがある場合
        else
        begin
          //カレントディレクトリの変更
          try
            w_Ftp.ChangeDir(arg_UpFolerSub2Name);
          except
            on E:Exception do
            begin
              arg_ErrFlg := '3';
              arg_ErrMsg := 'カレントディレクトリの変更に失敗しました。「' +
                            arg_UpFolerSub2Name + '」（' + E.Message + '）';
              Result := False;
              Exit;
            end;
          end;
        end;
      }
      finally
        if WSLDList <> nil then
          FreeAndNil(WSLDList);
      end;

      //6.転送Mode設定
      if (arg_FtpMode<>1) and   //ASCII
         (arg_FtpMode<>2) and   //イメージ
         (arg_FtpMode<>3) then  //バイト
      begin 
        //イメージ・バイト
        w_Ftp.TransferType := ftBinary;
      end
      else
      begin
        if arg_FtpMode = 1 then
          //ASCII
          w_Ftp.TransferType := ftASCII
        else
          //イメージ・バイト
          w_Ftp.TransferType := ftBinary;
      end;
      //7.ファイルの転送
      try
        // 画像フォルダのドライブのみ変更
        WSImagePas := arg_FtpInfo.f_FtpDrive + Copy(arg_UpFileFullPas, 2, Length(arg_UpFileFullPas));
        {
        //if FileSetAttr(WSImagePas, faAnyFile) = 0 then
        if FileSetAttr(WSImagePas, faReadOnly) = 0 then
        begin
          arg_ErrFlg := '2';
          arg_ErrMsg := 'ファイルのPUTに失敗しました。「' +
                        arg_UpFileFullPas + '」（ファイルの属性の変更エラー）';
          Result := False;
          Exit;
        end;
        }
        // ファイル転送
        w_Ftp.Put(WSImagePas, ExtractFileName(WSImagePas));
      except
        on E:Exception do
        begin
          arg_ErrFlg := '2';
          arg_ErrMsg := 'ファイルのPUTに失敗しました。「' +
                        arg_UpFileFullPas + '」（' + E.Message + '）';
          Result := False;
          Exit;
        end;
      end;
    //8.FTPオブジェクトの解放
    Finally
      w_Ftp.Free;
    end;
    //9.復帰値の設定
    result := True;
    exit;
    //10.エラー例外処理
  except
    on E: Exception do
    begin
      arg_ErrMsg := arg_ErrMsg+E.Message;
      arg_ErrFlg := '3';
      Result:=False;
      exit;
    end;
  end;
end;

//-----------------------------------------------------------------------------
initialization
begin

//1)起動PASSを確定
     g_FtpIniPath := ExtractFilePath( ParamStr(0) );
//コマンドEXEファイル名
     g_Exe_FName  := ExtractFileName( ParamStr(0) );
//コマンドEXEファイル名プレフィックス
     g_Exe_Name   := ChangeFileExt( g_Exe_FName, '' );
//デフォルトで起動ディレクトリのINIを読み込む
    func_FtpReadiniFile(g_FtpIniPath + G_FTP_INI_FNAME,g_Ftp_Info);
end;

finalization
begin
//
end;

end.
