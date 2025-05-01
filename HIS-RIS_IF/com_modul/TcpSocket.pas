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
  //2003.06.06
  新たなサービス作成するとき検索
修正：2003.07.04：増田
　　　　　　　　　患者プロファイルに感染症項目追加
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
  IdWinsock2,
  IdGlobal,
//プロダクト開発共通－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－
  Gval,
  jis2sjis,
  HisMsgDef,
  HisMsgDef01_IRAI,
  HisMsgDef02_JISSI,
  HisMsgDef03_CANCEL,
  HisMsgDef04_KANJA_Kekka,
  HisMsgDef05_KAIKEI,
  HisMsgDef06_RCE,
  Unit_DB
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
    f_Retry         : Integer;    //タイマー
  end;
//HIS検査種別変換
type
  THIS_Type = record
    f_HIS_ID : String; //HIS伝票コード
    f_RIS_ID : String; //RIS検査種別
  end;
type TKensa_Type = array of THIS_Type;

//ログ種別定義情報
const
  G_LOGGMSG_LEN = 22;
type
  TLog_Type = record
    f_LogMsg   : string[G_LOGGMSG_LEN];
    f_LogLevel : integer; //
  end;
//定数宣言-------------------------------------------------------------------
//INIファイル情報定義---------------------------------------------------------
const
 G_TCPINI_FNAME = 'ris_tcp.ini';
 G_RTTCPINI_FNAME = 'rtris_tcp.ini';
 //セクション：SERVICE情報
 g_C_SVC_SECSION        = 'SERVICE' ;
   g_SVC_RESDACTIVE_KEY = 'resdactive';//キー
   g_SVC_ORRVACTIVE_KEY = 'orrvactive';//キー
   g_SVC_EXSDACTIVE_KEY = 'exsdactive';//キー
   g_SVC_SHEMAACTIVE_KEY = 'Shemaactive';//キー
     g_SVC_ACTIVE       = '1';//
     g_SVC_DEACTIVE     = '0';//
   (*
   g_SVC_KARVACTIVE_KEY = 'karvactive';//キー
   g_SVC_RSSDACTIVE_KEY = 'rssdactive';//キー
   *)
   g_SVC_RESDCYCLE_KEY  = 'resdcycle';//キー
   g_SVC_EXSDCYCLE_KEY  = 'exsdcycle';//キー
     g_SVC_SDCYCLE      = '10';//
   g_SVC_ORRVCYCLE_KEY  = 'orrvcycle';//キー
   (*
   g_SVC_RSSDCYCLE_KEY  = 'rssdcycle';//キー
   g_SVC_KARVCYCLE_KEY  = 'karvcycle';//キー
   *)
   g_SVC_SHEMACYCLE_KEY  = 'Shemacycle';//キー
     g_SVC_RVCYCLE      = '10';//
 //セクション：RIS DB接続情報
 g_C_DB_SECSION     = 'DBINF';
   //診断
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
   g_DB_SNDKEEP_KEY = 'resndkeep';//キー
   g_DB_SNDEXKEEP_KEY = 'exsndkeep';//キー
   g_DB_SNDRSKEEP_KEY = 'rssndkeep';//キー
   g_DB_SNDREKEEP_KEY = 'resndkeep';//キー
     g_DB_SNDKEEP   = '30';//
   g_DB_RCVKEEP_KEY = 'orrcvkeep';//キー
   g_DB_RCVKAKEEP_KEY = 'karcvkeep';//キー
   g_DB_SHEMAKEEP_KEY = 'Shemakeep';//キー
     g_DB_RCVKEEP   = '30';//
   //所見
   g_REDB_NAME_KEY    = 'Redbname';//キー
     g_REDB_NAME      = 'ris_sv';//
   g_REDB_UID_KEY     = 'Redbuid';//キー
     g_REDB_UID       = 'ris';//
   g_REDB_PAS_KEY     = 'Redbpss';//キー
     g_REDB_PAS       = 'ris';//
(*
   //治療
   g_RTDB_NAME_KEY    = 'RTdbname';//キー
     g_RTDB_NAME      = 'ris_sv';//
   g_RTDB_UID_KEY     = 'RTdbuid';//キー
     g_RTDB_UID       = 'ris';//
   g_RTDB_PAS_KEY     = 'RTdbpss';//キー
     g_RTDB_PAS       = 'ris';//
*)
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
   g_SOCKET_RetryCount_KEY     = 'RetryCount'     ;//キー Timer
     g_SOCKET_RetryCount     = '3'   ;//デフォルト

   g_SOCKET_SIP_KEY       = 'ServerIP'     ;//キーIP Address
     g_SOCKET_SIP       = '000.000.000.000'   ;//デフォルト
   g_SOCKET_SPORT_KEY     = 'ServerPort'     ;//キー IP port
     g_SOCKET_SPORT     = ''   ;//デフォルト

   g_SOCKET_PORT_KEY      = 'Port'     ;//キーRIS IP port
     g_SOCKET_PORT        = '0000'   ;//デフォルト

  //セクション：ログ情報
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

  //セクション：DBログ情報(オーダ受信)
  g_DBLOG01_SECTION             = 'DB_LOG01';
  //セクション：DBログ情報(受付送信)
  g_DBLOG02_SECTION             = 'DB_LOG02';
  //セクション：DBログ情報(実施送信)
  g_DBLOG03_SECTION             = 'DB_LOG03';
  //セクション：DBログ情報(シェーマ連携)
  g_DBLOG04_SECTION             = 'DB_LOG04';
  //セクション：DBログ情報
    g_DBLOG_LOGGING_KEY       = 'LOGGING';
      g_DBLOG_LOGGING_DEF     = '1';
    g_DBLOG_PATH_KEY          = 'PATH';
      g_DBLOG_PATH_DEF        = '.\Log\Log\';
    g_DBLOG_PREFIX_KEY        = 'PREFIX';
      g_DBLOG_PREFIX_DEF      = 'LOG';
    g_DBLOG_KEEPDAYS_KEY      = 'KEEPDAYS';
      g_DBLOG_KEEPDAYS_DEF    = '7';

  //セクション：DBデバッグ情報(オーダ受信)
  g_DBLOGDBG01_SECTION          = 'DB_DEBUG01';
  //セクション：DBデバッグ情報(受付送信)
  g_DBLOGDBG02_SECTION          = 'DB_DEBUG02';
  //セクション：DBデバッグ情報(実施送信)
  g_DBLOGDBG03_SECTION          = 'DB_DEBUG03';
  //セクション：DBデバッグ情報(シェーマ連携)
  g_DBLOGDBG04_SECTION          = 'DB_DEBUG04';
  //セクション：DBデバッグ情報
    g_DBLOGDBG_LOGGING_KEY    = 'LOGGING';
      g_DBLOGDBG_LOGGING_DEF  = '1';
    g_DBLOGDBG_PATH_KEY       = 'PATH';
      g_DBLOGDBG_PATH_DEF     = '.\Log\Log\';
    g_DBLOGDBG_PREFIX_KEY     = 'PREFIX';
      g_DBLOGDBG_PREFIX_DEF   = 'LOG';
    g_DBLOGDBG_KEEPDAYS_KEY   = 'KEEPDAYS';
      g_DBLOGDBG_KEEPDAYS_DEF = '7';

  g_ROMA_SECSION  = 'ROMA';
    g_ROMA_1_KEY = 'ROMA1';//キー
        g_ROMA_1_DEF = '0';//
    g_ROMA_2_KEY = 'ROMA2';//キー
        g_ROMA_2_DEF = '0';//
    g_ROMA_3_KEY = 'ROMA3';//キー
        g_ROMA_3_DEF = '0';//
    g_ROMA_4_KEY = 'ROMA4';//キー
        g_ROMA_4_DEF = '0';//

  g_RIORDER_SECSION  = 'RIORDER';
    g_RIORDER_KEY = 'KAIKEI';//キー
        g_RIORDER_DEF = '0';//

  //ブランク項目データキー
  CSTNULLDATAKEY = 'NULL';

  // 看護区分
  //HISコード
  //Ａ－Ⅰ
  DEF_HIS_KANGO_1 = '1';
  //Ａ－Ⅱ
  DEF_HIS_KANGO_2 = '2';
  //Ａ－Ⅲ
  DEF_HIS_KANGO_3 = '3';
  //Ａ－Ⅳ
  DEF_HIS_KANGO_4 = '4';
  //Ｂ－Ⅰ
  DEF_HIS_KANGO_5 = '5';
  //Ｂ－Ⅱ
  DEF_HIS_KANGO_6 = '6';
  //Ｂ－Ⅲ
  DEF_HIS_KANGO_7 = '7';
  //Ｂ－Ⅳ
  DEF_HIS_KANGO_8 = '8';
  //Ｃ－Ⅰ
  DEF_HIS_KANGO_9 = '9';
  //Ｃ－Ⅱ
  DEF_HIS_KANGO_10 = '10';
  //Ｃ－Ⅲ
  DEF_HIS_KANGO_11 = '11';
  //Ｃ－Ⅳ
  DEF_HIS_KANGO_12 = '12';
  //RISコード
  //Ａ－Ⅰ
  DEF_RIS_KANGO_1 = '1';
  //Ａ－Ⅱ
  DEF_RIS_KANGO_2 = '2';
  //Ａ－Ⅲ
  DEF_RIS_KANGO_3 = '3';
  //Ａ－Ⅳ
  DEF_RIS_KANGO_4 = '4';
  //Ｂ－Ⅰ
  DEF_RIS_KANGO_5 = '5';
  //Ｂ－Ⅱ
  DEF_RIS_KANGO_6 = '6';
  //Ｂ－Ⅲ
  DEF_RIS_KANGO_7 = '7';
  //Ｂ－Ⅳ
  DEF_RIS_KANGO_8 = '8';
  //Ｃ－Ⅰ
  DEF_RIS_KANGO_9 = '9';
  //Ｃ－Ⅱ
  DEF_RIS_KANGO_10 = '10';
  //Ｃ－Ⅲ
  DEF_RIS_KANGO_11 = '11';
  //Ｃ－Ⅳ
  DEF_RIS_KANGO_12 = '12';
  //名称
  DEF_KANGO_1_NAME = 'Ａ－Ⅰ';
  DEF_KANGO_2_NAME = 'Ａ－Ⅱ';
  DEF_KANGO_3_NAME = 'Ａ－Ⅲ';
  DEF_KANGO_4_NAME = 'Ａ－Ⅳ';
  DEF_KANGO_5_NAME = 'Ｂ－Ⅰ';
  DEF_KANGO_6_NAME = 'Ｂ－Ⅱ';
  DEF_KANGO_7_NAME = 'Ｂ－Ⅲ';
  DEF_KANGO_8_NAME = 'Ｂ－Ⅳ';
  DEF_KANGO_9_NAME = 'Ｃ－Ⅰ';
  DEF_KANGO_10_NAME = 'Ｃ－Ⅱ';
  DEF_KANGO_11_NAME = 'Ｃ－Ⅲ';
  DEF_KANGO_12_NAME = 'Ｃ－Ⅳ';
  DEF_KANGO_99_NAME = '不明';
  //iniファイル内容
  g_KANGO_SECSION = 'KANGO';

  // 患者区分
  //HISコード
  //悪性腫瘍
  DEF_HIS_KANJA_1 = '1';
  //悪性腫瘍の疑い
  DEF_HIS_KANJA_2 = '2';
  //良性腫瘍
  DEF_HIS_KANJA_3 = '3';
  //非新生物
  DEF_HIS_KANJA_4 = '4';
  //その他
  DEF_HIS_KANJA_5 = '5';
  //RISコード
  //悪性腫瘍
  DEF_RIS_KANJA_1 = '1';
  //悪性腫瘍の疑い
  DEF_RIS_KANJA_2 = '2';
  //良性腫瘍
  DEF_RIS_KANJA_3 = '3';
  //非新生物
  DEF_RIS_KANJA_4 = '4';
  //その他
  DEF_RIS_KANJA_5 = '5';
  //名称
  DEF_KANJA_1_NAME = '悪性腫瘍';
  DEF_KANJA_2_NAME = '悪性腫瘍の疑い';
  DEF_KANJA_3_NAME = '良性腫瘍';
  DEF_KANJA_4_NAME = '非新生物';
  DEF_KANJA_5_NAME = 'その他';
  DEF_KANJA_9_NAME = '不明';
  //iniファイル内容
  g_KANJA_SECSION = 'KANJA';

  // 救護区分
  //HISコード
  //担送
  DEF_HIS_KYUGO_1 = '1';
  //護送
  DEF_HIS_KYUGO_2 = '2';
  //独歩
  DEF_HIS_KYUGO_3 = '3';
  //RISコード
  //担送
  DEF_RIS_KYUGO_1 = '1';
  //護送
  DEF_RIS_KYUGO_2 = '2';
  //独歩
  DEF_RIS_KYUGO_3 = '3';
  //名称
  DEF_KYUGO_1_NAME = '担送';
  DEF_KYUGO_2_NAME = '護送';
  DEF_KYUGO_3_NAME = '独歩';
  DEF_KYUGO_9_NAME = '不明';
  //iniファイル内容
  g_KYUGO_SECSION = 'KYUGO';

  // 血液型ABO
  //HISコード
  //A
  DEF_HIS_BLOODABO_1 = '1';
  //B
  DEF_HIS_BLOODABO_2 = '2';
  //O
  DEF_HIS_BLOODABO_3 = '3';
  //AB
  DEF_HIS_BLOODABO_4 = '4';
  //RISコード
  //A
  DEF_RIS_BLOODABO_1 = '1';
  //B
  DEF_RIS_BLOODABO_2 = '2';
  //O
  DEF_RIS_BLOODABO_3 = '3';
  //AB
  DEF_RIS_BLOODABO_4 = '4';
  //名称
  DEF_BLOODABO_1_NAME = 'A';
  DEF_BLOODABO_2_NAME = 'B';
  DEF_BLOODABO_3_NAME = 'O';
  DEF_BLOODABO_4_NAME = 'AB';
  DEF_BLOODABO_9_NAME = '?';
  //iniファイル内容
  g_BLOODABO_SECSION = 'BLOODABO';

  // 血液型RH
  //HISコード
  //-
  DEF_HIS_BLOODRH_1 = '-';
  //+
  DEF_HIS_BLOODRH_2 = '+';
  //RISコード
  //-
  DEF_RIS_BLOODRH_1 = '-';
  //+
  DEF_RIS_BLOODRH_2 = '+';
  //名称
  DEF_BLOODRH_1_NAME = 'RH-';
  DEF_BLOODRH_2_NAME = 'RH+';
  DEF_BLOODRH_9_NAME = '?';
  //iniファイル内容
  g_BLOODRH_SECSION = 'BLOODRH';

  // 障害情報
  //HISコード
  //無
  DEF_SYOUGAI_0 = '0';
  //有
  DEF_SYOUGAI_1 = '1';
  //名称
  DEF_SYOUGAI_0_NAME = '無';
  DEF_SYOUGAI_1_NAME = '有';

  //iniファイル内容
  g_SYOUGAINAME_SECSION = 'SYOUGAINAME';
    g_SYOUGAINAMEO1_KEY = 'NAME';      //データキー
      g_DEFSYOUGAINAMEO1 = '視覚障害,聴覚障害,言語障害,意識障害,精神障害,' +
                           '運動障害,内部障害,ペースメーカー';  //名称

  // 感染情報
  //HISコード
  //陽性
  DEF_KANSEN_0 = '+';
  //陰性
  DEF_KANSEN_1 = '-';
  //不明
  DEF_KANSEN_2 = '?';
  //RISコード
  //感染なし
  DEF_RIS_KANSEN_0 = '0';
  //感染あり
  DEF_RIS_KANSEN_1 = '1';
  //名称
  DEF_KANSEN_0_NAME = '陽性';
  DEF_KANSEN_1_NAME = '陰性';
  DEF_KANSEN_2_NAME = '不明';
  DEF_KANSEN_9_NAME = '未検査';

  //iniファイル内容
  g_KANSEN_SECSION  = 'KANSEN';

  g_KANSENNAME_SECSION  = 'KANSENNAME';
    g_KANSENNAMEO1_KEY  = 'NAME';      //データキー
      g_DEFKANSENNAMEO1 = 'ＨＢｓ抗原,ＨＢｅ抗源,ＨＶＣ抗体,ＨＩＶ,' +
                          'ＨＴＬＶ－Ｉ,梅毒ＲＰＲ,梅毒ＴＰＬＡ,ＭＲＳＡ,その他';  //名称
  g_KANSENON_SECSION    = 'KANSENON';
    g_KANSENONO1_KEY    = 'ON';      //データキー
      g_DEFKANSENONO1   = DEF_KANSEN_0 + ',' + DEF_KANSEN_2;  //名称

  // 禁忌情報
  //HISコード
  //無
  DEF_KINKI_0 = '0';
  //有
  DEF_KINKI_1 = '1';
  //名称
  DEF_KINKI_0_NAME = '無';
  DEF_KINKI_1_NAME = '有';

  //iniファイル内容
  g_KINKINAME_SECSION  = 'KINKINAME';
    g_KINKINAMEO1_KEY  = 'NAME';      //データキー
      g_DEFKINKINAMEO1 = 'ピリン,ペニシリン,ヨード,その他';  //名称


  // 緊急区分
  //HISコード
  //なし
  DEF_HIS_KINKYU_0 = '0';
  //緊急
  DEF_HIS_KINKYU_1 = '1';
  //RISコード
  //なし
  DEF_RIS_KINKYU_0 = '0';
  //緊急
  DEF_RIS_KINKYU_1 = '1';
  //名称
  DEF_KINKYU_0_NAME = 'なし';
  DEF_KINKYU_1_NAME = '緊急';
  //iniファイル内容
  g_KINKYU_SECSION = 'KINKYU';

  // 至急区分
  //HISコード
  //なし
  DEF_HIS_SIKYU_0 = '0';
  //至急
  DEF_HIS_SIKYU_1 = '1';
  //RISコード
  //なし
  DEF_RIS_SIKYU_0 = '0';
  //至急
  DEF_RIS_SIKYU_1 = '1';
  //名称
  DEF_SIKYU_0_NAME = 'なし';
  DEF_SIKYU_1_NAME = '至急';
  //iniファイル内容
  g_SIKYU_SECSION = 'SIKYU';

  // 至急現像区分
  //HISコード
  //なし
  DEF_HIS_GENZO_0 = '0';
  //至急現像
  DEF_HIS_GENZO_1 = '1';
  //RISコード
  //なし
  DEF_RIS_GENZO_0 = '0';
  //至急現像
  DEF_RIS_GENZO_1 = '1';
  //名称
  DEF_GENZO_0_NAME = 'なし';
  DEF_GENZO_1_NAME = '至急現像';
  //iniファイル内容
  g_GENZO_SECSION = 'GENZO';

  // 予約区分
  //HISコード
  //ｵｰﾌﾟﾝ
  DEF_HIS_YOYAKU_O = 'O';
  //ｸﾛｰｽﾞ予約
  DEF_HIS_YOYAKU_C = 'C';
  //予約なし
  DEF_HIS_YOYAKU_N = 'N';
  //RISコード
  //ｵｰﾌﾟﾝ
  DEF_RIS_YOYAKU_O = 'O';
  //ｸﾛｰｽﾞ予約
  DEF_RIS_YOYAKU_C = 'C';
  //予約なし
  DEF_RIS_YOYAKU_N = 'N';
  //名称
  DEF_YOYAKU_O_NAME = 'ｵｰﾌﾟﾝ';
  DEF_YOYAKU_C_NAME = 'ｸﾛｰｽﾞ予約';
  DEF_YOYAKU_N_NAME = '予約なし';
  //iniファイル内容
  g_YOYAKU_SECSION = 'YOYAKU';

  // 読影区分
  //HISコード
  //不要
  DEF_HIS_DOKUEI_0 = '0';
  //要読影
  DEF_HIS_DOKUEI_1 = '1';
  //RISコード
  //不要
  DEF_RIS_DOKUEI_0 = '0';
  //要読影
  DEF_RIS_DOKUEI_1 = '1';
  //名称
  DEF_DOKUEI_0_NAME = '不要';
  DEF_DOKUEI_1_NAME = '要読影';
  //iniファイル内容
  g_DOKUEI_SECSION = 'DOKUEI';
  //iniファイル内容
  g_TYPE_SECSION = 'TYPE';
    g_TYPEO1_KEY = 'RIS';      //データキー
    g_TYPEO2_KEY = 'THERARIS';      //データキー
    g_TYPEO3_KEY = 'REPORT';      //データキー
      g_DEFTYPE = '';  //コード
  //iniファイル内容
  g_REPORTTYPE_SECSION = 'REPORTTYPE';
  (*
  // 診断接続情報
  g_RRIS_SECSION  = 'RRISUSER';
    g_RRIS_KEY = 'USER';//キー
        g_RRIS_DEF = 'RRIS';//
  // 治療接続情報
  g_RTRIS_SECSION  = 'RTRISUSER';
    g_RTRIS_KEY = 'USER';//キー
        g_RTRIS_DEF = 'RTRIS';//
  CST_RT_TYPEID_31 = '31';
  *)

  // 材料情報
  //iniファイル内容
  g_ZAI_CODE_SECSION = 'ZAI_CODE';
    g_ZAI_CODE_KEY = 'CODE';      //データキー
      g_DEFZAI_CODE = '';  //コード
  //2007.07.04
  // グループ項目コード情報
  //iniファイル内容
  g_KOUMOKU_CODE_SECSION = 'KOUMOKU_CODE';
    g_KOUMOKUCODE_KEY = 'CODE';      //データキー
      g_DEFKOUMOKUCODE = '';  //コード
    g_NOT_ACCOUNT_KEY = 'NOT_ACCOUNT';      //データキー
      g_DEFNOT_ACCOUNT = '';  //コード
  //2007.07.04
  // 明細項目コード情報
  //iniファイル内容
  g_MEISAI_CODE_SECSION = 'MEISAI_CODE';
    g_MEISAICODE_KEY = 'CODE';      //データキー
      g_DEFMEISAICODE = '';  //コード
    g_MEISAINOT_ACCOUNT_KEY = 'NOT_ACCOUNT';      //データキー
      g_DEFMEISAINOT_ACCOUNT = '';  //コード

  // NOTESMARK情報
  g_NOTESMARK_SECSION  = 'NOTESMARK';
    g_KANGOKBN_KEY = 'KANGOKBN';//キー
    g_KANJAKBN_KEY = 'KANJAKBN';//
  // HIS送信なし情報
  g_HIS_SECSION  = 'HIS';
    g_HIS_ID_KEY = 'ID';//キー
  // シェーマ情報
  g_SHEMA_SECSION  = 'SHEMA';
    g_SHEMA_HIS_KEY = 'HIS_PASS';//キー
    g_SHEMA_LOCAL_KEY = 'LOCAL_PASS';//キー
    g_SHEMA_HTML_KEY = 'HTML_PASS';//キー
    //2008.09.12
    g_LOGONPASS_KEY = 'LOGONPASS';//キー
    g_LOGONUSER_KEY = 'LOGONUSER';//キー
    g_LOGONRETRY_KEY = 'LOGONRETRY';//キー

(*
  //iniファイル内容
  g_ENTRY_SECSION = 'ENTRY';
    g_ENTRY_USER_KEY = 'USER';      //データキー
    g_ENTRY_USERNAME_KEY = 'SERNAME';      //データキー
      g_ENTRY_USER_DEF = 'SYSTEM';      //データキー
      g_ENTRY_USERNAME_DEF = 'システム';      //データキー
*)

  //iniファイル内容
  g_RTRISTYPE_SECSION = 'RTRISTYPE';

  // HIS送信種別情報
  g_HIS_TYPE_SECSION  = 'HISTYPE';
    g_HIS_TYPE_KEY = 'TYPEID';      //データキー
      g_HIS_TYPE_DEF = '';      //データキー
  // HIS送信項目コード情報
  g_HIS_KOUMOKU_SECSION  = 'HISKOUMOKU';
    g_HIS_KOUMOKU_KEY = 'KOUMOKUID';      //データキー
      g_HIS_KOUMOKU_DEF = '';      //データキー
  // HIS送信部位コード情報
  g_HIS_BUI_SECSION  = 'HISBUI';
    g_HIS_BUI_KEY = 'BUIID';      //データキー
      g_HIS_BUI_DEF = '';      //データキー

  // オンコール情報
  g_ONCALL_SECSION  = 'ONCALL';
    g_ONCALL_AM_KEY = 'AM';      //データキー
    g_ONCALL_PM_KEY = 'PM';      //データキー
      g_ONCALL_AM_DEF = '0000';      //データキー
      g_ONCALL_PM_DEF = '2359';      //データキー

  // HIS送信科コード情報
  g_HIS_EXSECTION_SECSION  = 'EXSEND';
    g_HIS_EXSECTION_KEY = 'SECTIONID';      //データキー
      g_HIS_EXSECTION_DEF = '';      //データキー
    g_HIS_EXDR_KEY = 'DRID';      //データキー
      g_HIS_EXDR_DEF = '';      //データキー
  // HISコメントタイトル情報
  g_HIS_EXCOMTITLE_SECSION  = 'EXCOMTITLE';
    g_HIS_TITLE1_KEY = 'TITLE1';      //データキー
      g_HIS_TITLE1_DEF = '';      //データキー
    g_HIS_TITLE2_KEY = 'TITLE2';      //データキー
      g_HIS_TITLE2_DEF = '';      //データキー
//参照定数-----------------------------------------------------------------
//LOGファイル情報定義（内容）
const
 G_LOG_LINE_HEAD_OK  = 'OK'; //接頭子 正常
 G_LOG_LINE_HEAD_NG  = 'NG'; //接頭子 異常
 G_LOG_LINE_HEAD_NG1 = 'N1'; //接頭子 再送
 G_LOG_LINE_HEAD_NG2 = 'N2'; //接頭子 スキップ
 G_LOG_LINE_HEAD_NG3 = 'N3'; //接頭子 ストップ
 G_LOG_LINE_HEAD_NP  = '  '; //接頭子 コメント
//LOGファイル情報定義(ログの種別番号とレベルとログの種別文字列)
//実行時外部指定を考慮してInitialで代入処理する
const
 G_LOG_PKT_PTH_DEF             = '.LOG';//LOGファイル拡張子
 G_MAX_LOG_TYPE                = 10; //ログの種別の個数最大値
 //サービス処理
 G_LOG_KIND_SVC_NUM            = 1;
 G_LOG_KIND_SVC                = 'Servic            処理';//使用
 G_LOG_KIND_SVC_LEVEL          = 1;
 //ソケットサーバ
 G_LOG_KIND_SK_SV_NUM          = 2;
 G_LOG_KIND_SK_SV              = 'Socketサーバ      処理';//使用
 G_LOG_KIND_SK_SV_LEVEL        = 3;
 //ソケットクライアント
 G_LOG_KIND_SK_CL_NUM          = 3;
 G_LOG_KIND_SK_CL              = 'Socketクライアント処理';//使用
 G_LOG_KIND_SK_CL_LEVEL        = 3;
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
 G_LOG_KIND_DB_OUT_LEVEL       = 4;
 //DB 電文解析処理
 G_LOG_KIND_MS_ANLZ_NUM        = 7;
 G_LOG_KIND_MS_ANLZ            = 'MSG   解析        処理';//
 G_LOG_KIND_MS_ANLZ_LEVEL      = 4;
 //サービス基本処理
 G_LOG_KIND_SVCDEF_NUM         = 8;
 G_LOG_KIND_SVCDEF             = 'Servic 基本       処理';//
 G_LOG_KIND_SVCDEF_LEVEL       = 5;
 //デバックモード
 G_LOG_KIND_DEBUG_NUM          = 9;
 G_LOG_KIND_DEBUG              = '開発者用          処理';//
 G_LOG_KIND_DEBUG_LEVEL        = 6;
 //エラー処理
 G_LOG_KIND_NG_NUM             = 10;
 G_LOG_KIND_NG                 = 'エラー            処理';//
 G_LOG_KIND_NG_LEVEL           = 1;

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

  G_FIELD_NAME_DERI = 'デリミタ';

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
                                // 8:サービス基本処理
                                (f_LogMsg : G_LOG_KIND_SVCDEF;
                                 f_LogLevel:G_LOG_KIND_SVCDEF_LEVEL),
                                // 9:開発者用
                                (f_LogMsg : G_LOG_KIND_DEBUG;
                                 f_LogLevel:G_LOG_KIND_DEBUG_LEVEL),
                                // 10:エラー処理
                                (f_LogMsg : G_LOG_KIND_NG;
                                 f_LogLevel:G_LOG_KIND_NG_LEVEL)
                                );
//■コード及び名称定義
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
//2001.09.06
GPCST_SYOKUSHU_1='1';
GPCST_SYOKUSHU_2='2';
GPCST_SYOKUSHU_3='3';
GPCST_SYOKUSHU_4='4';
GPCST_SYOKUSHU_1_NAME='医師';
GPCST_SYOKUSHU_2_NAME='事務等';
GPCST_SYOKUSHU_3_NAME='技師';
GPCST_SYOKUSHU_4_NAME='看護師';
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
//■読影要否
GPCST_DOKUEI_0 = '0';
GPCST_DOKUEI_1 = '1';
GPCST_DOKUEI_2 = '2';
GPCST_DOKUEI_0_NAME = '不要';
GPCST_DOKUEI_1_NAME = '必要';
GPCST_DOKUEI_2_NAME = '緊急';
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
//■手技区分名
//GPCST_SHG_1_NAME = '基本';
GPCST_SHG_1_NAME = '加算'; //2004.02.01 koba
GPCST_SHG_2_NAME = '処置';
//■会計送信種別
GPCST_KAIKEI_0 = '0';
GPCST_KAIKEI_1 = '1'  ;
GPCST_KAIKEI_0_NAME = '会計なし';
GPCST_KAIKEI_1_NAME = '会計あり';

//■RIオーダ区分
GPCST_RI_ORDER_0 = '0';
GPCST_RI_ORDER_1 = '1'  ;
GPCST_RI_ORDER_2 = '2'  ;
GPCST_RI_ORDER_0_NAME = 'その他検査';
GPCST_RI_ORDER_1_NAME = 'RI注射';
GPCST_RI_ORDER_2_NAME = 'RI検査';
//■清算区分
GPCST_SEISAN_0 = '0';
GPCST_SEISAN_1 = '1';
GPCST_SEISAN_0_NAME = '未清算';
GPCST_SEISAN_1_NAME = '清算済';

//2002.11.20
//日付のFormat
CST_FORMATDATE_0='YYYYMMDD';
CST_FORMATDATE_1='YYYY/MM/DD';
CST_FORMATDATE_2='YYYY/MM/DD HH:NN';
CST_FORMATDATE_3='YYYY/MM/DD HH:MM:SS';
CST_FORMATDATE_4='HHMMSS';
CST_FORMATDATE_5='HH:MM:SS';


GPCST_INFKBN_FU='FU';   //受付
GPCST_INFKBN_FC='FC';   //受付キャンセル {2002.12.17]
GPCST_INFKBN_FO='F0';   //実施
GPCST_INFKBN_F1='F1';   //中止           {2002.12.17]
GPCST_INFKBN_FY='FY';   //予約           {2003.01.07]
GPCST_INFKBN_FH='FH';   //保留
GPCST_SYORIKBN_01='01'; //新規
GPCST_SYORIKBN_02='02'; //更新
GPCST_SYORIKBN_03='03'; //削除
GPCST_JOUTAIKBN_3='3';  //実施
GPCST_JOUTAIKBN_7='7';  //中止

