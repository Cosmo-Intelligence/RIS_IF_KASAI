unit TcpSocket;
{
■機能説明
 FTcpEmuCとFTcpEmuSから使う共通部
  1.ログ出力関数系
  2.文字コード系
  3.INIファイル系
  4.バッファ系
  5.電文ストリーム系
  6.その他系
■履歴
新規作成：2001.09.28：担当 iwai
修正：2001.12.27：担当 iwai
全角空白Trim関数の追加
修正：2002.01.09：担当 増田
バージョン情報の修正
修正：2002.01.30：担当 iwai
問題表1162 の変更
修正：2004.03.24：増田
　　　　　　　　　仕様変更による修正
修正：2004.04.06：増田
　　　　　　　　　チャージ情報送信セクション追加

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
  IdWinsock,
  IdGlobal,
  KanaRoma,
//プロダクト開発共通－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－
  Gval,
  jis2sjis,
  HisMsgDef
  ;

////型クラス宣言-------------------------------------------------------------
type   //ソケット通信共通
  TSocket_Info = record
    f_Active        : string[1];  //有効 無効
    f_EmuVisible    : string[1];  //表示 非表示
    f_EmuEnabled    : string[1];  //対話 非対話
    f_CharCode      : string[1];  //伝送文字コード
  end;
type   //ソケット通信  サーバ保持情報
  TServer_Info = record
    f_Socket_Info   : TSocket_Info;
    f_Port          : string[5]; //接続待ちポートアドレス
    f_TimeOut       : Longint;    //タイムアウト
  end;
type   //ソケット通信  クライアント保持情報
  TClint_Info = record
    f_Socket_Info   : TSocket_Info;
    f_IPAdrr        : string[15]; //サーバアドレス
    f_Port          : string[5];  //サーバポート
    f_TimeOut       : Longint;    //タイムアウト
    f_Timer         : Longint;    //タイマー
  end;
type   //予約枠コード、検査機器ID対応表
  TKensakiki_Def = record
    Yoyakuwaku : String; //予約枠コード
    Kensakiki  : String; //検査機器ID
  end;
type Tkensakiki = array of TKensakiki_Def;

type
  TOrderIndicate = record
    DATAKEY : String; //データキー名
    DATA    : TStrings; //コード
  end;
type ASC2 = array [0..15] of String;
const
  ASC2_CODE : ASC2 =
  ('0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F');

//ログ種別定義情報
const
  G_LOGGMSG_LEN = 22;
type
  TLog_Type = record
    f_LogMsg   : string[G_LOGGMSG_LEN];
    f_LogLevel : integer; //
  end;
type
  TXML = record
    XML_CHR : String; //XML使用不可文字
    RIS_CHR : String; //変換文字
  end;
type
  TDUMMY = record
    KENSA_TYPE : String; //検査種別
    DUMMY_CODE : String; //コード
  end;
//定数宣言-------------------------------------------------------------------
//情報定義
const
 G_VERSION_IRAI_STR = 'Ver1.0.0';
 G_VERSION_KANJA_STR = 'Ver1.0.0';
 G_VERSION_UKETUKE_STR = 'Ver1.0.0';
 G_VERSION_JISSI_STR = 'Ver1.0.0';
 G_VERSION_SEVER_STR = 'Ver1.0.0';
 G_VERSION_SCHEMA_STR = 'Ver1.0.0';
 G_VERSION_REPORT_STR = 'Ver1.0.0';
 G_VERSION_PACS_STR = 'Ver1.0.0';
//INIファイル情報定義---------------------------------------------------------
const
 G_TCPINI_FNAME = 'ris_tcp.ini';
 G_BACKINI_FNAME = 'ris_BackUp.ini';
 //セクション：SERVICE情報
 g_C_SVC_SECSION      = 'SERVICE' ;
   g_SVC_SDACTIVE_KEY = 'sdactive';//キー
   g_SVC_RVACTIVE_KEY = 'rvactive';//キー
     g_SVC_ACTIVE     = '1';//
     g_SVC_DEACTIVE   = '0';//
   g_SVC_SDCYCLE_KEY  = 'sdcycle';//キー
     g_SVC_SDCYCLE    = '10';//
   g_SVC_RVCYCLE_KEY  = 'rvcycle';//キー
     g_SVC_RVCYCLE    = '10';//
 //セクション：RIS DB接続情報
 g_C_DB_SECSION     = 'DBINF';
   g_DB_NAME_KEY    = 'dbname';//キー
     g_DB_NAME      = 'ris_sv';//
   g_DB_UID_KEY     = 'dbuid';//キー
     g_DB_UID       = 'ris';//
   g_DB_PAS_KEY     = 'dbpss';//キー
     g_DB_PAS       = 'ris';//
   g_DB_SERVICE_KEY = 'dbservice';//キー
     g_DB_SERVICE   = '';//
   g_DB_RETRY_KEY   = 'openretry';//キー
     g_DB_RETRY     = '5';//
   g_DB_SNDKEEP_KEY = 'sndkeep';//キー
     g_DB_SNDKEEP   = '30';//
   g_DB_RCVKEEP_KEY = 'rcvkeep';//キー
     g_DB_RCVKEEP   = '30';//
 //セクション：RIG接続情報
 g_C_SOCKET_SECSION            = 'C_SOCKET';  //
 g_S_SOCKET_SECSION            = 'S_SOCKET';
   g_SOCKET_ACTIVE_KEY         = 'Active';//キーActive
     g_SOCKET_ACTIVE           = '1';//
     g_SOCKET_DEACTIVE         = '0';//デフォルト
   g_SOCKET_EMUVISIBLE_KEY     = 'EmuVisible';//キーVisible
     g_SOCKET_EMUVISIBLE_TRUE  = '1';//
     g_SOCKET_EMUVISIBLE_FALSE = '0';//デフォルト
   g_SOCKET_EMUENABLED_KEY     = 'EmuEnabled';//キーEnabled
     g_SOCKET_EMUENABLED_TRUE  = '1';//
     g_SOCKET_EMUENABLED_FALSE = '0';//デフォルト
   g_SOCKET_CHARCODE_KEY       = 'CharCode';//キーCharCode
     g_SOCKET_CHARCODE_JIS     = '1';//
     g_SOCKET_CHARCODE_SJIS    = '0';//デフォルト
   g_SOCKET_TOUT_KEY     = 'TimeOut'     ;//キー ﾌﾟﾛﾄｺﾙタイムアウト
     g_SOCKET_TOUT     = '10000'   ;//デフォルト
   g_SOCKET_TIMER_KEY     = 'Timer'     ;//キー Timer
     g_SOCKET_TIMER     = '10000'   ;//デフォルト

   g_SOCKET_SIP_KEY       = 'ServerIP'     ;//キーIP Address
     g_SOCKET_SIP       = '000.000.000.000'   ;//デフォルト
   g_SOCKET_SPORT_KEY     = 'ServerPort'     ;//キー IP port
     g_SOCKET_SPORT     = ''   ;//デフォルト

   g_SOCKET_PORT_KEY      = 'Port'     ;//キーRIS IP port
     g_SOCKET_PORT        = '0000'   ;//デフォルト

 g_LOG_SECSION = 'LOG';
    g_SOCKET_LOGACTIVE_KEY  = 'LogActive'     ;//キーVersion
        g_SOCKET_LOGACTIVE2     = '2'   ;//NGのみ出力
        g_SOCKET_LOGACTIVE     =  '1'   ;//NGOK全て出力
        g_SOCKET_LOGDEACTIVE   =  '0' ;//デフォルト
    g_SOCKET_LOGPATH_KEY       = 'LogPath'     ;//キーVersion
        g_SOCKET_LOGPATH       =  ''   ;//デフォルト
    g_SOCKET_LOGSIZE_KEY       = 'LogSize'     ;//キーVersion
        g_SOCKET_LOGSIZE       =  '65536'   ;//デフォルト
    g_SOCKET_LOGKEEP_KEY       = 'LogKeep'     ;//キーVersion
        g_SOCKET_LOGKEEP       =  '3'   ;//デフォルト
    g_SOCKET_LOGINCMSG_KEY     = 'LogIncMsg'     ;//キーVersion
        g_SOCKET_LOGINCMSG     =  '1'   ;//デフォルト
    g_SOCKET_LOGLEVEL_KEY      = 'LogLevel'     ;//キーVersion
        g_SOCKET_LOGLEVEL      =  '5'   ;//デフォルト

 g_NAME_SECSION                = 'NAME';
    g_KANSEN_NAME01_KEY        = 'Yusen01'     ;//キー
        g_KANSEN_NAME01        =  ''   ;//

 g_PROF_SECSION  = 'PROF';
    g_PROF01_KEY = 'Prof01';//キー
        g_DEFPROF01 = '';//
    g_PROF02_KEY = 'Prof02';//キー
        g_DEFPROF02 = '';//

 g_SCHE_SECSION  = 'SCHEMA';
    g_SCHEMAIN_KEY = 'SchemaMaimDIR';//キー
        g_DEFMAIN = '';//
    g_SCHESUB_KEY = 'SchemaSubDIR';//キー
        g_DEFSUB = '';//
    g_SCHEDEL_KEY = 'SchemaDelDate';//キー
        g_DEFDELSUB = '';//

 g_PATH_SECSION  = 'PATH';
    g_PATHMAIN_KEY = 'TCP_MAINSVR_PATH';//キー
        g_DEFMAINPATH = '';//
    g_PATHSUB_KEY = 'TCP_BACKUPSVR_PATH';//キー
        g_DEFSUBPATH = '';//
 g_ACTIVE_SECSION  = 'ACTIVE';
    g_PATHACTIVE_KEY = 'TCP_ACTIVE_TXTOUT';//キー
        g_DEFACTIVE = '1';//

 g_RI_SECSION  = 'RI';
    g_RI01_KEY = 'RI01';//キー
        g_DEFRI01 = '';//
    g_RI02_KEY = 'RI02';//キー
        g_DEFRI02 = '';//
    g_RI03_KEY = 'RI03';//キー
        g_DEFRI03 = '';//
    g_RI04_KEY = 'RI04';//キー
        g_DEFRI04 = '';//
    g_RI05_KEY = 'RI05';//キー
        g_DEFRI05 = '';//
    g_RI06_KEY = 'RI06';//キー
        g_DEFRI06 = '';//
    g_RI07_KEY = 'RI07';//キー
        g_DEFRI07 = '';//

 g_KIKI_SECSION  = 'KIKI';
 g_KENZO_SECSION  = 'KENZO';
 g_SATUEI_SECSION  = 'SATUEI';
 g_KANJA_SECSION  = 'KANJA';
 //オーダ指示情報セクション
 g_ORDERINDICATE_SECSION  = 'ORDERINDICATE';
    g_ORDERINDICATE_KEY = 'Comment_Rep';//キー
        g_DEFORDERINDICATE = '';//
 //患者プロファイル情報セクション
 g_KANJAPROF_SECSION  = 'PROFILE';
 g_KANJAPROFCODE_SECSION  = 'PROFILECODE';
 //XML情報セクション
 g_XML_SECSION  = 'XML';
 //方向情報セクション
 g_HOUKOU_SECSION  = 'HOUKOU';
 //方法情報セクション
 g_HOUHOU_SECSION  = 'HOUHOU';
 //2004.03.24
 //オラクルエラー情報セクション
 g_ORAERR_SECSION  = 'ORAERR';
    g_ORAERR_KEY = 'ORAERRNO';//キー
        g_DEFORAERR = '';//
 //2004.04.06
 //チャージ情報送信有無セクション
 //g_CHARGE_SECSION  = '';
 //   g_CHARGE_KEY = '';//キー
        g_DEFZOECHARGE = '';//
        g_DEFSHGCHARGE = '';//

//参照定数-----------------------------------------------------------------
//LOGファイル情報定義（内容）
const
 G_LOG_LINE_HEAD_OK = 'OK'; //接頭子 正常
 G_LOG_LINE_HEAD_NG = 'NG'; //接頭子 異常
 G_LOG_LINE_HEAD_NP = '  '; //接頭子 コメント
//LOGファイル情報定義(ログの種別番号とレベルとログの種別文字列)
//実行時外部指定を考慮してInitialで代入処理する
const
 G_LOG_PKT_PTH_DEF             = '.LOG';//LOGファイル拡張子
 G_MAX_LOG_TYPE                = 10; //ログの種別の個数最大値
 //サービス処理 URH_SDSvc
 G_LOG_KIND_SVC_NUM            = 1;
 G_LOG_KIND_SVC                = 'Servic            処理';//使用
 G_LOG_KIND_SVC_LEVEL          = 1;
 //ソケットサーバ  FTcpEmuS
 G_LOG_KIND_SK_SV_NUM          = 2;
 G_LOG_KIND_SK_SV              = 'Socketサーバ      処理';//使用
 G_LOG_KIND_SK_SV_LEVEL        = 4;
 //ソケットクライアント URH_SDSvc  FTcpEmuC
 G_LOG_KIND_SK_CL_NUM          = 3;
 G_LOG_KIND_SK_CL              = 'Socketクライアント処理';//使用
 G_LOG_KIND_SK_CL_LEVEL        = 4;
 //DB基本処理
 G_LOG_KIND_DB_NUM             = 4;
 G_LOG_KIND_DB                 = 'DBase             処理';//使用
 G_LOG_KIND_DB_LEVEL           = 2;
 //DB 情報取得処理
 G_LOG_KIND_DB_IN_NUM          = 5;
 G_LOG_KIND_DB_IN              = '情報通知          処理';//
 G_LOG_KIND_DB_IN_LEVEL        = 5;
 //DB 情報設定処理
 G_LOG_KIND_DB_OUT_NUM         = 6;
 G_LOG_KIND_DB_OUT             = 'DBase 情報設定    処理';//
 G_LOG_KIND_DB_OUT_LEVEL       = 3;
 //DB 電文解析処理
 G_LOG_KIND_MS_ANLZ_NUM        = 7;
 G_LOG_KIND_MS_ANLZ            = 'MSG   解析        処理';//
 G_LOG_KIND_MS_ANLZ_LEVEL      = 6;
 //未定義
 G_LOG_KIND_NG_NUM             = 8;
 G_LOG_KIND_NG                 = '未定義            処理';//
 G_LOG_KIND_NG_LEVEL           = 6;

//------------------------------------------------------------------------------
// 詳細***** ソケット通信 エラー情報
const
  G_TCPSND_PRTCL00='00';
  G_TCPSND_PRTCL_ERR00='00';//成功
  G_TCPSND_PRTCL_ERR01='01';//送信失敗
  G_TCPSND_PRTCL_ERR02='02';//無応答
  G_TCPSND_PRTCL_ERR03='03';//返答失敗／拒否
  G_TCPSND_PRTCL_OK   = G_TCPSND_PRTCL00+G_TCPSND_PRTCL_ERR00;//成功

const
  //共通メッセージ
  CST_INI_OK_MSG = 'iniファイルの読み込みに成功しました。';
  CST_INI_NG_MSG = 'iniファイルの読み込みに失敗しました。';
  CST_SRV_ERR_MSG = 'iniファイルでサービスが有効になっていません。';
  CST_DB_ERR_MSG = 'データベースへの接続に失敗しました。';
  CST_DB_OK_MSG  = 'データベースへの接続に成功しました。';
  CST_DB_END_MSG = '*****RIS DB接続を終了しました*****';
  //受信用
  CST_JYUSINTBLDEL_OK_MSG  = '受信オーダテーブル不要レコードの削除に成功しました。';
  CST_JYUSINTBLDEL_NG_MSG  = '受信オーダテーブル不要レコードの削除に失敗しました。';

  CST_SAVE_ON  = '1';
  CST_SAVE_OFF = '0';
  CST_IRAI_BACK  = 'R';
  CST_KANJA_BACK = 'P';
  CST_IDO_BACK   = 'M';

  CST_NON_TITLE = 'N';

  CST_ORDERINDICATE_NON_REP = '0';

//その他定数-----------------------------------------------------------------
const
  CST_SEX = 'SEX';
  CST_SISETU = 'SIS';
//内部埋め込み定義の場合
type
   TLog_Type_Info     = array[1..G_MAX_LOG_TYPE] of TLog_Type;
const
  g_Log_Type_Info : TLog_Type_Info = (
                                // 1:サービス処理
                                (f_LogMsg : G_LOG_KIND_SVC;
                                 f_LogLevel:G_LOG_KIND_SVC_LEVEL),
                                // 2:ソケットサーバ
                                (f_LogMsg : G_LOG_KIND_SK_SV;
                                 f_LogLevel:G_LOG_KIND_SK_SV_LEVEL),
                                // 3:ソケットクライアント
                                (f_LogMsg : G_LOG_KIND_SK_CL;
                                 f_LogLevel:G_LOG_KIND_SK_CL_LEVEL),
                                // 4:DB基本処理
                                (f_LogMsg : G_LOG_KIND_DB;
                                 f_LogLevel:G_LOG_KIND_DB_LEVEL),
                                // 5:DB 情報取得処理
                                (f_LogMsg : G_LOG_KIND_DB_IN;
                                 f_LogLevel:G_LOG_KIND_DB_IN_LEVEL),
                                // 6:DB 情報設定処理
                                (f_LogMsg : G_LOG_KIND_DB_OUT;
                                 f_LogLevel:G_LOG_KIND_DB_OUT_LEVEL),
                                // 7:DB 電文解析処理
                                (f_LogMsg : G_LOG_KIND_MS_ANLZ;
                                 f_LogLevel:G_LOG_KIND_MS_ANLZ_LEVEL),
                                // 8:未定義
                                (f_LogMsg : G_LOG_KIND_NG;
                                 f_LogLevel:G_LOG_KIND_NG_LEVEL),
                                // 9:
                                (f_LogMsg : G_LOG_KIND_NG;
                                 f_LogLevel:G_LOG_KIND_NG_LEVEL),
                                // 10:
                                (f_LogMsg : G_LOG_KIND_NG;
                                 f_LogLevel:G_LOG_KIND_NG_LEVEL)
                                );

//■コード及び名称定義
//2001.09.07
// 性別
GPCST_SEX_1='1';
GPCST_SEX_2='2';
GPCST_SEX_3='3';
GPCST_SEX_1_NAME='M';
GPCST_SEX_2_NAME='F';
GPCST_SEX_3_NAME='不明';
GPCST_SEX_3P_NAME='O';
// 入外区分
{2004.01.08
GPCST_NYUGAIKBN_1='1';
GPCST_NYUGAIKBN_2='2';
2004.01.08}
GPCST_NYUGAIKBN_1='2';
GPCST_NYUGAIKBN_2='1';
{2002.10.30
GPCST_NYUGAIKBN_1_NAME='入院';
GPCST_NYUGAIKBN_2_NAME='外来';
2002.10.30}
GPCST_NYUGAIKBN_1_NAME='外来';
GPCST_NYUGAIKBN_2_NAME='入院';
// 会計種別
GPCST_KAIKEITYPE_0='0';
GPCST_KAIKEITYPE_1='1';
GPCST_KAIKEITYPE_2='2';
GPCST_KAIKEITYPE_3='3';
GPCST_KAIKEITYPE_0_NAME='医事';
GPCST_KAIKEITYPE_1_NAME='自費';
GPCST_KAIKEITYPE_2_NAME='校費';
GPCST_KAIKEITYPE_3_NAME='治験';
// 登録システム区分  _SYSK
GPCST_CODE_SYSK_RIS = 'R';
GPCST_CODE_SYSK_HIS = 'H';
GPCST_NAME_SYSK_RIS = 'RIS';
GPCST_NAME_SYSK_HIS = 'HIS';
// 検査進捗 _KENSIN
GPCST_CODE_KENSIN_0 = '0';
GPCST_CODE_KENSIN_1 = '1';
GPCST_CODE_KENSIN_2 = '2';
GPCST_CODE_KENSIN_3 = '3';
GPCST_CODE_KENSIN_4 = '4';
GPCST_NAME_KENSIN_0 = '未受';
GPCST_NAME_KENSIN_1 = '受済';
GPCST_NAME_KENSIN_2 = '検中';
GPCST_NAME_KENSIN_3 = '検済';
GPCST_NAME_KENSIN_4 = '中止';
GPCST_RYAKU_NAME_KENSIN_0 = '未';
GPCST_RYAKU_NAME_KENSIN_1 = '受';
GPCST_RYAKU_NAME_KENSIN_2 = '中';
GPCST_RYAKU_NAME_KENSIN_3 = '済';
GPCST_RYAKU_NAME_KENSIN_4 = '止';
// 検査進捗 _KENSIN_SUB
GPCST_CODE_KENSIN_SUB_5 = '5';
GPCST_CODE_KENSIN_SUB_6 = '6';
GPCST_CODE_KENSIN_SUB_7 = '7';
GPCST_CODE_KENSIN_SUB_8 = '8';
GPCST_CODE_KENSIN_SUB_9 = '9';
GPCST_CODE_KENSIN_SUB_10= '10';
GPCST_NAME_KENSIN_SUB_5 = '呼出';
GPCST_NAME_KENSIN_SUB_6 = '遅刻';
GPCST_NAME_KENSIN_SUB_7 = '確保';
GPCST_NAME_KENSIN_SUB_8 = '保留';
GPCST_NAME_KENSIN_SUB_9 = '再呼';
GPCST_NAME_KENSIN_SUB_10= '再受';
GPCST_RYAKU_NAME_KENSIN_SUB_5 = '呼';
GPCST_RYAKU_NAME_KENSIN_SUB_6 = '遅';
GPCST_RYAKU_NAME_KENSIN_SUB_7 = '確';
GPCST_RYAKU_NAME_KENSIN_SUB_8 = '留';
GPCST_RYAKU_NAME_KENSIN_SUB_9 = '呼';
GPCST_RYAKU_NAME_KENSIN_SUB_10= '受';

// 所見依頼フラグ _SYOKEN
GPCST_CODE_SYOKEN_0 = '0';
GPCST_CODE_SYOKEN_1 = '1';
GPCST_NAME_SYOKEN_0 = '不要';
GPCST_NAME_SYOKEN_1 = '要';
// RI実施フラグ _RI
GPCST_CODE_RI_0 = '0';
GPCST_CODE_RI_1 = '1';
GPCST_NAME_RI_0 = '負荷なし';
GPCST_NAME_RI_1 = '負荷あり';
// 時間外区分  _JIKAN
GPCST_CODE_JIKAN_0 = '0';
GPCST_CODE_JIKAN_1 = '1';
GPCST_CODE_JIKAN_2 = '2';
GPCST_CODE_JIKAN_3 = '3';
GPCST_NAME_JIKAN_0 = '定時';
GPCST_NAME_JIKAN_1 = '予約外';
GPCST_NAME_JIKAN_2 = '休日';
GPCST_NAME_JIKAN_3 = '当直';
// 撮影進捗 _SATUEI
GPCST_CODE_SATUEI_0 = '0';
GPCST_CODE_SATUEI_1 = '1';
GPCST_CODE_SATUEI_2 = '2';
GPCST_NAME_SATUEI_0 = '未撮影';
GPCST_NAME_SATUEI_1 = '撮影済';
GPCST_NAME_SATUEI_2 = '撮影キャンセル';
// 造影剤区分 _ZOUEI
GPCST_CODE_ZOUEI_0 = '0';
GPCST_CODE_ZOUEI_1 = '1';
GPCST_CODE_ZOUEI_2 = '2';
GPCST_CODE_ZOUEI_3 = '3';
GPCST_CODE_ZOUEI_4 = '4';
GPCST_NAME_ZOUEI_0 = '';
GPCST_NAME_ZOUEI_1 = '造影剤';
GPCST_NAME_ZOUEI_2 = '薬剤';
GPCST_NAME_ZOUEI_3 = 'カテ';
GPCST_NAME_ZOUEI_4 = '特材';
// 手技区分 SYUGI
GPCST_CODE_SYUGI_0 = '0';
GPCST_CODE_SYUGI_1 = '1';
GPCST_CODE_SYUGI_2 = '2';
//GPCST_CODE_SYUGI_3 = '3';
GPCST_NAME_SYUGI_0 = '';
GPCST_NAME_SYUGI_1 = '基本';
GPCST_NAME_SYUGI_2 = '処置';
//GPCST_NAME_SYUGI_3 = '以外は手技';
// 職種区分
{GPCST_SYOKUSHU_1='1';
GPCST_SYOKUSHU_2='2';
GPCST_SYOKUSHU_3='3';
GPCST_SYOKUSHU_4='4';
GPCST_SYOKUSHU_1_NAME='医師';
GPCST_SYOKUSHU_2_NAME='技師';
GPCST_SYOKUSHU_3_NAME='看護婦';
GPCST_SYOKUSHU_4_NAME='職員';}
//2001.09.06
GPCST_SYOKUSHU_1='1';
GPCST_SYOKUSHU_2='2';
GPCST_SYOKUSHU_3='3';
GPCST_SYOKUSHU_4='4';
GPCST_SYOKUSHU_1_NAME='医師';
GPCST_SYOKUSHU_2_NAME='事務等';
GPCST_SYOKUSHU_3_NAME='技師';
GPCST_SYOKUSHU_4_NAME='看護師';
//■帳票番号
GPCST_CHUHYO_BASE  = '00';
GPCST_CHUHYO_CH010 = '01';
GPCST_CHUHYO_CH020 = '02';
GPCST_CHUHYO_CH030 = '03';
GPCST_CHUHYO_CH040 = '04';
GPCST_CHUHYO_CH050 = '05';
GPCST_CHUHYO_CH060 = '06';
GPCST_CHUHYO_CH070 = '04';
//■自動再表示タイトル
GPCST_AUTO_DISP_TITLE  = '自動再表示中－';
//2001.09.10
//■帰宅指示
GPCST_KITAKU_0 = '0';
GPCST_KITAKU_1 = '1';
GPCST_KITAKU_0_NAME = '未帰宅';
GPCST_KITAKU_1_NAME = '帰宅済';
//2001.09.10
//■病棟連絡TEL
GPCST_TEL_0 = '0';
GPCST_TEL_1 = '1';
GPCST_TEL_0_NAME = '否';
GPCST_TEL_1_NAME = '要';
//2001.09.11
//■所見要否
GPCST_SYOKEN_YOUHI_0 = '0';
GPCST_SYOKEN_YOUHI_1 = '1';
GPCST_SYOKEN_YOUHI_0_NAME = '不要';
GPCST_SYOKEN_YOUHI_1_NAME = '必要';
// 撮影進捗
GPCST_CODE_SATUEIS_0 = '0';
GPCST_CODE_SATUEIS_1 = '1';
GPCST_CODE_SATUEIS_2 = '2';
GPCST_NAME_SATUEIS_0 = '未';
GPCST_NAME_SATUEIS_1 = '済';
GPCST_NAME_SATUEIS_2 = '中止';
GPCST_NAME_SATUEIS2_0 = '未入力';
GPCST_NAME_SATUEIS2_1 = '入力済';
GPCST_NAME_SATUEIS2_2 = '中止';
//■画像確認
GPCST_GAZOU_KAKUNIN_0 = '0';
GPCST_GAZOU_KAKUNIN_1 = '1';
GPCST_GAZOU_KAKUNIN_0_NAME = '未';
GPCST_GAZOU_KAKUNIN_1_NAME = '済';
//2001.09.20
//■帰宅指示
GPCST_KITAKU_0_G = '0';
GPCST_KITAKU_1_G = '1';
GPCST_KITAKU_0_NAME_G = '未';
GPCST_KITAKU_1_NAME_G = '帰';
//■病棟連絡TEL
GPCST_TEL_0_G = '0';
GPCST_TEL_1_G = '1';
GPCST_TEL_0_NAME_G = '';
GPCST_TEL_1_NAME_G = 'TEL';
//■画像確認
GPCST_GAZOU_KAKUNIN_0_G = '0';
GPCST_GAZOU_KAKUNIN_1_G = '1';
GPCST_GAZOU_KAKUNIN_0_NAME_G = '未';
GPCST_GAZOU_KAKUNIN_1_NAME_G = '済';
//↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑
//関数引数の定数//
//管理テーブル
G_KANRI_TBL_RMODE = '0';//参照モード
G_KANRI_TBL_WMODE = '1';//更新モード

//■依頼区分 2001.03.15
GPCST_KBN_10 = '10'; //単純撮影
GPCST_KBN_15 = '15'; //ﾎﾟｰﾀﾌﾞﾙ撮影
GPCST_KBN_20 = '20'; //断層撮影
GPCST_KBN_30 = '30'; //X線造影
GPCST_KBN_50 = '50'; //CT
GPCST_KBN_60 = '60'; //MR
GPCST_KBN_70 = '70'; //RI
GPCST_KBN_80 = '80'; //血管造影
GPCST_KBN_90 = '90'; //骨塩定量
{2001.09.01 Start}
//■大学統計写真分類
CST_DSB = 'DSB';
//■大学統計透視分類
CST_DTB = 'DTB';
//■手技区分
CST_SYUGI = 'SHG';
{2001.09.01 End}
//2001.09.03
//■造影剤区分
CST_ZOUEI = 'ZOE';
//2001.09.04
CST_SAYUU_DEF = 'なし';
//2001.09.03
//■職員区分
CST_SYOKUIN = 'SHK';
{2001.09.05 Start}
//■検査種別
{2003.11.26 変更
GPCST_SYUBETU_01 = '01'; //一般撮影
GPCST_SYUBETU_02 = '02'; //DIP･DIC
GPCST_SYUBETU_03 = '03'; //Portable
GPCST_SYUBETU_04 = '04'; //MMG
GPCST_SYUBETU_05 = '05'; //乳房特殊
GPCST_SYUBETU_06 = '06'; //乳房生検
GPCST_SYUBETU_07 = '07'; //CT
GPCST_SYUBETU_08 = '08'; //MRI
GPCST_SYUBETU_09 = '09'; //XTV
GPCST_SYUBETU_10 = '10'; //血管造影
GPCST_SYUBETU_11 = '11'; //心カテ
GPCST_SYUBETU_12 = '12'; //Echo
GPCST_SYUBETU_13 = '13'; //RI
GPCST_SYUBETU_14 = '14'; //参照画像取込
GPCST_SYUBETU_15 = '15'; //フィルム出力
GPCST_SYUBETU_20 = '20'; //治療計画CT
GPCST_SYUBETU_21 = '21'; //治療位置決め
}

{2003.12.06 変更
GPCST_SYUBETU_01 = '01'; //一般     <撮影系>
GPCST_SYUBETU_02 = '02'; //透視     <検査系>
GPCST_SYUBETU_03 = '03'; //血管     <検査系>
GPCST_SYUBETU_04 = '04'; //CT       <検査系>
GPCST_SYUBETU_05 = '05'; //MRI      <検査系>
GPCST_SYUBETU_06 = '06'; //核医学   <検査系>
GPCST_SYUBETU_07 = '07'; //治療     <検査系>
GPCST_SYUBETU_08 = '08'; //救命一般 <撮影系>
GPCST_SYUBETU_09 = '09'; //救命血管 <検査系>
GPCST_SYUBETU_10 = '10'; //救命CT   <検査系>
GPCST_SYUBETU_11 = '11'; //特殊     <撮影系>
GPCST_SYUBETU_12 = '12'; //骨塩     <検査系>
GPCST_SYUBETU_13 = '';   //未使用
GPCST_SYUBETU_14 = '';   //未使用
GPCST_SYUBETU_15 = '';   //未使用
GPCST_SYUBETU_20 = '';   //未使用
GPCST_SYUBETU_21 = '';   //未使用}

{2003.12.19 変更
GPCST_SYUBETU_11 = '11'; //一般     　　　<撮影系>
GPCST_SYUBETU_12 = '12'; //特殊検査     　<撮影系>
GPCST_SYUBETU_13 = '13'; //透視     　　　<検査系>
GPCST_SYUBETU_14 = '14'; //骨塩       　　<検査系>
GPCST_SYUBETU_15 = '15'; //血管      　　 <検査系>
GPCST_SYUBETU_16 = '16'; //CT   　　　　　<検査系>
GPCST_SYUBETU_17 = '17'; //MR    　　　　 <検査系>
GPCST_SYUBETU_18 = '18'; //核医学　　　　 <検査系>
GPCST_SYUBETU_19 = '19'; //治療 　　　　　<検査系>
GPCST_SYUBETU_20 = '20'; //治療位置決め   <撮影系>
GPCST_SYUBETU_21 = '21'; //治療位置決めCT <検査系>
GPCST_SYUBETU_22 = '22'; //救命一般     　<撮影系>
GPCST_SYUBETU_23 = '23'; //救命血管       <検査系>
GPCST_SYUBETU_24 = '24'; //救命CT         <検査系>
GPCST_SYUBETU_25 = '25';   //未使用
GPCST_SYUBETU_26 = '26';   //未使用
GPCST_SYUBETU_27 = '27';   //未使用}

GPCST_SYUBETU_01 = '01'; //一般     　　　<撮影系>
GPCST_SYUBETU_12 = '12'; //特殊検査     　<撮影系>
GPCST_SYUBETU_03 = '03'; //透視     　　　<検査系>
GPCST_SYUBETU_10 = '10'; //骨塩       　　<検査系>
GPCST_SYUBETU_08 = '08'; //血管      　　 <検査系>
GPCST_SYUBETU_05 = '05'; //CT   　　　　　<検査系>
GPCST_SYUBETU_06 = '06'; //MR    　　　　 <検査系>
GPCST_SYUBETU_07 = '07'; //核医学　　　　 <検査系>
GPCST_SYUBETU_09 = '09'; //治療 　　　　　<検査系>
GPCST_SYUBETU_14 = '14'; //治療位置決め   <撮影系>
GPCST_SYUBETU_15 = '15'; //治療位置決めCT <検査系>
GPCST_SYUBETU_31 = '31'; //救命一般     　<撮影系>
GPCST_SYUBETU_38 = '38'; //別館血管       <検査系>
GPCST_SYUBETU_35 = '35'; //別館CT         <検査系>
GPCST_SYUBETU_13 = '13'; //ｵﾍﾟ室ﾎﾟｰﾀﾌﾞﾙ   <撮影系> 2003.12.19追加



//■プリセットID番号取得用
CST_PRESET = 'PRE';
{2001.09.05 End}
//2001.09.07
//■入外区分取得用
CST_NYUGAI = 'NYU';
//■プリンタタイプ
GPCST_PRI_TYPE_01 = 'レーザー';         //レーザー
GPCST_PRI_TYPE_02 = 'ラベル';           //ラベル
GPCST_PRI_TYPE_03 = 'ドットインパクト'; //ドットインパクト
//2001.09.21
//■プリンタタイプ
GPCST_PRI_TYPE_NO_01 = '1';     //レーザー
GPCST_PRI_TYPE_NO_02 = '2';     //レベル
GPCST_PRI_TYPE_NO_03 = '3';     //ドットインパクト
//2001.11.10
GPCST_SATUEISITU_KYUKYU = '救急'; //撮影室=救急
//2002.09.20
//■色替要否
GPCST_COLOR_YOUHI_0 = '0';
GPCST_COLOR_YOUHI_1 = '1';
GPCST_COLOR_YOUHI_0_NAME = '不要';
GPCST_COLOR_YOUHI_1_NAME = '必要';
//2002.09.24
//■左右使用
GPCST_SAYUU_0 = '0';
GPCST_SAYUU_1 = '1';
GPCST_SAYUU_0_NAME = 'しない';
GPCST_SAYUU_1_NAME = 'する';
//2002.09.24
//■読影要否
GPCST_DOKUEI_0 = '0';
GPCST_DOKUEI_1 = '1';
GPCST_DOKUEI_2 = '2';
GPCST_DOKUEI_0_NAME = '不要';
GPCST_DOKUEI_1_NAME = '必要';
GPCST_DOKUEI_2_NAME = '緊急';
//2002.09.24
//■処置室使用
GPCST_SHOTI_0 = '0';
GPCST_SHOTI_1 = '1';
GPCST_SHOTI_0_NAME = 'しない';
GPCST_SHOTI_1_NAME = 'する';
GPCST_SHOTI_0_RYAKU_NAME = '';
GPCST_SHOTI_1_RYAKU_NAME = '使';
//2002.09.24
//■要造影
GPCST_YZOUEI_0 = '0';
GPCST_YZOUEI_1 = '1';
GPCST_YZOUEI_0_NAME = '';
GPCST_YZOUEI_1_NAME = '○';
//2002.09.24
//■処理区分
GPCST_SYORI_1 = '01';
GPCST_SYORI_2 = '02';
GPCST_SYORI_3 = '03';
GPCST_SYORI_1_NAME = '新規';
GPCST_SYORI_2_NAME = '更新';
GPCST_SYORI_3_NAME = '削除';
//2002.10.03
//■放科医師立会区分
GPCST_ISITATIAI_0 = '0';
GPCST_ISITATIAI_1 = '1';
GPCST_ISITATIAI_0_NAME = '立会なし';
GPCST_ISITATIAI_1_NAME = '立会あり';
GPCST_ISITATIAI_0_RyakuNAME = 'しない';
GPCST_ISITATIAI_1_RyakuNAME = 'する';
GPCST_ISITATIAI_0_RYAKU = '';
GPCST_ISITATIAI_1_RYAKU = '有';
//2002.10.03
//■デジタイズ進捗
GPCST_DEJITAI_0 = '0';
GPCST_DEJITAI_1 = '1';
GPCST_DEJITAI_0_NAME = '未';
GPCST_DEJITAI_1_NAME = '済';
//■検像進捗
GPCST_KENZOU_0 = '0';
GPCST_KENZOU_1 = '1';
GPCST_KENZOU_2 = '2';
GPCST_KENZOU_0_NAME = '再';
GPCST_KENZOU_1_NAME = '未';
GPCST_KENZOU_2_NAME = '済';
//2002.10.05
//■FCR連携
GPCST_FCR_0 = '0';
GPCST_FCR_1 = '1';
GPCST_FCR_0_NAME = 'しない';
GPCST_FCR_1_NAME = 'する';
//2002.10.05
//■MPPS対応
GPCST_MPPS_0 = '0';
GPCST_MPPS_1 = '1';
GPCST_MPPS_0_NAME = 'しない';
GPCST_MPPS_1_NAME = 'する';

GPCST_ERR_0 = '0';
GPCST_ERR_1 = '1';
GPCST_ERR_0_NAME = 'しない';
GPCST_ERR_1_NAME = 'する';
//2002.10.05
//■手技区分名
//GPCST_SHG_1_NAME = '基本';
GPCST_SHG_1_NAME = '加算'; //2004.02.01 koba
GPCST_SHG_2_NAME = '処置';
//■会計送信種別
GPCST_KAIKEI_0 = '0';
GPCST_KAIKEI_1 = '1'  ;
GPCST_KAIKEI_0_NAME = 'しない';
GPCST_KAIKEI_1_NAME = 'する'  ;

//■区分ﾏｽﾀID
GPCST_KBN_ID_SHOKEN   = '3';
GPCST_KBN_ID_KENSAKBN = '4';
GPCST_KBN_ID_3D = '16';
GPCST_KBN_ID_Cancel = '15';

//■RIオーダ区分
GPCST_RI_ORDER_0 = '0';
GPCST_RI_ORDER_1 = '1'  ;
GPCST_RI_ORDER_2 = '2'  ;
GPCST_RI_ORDER_0_NAME = 'なし';
GPCST_RI_ORDER_1_NAME = '注射'  ;
GPCST_RI_ORDER_2_NAME = '検査'  ;
//■画面ID項目
GPCST_GAMEN_0 ='B1';   //受付準備一覧画面ID
GPCST_GAMEN_1 ='E1';   //放部Dr.指示画面ID
GPCST_GAMEN_2 ='D1';   //当日受付一覧画面ID
GPCST_GAMEN_3 ='G1';   //撮影業務画面ID
GPCST_GAMEN_4 ='H1';   //検査業務一覧画面ID
GPCST_GAMEN_5 ='J1';   //Portable業務画面ID
GPCST_GAMEN_6 ='K1';   //RI業務画面ID
CPCST_GAMEN_7 ='N1';   //フィルム業務画面ID
GPCST_GAMEN_8 ='F1';   //検像業務画面ID
GPCST_GAMEN_9 ='X3';   //検査台帳一覧画面ID
GPCST_GAMEN_10='P1';   //患者実績一覧画面
//■オーダ指示コメント
GPCST_ORDER_COMMENT_131 = '131';//検査後診察無し
GPCST_ORDER_COMMENT_132 = '132';//検査後診察有り
//■感染症
GPCST_MRSA_SECTION_KEY = 'NAMECARDPRINT';
GPCST_MRSA_CODE_KEY = 'MRSACODE';
GPCST_MRSA_NAME_KEY = 'MRSANAME';

CST_PATH_GRID_COLUMNS   : string = 'C:\ris\columns\';//ｸﾞﾘｯﾄﾞｶﾗﾑｻｲｽﾞ保存先
//■Web用 指定条件　
{2004.03.09
GPCST_WED_KANJAID = 'patientid';
GPCST_WED_KENSADAY = 'date';
GPCST_WED_ORDERNO = 'accession';
GPCST_WED_MODALITY = 'modality';
2004.03.09}
//2004.03.09
GPCST_WED_KANJAID = 'ID';
GPCST_WED_KENSADAY = 'DATE';
//2004.03.29 GPCST_WED_ORDERNO = 'ODERNO';
GPCST_WED_ORDERNO = 'ORDERNO';
GPCST_WED_MODALITY = 'MODALITY';
//■依頼医指示中止情報
GPCST_FUTUUDOKUEI_CODE         = '101'; //普通読影
GPCST_KINKYUUDOKUEI_CODE       = '102'; //緊急読影
GPCST_DOKUHOKA_CODE            = '111'; //独歩可
GPCST_KURUMAISU_CODE           = '112'; //車椅子
GPCST_SUTORECCHA_CODE          = '113'; //ストレッチャー
GPCST_BED_CODE                 = '114'; //ベッド
GPCST_NINSINNASI_CODE          = '121'; //妊娠なし
GPCST_NINSINARI_CODE           = '122'; //妊娠有り
GPCST_NINSINFUMEI_CODE         = '123'; //心身不明
GPCST_KESASAGOSINSATUNASI_CODE = '131'; //検査後診察なし
GPCST_KENSAGOSANSATUARI_CODE   = '132'; //検査後診察あり
GPCST_CALLFUYOU_CODE           = '141'; //Call不要
GPCST_DRCALL_CODE              = '142'; //撮影時担当医Call
GPCST_BYOUSITU_CODE            = '201'; //病室
GPCST_SHUJUTUSITU_CODE         = '202'; //手術室
GPCST_KAIFUKUSITU_CODE         = '203'; //回復室
GPCST_KINKYUDORAISITU_CODE     = '204'; //緊急ドライ室
GPCST_KINKYUWETOSITU_CODE      = '205'; //緊急ウェット室
GPCST_GAIRAI_CODE              = '206'; //外来
GPCST_JINKINOUSEIJOU_CODE      = '301'; //腎機能正常
GPCST_JINKINOUIJOU_CODE        = '302'; //腎機能異常
GPCST_JINKINOUFUMEI_CODE       = '303'; //腎機能不明
GPCST_ZENSOKUNASI_CODE         = '311'; //喘息なし
GPCST_ZENSOKUARI_CODE          = '312'; //喘息あり
//2003.05.30
GPCST_ZENSOKUFUMEI_CODE        = '313'; //喘息不明
//2003.05.30 end
GPCST_YODONASI_CODE            = '321'; //ヨードアレルギーなし
GPCST_YODOARI_CODE             = '322'; //ヨードアレルギーあり
GPCST_YODOFUMEI_CODE           = '323'; //ヨードアレルギー不明
GPCST_TAINAIKINZOKUNASI_CODE   = '341'; //体内金属なし確認済み
GPCST_TAINAIKINZOKUARI_CODE    = '342'; //体内金属あり
GPCST_PESUMEKAARI_CODE         = '343'; //ペースメーカーあり
GPCST_HEISHONASI_CODE          = '351'; //閉所恐怖症なし
GPCST_HEISHOARI_CODE           = '352'; //閉所恐怖症あり
GPCST_BUSUKOPANKA_CODE         = '361'; //ブスコパン可
GPCST_BUSUKOPANHI_CODE         = '362'; //ブスコパン否
GPCST_GURUKAGONKA_CODE         = '371'; //ブス禁ーグルカゴン可
GPCST_GURUKAGONKIN_CODE        = '372'; //ブス禁ーグルカゴン禁
GPCST_OMUTUNASI_CODE           = '381'; //おむつ等なし
GPCST_OMUTUARI_CODE            = '382'; //おむつ等あり
GPCST_JUNYUNASI_CODE           = '391'; //授乳なし
GPCST_JUNYUCHU_CODE            = '392'; //授乳中

//2002.11.18
//■情報項目別マスタ区分/ID
CST_KMS = 'KMS';
CST_KMS_ID_1 = '1';
CST_KMS_ID_2 = '2';
CST_KMS_ID_5 = '5';   //連絡メモ：患者状態  2002.11.29
CST_KMS_ID_6 = '6';   //連絡メモ：メッセージ
CST_KMS_ID_7 = '7';   //連絡メモ：技師業務
CST_KMS_ID_8 = '8';   //撮影実施：誰が
CST_KMS_ID_9 = '9';   //撮影実施：どうした
CST_KMS_ID_10 = '10'; //Dr指示：造影有無
CST_KMS_ID_11 = '11'; //Dr指示：タイミング
CST_KMS_ID_12 = '12'; //Dr指示：撮像範囲
CST_KMS_ID_13 = '13'; //Dr指示：特殊撮影
CST_KMS_ID_14 = '14'; //検像コメント
CST_KMS_ID_17 = '17'; //フィルム枚数
//2003.12.09
CST_KMS_ID_18 = '18'; //備考
CST_KMS_ID_19 = '19'; //治療用　新/継
CST_KMS_ID_20 = '20'; //治療用　線原種類
CST_KMS_ID_21 = '21'; //mAs
CST_KMS_ID_22 = '22'; //ｽｷｬﾝ数

//2002.11.19
//■情報項目別マスタ区分
GPCST_SOUSIN_FLG_0 = '0';
GPCST_SOUSIN_FLG_1 = '1';
GPCST_SOUSIN_FLG_0_NAME = '未';
GPCST_SOUSIN_FLG_1_NAME = '済';

//2002.11.20
//日付のFormat
CST_FORMATDATE_0='YYYYMMDD';
CST_FORMATDATE_1='YYYY/MM/DD';
CST_FORMATDATE_2='YYYY/MM/DD HH:NN';
CST_FORMATDATE_3='YYYY/MM/DD HH:MM:SS';
CST_FORMATDATE_4='HHMMSS';
CST_FORMATDATE_5='HH:MM:SS';

//2002.11.21
//業務詳細画面ﾎﾞﾀﾝ操作
GPCST_BUTTON_0 = '0';  //保存のみ
GPCST_BUTTON_1 = '1';  //検査保留
GPCST_BUTTON_2 = '2';  //実施
GPCST_BUTTON_3 = '3';  //検像終了
GPCST_BUTTON_4 = '4';  //清算済

CST_ENG_TUKI_1='Jan';
CST_ENG_TUKI_2='Feb';
CST_ENG_TUKI_3='Mar';
CST_ENG_TUKI_4='Apr';
CST_ENG_TUKI_5='May';
CST_ENG_TUKI_6='Jun';
CST_ENG_TUKI_7='Jul';
CST_ENG_TUKI_8='Aug';
CST_ENG_TUKI_9='Sep';
CST_ENG_TUKI_10='Oct';
CST_ENG_TUKI_11='Nov';
CST_ENG_TUKI_12='Dec';

//MWM用送信、受信文字
GPCST_JUSIN_MOJI = 'START';
GPCST_JUSIN_MOJI_LEN = 5;
GPCST_SOUSIN_MOJI_1 = 'OK';
GPCST_SOUSIN_MOJI_2 = 'NG';
GPCST_SOUSIN_MOJI_LEN = 2;
//優先
GPCST_YUUSEN_0='0';
GPCST_YUUSEN_1='1';
GPCST_YUUSEN_2='2';
GPCST_YUUSEN_0_RYAKUNAME='';
GPCST_YUUSEN_1_RYAKUNAME='承';
GPCST_YUUSEN_2_RYAKUNAME='優';

GPCST_INFKBN_FU='FU';   //受付
GPCST_INFKBN_FC='FC';   //受付キャンセル {2002.12.17]
GPCST_INFKBN_FO='F0';   //実施
GPCST_INFKBN_F1='F1';   //中止           {2002.12.17]
GPCST_INFKBN_FY='FY';   //予約           {2003.01.07]
GPCST_INFKBN_FH='FH';   //保留
GPCST_SYORIKBN_01='01'; //新規
GPCST_SYORIKBN_02='02'; //更新
GPCST_SYORIKBN_03='03'; //削除
GPCST_JOUTAIKBN_3='3'; //実施
GPCST_JOUTAIKBN_7='7'; //中止

//ダイレクト印刷フラグ
GPCST_DIRECT_FLG='1';

GPCST_FCR = 'FCR';
GPCST_FPD = 'FPD';

{2003.05.07 start}
GPCST_NEW_FEILD_NAME = 'MWMCARET_FLG';
GPCST_MWM_TYPE_FLG_0 = '0';
GPCST_MWM_TYPE_FLG_0_NAME = '不要';
GPCST_MWM_TYPE_FLG_1 = '1';
GPCST_MWM_TYPE_FLG_1_NAME = '必要';
{2003.05.07 end}

//2003.12.11
//検査機器マスタ表示Flg用
GPCST_HYOJI_FLG_0 = '0';
GPCST_HYOJI_FLG_0_NAME = 'しない';
GPCST_HYOJI_FLG_1 = '1';
GPCST_HYOJI_FLG_1_NAME = 'する';

//伝票印刷フラグ  2003.12.11
GPCST_DENPYO_INSATU_FLG_1 = '1';

//患者紹介フラグ  2003.12.11
GPCST_KANJA_SYOKAIFLG_0 = '0';
GPCST_KANJA_SYOKAIFLG_1 = '1';

//精算フラグ 2003.12.12
GSPCST_SEISAN_FLG_0 = '0';
GSPCST_SEISAN_FLG_0_NAME = '未精算';
GSPCST_SEISAN_FLG_1 = '1';
GSPCST_SEISAN_FLG_1_NAME = '精算済';

//2003.10.13--------------------------------------------------------------------
GPCST_SATUEIJISSI_NAME = '★☆撮影実施者★☆';
//2003.10.13--------------------------------------------------------------------
GSPCST_GYOUMU_KBN_1 = '1';
GSPCST_GYOUMU_KBN_1_NAME = '日勤';
GSPCST_GYOUMU_KBN_2 = '2';
GSPCST_GYOUMU_KBN_2_NAME = '当直';
GSPCST_GYOUMU_KBN_3 = '3';
GSPCST_GYOUMU_KBN_3_NAME = '深夜';
GSPCST_GYOUMU_KBN_4 = '4';
GSPCST_GYOUMU_KBN_4_NAME = '緊急';

GSPCST_PORTABLE_FLG_0 = '0';
GSPCST_PORTABLE_FLG_1 = '1';
GSPCST_PORTABLE_FLG_2 = '2';
GSPCST_PORTABLE_FLG_3 = '3'; //2004.04.21

//同意書区分 2003.12.15
GPCST_DOUISHO_KBN_0 = '0';
GPCST_DOUISHO_KBN_0_NAME = 'なし';
GPCST_DOUISHO_KBN_1 = '1';
GPCST_DOUISHO_KBN_1_NAME = 'あり';

//受信マスタテーブル
//状態F 2003.12.16
GPCST_JOUTAI_FLG_0 = '0';
GPCST_JOUTAI_FLG_0_NAME = '表示';
GPCST_JOUTAI_FLG_1 = '1';
GPCST_JOUTAI_FLG_1_NAME = '確認済み';
GPCST_JOUTAI_FLG_3 = '3';
GPCST_JOUTAI_FLG_3_NAME = '削除';
//処理区分 2003.12.16
GPCST_JUSHIN_SHORI_1 = '1';
GPCST_JUSHIN_SHORI_1_NAME = '新規';
GPCST_JUSHIN_SHORI_2 = '2';
GPCST_JUSHIN_SHORI_2_NAME = '変更';
GPCST_JUSHIN_SHORI_3 = '3';
GPCST_JUSHIN_SHORI_3_NAME = '削除';
//マスタ区分 2003.12.18
GPCST_JUSHIN_MASTERTYPE_1 =  '1';
GPCST_JUSHIN_MASTERTYPE_1_NAME  = '撮影手技';
GPCST_JUSHIN_MASTERTYPE_11 = '11';
GPCST_JUSHIN_MASTERTYPE_11_NAME = '部位';
GPCST_JUSHIN_MASTERTYPE_12 = '12';
GPCST_JUSHIN_MASTERTYPE_12_NAME = '指示';
GPCST_JUSHIN_MASTERTYPE_13 = '13';
GPCST_JUSHIN_MASTERTYPE_13_NAME = '薬剤';
GPCST_JUSHIN_MASTERTYPE_14 = '14';
GPCST_JUSHIN_MASTERTYPE_14_NAME = '器材';
GPCST_JUSHIN_MASTERTYPE_15 = '15';
GPCST_JUSHIN_MASTERTYPE_15_NAME = 'ﾌｨﾙﾑ';
GPCST_JUSHIN_MASTERTYPE_16 = '16';
GPCST_JUSHIN_MASTERTYPE_16_NAME = '撮影方法';
GPCST_JUSHIN_MASTERTYPE_17 = '17';
GPCST_JUSHIN_MASTERTYPE_17_NAME = '加算';
GPCST_JUSHIN_MASTERTYPE_18 = '18';
GPCST_JUSHIN_MASTERTYPE_18_NAME = '造影剤';
GPCST_JUSHIN_MASTERTYPE_C =  'C';
GPCST_JUSHIN_MASTERTYPE_C_NAME  = '担当者マスタ';
//部位未送信F
GPCST_MISOUSIN_FLG_1 = '1'; //未送信
GPCST_MISOUSIN_FLG_1_NAME = '未送信'; //未送信
GPCST_MISOUSIN_FLG_N = '0';  //送信
GPCST_MISOUSIN_FLG_N_NAME = '送信';  //送信
//チャージ未使用F
GPCST_CHARGE_FLG_1 = '1'; //未使用
GPCST_CHARGE_FLG_1_NAME = '不可'; //未使用
GPCST_CHARGE_FLG_N = '0';  //使用
GPCST_CHARGE_FLG_N_NAME = '可'; //使用
//閉経区分
GPCST_HEIKEI_KBN_1 = '1';
GPCST_HEIKEI_KBN_1_NAME = '後';
GPCST_HEIKEI_KBN_0 = '0';
GPCST_HEIKEI_KBN_0_NAME = '前';
//月経規則
GPCST_GEKKEI_KBN_1 = '1';
GPCST_GEKKEI_KBN_1_NAME = '不規則';
GPCST_GEKKEI_KBN_0 = '0';
GPCST_GEKKEI_KBN_0_NAME = 'ほぼ規則的';
//月経調査票必要
GPCST_GEKKEI_FLG_0 = '0';
GPCST_GEKKEI_FLG_0_NAME = '不要';
GPCST_GEKKEI_FLG_1 = '1';
GPCST_GEKKEI_FLG_1_NAME = '必要';
//ポータブルフラグ
GPCST_PORTABLE_FLG_0 = '0';
GPCST_PORTABLE_FLG_0_NAME = '通常';
GPCST_PORTABLE_FLG_1 = '1';
GPCST_PORTABLE_FLG_1_NAME = 'ポータブル';
GPCST_PORTABLE_FLG_2 = '2';
GPCST_PORTABLE_FLG_2_NAME = '手術室';
GPCST_PORTABLE_FLG_3 = '3';           //2004.06.15
GPCST_PORTABLE_FLG_3_NAME = 'その他'; //2004.06.15
//2003.12.25
//RIオーダ番号変換番号（注射・検査）
GPCST_RIORDER_NO_CHUSYA = '0';
GPCST_RIORDER_NO_KENSA  = '6';

//2004.01.22
//ReportRisTable設定フラグ(WinMaster用)
GPCST_REPORT_FLG_1 = '1';
GPCST_REPORT_FLG_1_NAME = 'あり';
GPCST_REPORT_FLG_0 = '0';
GPCST_REPORT_FLG_0_NAME = 'なし';

GPCST_MISIYOU_FLG_1 = '1';
GPCST_MISIYOU_FLG_1_NAME = '未使用';
GPCST_MISIYOU_FLG_0 = '0';
GPCST_MISIYOU_FLG_0_NAME = '使用';

//RISオーダ送信キュー作成設定  2004.02.05
GPCST_RISORDERSOUSIN_FLG_0 = '0';
GPCST_RISORDERSOUSIN_FLG_0_NAME = 'なし';
GPCST_RISORDERSOUSIN_FLG_1 = '1';
GPCST_RISORDERSOUSIN_FLG_1_NAME = '通常'; //'あり'; //2004.04.09
//2004.04.09
GPCST_RISORDERSOUSIN_FLG_2 = '2';
GPCST_RISORDERSOUSIN_FLG_2_NAME = 'HISなしRepあり';

//2004.03.25--
//転送オーダーテーブル
//確認F
GPCST_TENSOU_KAKUNIN_FLG_0 = '0';
GPCST_TENSOU_KAKUNIN_FLG_0_NAME = '表示';
GPCST_TENSOU_KAKUNIN_FLG_1 = '1';
GPCST_TENSOU_KAKUNIN_FLG_1_NAME = '確認済み';
GPCST_TENSOU_KAKUNIN_FLG_3 = '3';
GPCST_TENSOU_KAKUNIN_FLG_3_NAME = '削除';
//情報種別
GPCST_TENSOU_INFKBN_F0 = 'F0';
GPCST_TENSOU_INFKBN_FU = 'FU';
GPCST_TENSOU_INFKBN_FC = 'FC';
GPCST_TENSOU_INFKBN_F1 = 'F1';
GPCST_TENSOU_INFKBN_F0_NAME = '実施情報';
GPCST_TENSOU_INFKBN_FU_NAME = '検査受付';
GPCST_TENSOU_INFKBN_FC_NAME = '受付キャンセル';
GPCST_TENSOU_INFKBN_F1_NAME = '検査中止';
GPCST_TENSOU_INFKBN_JISSHI_NAME = '実施情報';
GPCST_TENSOU_INFKBN_UKETUKE_NAME = '受付情報';
GPCST_TENSOU_INFKBN_KANJA_NAME = '患者情報要求';
GPCST_TENSOU_INFKBN_JUSHIN_NAME = '受信ｵｰﾀﾞﾃｰﾌﾞﾙ';   //2004.05.04
//状態メッセージ
GPCST_TENSOU_JOUTAI_01 = '01';
GPCST_TENSOU_JOUTAI_02 = '02';
GPCST_TENSOU_JOUTAI_03 = '03';
GPCST_TENSOU_JOUTAI_04 = '04';
//2004.03.31
GPCST_TENSOU_JOUTAI_66 = '66';
GPCST_TENSOU_JOUTAI_77 = '77';
GPCST_TENSOU_JOUTAI_88 = '88';
GPCST_TENSOU_JOUTAI_99 = '99';
GPCST_TENSOU_JOUTAI_01_NAME = '成功';
GPCST_TENSOU_JOUTAI_02_NAME = '電文エラー';
GPCST_TENSOU_JOUTAI_03_NAME = '通信エラー';
GPCST_TENSOU_JOUTAI_04_NAME = 'ユーザ確認';
//2004.03.31
GPCST_TENSOU_JOUTAI_66_NAME = '送信済電文エラー';
GPCST_TENSOU_JOUTAI_77_NAME = '送信済例外エラー';
GPCST_TENSOU_JOUTAI_88_NAME = '進捗エラー';
GPCST_TENSOU_JOUTAI_99_NAME = '未送信例外エラー';
//送信フラグ
GPCST_TENSOU_SOUSHINFLG_0 = '0';
GPCST_TENSOU_SOUSHINFLG_1 = '1';
GPCST_TENSOU_SOUSHINFLG_0_NAME = '未';
GPCST_TENSOU_SOUSHINFLG_1_NAME = '済';
//登録種別
GPCST_TENSOU_SYORIKBN_01 = '01';
GPCST_TENSOU_SYORIKBN_02 = '02';
GPCST_TENSOU_SYORIKBN_03 = '03';
GPCST_TENSOU_SYORIKBN_01_NAME = '新規';
GPCST_TENSOU_SYORIKBN_02_NAME = '更新';
GPCST_TENSOU_SYORIKBN_03_NAME = '削除';
//--2004.03.25
//■フィルム整理票印刷
GPCST_FILMLABEL_1 = '1';     //
GPCST_FILMLABEL_2 = '2';     //
GPCST_FILMLABEL_3 = '3';     //

GPCST_FILMLABEL_1_NAME = '保留・検査済';     //
GPCST_FILMLABEL_2_NAME = '検査済のみ';     //
GPCST_FILMLABEL_3_NAME = 'なし';     //

//2004.05.04--
//受信オーダテーブル
//シェーマ取得フラグ
GPCST_JUSHIN_SHEMA_0 ='0';
GPCST_JUSHIN_SHEMA_1 ='1';
GPCST_JUSHIN_SHEMA_2 ='2';
GPCST_JUSHIN_SHEMA_0_NAME ='シェーマ未取得';
GPCST_JUSHIN_SHEMA_1_NAME ='シェーマ取得済み';
GPCST_JUSHIN_SHEMA_2_NAME ='失敗';

//2004.05.05 ->
//撮影場所区分（病室マスタ）
GPCST_CODE_BYK_1 = '1';   //本館
GPCST_CODE_BYK_2 = '2';   //別館
GPCST_CODE_BYK_3 = '3';   //救命
//<-

//変数宣言-------------------------------------------------------------------
var
//実行環境情報---------------------
   g_Exe_Name   : string;
   g_Exe_FName  : string;
   g_LogPlefix  : string;
//INIファイル場所-------------------
   g_TcpIniPath : string;
//INIファイル情報-------------------
//SERVICE情報
   g_Svc_Sd_Acvite:string;
   g_Svc_Rv_Acvite:string;
   g_Svc_Sd_Cycle :integer;
   g_Svc_Rv_Cycle :integer;
//DB接続情報
   g_RisDB_Name : string;
   g_RisDB_Uid  : string;
   g_RisDB_Pas  : string;
   g_RisDB_DpendSrvName :string;
   g_RisDB_Retry: integer;
   g_RisDB_SndKeep: integer;
   g_RisDB_RcvKeep: integer;
//Socket接続用情報郡
   //クライアント
   g_C_Socket_Info_01      :  TClint_Info;
   g_C_Socket_Info_02      :  TClint_Info;
   g_C_Socket_Info_03      :  TClint_Info;
   g_C_Socket_Info_04      :  TClint_Info;
   g_C_Socket_Info_05      :  TClint_Info;
   g_C_Socket_Info_06      :  TClint_Info;
   //サーバ
   g_S_Socket_Info_01      :  TServer_Info;
   g_S_Socket_Info_02      :  TServer_Info;
   g_S_Socket_Info_03      :  TServer_Info;
   g_S_Socket_Info_04      :  TServer_Info;
   g_S_Socket_Info_05      :  TServer_Info;
   g_S_Socket_Info_06      :  TServer_Info;
//LOG情報
   g_Rig_LogActive         :  string;
   g_Rig_LogPath           :  string;
   g_Rig_LogSize           :  string;
   g_Rig_LogKeep           :  integer;
   g_Rig_LogIncMsg         :  string;
   g_Rig_LogLevel          :  string;
//LOG種別定義域（外部定義の場合）
   g_Log_Type     : array[1..G_MAX_LOG_TYPE] of TLog_Type;
//読影優先コード
   g_Name_Kansen01          :  string;
//プロファイル属性
   g_Prof01 : string;
   g_Prof02 : string;
//シェーマ情報
   g_Schema_Main : string;
   g_Schema_Sub  : string;
   g_Schema_Del  : string;
//バックアップパス
   g_Svr_Main : string;
   g_Svr_Back : string;
   g_Save_Active : string;
//予約枠コード、検査機器ID対応表
   g_Kikitaiou : TKensakiki;
//検像緊急コメントID
   g_Kenzo : TStrings;
//撮影場所コメントID
   g_Satuei : TStrings;
//患者状態コメントID
   g_KanjaJyoutai : TStrings;
//オーダ指示情報HIS・RISコード
   g_OrderIndicate_Code : array of TOrderIndicate;
   g_OrderIndicate_Up   : String;
//患者プロファイル情報コード
   g_KanjaProf_Code : array of TOrderIndicate;
   g_KanjaProfCode_Code : array of TOrderIndicate;
//XML変換文字列情報コード
   g_XML_Code : array of TXML;
//方向ダミー情報コード
   g_HOUKOU_Code : array of TDUMMY;
//検査方法ダミー情報コード
   g_HOUHOU_Code : array of TDUMMY;
//2004.03.24
//オラクルエラー番号
   g_OraErrNo : TStrings;
//関数手続き宣言-------------------------------------------------------------
//1.ログ出力関数系----------------------------------------------------------------
procedure proc_LogOut(
     arg_Status: string; //ステータス接頭子
     arg_Time:string;    //日時 ''：自動マシン時間
     arg_Kind:integer;   //ログ種別
     arg_Diteil:string); //詳細ログ
//2.文字コード系------------------------------------------------------------------
//文字コード系のストリーム型処理
procedure proc_SisToJis(arg_Stream: TStringStream);  //SJISからJISに返還
procedure proc_JisToSJis(arg_Stream: TStringStream); //JISからSJISに返還
function  func_SJisToJis(arg_Stream: string): string;//SJISからJISに返還
function  func_MakeSJIS: String;                     //SJIS文字列の作成
//3.INIファイル系-----------------------------------------------------------------
//Iniファイル情報読み出し
function  func_TcpReadiniFile: Boolean;
procedure proc_ReadiniYoyaku(
                           arg_Ini : TIniFile;
                           var arg_kiki:Tkensakiki
                           );
procedure proc_ReadiniKenzo(
                           arg_Ini : TIniFile;
                           var arg_Kenzo,arg_Satuei,arg_Kanja:TStrings
                           );
procedure proc_ReadiniOrderIndicate(
                           arg_Ini : TIniFile
                           );
procedure proc_ReadiniKanjaProf(
                           arg_Ini : TIniFile
                           );
procedure proc_ReadiniXML(
                          arg_Ini : TIniFile
                          );
procedure proc_ReadiniDummy_Code(
                          arg_Ini : TIniFile
                          );
procedure proc_ReadiniOraErr(arg_Ini : TIniFile;var arg_OraErr:TStrings);
//4.バッファ系--------------------------------------------------------------------
//バッファよりオフセットとサイズで文字列として取出す
//バッファから文字列を取り出す
function func_ByteToStr(
           arg_Buffer        : array of byte ; //バッファ
           arg_offset        : LongInt;        //オフセット
           arg_size          : LongInt         //サイズ
           ):string;
//バッファに文字列を設定
procedure proc_StrToByte(
           var arg_Buffer      : array of byte ;//バッファ
           arg_offset      : LongInt;           //オフセット
           arg_str         : string             //文字列
           );
//バッファよりTStringStreamを作成する
function  func_BufferToStrStrm(
           arg_Buffer        : array of byte; //バッファ
           arg_Size          : Longint        //サイズ
       ):TStringStream;
//5.電文ストリーム系------------------------------------------------------------------
//TStringListよりTStringStreamを作成する
Procedure  proc_TStrListToStrm(
           arg_TStringList   : TStringList;
           arg_TStringStream : TStringStream
           );
Procedure  proc_TStrListToStrm2(
           arg_TStringList   : TStringList;
           arg_TStringStream : TStringStream
           );
//TStringStreamより解析してTStringListを作成する
procedure proc_TStrmToStrlist(
           arg_TStringStream : TStringStream;
           arg_TStringList   : TStringList
           );
//TStringStreamより解析してTStringListを作成する
procedure proc_TStrmToStrlist2(
           arg_TStringStream : TStringStream;
           arg_TStringList   : TStringList
           );
procedure proc_TStrmToStrlist3(
           arg_String      : String;
           arg_TStringList : TStringList
           );
procedure proc_TStrmToStrlist4(
           arg_TStringStream : TStringStream;
           arg_TStringList   : TStringList
           );
//6.その他系------------------------------------------------------------------
//カンマ区切りで結合する
procedure  proc_StrConcat(
           var arg_LogBase   : string;
           arg_Log           : string
           );
function func_IsNumberStr(arg_str1:string): Boolean;
//2001.12.27
function func_MBTrim(arg_str:string)     : string;
function func_MBTrimRight(arg_str:string): string;
function func_MBTrimLeft(arg_str:string) : string;
function func_LeftSpace(intCapa : Integer;EditStr : String): String;
function func_RigthSpace(intCapa : Integer;EditStr : String): String;
function func_LeftZero(intCapa : Integer;EditStr : String): String;
procedure proc_BUp_TxtOut(arg_path,arg_Flg,arg_Data:String;arg_DateTime:TDateTime);
function bswap(src : integer) : integer; assembler;
function bswapf(src : single) : single;
procedure ByteOrderSwap(var Src: Double); overload;
function EndianShort_Short(Value: Short): Short;
function func_Lowerc(arg_string : String):String;
function func_Change_XML(arg_string : String):String;
function func_Change_RIS(arg_string : String):String;
function func_Search_OraErr(arg_Msg : String):String;
//●機能（例外無）：ｺｰﾄﾞを名前に変換登録 手技区分
function func_PIND_Change_SYUGI(
       arg_Code:string    //ｺｰﾄﾞ
       ):string;          //名称
//●★使用可★機能（例外有）：現在番号+1取得
function func_Get_NumberControl(
         arg_Database:TDatabase;
         arg_Query:TQuery;
         arg_Kubun:string;
         arg_Date:string
         ):integer;
//●★使用可★機能（例外有）：現在番号更新
function func_NumberControl_Update(
         arg_Database:TDatabase;
         arg_Query:TQuery;
         arg_Mode:integer;
         arg_Kubun:string;
         arg_UpdateDate:string;
         arg_Now_NO:integer
         ):Boolean;
//●機能（例外無）：シェーマ格納ファイル名作成
function func_Make_ShemaName(arg_OrderNO,               //オーダNO
                             arg_MotoFileName: string;  //HISｼｪｰﾏ名
                             arg_Index: integer         //部位NO
                             ):string;                  //格納ﾌｧｲﾙ名

implementation //**************************************************************

//使用ユニット---------------------------------------------------------------
//uses

//定数宣言       -------------------------------------------------------------
//const

//変数宣言     ---------------------------------------------------------------
//var

//関数手続き宣言--------------------------------------------------------------
//-----------------------------------------------------------------------------
//4.バッファ系制御処理
//-----------------------------------------------------------------------------
//●バッファよりオフセットとサイズで文字列として設定する
procedure proc_StrToByte(var arg_Buffer : array of Byte;
                             arg_offset : LongInt;
                             arg_str    : String
                         );
var
  w_i:LongInt;
begin
  //文字列の分だけループ
  for w_i := 0 to length(AnsiString(arg_str)) - 1 do begin
    //オフセットから文字列を入れていき、バッファを超えた場合
    if (high(arg_Buffer) <= (arg_offset + w_i)) then
      //処理終了
      Break;
    //バッファに文字列を設定
    arg_Buffer[arg_offset + w_i] := byte(arg_str[w_i+1]);
  end;
end;
//バッファよりオフセットとサイズで文字列として取出す
function func_ByteToStr(arg_Buffer : array of Byte;
                        arg_offset : LongInt;
                        arg_size   : LongInt
                        ):string;
var
  w_i:LongInt;
begin
  //初期設定
  Result := '';
  //オフセットから指定のサイズまでループ
  for w_i := arg_offset to (arg_offset + arg_size - 1) do begin
    //文字列を取得
    Result := Result + chr(arg_Buffer[w_i]);
  end;
end;
{
-----------------------------------------------------------------------------
  名前 : func_BufferToStrStrm;
  引数 :
  arg_Buffer: バッファ
  arg_Size:   サイズ
  機能 : バッファよりTStringStreamを作成する
  復帰値：TStringStream nil失敗
-----------------------------------------------------------------------------
}
function func_BufferToStrStrm(arg_Buffer : array of Byte;
                              arg_Size   : Longint
                              ):TStringStream;
begin
  try
    //初期値
    Result := TStringStream.Create('');
  except
    //nil処理
    Result := nil;
    //処理終了
    Exit;
  end;
  try
    //初期位置
    Result.Position := 0;
    //ストリームに書き込み
    Result.Write( arg_Buffer, arg_Size );
  except
    //開放
    Result.Free;
    //nil処理
    Result := nil;
    //処理終了
    Exit;
  end;
end;

//-----------------------------------------------------------------------------
//5.電文ストリーム系 制御処理
//-----------------------------------------------------------------------------
{
-----------------------------------------------------------------------------
  名前 : proc_TStrmToStrlist
  引数 :
  arg_TStringList:TStringList      元
  arg_TStringList   : TStringList  先
  arg_System        : string;      種類
  arg_MsgKind       : string       種別

  機能 : TStringStreamより解析してTStringListを作成する
  復帰値：
-----------------------------------------------------------------------------
}
procedure proc_TStrmToStrlist(
           arg_TStringStream : TStringStream;
           arg_TStringList   : TStringList
           );
var
  w_S:string;
  w_S2:String;
  w_i:integer;
begin
//TStringStream→TStringListに展開
  //初期値
  arg_TStringList.Text := '';
  //初期化
  arg_TStringList.Clear;
  //初期位置に移動
  arg_TStringStream.Position := 0;
  w_i := 1;
  w_S := arg_TStringStream.DataString;

  w_S2 := w_S2 + func_Lowerc(Copy(w_S,1,1));
  w_S2 := w_S2 + func_Lowerc(Copy(w_S,2,1));
  w_S2 := w_S2 + Copy(w_S,3,14);
  w_S2 := w_S2 + func_Lowerc(Copy(w_S,17,1));
  w_S2 := w_S2 + func_Lowerc(Copy(w_S,18,1));
  w_S2 := w_S2 + func_Lowerc(Copy(w_S,19,1));
  w_S2 := w_S2 + func_Lowerc(Copy(w_S,20,1));

  w_S2 := w_S2 + Copy(w_S,21,Length(w_S));

  w_S := w_S2;
  while w_S <> '' do begin
    if AnsiPos('><',w_S) > 0 then begin
      w_S2 := Copy(w_S,w_i,AnsiPos('><',w_S));
      arg_TStringList.Add(w_S2);
      w_S := Copy(w_S,AnsiPos('><',w_S) + 1,Length(w_S));
      if w_S = '</risinfo>' then begin
        arg_TStringList.Add(w_S);
        Break;
      end;
    end
    else
      Break;
  end;
  if Length(arg_TStringList.Text) = 0 then
    arg_TStringList.Add(w_S);
  //処理終了
  Exit;
end;
{
-----------------------------------------------------------------------------
  名前 : proc_TStrmToStrlist2
  引数 :
  arg_TStringList:TStringList      元
  arg_TStringList   : TStringList  先
  arg_System        : string;      種類
  arg_MsgKind       : string       種別

  機能 : TStringStreamより解析してTStringListを作成する
  復帰値：
-----------------------------------------------------------------------------
}
procedure proc_TStrmToStrlist2(
           arg_TStringStream : TStringStream;
           arg_TStringList   : TStringList
           );
var
  w_S:string;
  w_S2:String;
  w_i:integer;
begin
//TStringStream→TStringListに展開
  //初期値
  arg_TStringList.Text := '';
  //初期化
  arg_TStringList.Clear;
  //初期位置に移動
  arg_TStringStream.Position := 0;
  w_i := 1;
  w_S := arg_TStringStream.DataString;
  while w_S <> '' do begin
    if AnsiPos('><',w_S) > 0 then begin
      w_S2 := Copy(w_S,w_i,AnsiPos('><',w_S));
      arg_TStringList.Add(w_S2);
      w_S := Copy(w_S,AnsiPos('><',w_S) + 1,Length(w_S));
      if w_S = '</risinfo>' then begin
        arg_TStringList.Add(w_S);
        Break;
      end;
    end
    else
      Break;
  end;
  if Length(arg_TStringList.Text) = 0 then
    arg_TStringList.Add(w_S);
  //処理終了
  Exit;
end;
{
-----------------------------------------------------------------------------
  名前 : proc_TStrmToStrlist3
  引数 :
  arg_TStringList:TStringList      元
  arg_TStringList   : TStringList  先
  arg_System        : string;      種類
  arg_MsgKind       : string       種別

  機能 : TStringStreamより解析してTStringListを作成する
  復帰値：
-----------------------------------------------------------------------------
}
procedure proc_TStrmToStrlist3(
           arg_String      : String;
           arg_TStringList : TStringList
           );
var
  w_S:string;
  w_S2:String;
  w_i:integer;
begin
//TStringStream→TStringListに展開
  //初期値
  arg_TStringList.Text := '';
  //初期化
  arg_TStringList.Clear;
  w_i := 1;
  w_S := arg_String;
  while w_S <> '' do begin
    if AnsiPos('><',w_S) > 0 then begin
      w_S2 := Copy(w_S,w_i,AnsiPos('><',w_S));
      arg_TStringList.Add(w_S2);
      w_S := Copy(w_S,AnsiPos('><',w_S) + 1,Length(w_S));
      if w_S = '</risinfo>' then begin
        arg_TStringList.Add(w_S);
        Break;
      end;
    end
    else
      Break;
  end;
  if Length(arg_TStringList.Text) = 0 then
    arg_TStringList.Add(w_S);
  //処理終了
  Exit;
end;
{
-----------------------------------------------------------------------------
  名前 : proc_TStrmToStrlist4
  引数 :
  arg_TStringList:TStringList      元
  arg_TStringList   : TStringList  先
  arg_System        : string;      種類
  arg_MsgKind       : string       種別

  機能 : TStringStreamより解析してTStringListを作成する
  復帰値：
-----------------------------------------------------------------------------
}
procedure proc_TStrmToStrlist4(
           arg_TStringStream : TStringStream;
           arg_TStringList   : TStringList
           );
var
  w_S:string;
  w_S2:String;
  w_i:integer;
begin
//TStringStream→TStringListに展開
  //初期値
  arg_TStringList.Text := '';
  //初期化
  arg_TStringList.Clear;
  //初期位置に移動
  arg_TStringStream.Position := 0;
  w_i := 1;
  w_S := arg_TStringStream.DataString;

  w_S2 := w_S2 + func_Lowerc(Copy(w_S,1,1));
  w_S2 := w_S2 + func_Lowerc(Copy(w_S,2,1));
  w_S2 := w_S2 + func_Lowerc(Copy(w_S,3,1));
  w_S2 := w_S2 + func_Lowerc(Copy(w_S,4,1));
  w_S2 := w_S2 + func_Lowerc(Copy(w_S,5,1));
  w_S2 := w_S2 + func_Lowerc(Copy(w_S,6,1));

  w_S2 := w_S2 + Copy(w_S,7,Length(w_S));

  w_S := w_S2;
  while w_S <> '' do begin
    if AnsiPos('><',w_S) > 0 then begin
      w_S2 := Copy(w_S,w_i,AnsiPos('><',w_S));
      arg_TStringList.Add(w_S2);
      w_S := Copy(w_S,AnsiPos('><',w_S) + 1,Length(w_S));
      if w_S = '</risinfo>' then begin
        arg_TStringList.Add(w_S);
        Break;
      end;
    end
    else
      Break;
  end;
  if Length(arg_TStringList.Text) = 0 then
    arg_TStringList.Add(w_S);
  //処理終了
  Exit;
end;
{
-----------------------------------------------------------------------------
  名前 : proc_TStrListToStrm
  引数 :
  arg_TStringList   : TStringList  元
  arg_TStringList:TStringList      先
  arg_System        : string;      種類
  arg_MsgKind       : string       種別
  arg_TStringList:TStringList
  機能 : TStringListよりTStringStreamを作成する
  復帰値：TStringStream nil失敗
-----------------------------------------------------------------------------
}
Procedure  proc_TStrListToStrm(
           arg_TStringList   : TStringList;
           arg_TStringStream : TStringStream
           );
var
  w_i:integer;
  w_i2:integer;
  w_len1:integer;
  w_s:string;
  w_iSize:integer;
  w_ii:Word;
  w_Hex1 :string;
  w_Hex2 :string;
  w_Hex3 :string;
  w_Hex4 :string;
begin
  //TStringList→TStringStreamに展開
  try
    //初期化
    w_len1 := 0;
    //リスト数分ループ
    for w_i := 0 to arg_TStringList.Count - 1 do begin
      //一ラインずつ展開
      arg_TStringStream.Position := w_len1;
      if w_i = 0 then begin
        w_s := chr(StrToInt('$' + arg_TStringList[w_i]));
      end
      else if w_i = 1 then begin
        w_s := chr(StrToInt('$' + arg_TStringList[w_i]));
      end
      else if w_i = 3 then begin
        w_s := '';
        //リスト数分ループ
        for w_i2 := 0 to arg_TStringList.Count - 1 do begin
          w_s := w_s + arg_TStringList.Strings[w_i2];
        end;
        //データ長を設定
        w_s := FormatFloat('00000',Length(w_s) - 22);
        w_iSize := StrToInt(w_s);
        w_ii := w_iSize;
        w_s := IntToHex(w_ii,0);
        w_s := Copy('00000000', 1, 8 - Length(w_s)) + w_s;
        w_Hex1 := chr(StrToInt('$' + Copy(w_s,1,2)));
        w_Hex2 := chr(StrToInt('$' + Copy(w_s,3,2)));
        w_Hex3 := chr(StrToInt('$' + Copy(w_s,5,2)));
        w_Hex4 := chr(StrToInt('$' + Copy(w_s,7,2)));
        w_s    := w_Hex1 + w_Hex2 + w_Hex3 + w_Hex4;
      end
      else begin
        //データの取得
        w_s := arg_TStringList[w_i];
      end;
      //送信データの書き込み
      arg_TStringStream.WriteString(w_s);
      //位置の移動
      w_len1 := w_len1 + Length(w_s);
    end;
  except
    //初期化
    arg_TStringStream.Position := 0;
    //処理終了
    Exit;
  end;
end;
{
-----------------------------------------------------------------------------
  名前 : proc_TStrListToStrm2
  引数 :
  arg_TStringList   : TStringList  元
  arg_TStringList:TStringList      先
  arg_System        : string;      種類
  arg_MsgKind       : string       種別
  arg_TStringList:TStringList
  機能 : TStringListよりTStringStreamを作成する
  復帰値：TStringStream nil失敗
-----------------------------------------------------------------------------
}
Procedure  proc_TStrListToStrm2(
           arg_TStringList   : TStringList;
           arg_TStringStream : TStringStream
           );
var
  w_i:integer;
  w_i2:integer;
  w_len1:integer;
  w_s:string;
  w_iSize:integer;
  w_ii:Word;
  w_Hex1 :string;
  w_Hex2 :string;
  w_Hex3 :string;
  w_Hex4 :string;
begin
  //TStringList→TStringStreamに展開
  try
    //初期化
    w_len1 := 0;
    //リスト数分ループ
    for w_i := 0 to arg_TStringList.Count - 1 do begin
      //一ラインずつ展開
      arg_TStringStream.Position := w_len1;
      if w_i = 2 then begin
        w_s := '';
        //リスト数分ループ
        for w_i2 := 0 to arg_TStringList.Count - 1 do begin
          w_s := w_s + arg_TStringList.Strings[w_i2];
        end;
        //データ長を設定
        w_s := FormatFloat('00000',Length(w_s) - 10);
        w_iSize := StrToInt(w_s);
        w_ii := w_iSize;
        w_s := IntToHex(w_ii,0);
        w_s := Copy('00000000', 1, 8 - Length(w_s)) + w_s;
        w_Hex1 := chr(StrToInt('$' + Copy(w_s,1,2)));
        w_Hex2 := chr(StrToInt('$' + Copy(w_s,3,2)));
        w_Hex3 := chr(StrToInt('$' + Copy(w_s,5,2)));
        w_Hex4 := chr(StrToInt('$' + Copy(w_s,7,2)));
        w_s    := w_Hex1 + w_Hex2 + w_Hex3 + w_Hex4;
      end
      else begin
        //データの取得
        w_s := chr(StrToInt('$' + arg_TStringList[w_i]));
      end;
      //送信データの書き込み
      arg_TStringStream.WriteString(w_s);
      //位置の移動
      w_len1 := w_len1 + Length(w_s);
    end;
  except
    //初期化
    arg_TStringStream.Position := 0;
    //処理終了
    Exit;
  end;
end;
//-----------------------------------------------------------------------------
// 2.文字コード系制御処理
//-----------------------------------------------------------------------------
{
-----------------------------------------------------------------------------
  名前 : proc_JisToSJis;
  引数 :
  arg_Stream:TStringStream
  機能 : ストリームをJisからSJisに変換する
  復帰値：
-----------------------------------------------------------------------------
}
procedure proc_JisToSJis(arg_Stream: TStringStream);
var
 w_s:string;
begin
    w_s := arg_Stream.DataString;
    w_s := SJis7ToSJis8(w_s);
    w_s := JisToSJis(w_s);
    arg_Stream.Position:=0;
    arg_Stream.WriteString(w_s);

end;
{
-----------------------------------------------------------------------------
  名前 : proc_SisToJis;
  引数 :
  arg_Stream:TStringStream
  機能 : ストリームをJisからSJisに変換する
  復帰値：
-----------------------------------------------------------------------------
}
procedure proc_SisToJis(arg_Stream: TStringStream);
var
 w_s:string;
begin
    w_s := arg_Stream.DataString;
    w_s := SJis8ToSJis7(w_s);
    w_s := SJisToJis(w_s);
    arg_Stream.Position:=0;
    arg_Stream.WriteString(w_s);

end;
{
-----------------------------------------------------------------------------
  名前 : func_TStrListToStrm;
  引数 :
  arg_TStringList:TStringList
  機能 : TStringListよりストリームを作成する
  復帰値：TStringStream nil失敗
-----------------------------------------------------------------------------
}
function func_SJisToJis(arg_Stream: string): string;
begin
    result:=SJisToJis(arg_Stream);
end;
{
-----------------------------------------------------------------------------
  名前 : func_TStrListToStrm;
  引数 :
  arg_TStringList:TStringList
  機能 : TStringListよりストリームを作成する
  復帰値：TStringStream nil失敗
-----------------------------------------------------------------------------
}
///// SJISコードをJISコードに変換 - 1文字
function func_MakeSJIS: String;
var
  b0,b1: byte;
  w_s:string;
//  w_i:integer;
//  w_l:integer;
//  c0,c1: AnsiChar
begin
  w_s := '';

  for b0:=byte(#$20) to byte(#$7E) do
  begin
    w_s := w_s+AnsiChar(b0) ;
  end;
  w_s := w_s + #13#10;
  for b0:=byte(#$81) to byte(#$9F) do
  begin
    for b1:=byte(#$40) to byte(#$7E) do
    begin
     w_s := w_s+AnsiChar(b0) + AnsiChar(b1);
    end;
    w_s := w_s + #13#10;
  end;
  for b0:=byte(#$81) to byte(#$9F) do
  begin
    for b1:=byte(#$80) to byte(#$FC) do
    begin
     w_s := w_s+AnsiChar(b0) + AnsiChar(b1);
    end;
    w_s := w_s + #13#10;
  end;
  for b0:=byte(#$E0) to byte(#$EF) do
  begin
    for b1:=byte(#$40) to byte(#$7E) do
    begin
     w_s := w_s+AnsiChar(b0) + AnsiChar(b1);
    end;
    w_s := w_s + #13#10;
  end;
  for b0:=byte(#$E0) to byte(#$EF) do
  begin
    for b1:=byte(#$80) to byte(#$FC) do
    begin
     w_s := w_s+AnsiChar(b0) + AnsiChar(b1);
    end;
    w_s := w_s + #13#10;
  end;

  Result := w_s;
end;
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
                           arg_Def);
   if not(func_IsNullStr(w_string)) then
   begin
     result := w_string;
   end
   else
   begin
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
                           arg_Def);
   if not(func_IsNullStr(w_string)) then
   begin
     result := StrToIntDef(w_string,0);
   end
   else
   begin
     result := StrToIntDef(arg_Def,0);
   end;

end;

(**
●機能クライアント情報部分の読込み
引数：
  arg_Ini : TIniFile;
  arg_No:string
例外：無し
復帰値：
**)
function func_ReadiniCInfo(
                           arg_Ini : TIniFile;
                           arg_No:string
                           ): TClint_Info;
begin
      result.f_Socket_Info.f_Active :=
            func_IniReadString(
                               arg_Ini,
                               g_C_SOCKET_SECSION + arg_No,
                               g_SOCKET_ACTIVE_KEY,
                               g_SOCKET_DEACTIVE);
      result.f_Socket_Info.f_EmuVisible :=
            func_IniReadString(
                               arg_Ini,
                               g_C_SOCKET_SECSION + arg_No,
                               g_SOCKET_EMUVISIBLE_KEY,
                               g_SOCKET_EMUVISIBLE_FALSE);
      result.f_Socket_Info.f_EmuEnabled :=
            func_IniReadString(
                               arg_Ini,
                               g_C_SOCKET_SECSION + arg_No,
                               g_SOCKET_EMUENABLED_KEY,
                               g_SOCKET_EMUENABLED_FALSE);
      result.f_Socket_Info.f_CharCode :=
            func_IniReadString(
                               arg_Ini,
                               g_C_SOCKET_SECSION + arg_No,
                               g_SOCKET_CHARCODE_KEY,
                               g_SOCKET_CHARCODE_SJIS);

      result.f_TimeOut :=
            func_IniReadInt(
                               arg_Ini,
                               g_C_SOCKET_SECSION + arg_No,
                               g_SOCKET_TOUT_KEY,
                               g_SOCKET_TOUT);

      result.f_Timer :=
            func_IniReadInt(
                               arg_Ini,
                               g_C_SOCKET_SECSION + arg_No,
                               g_SOCKET_TIMER_KEY,
                               g_SOCKET_TIMER)*1000;

      result.f_IPAdrr :=
            func_IniReadString(
                               arg_Ini,
                               g_C_SOCKET_SECSION + arg_No,
                               g_SOCKET_SIP_KEY,
                               g_SOCKET_SIP);
      result.f_Port :=
            func_IniReadString(
                               arg_Ini,
                               g_C_SOCKET_SECSION + arg_No,
                               g_SOCKET_SPORT_KEY,
                               g_SOCKET_SPORT);
end;
(**
●機能サーバ情報部分の読込み
引数：
  arg_Ini : TIniFile;
  arg_No:string
例外：無し
復帰値：
**)
function func_ReadiniSInfo(
                           arg_Ini : TIniFile;
                           arg_No:string
                           ): TServer_Info;
begin
      result.f_Socket_Info.f_Active :=
            func_IniReadString(
                               arg_Ini,
                               g_S_SOCKET_SECSION + arg_No,
                               g_SOCKET_ACTIVE_KEY,
                               g_SOCKET_DEACTIVE);
      result.f_Socket_Info.f_EmuVisible :=
            func_IniReadString(
                               arg_Ini,
                               g_S_SOCKET_SECSION + arg_No,
                               g_SOCKET_EMUVISIBLE_KEY,
                               g_SOCKET_EMUVISIBLE_FALSE);
      result.f_Socket_Info.f_EmuEnabled :=
            func_IniReadString(
                               arg_Ini,
                               g_S_SOCKET_SECSION + arg_No,
                               g_SOCKET_EMUENABLED_KEY,
                               g_SOCKET_EMUENABLED_FALSE);
      result.f_Socket_Info.f_CharCode :=
            func_IniReadString(
                               arg_Ini,
                               g_S_SOCKET_SECSION + arg_No,
                               g_SOCKET_CHARCODE_KEY,
                               g_SOCKET_CHARCODE_SJIS);

      result.f_TimeOut :=
            func_IniReadInt(
                               arg_Ini,
                               g_S_SOCKET_SECSION + arg_No,
                               g_SOCKET_TOUT_KEY,
                               g_SOCKET_TOUT);
      result.f_Port :=
            func_IniReadString(
                               arg_Ini,
                               g_S_SOCKET_SECSION + arg_No,
                               g_SOCKET_PORT_KEY,
                               g_SOCKET_PORT);
end;
(**
●機能予約枠コード、検査機器ID対応表情報部分の読込み
引数：
  arg_Ini : TIniFile;
  var arg_kiki:Tkensakiki 予約枠コード、検査機器ID構造体
例外：無し
復帰値：
**)
procedure proc_ReadiniYoyaku(
                           arg_Ini : TIniFile;
                           var arg_kiki:Tkensakiki
                           );
var
  w_StringList:TStrings;
  w_i:Integer;
  w_Pos,w_Pos2:Integer;
begin
  w_StringList := TStringList.Create;
  try

    arg_Ini.ReadSectionValues(g_KIKI_SECSION,w_StringList);

    SetLength(arg_kiki,w_StringList.Count);

    for w_i := 0 to w_StringList.Count - 1 do begin
      w_Pos := Pos(',',w_StringList[w_i]);
      if w_Pos <> 0 then begin
        w_Pos2 := Pos('=',w_StringList[w_i]);
        arg_kiki[w_i].Yoyakuwaku := Copy(w_StringList[w_i],w_Pos2 + 1,w_Pos - 1 - w_Pos2);
        arg_kiki[w_i].Kensakiki  := Copy(w_StringList[w_i],w_Pos + 1,Length(w_StringList[w_i]) - w_Pos);
      end;

    end;
  finally
    if w_StringList <> nil then
      w_StringList.Free;
  end;
end;
(**
●検像緊急フラグ、撮影場所、患者情報情報部分の読込み
引数：
  arg_Ini : TIniFile;
  var arg_Kenzo:TStringList  検像コメントフラグ
      arg_Satuei:TStringList 撮影場所
      arg_Kanja:TStringList  患者情報
例外：無し
復帰値：
**)
procedure proc_ReadiniKenzo(
                           arg_Ini : TIniFile;
                           var arg_Kenzo,arg_Satuei,arg_Kanja:TStrings
                           );
var
  w_i:Integer;
  w_Pos:Integer;
begin
  arg_Kenzo := TStringList.Create;

  arg_Satuei := TStringList.Create;

  arg_Kanja := TStringList.Create;

  arg_Ini.ReadSectionValues(g_KENZO_SECSION,arg_Kenzo);
  arg_Ini.ReadSectionValues(g_SATUEI_SECSION,arg_Satuei);
  arg_Ini.ReadSectionValues(g_KANJA_SECSION,arg_Kanja);
  for w_i := 0 to arg_Kenzo.Count - 1 do begin
    w_Pos := Pos('=',arg_Kenzo[w_i]);
    if w_Pos <> 0 then begin
      arg_Kenzo[w_i] := Copy(arg_Kenzo[w_i],w_Pos + 1,Length(arg_Kenzo[w_i]));
    end;
  end;
  for w_i := 0 to arg_Satuei.Count - 1 do begin
    w_Pos := Pos('=',arg_Satuei[w_i]);
    if w_Pos <> 0 then begin
      arg_Satuei[w_i] := Copy(arg_Satuei[w_i],w_Pos + 1,Length(arg_Satuei[w_i]));
    end;
  end;
  for w_i := 0 to arg_Kanja.Count - 1 do begin
    w_Pos := Pos('=',arg_Kanja[w_i]);
    if w_Pos <> 0 then begin
      arg_Kanja[w_i] := Copy(arg_Kanja[w_i],w_Pos + 1,Length(arg_Kanja[w_i]));
    end;
  end;
end;
(**
●オーダ指示情報部分の読込み
引数：
  arg_Ini : TIniFile
例外：無し
復帰値：
**)
procedure proc_ReadiniOrderIndicate(
                           arg_Ini : TIniFile
                           );
var
  wsl_Data : TStrings;
  w_i:Integer;
  w_Pos:Integer;
begin
  try
    wsl_Data := TStringList.Create;
    //オーダ指示情報セクション読み込み
    arg_Ini.ReadSectionValues(g_ORDERINDICATE_SECSION,wsl_Data);
    //初期化
    SetLength(g_OrderIndicate_Code,0);
    //オーダ指示情報データキー分
    for w_i := 0 to wsl_Data.Count - 1 do begin
      //データキーとデータを分ける
      w_Pos := AnsiPos('=',wsl_Data[w_i]);
      //データキーとデータがある場合
      if w_Pos <> 0 then begin
        //格納場所作成
        SetLength(g_OrderIndicate_Code,w_i + 1);
        //データキー取得
        g_OrderIndicate_Code[w_i].DATAKEY := Copy(wsl_Data[w_i],1,w_Pos - 1);
        //作成
        g_OrderIndicate_Code[w_i].DATA := TStringList.Create;
        //データ設定
        g_OrderIndicate_Code[w_i].DATA.CommaText := Copy(wsl_Data[w_i],w_Pos + 1,Length(wsl_Data[w_i]));
      end;
    end;
  finally
    if wsl_Data <> nil then
      FreeAndNil(wsl_Data);
  end;
end;
(**
●XML情報部分の読込み
引数：
  arg_Ini : TIniFile
例外：無し
復帰値：
**)
procedure proc_ReadiniXML(
                          arg_Ini : TIniFile
                          );
var
  wsl_Data : TStrings;
  w_i:Integer;
  w_Pos:Integer;
begin
  try
    wsl_Data := TStringList.Create;
    //XML情報セクション読み込み
    arg_Ini.ReadSectionValues(g_XML_SECSION,wsl_Data);
    //初期化
    SetLength(g_XML_Code,0);
    //XML情報データキー分
    for w_i := 0 to wsl_Data.Count - 1 do begin
      //データキーとデータを分ける
      w_Pos := AnsiPos('=',wsl_Data[w_i]);
      //データキーとデータがある場合
      if w_Pos <> 0 then begin
        //格納場所作成
        SetLength(g_XML_Code,w_i + 1);
        //データキー取得
        g_XML_Code[w_i].XML_CHR := Copy(wsl_Data[w_i],1,w_Pos - 1);
        //データ設定
        g_XML_Code[w_i].RIS_CHR := Copy(wsl_Data[w_i],w_Pos + 1,Length(wsl_Data[w_i]));
      end;
    end;
  finally
    if wsl_Data <> nil then
      FreeAndNil(wsl_Data);
  end;
end;
(**
●ダミーコード情報部分の読込み
引数：
  arg_Ini : TIniFile
例外：無し
復帰値：
**)
procedure proc_ReadiniDummy_Code(
                          arg_Ini : TIniFile
                          );
var
  wsl_Data  : TStrings;
  wsl_Data2 : TStrings;
  w_i:Integer;
  w_Pos:Integer;
begin
  try
    wsl_Data := TStringList.Create;
    wsl_Data2 := TStringList.Create;
    //方向情報セクション読み込み
    arg_Ini.ReadSectionValues(g_HOUKOU_SECSION,wsl_Data);
    //方法情報セクション読み込み
    arg_Ini.ReadSectionValues(g_HOUHOU_SECSION,wsl_Data2);
    //初期化
    SetLength(g_HOUKOU_Code,0);
    //初期化
    SetLength(g_HOUHOU_Code,0);
    //方向情報データキー分
    for w_i := 0 to wsl_Data.Count - 1 do begin
      //データキーとデータを分ける
      w_Pos := AnsiPos('=',wsl_Data[w_i]);
      //データキーとデータがある場合
      if w_Pos <> 0 then begin
        //格納場所作成
        SetLength(g_HOUKOU_Code,w_i + 1);
        //データキー取得
        g_HOUKOU_Code[w_i].KENSA_TYPE := Copy(wsl_Data[w_i],1,w_Pos - 1);
        //データ設定
        g_HOUKOU_Code[w_i].DUMMY_CODE := Copy(wsl_Data[w_i],w_Pos + 1,Length(wsl_Data[w_i]));
      end;
    end;
    //方法情報データキー分
    for w_i := 0 to wsl_Data2.Count - 1 do begin
      //データキーとデータを分ける
      w_Pos := AnsiPos('=',wsl_Data2[w_i]);
      //データキーとデータがある場合
      if w_Pos <> 0 then begin
        //格納場所作成
        SetLength(g_HOUHOU_Code,w_i + 1);
        //データキー取得
        g_HOUHOU_Code[w_i].KENSA_TYPE := Copy(wsl_Data2[w_i],1,w_Pos - 1);
        //データ設定
        g_HOUHOU_Code[w_i].DUMMY_CODE := Copy(wsl_Data2[w_i],w_Pos + 1,Length(wsl_Data2[w_i]));
      end;
    end;
  finally
    if wsl_Data <> nil then
      FreeAndNil(wsl_Data);
    if wsl_Data2 <> nil then
      FreeAndNil(wsl_Data2);
  end;
end;
(**
●患者プロファイル情報部分の読込み
引数：
  arg_Ini : TIniFile
例外：無し
復帰値：
**)
procedure proc_ReadiniKanjaProf(
                           arg_Ini : TIniFile
                           );
var
  wsl_Data : TStrings;
  wsl_Data2 : TStrings;
  w_i:Integer;
  w_Pos:Integer;
begin
  try
    wsl_Data := TStringList.Create;
    wsl_Data2 := TStringList.Create;
    //患者プロファイル情報セクション読み込み
    arg_Ini.ReadSectionValues(g_KANJAPROF_SECSION,wsl_Data);
    //患者プロファイルコード情報セクション読み込み
    arg_Ini.ReadSectionValues(g_KANJAPROFCODE_SECSION,wsl_Data2);
    //初期化
    SetLength(g_KanjaProf_Code,0);
    SetLength(g_KanjaProfCode_Code,0);
    //患者プロファイル情報データキー分
    for w_i := 0 to wsl_Data.Count - 1 do begin
      //データキーとデータを分ける
      w_Pos := AnsiPos('=',wsl_Data[w_i]);
      //データキーとデータがある場合
      if w_Pos <> 0 then begin
        //格納場所作成
        SetLength(g_KanjaProf_Code,w_i + 1);
        //データキー取得
        g_KanjaProf_Code[w_i].DATAKEY := Copy(wsl_Data[w_i],1,w_Pos - 1);
        //作成
        g_KanjaProf_Code[w_i].DATA := TStringList.Create;
        //データ設定
        g_KanjaProf_Code[w_i].DATA.CommaText := Copy(wsl_Data[w_i],w_Pos + 1,Length(wsl_Data[w_i]));
      end;
    end;
    //患者プロファイル情報データキー分
    for w_i := 0 to wsl_Data2.Count - 1 do begin
      //データキーとデータを分ける
      w_Pos := AnsiPos('=',wsl_Data2[w_i]);
      //データキーとデータがある場合
      if w_Pos <> 0 then begin
        //格納場所作成
        SetLength(g_KanjaProfCode_Code,w_i + 1);
        //データキー取得
        g_KanjaProfCode_Code[w_i].DATAKEY := Copy(wsl_Data2[w_i],1,w_Pos - 1);
        //作成
        g_KanjaProfCode_Code[w_i].DATA := TStringList.Create;
        //データ設定
        g_KanjaProfCode_Code[w_i].DATA.CommaText := Copy(wsl_Data2[w_i],w_Pos + 1,Length(wsl_Data2[w_i]));
      end;
    end;
  finally
    if wsl_Data <> nil then
      FreeAndNil(wsl_Data);
    if wsl_Data2 <> nil then
      FreeAndNil(wsl_Data2);
  end;
end;
(** 2004.03.24
●オラクルエラー情報部分の読込み
引数：
  arg_Ini : TIniFile;
  var arg_OraErr:TStringList オラクルエラー番号
例外：無し
復帰値：
**)
procedure proc_ReadiniOraErr(arg_Ini : TIniFile;var arg_OraErr:TStrings);
begin
  //初期化
  arg_OraErr := TStringList.Create;
  //オラクルエラー番号セクション情報読み込み
  arg_OraErr.CommaText := func_IniReadString(
                               arg_Ini,
                               g_ORAERR_SECSION,
                               g_ORAERR_KEY,
                               g_DEFORAERR);
end;
//●機能 INIファイルの読込み
//引数：無し
//例外：無し
//復帰値：True False
function func_TcpReadiniFile: Boolean;
var
  w_ini,w_ini_B: TIniFile;
begin
  Result:=True;
  try
    if not FileExists(g_TcpIniPath + G_TCPINI_FNAME) then begin
      Result := False;
      Exit;
    end;
    //カタカナ→ローマ字変換初期化
    func_Kana_To_Roma_s(0);
    w_ini:=TIniFile.Create(g_TcpIniPath + G_TCPINI_FNAME);
    w_ini_B:=TIniFile.Create(g_TcpIniPath + G_BACKINI_FNAME);
    try
      //SERVICE情報
      g_Svc_Sd_Acvite :=
            func_IniReadString(
                               w_ini,
                               g_C_SVC_SECSION,
                               g_SVC_SDACTIVE_KEY,
                               g_SVC_ACTIVE);
      g_Svc_Sd_Cycle :=
            func_IniReadInt(
                               w_ini,
                               g_C_SVC_SECSION,
                               g_SVC_SDCYCLE_KEY,
                               g_SVC_SDCYCLE);
      g_Svc_Rv_Acvite :=
            func_IniReadString(
                               w_ini,
                               g_C_SVC_SECSION,
                               g_SVC_RVACTIVE_KEY,
                               g_SVC_ACTIVE);
      g_Svc_Rv_Cycle :=
            func_IniReadInt(
                               w_ini,
                               g_C_SVC_SECSION,
                               g_SVC_RVCYCLE_KEY,
                               g_SVC_RVCYCLE);

      //DB情報
      g_RisDB_Name :=
            func_IniReadString(
                               w_ini,
                               g_C_DB_SECSION,
                               g_DB_NAME_KEY,
                               g_DB_NAME);
      g_RisDB_Uid :=
            func_IniReadString(
                               w_ini,
                               g_C_DB_SECSION,
                               g_DB_UID_KEY,
                               g_DB_UID);
      g_RisDB_Pas :=
            func_IniReadString(
                               w_ini,
                               g_C_DB_SECSION,
                               g_DB_PAS_KEY,
                               g_DB_PAS);
      g_RisDB_DpendSrvName :=
            func_IniReadString(
                               w_ini,
                               g_C_DB_SECSION,
                               g_DB_SERVICE_KEY,
                               g_DB_SERVICE);
      g_RisDB_Retry :=
            func_IniReadInt(
                               w_ini,
                               g_C_DB_SECSION,
                               g_DB_RETRY_KEY,
                               g_DB_RETRY);
      g_RisDB_SndKeep :=
            func_IniReadInt(
                               w_ini,
                               g_C_DB_SECSION,
                               g_DB_SNDKEEP_KEY,
                               g_DB_SNDKEEP);
      g_RisDB_RcvKeep :=
            func_IniReadInt(
                               w_ini,
                               g_C_DB_SECSION,
                               g_DB_RCVKEEP_KEY,
                               g_DB_RCVKEEP);
      //ソケット情報
      g_C_Socket_Info_01:=func_ReadiniCInfo(w_ini,'1');
      g_C_Socket_Info_02:=func_ReadiniCInfo(w_ini,'2');
      g_C_Socket_Info_03:=func_ReadiniCInfo(w_ini,'3');
      g_C_Socket_Info_04:=func_ReadiniCInfo(w_ini,'4');
      g_C_Socket_Info_05:=func_ReadiniCInfo(w_ini,'5');
      g_C_Socket_Info_06:=func_ReadiniCInfo(w_ini,'6');
      g_S_Socket_Info_01:=func_ReadiniSInfo(w_ini,'1');
      g_S_Socket_Info_02:=func_ReadiniSInfo(w_ini,'2');
      g_S_Socket_Info_03:=func_ReadiniSInfo(w_ini,'3');
      g_S_Socket_Info_04:=func_ReadiniSInfo(w_ini,'4');
      g_S_Socket_Info_05:=func_ReadiniSInfo(w_ini,'5');
      g_S_Socket_Info_06:=func_ReadiniSInfo(w_ini,'6');
      //LOG情報
      g_Rig_LogActive :=
            func_IniReadString(
                               w_ini,
                               g_LOG_SECSION,
                               g_SOCKET_LOGACTIVE_KEY,
                               g_SOCKET_LOGDEACTIVE);
      g_Rig_LogPath :=
            func_IniReadString(
                               w_ini,
                               g_LOG_SECSION,
                               g_SOCKET_LOGPATH_KEY,
                               g_SOCKET_LOGPATH);
      //INIファイルと同じ場所
      if not(DirectoryExists(g_Rig_LogPath)) then
         g_Rig_LogPath := g_TcpIniPath;
      g_Rig_LogSize :=
            func_IniReadString(
                               w_ini,
                               g_LOG_SECSION,
                               g_SOCKET_LOGSIZE_KEY,
                               g_SOCKET_LOGSIZE);
      g_Rig_LogKeep :=
            func_IniReadInt(
                               w_ini,
                               g_LOG_SECSION,
                               g_SOCKET_LOGKEEP_KEY,
                               g_SOCKET_LOGKEEP);
      g_Rig_LogIncMsg :=
            func_IniReadString(
                               w_ini,
                               g_LOG_SECSION,
                               g_SOCKET_LOGINCMSG_KEY,
                               g_SOCKET_LOGINCMSG);
      g_Rig_LogLevel :=
            func_IniReadString(
                               w_ini,
                               g_LOG_SECSION,
                               g_SOCKET_LOGLEVEL_KEY,
                               g_SOCKET_LOGLEVEL);
      g_Name_Kansen01 :=
            func_IniReadString(
                               w_ini,
                               g_NAME_SECSION,
                               g_KANSEN_NAME01_KEY,
                               g_KANSEN_NAME01);
      g_Prof01 :=
            func_IniReadString(
                               w_ini,
                               g_PROF_SECSION,
                               g_PROF01_KEY,
                               g_DEFPROF01);
      g_Prof02 :=
            func_IniReadString(
                               w_ini,
                               g_PROF_SECSION,
                               g_PROF02_KEY,
                               g_DEFPROF02);
      g_Schema_Main :=
            func_IniReadString(
                               w_ini,
                               g_SCHE_SECSION,
                               g_SCHEMAIN_KEY,
                               g_DEFMAIN);
      g_Schema_Sub :=
            func_IniReadString(
                               w_ini,
                               g_SCHE_SECSION,
                               g_SCHESUB_KEY,
                               g_DEFSUB);
      g_Schema_Del :=
            func_IniReadString(
                               w_ini,
                               g_SCHE_SECSION,
                               g_SCHEDEL_KEY,
                               g_DEFDELSUB);

      g_Svr_Main :=
            func_IniReadString(
                               w_ini_B,
                               g_PATH_SECSION,
                               g_PATHMAIN_KEY,
                               g_DEFMAINPATH);
      g_Svr_Back :=
            func_IniReadString(
                               w_ini_B,
                               g_PATH_SECSION,
                               g_PATHSUB_KEY,
                               g_DEFSUBPATH);
      g_Save_Active :=
            func_IniReadString(
                               w_ini_B,
                               g_ACTIVE_SECSION,
                               g_PATHACTIVE_KEY,
                               g_DEFACTIVE);
      proc_ReadiniYoyaku(w_ini,g_Kikitaiou);

      proc_ReadiniKenzo(w_ini,g_Kenzo,g_Satuei,g_KanjaJyoutai);

      proc_ReadiniOrderIndicate(w_ini);

      proc_ReadiniXML(w_ini);

      proc_ReadiniDummy_Code(w_ini);

      g_OrderIndicate_Up :=
            func_IniReadString(
                               w_ini,
                               g_ORDERINDICATE_SECSION,
                               g_ORDERINDICATE_KEY,
                               g_DEFORDERINDICATE);

      proc_ReadiniKanjaProf(w_ini);
      //2004.03.24
      proc_ReadiniOraErr(w_ini,g_OraErrNo);
    finally
      w_ini.Free;
      w_ini_B.Free;
    end;
  exit;
  except
    Result:=False;
    exit;
  end;

end;
//-----------------------------------------------------------------------------
//1.ログ出力関数系
//-----------------------------------------------------------------------------

{
-----------------------------------------------------------------------------
  名前 : proc_LogOperate(Operate);
  引数 :
   arg_Status: string; 'NG'異常 'OK'正常 '  'その他
   arg_Time:string;    '2001/10/10 15:00:00' ''マシン時間
   arg_Operate:string  ログ内容

   Operate: string : 内容
  機能 : ログファイルに文字列を記録する。下層部
  例外はすべて無視するのでなし
-----------------------------------------------------------------------------
}
procedure proc_LogOperate(
   arg_Status: string;
   arg_Time:string;
   arg_Operate:string
   );
var
  w_LogFile :string;
  w_LogFileBak1: string;
  w_LogFileBak2: string;
  buffer: string;
  hd, Size,w_i: Integer;
  fp: TextFile;
begin
  // ログが無効の場合は、何もしない。
  //if g_Rig_LogActive<>g_SOCKET_LOGACTIVE then Exit;
//****//2002.01.30
  if g_Rig_LogActive=g_SOCKET_LOGDEACTIVE then Exit;
  if (g_Rig_LogActive=g_SOCKET_LOGACTIVE2)
  and
     (arg_Status<>G_LOG_LINE_HEAD_NG)
  then Exit;
//****//2002.01.30
try
  w_LogFile:=g_Rig_LogPath + g_LogPlefix + '0' + G_LOG_PKT_PTH_DEF;
  //時刻の補完
  if func_IsNullStr(arg_Time) then
    arg_Time:=FormatDateTime('yyyy/mm/dd hh:mm:ss', Now);
  //出力メッセージ構成
  buffer := arg_Status + ',' + arg_Time + ',' + arg_Operate;

  if FileExists(w_LogFile) then
  begin
    // ログのサイズを確認する。
    hd:=FileOpen(w_LogFile, fmOpenRead or fmShareDenyWrite);
    Size:=GetFileSize(hd, nil);
    FileClose(hd);
    Size:= Size+ length(AnsiString(buffer));
    if Size >= StrToIntDef(g_Rig_LogSize,65536) then
    begin
      // 一定サイズを超えた場合は、バックアップをとる。
      for w_i := (g_Rig_LogKeep-2)    downto 0  do
      begin
        w_LogFileBak1:=g_Rig_LogPath + g_LogPlefix + IntToStr(w_i) + G_LOG_PKT_PTH_DEF;
        if FileExists(w_LogFileBak1) then
        begin
          w_LogFileBak2:=g_Rig_LogPath + g_LogPlefix + IntToStr(w_i+1) + G_LOG_PKT_PTH_DEF;
          if FileExists(w_LogFileBak2) then
          begin
             DeleteFile(w_LogFileBak2);
          end;
          RenameFile(w_LogFileBak1, w_LogFileBak2);
        end;
      end;
      AssignFile(fp, w_LogFile);
      try
        Rewrite(fp);
        Writeln(fp, buffer);
      finally
        CloseFile(fp);
      end;
    end
    else
    begin
      // 既存のログに追記する。
      AssignFile(fp, w_LogFile);
      try
        Append(fp);
        Writeln(fp, buffer);
      finally
        CloseFile(fp);
      end;
    end;
  end
  else
  begin
    // 新規にログを作成する。
    AssignFile(fp, w_LogFile);
    try
     Rewrite(fp);
     Writeln(fp, buffer);
    finally
     CloseFile(fp);
    end;
  end;
except
  exit;
end;
end;
//ログ文字列作成
function  func_LogStr(arg_Kind:integer; arg_Diteil:string): string;
var
 w_s:string;
begin
 w_s := g_Log_Type[arg_Kind].f_LogMsg + StringOfChar(chr($20),G_LOGGMSG_LEN);
 w_s := func_BCopy(w_s,G_LOGGMSG_LEN);
 result := w_s + '（' + arg_Diteil +'）' ;
end;
{
-----------------------------------------------------------------------------
  名前 : proc_LogOut(arg_Kind:string; arg_Diteil:string);
  引数 :
   arg_Status  : 'NG'異常 'OK'正常 '  'その他
   arg_Time    : '2001/10/10 15:00:00' ''マシン時間
   arg_Kind    : ログ内容種別
   arg_Diteil  : ログ内容詳細
  機能 : Userにログ出力機能を提供する
  例外はすべて無視するのでなし
-----------------------------------------------------------------------------
}
procedure proc_LogOut(
     arg_Status: string;
     arg_Time:string;
     arg_Kind:integer;
     arg_Diteil:string);
var
 w_s:string;
begin
 try
  w_s := func_LogStr(arg_Kind,arg_Diteil);
  if (g_Log_Type[arg_Kind].f_LogLevel <= StrToIntDef(g_Rig_LogLevel,0)) then
  begin
    proc_LogOperate(arg_Status,arg_Time,w_s);
  end;
 except
  exit;
 end;
end;
//-----------------------------------------------------------------------------
//6.その他系
//-----------------------------------------------------------------------------
//カンマ区切りで結合する
procedure  proc_StrConcat(
           var arg_LogBase   : string;
           arg_Log           : string
           );
begin
  if arg_Log='' then exit;
  if (arg_LogBase='') then
  begin
    arg_LogBase := arg_Log;
  end
  else
  begin
    arg_LogBase := arg_LogBase + ',' + arg_Log;
  end;
end;
function func_IsNumberStr(arg_str1:string): BOOlean;
begin
  result:=func_IsInstr(arg_str1,'0123456789');
end;

//2001.12.27
//全角ブランクの両側トリム
function func_MBTrim(arg_str:string) : string;
var
  w_s:string;
begin
  w_s := arg_str;
  w_s:=func_MBTrimLeft(w_s);
  w_s:=func_MBTrimRight(w_s);
  result := w_s;
end;
//全角ブランクの右側トリム
function func_MBTrimRight(arg_str:string): string;
var
  w_s:string;
  w_ZBLK :string;
begin
  w_ZBLK:='　';
  w_s := arg_str;
  w_s := TrimRight(w_s);
  while  (Length(w_s)>1)
     and (w_s[Length(w_s)] = w_ZBLK[2])
     and (w_s[Length(w_s)-1] = w_ZBLK[1]) do
  begin
    Delete(w_s, Length(w_s), 1);
    Delete(w_s, Length(w_s), 1);
    w_s := TrimRight(w_s);
  end;
  result := w_s;
end;
//全角ブランクの左側トリム
function func_MBTrimLeft(arg_str:string) : string;
var
  w_s:string;
  w_ZBLK :string;
begin
  w_ZBLK:='　';
  w_s := arg_str;
  w_s := TrimLeft(w_s);
  while (Length(w_s)>1)
   and  (w_s[1] = w_ZBLK[1])
   and  (w_s[2] = w_ZBLK[2]) do
  begin
    Delete(w_s, 1, 2);
    w_s := TrimLeft(w_s);
  end;
  result := w_s;
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
    wkBuf := Copy(EditStr,1,intCapa);
  end;
  //戻り値
  Result := wkBuf;
end;
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
  //スペースバイト数
  len := intCapa - Length(EditStr);
  //初期化
  wkBuf := '';
  //範囲内時
  if len > 0 then begin
    //スペースバイト数分の'0'の作成
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

procedure proc_BUp_TxtOut(arg_path,arg_Flg,arg_Data:String;arg_DateTime:TDateTime);
var
  w_Qry:TQuery;
  w_LogPath,w_Log_File:String;
  SearchRec: TSearchRec;
  PathName: string;
  FileNameList:TStrings;
  w_i:Integer;
  wi_Max:Integer;
  TxtFile: TextFile;
begin
  w_Qry := TQuery.Create(nil);
  try
    //電文作成の場合
    if g_Save_Active = CST_SAVE_ON then begin
      //フォルダ名[保管先（iniファイルに定義）\YYYYMMDD]
      w_LogPath := arg_path +  '\' + FormatDateTime('YYYYMMDD',arg_DateTime);
      // フォルダが存在していない場合にはフォルダを用意する。
      wi_Max := 0;
      if (DirectoryExists(w_LogPath)=False) then begin
        if ForceDirectories(w_LogPath) = False then begin
           proc_LogOut(G_LOG_LINE_HEAD_NG,'',G_LOG_KIND_DB_IN_LEVEL,
                   '保存先フォルダが見当たらないためバックアップ用テキスト作成に失敗しました。保存先フォルダ:' + w_LogPath
                   );
          Exit;
        end;
      end
      //ファイルが存在するばあいには００１から連番する
      else begin
        FileNameList:=TStringList.Create;
        FileNameList.Clear;
        try
          SysUtils.FindFirst(w_LogPath+'\*'+'.txt', faAnyFile, SearchRec);
          try
            if SearchRec.Name='' then Exit;
            repeat
              //拡張子を除いた部分だけ抽出できる関数！  EX.Test.txt　→　Test
              PathName:= ChangeFileExt(SearchRec.Name,'');
              if (SearchRec.Name<>'.') and (SearchRec.Name<>'..') then begin
                if arg_Flg = Copy(PathName,1,1) then
                  FileNameList.Add(PathName);
              end;
              until SysUtils.FindNext(SearchRec)<>0;
          finally
            SysUtils.FindClose(SearchRec);
          end;
          //オーダ番号○×××.txt の ×××のMAX値を求める
          for w_i := 0 to FileNameList.Count -1 do begin
            wi_Max := StrToInt(Right(FileNameList[w_i],3));
          end;
          wi_Max := wi_Max +1;
        finally
          FileNameList.Free;
        end;
      end;
      if wi_Max = 0 then
        wi_Max := 1;
      //ログファイル名
      w_Log_File :=  '\' + arg_Flg + FormatDateTime('YYYYMMDDHHMMSS',arg_DateTime) + FormatCurr('000',StrToCurr(IntToStr(wi_Max))) + '.txt';
      if not FileExists(w_LogPath  + w_Log_File) then begin
        try
          AssignFile(TxtFile,w_LogPath + w_Log_File);
          try
            Rewrite(TxtFile);
          except
            //ステータス表示＆ログ出力
            proc_LogOut(G_LOG_LINE_HEAD_NG,'',G_LOG_KIND_SK_CL_LEVEL,'ﾌｧｲﾙ作成エラー　Rewrite');
            Exit;
          end;
        except
          //ステータス表示＆ログ出力
          proc_LogOut(G_LOG_LINE_HEAD_NG,'',G_LOG_KIND_SK_CL_LEVEL,'ﾌｧｲﾙ作成エラー　AssignFile');
          Exit;
        end;
      end;
      try
        try
          Writeln(TxtFile, arg_Data);
        except
          //ステータス表示＆ログ出力
          proc_LogOut(G_LOG_LINE_HEAD_NG,'',G_LOG_KIND_SK_CL_LEVEL,'ﾌｧｲﾙ作成エラー　Writeln');
          Exit;
        end;
      finally
        Flush(TxtFile);
        CloseFile(TxtFile);
      end;
    end;
 finally
   if w_Qry <> nil then begin
     w_Qry.Close;
     w_Qry.Free;
   end;
 end;
end;

function bswap(src : integer) : integer; assembler;
asm
  bswap eax
end;

function bswapf(src : single) : single;
var
  i : integer absolute src;
begin
  i := bswap(i);
  result := src;
end;

procedure ByteOrderSwap(var Src: Double); overload;
var
  Mdp: Array[0..4] of Byte Absolute Src;
  Byt: Byte;
  i: Integer;
begin
  for i:=0 to 1 do begin
    Byt:=Mdp[I];
    Mdp[I]:=Mdp[4-i];
    Mdp[4-i]:=Byt;
  end;
end;
function EndianShort_Short(Value: Short): Short;
begin
  Result := ((Value and $FF00)shr 8) + ((Value and $00FF)shl 8);
end;

function func_Lowerc(arg_string : String):String;
var
  w_i  : Integer;
  w_ii : Integer;
begin
  Result := '';
  for w_i := 0 to 15 do begin
    for w_ii := 0 to 15 do begin
      if arg_string = Chr(StrToInt('$' + ASC2_CODE[w_i] + ASC2_CODE[w_ii])) then begin
        Result := ASC2_CODE[w_i] + ASC2_CODE[w_ii];
        Exit;
      end;
    end;
  end;
end;

function func_Change_XML(arg_string : String):String;
var
  w_i  : Integer;
  w_String : String;
begin
  Result := '';
  w_String := arg_string;
  //変換文字分
  for w_i := 0 to Length(g_XML_Code) - 1 do begin
    //文字列変換
    w_String := StringReplace(w_String,g_XML_Code[w_i].RIS_CHR,g_XML_Code[w_i].XML_CHR,[rfReplaceAll]);
  end;
  Result := w_String;
end;

function func_Change_RIS(arg_string : String):String;
var
  w_i  : Integer;
  w_String : String;
begin
  Result := '';
  w_String := arg_string;
  //変換文字分
  for w_i := 0 to Length(g_XML_Code) - 1 do begin
    if '&' = g_XML_Code[w_i].XML_CHR then
      //文字列変換
      w_String := StringReplace(w_String,g_XML_Code[w_i].XML_CHR,g_XML_Code[w_i].RIS_CHR,[rfReplaceAll]);
  end;
  //変換文字分
  for w_i := 0 to Length(g_XML_Code) - 1 do begin
    if '&' <> g_XML_Code[w_i].XML_CHR then
      //文字列変換
      w_String := StringReplace(w_String,g_XML_Code[w_i].XML_CHR,g_XML_Code[w_i].RIS_CHR,[rfReplaceAll]);
  end;
  Result := w_String;
end;
//2004.03.24
function func_Search_OraErr(arg_Msg : String):String;
var
  w_i  : Integer;
begin
  //初期値（電文エラー）
  Result := GPCST_TENSOU_JOUTAI_02;
  //iniファイルの分
  for w_i := 0 to g_OraErrNo.Count - 1 do begin
    //オラクルエラー情報のコードがある場合
    if AnsiPos(g_OraErrNo.Strings[w_i],arg_Msg) <> 0 then begin
      //Retry要求
      Result := GPCST_TENSOU_JOUTAI_03;
      //処理終了
      Break;
    end;
  end;
end;
//●機能（例外無）：ｺｰﾄﾞを名前に変換登録 手技区分
function func_PIND_Change_SYUGI(
       arg_Code:string    //ｺｰﾄﾞ
       ):string;          //名称
var
   w_Res:string;
begin
  IF arg_Code=GPCST_CODE_SYUGI_0 THEN w_Res:= GPCST_NAME_SYUGI_0
  ELSE
  IF arg_Code=GPCST_CODE_SYUGI_1 THEN w_Res:= GPCST_NAME_SYUGI_1
  ELSE
  IF arg_Code=GPCST_CODE_SYUGI_2 THEN w_Res:= GPCST_NAME_SYUGI_2
{  ELSE
  IF arg_Code=GPCST_CODE_SYUGI_3 THEN w_Res:= GPCST_NAME_SYUGI_3}
  ELSE
  IF arg_Code=GPCST_NAME_SYUGI_0 THEN w_Res:= GPCST_CODE_SYUGI_0
  ELSE
  IF arg_Code=GPCST_NAME_SYUGI_1 THEN w_Res:= GPCST_CODE_SYUGI_1
  ELSE
  IF arg_Code=GPCST_NAME_SYUGI_2 THEN w_Res:= GPCST_CODE_SYUGI_2
//  ELSE
//  IF arg_Code=GPCST_NAME_SYUGI_3 THEN w_Res:= GPCST_CODE_SYUGI_3
  ELSE w_Res:= '';
  result:=w_Res;
end;
//●★使用可★機能（例外有）：現在番号+1取得
function func_Get_NumberControl(
         arg_Database:TDatabase;
         arg_Query:TQuery;
         arg_Kubun:string;
         arg_Date:string
         ):integer;
var
  w_NO: integer;
  w_Date: string;
  w_Sys_Date: string;
  w_Year: string;
begin
  Result := 0;
  w_NO := 0;
  //指定区分なしはエラー
  if arg_Kubun = '' then
    Exit;
  //日付管理ありはシステム日付にする
  if arg_Date <> '' then
    arg_Date := FormatDateTime('YYYY/MM/DD', func_GetDBSysDate(arg_Query));
  //受付№は年度により切り替えるため日付管理にする
  if arg_Kubun = 'UNO' then
    arg_Date := FormatDateTime('YYYY/MM/DD', func_GetDBSysDate(arg_Query));
{2002.11.22
  //受付№は20001～
  if arg_Kubun = 'UNO' then
    w_NO := 20000;
2002.11.22}
  //12番は601～
  if arg_Kubun = 'S12' then
    w_NO := 600;
  //13番は401～
  if arg_Kubun = 'S13' then
    w_NO := 400;
  //15番は101～
  if arg_Kubun = 'S15' then
    w_NO := 100;
  //16番は501～
  if arg_Kubun = 'S16' then
    w_NO := 500;
  //17番は201～
  if arg_Kubun = 'S17' then
    w_NO := 200;
  //19番は301～
  if arg_Kubun = 'S19' then
    w_NO := 300;
  //救急は901～
  if arg_Kubun = 'S99' then
    w_NO := 900;
//番号管理より指定区分の現在番号＋１を求める
  arg_Database.StartTransaction;
  try
    with arg_Query do begin
      Close;
      SQL.Clear;
      SQL.Add ('SELECT ');
      SQL.Add (' nb.* ');
      SQL.Add (' FROM NUMBERCONTROLTABLE nb ');
      SQL.Add (' WHERE nb.KANRI_ID = :PKANRI_ID ');
      SQL.Add (' for update ');
      if not Prepared then Prepare;
      ParamByName('PKANRI_ID').AsString := arg_Kubun;
      //Open;
      //First;
      ExecSQL;
    end;
    with arg_Query do begin
      Close;
      SQL.Clear;
      SQL.Add ('SELECT ');
      SQL.Add (' nb.* ');
      SQL.Add (' FROM NUMBERCONTROLTABLE nb ');
      SQL.Add (' WHERE nb.KANRI_ID = :PKANRI_ID ');
      if not Prepared then Prepare;
      ParamByName('PKANRI_ID').AsString := arg_Kubun;
      Open;
      First;
    end;
//...レコードあり
    if not(arg_Query.Eof) then begin
      //...日付管理なし
      if arg_Date = '' then begin
        if arg_Query.FieldByName('NOW_NO').AsString <> '' then begin
          w_NO := arg_Query.FieldByName('NOW_NO').AsInteger;
          //+1する
          w_NO := w_NO + 1;
        end;
      end
    //...日付管理あり
      else begin
{2002.11.22
        //「受付№」は年度により切り替える
        if arg_Kubun = 'UNO' then begin
          if arg_Query.FieldByName('UPDATEDATE').AsString <> '' then begin
            w_Year := FormatDateTime('YYYY', arg_Query.FieldByName('UPDATEDATE').AsDateTime);
            //年が異なる場合は新たに始める
            if w_Year <> Copy(arg_Date,1,4) then begin
              //+1する
              w_NO := w_NO + 1;
            end
            //年が同じ場合は元に＋１する
            else begin
              w_NO := arg_Query.FieldByName('NOW_NO').AsInteger;
              //+1する
              w_NO := w_NO + 1;
            end;
          end
          else begin
            //+1する
            w_NO := w_NO + 1;
          end;
        end
        //通常
        else begin
          if arg_Query.FieldByName('UPDATEDATE').AsString <> '' then begin
            w_Date := FormatDateTime('YYYY/MM/DD', arg_Query.FieldByName('UPDATEDATE').AsDateTime);
            //日付が異なる場合は新たに始める
            if w_Date <> arg_Date then begin
              //+1する
              w_NO := w_NO + 1;
            end
            //日付が同じ場合は元に＋１する
            else begin
              w_NO := arg_Query.FieldByName('NOW_NO').AsInteger;
              //+1する
              w_NO := w_NO + 1;
            end;
          end
          else begin
            //+1する
            w_NO := w_NO + 1;
          end;
        end;
2002.11.22}
        if arg_Query.FieldByName('UPDATEDATE').AsString <> '' then begin
          w_Date := FormatDateTime('YYYY/MM/DD', arg_Query.FieldByName('UPDATEDATE').AsDateTime);
          //日付が異なる場合は新たに始める
          if w_Date <> arg_Date then begin
            //+1する
            w_NO := w_NO + 1;
          end
          //日付が同じ場合は元に＋１する
          else begin
            w_NO := arg_Query.FieldByName('NOW_NO').AsInteger;
            //+1する
            w_NO := w_NO + 1;
          end;
        end
        else begin
          //+1する
          w_NO := w_NO + 1;
        end;
      end;
      if w_NO <= 0 then begin
        arg_Database.Rollback; // コミットで失敗した場合，変更を取り消す
        Exit;
      end;
      //番号管理テーブル更新
      w_Sys_Date := FormatDateTime('YYYY/MM/DD', func_GetDBSysDate(arg_Query));
      if not func_NumberControl_Update(arg_Database, arg_Query, 2, arg_Kubun, w_Sys_Date, w_NO) then begin
        arg_Database.Rollback; // コミットで失敗した場合，変更を取り消す
        Exit;
      end;
      arg_Database.Commit; // 成功した場合，変更をコミットする
    end
//...レコードなし
    else begin
      //レコードがない場合は新たに始める
      //+1する
      w_NO := w_NO + 1;
      //番号管理テーブル追加
      w_Sys_Date := FormatDateTime('YYYY/MM/DD', func_GetDBSysDate(arg_Query));
      if not func_NumberControl_Update(arg_Database, arg_Query, 1, arg_Kubun, w_Sys_Date, w_NO) then begin
        arg_Database.Rollback; // コミットで失敗した場合，変更を取り消す
        Exit;
      end;
      arg_Database.Commit; // 成功した場合，変更をコミットする
    end;
  except
    on E: Exception do begin
      arg_Database.Rollback; // 失敗した場合，変更を取り消す
      Exit;
    end;
  end;
  //
  Result := w_NO;
end;
//●★使用可★機能（例外有）：現在番号更新
function func_NumberControl_Update(
         arg_Database:TDatabase;
         arg_Query:TQuery;
         arg_Mode:integer;
         arg_Kubun:string;
         arg_UpdateDate:string;
         arg_Now_NO:integer
         ):Boolean;
begin
  Result := False;
  if (arg_Mode <> 1) and  //追加
     (arg_Mode <> 2) then //修正
    Exit;
//更新開始
//  arg_Database.StartTransaction;
  try
{
    with arg_Query do begin
      Close;
      SQL.Clear;
      SQL.Add ('SELECT ');
      SQL.Add (' nb.* ');
      SQL.Add (' FROM NUMBERCONTROLTABLE nb ');
      SQL.Add (' WHERE nb.KANRI_ID = :PKANRI_ID ');
      SQL.Add (' for update ');
      if not Prepared then Prepare;
      ParamByName('PKANRI_ID').AsString := arg_Kubun;
      //Open;
      //First;
      ExecSQL;
    end;
}
    //追加処理
    if arg_Mode = 1 then begin
      with arg_Query do begin
        Close;
        SQL.Clear;
        SQL.Add ('INSERT INTO NUMBERCONTROLTABLE ');
        SQL.Add ('(');
        SQL.Add (' KANRI_ID,');
        SQL.Add (' UPDATEDATE,');
        SQL.Add (' NOW_NO ');
        SQL.Add (') VALUES ( ');
        SQL.Add (' :PKANRI_ID,');
        SQL.Add (' :PUPDATEDATE,');
        SQL.Add (' :PNOW_NO ');
        SQL.Add (')');
        if not Prepared then Prepare;
        ParamByName('PKANRI_ID').AsString := arg_Kubun;
        ParamByName('PUPDATEDATE').AsDate := func_StrToDate(arg_UpdateDate);
        ParamByName('PNOW_NO').AsInteger  := arg_Now_NO;
        ExecSQL;
      end;
    end
    //修正処理
    else begin
      with arg_Query do begin
        Close;
        SQL.Clear;
        SQL.Add('UPDATE NUMBERCONTROLTABLE SET ');
        SQL.Add(' UPDATEDATE = :PUPDATEDATE ');
        SQL.Add(',NOW_NO = :PNOW_NO ');
        SQL.Add('WHERE ');
        SQL.Add(' KANRI_ID = :PKEYCODE ');
        if not Prepared then Prepare;
        ParamByName('PUPDATEDATE').AsDate := func_StrToDate(arg_UpdateDate);
        ParamByName('PNOW_NO').AsInteger  := arg_Now_NO;
        //キー
        ParamByName('PKEYCODE').AsString  := arg_Kubun;
        ExecSQL;
      end;
    end;
{
    try
      arg_Database.Commit; // 成功した場合，変更をコミットする
    except
      on E: Exception do begin
        arg_Database.Rollback; // コミットで失敗した場合，変更を取り消す
        Exit;
      end;
    end;
}
  except
    on E:Exception do begin
//      arg_Database.Rollback; // コミットで失敗した場合，変更を取り消す
      Exit;
    end;
    on E: Exception do begin
//      arg_Database.Rollback; // 失敗した場合，変更を取り消す
      Exit;
    end;
  end;
//正常
  Result := True;
end;
//番号管理テーブル現在番号編集↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑
//●機能（例外無）：シェーマ格納ファイル名作成
function func_Make_ShemaName(arg_OrderNO,               //オーダNO
                             arg_MotoFileName: string;  //HISｼｪｰﾏ名
                             arg_Index: integer         //部位NO
                             ):string;                  //格納ﾌｧｲﾙ名
var
  w_P: integer;
  w_Kakuchosi: string;
  w_i:Integer;
begin
  Result := '';
  if arg_MotoFileName = '' then
    Exit;
  //if arg_Index = 0 then
  //  Exit;
  //2003.02.17
  w_P := 0;
  //HISｼｪｰﾏ名より拡張子位置取得
  for w_i := Length(arg_MotoFileName) downto 1 do begin
    if Copy(arg_MotoFileName,w_i,1) = '.' then begin
      w_P := w_i;
      Break;
    end;
  end;
  //HISｼｪｰﾏ名より拡張子位置取得
  //w_P := Pos('.',arg_MotoFileName);
  if w_P <= 0 then
    Exit;

  w_Kakuchosi := Copy(arg_MotoFileName,w_P,Length(arg_MotoFileName)-w_P+1);

  //格納ﾌｧｲﾙ名作成（ﾌｧｲﾙ名="ｵｰﾀﾞNO_ｼｪｰﾏ部位NO.HISｼｪｰﾏ拡張子"）
  Result := arg_OrderNO + '_' + FormatFloat('00',arg_Index) + w_Kakuchosi;
end;

//-----------------------------------------------------------------------------
initialization
begin

//1)起動PASSを確定
     g_TcpIniPath := ExtractFilePath( ParamStr(0) );
//コマンドEXEファイル名
     g_Exe_FName  := ExtractFileName( ParamStr(0) );
//コマンドEXEファイル名プレフィックス
     g_Exe_Name   := ChangeFileExt( g_Exe_FName, '' );
//LOGプレフィックスを実行ファイル名にする
     g_LogPlefix  := g_Exe_Name + '_';
//LOG TYPE を設定
     g_Log_Type[G_LOG_KIND_SVC_NUM].f_LogMsg   := G_LOG_KIND_SVC;
     g_Log_Type[G_LOG_KIND_SVC_NUM].f_LogLevel := G_LOG_KIND_SVC_LEVEL;

     g_Log_Type[G_LOG_KIND_SK_SV_NUM].f_LogMsg   := G_LOG_KIND_SK_SV;
     g_Log_Type[G_LOG_KIND_SK_SV_NUM].f_LogLevel := G_LOG_KIND_SK_SV_LEVEL;

     g_Log_Type[G_LOG_KIND_SK_CL_NUM].f_LogMsg   := G_LOG_KIND_SK_CL;
     g_Log_Type[G_LOG_KIND_SK_CL_NUM].f_LogLevel := G_LOG_KIND_SK_CL_LEVEL;

     g_Log_Type[G_LOG_KIND_DB_NUM].f_LogMsg   := G_LOG_KIND_DB;
     g_Log_Type[G_LOG_KIND_DB_NUM].f_LogLevel := G_LOG_KIND_DB_LEVEL;

     g_Log_Type[G_LOG_KIND_DB_IN_NUM].f_LogMsg   := G_LOG_KIND_DB_IN;
     g_Log_Type[G_LOG_KIND_DB_IN_NUM].f_LogLevel := G_LOG_KIND_DB_IN_LEVEL;

     g_Log_Type[G_LOG_KIND_DB_OUT_NUM].f_LogMsg   := G_LOG_KIND_DB_OUT;
     g_Log_Type[G_LOG_KIND_DB_OUT_NUM].f_LogLevel := G_LOG_KIND_DB_OUT_LEVEL;

     g_Log_Type[G_LOG_KIND_MS_ANLZ_NUM].f_LogMsg   := G_LOG_KIND_MS_ANLZ;
     g_Log_Type[G_LOG_KIND_MS_ANLZ_NUM].f_LogLevel := G_LOG_KIND_MS_ANLZ_LEVEL;

end;

finalization
begin
//
end;

end.