//精算フラグ 2003.12.12
GSPCST_SEISAN_FLG_0 = '0';
GSPCST_SEISAN_FLG_0_NAME = '未精算';
GSPCST_SEISAN_FLG_1 = '1';
GSPCST_SEISAN_FLG_1_NAME = '精算済';
//ポータブルフラグ
GPCST_PORTABLE_FLG_0 = '0';
GPCST_PORTABLE_FLG_0_NAME = '通常';
GPCST_PORTABLE_FLG_1 = '1';
GPCST_PORTABLE_FLG_1_NAME = 'ポータブル';
GPCST_PORTABLE_FLG_2 = '2';
GPCST_PORTABLE_FLG_2_NAME = '手術室';
GPCST_PORTABLE_FLG_3 = '3';           //2004.06.15
GPCST_PORTABLE_FLG_3_NAME = 'その他'; //2004.06.15


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
   g_Svc_Ex_Acvite:string;
   g_Svc_Shema_Acvite:string;
   (*
   g_Svc_Rs_Acvite:string;
   g_Svc_Ka_Acvite:string;
   *)
   g_Svc_Sd_Cycle :integer;
   g_Svc_Rv_Cycle :integer;
   g_Svc_Ex_Cycle :integer;
   g_Svc_Shema_Cycle :integer;
   (*
   g_Svc_Rs_Cycle :integer;
   g_Svc_Ka_Cycle :integer;
   *)

   g_RTSvc_Ex_Acvite:string;
   g_RTSvc_Ex_Cycle :integer;
   g_RTSvc_Re_Acvite:string;
   g_RTSvc_Re_Cycle :integer;

//DB接続情報
   g_RisDB_Name : string;
   g_RisDB_Uid  : string;
   g_RisDB_Pas  : string;
   g_ReRisDB_Name : string;
   g_ReRisDB_Uid  : string;
   g_ReRisDB_Pas  : string;
   (*
   g_RTRisDB_Name : string;
   g_RTRisDB_Uid  : string;
   g_RTRisDB_Pas  : string;
   *)
   g_RisDB_DpendSrvName :string;
   g_RisDB_Retry: integer;
   g_RisDB_SndKeep: integer;
   g_RisDB_RcvKeep: integer;
   g_RisDB_SndEXKeep: integer;
   g_RisDB_RcvKaKeep: integer;
   g_RisDB_ShemaKeep: integer;
   g_RisDB_SndRsKeep: integer;
   g_RTRisDB_ReKeep: integer;
   g_RTRisDB_SndEXKeep: integer;
//Socket接続用情報郡
   //クライアント
   g_C_Socket_Info_01      :  TClint_Info;
   g_C_Socket_Info_02      :  TClint_Info;
   g_C_Socket_Info_03      :  TClint_Info;
   g_C_Socket_Info_04      :  TClint_Info;
   g_C_Socket_Info_05      :  TClint_Info;
   //サーバ
   g_S_Socket_Info_01      :  TServer_Info;
   g_S_Socket_Info_02      :  TServer_Info;
   g_S_Socket_Info_03      :  TServer_Info;
   g_S_Socket_Info_04      :  TServer_Info;
   g_S_Socket_Info_05      :  TServer_Info;
   //クライアント
   g_C_RTSocket_Info_01      :  TClint_Info;
   g_C_RTSocket_Info_02      :  TClint_Info;
   //サーバ
   g_S_RTSocket_Info_01      :  TServer_Info;
   g_S_RTSocket_Info_02      :  TServer_Info;
//LOG情報
   g_Rig_LogActive         :  string;
   g_Rig_LogPath           :  string;
   g_Rig_LogSize           :  string;
   g_Rig_LogKeep           :  integer;
   g_Rig_LogIncMsg         :  string;
   g_Rig_LogLevel          :  string;

   //2018/08/30 ログファイル変更
   g_LogFileSize: integer;

//セクション：DBログ情報
  g_DBLOG01_LOGGING         : Boolean;
  g_DBLOG01_PATH            : String;
  g_DBLOG01_PREFIX          : String;
  g_DBLOG01_KEEPDAYS        : Integer;
//セクション：DBログ情報
  g_DBLOG02_LOGGING         : Boolean;
  g_DBLOG02_PATH            : String;
  g_DBLOG02_PREFIX          : String;
  g_DBLOG02_KEEPDAYS        : Integer;
//セクション：DBログ情報
  g_DBLOG03_LOGGING         : Boolean;
  g_DBLOG03_PATH            : String;
  g_DBLOG03_PREFIX          : String;
  g_DBLOG03_KEEPDAYS        : Integer;
//セクション：DBログ情報
  g_DBLOG04_LOGGING         : Boolean;
  g_DBLOG04_PATH            : String;
  g_DBLOG04_PREFIX          : String;
  g_DBLOG04_KEEPDAYS        : Integer;

//セクション：DBデバッグ情報
  g_DBLOGDBG01_LOGGING      : Boolean;
  g_DBLOGDBG01_PATH         : String;
  g_DBLOGDBG01_PREFIX       : String;
  g_DBLOGDBG01_KEEPDAYS     : Integer;
//セクション：DBデバッグ情報
  g_DBLOGDBG02_LOGGING      : Boolean;
  g_DBLOGDBG02_PATH         : String;
  g_DBLOGDBG02_PREFIX       : String;
  g_DBLOGDBG02_KEEPDAYS     : Integer;
//セクション：DBデバッグ情報
  g_DBLOGDBG03_LOGGING      : Boolean;
  g_DBLOGDBG03_PATH         : String;
  g_DBLOGDBG03_PREFIX       : String;
  g_DBLOGDBG03_KEEPDAYS     : Integer;
//セクション：DBデバッグ情報
  g_DBLOGDBG04_LOGGING      : Boolean;
  g_DBLOGDBG04_PATH         : String;
  g_DBLOGDBG04_PREFIX       : String;
  g_DBLOGDBG04_KEEPDAYS     : Integer;

//LOG種別定義域（外部定義の場合）
   g_Log_Type     : array[1..G_MAX_LOG_TYPE] of TLog_Type;
//プロファイル属性
   g_Prof01 : string;
   g_Prof02 : string;
   g_Prof03 : string;
   g_Prof04 : string;
   g_Prof05 : string;
   g_Prof06 : string;
   g_Prof07 : string;
   g_Prof08 : string;
   //2003.07.04
   g_Prof09 : string;
   g_Prof10 : string;
   g_Prof11 : string;
   g_Prof12 : string;
//シェーマ情報
   g_Schema_Main : string;
   g_Schema_Sub  : string;
   g_Schema_Del  : string;
   g_Schema_MainSVR : string;
   g_Schema_SubSVR  : string;
   g_Schema_Sel  : string;
//HIS_ID,RIS_ID対応表
   g_Kensa_ID : TKensa_Type;
//患者状態コメントID
   g_KanjaJyoutai : TStrings;
//プロファイルID
   g_Prof_List : TStrings;
//看護区分
  g_KangoKbn_List : TStrings;
  g_KangoName_List : TStrings;
//患者区分
  g_KanjaKbn_List : TStrings;
  g_KanjaName_List : TStrings;
//救護区分
  g_KyuugoKbn_List : TStrings;
  g_KyuugoName_List : TStrings;
//障害情報名称
  g_Syougai_List : TStrings;
//血液型ABO
  g_ABOCode_List : TStrings;
  g_ABOName_List : TStrings;
//血液型RH
  g_RHCode_List : TStrings;
  g_RHName_List : TStrings;
//感染情報
  g_KansenCode_List : TStrings;
  g_KansenName_List : TStrings;
//感染情報あり項目
  g_KansenON_List : TStrings;
//感染情報名称
  g_Kansen_List : TStrings;
//禁忌情報名称
  g_Kinki_List : TStrings;
//緊急区分
  g_KinkyuKbn_List : TStrings;
  g_KinkyuName_List : TStrings;
//至急区分
  g_SikyuKbn_List : TStrings;
  g_SikyuName_List : TStrings;
//至急現像区分
  g_GenzoKbn_List : TStrings;
  g_GenzoName_List : TStrings;
//予約区分
  g_YoyakuKbn_List : TStrings;
  g_YoyakuName_List : TStrings;
//読影区分
  g_DokueiKbn_List : TStrings;
  g_DokueiName_List : TStrings;
  g_RomaFlg_1 : Integer;
  g_RomaFlg_2 : Integer;
  g_RomaFlg_3 : Integer;
  g_RomaFlg_4 : Integer;

  g_RIOrder : String;
  (*
//保存先別検査種別
  g_RISType_List : TStrings;
  g_TheraRisType_List : TStrings;
  g_Report_List : TStrings;
  *)
//HIS_ID,Report_ID対応表
   g_ReportType_ID : TKensa_Type;
  (*
  // 診断接続情報
  g_RRISUser : string;
  // 治療接続情報
  g_RTRISUser : string;
  *)
//材料情報名称
  g_Zairyo_List : TStrings;
  //2007.07.04
  // グループ項目コード情報
  // 会計無し項目コード情報
  g_KOUMOKU_CODE : string;
  // 会計無しコード情報
  g_NOT_ACCOUNT : string;
  // 明細項目コード情報
  // 会計無し項目コード情報
  g_MESAI_KOUMOKU_CODE : string;
  // 会計無しコード情報
  g_MESAI_NOT_ACCOUNT : string;

  // NOTESMARK情報
  g_NotesMake_Kangokbn_List : TStrings;
  g_NotesMake_Kanjakbn_List : TStrings;
  // HIS送信なし情報
  g_HIS_List : TStrings;
  // シェーマ情報
  g_SHEMA_HIS_PASS : string;
  g_SHEMA_LOCAL_PASS : string;
  g_SHEMA_HTML_PASS : string;

  g_Shema_HTML_Original_File : string;
  g_LOGONPASS : string;
  g_LOGONUSER : string;
  g_LOGONRETRY : Integer;
(*
  g_ENTRY_USER  : string;
  g_ENTRY_USERNAME : string;
*)

  g_HIS_TYPE: string;

  g_HIS_KOUMOKU: string;
  g_HIS_BUI: string;

  g_ONCALL_AM: string;
  g_ONCALL_PM: string;

  g_HIS_EXSECTION: string;
  g_HIS_EXDR: string;

  g_COM_TITLE1: string;
  g_COM_TITLE2: string;
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
function func_RTTcpReadiniFile: Boolean;
procedure proc_ReadiniKenzo(
                           arg_Ini : TIniFile;
                           var arg_Kanja:TStrings
                           );
procedure proc_ReadiniFlg(
                          arg_Ini : TIniFile
                          );
procedure proc_ReadiniType(
                          arg_Ini : TIniFile
                          );
//4.バッファ系--------------------------------------------------------------------
//バッファよりオフセットとサイズで文字列として取出す
//バッファから文字列を取り出す
function func_ByteToStr(
           arg_Buffer        : array of byte ; //バファ
           arg_offset        : LongInt;        //オフセット
           arg_size          : LongInt         //サイズ
           ):string;
//バッファに文字列を設定
procedure proc_StrToByte(
           var arg_Buffer      : array of byte ;//バファ
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
           arg_TStringStream : TStringStream;
           arg_System        : string; //発生システム
           arg_MsgKind       : string  //種別
           );
//TStringListよりTStringStreamを作成する(放射線依頼電文用)
Procedure  proc_TStrListToStrm_Irai(
           arg_TStringList   : TStringList;
           arg_TStringStream : TStringStream;
           arg_System        : string;
           arg_MsgKind       : string
           );
//実施用
Procedure  proc_TStrListToStrm_Jissi(
           arg_TStringList   : TStringList;
           arg_TStringStream : TStringStream;
           arg_System        : string;
           arg_MsgKind       : string
           );
//TStringListよりTStringStreamを作成する
Procedure  proc_TStrListToStrm2(
           arg_TStringList   : TStringList;
           arg_TStringStream : TStringStream;
           arg_System        : string; //発生システム
           arg_MsgKind       : string  //種別
           );
//TStringStreamより解析してTStringListを作成する
procedure proc_TStrmToStrlist(
           arg_TStringStream : TStringStream;
           arg_TStringList   : TStringList  ;
           arg_System        : string; //発生システム
           arg_MsgKind       : string  //種別
           );
//TStringStreamより解析してTStringListを作成する(放射線依頼電文用)
procedure proc_TStrmToStrlist_H_Irai(
           arg_TStringStream : TStringStream;
           arg_TStringList   : TStringList  ;
           arg_System        : string;
           arg_MsgKind       : string
           );
//TStringStreamより解析してTStringListを作成する(放射線依頼電文用)
procedure proc_TStrmToStrlist_H_Jissi(
           arg_TStringStream : TStringStream;
           arg_TStringList   : TStringList  ;
           arg_System        : string;
           arg_MsgKind       : string
           );
//TStringStreamより解析してTStringListを作成する
procedure proc_TStrmToStrlist2(
           arg_TStringStream : TStringStream;
           arg_TStringList   : TStringList  ;
           arg_System        : string; //発生システム
           arg_MsgKind       : string  //種別
           );
//TStringStreamより解析してTStringListを作成する
procedure proc_TStrmToStrlist3(
           arg_TStringStream : TStringStream;
           arg_TStringList   : TStringList  ;
           arg_System        : string; //発生システム
           arg_MsgKind       : string  //種別
           );
//電文バイト長取得
function func_MsgLen(
           arg_System        : string;  //発生システム
           arg_MsgKind       : string   //種別
           ):integer;
//電文定義体の長さ取得
function func_MsgDefLen(
           arg_System        : string;
           arg_MsgKind       : string
           ):integer;
//電文定義体の取得
function func_FindMsgField(
           arg_System        : string;
           arg_MsgKind       : string;
           arg_index         : integer //場所1-ｎ
           ):TStreamField;
//電文から情報を取り出す
function func_GetStringStream(
           arg_System        : string;
           arg_MsgKind       : string;
           arg_TStringStream : TStringStream;  //電文
           arg_index         : integer         //場所1-ｎ
           ):string;
//電文定義情報をもとにストリームから文字列を取り出す（可変長の電文用）
function func_GetStringStream2(arg_System        : String;
                              arg_MsgKind       : String;
                              arg_TStringStream : TStringStream;
                              arg_index         : integer;
                              arg_Offset        : integer
                              ):string;
//電文定義情報をもとにストリームから文字列を取り出す（可変長のコメント用）
function func_GetStringStream3(arg_System        : String;
                               arg_MsgKind       : String;
                               arg_TStringStream : TStringStream;
                               arg_Offset        : integer;
                               arg_Size          : integer
                               ):string;
//電文に情報を設置
procedure  proc_SetStringStream(
           arg_System        : string;
           arg_MsgKind       : string;
           arg_TStringStream : TStringStream; //電文
           arg_index         : integer;       //場所1-ｎ
           arg_string        : string         //設定文字列
           );
//電文に情報を設置（可変長の電文用）
procedure proc_SetStringStream2(arg_System        : String;
                                arg_MsgKind       : String;
                                arg_TStringStream : TStringStream;
                                arg_index         : integer;
                                arg_Offset        : integer;
                                arg_string        : String
                                );
//電文をクリア設定する
procedure  proc_ClearStream(
           arg_System        : string;
           arg_MsgKind       : string;
           arg_TStringStream : TStringStream
           );
//電文をクリア設定する(依頼電文専用)
procedure  proc_ClearStream2(
           arg_System        : string;
           arg_MsgKind       : string;
           arg_TStringStream : TStringStream
           );
//電文の共通部にデフォルト値を設定する
procedure  proc_SetStreamHDDef(
           arg_System        : string;
           arg_MsgKind       : string;
           arg_TStringStream : TStringStream
           );
//電文をクリア設定する(依頼電文専用)
procedure  proc_ClearStream3(
           arg_MaxLen        : Integer;
           arg_TStringStream : TStringStream
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
function bswap(src : integer) : integer; assembler;
function bswapf(src : single) : single;
procedure ByteOrderSwap(var Src: Double); overload;
function EndianShort_Short(Value: Short): Short;
procedure proc_Change_Byte(var arg_Length: String);
function func_HisToRis(arg_HisID:String):String;
function func_RisToHis(arg_RisID:String):String;
//●機能（例外無）：ｺｰﾄﾞを名前に変換登録 手技区分
function func_Change_Command(
       arg_Code:string    //ｺｰﾄﾞ
       ):string;          //名称
//●機能（例外無）：ｺｰﾄﾞを名前に変換 コマンド名（受信系サービスのみ）
function func_Change_RVRISCommand(
                                  arg_Code: String    //ｺｰﾄﾞ
                                  ): String;          //名称
//●機能（例外無）：シェーマ格納ファイル名作成
function func_Make_ShemaName(arg_OrderNO,               //オーダNO
                             arg_MotoFileName: string;  //HISｼｪｰﾏ名
                             arg_Index: integer         //部位NO
                             ):string;                  //格納ﾌｧｲﾙ名

//●機能（例外無）：HIS血液型ABOとRH情報をRIS用に変換
function func_Make_BloodType(
                             arg_ABO: String;
                             arg_RH: String
                             ): String;
//●機能（例外無）：RIS障害情報、禁忌情報の作成
procedure proc_Make_RISInfo(
                                arg_Syougai: String;
                                arg_Kinki: String;
                            var arg_SyougaiInfo: String;
                            var arg_KinkiInfo: String
                           );
//●機能（例外無）：RIS感染情報の作成
procedure proc_Make_RISKansen(
                                arg_Kansen: String;
                                arg_KansenCom: String;
                            var arg_KansenFlg: String;
                            var arg_KansenInfo: String
                           );
//●機能（例外無）：RIS妊娠日の作成
procedure proc_Make_RISNinsinDate(
                                     arg_Ninsin: String;
                                 var arg_NinsinDate: String
                                 );
//●機能（例外無）：HIS看護区分・患者区分をRIS用に変換
function func_Make_ExtraProfile(
                                arg_Kango: String;
                                arg_Kanja: String
                                ): String;
function func_GetServiceInfo(    arg_AppID  : String;
                                 arg_Qry    : T_Query;
                             var arg_Flg    : Boolean;
                             var arg_ErrMsg : String
                             ): String;
function func_GetSeq(    arg_AppID  : String;
                         arg_Qry    : TQuery;
                     var arg_Flg    : Boolean;
                     var arg_ErrMsg : String
                     ): String;
function func_GetDBMachineName(    arg_AppID  : String;
                                   arg_Qry    : TQuery;
                               var arg_Flg    : Boolean;
                               var arg_ErrMsg : String
                               ): String;
function func_SetHISRISControlInfo(    arg_APPID : String;
                                       arg_DataSeq : String;
                                       arg_Qry    : TQuery;
                                   var arg_Flg    : Boolean;
                                   var arg_LogBuffer : String
                                   ):Boolean;
function func_GetRISHost(    arg_HostID : String;
                             arg_Qry    : TQuery;
                         var arg_Flg    : Boolean;
                         var arg_ErrMsg : String
                         ): String;
(*
function func_GetRTRISHost(    arg_HostID : String;
                               arg_Qry    : TQuery;
                           var arg_Flg    : Boolean;
                           var arg_ErrMsg : String
                           ): String;
*)
function func_HisToReport(arg_HisID:String):String;
function func_ReportToHis(arg_ReportID:String):String;
(*
function func_GetRTServiceInfo(    arg_AppID  : String;
                                   arg_Qry    : TQuery;
                               var arg_Flg    : Boolean;
                               var arg_ErrMsg : String
                               ): String;
*)
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
//●電文定義情報を取得する
function func_FindMsgField(arg_System  : String;
                           arg_MsgKind : String;
                           arg_index   : Integer
                           ):TStreamField;
begin
  //依頼情報電文の場合
  if arg_MsgKind = G_MSGKIND_START then begin
    //指定項目内容設定
    Result := g_Stream_Base[arg_index];
  end
  //オーダ依頼情報電文の場合
  else if arg_MsgKind = G_MSGKIND_IRAI then begin
    //指定項目内容設定
    Result := g_Stream01_IRAI[arg_index];
  end
  //オーダキャンセル情報電文の場合
  else if arg_MsgKind = G_MSGKIND_CANCEL then begin
    //指定項目内容設定
    Result := g_Stream03_CANCEL[arg_index];
  end
  //患者情報電文の場合
  else if arg_MsgKind = G_MSGKIND_KANJA then begin
    //指定項目内容設定
    Result := g_Stream04_KANJA[arg_index];
  end
  //受付電文の場合
  else if arg_MsgKind = G_MSGKIND_UKETUKE then begin
    //指定項目内容設定
    Result := g_Stream06_RCE[arg_index];
  end
  //実施電文の場合
  else if arg_MsgKind = G_MSGKIND_JISSI then begin
    //指定項目内容設定
    Result := g_Stream02_JISSI[arg_index];
  end
  //会計電文の場合
  else if arg_MsgKind = G_MSGKIND_KAIKEI then begin
    //指定項目内容設定
    Result := g_Stream05_KAIKEI[arg_index];
  end;
end;
//●電文の長さバイト単位を取得する
function func_MsgLen(arg_System  : string;
                     arg_MsgKind : string
                     ):integer;
begin
  //セッション開始・終了の場合
  if arg_MsgKind = G_MSGKIND_START then begin
    //最大電文長取得
    Result := G_MSGSIZE_START;
  end
  //オーダ依頼情報電文の場合
  else if arg_MsgKind = G_MSGKIND_IRAI then begin
    //最大電文長取得
    Result := G_MSGSIZE_IRAI;
  end
  //オーダキャンセル情報電文の場合
  else if arg_MsgKind = G_MSGKIND_CANCEL then begin
    //最大電文長取得
    Result := G_MSGSIZE_CANCEL;
  end
  //患者情報電文の場合
  else if arg_MsgKind = G_MSGKIND_KANJA then begin
    //最大電文長取得
    Result := G_MSGSIZE_KANJA;
  end
  //受付電文の場合
  else if arg_MsgKind = G_MSGKIND_UKETUKE then begin
    //最大電文長取得
    Result := G_MSGSIZE_UKETUKE;
  end
  //実施電文の場合
  else if arg_MsgKind = G_MSGKIND_JISSI then begin
    //最大電文長取得
    Result := G_MSGSIZE_JISSI;
  end
  //会計電文の場合
  else if arg_MsgKind = G_MSGKIND_KAIKEI then begin
    //最大電文長取得
    Result := G_MSGSIZE_KAIKEI;
  end
  //再送電文の場合
  else if arg_MsgKind = G_MSGKIND_RESEND then begin
    //最大電文長取得
    Result := G_MSGSIZE_RESEND;
  end
  //それ以外の場合
  else begin
    //最大電文長取得
    Result := 0;
  end;
end;
//●電文定義情報数 定義フィールド数
function func_MsgDefLen(arg_System  : String;
                        arg_MsgKind : String
                        ):integer;
begin
  //セッション開始・終了の場合
  if arg_MsgKind = G_MSGKIND_START then begin
    //項目数設定
    Result := G_MSGFNUM_START;
  end
  //オーダ依頼情報電文の場合
  else if arg_MsgKind = G_MSGKIND_IRAI then begin
    //項目数設定
    Result := G_MSGFNUM_IRAI;
  end
  //オーダキャンセル情報電文の場合
  else if arg_MsgKind = G_MSGKIND_CANCEL then begin
    //項目数設定
    Result := G_MSGFNUM_CANCEL;
  end
  //患者情報電文の場合
  else if arg_MsgKind = G_MSGKIND_KANJA then begin
    //項目数設定
    Result := G_MSGFNUM_KANJA;
  end
  //受付電文の場合
  else if arg_MsgKind = G_MSGKIND_UKETUKE then begin
    //項目数設定
    Result := G_MSGFNUM_UKETUKE;
  end
  //実施電文の場合
  else if arg_MsgKind = G_MSGKIND_JISSI then begin
    //最大電文長取得
    Result := G_MSGFNUM_JISSI;
  end
  //会計電文の場合
  else if arg_MsgKind = G_MSGKIND_KAIKEI then begin
    //項目数設定
    Result := G_MSGFNUM_KAIKEI;
  end
  //再送電文の場合
  else if arg_MsgKind = G_MSGKIND_RESEND then begin
    //項目数設定
    Result := G_MSGFNUM_RESEND;
  end
  //それ以外の場合
  else begin
    //項目数設定
    Result := 0;
  end;
end;
//●電文定義情報をもとにストリームから文字列を取り出す
function func_GetStringStream(arg_System        : String;
                              arg_MsgKind       : String;
                              arg_TStringStream : TStringStream;
                              arg_index         : integer
                              ):string;
var
  w_offset:integer;
  w_size  :integer;
  w_StremField : TStreamField;
begin
   //初期値
   arg_TStringStream.Position := 0;
   //指定電文項目の情報取得
   w_StremField := func_FindMsgField(arg_System,arg_MsgKind,arg_index);
   //オフセット
   w_offset := w_StremField.offset;
   //サイズ
   w_size   := w_StremField.size;
   //ストリームをオフセット位置に移動
   arg_TStringStream.Position := w_offset;
   //文字の読み込み
   Result   := arg_TStringStream.ReadString(w_size);
   //処理終了
   Exit;
end;
//●電文定義情報をもとにストリームから文字列を取り出す（可変長の電文用）
function func_GetStringStream2(arg_System        : String;
                              arg_MsgKind       : String;
                              arg_TStringStream : TStringStream;
                              arg_index         : integer;
                              arg_Offset        : integer
                              ):string;
var
  w_offset:integer;
  w_size  :integer;
  w_StremField : TStreamField;
begin
   //初期値
   arg_TStringStream.Position := 0;
   //指定電文項目の情報取得
   w_StremField := func_FindMsgField(arg_System,arg_MsgKind,arg_index);
   //オフセット
   w_offset := arg_Offset;
   //サイズ
   w_size   := w_StremField.size;
   //ストリームをオフセット位置に移動
   arg_TStringStream.Position := w_offset;
   //文字の読み込み
   Result   := arg_TStringStream.ReadString(w_size);
   //処理終了
   Exit;
end;
//●電文定義情報をもとにストリームから文字列を取り出す（可変長のコメント用）
function func_GetStringStream3(arg_System        : String;
                               arg_MsgKind       : String;
                               arg_TStringStream : TStringStream;
                               arg_Offset        : integer;
                               arg_Size          : integer
                              ):string;
var
  w_offset:integer;
  w_size  :integer;
begin
   //初期値
   arg_TStringStream.Position := 0;
   //オフセット
   w_offset := arg_Offset;
   //サイズ
   w_size   := arg_Size;
   //ストリームをオフセット位置に移動
   arg_TStringStream.Position := w_offset;
   //文字の読み込み
   Result   := arg_TStringStream.ReadString(w_size);
   //処理終了
   Exit;
end;
//●電文定義情報をもとにストリームに文字列を設定する
procedure proc_SetStringStream(arg_System        : String;
                               arg_MsgKind       : String;
                               arg_TStringStream : TStringStream;
                               arg_index         : integer;
                               arg_string        : String
                               );
var
  w_offset:integer;
  w_size  :integer;
  w_len   :integer;
  w_StremField : TStreamField;
  w_s:String;
begin
   //初期値
   arg_TStringStream.Position := 0;
   //指定電文項目の情報取得
   w_StremField := func_FindMsgField(arg_System,arg_MsgKind,arg_index);
   //オフセット
   w_offset := w_StremField.offset;
   //サイズ
   w_size   := w_StremField.size;
   //ストリームをオフセット位置に移動
   arg_TStringStream.Position := w_offset;
   //文字列の長さを取得
   w_len      := length( arg_string );
   //文字列長がサイズより大きい場合
   if w_len >= w_size then begin
     //切り捨てる
     arg_string := copy(arg_string, 1,w_size);
   end
   //文字列長がサイズより小さい場合
   else begin
      //補完する
      //項目属性が"文字列"の場合
      if (Byte(w_StremField.x9[1]) = Byte(G_FIELD_C)) then begin
        //空白を補完
        arg_string := arg_string + StringOfChar(' ',w_size);
      end
      //項目属性が"数値"の場合
      else begin
        //"0"を補完
        arg_string := StringOfChar('0',w_size) + arg_string;
      end;
      //補完完了文字列の設定
      arg_string := copy(arg_string, 1,w_size);
   end;
   //オフセット + サイズとストリームのサイズの少ないほうに位置移動
   arg_TStringStream.Position := min((w_offset + w_size),arg_TStringStream.Size);
   //ストリームのサイズ - オフセット + サイズと"0"の大きいほうの分だけ読み込む
   w_s := arg_TStringStream.ReadString(max((arg_TStringStream.Size - (w_offset + w_size)),0));
   //オフセットの位置に移動
   arg_TStringStream.Position := w_offset;
   //指定の位置に指定文字列と前にあった文字列を追加
   arg_TStringStream.WriteString(arg_string+w_s);

   Exit;
end;
//●電文定義情報をもとにストリームに文字列を設定する(可変長用)
procedure proc_SetStringStream2(arg_System        : String;
                                arg_MsgKind       : String;
                                arg_TStringStream : TStringStream;
                                arg_index         : integer;
                                arg_Offset        : integer;
                                arg_string        : String
                                );
var
  w_offset:integer;
  w_size  :integer;
  w_len   :integer;
  w_StremField : TStreamField;
  w_s:String;
begin
   //初期値
   arg_TStringStream.Position := 0;
   //指定電文項目の情報取得
   w_StremField := func_FindMsgField(arg_System,arg_MsgKind,arg_index);
   //オフセット
   w_offset := arg_Offset;
   //サイズ
   w_size   := w_StremField.size;
   //ストリームをオフセット位置に移動
   arg_TStringStream.Position := w_offset;
   //文字列の長さを取得
   w_len      := length( arg_string );
   //文字列長がサイズより大きい場合
   if w_len >= w_size then begin
     //切り捨てる
     arg_string := copy(arg_string, 1,w_size);
   end
   //文字列長がサイズより小さい場合
   else begin
      //補完する
      //項目属性が"文字列"の場合
      if (Byte(w_StremField.x9[1]) = Byte(G_FIELD_C)) then begin
        //空白を補完
        arg_string := arg_string + StringOfChar(' ',w_size);
      end
      //項目属性が"数値"の場合
      else begin
        //"0"を補完
        arg_string := StringOfChar('0',w_size) + arg_string;
      end;
      //補完完了文字列の設定
      arg_string := copy(arg_string, 1,w_size);
   end;
   //オフセット + サイズとストリームのサイズの少ないほうに位置移動
   arg_TStringStream.Position := min((w_offset + w_size),arg_TStringStream.Size);
   //ストリームのサイズ - オフセット + サイズと"0"の大きいほうの分だけ読み込む
   w_s := arg_TStringStream.ReadString(max((arg_TStringStream.Size - (w_offset + w_size)),0));
   //オフセットの位置に移動
   arg_TStringStream.Position := w_offset;
   //指定の位置に指定文字列と前にあった文字列を追加
   arg_TStringStream.WriteString(arg_string+w_s);

   Exit;
end;
//●電文定義情報をもとにストリームにクリア設定する
procedure  proc_ClearStream(
           arg_System        : string;
           arg_MsgKind       : string;
           arg_TStringStream : TStringStream
           );
var
 w_i:integer;
 w_len:integer;
 w_s:string;
 w_MsgDeflen:integer;
 w_Msglen:integer;
 w_StremField : TStreamField;
begin
  try
    //電文種別の項目数を求める
    w_MsgDeflen := func_MsgDefLen( arg_System, arg_MsgKind );
    //項目数がない場合
    if w_MsgDeflen=0 then begin
      //処理終了
      Exit;
    end;
    //電文長を調べる
    w_Msglen := func_MsgLen( arg_System, arg_MsgKind );
    //電文長を取得
    if w_Msglen=0 then begin
      //処理終了
      Exit;
    end;
    //一ラインずつ展開
    arg_TStringStream.Position := 0;
    //項目数分ループ
    for w_i := 1 to w_MsgDeflen do begin
      //電文長項目の場合
      if w_i = COMMON1DENLENNO then begin
        //サイズ設定
        w_s := FormatFloat('000000', w_Msglen);
      end
      //それ以外の項目の場合
      else begin
        //項目情報取得
        w_StremField := func_FindMsgField(arg_System,arg_MsgKind,w_i);
        //項目サイズ取得
        w_len := w_StremField.size;
        //文字列項目の場合
        if (Byte(w_StremField.x9[1]) = Byte(G_FIELD_C)) then begin
          //スペース埋め
          w_s := StringOfChar(' ',w_len);
        end
        //数値項目の場合
        else begin
          //ゼロ埋め
          w_s := StringOfChar('0',w_len) ;
        end;
      end;
      //データの書き込み
      arg_TStringStream.WriteString(w_s);
    end;
    //処理終了
    Exit;
//①<<----
  except
    //初期化
    arg_TStringStream.Position := 0;
    //処理終了
    Exit;
//①<<----
  end;

end;
//●電文定義情報をもとにストリームにクリア設定する
procedure  proc_ClearStream2(
           arg_System        : string;
           arg_MsgKind       : string;
           arg_TStringStream : TStringStream
           );
var
 w_i:integer;
 w_len:integer;
 w_s:string;
 w_MsgDeflen:integer;
 w_Msglen:integer;
 w_StremField : TStreamField;
begin
  try
    //電文種別の項目数を求める
    w_MsgDeflen := func_MsgDefLen( arg_System, arg_MsgKind );
    //項目数がない場合
    if w_MsgDeflen=0 then begin
      //処理終了
      Exit;
    end;
    //電文長を調べる
    w_Msglen := func_MsgLen( arg_System, arg_MsgKind );
    //電文長を取得
    if w_Msglen=0 then begin
      //処理終了
      Exit;
    end;
    //一ラインずつ展開
    arg_TStringStream.Position := 0;
    //項目数分ループ
    for w_i := 1 to w_MsgDeflen do begin
      if w_i > JISSIMEISAICOUNTNO then
        Break;
      //電文長項目の場合
      if w_i = COMMON1DENLENNO then begin
        //サイズ設定
        w_s := FormatFloat('000000', w_Msglen);
      end
      //それ以外の項目の場合
      else begin
        //項目情報取得
        w_StremField := func_FindMsgField(arg_System,arg_MsgKind,w_i);
        //項目サイズ取得
        w_len := w_StremField.size;
        //文字列項目の場合
        if (Byte(w_StremField.x9[1]) = Byte(G_FIELD_C)) then begin
          //スペース埋め
          w_s := StringOfChar(' ',w_len);
        end
        //数値項目の場合
        else begin
          //ゼロ埋め
          w_s := StringOfChar('0',w_len) ;
        end;
      end;
      //データの書き込み
      arg_TStringStream.WriteString(w_s);
    end;
    //処理終了
    Exit;
//①<<----
  except
    //初期化
    arg_TStringStream.Position := 0;
    //処理終了
    Exit;
//①<<----
  end;

end;
//●ストリームをクリア
procedure  proc_ClearStream3(
           arg_MaxLen        : Integer;
           arg_TStringStream : TStringStream
           );
var
 w_s:string;
begin
  try
    w_s := func_LeftSpace(arg_MaxLen,w_s);
    //データの書き込み
    arg_TStringStream.WriteString(w_s);
    //処理終了
    Exit;
//①<<----
  except
    //初期化
    arg_TStringStream.Position := 0;
    //処理終了
    Exit;
//①<<----
  end;

end;
//●電文定義情報をもとにストリームに固定デフォルト文字列を設定する
procedure proc_SetStreamHDDef(arg_System        : string;
                              arg_MsgKind       : string;
                              arg_TStringStream : TStringStream
                              );
begin
  //返信電文の場合
  if arg_MsgKind = G_MSGKIND_START then
  begin
    //送信先項目"RIS"固定
    proc_SetStringStream(arg_System, arg_MsgKind, arg_TStringStream,
                         COMMON1SDIDNO, CST_SENDTO);
    //送信元項目"HIS"固定
    proc_SetStringStream(arg_System, arg_MsgKind, arg_TStringStream,
                         COMMON1RVIDNO, CST_FROMTO);
  end;
  //受付・キャンセル電文の場合
  if arg_MsgKind = G_MSGKIND_UKETUKE then
  begin
    //送信先項目"RIS"固定
    proc_SetStringStream(arg_System, arg_MsgKind, arg_TStringStream,
                         COMMON1SDIDNO, CST_SENDTO);
    //送信元項目"HIS"固定
    proc_SetStringStream(arg_System, arg_MsgKind, arg_TStringStream,
                         COMMON1RVIDNO, CST_FROMTO);
    //コマンド名項目
    proc_SetStringStream(arg_System, arg_MsgKind, arg_TStringStream,
                         COMMON1COMMANDNO, CST_COMMAND_UKETUKE);
    //結果項目
    proc_SetStringStream(arg_System, arg_MsgKind, arg_TStringStream,
                         COMMON1STATUSNO, CST_DENBUNID_OK);
    //病院コード項目
    proc_SetStringStream(arg_System, arg_MsgKind, arg_TStringStream,
                         RECHOSPCODENO, '01');
  end;
  //実施電文の場合
  if arg_MsgKind = G_MSGKIND_JISSI then
  begin
    //送信先項目"RIS"固定
    proc_SetStringStream(arg_System, arg_MsgKind, arg_TStringStream,
                         COMMON1SDIDNO, CST_SENDTO);
    //送信元項目"HIS"固定
    proc_SetStringStream(arg_System, arg_MsgKind, arg_TStringStream,
                         COMMON1RVIDNO, CST_FROMTO);
    //コマンド名項目
    proc_SetStringStream(arg_System, arg_MsgKind, arg_TStringStream,
                         COMMON1COMMANDNO, CST_COMMAND_JISSI);
    //結果項目
    proc_SetStringStream(arg_System, arg_MsgKind, arg_TStringStream,
                         COMMON1STATUSNO, CST_DENBUNID_OK);
    //病院コード項目
    proc_SetStringStream(arg_System, arg_MsgKind, arg_TStringStream,
                         JISSIHOSPCODENO, '01');
  end;
  //返信電文の場合
  if arg_MsgKind = G_MSGKIND_RESEND then
  begin
    //送信先項目"RIS"固定
    proc_SetStringStream(arg_System, arg_MsgKind, arg_TStringStream,
                         COMMON1SDIDNO, CST_SENDTO);
    //送信元項目"HIS"固定
    proc_SetStringStream(arg_System, arg_MsgKind, arg_TStringStream,
                         COMMON1RVIDNO, CST_FROMTO);
  end;
{
  //セッション開始・終了の場合
  if arg_MsgKind = G_MSGKIND_START then
  begin
    //ログモード項目"0"固定
    proc_SetStringStream(arg_System, arg_MsgKind, arg_TStringStream,
                         COMMON1LOGMODENO, '0');
    //着側AP_ID項目"      "固定
    proc_SetStringStream(arg_System, arg_MsgKind, arg_TStringStream,
                         COMMON1RVIDNO, '      ');
    //発側AP_ID項目"      "固定
    proc_SetStringStream(arg_System, arg_MsgKind, arg_TStringStream,
                         COMMON1SDIDNO, '      ');
    //電文長項目"000064"固定
    proc_SetStringStream(arg_System, arg_MsgKind, arg_TStringStream,
                         COMMON1DENLENNO, func_LeftZero(6,
                         IntToStr(G_MSGSIZE_START)));
    //継続フラグ項目"0"固定
    proc_SetStringStream(arg_System, arg_MsgKind, arg_TStringStream,
                         COMMON1CONTINUENO,'0');
  end;
  //実施電文の場合
  if arg_MsgKind = G_MSGKIND_JISSI then
  begin
    //電文ID項目"SM"固定
    proc_SetStringStream(arg_System, arg_MsgKind, arg_TStringStream,
                         COMMON1DENBUNIDNO, CST_DENBUNID_SD);
    //ログモード項目"0"固定
    proc_SetStringStream(arg_System, arg_MsgKind, arg_TStringStream,
                         COMMON1LOGMODENO, '0');
    //内容コード項目"0"固定
    proc_SetStringStream(arg_System, arg_MsgKind, arg_TStringStream,
                         COMMON1NAIYONO, '00');
    //着側AP_ID項目"      "固定
    proc_SetStringStream(arg_System, arg_MsgKind, arg_TStringStream,
                         COMMON1RVIDNO, '      ');
    //発側AP_ID項目"      "固定
    proc_SetStringStream(arg_System, arg_MsgKind, arg_TStringStream,
                         COMMON1SDIDNO, '      ');
    //病院コード項目"01"固定
    proc_SetStringStream(arg_System, arg_MsgKind, arg_TStringStream,
                         JISSIHOSPCODENO, CST_HOSPCODE);
  end;
  //会計電文の場合
  if arg_MsgKind = G_MSGKIND_KAIKEI then
  begin
    //電文ID項目"SM"固定
    proc_SetStringStream(arg_System, arg_MsgKind, arg_TStringStream,
                         COMMON1DENBUNIDNO, CST_DENBUNID_SD);
    //ログモード項目"0"固定
    proc_SetStringStream(arg_System, arg_MsgKind, arg_TStringStream,
                         COMMON1LOGMODENO, '0');
    //内容コード項目"0"固定
    proc_SetStringStream(arg_System, arg_MsgKind, arg_TStringStream,
                         COMMON1NAIYONO, '00');
    //着側AP_ID項目"      "固定
    proc_SetStringStream(arg_System, arg_MsgKind, arg_TStringStream,
                         COMMON1RVIDNO, '      ');
    //発側AP_ID項目"      "固定
    proc_SetStringStream(arg_System, arg_MsgKind, arg_TStringStream,
                         COMMON1SDIDNO, '      ');
    //継続フラグ項目"0"固定
    proc_SetStringStream(arg_System, arg_MsgKind, arg_TStringStream,
                         COMMON1CONTINUENO, '0');
    //病院コード項目"01"固定
    proc_SetStringStream(arg_System, arg_MsgKind, arg_TStringStream,
                         RECHOSPCODENO, CST_HOSPCODE);
  end;
  }
end;
{
-----------------------------------------------------------------------------
  名前 : proc_TStrmToStrlist;
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
           arg_TStringList   : TStringList  ;
           arg_System        : string;
           arg_MsgKind       : string
           );
begin
  //放射線系電文の場合
  if arg_MsgKind <> G_MSGKIND_JISSI then
    //ストリームからストリングリストへ
    proc_TStrmToStrlist_H_Irai(arg_TStringStream,arg_TStringList,arg_System,arg_MsgKind)
  else
    proc_TStrmToStrlist_H_Jissi(arg_TStringStream,arg_TStringList,arg_System,arg_MsgKind);
  //処理終了
  Exit;
end;
{
-----------------------------------------------------------------------------
  名前 : proc_TStrmToStrlist_H_Irai;
  引数 :
  arg_TStringList:TStringList      元
  arg_TStringList   : TStringList  先
  arg_System        : string;      種類
  arg_MsgKind       : string       種別

  機能 : TStringStreamより解析してTStringListを作成する
  復帰値：
-----------------------------------------------------------------------------
}
procedure proc_TStrmToStrlist_H_Irai(
           arg_TStringStream : TStringStream;
           arg_TStringList   : TStringList  ;
           arg_System        : string;
           arg_MsgKind       : string
           );
var
  w_i:integer;
  w_MaxDefLen:integer;
  w_offset:integer;
  w_size  :integer;
  w_s:string;
  w_FieldName:string;
  w_StremField : TStreamField;
  w_Kmk:integer;
  w_Kmk_Count:integer;
  w_Kind:String;
  wm_Offset:Integer;
  wm_DataMokutekiComLen:String;
  wm_DataSijiComLen:String;
  wm_DataSonotaComLen:String;
  wm_DataByoumeiComLen:String;
//  wm_DataDokueiComLen:String;
  wm_ComOffset:Integer;
  wi_MeisaiCount:Integer;
  w_Loop_Meisai:Integer;
  ws_RecKbn:String;
  w_Kmk_SyoriCount:Integer;
begin
//TStringStream→TStringListに展開
  //初期値
  arg_TStringList.Text := '';
  //初期化
  arg_TStringList.Clear;
  //初期位置に移動
  arg_TStringStream.Position := 0;
  //項目数を取得
  w_MaxDefLen := func_MsgDefLen(arg_System,arg_MsgKind);

  //初期化
  w_Kmk         := 0;
  w_Kmk_Count   := 0;
  w_offset      := 0;
  w_Kind        := arg_MsgKind;
  w_Kmk_SyoriCount := 0;
  wm_ComOffset := 0;
  //項目数分作成
  for w_i := 1 to w_MaxDefLen do begin
    //依頼情報電文の場合
    if w_Kind = G_MSGKIND_IRAI then begin
      case w_i of
        //グループ数項目
        CST_IRAI_LOOPSTART:
        begin
          //グループ数項目取得
          w_s := func_GetStringStream(arg_System,w_Kind,arg_TStringStream,CST_IRAI_LOOPSTART);
          //受信項目の情報取得
          w_StremField := func_FindMsgField(arg_System,w_Kind,CST_IRAI_LOOPSTART);
          //グループ数項目が数値の場合
          if func_IsNumber(w_s) then
            //グループ数項目取得
            w_Kmk := StrToInt(w_s)
          else
            //グループ数項目なし
            w_Kmk := 0;
          //項目の最大数以上の場合
          if w_Kmk > CST_GROUP_LOOP_MAX then
            //項目の最大数に設定
            w_Kmk := CST_GROUP_LOOP_MAX;
        end;
      end;
      if (IRAIMOKUTEKILENNO <= w_i) and
         (IRAIBYOUMEINO >= w_i)   then
      begin
        //検査目的長
        if IRAIMOKUTEKILENNO = w_i then begin
          //検査目的長までのオフセットを取得
          w_StremField := func_FindMsgField(arg_System, w_Kind, IRAIMOKUTEKILENNO);
          if wm_ComOffset = 0 then
          begin
            //オフセットを設定
            wm_Offset := w_StremField.offset;
            //項目コード開始オフセット位置
            wm_ComOffset := wm_Offset;
          end;
          //電文：検査目的長の取得
          wm_DataMokutekiComLen := '';
          wm_DataMokutekiComLen := func_GetStringStream3(arg_System, w_Kind,
                                                         arg_TStringStream,
                                                         wm_ComOffset,
                                                         IRAIMOKUTEKILENLEN);
          w_s := wm_DataMokutekiComLen;
          //半角ブランクの削除
          wm_DataMokutekiComLen := TrimRight(wm_DataMokutekiComLen);
          //オフセット位置の移動
          wm_ComOffset := wm_ComOffset + IRAIMOKUTEKILENLEN;
          if arg_System <> CST_NON_TITLE then
            //設定 値と名前
            arg_TStringList.Add( w_s + '<:>' + w_StremField.name)
          else
            //設定 値と名前
            arg_TStringList.Add(w_s);
          Continue;
        end
        else
        //検査目的
        if IRAIMOKUTEKINO = w_i then begin
          //検査目的長までのオフセットを取得
          w_StremField := func_FindMsgField(arg_System, w_Kind, IRAIMOKUTEKINO);
          if wm_ComOffset = 0 then
          begin
            //オフセットを設定
            wm_Offset := w_StremField.offset;
            //項目コード開始オフセット位置
            wm_ComOffset := wm_Offset;
          end;
          //電文：検査目的の取得
          w_s := '';
          w_s := func_GetStringStream3(arg_System, w_Kind,
                                                arg_TStringStream,
                                                wm_ComOffset,
                                       StrToIntDef(wm_DataMokutekiComLen, 0));
          //オフセット位置の移動
          wm_ComOffset := wm_ComOffset + StrToIntDef(wm_DataMokutekiComLen, 0);
          if arg_System <> CST_NON_TITLE then
            //設定 値と名前
            arg_TStringList.Add( w_s + '<:>' + w_StremField.name)
          else
            //設定 値と名前
            arg_TStringList.Add(w_s);
          Continue;
        end
        else
        //特別指示長
        if IRAISIJILENNO = w_i then begin
          //特別指示長の名称を取得
          w_StremField := func_FindMsgField(arg_System, w_Kind, IRAISIJILENNO);
          if wm_ComOffset = 0 then
          begin
            //オフセットを設定
            wm_Offset := w_StremField.offset;
            //項目コード開始オフセット位置
            wm_ComOffset := wm_Offset;
          end;
          //電文：特別指示長の取得
          wm_DataSijiComLen := '';
          wm_DataSijiComLen := func_GetStringStream3(arg_System, w_Kind,
                                                     arg_TStringStream,
                                                     wm_ComOffset, IRAISIJILENLEN);
          w_s := wm_DataSijiComLen;
          //半角ブランクの削除
          wm_DataSijiComLen := TrimRight(wm_DataSijiComLen);
          //オフセット位置の移動
          wm_ComOffset := wm_ComOffset + IRAISIJILENLEN;
          if arg_System <> CST_NON_TITLE then
            //設定 値と名前
            arg_TStringList.Add( w_s + '<:>' + w_StremField.name)
          else
            //設定 値と名前
            arg_TStringList.Add(w_s);
          Continue;
        end
        else
        //特別指示
        if IRAISIJINO = w_i then begin
          //特別指示の名称を取得
          w_StremField := func_FindMsgField(arg_System, w_Kind, IRAISIJINO);
          if wm_ComOffset = 0 then
          begin
            //オフセットを設定
            wm_Offset := w_StremField.offset;
            //項目コード開始オフセット位置
            wm_ComOffset := wm_Offset;
          end;
          //電文：特別指示の取得
          w_s := '';
          w_s := func_GetStringStream3(arg_System, w_Kind,
                                                  arg_TStringStream, wm_ComOffset,
                                                 StrToIntDef(wm_DataSijiComLen, 0));
          //オフセット位置の移動
          wm_ComOffset := wm_ComOffset + StrToIntDef(wm_DataSijiComLen, 0);
          if arg_System <> CST_NON_TITLE then
            //設定 値と名前
            arg_TStringList.Add( w_s + '<:>' + w_StremField.name)
          else
            //設定 値と名前
            arg_TStringList.Add(w_s);
          Continue;
        end
        else
        //その他詳細長
        if IRAISONOTALENNO = w_i then begin
          //その他詳細長の名称を取得
          w_StremField := func_FindMsgField(arg_System, w_Kind, IRAISONOTALENNO);
          if wm_ComOffset = 0 then
          begin
            //オフセットを設定
            wm_Offset := w_StremField.offset;
            //項目コード開始オフセット位置
            wm_ComOffset := wm_Offset;
          end;
          //電文：その他詳細長の取得
          wm_DataSonotaComLen := '';
          wm_DataSonotaComLen := func_GetStringStream3(arg_System, w_Kind,
                                                       arg_TStringStream,
                                                       wm_ComOffset,
                                                       IRAISONOTALENLEN);
          w_s := wm_DataSonotaComLen;
          //半角ブランクの削除
          wm_DataSonotaComLen := TrimRight(wm_DataSonotaComLen);
          //オフセット位置の移動
          wm_ComOffset := wm_ComOffset + IRAISONOTALENLEN;
          if arg_System <> CST_NON_TITLE then
            //設定 値と名前
            arg_TStringList.Add( w_s + '<:>' + w_StremField.name)
          else
            //設定 値と名前
            arg_TStringList.Add(w_s);
          Continue;
        end
        else
        //その他詳細
        if IRAISONOTANO = w_i then begin
          //その他詳細の名称を取得
          w_StremField := func_FindMsgField(arg_System, w_Kind, IRAISONOTANO);
          if wm_ComOffset = 0 then
          begin
            //オフセットを設定
            wm_Offset := w_StremField.offset;
            //項目コード開始オフセット位置
            wm_ComOffset := wm_Offset;
          end;
          //電文：その他詳細の取得
          w_s := '';
          w_s := func_GetStringStream3(arg_System, w_Kind,
                                                    arg_TStringStream, wm_ComOffset,
                                               StrToIntDef(wm_DataSonotaComLen, 0));
          //オフセット位置の移動
          wm_ComOffset := wm_ComOffset + StrToIntDef(wm_DataSonotaComLen, 0);
          if arg_System <> CST_NON_TITLE then
            //設定 値と名前
            arg_TStringList.Add( w_s + '<:>' + w_StremField.name)
          else
            //設定 値と名前
            arg_TStringList.Add(w_s);
          Continue;
        end
        else
        //依頼時病名長
        if IRAIBYOUMEILENNO = w_i then begin
          //依頼時病名長の名称を取得
          w_StremField := func_FindMsgField(arg_System, w_Kind, IRAIBYOUMEILENNO);
          if wm_ComOffset = 0 then
          begin
            //オフセットを設定
            wm_Offset := w_StremField.offset;
            //項目コード開始オフセット位置
            wm_ComOffset := wm_Offset;
          end;
          //電文：依頼時病名長の取得
          wm_DataByoumeiComLen := '';
          wm_DataByoumeiComLen := func_GetStringStream3(arg_System, w_Kind,
                                                        arg_TStringStream,
                                                        wm_ComOffset,
                                                        IRAIBYOUMEILENLEN);
          w_s := wm_DataByoumeiComLen;
          //半角ブランクの削除
          wm_DataByoumeiComLen := TrimRight(wm_DataByoumeiComLen);
          //オフセット位置の移動
          wm_ComOffset := wm_ComOffset + IRAIBYOUMEILENLEN;
          if arg_System <> CST_NON_TITLE then
            //設定 値と名前
            arg_TStringList.Add( w_s + '<:>' + w_StremField.name)
          else
            //設定 値と名前
            arg_TStringList.Add(w_s);
          Continue;
        end
        else
        //依頼時病名
        if IRAIBYOUMEINO = w_i then begin
          //依頼時病名の名称を取得
          w_StremField := func_FindMsgField(arg_System, w_Kind, IRAIBYOUMEINO);
          if wm_ComOffset = 0 then
          begin
            //オフセットを設定
            wm_Offset := w_StremField.offset;
            //項目コード開始オフセット位置
            wm_ComOffset := wm_Offset;
          end;
          //電文：依頼時病名の取得
          w_s := '';
          w_s := func_GetStringStream3(arg_System, w_Kind,
                                                     arg_TStringStream,
                                                     wm_ComOffset,
                                              StrToIntDef(wm_DataByoumeiComLen, 0));
          //オフセット位置の移動
          wm_ComOffset := wm_ComOffset + StrToIntDef(wm_DataByoumeiComLen, 0);
          if arg_System <> CST_NON_TITLE then
            //設定 値と名前
            arg_TStringList.Add( w_s + '<:>' + w_StremField.name)
          else
            //設定 値と名前
            arg_TStringList.Add(w_s);
          Continue;
        end;
      end;
      //ループ開始になった場合
      if IRAIGROUPNO <= w_i then begin
        //項目個数がある場合
        if w_Kmk > 0 then begin
          //初期の場合
          if w_Kmk_Count = 0 then begin
            //グループ番号位置
            w_Kmk_Count := IRAIGROUPNO;
          end;

          inc(w_Kmk_SyoriCount);

          //電文：グループ番号の取得
          w_s := func_GetStringStream2(arg_System,w_Kind,arg_TStringStream,
                                       IRAIGROUPNO,wm_ComOffset);
          //グループ番号の長さを取得
          w_StremField := func_FindMsgField(arg_System, w_Kind, IRAIGROUPNO);
          //オフセット位置の移動
          wm_ComOffset := wm_ComOffset + w_StremField.size;

          if arg_System <> CST_NON_TITLE then
            //設定 値と名前
            arg_TStringList.Add( w_s + '<:>' + w_StremField.name)
          else
            //設定 値と名前
            arg_TStringList.Add(w_s);

          //電文：オーダ進捗の取得
          w_s := func_GetStringStream2(arg_System,w_Kind,arg_TStringStream,
                                       IRAIORDERSTATUSNO,wm_ComOffset);
          //オーダ進捗の長さを取得
          w_StremField := func_FindMsgField(arg_System, w_Kind,
                                            IRAIORDERSTATUSNO);
          //オフセット位置の移動
          wm_ComOffset := wm_ComOffset + w_StremField.size;

          if arg_System <> CST_NON_TITLE then
            //設定 値と名前
            arg_TStringList.Add( w_s + '<:>' + w_StremField.name)
          else
            //設定 値と名前
            arg_TStringList.Add(w_s);

          //電文：会計進捗の取得
          w_s := func_GetStringStream2(arg_System,w_Kind,arg_TStringStream,
                                       IRAIACCOUNTSTATUSNO,wm_ComOffset);
          //会計進捗の長さを取得
          w_StremField := func_FindMsgField(arg_System, w_Kind,
                                            IRAIACCOUNTSTATUSNO);
          //オフセット位置の移動
          wm_ComOffset := wm_ComOffset + w_StremField.size;

          if arg_System <> CST_NON_TITLE then
            //設定 値と名前
            arg_TStringList.Add( w_s + '<:>' + w_StremField.name)
          else
            //設定 値と名前
            arg_TStringList.Add(w_s);

          //電文：実施日の取得
          w_s := func_GetStringStream2(arg_System,w_Kind,arg_TStringStream,
                                       IRAIORDEREXDATENO,wm_ComOffset);
          //実施日の長さを取得
          w_StremField := func_FindMsgField(arg_System, w_Kind,
                                            IRAIORDEREXDATENO);
          //オフセット位置の移動
          wm_ComOffset := wm_ComOffset + w_StremField.size;

          if arg_System <> CST_NON_TITLE then
            //設定 値と名前
            arg_TStringList.Add( w_s + '<:>' + w_StremField.name)
          else
            //設定 値と名前
            arg_TStringList.Add(w_s);

          //電文：実施時間の取得
          w_s := func_GetStringStream2(arg_System,w_Kind,arg_TStringStream,
                                       IRAIORDEREXTIMENO,wm_ComOffset);
          //実施時間の長さを取得
          w_StremField := func_FindMsgField(arg_System, w_Kind,
                                            IRAIORDEREXTIMENO);
          //オフセット位置の移動
          wm_ComOffset := wm_ComOffset + w_StremField.size;

          if arg_System <> CST_NON_TITLE then
            //設定 値と名前
            arg_TStringList.Add( w_s + '<:>' + w_StremField.name)
          else
            //設定 値と名前
            arg_TStringList.Add(w_s);

          //電文：項目コードの取得
          w_s := func_GetStringStream2(arg_System,w_Kind,arg_TStringStream,
                                       IRAIKOUMOKUCODENO,wm_ComOffset);
          //項目コードの長さを取得
          w_StremField := func_FindMsgField(arg_System, w_Kind,
                                            IRAIKOUMOKUCODENO);
          //オフセット位置の移動
          wm_ComOffset := wm_ComOffset + w_StremField.size;

          if arg_System <> CST_NON_TITLE then
            //設定 値と名前
            arg_TStringList.Add( w_s + '<:>' + w_StremField.name)
          else
            //設定 値と名前
            arg_TStringList.Add(w_s);

          //電文：項目名称の取得
          w_s := func_GetStringStream2(arg_System,w_Kind,arg_TStringStream,
                                       IRAIKOUMOKUNAMENO,wm_ComOffset);
          //項目名称の長さを取得
          w_StremField := func_FindMsgField(arg_System, w_Kind,
                                            IRAIKOUMOKUNAMENO);
          //オフセット位置の移動
          wm_ComOffset := wm_ComOffset + w_StremField.size;

          if arg_System <> CST_NON_TITLE then
            //設定 値と名前
            arg_TStringList.Add( w_s + '<:>' + w_StremField.name)
          else
            //設定 値と名前
            arg_TStringList.Add(w_s);

          //電文：撮影種コードの取得
          w_s := func_GetStringStream2(arg_System,w_Kind,arg_TStringStream,
                                       IRAIORDERSYUCODENO,wm_ComOffset);
          //撮影種コードの長さを取得
          w_StremField := func_FindMsgField(arg_System, w_Kind,
                                            IRAIORDERSYUCODENO);
          //オフセット位置の移動
          wm_ComOffset := wm_ComOffset + w_StremField.size;

          if arg_System <> CST_NON_TITLE then
            //設定 値と名前
            arg_TStringList.Add( w_s + '<:>' + w_StremField.name)
          else
            //設定 値と名前
            arg_TStringList.Add(w_s);

          //電文：撮影種名称の取得
          w_s := func_GetStringStream2(arg_System,w_Kind,arg_TStringStream,
                                       IRAIORDERSYUNAMENO,wm_ComOffset);
          //撮影種名称の長さを取得
          w_StremField := func_FindMsgField(arg_System, w_Kind,
                                            IRAIORDERSYUNAMENO);
          //オフセット位置の移動
          wm_ComOffset := wm_ComOffset + w_StremField.size;

          if arg_System <> CST_NON_TITLE then
            //設定 値と名前
            arg_TStringList.Add( w_s + '<:>' + w_StremField.name)
          else
            //設定 値と名前
            arg_TStringList.Add(w_s);

          //電文：部位コードの取得
          w_s := func_GetStringStream2(arg_System,w_Kind,arg_TStringStream,
                                       IRAIBUICODENO,wm_ComOffset);
          //部位コードの長さを取得
          w_StremField := func_FindMsgField(arg_System, w_Kind, IRAIBUICODENO);
          //オフセット位置の移動
          wm_ComOffset := wm_ComOffset + w_StremField.size;

          if arg_System <> CST_NON_TITLE then
            //設定 値と名前
            arg_TStringList.Add( w_s + '<:>' + w_StremField.name)
          else
            //設定 値と名前
            arg_TStringList.Add(w_s);

          //電文：部位名称の取得
          w_s := func_GetStringStream2(arg_System,w_Kind,arg_TStringStream,
                                       IRAIBUINAMENO,wm_ComOffset);
          //部位名称の長さを取得
          w_StremField := func_FindMsgField(arg_System, w_Kind, IRAIBUINAMENO);
          //オフセット位置の移動
          wm_ComOffset := wm_ComOffset + w_StremField.size;

          if arg_System <> CST_NON_TITLE then
            //設定 値と名前
            arg_TStringList.Add( w_s + '<:>' + w_StremField.name)
          else
            //設定 値と名前
            arg_TStringList.Add(w_s);

          //電文：検査室コードの取得
          w_s := func_GetStringStream2(arg_System,w_Kind,arg_TStringStream,
                                       IRAIKENSAROOMCODENO,wm_ComOffset);
          //検査室コードの長さを取得
          w_StremField := func_FindMsgField(arg_System, w_Kind,
                                            IRAIKENSAROOMCODENO);
          //オフセット位置の移動
          wm_ComOffset := wm_ComOffset + w_StremField.size;

          if arg_System <> CST_NON_TITLE then
            //設定 値と名前
            arg_TStringList.Add( w_s + '<:>' + w_StremField.name)
          else
            //設定 値と名前
            arg_TStringList.Add(w_s);

          //電文：検査室名称の取得
          w_s := func_GetStringStream2(arg_System,w_Kind,arg_TStringStream,
                                       IRAIKENSAROOMNAMENO,wm_ComOffset);
          //検査室名称の長さを取得
          w_StremField := func_FindMsgField(arg_System, w_Kind,
                                            IRAIKENSAROOMNAMENO);
          //オフセット位置の移動
          wm_ComOffset := wm_ComOffset + w_StremField.size;

          if arg_System <> CST_NON_TITLE then
            //設定 値と名前
            arg_TStringList.Add( w_s + '<:>' + w_StremField.name)
          else
            //設定 値と名前
            arg_TStringList.Add(w_s);

          //電文：明細数の取得
          w_s := func_GetStringStream2(arg_System,w_Kind,arg_TStringStream,
                                       IRAIMEISAICOUNTNO,wm_ComOffset);
          //明細数の長さを取得
          w_StremField := func_FindMsgField(arg_System, w_Kind,
                                            IRAIMEISAICOUNTNO);
          //オフセット位置の移動
          wm_ComOffset := wm_ComOffset + w_StremField.size;
          //明細数数値化
          wi_MeisaiCount := StrToIntDef(Trim(w_s),0);

          if arg_System <> CST_NON_TITLE then
            //設定 値と名前
            arg_TStringList.Add( w_s + '<:>' + w_StremField.name)
          else
            //設定 値と名前
            arg_TStringList.Add(w_s);

          for w_Loop_Meisai := 0 to wi_MeisaiCount - 1 do
          begin
            //電文：レコード区分の取得
            w_s := func_GetStringStream2(arg_System, w_Kind, arg_TStringStream,
                                         IRAIYRECKBNNO, wm_ComOffset);
            //半角ブランクの削除
            ws_RecKbn := TrimRight(w_s);
            //レコード区分の長さを取得
            w_StremField := func_FindMsgField(arg_System, w_Kind,
                                              IRAIYRECKBNNO);
            //オフセット位置の移動
            wm_ComOffset := wm_ComOffset + w_StremField.size;

            //薬剤・手技・材料・フィルム
            if (ws_RecKbn = CST_RECORD_KBN_20) or
               (ws_RecKbn = CST_RECORD_KBN_30) or
               (ws_RecKbn = CST_RECORD_KBN_50) or
               (ws_RecKbn = CST_RECORD_KBN_57) then
            begin
              //レコード区分のタイトルを取得
              w_StremField := func_FindMsgField(arg_System, w_Kind,
                                                IRAIYRECKBNNO);
              if arg_System <> CST_NON_TITLE then
                //設定 値と名前
                arg_TStringList.Add( w_s + '<:>' + w_StremField.name)
              else
                //設定 値と名前
                arg_TStringList.Add(w_s);

              w_Kmk_Count := IRAIYKMKCODENO;
            end
            //選択コメント・必須コメント・フリーコメント
            else if (ws_RecKbn = CST_RECORD_KBN_97) or
                    (ws_RecKbn = CST_RECORD_KBN_98) or
                    (ws_RecKbn = CST_RECORD_KBN_99) then
            begin
              //レコード区分のタイトルを取得
              w_StremField := func_FindMsgField(arg_System, w_Kind,
                                                IRAICRECKBNNO);
              if arg_System <> CST_NON_TITLE then
                //設定 値と名前
                arg_TStringList.Add( w_s + '<:>' + w_StremField.name)
              else
                //設定 値と名前
                arg_TStringList.Add(w_s);

              w_Kmk_Count := IRAICKMKCODENO;
            end
            //シェーマ
            else if ws_RecKbn = CST_RECORD_KBN_95 then
            begin
              //レコード区分のタイトルを取得
              w_StremField := func_FindMsgField(arg_System, w_Kind,
                                                IRAISRECKBNNO);
              if arg_System <> CST_NON_TITLE then
                //設定 値と名前
                arg_TStringList.Add( w_s + '<:>' + w_StremField.name)
              else
                //設定 値と名前
                arg_TStringList.Add(w_s);

              w_Kmk_Count := IRAISINFONO;
            end;
            //薬剤・手技・材料・フィルム
            if (ws_RecKbn = CST_RECORD_KBN_20) or
               (ws_RecKbn = CST_RECORD_KBN_30) or
               (ws_RecKbn = CST_RECORD_KBN_50) or
               (ws_RecKbn = CST_RECORD_KBN_57) then
            begin
              //電文：項目コードの取得
              w_s := func_GetStringStream2(arg_System, w_Kind, arg_TStringStream,
                                           IRAIYKMKCODENO, wm_ComOffset);
              //項目コードの長さを取得
              w_StremField := func_FindMsgField(arg_System, w_Kind,
                                                IRAIYKMKCODENO);
              //オフセット位置の移動
              wm_ComOffset := wm_ComOffset + w_StremField.size;

              if arg_System <> CST_NON_TITLE then
                //設定 値と名前
                arg_TStringList.Add( w_s + '<:>' + w_StremField.name)
              else
                //設定 値と名前
                arg_TStringList.Add(w_s);

              //電文：項目名称の取得
              w_s := func_GetStringStream2(arg_System, w_Kind, arg_TStringStream,
                                      IRAIYKMKNAMENO, wm_ComOffset);
              //項目名称の長さを取得
              w_StremField := func_FindMsgField(arg_System, w_Kind,
                                                IRAIYKMKNAMENO);
              //オフセット位置の移動
              wm_ComOffset := wm_ComOffset + w_StremField.size;

              if arg_System <> CST_NON_TITLE then
                //設定 値と名前
                arg_TStringList.Add( w_s + '<:>' + w_StremField.name)
              else
                //設定 値と名前
                arg_TStringList.Add(w_s);

              //電文：使用量の取得
              w_s := func_GetStringStream2(arg_System, w_Kind, arg_TStringStream,
                                      IRAIYUSENO, wm_ComOffset);
              //使用量の長さを取得
              w_StremField := func_FindMsgField(arg_System, w_Kind,
                                                IRAIYUSENO);
              //オフセット位置の移動
              wm_ComOffset := wm_ComOffset + w_StremField.size;

              if arg_System <> CST_NON_TITLE then
                //設定 値と名前
                arg_TStringList.Add( w_s + '<:>' + w_StremField.name)
              else
                //設定 値と名前
                arg_TStringList.Add(w_s);

              //電文：分割数の取得
              w_s := func_GetStringStream2(arg_System, w_Kind, arg_TStringStream,
                                      IRAIYBUNKATUNO, wm_ComOffset);
              //分割数の長さを取得
              w_StremField := func_FindMsgField(arg_System, w_Kind,
                                                IRAIYBUNKATUNO);
              //オフセット位置の移動
              wm_ComOffset := wm_ComOffset + w_StremField.size;

              if arg_System <> CST_NON_TITLE then
                //設定 値と名前
                arg_TStringList.Add( w_s + '<:>' + w_StremField.name)
              else
                //設定 値と名前
                arg_TStringList.Add(w_s);

              //電文：予備の取得
              w_s := func_GetStringStream2(arg_System, w_Kind, arg_TStringStream,
                                      IRAIYYOBINO, wm_ComOffset);
              //予備の長さを取得
              w_StremField := func_FindMsgField(arg_System, w_Kind,
                                                IRAIYYOBINO);
              //オフセット位置の移動
              wm_ComOffset := wm_ComOffset + w_StremField.size;

              if arg_System <> CST_NON_TITLE then
                //設定 値と名前
                arg_TStringList.Add( w_s + '<:>' + w_StremField.name)
              else
                //設定 値と名前
                arg_TStringList.Add(w_s);

              w_Kmk_Count := IRAIYKMKCODENO;

            end
            //選択コメント・必須コメント・フリーコメント
            else if (ws_RecKbn = CST_RECORD_KBN_88) or
                    (ws_RecKbn = CST_RECORD_KBN_90) or
                    (ws_RecKbn = CST_RECORD_KBN_91) or
                    (ws_RecKbn = CST_RECORD_KBN_92) or
                    (ws_RecKbn = CST_RECORD_KBN_93) or
                    (ws_RecKbn = CST_RECORD_KBN_94) or
                    (ws_RecKbn = CST_RECORD_KBN_97) or
                    (ws_RecKbn = CST_RECORD_KBN_98) or
                    (ws_RecKbn = CST_RECORD_KBN_99) then
            begin
              //電文：項目コードの取得
              w_s := func_GetStringStream2(arg_System, w_Kind, arg_TStringStream,
                                      IRAICKMKCODENO, wm_ComOffset);
              //項目コードの長さを取得
              w_StremField := func_FindMsgField(arg_System, w_Kind,
                                                IRAICKMKCODENO);
              //オフセット位置の移動
              wm_ComOffset := wm_ComOffset + w_StremField.size;

              if arg_System <> CST_NON_TITLE then
                //設定 値と名前
                arg_TStringList.Add( w_s + '<:>' + w_StremField.name)
              else
                //設定 値と名前
                arg_TStringList.Add(w_s);

              //電文：項目名称の取得
              w_s := func_GetStringStream2(arg_System, w_Kind, arg_TStringStream,
                                           IRAICKMKNAMENO, wm_ComOffset);
              //項目名称の長さを取得
              w_StremField := func_FindMsgField(arg_System, w_Kind,
                                                IRAICKMKNAMENO);
              //オフセット位置の移動
              wm_ComOffset := wm_ComOffset + w_StremField.size;

              if arg_System <> CST_NON_TITLE then
                //設定 値と名前
                arg_TStringList.Add( w_s + '<:>' + w_StremField.name)
              else
                //設定 値と名前
                arg_TStringList.Add(w_s);

              //電文：予備の取得
              w_s := func_GetStringStream2(arg_System, w_Kind, arg_TStringStream,
                                           IRAICYOBINO, wm_ComOffset);
              //予備の長さを取得
              w_StremField := func_FindMsgField(arg_System, w_Kind, IRAICYOBINO);
              //オフセット位置の移動
              wm_ComOffset := wm_ComOffset + w_StremField.size;

              if arg_System <> CST_NON_TITLE then
                //設定 値と名前
                arg_TStringList.Add( w_s + '<:>' + w_StremField.name)
              else
                //設定 値と名前
                arg_TStringList.Add(w_s);

              w_Kmk_Count := IRAICKMKCODENO;

            end
            //シェーマ
            else if ws_RecKbn = CST_RECORD_KBN_95 then
            begin
              //電文：シェーマ名の取得
              w_s := func_GetStringStream2(arg_System, w_Kind, arg_TStringStream,
                                      IRAISNAMENO, wm_ComOffset);
              //シェーマ名の長さを取得
              w_StremField := func_FindMsgField(arg_System, w_Kind, IRAISNAMENO);
              //オフセット位置の移動
              wm_ComOffset := wm_ComOffset + w_StremField.size;

              if arg_System <> CST_NON_TITLE then
                //設定 値と名前
                arg_TStringList.Add( w_s + '<:>' + w_StremField.name)
              else
                //設定 値と名前
                arg_TStringList.Add(w_s);

              //電文：シェーマ情報の取得
              w_s := func_GetStringStream2(arg_System, w_Kind, arg_TStringStream,
                                      IRAISINFONO, wm_ComOffset);
              //シェーマ情報の長さを取得
              w_StremField := func_FindMsgField(arg_System, w_Kind, IRAISINFONO);
              //オフセット位置の移動
              wm_ComOffset := wm_ComOffset + w_StremField.size;

              if arg_System <> CST_NON_TITLE then
                //設定 値と名前
                arg_TStringList.Add( w_s + '<:>' + w_StremField.name)
              else
                //設定 値と名前
                arg_TStringList.Add(w_s);

              //電文：シェーマ予備の取得
              w_s := func_GetStringStream2(arg_System, w_Kind, arg_TStringStream,
                                      IRAISYOBINO, wm_ComOffset);
              //シェーマ予備の長さを取得
              w_StremField := func_FindMsgField(arg_System, w_Kind, IRAISYOBINO);
              //オフセット位置の移動
              wm_ComOffset := wm_ComOffset + w_StremField.size;

              if arg_System <> CST_NON_TITLE then
                //設定 値と名前
                arg_TStringList.Add( w_s + '<:>' + w_StremField.name)
              else
                //設定 値と名前
                arg_TStringList.Add(w_s);

              w_Kmk_Count := IRAICKMKCODENO;

            end;
            if w_Loop_Meisai = wi_MeisaiCount then begin
              w_Kmk_Count := IRAIGROUPNO;
              if w_Kmk_SyoriCount = w_Kmk then
                Exit;
            end;
          end;
          if w_Kmk_SyoriCount = w_Kmk then
            Exit;
        end;
      end
      else
        //受信項目の情報取得
        w_StremField := func_FindMsgField(arg_System,w_Kind,w_i);
    end
    //それ以外の電文
    else
      //受信項目の情報取得
      w_StremField := func_FindMsgField(arg_System,w_Kind,w_i);
    if ((w_Kind = G_MSGKIND_IRAI) and
       (IRAIMOKUTEKILENNO > w_i)) or
       (w_Kind <> G_MSGKIND_IRAI) then
    begin
      //はじめの場合
      if w_i = 1 then
        //位置設定
        w_offset := 0;
      //サイズ設定
      w_size   := w_StremField.size;
      //ポジション移動
      arg_TStringStream.Position := w_offset;
      //データの読み込み
      w_s      := arg_TStringStream.ReadString(w_size);
      //項目名称の設定
      w_FieldName  := w_StremField.name;
      //デリミタの場合
      if G_FIELD_NAME_DERI = w_FieldName then begin
        if (w_s = Chr($0D)) or
           (w_s = '') then begin
          if arg_System <> CST_NON_TITLE then
            //設定 値と名前
            arg_TStringList.Add( w_s + '<:>デリミタ')
          else
            //設定 値と名前
            arg_TStringList.Add(w_s);
          //処理終了
          Exit;
        end;
      end;
      if arg_System <> CST_NON_TITLE then
        //設定 値と名前
        arg_TStringList.Add( w_s + '<:>' + w_FieldName)
      else
        //設定 値と名前
        arg_TStringList.Add(w_s);
      //位置設定
      w_offset := w_offset + w_StremField.size;
    end;
  end;
  //処理終了
  Exit;
end;
{
-----------------------------------------------------------------------------
  名前 : proc_TStrmToStrlist_H_Jissi;
  引数 :
  arg_TStringList:TStringList      元
  arg_TStringList   : TStringList  先
  arg_System        : string;      種類
  arg_MsgKind       : string       種別

  機能 : TStringStreamより解析してTStringListを作成する
  復帰値：
-----------------------------------------------------------------------------
}
procedure proc_TStrmToStrlist_H_Jissi(
           arg_TStringStream : TStringStream;
           arg_TStringList   : TStringList  ;
           arg_System        : string;
           arg_MsgKind       : string
           );
var
  w_i:integer;
  w_MaxDefLen:integer;
  w_offset:integer;
  w_size  :integer;
  w_s:string;
  w_FieldName:string;
  w_StremField : TStreamField;
  w_Kmk:integer;
  w_Kmk_Count:integer;
  w_Kind:String;
  wm_Offset:Integer;
  wm_ComOffset:Integer;
  wi_MeisaiCount:Integer;
  w_Loop_Meisai:Integer;
  ws_RecKbn:String;
  w_Kmk_SyoriCount:Integer;
begin
//TStringStream→TStringListに展開
  //初期値
  arg_TStringList.Text := '';
  //初期化
  arg_TStringList.Clear;
  //初期位置に移動
  arg_TStringStream.Position := 0;
  //項目数を取得
  w_MaxDefLen := func_MsgDefLen(arg_System,arg_MsgKind);

  //初期化
  w_Kmk         := 0;
  w_Kmk_Count   := 0;
  w_offset      := 0;
  w_Kind        := arg_MsgKind;
  w_Kmk_SyoriCount := 0;
  wm_ComOffset := 0;
  //項目数分作成
  for w_i := 1 to w_MaxDefLen do begin
    //実施情報電文の場合
    if w_Kind = G_MSGKIND_JISSI then begin
      case w_i of
        //グループ数項目
        CST_JISSI_LOOPSTART:
        begin
          //グループ数項目取得
          w_s := func_GetStringStream(arg_System,w_Kind,arg_TStringStream,CST_JISSI_LOOPSTART);
          //受信項目の情報取得
          w_StremField := func_FindMsgField(arg_System,w_Kind,CST_JISSI_LOOPSTART);
          //グループ数項目が数値の場合
          if func_IsNumber(w_s) then
            //グループ数項目取得
            w_Kmk := StrToInt(w_s)
          else
            //グループ数項目なし
            w_Kmk := 0;
          //項目の最大数以上の場合
          if w_Kmk > CST_GROUP_LOOP_MAX then
            //項目の最大数に設定
            w_Kmk := CST_GROUP_LOOP_MAX;
        end;
      end;
      //ループ開始になった場合
      if JISSIGROUPNO <= w_i then begin
        //項目個数がある場合
        if w_Kmk > 0 then begin
          //初期の場合
          if w_Kmk_Count = 0 then begin
            //グループ番号位置
            w_Kmk_Count := JISSIGROUPNO;
          end;

          inc(w_Kmk_SyoriCount);
          if wm_ComOffset = 0 then begin
            //検査目的長までのオフセットを取得
            w_StremField := func_FindMsgField(arg_System, w_Kind, JISSIGROUPNO);
            //オフセットを設定
            wm_Offset := w_StremField.offset;
            //項目コード開始オフセット位置
            wm_ComOffset := wm_Offset;
          end;

          //電文：グループ番号の取得
          w_s := func_GetStringStream2(arg_System,w_Kind,arg_TStringStream,
                                       JISSIGROUPNO,wm_ComOffset);
          //グループ番号の長さを取得
          w_StremField := func_FindMsgField(arg_System, w_Kind, JISSIGROUPNO);
          //オフセット位置の移動
          wm_ComOffset := wm_ComOffset + w_StremField.size;

          if arg_System <> CST_NON_TITLE then
            //設定 値と名前
            arg_TStringList.Add( w_s + '<:>' + w_StremField.name)
          else
            //設定 値と名前
            arg_TStringList.Add(w_s);

          //電文：会計区分の取得
          w_s := func_GetStringStream2(arg_System,w_Kind,arg_TStringStream,
                                       JISSIKAIKEIKBNNO,wm_ComOffset);
          //会計区分の長さを取得
          w_StremField := func_FindMsgField(arg_System, w_Kind,
                                            JISSIKAIKEIKBNNO);
          //オフセット位置の移動
          wm_ComOffset := wm_ComOffset + w_StremField.size;

          if arg_System <> CST_NON_TITLE then
            //設定 値と名前
            arg_TStringList.Add( w_s + '<:>' + w_StremField.name)
          else
            //設定 値と名前
            arg_TStringList.Add(w_s);

          //電文：実施区分の取得
          w_s := func_GetStringStream2(arg_System,w_Kind,arg_TStringStream,
                                       JISSIJISSIKBNNO,wm_ComOffset);
          //実施区分の長さを取得
          w_StremField := func_FindMsgField(arg_System, w_Kind,
                                            JISSIJISSIKBNNO);
          //オフセット位置の移動
          wm_ComOffset := wm_ComOffset + w_StremField.size;

          if arg_System <> CST_NON_TITLE then
            //設定 値と名前
            arg_TStringList.Add( w_s + '<:>' + w_StremField.name)
          else
            //設定 値と名前
            arg_TStringList.Add(w_s);

          //電文：項目コードの取得
          w_s := func_GetStringStream2(arg_System,w_Kind,arg_TStringStream,
                                       JISSIKMKCODENO,wm_ComOffset);
          //項目コードの長さを取得
          w_StremField := func_FindMsgField(arg_System, w_Kind,
                                            JISSIKMKCODENO);
          //オフセット位置の移動
          wm_ComOffset := wm_ComOffset + w_StremField.size;

          if arg_System <> CST_NON_TITLE then
            //設定 値と名前
            arg_TStringList.Add( w_s + '<:>' + w_StremField.name)
          else
            //設定 値と名前
            arg_TStringList.Add(w_s);

          //電文：検査回数の取得
          w_s := func_GetStringStream2(arg_System,w_Kind,arg_TStringStream,
                                       JISSIKENSACOUNTNO,wm_ComOffset);
          //検査回数の長さを取得
          w_StremField := func_FindMsgField(arg_System, w_Kind,
                                            JISSIKENSACOUNTNO);
          //オフセット位置の移動
          wm_ComOffset := wm_ComOffset + w_StremField.size;

          if arg_System <> CST_NON_TITLE then
            //設定 値と名前
            arg_TStringList.Add( w_s + '<:>' + w_StremField.name)
          else
            //設定 値と名前
            arg_TStringList.Add(w_s);

          //電文：撮影種コードの取得
          w_s := func_GetStringStream2(arg_System,w_Kind,arg_TStringStream,
                                       JISSIBUISATUEICODENO,wm_ComOffset);
          //撮影種コードの長さを取得
          w_StremField := func_FindMsgField(arg_System, w_Kind,
                                            JISSIBUISATUEICODENO);
          //オフセット位置の移動
          wm_ComOffset := wm_ComOffset + w_StremField.size;

          if arg_System <> CST_NON_TITLE then
            //設定 値と名前
            arg_TStringList.Add( w_s + '<:>' + w_StremField.name)
          else
            //設定 値と名前
            arg_TStringList.Add(w_s);

          //電文：部位コードの取得
          w_s := func_GetStringStream2(arg_System,w_Kind,arg_TStringStream,
                                       JISSIBUICODENO,wm_ComOffset);
          //部位コードの長さを取得
          w_StremField := func_FindMsgField(arg_System, w_Kind, JISSIBUICODENO);
          //オフセット位置の移動
          wm_ComOffset := wm_ComOffset + w_StremField.size;

          if arg_System <> CST_NON_TITLE then
            //設定 値と名前
            arg_TStringList.Add( w_s + '<:>' + w_StremField.name)
          else
            //設定 値と名前
            arg_TStringList.Add(w_s);

          //電文：検査室コードの取得
          w_s := func_GetStringStream2(arg_System,w_Kind,arg_TStringStream,
                                       JISSIKENSAROOMCODENO,wm_ComOffset);
          //検査室の長さを取得
          w_StremField := func_FindMsgField(arg_System, w_Kind, JISSIKENSAROOMCODENO);
          //オフセット位置の移動
          wm_ComOffset := wm_ComOffset + w_StremField.size;

          if arg_System <> CST_NON_TITLE then
            //設定 値と名前
            arg_TStringList.Add( w_s + '<:>' + w_StremField.name)
          else
            //設定 値と名前
            arg_TStringList.Add(w_s);

          //電文：ポータブルの取得
          w_s := func_GetStringStream2(arg_System,w_Kind,arg_TStringStream,
                                       JISSIPORTABLENO,wm_ComOffset);
          //ポータブルの長さを取得
          w_StremField := func_FindMsgField(arg_System, w_Kind,
                                            JISSIPORTABLENO);
          //オフセット位置の移動
          wm_ComOffset := wm_ComOffset + w_StremField.size;

          if arg_System <> CST_NON_TITLE then
            //設定 値と名前
            arg_TStringList.Add( w_s + '<:>' + w_StremField.name)
          else
            //設定 値と名前
            arg_TStringList.Add(w_s);

          //電文：明細数の取得
          w_s := func_GetStringStream2(arg_System,w_Kind,arg_TStringStream,
                                       JISSIMEISAICOUNTNO,wm_ComOffset);
          //明細数の長さを取得
          w_StremField := func_FindMsgField(arg_System, w_Kind,
                                            JISSIMEISAICOUNTNO);
          //オフセット位置の移動
          wm_ComOffset := wm_ComOffset + w_StremField.size;
          //明細数数値化
          wi_MeisaiCount := StrToIntDef(Trim(w_s),0);

          if arg_System <> CST_NON_TITLE then
            //設定 値と名前
            arg_TStringList.Add( w_s + '<:>' + w_StremField.name)
          else
            //設定 値と名前
            arg_TStringList.Add(w_s);

          for w_Loop_Meisai := 0 to wi_MeisaiCount - 1 do
          begin
            //電文：管理区分の取得
            w_s := func_GetStringStream2(arg_System, w_Kind, arg_TStringStream,
                                         JISSIYRECORDKBNNO, wm_ComOffset);
            //半角ブランクの削除
            ws_RecKbn := TrimRight(w_s);
            //レコード区分の長さを取得
            w_StremField := func_FindMsgField(arg_System, w_Kind,
                                              JISSIYRECORDKBNNO);
            {
            if arg_System <> CST_NON_TITLE then
              //設定 値と名前
              arg_TStringList.Add( w_s + '<:>' + w_StremField.name)
            else
              //設定 値と名前
              arg_TStringList.Add(w_s);
            }
            //オフセット位置の移動
            wm_ComOffset := wm_ComOffset + w_StremField.size;

            //薬剤
            if (ws_RecKbn = CST_RECORD_KBN_20) or
               (ws_RecKbn = CST_RECORD_KBN_30) or
               (ws_RecKbn = CST_RECORD_KBN_50) or
               (ws_RecKbn = CST_RECORD_KBN_57) then
            begin
              //レコード区分のタイトルを取得
              w_StremField := func_FindMsgField(arg_System, w_Kind,
                                                JISSIYRECORDKBNNO);
              if arg_System <> CST_NON_TITLE then
                //設定 値と名前
                arg_TStringList.Add( w_s + '<:>' + w_StremField.name)
              else
                //設定 値と名前
                arg_TStringList.Add(w_s);

              w_Kmk_Count := JISSIYKMKCODENO;
            end
            //選択コメント・必須コメント・フリーコメント
            else if (ws_RecKbn = CST_RECORD_KBN_88) or
                    (ws_RecKbn = CST_RECORD_KBN_90) or
                    (ws_RecKbn = CST_RECORD_KBN_91) or
                    (ws_RecKbn = CST_RECORD_KBN_92) or
                    (ws_RecKbn = CST_RECORD_KBN_93) or
                    (ws_RecKbn = CST_RECORD_KBN_94) or
                    (ws_RecKbn = CST_RECORD_KBN_97) or
                    (ws_RecKbn = CST_RECORD_KBN_98) or
                    (ws_RecKbn = CST_RECORD_KBN_99) then
            begin
              //レコード区分のタイトルを取得
              w_StremField := func_FindMsgField(arg_System, w_Kind,
                                                JISSICRECORDKBNNO);
              if arg_System <> CST_NON_TITLE then
                //設定 値と名前
                arg_TStringList.Add( w_s + '<:>' + w_StremField.name)
              else
                //設定 値と名前
                arg_TStringList.Add(w_s);

              w_Kmk_Count := JISSICKMKCODENO;
            end;
            //薬剤
            if (ws_RecKbn = CST_RECORD_KBN_20) or
               (ws_RecKbn = CST_RECORD_KBN_30) or
               (ws_RecKbn = CST_RECORD_KBN_50) or
               (ws_RecKbn = CST_RECORD_KBN_57) then
            begin
              //電文：項目コードの取得
              w_s := func_GetStringStream2(arg_System, w_Kind, arg_TStringStream,
                                      JISSIYKMKCODENO, wm_ComOffset);
              //項目コードの長さを取得
              w_StremField := func_FindMsgField(arg_System, w_Kind,
                                                JISSIYKMKCODENO);
              //オフセット位置の移動
              wm_ComOffset := wm_ComOffset + w_StremField.size;

              if arg_System <> CST_NON_TITLE then
                //設定 値と名前
                arg_TStringList.Add( w_s + '<:>' + w_StremField.name)
              else
                //設定 値と名前
                arg_TStringList.Add(w_s);

              //電文：オーダ使用量の取得
              w_s := func_GetStringStream2(arg_System, w_Kind, arg_TStringStream,
                                           JISSIYORDERUSENO, wm_ComOffset);
              //オーダ使用量の長さを取得
              w_StremField := func_FindMsgField(arg_System, w_Kind,
                                                JISSIYORDERUSENO);
              //オフセット位置の移動
              wm_ComOffset := wm_ComOffset + w_StremField.size;

              if arg_System <> CST_NON_TITLE then
                //設定 値と名前
                arg_TStringList.Add( w_s + '<:>' + w_StremField.name)
              else
                //設定 値と名前
                arg_TStringList.Add(w_s);

              //電文：分割数の取得
              w_s := func_GetStringStream2(arg_System, w_Kind, arg_TStringStream,
                                           JISSIYBUNKATUNO, wm_ComOffset);
              //分割数の長さを取得
              w_StremField := func_FindMsgField(arg_System, w_Kind,
                                                JISSIYBUNKATUNO);
              //オフセット位置の移動
              wm_ComOffset := wm_ComOffset + w_StremField.size;

              if arg_System <> CST_NON_TITLE then
                //設定 値と名前
                arg_TStringList.Add( w_s + '<:>' + w_StremField.name)
              else
                //設定 値と名前
                arg_TStringList.Add(w_s);

              //電文：予備の取得
              w_s := func_GetStringStream2(arg_System, w_Kind, arg_TStringStream,
                                      JISSIYYOBINO, wm_ComOffset);
              //予備の長さを取得
              w_StremField := func_FindMsgField(arg_System, w_Kind,
                                                JISSIYYOBINO);
              //オフセット位置の移動
              wm_ComOffset := wm_ComOffset + w_StremField.size;

              if arg_System <> CST_NON_TITLE then
                //設定 値と名前
                arg_TStringList.Add( w_s + '<:>' + w_StremField.name)
              else
                //設定 値と名前
                arg_TStringList.Add(w_s);

              w_Kmk_Count := JISSIYRECORDKBNNO;

            end
            //選択コメント・必須コメント・フリーコメント
            else if (ws_RecKbn = CST_RECORD_KBN_88) or
                    (ws_RecKbn = CST_RECORD_KBN_90) or
                    (ws_RecKbn = CST_RECORD_KBN_91) or
                    (ws_RecKbn = CST_RECORD_KBN_92) or
                    (ws_RecKbn = CST_RECORD_KBN_93) or
                    (ws_RecKbn = CST_RECORD_KBN_94) or
                    (ws_RecKbn = CST_RECORD_KBN_97) or
                    (ws_RecKbn = CST_RECORD_KBN_98) or
                    (ws_RecKbn = CST_RECORD_KBN_99) then
            begin
              //電文：項目コードの取得
              w_s := func_GetStringStream2(arg_System, w_Kind, arg_TStringStream,
                                           JISSICKMKCODENO, wm_ComOffset);
              //項目コードの長さを取得
              w_StremField := func_FindMsgField(arg_System, w_Kind,
                                                JISSICKMKCODENO);
              //オフセット位置の移動
              wm_ComOffset := wm_ComOffset + w_StremField.size;

              if arg_System <> CST_NON_TITLE then
                //設定 値と名前
                arg_TStringList.Add( w_s + '<:>' + w_StremField.name)
              else
                //設定 値と名前
                arg_TStringList.Add(w_s);

              //電文：コメントの取得
              w_s := func_GetStringStream2(arg_System, w_Kind, arg_TStringStream,
                                           JISSICCOMNO, wm_ComOffset);
              //コメントの長さを取得
              w_StremField := func_FindMsgField(arg_System, w_Kind,
                                                JISSICCOMNO);
              //オフセット位置の移動
              wm_ComOffset := wm_ComOffset + w_StremField.size;

              if arg_System <> CST_NON_TITLE then
                //設定 値と名前
                arg_TStringList.Add( w_s + '<:>' + w_StremField.name)
              else
                //設定 値と名前
                arg_TStringList.Add(w_s);

              //電文：予備の取得
              w_s := func_GetStringStream2(arg_System, w_Kind, arg_TStringStream,
                                           JISSICYOBINO, wm_ComOffset);
              //予備の長さを取得
              w_StremField := func_FindMsgField(arg_System, w_Kind, JISSICYOBINO);
              //オフセット位置の移動
              wm_ComOffset := wm_ComOffset + w_StremField.size;

              if arg_System <> CST_NON_TITLE then
                //設定 値と名前
                arg_TStringList.Add( w_s + '<:>' + w_StremField.name)
              else
                //設定 値と名前
                arg_TStringList.Add(w_s);

              w_Kmk_Count := JISSICRECORDKBNNO;

            end;
            if w_Loop_Meisai = wi_MeisaiCount then begin
              w_Kmk_Count := JISSIGROUPNO;
              if w_Kmk_SyoriCount = w_Kmk then
                Exit;
            end;
          end;
          if w_Kmk_SyoriCount = w_Kmk then
            Exit;
        end;
      end
      else
        //受信項目の情報取得
        w_StremField := func_FindMsgField(arg_System,w_Kind,w_i);
    end
    //それ以外の電文
    else
      //受信項目の情報取得
      w_StremField := func_FindMsgField(arg_System,w_Kind,w_i);
    if ((w_Kind = G_MSGKIND_JISSI) and
       (JISSIGROUPNO > w_i)) then
    begin
      //はじめの場合
      if w_i = 1 then
        //位置設定
        w_offset := 0;
      //サイズ設定
      w_size   := w_StremField.size;
      //ポジション移動
      arg_TStringStream.Position := w_offset;
      //データの読み込み
      w_s      := arg_TStringStream.ReadString(w_size);
      //項目名称の設定
      w_FieldName  := w_StremField.name;
      //デリミタの場合
      if G_FIELD_NAME_DERI = w_FieldName then begin
        if (w_s = Chr($0D)) or
           (w_s = '') then begin
          if arg_System <> CST_NON_TITLE then
            //設定 値と名前
            arg_TStringList.Add( w_s + '<:>デリミタ')
          else
            //設定 値と名前
            arg_TStringList.Add(w_s);
          //処理終了
          Exit;
        end;
      end;
      if arg_System <> CST_NON_TITLE then
        //設定 値と名前
        arg_TStringList.Add( w_s + '<:>' + w_FieldName)
      else
        //設定 値と名前
        arg_TStringList.Add(w_s);
      //位置設定
      w_offset := w_offset + w_StremField.size;
    end;
  end;
  //処理終了
  Exit;
end;
{
-----------------------------------------------------------------------------
  名前 : proc_TStrmToStrlist2;
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
           arg_TStringList   : TStringList  ;
           arg_System        : string;
           arg_MsgKind       : string
           );
var
  w_i:integer;
  w_s:string;
  w_Kind,w_S2:String;
begin
//TStringStream→TStringListに展開
  //初期値
  arg_TStringList.Text := '';
  //初期化
  arg_TStringList.Clear;
  //初期位置に移動
  arg_TStringStream.Position := 0;
  //初期化
  w_Kind        := arg_MsgKind;
  w_i := 1;
  w_S := arg_TStringStream.DataString;
  w_S2 := Copy(arg_TStringStream.DataString,1,1);
  arg_TStringList.Add(w_S2);
  w_S2 := Copy(arg_TStringStream.DataString,2,1);
  arg_TStringList.Add(w_S2);
  w_S2 := Copy(arg_TStringStream.DataString,3,4);
  //w_S2 := FormatFloat('00000',bswapf(StrToInt(w_s)));
  arg_TStringList.Add(w_S2);
  w_S := Copy(w_S,7,Length(w_S));
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
  //処理終了
  Exit;
end;
{
-----------------------------------------------------------------------------
  名前 : proc_TStrmToStrlist3;
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
           arg_TStringStream : TStringStream;
           arg_TStringList   : TStringList  ;
           arg_System        : string;
           arg_MsgKind       : string
           );
var
  w_s:string;
  w_Kind,w_S2:String;
begin
//TStringStream→TStringListに展開
  //初期値
  arg_TStringList.Text := '';
  //初期化
  arg_TStringList.Clear;
  //初期位置に移動
  arg_TStringStream.Position := 0;
  //初期化
  w_Kind        := arg_MsgKind;
  w_S := arg_TStringStream.DataString;
  w_S2 := Copy(arg_TStringStream.DataString,1,1);
  arg_TStringList.Add(w_S2);
  w_S2 := Copy(arg_TStringStream.DataString,2,5);
  arg_TStringList.Add(w_S2);
  w_S2 := Copy(arg_TStringStream.DataString,7,2);
  if func_IsNumber(w_S2) then begin
    proc_Change_Byte(w_S2);
  end;
  arg_TStringList.Add(w_S2);
  //処理終了
  Exit;
end;

{
-----------------------------------------------------------------------------
  名前 : proc_TStrListToStrm;
  引数 :
  arg_TStringList   : TStringList  元
  arg_TStringList:TStringList      先
  arg_System        : string;      種類
  arg_MsgKind       : string       種別
  arg_TStringList:TStringList
  機能 : TStringListよりTStringStreamを作成する
  ツールからの手動入力を考慮して
  定義情報を元に補完と切り捨て処理をおこなう。
  復帰値：TStringStream nil失敗
-----------------------------------------------------------------------------
}
Procedure  proc_TStrListToStrm(
           arg_TStringList   : TStringList;
           arg_TStringStream : TStringStream;
           arg_System        : string;
           arg_MsgKind       : string
           );
begin
  //ストリングリストからストリームへ
  if arg_MsgKind = G_MSGKIND_JISSI then
  begin
    proc_TStrListToStrm_Jissi(arg_TStringList,arg_TStringStream,arg_System,arg_MsgKind);
  end
  else
  begin
    proc_TStrListToStrm_Irai(arg_TStringList,arg_TStringStream,arg_System,arg_MsgKind);
  end;

  //処理終了
  Exit;
end;
{
-----------------------------------------------------------------------------
  名前 : proc_TStrListToStrm_Irai;
  引数 :
  arg_TStringList   : TStringList  元
  arg_TStringList:TStringList      先
  arg_System        : string;      種類
  arg_MsgKind       : string       種別
  arg_TStringList:TStringList
  機能 : TStringListよりTStringStreamを作成する
  ツールからの手動入力を考慮して
  定義情報を元に補完と切り捨て処理をおこなう。
  復帰値：TStringStream nil失敗
-----------------------------------------------------------------------------
}
Procedure  proc_TStrListToStrm_Irai(
           arg_TStringList   : TStringList;
           arg_TStringStream : TStringStream;
           arg_System        : string;
           arg_MsgKind       : string
           );
var
  w_i:integer;
  w_len1:integer;
  w_len2:integer;
  w_s:string;
  w_MsgDeflen:integer;
  w_RMsglen:integer;
  w_StremField : TStreamField;
  w_Kmk:integer;
  w_Kmk_Count:integer;
  w_Kmk_No:integer;
  w_Kind:String;
  wi_MeisaiLoop: Integer;
  wi_MeisaiCount: Integer;
  wi_RecKbn: Integer;
  wi_RecKbn_Yakuzai: Integer;
  wi_RecKbn_Comment: Integer;
  wi_RecKbn_Schema: Integer;
  wb_Mesai_Flg: Boolean;
begin
  //TStringList→TStringStreamに展開
  try
    //電文種別の電文長を求める
    w_MsgDeflen := func_MsgDefLen(arg_System, arg_MsgKind);
    //電文長がない場合
    if w_MsgDeflen = 0 then
    begin
      //処理終了
      Exit;
    end;
//電文長を調べる
    w_RMsglen     := 0;
    //初期化
    w_Kmk         := 0;
    w_Kmk_Count   := 0;
    w_Kmk_No      := 0;
    wi_MeisaiCount:= 0;
    wi_MeisaiLoop := 0;
    wb_Mesai_Flg  := False;
    wi_RecKbn     := 0;
    wi_RecKbn_Yakuzai := 0;
    wi_RecKbn_Comment := 0;
    wi_RecKbn_Schema  := 0;
    w_Kind := arg_MsgKind;
    //リスト数分ループ
    for w_i := 1 to arg_TStringList.Count do
    begin
      //リスト文字列の長さ取得
      w_len1       := length(arg_TStringList[w_i-1]);
      //依頼情報電文の場合
      if w_Kind = G_MSGKIND_IRAI then
      begin
        case w_i of
          //グループ数項目
          CST_IRAI_LOOPSTART:
          begin
            //グループ数項目が数値の場合
            if func_IsNumber(arg_TStringList[w_i-1]) then
            begin
              //グループ数項目取得
              w_Kmk := StrToInt(arg_TStringList[w_i-1]);
            end
            else
            begin
              //グループ数項目なし
              w_Kmk := 0;
            end;
            //項目の最大数以上の場合
            if w_Kmk > CST_GROUP_LOOP_MAX then
            begin
              //項目の最大数に設定
              w_Kmk := CST_GROUP_LOOP_MAX;
            end;
          end;
        end;
        //ループ開始になった場合(グループ番号)
        if IRAIGROUPNO <= w_i then
        begin
          //項目個数がある場合
          if w_Kmk > 0 then
          begin
            //繰り返しがグループ数に達するまで
            if w_Kmk_Count <= w_Kmk then
            begin
              //グループ番号～明細数まで
              if IRAIMEISAICOUNTNO > w_Kmk_No then
              begin
                //一番初めの場合
                if w_Kmk_No = 0 then
                begin
                  if w_Kmk_Count = 0 then
                    //初期化
                    w_Kmk_Count := 1;
                  //電文レイアウト位置の"グループ番号"の位置設定
                  w_Kmk_No := IRAIGROUPNO;
                end
                //以外の場合
                else
                begin
                  //前回に＋１
                  inc(w_Kmk_No);
                end;
                //送信項目の情報取得
                w_StremField := func_FindMsgField(arg_System,w_Kind,w_Kmk_No);
                //明細数の場合
                if IRAIMEISAICOUNTNO = w_Kmk_No then
                begin
                  //レコード区分初期化
                  wi_RecKbn := 0;
                  wi_RecKbn_Yakuzai := 0;
                  wi_RecKbn_Comment := 0;
                  wi_RecKbn_Schema  := 0;
                  wi_MeisaiLoop := 0;
                  //明細数の設定
                  wi_MeisaiCount := StrToIntDef(arg_TStringList[w_i - 1],0);
                  wb_Mesai_Flg := False;
                end;
              end
              //明細数以降の場合
              else
              begin
                //明細回数がある場合
                if (wi_MeisaiCount > 0) and
                   (wi_MeisaiLoop < wi_MeisaiCount) then
                   begin
                  if not wb_Mesai_Flg then
                  begin
                    //レコード区分設定
                    wi_RecKbn := StrToIntDef(arg_TStringList[w_i - 1],0);
                    //送信項目の情報取得
                    w_StremField := func_FindMsgField(arg_System,w_Kind,IRAIYRECKBNNO);
                    //レコード区分取得成功
                    wb_Mesai_Flg := True;
                  end
                  else
                  begin
                    case wi_RecKbn of
                      //薬剤・手技・材料・フィルム
                      20,30,50,57:
                        begin
                          //一番初めの場合
                          if wi_RecKbn_Yakuzai = 0 then
                          begin
                            //電文レイアウト位置の"項目コード"の位置設定
                            wi_RecKbn_Yakuzai := IRAIYKMKCODENO;
                          end
                          //それ以外の場合
                          else
                          begin
                            //前回に＋１
                            inc(wi_RecKbn_Yakuzai);
                          end;
                          //送信項目の情報取得
                          w_StremField := func_FindMsgField(arg_System,w_Kind,wi_RecKbn_Yakuzai);
                          //"予備"まで終了した場合
                          if wi_RecKbn_Yakuzai = IRAIYYOBINO then
                          begin
                            wi_RecKbn_Yakuzai := IRAIYRECKBNNO;
                            Inc(wi_MeisaiLoop);
                            //レコード区分未取得
                            wb_Mesai_Flg := False;
                            //明細項目終了の場合
                            if wi_MeisaiLoop = wi_MeisaiCount then begin
                              //初期化
                              w_Kmk_No := 0;
                              //回数アップ
                              inc(w_Kmk_Count);
                            end;
                          end;
                        end;
                      //選択・必須・フリーコメント
                      88,90,91,92,93,94,97,98,99:
                        begin
                          //一番初めの場合
                          if wi_RecKbn_Comment = 0 then
                          begin
                            //電文レイアウト位置の"項目コード"の位置設定
                            wi_RecKbn_Comment := IRAICKMKCODENO;
                          end
                          //それ以外の場合
                          else
                          begin
                            //前回に＋１
                            inc(wi_RecKbn_Comment);
                          end;
                          //送信項目の情報取得
                          w_StremField := func_FindMsgField(arg_System,w_Kind,wi_RecKbn_Comment);
                          //"予備"まで終了した場合
                          if wi_RecKbn_Comment = IRAICYOBINO then
                          begin
                            wi_RecKbn_Comment := IRAICRECKBNNO;
                            Inc(wi_MeisaiLoop);
                            //レコード区分未取得
                            wb_Mesai_Flg := False;
                            //明細項目終了の場合
                            if wi_MeisaiLoop = wi_MeisaiCount then begin
                              //初期化
                              w_Kmk_No := 0;
                              //回数アップ
                              inc(w_Kmk_Count);
                            end;
                          end;
                        end;
                      //シェーマ
                      95:
                        begin
                          //一番初めの場合
                          if wi_RecKbn_Schema = 0 then
                          begin
                            //電文レイアウト位置の"シェーマ情報"の位置設定
                            wi_RecKbn_Schema := IRAISNAMENO;
                          end
                          //それ以外の場合
                          else
                          begin
                            //前回に＋１
                            inc(wi_RecKbn_Schema);
                          end;
                          //送信項目の情報取得
                          w_StremField := func_FindMsgField(arg_System,w_Kind,wi_RecKbn_Schema);
                          //"シェーマ情報"まで終了した場合
                          if wi_RecKbn_Schema = IRAISYOBINO then
                          begin
                            wi_RecKbn_Schema := IRAISRECKBNNO;
                            Inc(wi_MeisaiLoop);
                            //レコード区分未取得
                            wb_Mesai_Flg := False;
                            //明細項目終了の場合
                            //明細項目終了の場合
                            if wi_MeisaiLoop = wi_MeisaiCount then begin
                              //初期化
                              w_Kmk_No := 0;
                              //回数アップ
                              inc(w_Kmk_Count);
                            end;
                          end;
                        end;
                    end;
                  end;
                end
                else
                begin
                  //電文レイアウト位置の"グループ番号"の位置設定
                  w_Kmk_No := IRAIGROUPNO;
                  //送信項目の情報取得
                  w_StremField := func_FindMsgField(arg_System,w_Kind,w_Kmk_No);
                end;
              end;
            end;
          end;
        end
        else
        begin
          //送信項目の情報取得
          w_StremField := func_FindMsgField(arg_System,w_Kind,w_i);
        end;
      end
      else
      begin
        //送信項目の情報取得
        w_StremField := func_FindMsgField(arg_System,w_Kind,w_i);
      end;
      //ループ開始になった場合
      if (IRAIMOKUTEKINO = w_i)  or
         (IRAISIJINO = w_i)      or
         (IRAISONOTANO = w_i)    or
         (IRAIBYOUMEINO = w_i)   then
         begin
        //送信項目の長さ取得
        w_len2 := StrToIntDef(arg_TStringList[w_i-2],0);
      end
      else
      begin
        //送信項目の長さ取得
        w_len2       := w_StremField.size;
      end;
      //リスト文字列のより送信項目の長さが小さい場合
      if w_len1 >= w_len2 then
      begin
        //設定
        w_RMsglen := w_RMsglen + w_len2;
      end
      //それ以外の場合
      else
      begin
        //設定
        w_RMsglen := w_RMsglen + w_len2;
      end;
      //電文レイアウト上の最大
      if w_MsgDeflen = w_i then
      begin
        //処理終了
        Break;
      end;
    end;
    //一ラインずつ展開
    arg_TStringStream.Position := 0;
    //初期化
    w_Kmk_Count  := 0;
    w_Kmk_No := 0;
    //リスト数分ループ
    for w_i := 1 to arg_TStringList.Count do
    begin
      //電文長項目の場合
      if w_i = COMMON1DENLENNO then
      begin
        //サイズ設定
        w_s := FormatFloat('000000', w_RMsglen - 32);
        //電文長項目書き込み
        arg_TStringStream.WriteString(w_s);
      end
      //それ以外の項目の場合
      else
      begin
        //文字列取得
        w_s          := arg_TStringList[w_i-1];
        //送信文字列長取得
        w_len1       := length( w_s );
        //ループ開始になった場合(グループ番号)
        if IRAIGROUPNO <= w_i then
        begin
          //項目個数がある場合
          if w_Kmk > 0 then
          begin
            //繰り返しがグループ数に達するまで
            if w_Kmk_Count <= w_Kmk then
            begin
              //グループ番号～明細数まで
              if IRAIMEISAICOUNTNO > w_Kmk_No then
              begin
                //一番初めの場合
                if w_Kmk_No = 0 then
                begin
                  if w_Kmk_Count = 0 then
                    //初期化
                    w_Kmk_Count := 1;
                  //電文レイアウト位置の"グループ番号"の位置設定
                  w_Kmk_No := IRAIGROUPNO;
                end
                //以外の場合
                else
                begin
                  //前回に＋１
                  inc(w_Kmk_No);
                end;
                //送信項目の情報取得
                w_StremField := func_FindMsgField(arg_System,w_Kind,w_Kmk_No);
                //明細数の場合
                if IRAIMEISAICOUNTNO = w_Kmk_No then
                begin
                  //レコード区分初期化
                  wi_RecKbn := 0;
                  wi_RecKbn_Yakuzai := 0;
                  wi_RecKbn_Comment := 0;
                  wi_RecKbn_Schema  := 0;
                  wi_MeisaiLoop := 0;
                  //明細数の設定
                  wi_MeisaiCount := StrToIntDef(arg_TStringList[w_i - 1],0);
                  wb_Mesai_Flg := False;
                end;
              end
              //明細数以降の場合
              else
              begin
                //明細回数がある場合
                if (wi_MeisaiCount > 0) and
                   (wi_MeisaiLoop < wi_MeisaiCount) then
                   begin
                  //レコード区分設定
                  if not wb_Mesai_Flg then
                  begin
                    wi_RecKbn := StrToIntDef(arg_TStringList[w_i - 1],0);
                    //送信項目の情報取得
                    w_StremField := func_FindMsgField(arg_System,w_Kind,IRAIYRECKBNNO);
                    //レコード区分取得成功
                    wb_Mesai_Flg := True;
                  end
                  else
                  begin
                    case wi_RecKbn of
                      //薬剤・手技・材料・フィルム
                      20,30,50,57:
                        begin
                          //一番初めの場合
                          if wi_RecKbn_Yakuzai = 0 then
                          begin
                            //電文レイアウト位置の"項目コード"の位置設定
                            wi_RecKbn_Yakuzai := IRAIYKMKCODENO;
                          end
                          //それ以外の場合
                          else
                          begin
                            //前回に＋１
                            inc(wi_RecKbn_Yakuzai);
                          end;
                          //送信項目の情報取得
                          w_StremField := func_FindMsgField(arg_System,w_Kind,wi_RecKbn_Yakuzai);
                          //"予備"まで終了した場合
                          if wi_RecKbn_Yakuzai = IRAIYYOBINO then
                          begin
                            wi_RecKbn_Yakuzai := IRAIYRECKBNNO;
                            Inc(wi_MeisaiLoop);
                            //レコード区分未取得
                            wb_Mesai_Flg := False;
                            //明細項目終了の場合
                            if wi_MeisaiLoop = wi_MeisaiCount then begin
                              //初期化
                              w_Kmk_No := 0;
                              //回数アップ
                              inc(w_Kmk_Count);
                            end;
                          end;
                        end;
                      //選択・必須・フリーコメント
                      88,90,91,92,93,94,97,98,99:
                        begin
                          //一番初めの場合
                          if wi_RecKbn_Comment = 0 then
                          begin
                            //電文レイアウト位置の"項目コード"の位置設定
                            wi_RecKbn_Comment := IRAICKMKCODENO;
                          end
                          //それ以外の場合
                          else
                          begin
                            //前回に＋１
                            inc(wi_RecKbn_Comment);
                          end;
                          //送信項目の情報取得
                          w_StremField := func_FindMsgField(arg_System,w_Kind,wi_RecKbn_Comment);
                          //"予備"まで終了した場合
                          if wi_RecKbn_Comment = IRAICYOBINO then
                          begin
                            wi_RecKbn_Comment := IRAICRECKBNNO;
                            Inc(wi_MeisaiLoop);
                            //レコード区分未取得
                            wb_Mesai_Flg := False;
                            //明細項目終了の場合
                            if wi_MeisaiLoop = wi_MeisaiCount then begin
                              //初期化
                              w_Kmk_No := 0;
                              //回数アップ
                              inc(w_Kmk_Count);
                            end;
                          end;
                        end;
                      //シェーマ
                      95:
                        begin
                          //一番初めの場合
                          if wi_RecKbn_Schema = 0 then
                          begin
                            //電文レイアウト位置の"シェーマ情報"の位置設定
                            wi_RecKbn_Schema := IRAISNAMENO;
                          end
                          //それ以外の場合
                          else
                          begin
                            //前回に＋１
                            inc(wi_RecKbn_Schema);
                          end;
                          //送信項目の情報取得
                          w_StremField := func_FindMsgField(arg_System,w_Kind,wi_RecKbn_Schema);
                          //"シェーマ情報"まで終了した場合
                          if wi_RecKbn_Schema = IRAISYOBINO then
                          begin
                            wi_RecKbn_Schema := IRAISRECKBNNO;
                            Inc(wi_MeisaiLoop);
                            //レコード区分未取得
                            wb_Mesai_Flg := False;
                            //明細項目終了の場合
                            if wi_MeisaiLoop = wi_MeisaiCount then begin
                              //初期化
                              w_Kmk_No := 0;
                              //回数アップ
                              inc(w_Kmk_Count);
                            end;
                          end;
                        end;
                    end;
                  end;
                end
                else
                begin
                  //電文レイアウト位置の"グループ番号"の位置設定
                  w_Kmk_No := IRAIGROUPNO;
                  //送信項目の情報取得
                  w_StremField := func_FindMsgField(arg_System,w_Kind,w_Kmk_No);
                end;
              end;
            end;
          end
          //それ以外の電文
          else
          begin
            //送信項目の情報取得
            w_StremField := func_FindMsgField(arg_System,w_Kind,w_i);
          end;
        end
        else
        begin
          //送信項目の情報取得
          w_StremField := func_FindMsgField(arg_System,w_Kind,w_i);
        end;
        //ループ開始になった場合
        if (IRAIMOKUTEKINO = w_i)  or
           (IRAISIJINO = w_i)      or
           (IRAISONOTANO = w_i)    or
           (IRAIBYOUMEINO = w_i)   then
           begin
          //送信項目の長さ取得
          w_len2 := StrToIntDef(arg_TStringList[w_i-2],0);
        end
        else
        begin
          //送信項目の長さ取得
          w_len2       := w_StremField.size;
        end;
        //リスト文字列が送信文字長より大きい場合
        if w_len1 >= w_len2 then
        begin
          //多ければ切り捨てる
          w_s := copy(w_s, 1,w_len2);
        end
        //それ以外の場合
        else
        begin
           //少なければ補完する
           //項目が文字列の場合
           if (Byte(w_StremField.x9[1]) = Byte(G_FIELD_C)) then
           begin
             //' 'を補完
             w_s := w_s + StringOfChar(' ',w_len2);
           end
           //それ以外の場合
           else
           begin
             //'0'を補完
             w_s := StringOfChar('0',w_len2) + w_s;
           end;
           //送信文字列を確定
           w_s := copy(w_s, 1,w_len2);
        end;
        //送信データの書き込み
        arg_TStringStream.WriteString(w_s);
      end;
      //電文レイアウト上の最大
      if w_MsgDeflen = w_i then
      begin
        //処理終了
        Break;
      end;
    end;
  except
    //初期化
    arg_TStringStream.Position := 0;
    //処理終了
    Exit;
  end;
end;
Procedure  proc_TStrListToStrm_Jissi(
           arg_TStringList   : TStringList;
           arg_TStringStream : TStringStream;
           arg_System        : string;
           arg_MsgKind       : string
           );
var
  w_i:integer;
  w_len1:integer;
  w_len2:integer;
  w_s:string;
  w_MsgDeflen:integer;
  w_RMsglen:integer;
  w_StremField : TStreamField;
  w_Kmk:integer;
  w_Kmk_Count:integer;
  w_Kmk_No:integer;
  w_Kind:String;
  wi_MeisaiLoop: Integer;
  wi_MeisaiCount: Integer;
  wi_RecKbn: Integer;
  wi_RecKbn_Yakuzai: Integer;
  wi_RecKbn_Comment: Integer;
  wi_RecKbn_Film: Integer;
  wi_RecKbn_Syugi: Integer;
  wb_Mesai_Flg: Boolean;
  wb_Kanri_Flg: Boolean;
begin
  //TStringList→TStringStreamに展開
  try
    //電文種別の電文長を求める
    w_MsgDeflen := func_MsgDefLen(arg_System, arg_MsgKind);
    //電文長がない場合
    if w_MsgDeflen = 0 then
    begin
      //処理終了
      Exit;
    end;
//電文長を調べる
    w_RMsglen     := 0;
    //初期化
    w_Kmk         := 0;
    w_Kmk_Count   := 0;
    w_Kmk_No      := 0;
    wi_MeisaiCount:= 0;
    wi_MeisaiLoop := 0;
    wb_Kanri_Flg  := False;
    wb_Mesai_Flg  := False;
    wi_RecKbn     := 0;
    wi_RecKbn_Yakuzai := 0;
    wi_RecKbn_Comment := 0;
    wi_RecKbn_Film    := 0;
    wi_RecKbn_Syugi   := 0;
    w_Kind := arg_MsgKind;
    //リスト数分ループ
    for w_i := 1 to arg_TStringList.Count do
    begin
      //リスト文字列の長さ取得
      w_len1       := length(arg_TStringList[w_i-1]);
      //実施情報電文の場合
      if w_Kind = G_MSGKIND_JISSI then
      begin
        case w_i of
          //グループ数項目
          CST_JISSI_LOOPSTART:
          begin
            //グループ数項目が数値の場合
            if func_IsNumber(arg_TStringList[w_i-1]) then
            begin
              //グループ数項目取得
              w_Kmk := StrToInt(arg_TStringList[w_i-1]);
            end
            else
            begin
              //グループ数項目なし
              w_Kmk := 0;
            end;
            //項目の最大数以上の場合
            if w_Kmk > CST_GROUP_LOOP_MAX then
            begin
              //項目の最大数に設定
              w_Kmk := CST_GROUP_LOOP_MAX;
            end;
          end;
        end;
        //ループ開始になった場合(グループ番号)
        if JISSIGROUPNO <= w_i then
        begin
          //項目個数がある場合
          if w_Kmk > 0 then
          begin
            //繰り返しがグループ数に達するまで
            if w_Kmk_Count <= w_Kmk then
            begin
              //グループ番号～明細数まで
              if JISSIMEISAICOUNTNO > w_Kmk_No then
              begin
                //一番初めの場合
                if w_Kmk_No = 0 then
                begin
                  if w_Kmk_Count = 0 then
                    //初期化
                    w_Kmk_Count := 1;
                  //電文レイアウト位置の"グループ番号"の位置設定
                  w_Kmk_No := JISSIGROUPNO;
                end
                //以外の場合
                else
                begin
                  //前回に＋１
                  inc(w_Kmk_No);
                end;
                //送信項目の情報取得
                w_StremField := func_FindMsgField(arg_System,w_Kind,w_Kmk_No);
                //明細数の場合
                if JISSIMEISAICOUNTNO = w_Kmk_No then
                begin
                  //レコード区分初期化
                  wi_RecKbn := 0;
                  wi_RecKbn_Yakuzai := 0;
                  wi_RecKbn_Comment := 0;
                  wi_RecKbn_Film    := 0;
                  wi_RecKbn_Syugi   := 0;
                  wi_MeisaiLoop := 0;
                  //明細数の設定
                  wi_MeisaiCount := StrToIntDef(arg_TStringList[w_i - 1],0);
                  wb_Kanri_Flg := False;
                  wb_Mesai_Flg := False;
                end;
              end
              //明細数以降の場合
              else
              begin
                //明細回数がある場合
                if (wi_MeisaiCount > 0) and
                   (wi_MeisaiLoop < wi_MeisaiCount) then
                  begin
                  if not wb_Mesai_Flg then
                  begin
                    //レコード区分設定
                    wi_RecKbn := StrToIntDef(arg_TStringList[w_i - 1],0);
                    //送信項目の情報取得
                    w_StremField := func_FindMsgField(arg_System,w_Kind,JISSIYRECORDKBNNO);
                    //レコード区分取得成功
                    wb_Mesai_Flg := True;
                  end
                  else
                  begin
                    case wi_RecKbn of
                      //薬剤
                      20,30,50,57:
                        begin
                          //一番初めの場合
                          if wi_RecKbn_Yakuzai = 0 then
                          begin
                            //電文レイアウト位置の"入力区分"の位置設定
                            wi_RecKbn_Yakuzai := JISSIYKMKCODENO;
                          end
                          //それ以外の場合
                          else
                          begin
                            //前回に＋１
                            inc(wi_RecKbn_Yakuzai);
                          end;
                          //送信項目の情報取得
                          w_StremField := func_FindMsgField(arg_System,w_Kind,wi_RecKbn_Yakuzai);
                          //"予備"まで終了した場合
                          if wi_RecKbn_Yakuzai = JISSIYYOBINO then
                          begin
                            wi_RecKbn_Yakuzai := JISSIYRECORDKBNNO;
                            Inc(wi_MeisaiLoop);
                            //レコード区分未取得
                            wb_Mesai_Flg := False;
                            //管理番号未取得
                            wb_Kanri_Flg := False;
                            //明細項目終了の場合
                            if wi_MeisaiLoop = wi_MeisaiCount then begin
                              //初期化
                              w_Kmk_No := 0;
                              //回数アップ
                              inc(w_Kmk_Count);
                            end;
                          end;
                        end;
                      //選択・必須・フリーコメント
                      88,90,91,92,93,94,97,98,99:
                        begin
                          //一番初めの場合
                          if wi_RecKbn_Comment = 0 then
                          begin
                            //電文レイアウト位置の"入力区分"の位置設定
                            wi_RecKbn_Comment := JISSICKMKCODENO;
                          end
                          //それ以外の場合
                          else
                          begin
                            //前回に＋１
                            inc(wi_RecKbn_Comment);
                          end;
                          //送信項目の情報取得
                          w_StremField := func_FindMsgField(arg_System,w_Kind,wi_RecKbn_Comment);
                          //"予備"まで終了した場合
                          if wi_RecKbn_Comment = JISSICYOBINO then
                          begin
                            wi_RecKbn_Comment := JISSICRECORDKBNNO;
                            Inc(wi_MeisaiLoop);
                            //レコード区分未取得
                            wb_Mesai_Flg := False;
                            //管理番号未取得
                            wb_Kanri_Flg := False;
                            //明細項目終了の場合
                            if wi_MeisaiLoop = wi_MeisaiCount then begin
                              //初期化
                              w_Kmk_No := 0;
                              //回数アップ
                              inc(w_Kmk_Count);
                            end;
                          end;
                        end;
                    end;
                  end;
                end
                else
                begin
                  //電文レイアウト位置の"グループ番号"の位置設定
                  w_Kmk_No := JISSIGROUPNO;
                end;
              end;
            end;
          end;
        end
        else
        begin
          //送信項目の情報取得
          w_StremField := func_FindMsgField(arg_System,w_Kind,w_i);
        end;
      end
      else
      begin
        //送信項目の情報取得
        w_StremField := func_FindMsgField(arg_System,w_Kind,w_i);
      end;
      //送信項目の長さ取得
      w_len2       := w_StremField.size;
      //リスト文字列のより送信項目の長さが小さい場合
      if w_len1 >= w_len2 then
      begin
        //設定
        w_RMsglen := w_RMsglen + w_len2;
      end
      //それ以外の場合
      else
      begin
        //設定
        w_RMsglen := w_RMsglen + w_len2;
      end;
      //電文レイアウト上の最大
      if w_MsgDeflen = w_i then
      begin
        //処理終了
        Break;
      end;
    end;
    //一ラインずつ展開
    arg_TStringStream.Position := 0;
    //初期化
    w_Kmk_Count  := 0;
    w_Kmk_No := 0;
    //リスト数分ループ
    for w_i := 1 to arg_TStringList.Count do
    begin
      //電文長項目の場合
      if w_i = COMMON1DENLENNO then
      begin
        //サイズ設定
        w_s := FormatFloat('000000', w_RMsglen);
        //電文長項目書き込み
        arg_TStringStream.WriteString(w_s);
      end
      //それ以外の項目の場合
      else
      begin
        //文字列取得
        w_s          := arg_TStringList[w_i-1];
        //送信文字列長取得
        w_len1       := length( w_s );
        //ループ開始になった場合(グループ番号)
        if JISSIGROUPNO <= w_i then
        begin
          //項目個数がある場合
          if w_Kmk > 0 then
          begin
            //繰り返しがグループ数に達するまで
            if w_Kmk_Count <= w_Kmk then
            begin
              //グループ番号～明細数まで
              if JISSIMEISAICOUNTNO > w_Kmk_No then
              begin
                //一番初めの場合
                if w_Kmk_No = 0 then
                begin
                  if w_Kmk_Count = 0 then
                    //初期化
                    w_Kmk_Count := 1;
                  //電文レイアウト位置の"グループ番号"の位置設定
                  w_Kmk_No := JISSIGROUPNO;
                end
                //以外の場合
                else
                begin
                  //前回に＋１
                  inc(w_Kmk_No);
                end;
                //送信項目の情報取得
                w_StremField := func_FindMsgField(arg_System,w_Kind,w_Kmk_No);
                //明細数の場合
                if IRAIMEISAICOUNTNO = w_Kmk_No then
                begin
                  //レコード区分初期化
                  wi_RecKbn := 0;
                  wi_RecKbn_Yakuzai := 0;
                  wi_RecKbn_Comment := 0;
                  wi_RecKbn_Film    := 0;
                  wi_RecKbn_Syugi   := 0;
                  wi_MeisaiLoop := 0;
                  //明細数の設定
                  wi_MeisaiCount := StrToIntDef(arg_TStringList[w_i - 1],0);
                  wb_Kanri_Flg := False;
                  wb_Mesai_Flg := False;
                end;
              end
              //明細数以降の場合
              else
              begin
                //明細回数がある場合
                if (wi_MeisaiCount > 0) and
                   (wi_MeisaiLoop < wi_MeisaiCount) then
                   begin
                  if not wb_Mesai_Flg then
                  begin
                    //レコード区分設定
                    wi_RecKbn := StrToIntDef(arg_TStringList[w_i - 1],0);
                    //送信項目の情報取得
                    w_StremField := func_FindMsgField(arg_System,w_Kind,JISSIYRECORDKBNNO);
                    //レコード区分取得成功
                    wb_Mesai_Flg := True;
                  end
                  else
                  begin
                    case wi_RecKbn of
                      //薬剤
                      20,30,50,57:
                        begin
                          //一番初めの場合
                          if wi_RecKbn_Yakuzai = 0 then
                          begin
                            //電文レイアウト位置の"入力区分"の位置設定
                            wi_RecKbn_Yakuzai := JISSIYKMKCODENO;
                          end
                          //それ以外の場合
                          else
                          begin
                            //前回に＋１
                            inc(wi_RecKbn_Yakuzai);
                          end;
                          //送信項目の情報取得
                          w_StremField := func_FindMsgField(arg_System,w_Kind,wi_RecKbn_Yakuzai);
                          //"予備"まで終了した場合
                          if wi_RecKbn_Yakuzai = JISSIYYOBINO then
                          begin
                            wi_RecKbn_Yakuzai := JISSIYRECORDKBNNO;
                            Inc(wi_MeisaiLoop);
                            //レコード区分未取得
                            wb_Mesai_Flg := False;
                            //管理番号未取得
                            wb_Kanri_Flg := False;
                            //明細項目終了の場合
                            if wi_MeisaiLoop = wi_MeisaiCount then begin
                              //初期化
                              w_Kmk_No := 0;
                              //回数アップ
                              inc(w_Kmk_Count);
                            end;
                          end;
                        end;
                      //選択・必須・フリーコメント
                      88,90,91,92,93,94,97,98,99:
                        begin
                          //一番初めの場合
                          if wi_RecKbn_Comment = 0 then
                          begin
                            //電文レイアウト位置の"入力区分"の位置設定
                            wi_RecKbn_Comment := JISSICKMKCODENO;
                          end
                          //それ以外の場合
                          else
                          begin
                            //前回に＋１
                            inc(wi_RecKbn_Comment);
                          end;
                          //送信項目の情報取得
                          w_StremField := func_FindMsgField(arg_System,w_Kind,wi_RecKbn_Comment);
                          //"予備"まで終了した場合
                          if wi_RecKbn_Comment = JISSICYOBINO then
                          begin
                            wi_RecKbn_Comment := JISSICRECORDKBNNO;
                            Inc(wi_MeisaiLoop);
                            //レコード区分未取得
                            wb_Mesai_Flg := False;
                            //管理番号未取得
                            wb_Kanri_Flg := False;
                            //明細項目終了の場合
                            if wi_MeisaiLoop = wi_MeisaiCount then begin
                              //初期化
                              w_Kmk_No := 0;
                              //回数アップ
                              inc(w_Kmk_Count);
                            end;
                          end;
                        end;
                    end;
                  end;
                end
                else
                begin
                  //電文レイアウト位置の"グループ番号"の位置設定
                  w_Kmk_No := IRAIGROUPNO;
                end;
              end;
            end;
          end
          //それ以外の電文
          else
          begin
            //送信項目の情報取得
            w_StremField := func_FindMsgField(arg_System,w_Kind,w_i);
          end;
        end
        else
        begin
          //送信項目の情報取得
          w_StremField := func_FindMsgField(arg_System,w_Kind,w_i);
        end;
        //送信項目の長さ取得
        w_len2       := w_StremField.size;
        //リスト文字列が送信文字長より大きい場合
        if w_len1 >= w_len2 then
        begin
          //多ければ切り捨てる
          w_s := copy(w_s, 1,w_len2);
        end
        //それ以外の場合
        else
        begin
           //少なければ補完する
           //項目が文字列の場合
           if (Byte(w_StremField.x9[1]) = Byte(G_FIELD_C)) then
           begin
             //' 'を補完
             w_s := w_s + StringOfChar(' ',w_len2);
           end
           //それ以外の場合
           else
           begin
             //'0'を補完
             w_s := StringOfChar('0',w_len2) + w_s;
           end;
           //送信文字列を確定
           w_s := copy(w_s, 1,w_len2);
        end;
        //送信データの書き込み
        arg_TStringStream.WriteString(w_s);
      end;
      //電文レイアウト上の最大
      if w_MsgDeflen = w_i then
      begin
        //処理終了
        Break;
      end;
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
  名前 : proc_TStrListToStrm2;
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
           arg_TStringStream : TStringStream;
           arg_System        : string;
           arg_MsgKind       : string
           );
var
  w_i:integer;
  w_len1:integer;
  w_s:string;
  //w_i2:Double;
begin
  //TStringList→TStringStreamに展開
  try
    //初期化
    w_len1 := 0;
    //リスト数分ループ
    for w_i := 0 to arg_TStringList.Count - 1 do begin
      //一ラインずつ展開
      arg_TStringStream.Position := w_len1;
      //データの取得
      w_s := arg_TStringList[w_i];
      if w_i = 2 then begin
        if w_s = '00' then begin
          w_S := Chr($00) + Chr($00);
        end
        else begin
          w_S := Chr($FF) + Chr($FF);
        end;
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
      result.f_Retry :=
            func_IniReadInt(
                               arg_Ini,
                               g_C_SOCKET_SECSION + arg_No,
                               g_SOCKET_RetryCount_KEY,
                               g_SOCKET_RetryCount);
      {

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
      }
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
      {
      result.f_Port :=
            func_IniReadString(
                               arg_Ini,
                               g_S_SOCKET_SECSION + arg_No,
                               g_SOCKET_PORT_KEY,
                               g_SOCKET_PORT);
      }
end;
//●機能 INIファイルの読込み
//引数：無し
//例外：無し
//復帰値：True False
function func_TcpReadiniFile: Boolean;
var
  w_ini:      TIniFile;
  wkInteger:  Integer;
begin
  Result:=True;
  try
    w_ini:=TIniFile.Create(g_TcpIniPath + G_TCPINI_FNAME);
    try
      //SERVICE情報
      g_Svc_Sd_Acvite :=
            func_IniReadString(
                               w_ini,
                               g_C_SVC_SECSION,
                               g_SVC_RESDACTIVE_KEY,
                               g_SVC_ACTIVE);
      g_Svc_Sd_Cycle :=
            func_IniReadInt(
                               w_ini,
                               g_C_SVC_SECSION,
                               g_SVC_RESDCYCLE_KEY,
                               g_SVC_SDCYCLE);
      g_Svc_Rv_Acvite :=
            func_IniReadString(
                               w_ini,
                               g_C_SVC_SECSION,
                               g_SVC_ORRVACTIVE_KEY,
                               g_SVC_ACTIVE);
      g_Svc_Rv_Cycle :=
            func_IniReadInt(
                               w_ini,
                               g_C_SVC_SECSION,
                               g_SVC_ORRVCYCLE_KEY,
                               g_SVC_RVCYCLE);
      g_Svc_Ex_Acvite :=
            func_IniReadString(
                               w_ini,
                               g_C_SVC_SECSION,
                               g_SVC_EXSDACTIVE_KEY,
                               g_SVC_ACTIVE);
      g_Svc_Ex_Cycle :=
            func_IniReadInt(
                               w_ini,
                               g_C_SVC_SECSION,
                               g_SVC_EXSDCYCLE_KEY,
                               g_SVC_SDCYCLE);
      g_Svc_Shema_Acvite :=
            func_IniReadString(
                               w_ini,
                               g_C_SVC_SECSION,
                               g_SVC_SHEMAACTIVE_KEY,
                               g_SVC_ACTIVE);
      g_Svc_Shema_Cycle :=
            func_IniReadInt(
                               w_ini,
                               g_C_SVC_SECSION,
                               g_SVC_SHEMACYCLE_KEY,
                               g_SVC_SDCYCLE);
(*
      g_Svc_Ka_Acvite :=
            func_IniReadString(
                               w_ini,
                               g_C_SVC_SECSION,
                               g_SVC_KARVACTIVE_KEY,
                               g_SVC_ACTIVE);
      g_Svc_Ka_Cycle :=
            func_IniReadInt(
                               w_ini,
                               g_C_SVC_SECSION,
                               g_SVC_KARVCYCLE_KEY,
                               g_SVC_RVCYCLE);
      g_Svc_Rs_Acvite :=
            func_IniReadString(
                               w_ini,
                               g_C_SVC_SECSION,
                               g_SVC_RSSDACTIVE_KEY,
                               g_SVC_ACTIVE);
      g_Svc_Rs_Cycle :=
            func_IniReadInt(
                               w_ini,
                               g_C_SVC_SECSION,
                               g_SVC_RSSDCYCLE_KEY,
                               g_SVC_SDCYCLE);
*)
      //DB情報
      //診断
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
      g_RisDB_SndExKeep :=
            func_IniReadInt(
                               w_ini,
                               g_C_DB_SECSION,
                               g_DB_SNDEXKEEP_KEY,
                               g_DB_SNDKEEP);
      g_RisDB_RcvKaKeep :=
            func_IniReadInt(
                               w_ini,
                               g_C_DB_SECSION,
                               g_DB_RCVKAKEEP_KEY,
                               g_DB_RCVKEEP);
      g_RisDB_SndRsKeep :=
            func_IniReadInt(
                               w_ini,
                               g_C_DB_SECSION,
                               g_DB_SNDRSKEEP_KEY,
                               g_DB_SNDKEEP);
      g_RisDB_ShemaKeep :=
            func_IniReadInt(
                               w_ini,
                               g_C_DB_SECSION,
                               g_DB_SHEMAKEEP_KEY,
                               g_DB_SNDKEEP);

(*
      g_RTRisDB_Name :=
            func_IniReadString(
                               w_ini,
                               g_C_DB_SECSION,
                               g_RTDB_NAME_KEY,
                               g_DB_NAME);
      g_RTRisDB_Uid :=
            func_IniReadString(
                               w_ini,
                               g_C_DB_SECSION,
                               g_RTDB_UID_KEY,
                               g_DB_UID);
      g_RTRisDB_Pas :=
            func_IniReadString(
                               w_ini,
                               g_C_DB_SECSION,
                               g_RTDB_PAS_KEY,
                               g_DB_PAS);
*)

      //ソケット情報
      g_C_Socket_Info_01:=func_ReadiniCInfo(w_ini,'1');
      g_C_Socket_Info_02:=func_ReadiniCInfo(w_ini,'2');
      g_C_Socket_Info_03:=func_ReadiniCInfo(w_ini,'3');
      g_C_Socket_Info_04:=func_ReadiniCInfo(w_ini,'4');
      g_C_Socket_Info_05:=func_ReadiniCInfo(w_ini,'5');
      g_S_Socket_Info_01:=func_ReadiniSInfo(w_ini,'1');
      g_S_Socket_Info_02:=func_ReadiniSInfo(w_ini,'2');
      g_S_Socket_Info_03:=func_ReadiniSInfo(w_ini,'3');
      g_S_Socket_Info_04:=func_ReadiniSInfo(w_ini,'4');
      g_S_Socket_Info_05:=func_ReadiniSInfo(w_ini,'5');
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
      //2018/08/30 ログファイル変更
      g_LogFileSize:= func_IniReadInt(
                               w_ini,
                               g_LOG_SECSION,
                               'FileSize',
                               '2000');
      //Kb → 1,000倍
      g_LogFileSize:= g_LogFileSize * 1000;                               

      //セクション：DBログ情報
      wkInteger   :=
            func_IniReadInt(
                               w_ini,
                               g_DBLOG01_SECTION,
                               g_DBLOG_LOGGING_KEY,
                               g_DBLOG_LOGGING_DEF);
      g_DBLOG01_LOGGING := False;
      if wkInteger = 1 Then g_DBLOG01_LOGGING := True;
      g_DBLOG01_PATH      :=
            func_IniReadString(
                               w_ini,
                               g_DBLOG01_SECTION,
                               g_DBLOG_PATH_KEY,
                               g_DBLOG_PATH_DEF);
      g_DBLOG01_PREFIX    :=
            func_IniReadString(
                               w_ini,
                               g_DBLOG01_SECTION,
                               g_DBLOG_PREFIX_KEY,
                               g_DBLOG_PREFIX_DEF);
      g_DBLOG01_KEEPDAYS  :=
          func_IniReadInt(
                               w_ini,
                               g_DBLOG01_SECTION,
                               g_DBLOG_KEEPDAYS_KEY,
                               g_DBLOG_KEEPDAYS_DEF);
      //セクション：DBログ情報
      wkInteger   :=
            func_IniReadInt(
                               w_ini,
                               g_DBLOG02_SECTION,
                               g_DBLOG_LOGGING_KEY,
                               g_DBLOG_LOGGING_DEF);
      g_DBLOG02_LOGGING := False;
      if wkInteger = 1 Then g_DBLOG02_LOGGING := True;
      g_DBLOG02_PATH      :=
            func_IniReadString(
                               w_ini,
                               g_DBLOG02_SECTION,
                               g_DBLOG_PATH_KEY,
                               g_DBLOG_PATH_DEF);
      g_DBLOG02_PREFIX    :=
            func_IniReadString(
                               w_ini,
                               g_DBLOG02_SECTION,
                               g_DBLOG_PREFIX_KEY,
                               g_DBLOG_PREFIX_DEF);
      g_DBLOG02_KEEPDAYS  :=
          func_IniReadInt(
                               w_ini,
                               g_DBLOG02_SECTION,
                               g_DBLOG_KEEPDAYS_KEY,
                               g_DBLOG_KEEPDAYS_DEF);
      //セクション：DBログ情報
      wkInteger   :=
            func_IniReadInt(
                               w_ini,
                               g_DBLOG03_SECTION,
                               g_DBLOG_LOGGING_KEY,
                               g_DBLOG_LOGGING_DEF);
      g_DBLOG03_LOGGING := False;
      if wkInteger = 1 Then g_DBLOG03_LOGGING := True;
      g_DBLOG03_PATH      :=
            func_IniReadString(
                               w_ini,
                               g_DBLOG03_SECTION,
                               g_DBLOG_PATH_KEY,
                               g_DBLOG_PATH_DEF);
      g_DBLOG03_PREFIX    :=
            func_IniReadString(
                               w_ini,
                               g_DBLOG03_SECTION,
                               g_DBLOG_PREFIX_KEY,
                               g_DBLOG_PREFIX_DEF);
      g_DBLOG03_KEEPDAYS  :=
          func_IniReadInt(
                               w_ini,
                               g_DBLOG03_SECTION,
                               g_DBLOG_KEEPDAYS_KEY,
                               g_DBLOG_KEEPDAYS_DEF);
      //セクション：DBログ情報
      wkInteger   :=
            func_IniReadInt(
                               w_ini,
                               g_DBLOG04_SECTION,
                               g_DBLOG_LOGGING_KEY,
                               g_DBLOG_LOGGING_DEF);
      g_DBLOG04_LOGGING := False;
      if wkInteger = 1 Then g_DBLOG04_LOGGING := True;
      g_DBLOG04_PATH      :=
            func_IniReadString(
                               w_ini,
                               g_DBLOG04_SECTION,
                               g_DBLOG_PATH_KEY,
                               g_DBLOG_PATH_DEF);
      g_DBLOG04_PREFIX    :=
            func_IniReadString(
                               w_ini,
                               g_DBLOG04_SECTION,
                               g_DBLOG_PREFIX_KEY,
                               g_DBLOG_PREFIX_DEF);
      g_DBLOG04_KEEPDAYS  :=
          func_IniReadInt(
                               w_ini,
                               g_DBLOG04_SECTION,
                               g_DBLOG_KEEPDAYS_KEY,
                               g_DBLOG_KEEPDAYS_DEF);

      //セクション：DBデバッグ情報
      wkInteger :=
            func_IniReadInt(
                               w_ini,
                               g_DBLOGDBG01_SECTION,
                               g_DBLOGDBG_LOGGING_KEY,
                               g_DBLOGDBG_LOGGING_DEF);
      g_DBLOGDBG01_LOGGING := False;
      if wkInteger = 1 Then g_DBLOGDBG01_LOGGING := True;
      g_DBLOGDBG01_PATH      :=
            func_IniReadString(
                               w_ini,
                               g_DBLOGDBG01_SECTION,
                               g_DBLOGDBG_PATH_KEY,
                               g_DBLOGDBG_PATH_DEF);
      g_DBLOGDBG01_PREFIX    :=
            func_IniReadString(
                               w_ini,
                               g_DBLOGDBG01_SECTION,
                               g_DBLOGDBG_PREFIX_KEY,
                               g_DBLOGDBG_PREFIX_DEF);
      g_DBLOGDBG01_KEEPDAYS  :=
          func_IniReadInt(
                               w_ini,
                               g_DBLOGDBG01_SECTION,
                               g_DBLOGDBG_KEEPDAYS_KEY,
                               g_DBLOGDBG_KEEPDAYS_DEF);
      //セクション：DBデバッグ情報
      wkInteger :=
            func_IniReadInt(
                               w_ini,
                               g_DBLOGDBG02_SECTION,
                               g_DBLOGDBG_LOGGING_KEY,
                               g_DBLOGDBG_LOGGING_DEF);
      g_DBLOGDBG02_LOGGING := False;
      if wkInteger = 1 Then g_DBLOGDBG02_LOGGING := True;
      g_DBLOGDBG02_PATH      :=
            func_IniReadString(
                               w_ini,
                               g_DBLOGDBG02_SECTION,
                               g_DBLOGDBG_PATH_KEY,
                               g_DBLOGDBG_PATH_DEF);
      g_DBLOGDBG02_PREFIX    :=
            func_IniReadString(
                               w_ini,
                               g_DBLOGDBG02_SECTION,
                               g_DBLOGDBG_PREFIX_KEY,
                               g_DBLOGDBG_PREFIX_DEF);
      g_DBLOGDBG02_KEEPDAYS  :=
          func_IniReadInt(
                               w_ini,
                               g_DBLOGDBG02_SECTION,
                               g_DBLOGDBG_KEEPDAYS_KEY,
                               g_DBLOGDBG_KEEPDAYS_DEF);
      //セクション：DBデバッグ情報
      wkInteger :=
            func_IniReadInt(
                               w_ini,
                               g_DBLOGDBG03_SECTION,
                               g_DBLOGDBG_LOGGING_KEY,
                               g_DBLOGDBG_LOGGING_DEF);
      g_DBLOGDBG03_LOGGING := False;
      if wkInteger = 1 Then g_DBLOGDBG03_LOGGING := True;
      g_DBLOGDBG03_PATH      :=
            func_IniReadString(
                               w_ini,
                               g_DBLOGDBG03_SECTION,
                               g_DBLOGDBG_PATH_KEY,
                               g_DBLOGDBG_PATH_DEF);
      g_DBLOGDBG03_PREFIX    :=
            func_IniReadString(
                               w_ini,
                               g_DBLOGDBG03_SECTION,
                               g_DBLOGDBG_PREFIX_KEY,
                               g_DBLOGDBG_PREFIX_DEF);
      g_DBLOGDBG03_KEEPDAYS  :=
          func_IniReadInt(
                               w_ini,
                               g_DBLOGDBG03_SECTION,
                               g_DBLOGDBG_KEEPDAYS_KEY,
                               g_DBLOGDBG_KEEPDAYS_DEF);
      //セクション：DBデバッグ情報
      wkInteger :=
            func_IniReadInt(
                               w_ini,
                               g_DBLOGDBG04_SECTION,
                               g_DBLOGDBG_LOGGING_KEY,
                               g_DBLOGDBG_LOGGING_DEF);
      g_DBLOGDBG04_LOGGING := False;
      if wkInteger = 1 Then g_DBLOGDBG04_LOGGING := True;
      g_DBLOGDBG04_PATH      :=
            func_IniReadString(
                               w_ini,
                               g_DBLOGDBG04_SECTION,
                               g_DBLOGDBG_PATH_KEY,
                               g_DBLOGDBG_PATH_DEF);
      g_DBLOGDBG04_PREFIX    :=
            func_IniReadString(
                               w_ini,
                               g_DBLOGDBG04_SECTION,
                               g_DBLOGDBG_PREFIX_KEY,
                               g_DBLOGDBG_PREFIX_DEF);
      g_DBLOGDBG04_KEEPDAYS  :=
          func_IniReadInt(
                               w_ini,
                               g_DBLOGDBG04_SECTION,
                               g_DBLOGDBG_KEEPDAYS_KEY,
                               g_DBLOGDBG_KEEPDAYS_DEF);

      g_RomaFlg_1 :=
            func_IniReadInt(
                               w_ini,
                               g_ROMA_SECSION,
                               g_ROMA_1_KEY,
                               g_ROMA_1_DEF);
      g_RomaFlg_2 :=
            func_IniReadInt(
                               w_ini,
                               g_ROMA_SECSION,
                               g_ROMA_2_KEY,
                               g_ROMA_2_DEF);
      g_RomaFlg_3 :=
            func_IniReadInt(
                               w_ini,
                               g_ROMA_SECSION,
                               g_ROMA_3_KEY,
                               g_ROMA_3_DEF);
      g_RomaFlg_4 :=
            func_IniReadInt(
                               w_ini,
                               g_ROMA_SECSION,
                               g_ROMA_4_KEY,
                               g_ROMA_4_DEF);

      proc_ReadiniKenzo(w_ini,g_KanjaJyoutai);
      proc_ReadiniFlg(w_ini);
      proc_ReadiniType(w_ini);

      g_RIOrder :=
            func_IniReadString(
                               w_ini,
                               g_RIORDER_SECSION,
                               g_RIORDER_KEY,
                               g_RIORDER_DEF);

(*
      g_RISType_List := TStringList.Create;

      g_RISType_List.CommaText :=
            func_IniReadString(
                               w_ini,
                               g_TYPE_SECSION,
                               g_TYPEO1_KEY,
                               '');

      g_TheraRisType_List := TStringList.Create;

      g_TheraRisType_List.CommaText :=
            func_IniReadString(
                               w_ini,
                               g_TYPE_SECSION,
                               g_TYPEO2_KEY,
                               '');

      g_Report_List := TStringList.Create;

      g_Report_List.CommaText :=
            func_IniReadString(
                               w_ini,
                               g_TYPE_SECSION,
                               g_TYPEO3_KEY,
                               '');

      g_RRISUser :=
            func_IniReadString(
                               w_ini,
                               g_RRIS_SECSION,
                               g_RRIS_KEY,
                               g_RRIS_DEF);
      g_RTRISUser :=
            func_IniReadString(
                               w_ini,
                               g_RTRIS_SECSION,
                               g_RTRIS_KEY,
                               g_RTRIS_DEF);
*)

      g_NotesMake_Kangokbn_List := TStringList.Create;

      g_NotesMake_Kangokbn_List.CommaText :=
            func_IniReadString(
                               w_ini,
                               g_NOTESMARK_SECSION,
                               g_KANGOKBN_KEY,
                               '');

      g_NotesMake_Kanjakbn_List := TStringList.Create;

      g_NotesMake_Kanjakbn_List.CommaText :=
            func_IniReadString(
                               w_ini,
                               g_NOTESMARK_SECSION,
                               g_KANJAKBN_KEY,
                               '');

      //2007.07.04
      g_KOUMOKU_CODE :=
            func_IniReadString(
                               w_ini,
                               g_KOUMOKU_CODE_SECSION,
                               g_KOUMOKUCODE_KEY,
                               g_DEFKOUMOKUCODE);
      //2007.07.04
      g_NOT_ACCOUNT :=
            func_IniReadString(
                               w_ini,
                               g_KOUMOKU_CODE_SECSION,
                               g_NOT_ACCOUNT_KEY,
                               g_DEFNOT_ACCOUNT);
      //2007.07.04
      g_MESAI_KOUMOKU_CODE :=
            func_IniReadString(
                               w_ini,
                               g_MEISAI_CODE_SECSION,
                               g_MEISAICODE_KEY,
                               g_DEFMEISAICODE);
      //2007.07.04
      g_MESAI_NOT_ACCOUNT :=
            func_IniReadString(
                               w_ini,
                               g_MEISAI_CODE_SECSION,
                               g_MEISAINOT_ACCOUNT_KEY,
                               g_DEFMEISAINOT_ACCOUNT);


      g_HIS_List := TStringList.Create;

      g_HIS_List.CommaText :=
            func_IniReadString(
                               w_ini,
                               g_HIS_SECSION,
                               g_HIS_ID_KEY,
                               '');

      g_SHEMA_HIS_PASS :=
            func_IniReadString(
                               w_ini,
                               g_SHEMA_SECSION,
                               g_SHEMA_HIS_KEY,
                               '');
      g_SHEMA_HIS_PASS := IncludeTrailingPathDelimiter(g_SHEMA_HIS_PASS);

      g_SHEMA_LOCAL_PASS :=
            func_IniReadString(
                               w_ini,
                               g_SHEMA_SECSION,
                               g_SHEMA_LOCAL_KEY,
                               '');
      //INIファイルと同じ場所
      if not(DirectoryExists(g_SHEMA_LOCAL_PASS)) then
         g_SHEMA_LOCAL_PASS := g_TcpIniPath;

      g_SHEMA_LOCAL_PASS := IncludeTrailingPathDelimiter(g_SHEMA_LOCAL_PASS);

      g_SHEMA_HTML_PASS :=
            func_IniReadString(
                               w_ini,
                               g_SHEMA_SECSION,
                               g_SHEMA_HTML_KEY,
                               '');
      //INIファイルと同じ場所
      if not(DirectoryExists(g_SHEMA_HTML_PASS)) then
         g_SHEMA_HTML_PASS := g_TcpIniPath;

      g_SHEMA_HTML_PASS := IncludeTrailingPathDelimiter(g_SHEMA_HTML_PASS);
      //2008.09.12 ---
      g_LOGONPASS :=
            func_IniReadString(
                               w_ini,
                               g_SHEMA_SECSION,
                               g_LOGONPASS_KEY,
                               '');
      g_LOGONUSER :=
            func_IniReadString(
                               w_ini,
                               g_SHEMA_SECSION,
                               g_LOGONUSER_KEY,
                               '');
      g_LOGONRETRY :=
            func_IniReadInt(
                               w_ini,
                               g_SHEMA_SECSION,
                               g_LOGONRETRY_KEY,
                               '0');
(*
      //--- 2008.09.12
      g_ENTRY_USER :=
            func_IniReadString(
                               w_ini,
                               g_ENTRY_SECSION,
                               g_ENTRY_USER_KEY,
                               g_ENTRY_USER_DEF);
      g_ENTRY_USERNAME :=
            func_IniReadString(
                               w_ini,
                               g_ENTRY_SECSION,
                               g_ENTRY_USERNAME_KEY,
                               g_ENTRY_USERNAME_DEF);
*)
    finally
      w_ini.Free;
    end;
  exit;
  except
    Result:=False;
    exit;
  end;

end;
//●機能 INIファイルの読込み
//引数：無し
//例外：無し
//復帰値：True False
function func_RTTcpReadiniFile: Boolean;
var
  w_ini:      TIniFile;
  wkInteger:  Integer;
begin
  Result:=True;
  try
    w_ini:=TIniFile.Create(g_TcpIniPath + G_RTTCPINI_FNAME);
    try
      //SERVICE情報
      g_RTSvc_Ex_Acvite :=
            func_IniReadString(
                               w_ini,
                               g_C_SVC_SECSION,
                               g_SVC_EXSDACTIVE_KEY,
                               g_SVC_ACTIVE);
      g_RTSvc_Ex_Cycle :=
            func_IniReadInt(
                               w_ini,
                               g_C_SVC_SECSION,
                               g_SVC_EXSDCYCLE_KEY,
                               g_SVC_SDCYCLE);
      g_RTSvc_Re_Acvite :=
            func_IniReadString(
                               w_ini,
                               g_C_SVC_SECSION,
                               g_SVC_RESDACTIVE_KEY,
                               g_SVC_ACTIVE);
      g_RTSvc_Re_Cycle :=
            func_IniReadInt(
                               w_ini,
                               g_C_SVC_SECSION,
                               g_SVC_RESDCYCLE_KEY,
                               g_SVC_RVCYCLE);
      //DB情報
(*
      g_RTRisDB_Name :=
            func_IniReadString(
                               w_ini,
                               g_C_DB_SECSION,
                               g_RTDB_NAME_KEY,
                               g_DB_NAME);
      g_RTRisDB_Uid :=
            func_IniReadString(
                               w_ini,
                               g_C_DB_SECSION,
                               g_RTDB_UID_KEY,
                               g_DB_UID);
      g_RTRisDB_Pas :=
            func_IniReadString(
                               w_ini,
                               g_C_DB_SECSION,
                               g_RTDB_PAS_KEY,
                               g_DB_PAS);
*)

      g_RisDB_Retry :=
            func_IniReadInt(
                               w_ini,
                               g_C_DB_SECSION,
                               g_DB_RETRY_KEY,
                               g_DB_RETRY);
      g_RTRisDB_SndEXKeep :=
            func_IniReadInt(
                               w_ini,
                               g_C_DB_SECSION,
                               g_DB_SNDEXKEEP_KEY,
                               g_DB_SNDKEEP);
      g_RTRisDB_ReKeep :=
            func_IniReadInt(
                               w_ini,
                               g_C_DB_SECSION,
                               g_DB_SNDREKEEP_KEY,
                               g_DB_SNDKEEP);
      //ソケット情報
      g_C_RTSocket_Info_01:=func_ReadiniCInfo(w_ini,'1');
      g_C_RTSocket_Info_02:=func_ReadiniCInfo(w_ini,'2');
      g_S_RTSocket_Info_01:=func_ReadiniSInfo(w_ini,'1');
      g_S_RTSocket_Info_02:=func_ReadiniSInfo(w_ini,'2');
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

      //セクション：DBログ情報
      wkInteger   :=
            func_IniReadInt(
                               w_ini,
                               g_DBLOG01_SECTION,
                               g_DBLOG_LOGGING_KEY,
                               g_DBLOG_LOGGING_DEF);
      g_DBLOG01_LOGGING := False;
      if wkInteger = 1 Then g_DBLOG01_LOGGING := True;
      g_DBLOG01_PATH      :=
            func_IniReadString(
                               w_ini,
                               g_DBLOG01_SECTION,
                               g_DBLOG_PATH_KEY,
                               g_DBLOG_PATH_DEF);
      g_DBLOG01_PREFIX    :=
            func_IniReadString(
                               w_ini,
                               g_DBLOG01_SECTION,
                               g_DBLOG_PREFIX_KEY,
                               g_DBLOG_PREFIX_DEF);
      g_DBLOG01_KEEPDAYS  :=
          func_IniReadInt(
                               w_ini,
                               g_DBLOG01_SECTION,
                               g_DBLOG_KEEPDAYS_KEY,
                               g_DBLOG_KEEPDAYS_DEF);
      //セクション：DBログ情報
      wkInteger   :=
            func_IniReadInt(
                               w_ini,
                               g_DBLOG02_SECTION,
                               g_DBLOG_LOGGING_KEY,
                               g_DBLOG_LOGGING_DEF);
      g_DBLOG02_LOGGING := False;
      if wkInteger = 1 Then g_DBLOG02_LOGGING := True;
      g_DBLOG02_PATH      :=
            func_IniReadString(
                               w_ini,
                               g_DBLOG02_SECTION,
                               g_DBLOG_PATH_KEY,
                               g_DBLOG_PATH_DEF);
      g_DBLOG02_PREFIX    :=
            func_IniReadString(
                               w_ini,
                               g_DBLOG02_SECTION,
                               g_DBLOG_PREFIX_KEY,
                               g_DBLOG_PREFIX_DEF);
      g_DBLOG02_KEEPDAYS  :=
          func_IniReadInt(
                               w_ini,
                               g_DBLOG02_SECTION,
                               g_DBLOG_KEEPDAYS_KEY,
                               g_DBLOG_KEEPDAYS_DEF);
      //セクション：DBログ情報
      wkInteger   :=
            func_IniReadInt(
                               w_ini,
                               g_DBLOG03_SECTION,
                               g_DBLOG_LOGGING_KEY,
                               g_DBLOG_LOGGING_DEF);
      g_DBLOG03_LOGGING := False;
      if wkInteger = 1 Then g_DBLOG03_LOGGING := True;
      g_DBLOG03_PATH      :=
            func_IniReadString(
                               w_ini,
                               g_DBLOG03_SECTION,
                               g_DBLOG_PATH_KEY,
                               g_DBLOG_PATH_DEF);
      g_DBLOG03_PREFIX    :=
            func_IniReadString(
                               w_ini,
                               g_DBLOG03_SECTION,
                               g_DBLOG_PREFIX_KEY,
                               g_DBLOG_PREFIX_DEF);
      g_DBLOG03_KEEPDAYS  :=
          func_IniReadInt(
                               w_ini,
                               g_DBLOG03_SECTION,
                               g_DBLOG_KEEPDAYS_KEY,
                               g_DBLOG_KEEPDAYS_DEF);
      //セクション：DBログ情報
      wkInteger   :=
            func_IniReadInt(
                               w_ini,
                               g_DBLOG04_SECTION,
                               g_DBLOG_LOGGING_KEY,
                               g_DBLOG_LOGGING_DEF);
      g_DBLOG04_LOGGING := False;
      if wkInteger = 1 Then g_DBLOG04_LOGGING := True;
      g_DBLOG04_PATH      :=
            func_IniReadString(
                               w_ini,
                               g_DBLOG04_SECTION,
                               g_DBLOG_PATH_KEY,
                               g_DBLOG_PATH_DEF);
      g_DBLOG04_PREFIX    :=
            func_IniReadString(
                               w_ini,
                               g_DBLOG04_SECTION,
                               g_DBLOG_PREFIX_KEY,
                               g_DBLOG_PREFIX_DEF);
      g_DBLOG04_KEEPDAYS  :=
          func_IniReadInt(
                               w_ini,
                               g_DBLOG04_SECTION,
                               g_DBLOG_KEEPDAYS_KEY,
                               g_DBLOG_KEEPDAYS_DEF);

      //セクション：DBデバッグ情報
      wkInteger :=
            func_IniReadInt(
                               w_ini,
                               g_DBLOGDBG01_SECTION,
                               g_DBLOGDBG_LOGGING_KEY,
                               g_DBLOGDBG_LOGGING_DEF);
      g_DBLOGDBG01_LOGGING := False;
      if wkInteger = 1 Then g_DBLOGDBG01_LOGGING := True;
      g_DBLOGDBG01_PATH      :=
            func_IniReadString(
                               w_ini,
                               g_DBLOGDBG01_SECTION,
                               g_DBLOGDBG_PATH_KEY,
                               g_DBLOGDBG_PATH_DEF);
      g_DBLOGDBG01_PREFIX    :=
            func_IniReadString(
                               w_ini,
                               g_DBLOGDBG01_SECTION,
                               g_DBLOGDBG_PREFIX_KEY,
                               g_DBLOGDBG_PREFIX_DEF);
      g_DBLOGDBG01_KEEPDAYS  :=
          func_IniReadInt(
                               w_ini,
                               g_DBLOGDBG01_SECTION,
                               g_DBLOGDBG_KEEPDAYS_KEY,
                               g_DBLOGDBG_KEEPDAYS_DEF);
      //セクション：DBデバッグ情報
      wkInteger :=
            func_IniReadInt(
                               w_ini,
                               g_DBLOGDBG02_SECTION,
                               g_DBLOGDBG_LOGGING_KEY,
                               g_DBLOGDBG_LOGGING_DEF);
      g_DBLOGDBG02_LOGGING := False;
      if wkInteger = 1 Then g_DBLOGDBG02_LOGGING := True;
      g_DBLOGDBG02_PATH      :=
            func_IniReadString(
                               w_ini,
                               g_DBLOGDBG02_SECTION,
                               g_DBLOGDBG_PATH_KEY,
                               g_DBLOGDBG_PATH_DEF);
      g_DBLOGDBG02_PREFIX    :=
            func_IniReadString(
                               w_ini,
                               g_DBLOGDBG02_SECTION,
                               g_DBLOGDBG_PREFIX_KEY,
                               g_DBLOGDBG_PREFIX_DEF);
      g_DBLOGDBG02_KEEPDAYS  :=
          func_IniReadInt(
                               w_ini,
                               g_DBLOGDBG02_SECTION,
                               g_DBLOGDBG_KEEPDAYS_KEY,
                               g_DBLOGDBG_KEEPDAYS_DEF);
      //セクション：DBデバッグ情報
      wkInteger :=
            func_IniReadInt(
                               w_ini,
                               g_DBLOGDBG03_SECTION,
                               g_DBLOGDBG_LOGGING_KEY,
                               g_DBLOGDBG_LOGGING_DEF);
      g_DBLOGDBG03_LOGGING := False;
      if wkInteger = 1 Then g_DBLOGDBG03_LOGGING := True;
      g_DBLOGDBG03_PATH      :=
            func_IniReadString(
                               w_ini,
                               g_DBLOGDBG03_SECTION,
                               g_DBLOGDBG_PATH_KEY,
                               g_DBLOGDBG_PATH_DEF);
      g_DBLOGDBG03_PREFIX    :=
            func_IniReadString(
                               w_ini,
                               g_DBLOGDBG03_SECTION,
                               g_DBLOGDBG_PREFIX_KEY,
                               g_DBLOGDBG_PREFIX_DEF);
      g_DBLOGDBG03_KEEPDAYS  :=
          func_IniReadInt(
                               w_ini,
                               g_DBLOGDBG03_SECTION,
                               g_DBLOGDBG_KEEPDAYS_KEY,
                               g_DBLOGDBG_KEEPDAYS_DEF);
      //セクション：DBデバッグ情報
      wkInteger :=
            func_IniReadInt(
                               w_ini,
                               g_DBLOGDBG04_SECTION,
                               g_DBLOGDBG_LOGGING_KEY,
                               g_DBLOGDBG_LOGGING_DEF);
      g_DBLOGDBG04_LOGGING := False;
      if wkInteger = 1 Then g_DBLOGDBG04_LOGGING := True;
      g_DBLOGDBG04_PATH      :=
            func_IniReadString(
                               w_ini,
                               g_DBLOGDBG04_SECTION,
                               g_DBLOGDBG_PATH_KEY,
                               g_DBLOGDBG_PATH_DEF);
      g_DBLOGDBG04_PREFIX    :=
            func_IniReadString(
                               w_ini,
                               g_DBLOGDBG04_SECTION,
                               g_DBLOGDBG_PREFIX_KEY,
                               g_DBLOGDBG_PREFIX_DEF);
      g_DBLOGDBG04_KEEPDAYS  :=
          func_IniReadInt(
                               w_ini,
                               g_DBLOGDBG04_SECTION,
                               g_DBLOGDBG_KEEPDAYS_KEY,
                               g_DBLOGDBG_KEEPDAYS_DEF);

      {
      g_RISType_List := TStringList.Create;

      g_RISType_List.CommaText :=
            func_IniReadString(
                               w_ini,
                               g_TYPE_SECSION,
                               g_TYPEO1_KEY,
                               '');

      g_TheraRisType_List := TStringList.Create;

      g_TheraRisType_List.CommaText :=
            func_IniReadString(
                               w_ini,
                               g_TYPE_SECSION,
                               g_TYPEO2_KEY,
                               '');
      }
(*
      g_RRISUser :=
            func_IniReadString(
                               w_ini,
                               g_RRIS_SECSION,
                               g_RRIS_KEY,
                               g_RRIS_DEF);
      g_RTRISUser :=
            func_IniReadString(
                               w_ini,
                               g_RTRIS_SECSION,
                               g_RTRIS_KEY,
                               g_RTRIS_DEF);
*)

      g_HIS_TYPE :=
            func_IniReadString(
                               w_ini,
                               g_HIS_TYPE_SECSION,
                               g_HIS_TYPE_KEY,
                               g_HIS_TYPE_DEF);

      g_HIS_KOUMOKU :=
            func_IniReadString(
                               w_ini,
                               g_HIS_KOUMOKU_SECSION,
                               g_HIS_KOUMOKU_KEY,
                               g_HIS_KOUMOKU_DEF);

      g_HIS_BUI :=
            func_IniReadString(
                               w_ini,
                               g_HIS_BUI_SECSION,
                               g_HIS_BUI_KEY,
                               g_HIS_BUI_DEF);

      g_ONCALL_AM :=
            func_IniReadString(
                               w_ini,
                               g_ONCALL_SECSION,
                               g_ONCALL_AM_KEY,
                               g_ONCALL_AM_DEF);
      g_ONCALL_PM :=
            func_IniReadString(
                               w_ini,
                               g_ONCALL_SECSION,
                               g_ONCALL_PM_KEY,
                               g_ONCALL_PM_DEF);

      g_HIS_EXSECTION :=
            func_IniReadString(
                               w_ini,
                               g_HIS_EXSECTION_SECSION,
                               g_HIS_EXSECTION_KEY,
                               g_HIS_EXSECTION_DEF);
      g_HIS_EXDR :=
            func_IniReadString(
                               w_ini,
                               g_HIS_EXSECTION_SECSION,
                               g_HIS_EXDR_KEY,
                               g_HIS_EXDR_DEF);

      g_COM_TITLE1 :=
            func_IniReadString(
                               w_ini,
                               g_HIS_EXCOMTITLE_SECSION,
                               g_HIS_TITLE1_KEY,
                               g_HIS_TITLE1_DEF);
      g_COM_TITLE2 :=
            func_IniReadString(
                               w_ini,
                               g_HIS_EXCOMTITLE_SECSION,
                               g_HIS_TITLE2_KEY,
                               g_HIS_TITLE2_DEF);
    finally
      w_ini.Free;
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
  buffer: string;
  fp: TextFile;
  wd_DateTime: TDateTime;
  wd_FileDateTime: TDateTime;
begin
  // ログが無効の場合は、何もしない。
  if g_Rig_LogActive = g_SOCKET_LOGDEACTIVE then
    Exit;
  // NGのみ出力で
  // ステータスがNG以外の場合は何もしない
  if (g_Rig_LogActive = g_SOCKET_LOGACTIVE2) and
     (arg_Status <> G_LOG_LINE_HEAD_NG)      then
    Exit;
  try
    //現在時間の取得
    wd_DateTime := Now;
    //ファイル名の作成
    w_LogFile := g_Rig_LogPath + g_LogPlefix + FormatDateTime('dd', wd_DateTime) + G_LOG_PKT_PTH_DEF;
    //時刻の補完
    if func_IsNullStr(arg_Time) then
      arg_Time:=FormatDateTime('yyyy/mm/dd hh:mm:ss', Now);
    //出力メッセージ構成
    buffer := arg_Status + ',' + arg_Time + ',' + arg_Operate;

    //2018/08/30 ログファイル変更
    FLog.LOGOUT(buffer);
  except
    exit;
  end;
end;
//ログ文字列作成
function  func_LogStr(arg_Kind:integer; arg_Diteil:string): string;
var
  w_s:string;
begin
  //ログ種別で指定された文字列を取得
  w_s := g_Log_Type[arg_Kind].f_LogMsg + StringOfChar(chr($20),G_LOGGMSG_LEN);
  //文字列を整える
  w_s := func_BCopy(w_s,G_LOGGMSG_LEN);
  //付帯文字列と組み合わせる
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
    //ログ文字列＋付帯文字列
    w_s := func_LogStr(arg_Kind,arg_Diteil);
    //iniファイルのログレベルがログ内容種別以上の場合
    if (g_Log_Type[arg_Kind].f_LogLevel <= StrToIntDef(g_Rig_LogLevel,0)) then begin
      //ログ出力
      proc_LogOperate(arg_Status,arg_Time,w_s);
    end;
  except
    //処理終了
    Exit;
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
    wkBuf := TrimRight(func_BCopy(EditStr,intCapa));
    if Length(wkBuf) < intCapa then
    begin
      wkBuf := wkBuf + chr(32);
    end;
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

procedure proc_Change_Byte(var arg_Length: String);
var
  Mdp: String Absolute arg_Length;
  w_s1,w_s2,w_s3,w_s4,w_s5:String;
begin
  w_s1 := '0';
  w_s2 := '0';
  w_s3 := '0';
  w_s4 := '0';
  w_s5 := '0';

  w_s1 := Copy(Mdp,1,1);
  w_s2 := Copy(Mdp,2,1);
  w_s3 := Copy(Mdp,3,1);
  w_s4 := Copy(Mdp,4,1);
  w_s5 := Copy(Mdp,5,1);

  Mdp := w_s5 + w_s4 + w_s3 + w_s2 + w_s1;
end;
(**
●HIS伝票コードから対応するRIS検査種別を検索する
引数：
  arg_HisID : String; HIS伝票コード
例外：無し
復帰値：RIS検査種別　String
**)
function func_HisToRis(arg_HisID:String):String;
var
  w_Kensa:String;
  w_i:Integer;
begin
  //初期化
  w_Kensa := '';
  //初期設定ファイルにある伝票コード分
  for w_i := 0 to Length(g_Kensa_ID) - 1 do begin
    //同じ伝票コードがあった場合
    if arg_HisID = g_Kensa_ID[w_i].f_HIS_ID then
      //RIS検査種別に変換
      w_Kensa := g_Kensa_ID[w_i].f_RIS_ID;
  end;
  //検査種別変換
  Result := w_Kensa;
end;
(**
●RIS検査種別から対応するHIS伝票コードを検索する
引数：
  arg_RisID : String; RIS検査種別
例外：無し
復帰値：HIS伝票コード　String
**)
function func_RisToHis(arg_RisID:String):String;
var
  w_Kensa:String;
  w_i:Integer;
begin
  //初期化
  w_Kensa := '';
  //初期設定ファイルにある伝票コード分
  for w_i := 0 to Length(g_Kensa_ID) - 1 do begin
    //同じ検査種別があった場合
    if arg_RisID = g_Kensa_ID[w_i].f_RIS_ID then
      //伝票コードに変換
      w_Kensa := g_Kensa_ID[w_i].f_HIS_ID;
  end;
  //伝票コード変換
  Result := w_Kensa;
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
                           var arg_Kanja:TStrings
                           );
var
  w_i:Integer;
  w_Pos:Integer;
begin

  arg_Kanja := TStringList.Create;

  arg_Ini.ReadSectionValues(g_KANJA_SECSION,arg_Kanja);

  for w_i := 0 to arg_Kanja.Count - 1 do begin
    w_Pos := Pos('=',arg_Kanja[w_i]);
    if w_Pos <> 0 then begin
      arg_Kanja[w_i] := Copy(arg_Kanja[w_i],w_Pos + 1,Length(arg_Kanja[w_i]));
    end;
  end;
end;
(**
●フラグ情報部分の読込み
引数：
  arg_Ini : TIniFile;
例外：無し
復帰値：
**)
procedure proc_ReadiniFlg(
                          arg_Ini : TIniFile
                          );
var
  w_i   : Integer;
  w_Pos : Integer;
  wsl_List : TStrings;
  wsl_List2 : TStrings;
  w_i2   : Integer;
begin

  //看護区分
  g_KangoKbn_List := TStringList.Create;
  g_KangoName_List := TStringList.Create;
  //ワーク
  wsl_List := TStringList.Create;

  arg_Ini.ReadSectionValues(g_KANGO_SECSION,wsl_List);


  for w_i := 0 to wsl_List.Count - 1 do
  begin
    w_Pos := Pos('=',wsl_List[w_i]);
    if w_Pos <> 0 then
    begin
      g_KangoKbn_List.Add(Copy(wsl_List[w_i], 1, w_Pos - 1));
      g_KangoName_List.Add(Copy(wsl_List[w_i],w_Pos + 1,Length(wsl_List[w_i])));
    end;
  end;

  if wsl_List.Count = 0 then
  begin
    //初期値設定
    g_KangoKbn_List.Add(DEF_HIS_KANGO_1);
    g_KangoKbn_List.Add(DEF_HIS_KANGO_2);
    g_KangoKbn_List.Add(DEF_HIS_KANGO_3);
    g_KangoKbn_List.Add(CSTNULLDATAKEY);
    g_KangoName_List.Add(DEF_KANGO_1_NAME);
    g_KangoName_List.Add(DEF_KANGO_2_NAME);
    g_KangoName_List.Add(DEF_KANGO_3_NAME);
    g_KangoName_List.Add(DEF_KANGO_9_NAME);
  end;

  //患者区分
  g_KanjaKbn_List := TStringList.Create;
  g_KanjaName_List := TStringList.Create;
  //ワーク
  wsl_List.Clear;

  arg_Ini.ReadSectionValues(g_KANJA_SECSION,wsl_List);


  for w_i := 0 to wsl_List.Count - 1 do
  begin
    w_Pos := Pos('=',wsl_List[w_i]);
    if w_Pos <> 0 then
    begin
      g_KanjaKbn_List.Add(Copy(wsl_List[w_i], 1, w_Pos - 1));
      g_KanjaName_List.Add(Copy(wsl_List[w_i],w_Pos + 1,Length(wsl_List[w_i])));
    end;
  end;

  if wsl_List.Count = 0 then
  begin
    //初期値設定
    g_KanjaKbn_List.Add(DEF_HIS_KANJA_1);
    g_KanjaKbn_List.Add(DEF_HIS_KANJA_2);
    g_KanjaKbn_List.Add(DEF_HIS_KANJA_3);
    g_KanjaKbn_List.Add(DEF_HIS_KANJA_4);
    g_KanjaKbn_List.Add(CSTNULLDATAKEY);
    g_KanjaName_List.Add(DEF_KANJA_1_NAME);
    g_KanjaName_List.Add(DEF_KANJA_2_NAME);
    g_KanjaName_List.Add(DEF_KANJA_3_NAME);
    g_KanjaName_List.Add(DEF_KANJA_4_NAME);
    g_KanjaName_List.Add(DEF_KANJA_9_NAME);
  end;

  //救護区分
  g_KyuugoKbn_List := TStringList.Create;
  g_KyuugoName_List := TStringList.Create;
  //ワーク
  wsl_List.Clear;

  arg_Ini.ReadSectionValues(g_KYUGO_SECSION,wsl_List);


  for w_i := 0 to wsl_List.Count - 1 do
  begin
    w_Pos := Pos('=',wsl_List[w_i]);
    if w_Pos <> 0 then
    begin
      g_KyuugoKbn_List.Add(Copy(wsl_List[w_i], 1, w_Pos - 1));
      g_KyuugoName_List.Add(Copy(wsl_List[w_i],w_Pos + 1,Length(wsl_List[w_i])));
    end;
  end;

  if wsl_List.Count = 0 then
  begin
    //初期値設定
    g_KyuugoKbn_List.Add(DEF_HIS_KYUGO_1);
    g_KyuugoKbn_List.Add(DEF_HIS_KYUGO_2);
    g_KyuugoKbn_List.Add(DEF_HIS_KYUGO_3);
    g_KyuugoKbn_List.Add(CSTNULLDATAKEY);
    g_KyuugoName_List.Add(DEF_KYUGO_1_NAME);
    g_KyuugoName_List.Add(DEF_KYUGO_2_NAME);
    g_KyuugoName_List.Add(DEF_KYUGO_3_NAME);
    g_KyuugoName_List.Add(DEF_KYUGO_9_NAME);
  end;

  //血液型ABO
  g_ABOCode_List := TStringList.Create;
  g_ABOName_List := TStringList.Create;
  //ワーク
  wsl_List.Clear;

  arg_Ini.ReadSectionValues(g_BLOODABO_SECSION,wsl_List);


  for w_i := 0 to wsl_List.Count - 1 do
  begin
    w_Pos := Pos('=',wsl_List[w_i]);
    if w_Pos <> 0 then
    begin
      g_ABOCode_List.Add(Copy(wsl_List[w_i], 1, w_Pos - 1));
      g_ABOName_List.Add(Copy(wsl_List[w_i],w_Pos + 1,Length(wsl_List[w_i])));
    end;
  end;

  if wsl_List.Count = 0 then
  begin
    //初期値設定
    g_ABOCode_List.Add(DEF_HIS_BLOODABO_1);
    g_ABOCode_List.Add(DEF_HIS_BLOODABO_2);
    g_ABOCode_List.Add(DEF_HIS_BLOODABO_3);
    g_ABOCode_List.Add(DEF_HIS_BLOODABO_4);
    g_ABOCode_List.Add(CSTNULLDATAKEY);
    g_ABOName_List.Add(DEF_BLOODABO_1_NAME);
    g_ABOName_List.Add(DEF_BLOODABO_2_NAME);
    g_ABOName_List.Add(DEF_BLOODABO_3_NAME);
    g_ABOName_List.Add(DEF_BLOODABO_4_NAME);
    g_ABOName_List.Add(DEF_BLOODABO_9_NAME);
  end;

  //血液型RH
  g_RHCode_List := TStringList.Create;
  g_RHName_List := TStringList.Create;
  //ワーク
  wsl_List.Clear;

  arg_Ini.ReadSectionValues(g_BLOODRH_SECSION,wsl_List);


  for w_i := 0 to wsl_List.Count - 1 do
  begin
    w_Pos := Pos('=',wsl_List[w_i]);
    if w_Pos <> 0 then
    begin
      g_RHCode_List.Add(Copy(wsl_List[w_i], 1, w_Pos - 1));
      g_RHName_List.Add(Copy(wsl_List[w_i],w_Pos + 1,Length(wsl_List[w_i])));
    end;
  end;

  if wsl_List.Count = 0 then
  begin
    //初期値設定
    g_RHCode_List.Add(DEF_HIS_BLOODRH_1);
    g_RHCode_List.Add(DEF_HIS_BLOODRH_2);
    g_RHCode_List.Add(CSTNULLDATAKEY);
    g_RHName_List.Add(DEF_BLOODRH_1_NAME);
    g_RHName_List.Add(DEF_BLOODRH_2_NAME);
    g_RHName_List.Add(DEF_BLOODRH_9_NAME);
  end;

  //障害情報名称
  g_Syougai_List := TStringList.Create;
  //ワーク
  wsl_List.Clear;

  arg_Ini.ReadSectionValues(g_SYOUGAINAME_SECSION,wsl_List);


  for w_i := 0 to wsl_List.Count - 1 do
  begin
    w_Pos := Pos('=',wsl_List[w_i]);
    if w_Pos <> 0 then
    begin
      g_Syougai_List.CommaText := Copy(wsl_List[w_i],w_Pos + 1,Length(wsl_List[w_i]));
    end;
  end;

  if wsl_List.Count = 0 then
  begin
    //初期値設定
    g_Syougai_List.CommaText := g_DEFSYOUGAINAMEO1;
  end;

  //感染情報
  g_KansenCode_List := TStringList.Create;
  g_KansenName_List := TStringList.Create;
  //ワーク
  wsl_List.Clear;

  arg_Ini.ReadSectionValues(g_KANSEN_SECSION,wsl_List);


  for w_i := 0 to wsl_List.Count - 1 do
  begin
    w_Pos := Pos('=',wsl_List[w_i]);
    if w_Pos <> 0 then
    begin
      g_KansenCode_List.Add(Copy(wsl_List[w_i], 1, w_Pos - 1));
      g_KansenName_List.Add(Copy(wsl_List[w_i],w_Pos + 1,Length(wsl_List[w_i])));
    end;
  end;

  if wsl_List.Count = 0 then
  begin
    //初期値設定
    g_KansenCode_List.Add(DEF_KANSEN_0);
    g_KansenCode_List.Add(DEF_KANSEN_1);
    g_KansenCode_List.Add(DEF_KANSEN_2);
    g_KansenCode_List.Add(CSTNULLDATAKEY);
    g_KansenName_List.Add(DEF_KANSEN_0_NAME);
    g_KansenName_List.Add(DEF_KANSEN_1_NAME);
    g_KansenName_List.Add(DEF_KANSEN_2_NAME);
    g_KansenName_List.Add(DEF_KANSEN_9_NAME);
  end;

  //感染情報名称
  g_Kansen_List := TStringList.Create;
  //ワーク
  wsl_List.Clear;

  arg_Ini.ReadSectionValues(g_KANSENNAME_SECSION,wsl_List);


  for w_i := 0 to wsl_List.Count - 1 do
  begin
    w_Pos := Pos('=',wsl_List[w_i]);
    if w_Pos <> 0 then
    begin
      g_Kansen_List.CommaText := Copy(wsl_List[w_i],w_Pos + 1,Length(wsl_List[w_i]));
    end;
  end;

  if wsl_List.Count = 0 then
  begin
    //初期値設定
    g_Kansen_List.CommaText := g_DEFKANSENNAMEO1;
  end;

  //感染情報有り名称
  g_KansenON_List := TStringList.Create;
  //ワーク
  wsl_List.Clear;

  arg_Ini.ReadSectionValues(g_KANSENON_SECSION,wsl_List);


  for w_i := 0 to wsl_List.Count - 1 do
  begin
    w_Pos := Pos('=',wsl_List[w_i]);
    if w_Pos <> 0 then
    begin
      g_KansenON_List.CommaText := Copy(wsl_List[w_i],w_Pos + 1,Length(wsl_List[w_i]));
    end;
  end;

  if wsl_List.Count = 0 then
  begin
    //初期値設定
    g_KansenON_List.CommaText := g_DEFKANSENONO1;
  end;

  //禁忌情報名称
  g_Kinki_List := TStringList.Create;
  //ワーク
  wsl_List.Clear;

  arg_Ini.ReadSectionValues(g_KINKINAME_SECSION,wsl_List);


  for w_i := 0 to wsl_List.Count - 1 do
  begin
    w_Pos := Pos('=',wsl_List[w_i]);
    if w_Pos <> 0 then
    begin
      g_Kinki_List.CommaText := Copy(wsl_List[w_i],w_Pos + 1,Length(wsl_List[w_i]));
    end;
  end;

  if wsl_List.Count = 0 then
  begin
    //初期値設定
    g_Kinki_List.CommaText := g_DEFKINKINAMEO1;
  end;

  //緊急区分
  g_KinkyuKbn_List := TStringList.Create;
  g_KinkyuName_List := TStringList.Create;
  //ワーク
  wsl_List.Clear;

  arg_Ini.ReadSectionValues(g_KINKYU_SECSION,wsl_List);


  for w_i := 0 to wsl_List.Count - 1 do
  begin
    w_Pos := Pos('=',wsl_List[w_i]);
    if w_Pos <> 0 then
    begin
      g_KinkyuKbn_List.Add(Copy(wsl_List[w_i], 1, w_Pos - 1));
      g_KinkyuName_List.Add(Copy(wsl_List[w_i],w_Pos + 1,Length(wsl_List[w_i])));
    end;
  end;

  if wsl_List.Count = 0 then
  begin
    //初期値設定
    g_KinkyuKbn_List.Add(DEF_HIS_KINKYU_0);
    g_KinkyuKbn_List.Add(DEF_HIS_KINKYU_1);
    g_KinkyuName_List.Add(DEF_KINKYU_0_NAME);
    g_KinkyuName_List.Add(DEF_KINKYU_1_NAME);
  end;

  //至急区分
  g_SikyuKbn_List := TStringList.Create;
  g_SikyuName_List := TStringList.Create;
  //ワーク
  wsl_List.Clear;

  arg_Ini.ReadSectionValues(g_SIKYU_SECSION,wsl_List);


  for w_i := 0 to wsl_List.Count - 1 do
  begin
    w_Pos := Pos('=',wsl_List[w_i]);
    if w_Pos <> 0 then
    begin
      g_SikyuKbn_List.Add(Copy(wsl_List[w_i], 1, w_Pos - 1));
      g_SikyuName_List.Add(Copy(wsl_List[w_i],w_Pos + 1,Length(wsl_List[w_i])));
    end;
  end;

  if wsl_List.Count = 0 then
  begin
    //初期値設定
    g_SikyuKbn_List.Add(DEF_HIS_SIKYU_0);
    g_SikyuKbn_List.Add(DEF_HIS_SIKYU_1);
    g_SikyuName_List.Add(DEF_SIKYU_0_NAME);
    g_SikyuName_List.Add(DEF_SIKYU_1_NAME);
  end;

  //至急現像区分
  g_GenzoKbn_List := TStringList.Create;
  g_GenzoName_List := TStringList.Create;
  //ワーク
  wsl_List.Clear;

  arg_Ini.ReadSectionValues(g_GENZO_SECSION,wsl_List);


  for w_i := 0 to wsl_List.Count - 1 do
  begin
    w_Pos := Pos('=',wsl_List[w_i]);
    if w_Pos <> 0 then
    begin
      g_GenzoKbn_List.Add(Copy(wsl_List[w_i], 1, w_Pos - 1));
      g_GenzoName_List.Add(Copy(wsl_List[w_i],w_Pos + 1,Length(wsl_List[w_i])));
    end;
  end;

  if wsl_List.Count = 0 then
  begin
    //初期値設定
    g_GenzoKbn_List.Add(DEF_HIS_GENZO_0);
    g_GenzoKbn_List.Add(DEF_HIS_GENZO_1);
    g_GenzoName_List.Add(DEF_GENZO_0_NAME);
    g_GenzoName_List.Add(DEF_GENZO_1_NAME);
  end;

  //予約区分
  g_YoyakuKbn_List := TStringList.Create;
  g_YoyakuName_List := TStringList.Create;
  //ワーク
  wsl_List.Clear;

  arg_Ini.ReadSectionValues(g_YOYAKU_SECSION,wsl_List);


  for w_i := 0 to wsl_List.Count - 1 do
  begin
    w_Pos := Pos('=',wsl_List[w_i]);
    if w_Pos <> 0 then
    begin
      g_YoyakuKbn_List.Add(Copy(wsl_List[w_i], 1, w_Pos - 1));
      g_YoyakuName_List.Add(Copy(wsl_List[w_i],w_Pos + 1,Length(wsl_List[w_i])));
    end;
  end;

  if wsl_List.Count = 0 then
  begin
    //初期値設定
    g_YoyakuKbn_List.Add(DEF_HIS_YOYAKU_O);
    g_YoyakuKbn_List.Add(DEF_HIS_YOYAKU_C);
    g_YoyakuKbn_List.Add(DEF_HIS_YOYAKU_N);
    g_YoyakuName_List.Add(DEF_YOYAKU_O_NAME);
    g_YoyakuName_List.Add(DEF_YOYAKU_C_NAME);
    g_YoyakuName_List.Add(DEF_YOYAKU_N_NAME);
  end;

  //読影区分
  g_DokueiKbn_List := TStringList.Create;
  g_DokueiName_List := TStringList.Create;
  //ワーク
  wsl_List.Clear;

  arg_Ini.ReadSectionValues(g_DOKUEI_SECSION,wsl_List);

  for w_i := 0 to wsl_List.Count - 1 do
  begin
    w_Pos := Pos('=',wsl_List[w_i]);
    if w_Pos <> 0 then
    begin
      g_DokueiKbn_List.Add(Copy(wsl_List[w_i], 1, w_Pos - 1));
      g_DokueiName_List.Add(Copy(wsl_List[w_i],w_Pos + 1,Length(wsl_List[w_i])));
    end;
  end;

  if wsl_List.Count = 0 then
  begin
    //初期値設定
    g_DokueiKbn_List.Add(DEF_HIS_DOKUEI_0);
    g_DokueiKbn_List.Add(DEF_HIS_DOKUEI_1);
    g_DokueiName_List.Add(DEF_DOKUEI_0_NAME);
    g_DokueiName_List.Add(DEF_DOKUEI_1_NAME);
  end;
  //所見用検査種別
  SetLength(g_ReportType_ID,0);

  //ワーク
  wsl_List.Clear;
  wsl_List2 := TStringList.Create;

  arg_Ini.ReadSectionValues(g_REPORTTYPE_SECSION,wsl_List);

  for w_i := 0 to wsl_List.Count - 1 do
  begin
    w_Pos := Pos('=',wsl_List[w_i]);
    if w_Pos <> 0 then
    begin
      wsl_List2.CommaText := Copy(wsl_List[w_i],w_Pos + 1,Length(wsl_List[w_i]));

      for w_i2 := 0 to wsl_List2.Count - 1 do
      begin
        SetLength(g_ReportType_ID,Length(g_ReportType_ID) + 1);
        g_ReportType_ID[Length(g_ReportType_ID) - 1].f_HIS_ID := wsl_List2.Strings[w_i2];
        g_ReportType_ID[Length(g_ReportType_ID) - 1].f_RIS_ID := Copy(wsl_List[w_i], 1, w_Pos - 1);
      end;
    end;
  end;


  //材料情報名称
  g_Zairyo_List := TStringList.Create;
  //ワーク
  wsl_List.Clear;

  arg_Ini.ReadSectionValues(g_ZAI_CODE_SECSION,wsl_List);


  for w_i := 0 to wsl_List.Count - 1 do
  begin
    w_Pos := Pos('=',wsl_List[w_i]);
    if w_Pos <> 0 then
    begin
      g_Zairyo_List.CommaText := Copy(wsl_List[w_i],w_Pos + 1,Length(wsl_List[w_i]));
    end;
  end;

  if wsl_List.Count = 0 then
  begin
    //初期値設定
    g_Zairyo_List.CommaText := g_DEFZAI_CODE;
  end;

  if wsl_List <> nil then
    FreeAndNil(wsl_List);
  if wsl_List2 <> nil then
    FreeAndNil(wsl_List2);

end;
procedure proc_ReadiniType(
                          arg_Ini : TIniFile
                          );
var
  w_i   : Integer;
  w_Pos : Integer;
  wsl_List : TStrings;
begin

  //検査種別
  SetLength(g_Kensa_ID,0);

  if wsl_List = nil then
    wsl_List := TStringList.Create;
  //ワーク
  wsl_List.Clear;

  arg_Ini.ReadSectionValues(g_RTRISTYPE_SECSION,wsl_List);

  for w_i := 0 to wsl_List.Count - 1 do
  begin
    w_Pos := Pos('=',wsl_List[w_i]);
    if w_Pos <> 0 then
    begin
      SetLength(g_Kensa_ID,Length(g_Kensa_ID) + 1);
      g_Kensa_ID[Length(g_Kensa_ID) - 1].f_HIS_ID := Copy(wsl_List[w_i], 1, w_Pos - 1);
      g_Kensa_ID[Length(g_Kensa_ID) - 1].f_RIS_ID := Copy(wsl_List[w_i],w_Pos + 1,Length(wsl_List[w_i]));
    end;
  end;
  if wsl_List <> nil then
    FreeAndNil(wsl_List);

end;
//●機能（例外無）：ｺｰﾄﾞを名前に変換 コマンド名
function func_Change_Command(
                             arg_Code: String    //ｺｰﾄﾞ
                             ): String;          //名称
var
  w_Res: String;
begin
  //オーダ情報
  if arg_Code = CST_COMMAND_ORDER then
    //オーダ受信サービス
    w_Res := CST_APPID_HRCV01
  //患者情報更新
  else if arg_Code = CST_COMMAND_KANJAUP then
    //患者情報受信サービス
    w_Res := CST_APPID_HRCV02
  //患者死亡退院情報
  else if arg_Code = CST_COMMAND_KANJADEL then
    //患者情報受信サービス
    w_Res := CST_APPID_HRCV02
  //オーダキャンセル
  else if arg_Code = CST_COMMAND_ORDERCANCEL then
    //オーダ受信サービス
    w_Res := CST_APPID_HRCV01
  //会計通知
  else if arg_Code = CST_COMMAND_KAIKEI then
    //会計通知受信サービス
    w_Res := CST_APPID_HRCV03
  //患者受付
  else if arg_Code = CST_COMMAND_UKETUKE then
    //受付通知送信サービス
    w_Res := CST_APPID_HSND01
  //撮影実施通知
  else if arg_Code = CST_COMMAND_JISSI then
    //実績送信サービス
    w_Res := CST_APPID_HSND02
  //オーダ再送要求
  else if arg_Code = CST_COMMAND_RESEND then
    //実績送信サービス
    w_Res := CST_APPID_HSND02
  else
    //コード無し
    w_Res := '';

  Result := w_Res;
end;
//●機能（例外無）：ｺｰﾄﾞを名前に変換 コマンド名（受信系サービスのみ）
function func_Change_RVRISCommand(
                                  arg_Code: String    //ｺｰﾄﾞ
                                  ): String;          //名称
var
  w_Res: String;
begin
  //オーダ情報
  if arg_Code = CST_COMMAND_ORDER then
    //オーダ情報
    w_Res := CST_APPTYPE_OI01
  //患者情報更新
  else if arg_Code = CST_COMMAND_KANJAUP then
    //患者情報
    w_Res := CST_APPTYPE_PI01
  //患者死亡退院情報
  else if arg_Code = CST_COMMAND_KANJADEL then
    //死亡退院情報
    w_Res := CST_APPTYPE_PI99
  //オーダキャンセル
  else if arg_Code = CST_COMMAND_ORDERCANCEL then
    //オーダキャンセル
    w_Res := CST_APPTYPE_OI99
  //会計通知
  else if arg_Code = CST_COMMAND_KAIKEI then
    //会計通知
    w_Res := CST_APPTYPE_AC01
  else
    //コード無し
    w_Res := '';

  Result := w_Res;
end;
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
//●機能（例外無）：HIS血液型ABOとRH情報をRIS用に変換
function func_Make_BloodType(
                             arg_ABO: String;
                             arg_RH: String
                             ): String;
var
  ws_ABO: String;
  wi_LoopABO: Integer;
  wi_LoopABO2: Integer;
  ws_RH: String;
  wi_LoopRH: Integer;
  wi_LoopRH2: Integer;
begin
  //血液型ABOが無い場合
  if arg_ABO = '' then
  begin
    for wi_LoopABO2 := 0 to g_ABOCode_List.Count - 1 do
    begin
      if g_ABOCode_List[wi_LoopABO2] = CSTNULLDATAKEY then
      begin
        //不明
        ws_ABO := g_ABOName_List[wi_LoopABO2];
      end;
    end;
  end
  else
  begin
    //iniファイルの情報分
    for wi_LoopABO := 0 to g_ABOCode_List.Count - 1 do
    begin
      //コードと同じものがあった場合
      if arg_ABO = g_ABOCode_List[wi_LoopABO] then
      begin
        //名称リスト範囲内の場合
        if g_ABOName_List.Count - 1 >= wi_LoopABO then
        begin
          //リスト名称設定
          ws_ABO := g_ABOName_List[wi_LoopABO];
        end;
      end
      else if arg_ABO = ' ' then
      begin
        for wi_LoopABO2 := 0 to g_ABOCode_List.Count - 1 do
        begin
          if g_ABOCode_List[wi_LoopABO2] = CSTNULLDATAKEY then
          begin
            //不明
            ws_ABO := g_ABOName_List[wi_LoopABO2];
          end;
        end;
      end;
    end;
  end;
  //血液型RHが無い場合
  if arg_RH = '' then
  begin
    for wi_LoopRH2 := 0 to g_RHCode_List.Count - 1 do
    begin
      if g_RHCode_List[wi_LoopRH2] = CSTNULLDATAKEY then
      begin
        //不明
        ws_RH := g_RHName_List[wi_LoopRH2];
      end;
    end;
  end
  else
  begin
    //iniファイルの情報分
    for wi_LoopRH := 0 to g_RHCode_List.Count - 1 do
    begin
      //コードと同じものがあった場合
      if arg_RH = g_RHCode_List[wi_LoopRH] then
      begin
        //名称リスト範囲内の場合
        if g_RHName_List.Count - 1 >= wi_LoopRH then
        begin
          //リスト名称設定
          ws_RH := g_RHName_List[wi_LoopRH];
        end;
      end
      else if arg_RH = ' ' then
      begin
        for wi_LoopRH2 := 0 to g_RHCode_List.Count - 1 do
        begin
          if g_RHCode_List[wi_LoopRH2] = CSTNULLDATAKEY then
          begin
            //不明
            ws_RH := g_RHName_List[wi_LoopRH2];
          end;
        end;
      end;
    end;
  end;

  Result := ws_ABO + ',' + ws_RH;
end;
//●機能（例外無）：RIS障害情報、禁忌情報の作成
procedure proc_Make_RISInfo(
                                arg_Syougai: String;
                                arg_Kinki: String;
                            var arg_SyougaiInfo: String;
                            var arg_KinkiInfo: String
                           );
var
  wi_Loop: Integer;
begin
  //障害情報が無い場合
  if arg_Syougai = '' then
  begin
    //障害情報なし
    arg_SyougaiInfo := '';
  end
  else
  begin
    //iniファイルの情報分
    for wi_Loop := 1 to Length(arg_Syougai) do
    begin
      //コードと同じものがあった場合
      if arg_Syougai[wi_Loop] = DEF_SYOUGAI_1 then
      begin
        //名称リスト範囲内の場合
        if g_Syougai_List.Count >= wi_Loop then
        begin
          if arg_SyougaiInfo = '' then
          begin
            //リスト名称設定
            arg_SyougaiInfo := g_Syougai_List[wi_Loop - 1];
          end
          else
          begin
            //リスト名称設定
            arg_SyougaiInfo := arg_SyougaiInfo + ',' +
                               g_Syougai_List[wi_Loop - 1];
          end;
        end;
      end;
    end;
  end;
  //禁忌情報が無い場合
  if arg_Kinki = '' then
  begin
    //禁忌情報なし
    arg_KinkiInfo := '';
  end
  else
  begin
    //iniファイルの情報分
    for wi_Loop := 1 to Length(arg_Kinki) do
    begin
      //コードと同じものがあった場合
      if arg_Kinki[wi_Loop] = DEF_KINKI_1 then
      begin
        //名称リスト範囲内の場合
        if g_Kinki_List.Count >= wi_Loop then
        begin
          if arg_KinkiInfo = '' then
          begin
            //リスト名称設定
            arg_KinkiInfo := g_Kinki_List[wi_Loop - 1];
          end
          else
          begin
            //リスト名称設定
            arg_KinkiInfo := arg_KinkiInfo + ',' + g_Kinki_List[wi_Loop - 1];
          end;
        end;
      end;
    end;
  end;
end;
//●機能（例外無）：RIS感染情報の作成
procedure proc_Make_RISKansen(
                                arg_Kansen: String;
                                arg_KansenCom: String;
                            var arg_KansenFlg: String;
                            var arg_KansenInfo: String
                           );
var
  wi_Loop: Integer;
  wi_LoopOn: Integer;
  wi_LoopKa: Integer;
  wi_LoopKa2: Integer;
begin
  //感染情報が無い場合
  if arg_Kansen = '' then
  begin
    //感染情報フラグ
    arg_KansenFlg := DEF_RIS_KANSEN_0;
  end
  else
  begin
    //iniファイルの情報分
    for wi_Loop := 1 to Length(arg_Kansen) do
    begin
      for wi_LoopOn := 0 to g_KansenON_List.Count - 1 do
      begin
        //コードと同じものがあった場合
        if arg_Kansen[wi_Loop] = g_KansenON_List[wi_LoopOn] then
        begin
          //名称リスト範囲内の場合
          if g_Kansen_List.Count >= wi_Loop then
          begin
            //感染有り
            arg_KansenFlg := DEF_RIS_KANSEN_1;
          end;
        end;
      end;
    end;
  end;
  //感染情報が無い場合
  if arg_Kansen = '' then
  begin
    //感染情報なし
    arg_KansenInfo := '';
  end
  else
  begin
    //iniファイルの情報分
    for wi_Loop := 1 to Length(arg_Kansen) do
    begin
      for wi_LoopKa := 0 to g_KansenCode_List.Count - 1 do
      begin
        //コードと同じものがあった場合
        if arg_Kansen[wi_Loop] = g_KansenCode_List[wi_LoopKa] then
        begin
          //名称リスト範囲内の場合
          if g_Kansen_List.Count >= wi_Loop then
          begin
            if arg_KansenInfo = '' then
            begin
              //リスト名称設定
              arg_KansenInfo := g_Kansen_List[wi_Loop - 1] + '=' +
                                g_KansenName_List[wi_LoopKa];
            end
            else
            begin
              //リスト名称設定
              arg_KansenInfo := arg_KansenInfo + ',' +
                                g_Kansen_List[wi_Loop - 1] + '=' +
                                g_KansenName_List[wi_LoopKa];
            end;
          end;
        end
        //ブランクの場合
        else if arg_Kansen[wi_Loop] = ' ' then
        begin
          for wi_LoopKa2 := 0 to g_KansenCode_List.Count - 1 do
          begin
            if g_Kansen_List[wi_LoopKa2] = CSTNULLDATAKEY then
            begin
              if arg_KansenInfo = '' then
              begin
                //リスト名称設定
                arg_KansenInfo := g_Kansen_List[wi_Loop - 1] + '=' +
                                  g_KansenName_List[wi_LoopKa2];
              end
              else
              begin
                //リスト名称設定
                arg_KansenInfo := arg_KansenInfo + ',' +
                                  g_Kansen_List[wi_Loop - 1] + '=' +
                                  g_KansenName_List[wi_LoopKa2];
              end;
            end;
          end;
        end;
      end;
    end;
  end;
  //感染コメントがある場合
  if arg_KansenCom <> '' then
  begin
    //感染情報フラグ
    arg_KansenFlg := DEF_RIS_KANSEN_1;
    //感染情報がある場合
    if arg_KansenInfo = '' then
    begin
      arg_KansenInfo := arg_KansenCom;
    end
    //感染情報が無い場合
    else
    begin
      arg_KansenInfo := arg_KansenInfo + ',' + arg_KansenCom;
    end;
  end;
end;
//●機能（例外無）：RIS妊娠日の作成
procedure proc_Make_RISNinsinDate(
                                      arg_Ninsin: String;
                                  var arg_NinsinDate: String
                                  );
begin
  //妊娠日が無い場合
  if arg_Ninsin = '' then
    //処理終了
    Exit;
  //YYYY年MM月DD日に変換
  arg_NinsinDate := Copy(arg_Ninsin,1,4) + '年' + Copy(arg_Ninsin,5,2) + '月' +
                    Copy(arg_Ninsin,7,2) + '日';
end;
//●機能（例外無）：HIS看護区分・患者区分をRIS用に変換
function func_Make_ExtraProfile(
                                arg_Kango: String;
                                arg_Kanja: String
                                ): String;
var
  wi_LoopKango: Integer;
  wi_LoopKango2: Integer;
  wi_LoopKanja: Integer;
  wi_LoopKanja2: Integer;
begin
  //看護区分が無い場合
  if arg_Kango = '' then
  begin
    for wi_LoopKango := 0 to g_KangoKbn_List.Count - 1 do
    begin
      if g_KangoKbn_List[wi_LoopKango] = CSTNULLDATAKEY then
      begin
        //不明
        arg_Kango := '看護区分=' + g_KangoName_List[wi_LoopKango];
      end;
    end;
  end
  else
  begin
    //iniファイルの情報分
    for wi_LoopKango2 := 0 to g_KangoKbn_List.Count - 1 do
    begin
      //コードと同じものがあった場合
      if arg_Kango = g_KangoKbn_List[wi_LoopKango2] then
      begin
        //名称リスト範囲内の場合
        if g_KangoKbn_List.Count - 1 >= wi_LoopKango2 then
        begin
          //リスト名称設定
          arg_Kango := '看護区分=' + g_KangoName_List[wi_LoopKango2];
        end;
      end
      else if arg_Kango = ' ' then
      begin
        for wi_LoopKango := 0 to g_KangoKbn_List.Count - 1 do
        begin
          if g_KangoKbn_List[wi_LoopKango] = CSTNULLDATAKEY then
          begin
            //不明
            arg_Kango := '看護区分=' + g_KangoName_List[wi_LoopKango];
          end;
        end;
      end;
    end;
  end;
  //患者区分が無い場合
  if arg_Kanja = '' then
  begin
    for wi_LoopKanja := 0 to g_KanjaKbn_List.Count - 1 do
    begin
      if g_KanjaKbn_List[wi_LoopKanja] = CSTNULLDATAKEY then
      begin
        //不明
        arg_Kanja := '患者区分=' + g_KanjaName_List[wi_LoopKanja];
      end;
    end;
  end
  else
  begin
    //iniファイルの情報分
    for wi_LoopKanja := 0 to g_KanjaKbn_List.Count - 1 do
    begin
      //コードと同じものがあった場合
      if arg_Kanja = g_KanjaKbn_List[wi_LoopKanja] then
      begin
        //名称リスト範囲内の場合
        if g_KanjaKbn_List.Count - 1 >= wi_LoopKanja then
        begin
          //リスト名称設定
          arg_Kanja := '患者区分=' + g_KanjaName_List[wi_LoopKanja];
        end;
      end
      else if arg_Kanja = ' ' then
      begin
        for wi_LoopKanja2 := 0 to g_KanjaKbn_List.Count - 1 do
        begin
          if g_KanjaKbn_List[wi_LoopKanja2] = CSTNULLDATAKEY then
          begin
            //不明
            arg_Kanja := '患者区分=' + g_KanjaName_List[wi_LoopKanja2];
          end;
        end;
      end;
    end;
  end;

  Result := arg_Kango + ',' + arg_Kanja;
end;
{
-----------------------------------------------------------------------------
  名前   : func_GetServiceInfo
  引数   :     arg_AppID  : String アプリケーション識別子
           var arg_ErrMsg : String エラー時：詳細原因 正常時：''
  機能   : 1. HIS通信管理テーブルからポートを取得する。
  復帰値 : 例外ない
-----------------------------------------------------------------------------
}
function func_GetServiceInfo(    arg_AppID  : String;
                                 arg_Qry    : T_Query;
                             var arg_Flg    : Boolean;
                             var arg_ErrMsg : String
                             ): String;
var
  sqlSelect:  String;
  iRslt:      Integer;
begin
  //戻り値
  Result := '';
  try
    with arg_Qry do begin
      //SQL設定
      sqlSelect := '';
      sqlSelect := sqlSelect + 'SELECT COMMUNICATORDEFINE FROM HISRISCONTROLINFO';
      sqlSelect := sqlSelect + ' WHERE APPID = :PAPPID';
      PrepareQuery(sqlSelect);
      //パラメータ
      //サービス識別子
      SetParam('PAPPID', arg_AppID);
      //SQL実行
      iRslt:= OpenQuery();
      if iRslt < 0 then begin
        //例外エラー
        Result := '';
        //処理終了
        Exit;
      end;
      if Eof = False then begin
        // 対象データの取得
        //ポートの設定
        Result := GetString('COMMUNICATORDEFINE');
      end
      else begin
        Result := '';
      end;
      //正常終了処理
      arg_ErrMsg :='';
      //処理終了
      Exit;
    end;
  except
    //エラー終了処理
    on E:exception do
    begin
      //エラーメッセージ
      arg_ErrMsg := E.Message;
      //DB切断
      arg_Flg := False;
      //戻り値
      Result := '';
      //処理終了
      Exit;
    end;
  end;
end;
{
-----------------------------------------------------------------------------
  名前   : func_GetServiceInfo
  引数   :     arg_AppID  : String アプリケーション識別子
           var arg_ErrMsg : String エラー時：詳細原因 正常時：''
  機能   : 1. HIS通信管理テーブルからポートを取得する。
  復帰値 : 例外ない
-----------------------------------------------------------------------------
}
(*
function func_GetRTServiceInfo(    arg_AppID  : String;
                                   arg_Qry    : TQuery;
                               var arg_Flg    : Boolean;
                               var arg_ErrMsg : String
                               ): String;
begin
  //戻り値
  Result := '';
  try
    try
      with arg_Qry do
      begin
        //SQL文クリア
        SQL.Clear;
        //SQL文作成
        SQL.Add('SELECT COMMUNICATORDEFINE FROM ' + g_RRISUser + '.HISRISCONTROLINFO');
        SQL.Add(' WHERE APPID = :PAPPID');
        //サービス識別子
        ParamByName('PAPPID').AsString := arg_AppID;
        Open;
        Last;
        First;
        //レコードがある場合
        if arg_Qry.RecordCount > 0 then
        begin
          //ポートの設定
          Result := FieldByName('COMMUNICATORDEFINE').AsString;
        end
        else
        begin
          Result := '';
        end;
      end;
      //正常終了処理
      arg_ErrMsg :='';
      //処理終了
      Exit;
    except
      //エラー終了処理
      on E:exception do
      begin
        //エラーメッセージ
        arg_ErrMsg := E.Message;
        //DB切断
        arg_Flg := False;
        //戻り値
        Result := '';
        //処理終了
        Exit;
      end;
    end;
  finally
    arg_Qry.Close;
    arg_Qry.SQL.Clear;
  end;
end;
*)
{
-----------------------------------------------------------------------------
  名前   : func_GetSeq
  引数   :     arg_AppID  : String アプリケーション識別子
           var arg_ErrMsg : String  エラー時：詳細原因 正常時：''
  機能   : 1. HIS通信管理テーブルから送信済SEQを取得する。
  復帰値 : 例外ない  SEQ番号
-----------------------------------------------------------------------------
}
function func_GetSeq(    arg_AppID  : String;
                         arg_Qry    : TQuery;
                     var arg_Flg    : Boolean;
                     var arg_ErrMsg : String
                     ): String;
begin
  //戻り値
  Result := '';
  try
    try
      with arg_Qry do
      begin
        //SQL文クリア
        SQL.Clear;
        //SQL文作成
        SQL.Add('SELECT COMINF01 FROM HISRISCONTROLINFO');
        SQL.Add(' WHERE APPID = :PAPPID');
        //サービス識別子
        ParamByName('PAPPID').AsString := arg_AppID;
        Open;
        Last;
        First;
        //レコードがある場合
        if arg_Qry.RecordCount > 0 then
        begin
          //受信済SEQの設定
          Result := func_LeftZero(10,FieldByName('COMINF01').AsString);
        end
        else
        begin
          Result := '0000000000';
        end;
      end;
      //正常終了処理
      arg_ErrMsg :='';
      //処理終了
      Exit;
    except
      //エラー終了処理
      on E:exception do
      begin
        //エラーメッセージ
        arg_ErrMsg := E.Message;
        //DB切断
        arg_Flg := False;
        //戻り値
        Result := '';
        //処理終了
        Exit;
      end;
    end;
  finally
    arg_Qry.Close;
    arg_Qry.SQL.Clear;
  end;
end;
{
-----------------------------------------------------------------------------
  名前   : func_GetDBMachineName
  引数   :     arg_AppID  : String アプリケーション識別子
           var arg_ErrMsg : String  エラー時：詳細原因 正常時：''
  機能   : 1. HIS通信管理テーブルからサーバ名を取得する。
  復帰値 : 例外ない  サーバ名
-----------------------------------------------------------------------------
}
function func_GetDBMachineName(    arg_AppID  : String;
                                   arg_Qry    : TQuery;
                               var arg_Flg    : Boolean;
                               var arg_ErrMsg : String
                               ): String;
begin
  //戻り値
  Result := '';
  try
    try
      with arg_Qry do
      begin
        //SQL文クリア
        SQL.Clear;
        //SQL文作成
        SQL.Add('SELECT COMINF05 FROM HISRISCONTROLINFO');
        SQL.Add(' WHERE APPID = :PAPPID');
        //サービス識別子
        ParamByName('PAPPID').AsString := arg_AppID;
        Open;
        Last;
        First;
        //レコードがある場合
        if arg_Qry.RecordCount > 0 then
        begin
          //サーバ名の設定
          Result := FieldByName('COMINF05').AsString;
        end
        else
        begin
          Result := '';
        end;
      end;
      //正常終了処理
      arg_ErrMsg :='';
      //処理終了
      Exit;
    except
      //エラー終了処理
      on E:exception do
      begin
        //エラーメッセージ
        arg_ErrMsg := E.Message;
        //DB切断
        arg_Flg := False;
        //戻り値
        Result := '';
        //処理終了
        Exit;
      end;
    end;
  finally
    arg_Qry.Close;
    arg_Qry.SQL.Clear;
  end;
end;
{
-----------------------------------------------------------------------------
  名前   : func_SetHISRISControlInfo
  引数   : arg_APPID         : String        RIS_ID
           arg_LogBuffer     : String        付加エラー詳細
  機能   : 1.HIS通信管理テーブルの更新
  復帰値 : True 成功 False 失敗 例外は発生しない
-----------------------------------------------------------------------------
}
function func_SetHISRISControlInfo(    arg_APPID : String;
                                       arg_DataSeq : String;
                                       arg_Qry    : TQuery;
                                   var arg_Flg    : Boolean;
                                   var arg_LogBuffer : String
                                   ):Boolean;
begin
  try
    with arg_Qry do
    begin
      //閉じる
      Close;
      //SQL文クリア
      SQL.Clear;
      //SQL文作成
      SQL.Add('UPDATE HISRISCONTROLINFO SET');
      SQL.Add('COMINF01 = :PCOMINF01 '); //データSEQ
      SQL.Add('WHERE APPID = :PAPPID '); //アプリケーション識別子
      try
        //RIS_ID
        ParamByName('PCOMINF01').AsString := arg_DataSeq;
        //患者ID
        ParamByName('PAPPID').AsString := arg_APPID;
        {$IFDEF DEBUGE}
        SQL.SaveToFile('HISRISCONTROLINFO.SQL');
        {$ENDIF}
        //実行
        ExecSQL;
        //戻り値
        Result := True;
        //処理終了
        Exit;
      except
        on E: Exception do
        begin
          //ログ文字列作成
          proc_StrConcat(arg_LogBuffer, ' HIS通信管理変更 例外発生「' +
                         E.Message + '」');
          //戻り値
          Result := False;
          //切断
          arg_Flg := False;
          //処理終了
          Exit;
        end;
      end;
    end;
  finally
    arg_Qry.Close;
    arg_Qry.SQL.Clear;
  end;
end;
{
-----------------------------------------------------------------------------
  名前   : func_GetRISHost
  引数   : arg_HostID        : String        端末ID
           arg_LogBuffer     : String        付加エラー詳細
  機能   : 1.端末名称取得
  復帰値 : True 成功 False 失敗 例外は発生しない
-----------------------------------------------------------------------------
}
function func_GetRISHost(    arg_HostID : String;
                             arg_Qry    : TQuery;
                         var arg_Flg    : Boolean;
                         var arg_ErrMsg : String
                         ): String;
begin
  //戻り値
  Result := '';
  try
    try
      with arg_Qry do
      begin
        //SQL文クリア
        SQL.Clear;
        //SQL文作成
        SQL.Add('SELECT TERMINALNAME FROM TERMINALINFO');
        SQL.Add(' WHERE TERMINALID = :PTERMINALID');
        //端末ID
        ParamByName('PTERMINALID').AsString := arg_HostID;
        Open;
        Last;
        First;
        //レコードがある場合
        if arg_Qry.RecordCount > 0 then
        begin
          //サーバ名の設定
          Result := FieldByName('TERMINALNAME').AsString;
        end
        else
        begin
          Result := '';
        end;
      end;
      //正常終了処理
      arg_ErrMsg :='';
      //処理終了
      Exit;
    except
      //エラー終了処理
      on E:exception do
      begin
        //エラーメッセージ
        arg_ErrMsg := E.Message;
        //DB切断
        arg_Flg := False;
        //戻り値
        Result := '';
        //処理終了
        Exit;
      end;
    end;
  finally
    arg_Qry.Close;
    arg_Qry.SQL.Clear;
  end;
end;
{
-----------------------------------------------------------------------------
  名前   : func_GetRTRISHost
  引数   : arg_HostID        : String        端末ID
           arg_LogBuffer     : String        付加エラー詳細
  機能   : 1.端末名称取得
  復帰値 : True 成功 False 失敗 例外は発生しない
-----------------------------------------------------------------------------
}
(*
function func_GetRTRISHost(    arg_HostID : String;
                               arg_Qry    : TQuery;
                           var arg_Flg    : Boolean;
                           var arg_ErrMsg : String
                           ): String;
begin
  //戻り値
  Result := '';
  try
    try
      with arg_Qry do
      begin
        //SQL文クリア
        SQL.Clear;
        //SQL文作成
        SQL.Add('SELECT TERMINALNAME FROM ' + g_RRISUser + '.TERMINALINFO');
        SQL.Add(' WHERE TERMINALID = :PTERMINALID');
        //端末ID
        ParamByName('PTERMINALID').AsString := arg_HostID;
        Open;
        Last;
        First;
        //レコードがある場合
        if arg_Qry.RecordCount > 0 then
        begin
          //サーバ名の設定
          Result := FieldByName('TERMINALNAME').AsString;
        end
        else
        begin
          Result := '';
        end;
      end;
      //正常終了処理
      arg_ErrMsg :='';
      //処理終了
      Exit;
    except
      //エラー終了処理
      on E:exception do
      begin
        //エラーメッセージ
        arg_ErrMsg := E.Message;
        //DB切断
        arg_Flg := False;
        //戻り値
        Result := '';
        //処理終了
        Exit;
      end;
    end;
  finally
    arg_Qry.Close;
    arg_Qry.SQL.Clear;
  end;
end;
*)

function func_HisToReport(arg_HisID:String):String;
var
  w_Kensa:String;
  w_i:Integer;
begin
  //初期化
  w_Kensa := '';
  //初期設定ファイルにある伝票コード分
  for w_i := 0 to Length(g_ReportType_ID) - 1 do begin
    //同じ伝票コードがあった場合
    if arg_HisID = g_ReportType_ID[w_i].f_HIS_ID then
      //Report検査種別に変換
      w_Kensa := g_ReportType_ID[w_i].f_RIS_ID;
  end;
  //検査種別変換
  Result := w_Kensa;
end;

function func_ReportToHis(arg_ReportID:String):String;
var
  w_Kensa:String;
  w_i:Integer;
begin
  //初期化
  w_Kensa := '';
  //初期設定ファイルにある伝票コード分
  for w_i := 0 to Length(g_ReportType_ID) - 1 do begin
    //同じ検査種別があった場合
    if arg_ReportID = g_ReportType_ID[w_i].f_RIS_ID then
      //伝票コードに変換
      w_Kensa := g_ReportType_ID[w_i].f_HIS_ID;
  end;
  //伝票コード変換
  Result := w_Kensa;
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

     g_Log_Type[G_LOG_KIND_SVCDEF_NUM].f_LogMsg   := G_LOG_KIND_SVCDEF;
     g_Log_Type[G_LOG_KIND_SVCDEF_NUM].f_LogLevel := G_LOG_KIND_SVCDEF_LEVEL;

     g_Log_Type[G_LOG_KIND_DEBUG_NUM].f_LogMsg   := G_LOG_KIND_DEBUG;
     g_Log_Type[G_LOG_KIND_DEBUG_NUM].f_LogLevel := G_LOG_KIND_DEBUG_LEVEL;

     g_Log_Type[G_LOG_KIND_NG_NUM].f_LogMsg   := G_LOG_KIND_NG;
     g_Log_Type[G_LOG_KIND_NG_NUM].f_LogLevel := G_LOG_KIND_NG_LEVEL;
end;

finalization
begin
//
end;

end.
