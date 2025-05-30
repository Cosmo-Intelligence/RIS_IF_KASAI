unit UDb_RisSvr_Irai;
(**
■機能説明
  依頼情報受信サービス用のRisDBへのアクセス制御

■履歴
新規作成：2004.08.30：担当 増田
修正　　：2006.08.28：担当 増田　呉共済から四国がんセンター用に改修
修正　　：2006.09.22：担当 水野　BUISETMASTER 抽出時に部位分類IDを条件から除く対応
*)

interface

uses
//システム−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  IniFiles, ScktComp,SvcMgr,Math, //,Db, DBTables
//プロダクト開発共通−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−
  Gval,
  pdct_ini,
  KanaRoma,
  HisMsgDef,
  HisMsgDef01_IRAI,
  HisMsgDef03_CANCEL,
  HisMsgDef04_KANJA_Kekka,
  TcpSocket,
  Unit_Log, Unit_DB//, DB, DBTables
  ;
//型クラス宣言-------------------------------------------------------------
// 薬剤構造体
type
  TYakuzai = record
    //レコード区分
    RecKbn: String;
    //項目コード
    KmkCode: String;
    //項目名称
    KmkName: String;
    //使用量
    Use: String;
    //分割数
    Bunkatu: String;
    //予備
    Yobi: String;
  end;
//コメント構造体
type
  TComment = record
    //レコード区分
    RecKbn: String;
    //項目コード
    KmkCode: String;
    //使用量
    KmkName: String;
    //予備
    Yobi: String;
  end;
//シェーマ構造体
type
  TSchema = record
    //レコード区分
    RecKbn: String;
    //予備
    SchemaName: String;
    //予備
    SchemaInfo: String;
    //予備
    SchemaYobi: String;
  end;
//オーダグループ情報
type
  TOrderGroup = record
    // グループ番号
    GroupNo: String[3];
    // オーダ進捗
    OrderStatus: String[1];
    // 会計進捗
    AccountStatus: String[1];
    // 実施日
    ExDate: String[8];
    // 実施時間
    ExTime: String[4];
    // 項目コード
    KmkCode: String[6];
    // 項目名称
    KmkName: String[60];
    // 撮影種コード
    SatueiCode: String[6];
    // 撮影種名称
    SatueiName: String[60];
    // 部位コード
    BuiCode: String[6];
    // 部位名称
    BuiName: String[60];
    // 検査室コード
    KensaRoomCode: String[6];
    // 検査室名称
    KensaRoomName: String[60];
    // 明細数
    MeisaiCount: String[2];
    // 薬剤
    Yakuzai: array of TYakuzai;
    // コメント
    Comment: array of TComment;
    // シェーマ
    Schema: array of TSchema;
    // 部位ID(登録用)
    BuiID: String;
    // 方向ID(登録用)
    HoukouID: String;
    // 左右ID(登録用)
    SayuID: String;
    // 方法ID(登録用)
    HouhouID: String;
  end;
type
  TDb_RisSvr_Irai = class//(TDataModule)
  private
    { Private 宣言 }
    wm_SKbn      : String;  //処理区分
    wm_Offset    : Integer; //オフセット位置
    wm_ComOffset : Integer; //コメント情報開始オフセット位置

    wm_HeaderSendTo: String;     // 送信先
    wm_HeaderFromTo: String;     // 送信元
    wm_HeaderCommand: String;    // コマンド
    wm_HeaderStatus: String;     // ステータス
    wm_HeaderDate: String;         // 日付
    wm_HeaderTime: String;         // 時間
    
    wm_DataHospCode: String;       // 病院コード
    wm_KanjaPatientID: String;     // 患者番号
    wm_KanjaPatientName: String;   // 患者氏名
    wm_KanjaPatientKana: String;   // 患者カナ氏名
    wm_KanjaSex: String;           // 性別
    wm_KanjaBirthday: String;      // 生年月日
    wm_KanjaPostCode1: String;     // 郵便番号１
    wm_KanjaAddress1: String;      // 住所１
    wm_KanjaTEL1: String;          // 電話番号１
    wm_KanjaPostCode2: String;     // 郵便番号２
    wm_KanjaAddress2: String;      // 住所２
    wm_KanjaTEL2: String;          // 電話番号２
    wm_KanjaWardCode: String;      // 病棟コード
    wm_KanjaWardName: String;      // 病棟名称
    wm_KanjaSickroomCode: String;  // 病室コード
    //wm_KanjaSickroomName: String;  // 病室名称
    wm_KanjaKangoKbn: String;      // 看護区分
    wm_KanjaPatientKbn: String;    // 患者区分
    wm_KanjaKyugoKbn: String;      // 救護区分
    wm_KanjaYobiKbn: String;       // 予備区分
    wm_KanjaSyougaiInfo: String;   // 障害情報
    wm_KanjaHeight: String;        // 身長
    wm_KanjaWeight: String;        // 体重
    wm_KanjaBloodAB: String;       // 血液型ABO
    wm_KanjaBloodRH: String;       // 血液型RH
    wm_KanjaKansenInfo: String;    // 感染情報
    wm_KanjaKansenCom: String;     // 感染コメント
    wm_KanjaKinkiInfo: String;     // 禁忌情報
    wm_KanjaKinkiCom: String;      // 禁忌コメント
    wm_KanjaNinsinDate: String;    // 妊娠日
    wm_KanjaDeathDate: String;     // 死亡退院日
    //wm_KanjaYobi: String;          // 予備
    wm_DataOrdeNo: String;         // オーダ番号
    wm_DataStartDate: String;      // 開始日
    wm_DataStartTime: String;      // 開始時間
    wm_DataSatueiCode: String;     // 撮影種コード
    wm_DataSatueiName: String;     // 撮影種名称
    wm_DataInOutKbn: String;       // 入外区分
    wm_DataSectionCode: String;    // 依頼科コード
    wm_DataSectionName: String;    // 依頼科名称
    wm_DataDoctorCode: String;     // 依頼医コード
    wm_DataDoctorName: String;     // 依頼医名称
    //wm_DataBusyoCode: String;      // 部署コード
    //wm_DataBusyoName: String;      // 部署名称
    wm_DataWardCode: String;       // 病棟コード
    //wm_DataWardName: String;       // 病棟名称
    wm_DataSickroomCode: String;   // 病室コード
    //wm_DataSickroomName: String;   // 病室名称
    wm_DataKinkyuKbn: String;      // 緊急区分
    wm_DataSikyuKbn: String;       // 至急区分
    wm_DataGenzoKbn: String;       // 至急現像区分
    wm_DataYoyakuKbn: String;      // 予約区分
    wm_DataDokueiKbn: String;      // 読影区分
    wm_DataKbn6: String;           // 区分６
    wm_DataKbn7: String;           // 区分７
    {
    wm_DataHKCode1: String;        // 保険コード１
    wm_DataHKCode2: String;        // 保険コード２
    wm_DataHKCode3: String;        // 保険コード３
    wm_DataHKCode4: String;        // 保険コード４
    wm_DataHKCode5: String;        // 保険コード５
    }
    wm_DataUpDateDate: String;     // 依頼年月日
    wm_DataGroupCount: String;     // グループ数
    //wm_DataOrderComLen: String;    // オーダコメント長
    wm_DataMokutekiComLen: String; // 検査目的長
    wm_DataMokutekiCom: String;    // 検査目的
    wm_DataSijiComLen: String;     // 特別指示長
    wm_DataSijiCom: String;        // 特別指示
    wm_DataSonotaComLen: String;   // その他詳細長
    wm_DataSonotaCom: String;      // その他詳細
    wm_DataByoumeiComLen: String;  // 依頼時病名長
    wm_DataByoumeiCom: String;     // 依頼時病名
    {
    wm_DataDokueiComLen: String;   // 読影コメント長
    wm_DataDokueiCom: String;      // 読影コメント
    wm_DataSisikiCom: String;      // 歯式部位
    }
    wm_OrderBui: array of TOrderGroup; // オーダ部位情報

    wm_CancelOpeUserCode: String;  // 操作者コード
    wm_CancelOpeUserName: String;  // 操作者名称

    wm_SyotiRoom: String;          // 処置室使用フラグ
    wm_Tatiai: String;             // 放科医立会いフラグ
    wm_KensaType01Flg: String;     // 撮影系画面フラグ
    wm_KensaType02Flg: String;     // ポータブル画面フラグ
    wm_KensaType03Flg: String;     // 検査系画面フラグ
    wm_KensaType04Flg: String;     // 核医学画面フラグ

    wm_RISKensaType: String;     // RIS撮影種コード


  //オーダ部位テーブル
    wm_OrderCount     : Integer;  //オーダ部位情報格納域の現在位置
  //オーダ指示
    wm_ComIDCount : Integer; //現在位置
  //Exメイン
    wm_Shoken_Youhi_Flg : String;    //所見要否フラグ
  //オーダメイン-------------------------
    wm_Kensa_Date_Age     : Integer;   //検査時年齢
    wm_StudyInstanceUID   : String;    //スタディインスタンスUID
    wm_RTRIS_TypeID: String;     // 撮影種コード
  public
    { Public 宣言 }
    wm_RisID      : String;    //RIS識別ID
    (*
    DatabaseRis   : TDatabase; //RIS DB
    *)
    wg_DBFlg      : Boolean;
    w_RecvMsgTime : TDateTime; // YYYY/MM/DD hh:mi:ss
    wg_ShmFlg     : String;    //シェーマフラグ 0:無し、1:有り
    wg_Kind       : String;    //種別
    wg_DenbunNo: Integer;
    wg_DB_Type    : String;
    (*
    RTDatabaseRis   : TDatabase; //RTRIS DB
    wg_RTDBFlg      : Boolean;
    wm_TheraRisID : String;
    *)
    //DB系---------------------------------------------
    function  DBOpen(var arg_ErrMsg : String;
                         arg_Svc    : TService
                     ): Boolean;
    function  DBOpen2(var arg_ErrMsg : String;
                          arg_Svc    : TService
                      ): Boolean;
    procedure DBClose;

    //ツール系---------------------------------------------
    //☆一般化可能
    function  func_DelRecord(arg_TblName : String;
                             arg_Where   : String
                            ):Boolean;
    function  func_CoutRecord(arg_TblName : String;
                              arg_Where   : String
                             ):Integer;
    //☆一般化可能
    function  func_LockTbl(arg_TblName : String;
                           arg_List    : String;
                           arg_Where   : String;
                           arg_Wait    : String
                           ):Boolean;
    //前処理系---------------------------------------------
    function  func_DelOrder(    arg_Keep   : Integer;
                            var arg_ErrMsg : String
                           ):Boolean;
    procedure proc_MakeMsg(arg_System  : String;
                           arg_MsgKind : String;
                           arg_DID     : String;
                           arg_Command : String;
                           arg_Msg     : TStringStream
                           );
    function  func_SaveMsg(    arg_MsgKind   : String;
                               arg_kbn       : String;
                               arg_Date      : TDateTime;
                               arg_Msg       : TStringStream;
                           var arg_LogBuffer : String
                          ):Boolean;
    function  func_SaveMsgNG(  arg_MsgKind   : String;
                               arg_kbn       : String;
                               arg_Date      : TDateTime;
                               arg_Msg       : TStringStream;
                           var arg_LogBuffer : String
                          ):Boolean;
    //Main系---------------------------------------------
    //Msg解析---
    function  func_InquireMsg(    arg_RecvMsgStream : TStringStream;
                              var arg_MsgKind       : String;
                              var arg_LogBuffer     : String
                             ):Boolean;
      function  func_GetDataMsg(    arg_System        : String;
                                    arg_RecvMsgStream : TStringStream;
                                var arg_LogBuffer     : String
                                ):Boolean;
    //DBチェック---
        function func_CheckKanjaHisID(    arg_Flg  : String;
                                      var arg_DLog : String
                                     ):Boolean;
          function func_CheckID(arg_TblName : String;
                                arg_Where   : String
                               ):Boolean;
        function func_CheckIraiHisID(
                                     var arg_DLog: String
                                    ):Boolean;
          function  func_GetRisID(    arg_ID1           : String;
                                  var arg_RISID         : String;
                                  var arg_LogBuffer     : String
                                 ):Boolean;
    //DB格納---
        function  func_UpdateRisDBIrai(
                                       var arg_LogBuffer : String
                                      ):Boolean;
          function  func_UpdateRisDBIraiNew(
                                            var arg_LogBuffer : String
                                           ):Boolean;
          function func_MakeRisID(    arg_ID1           : String;
                                  var arg_RISID         : String;
                                  var arg_LogBuffer     : String
                                 ):Boolean;
            function  func_MakeRisID_No(    arg_ID1       : String;
                                        var arg_RISID     : String;
                                        var arg_LogBuffer : String
                                       ):Boolean;
            function  func_MakeOrderInfoTBL(    arg_RISID         : String;
                                            var arg_LogBuffer     : String
                                        ):Boolean;
            function  func_MakeOrderBuiTBL(    arg_RISID         : String;
                                           var arg_LogBuffer     : String
                                          ):Boolean;
            function  func_MakeOrderIndicateTBL(    arg_RISID     : String;
                                                var arg_LogBuffer : String
                                               ):Boolean;
            function  func_MakeOrderShemaTBL(    arg_RISID     : String;
                                             var arg_LogBuffer : String
                                               ):Boolean;
            function  func_MakeExMainTBL(    arg_RISID         : String;
                                         var arg_LogBuffer     : String
                                         ):Boolean;
        function  func_UpdateRisDBIraiUp(
                                         var arg_LogBuffer : String
                                         ):Boolean;
          function  func_UpExMainTBL(    arg_RISID     : String;
                                     var arg_LogBuffer : String
                                     ):Boolean;
          function  func_MakeKanjaTBL(    arg_KanjaID  : String;
                                      var arg_LogBuffer: String
                                     ):Boolean;
        function  func_UpdateRisDBIraiDel(
                                          var arg_LogBuffer : String
                                         ):Boolean;
        function  func_UpdateRisDBPatient(
                                          var arg_LogBuffer : String
                                          ):Boolean;
        function  func_InquireMsgForDB(    arg_System        : String;
                                           arg_MsgKind       : String;
                                           arg_RecvMsgStream : TStringStream;
                                           arg_TDate         : TDateTime;
                                       var arg_LogBuffer     : String
                                      ):Boolean;
          function  func_IdentifyRISID(    arg_System        : String;
                                       var arg_RISID         : String;
                                       var arg_LogBuffer     : String
                                      ):Boolean;
        function  func_InquireDB(    arg_System        : String;
                                     arg_MsgKind       : String;
                                     arg_RecvMsgStream : TStringStream;
                                 var arg_LogBuffer     : String
                                ):Boolean;
        function  func_CheckMax999(var arg_Msg : String):Boolean;
        function func_Get_StudyInstanceUID:String;
        procedure proc_GetDokuei(var arg_Dokuei:String);
        procedure proc_GetSyoti(var arg_Syoti,arg_Tatiai:String);
        procedure proc_GetRi(var arg_RI:String);
        procedure proc_GetPortable(var arg_Portable:String);
        procedure proc_GetKiki(var arg_KIKI:String);
        procedure proc_GetExamRoom(var arg_Room:String);
        procedure proc_GetDrTEL(    arg_Dr: String;
                                var arg_Tel:String
                                );
        function  func_GetSequence(var arg_Seq: Integer;
                                   var arg_LogBuffer : String
                                   ):Boolean;

    //患者
    function  func_InquireMsgForDB_Patient(    arg_System        : String;
                                               arg_MsgKind       : String;
                                               arg_RecvMsgStream : TStringStream;
                                               arg_TDate         : TDateTime;
                                           var arg_LogBuffer     : String
                                           ):Boolean;
      function  func_IdentifyPatientID(var arg_LogBuffer : String
                                       ):Boolean;

    function  func_GetType(var arg_LogBuffer: String):String;
    function  func_GetType_DB(var arg_LogBuffer: String):String;

    //2018/08/30 ToHisInfo登録
    function func_InsertToHisInfo(): boolean;
  end;

//定数宣言-------------------------------------------------------------------
const
//DB 定数
  CST_ORDERMAIN_KAIKEITYPE_FLG_HIS ='0'; //会計フラグOFF
  CST_SHOKEN_YOUHI_FLG_ON ='1';  //所見要否フラグON
  CST_SHOKEN_YOUHI_FLG_OFF ='0'; //所見要否フラグOFF
  CST_SHOKEN_YOUHI_FLG_ON2 ='2';  //所見要否フラグON(至急)
  CST_SOUSINSUMI_FLG = '1';      //送信済フラグ
  CST_MISOUSIN_FLG = '0';        //未送信フラグ
  CST_ORDER_RES_OK  = 'OK';  //：送信成功
  CST_ORDER_RES_NG  = 'NG';  //：送信失敗
  CST_ORDER_RES_NG1 = 'NG1'; //：送信失敗 通信不可
  CST_ORDER_RES_NG2 = 'NG2'; //：送信失敗 電文NG
  CST_ORDER_RES_CL =  'CL';  //：送信キャンセル
  //エラー発生場所特定メッセージ
  CST_GROUP_OVER  = 'グループ数が最大値を超えています。';
  CST_KENSAGROUP_OVER  = '検査系種別ですが部位が複数あります。';
  //未取得
  CST_GETNO_FLG='00';
  //取得
  CST_GETOK_FLG='10';
  //失敗
  CST_GETNG_FLG='09';

//変数宣言-------------------------------------------------------------------
var
  Db_RisSvr_Irai: TDb_RisSvr_Irai;

//関数手続き宣言-------------------------------------------------------------
implementation //**************************************************************
//使用ユニット---------------------------------------------------------------
//uses

//定数宣言       -------------------------------------------------------------
//const

//変数宣言     ---------------------------------------------------------------
//var

//関数手続き宣言--------------------------------------------------------------

//==============================================================================
//DB処理↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓
//==============================================================================
{******************************************************************************}
{                                                                              }
{    関数名 DBOpen　　　　　：Oracle接続制御関数(接続用)                       }
{                                                                              }
{  返り値型 Boolean型                                                          }
{           True ：正常終了                                                    }
{           False：異常終了                                                    }
{                                                                              }
{      引数 型                      名前         タイプ  説明                  }
{           String                  arg_ErrMsg   IN/OUT  例外メッセージ        }
{           TService                arg_Svc        IN    自サービス            }
{                                                                              }
{      例外 なし                                                               }
{                                                                              }
{  機能説明 Oracle接続制御関数(接続用)                                         }
{           Oracleへの接続の制御を行う。                                       }
{           エラー時には、INIファイルで設定された回数分リトライを行う。        }
{           リトライ回数を超えても接続ができない場合は、                       }
{           例外メッセージの内容を取得し終了する。                             }
{                                                                              }
{******************************************************************************}
function TDb_RisSvr_Irai.DBOpen(var arg_ErrMsg : String;
                                    arg_Svc    : TService):Boolean;
var
  RetryCnt: integer;
begin
  //初期値設定
  Result := True;

  //ログ作成
  if not Assigned(FLog) then begin
    FLog := T_FileLog.Create(g_DBLOG01_PATH,
                             g_DBLOG01_PREFIX,
                             g_DBLOG01_LOGGING,
                             g_DBLOG01_KEEPDAYS,
                             g_LogFileSize,   //2018/08/30 ログファイル変更
                             nil);
  end;
  if not Assigned(FDebug) then begin
    FDebug := T_FileLog.Create(g_DBLOGDBG01_PATH,
                               g_DBLOGDBG01_PREFIX,
                               g_DBLOGDBG01_LOGGING,
                               g_DBLOGDBG01_KEEPDAYS,
                               g_LogFileSize,   //2018/08/30 ログファイル変更
                               nil);
  end;
  //期限切れログ削除
  FLog.DayChange;
  FDebug.DayChange;

  //設定
  wg_DBFlg := True;
  if FDB = nil then begin
    //データベースを作成
    FDB := T_ORADB.Create(g_RisDB_Name,
                          g_RisDB_Uid,
                          g_RisDB_Pas,
                          FLog, FDebug);
  end;
  //クエリー作成
  if not Assigned(FQ_SEL) then begin
    FQ_SEL := T_Query.Create(FDB, FLog, FDebug);
  end;
  if not Assigned(FQ_ALT) then begin
    FQ_ALT := T_Query.Create(FDB, FLog, FDebug);
  end;
  //DB接続
  if FDB.DBConnect() = false then begin
    //リトライ回数初期化
    RetryCnt := 0;
    while RetryCnt < g_RisDB_Retry do begin
      //待機時間
      Sleep(10000);
      //再接続
      if FDB.DBConnect() = True then begin
        Exit;
      end;
    end;
    if RetryCnt > g_RisDB_Retry then begin
      wg_DBFlg := False;
      Result := False;
    end;
  end;
  //成功したのでリトライ回数を設定
  if wg_DBFlg = True Then begin
    //ログ出力
    proc_LogOut(G_LOG_LINE_HEAD_OK,'',G_LOG_KIND_DB_NUM,'RIS DB接続OK');
  end
  else begin
    //ログ出力
    proc_LogOut(G_LOG_LINE_HEAD_OK,'',G_LOG_KIND_DB_NUM,'RIS DB接続NG');
  end;

end;
{******************************************************************************}
{                                                                              }
{    関数名 DBOpen2　　　　：Oracle接続制御関数(再接続用)                      }
{                                                                              }
{  返り値型 Boolean型                                                          }
{           True ：正常終了                                                    }
{           False：異常終了                                                    }
{                                                                              }
{      引数 型                      名前         タイプ  説明                  }
{           String                  arg_ErrMsg   IN/OUT  例外メッセージ        }
{           TService                arg_Svc        IN    自サービス            }
{                                                                              }
{      例外 なし                                                               }
{                                                                              }
{  機能説明 Oracle接続制御関数(再接続用)                                       }
{           Oracleへの接続の制御を行う。                                       }
{                                                                              }
{******************************************************************************}
function TDb_RisSvr_Irai.DBOpen2(var arg_ErrMsg : String;
                                     arg_Svc    : TService):Boolean;
begin
  //初期値設定
  Result := True;

  //ログ作成
  if not Assigned(FLog) then begin
    FLog := T_FileLog.Create(g_DBLOG01_PATH,
                             g_DBLOG01_PREFIX,
                             g_DBLOG01_LOGGING,
                             g_DBLOG01_KEEPDAYS,
                             g_LogFileSize,   //2018/08/30 ログファイル変更
                             nil);
  end;
  if not Assigned(FDebug) then begin
    FDebug := T_FileLog.Create(g_DBLOGDBG01_PATH,
                               g_DBLOGDBG01_PREFIX,
                               g_DBLOGDBG01_LOGGING,
                               g_DBLOGDBG01_KEEPDAYS,
                               g_LogFileSize,   //2018/08/30 ログファイル変更
                               nil);
  end;
  //期限切れログ削除
  FLog.DayChange;
  FDebug.DayChange;

  //設定
  wg_DBFlg := True;
  if FDB = nil then begin
    //データベースを作成
    FDB := T_ORADB.Create(g_DB_NAME,
                          g_DB_UID,
                          g_DB_PAS,
                          FLog, FDebug);
  end;
  //クエリー作成
  if not Assigned(FQ_SEL) then begin
    FQ_SEL := T_Query.Create(FDB, FLog, FDebug);
  end;
  if not Assigned(FQ_ALT) then begin
    FQ_ALT := T_Query.Create(FDB, FLog, FDebug);
  end;
  //DB接続
  if FDB.DBConnect() = false then begin
    wg_DBFlg := False;
    Result := False;
  end;
  //成功したのでリトライ回数を設定
  if wg_DBFlg = True Then begin
    //ログ出力
    proc_LogOut(G_LOG_LINE_HEAD_OK,'',G_LOG_KIND_DB_NUM,'RIS DB再接続OK');
  end
  else begin
    //ログ出力
    proc_LogOut(G_LOG_LINE_HEAD_OK,'',G_LOG_KIND_DB_NUM,'RIS DB再接続NG');
  end;

end;
{******************************************************************************}
{                                                                              }
{    関数名 DBClose　　　　：Oracle接続制御関数(切断用)                        }
{                                                                              }
{  返り値型 Boolean型                                                          }
{           True ：正常終了                                                    }
{           False：異常終了                                                    }
{                                                                              }
{      引数 型                      名前         タイプ  説明                  }
{                                                                              }
{      例外 なし                                                               }
{                                                                              }
{  機能説明 Oracle接続制御関数(切断用)                                         }
{           Oracleへの切断の制御を行う。                                       }
{                                                                              }
{******************************************************************************}
procedure TDb_RisSvr_Irai.DBClose;
begin
  //設定
  wg_DBFlg := False;
//  wg_RTDBFlg := False;

  try
    FDB.DBDisConnect();
  except
  end;

end;
//==============================================================================
//ツール処理↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓
//==============================================================================
{******************************************************************************}
{                                                                              }
{    関数名 func_DelRecord　　：指定テーブルの削除                             }
{                                                                              }
{  返り値型 Boolean型                                                          }
{           True ：正常終了                                                    }
{           False：異常終了                                                    }
{                                                                              }
{      引数 型               名前             タイプ  説明                     }
{           String           arg_TblName        IN    テーブル名               }
{           String           arg_Where          IN    WHERE句                  }
{                                                                              }
{      例外 なし                                                               }
{                                                                              }
{  機能説明 指定テーブルの削除処理を行う。                                     }
{                                                                              }
{******************************************************************************}
function TDb_RisSvr_Irai.func_DelRecord(arg_TblName : String;
                                        arg_Where   : String
                                        ):Boolean;
var
  sqlExec:  String;
  iRslt:    Integer;
begin
  try
    with FQ_ALT do begin
      //SQL文字列作成
      sqlExec := '';
      sqlExec := sqlExec + 'DELETE  FROM ' + arg_TblName + ' ';
      //WHERE句がある場合
      if not func_IsNullStr( arg_Where ) then
      begin
        //WHERE句の作成
        sqlExec := sqlExec + ' WHERE ' + arg_Where + ' ';
      end;
      //SQL実行
      PrepareQuery(sqlExec);
      //SQL実行
      iRslt:= ExecSQL();
      if iRslt < 0 then begin
        //失敗
        Result := False;
        //
        Exit;
      end;
    end;
    //成功
    Result := True;
  except
    //失敗
    Result := False;
    //切断
    wg_DBFlg := False;
  end;
end;
{******************************************************************************}
{                                                                              }
{    関数名 func_CoutRecord　　：指定データのレコード数取得                    }
{                                                                              }
{  返り値型 Integer型                                                          }
{                                                                              }
{      引数 型               名前             タイプ  説明                     }
{           String           arg_TblName        IN    テーブル名               }
{           String           arg_Where          IN    WHERE句                  }
{                                                                              }
{      例外 なし                                                               }
{                                                                              }
{  機能説明 指定データのレコード数取得を行う。                                 }
{                                                                              }
{******************************************************************************}
function TDb_RisSvr_Irai.func_CoutRecord(arg_TblName : String;
                                         arg_Where   : String):Integer;
var
  iRslt:      Integer;
  sqlSelect:  String;
begin
  Result := 0;
  try
    with FQ_SEL do begin
      //SQL設定
      sqlSelect := '';
      sqlSelect := sqlSelect + 'SELECT COUNT(*) RES FROM ' + arg_TblName + ' ';
      if not func_IsNullStr(arg_Where) then
      begin
        sqlSelect := sqlSelect + 'WHERE ' + arg_Where + ' ';
      end;
      PrepareQuery(sqlSelect);
      //SQL実行
      iRslt:= OpenQuery();
      if iRslt < 0 then begin
        //例外エラー
        Result := -2;
        //処理終了
        Exit;
      end;

      if Eof = False then begin
        // 対象データの取得
        Result := StrToIntDef(GetString('RES'), 0);
      end;
    end;
  except
    //例外エラー
    Result := -2;
    //切断
    wg_DBFlg := False;
    //処理終了
    Exit;
  end;
end;
{******************************************************************************}
{                                                                              }
{    関数名 func_LockTbl   　　：指定データのLOCK処理                          }
{                                                                              }
{  返り値型 Boolean型                                                          }
{           True ：正常終了                                                    }
{           False：異常終了                                                    }
{                                                                              }
{      引数 型               名前             タイプ  説明                     }
{           String           arg_TblName        IN    テーブル名               }
{           String           arg_List           IN    SELECT句                 }
{           String           arg_Where          IN    WHERE句                  }
{           String           arg_Wait           IN    Wait指定                 }
{                                                                              }
{      例外 なし                                                               }
{                                                                              }
{  機能説明 指定データのLOCK処理を行う。                                       }
{                                                                              }
{******************************************************************************}
function  TDb_RisSvr_Irai.func_LockTbl(arg_TblName : String;
                                       arg_List    : String;
                                       arg_Where   : String;
                                       arg_Wait    : String):Boolean;
var
  iRslt:    Integer;
  sqlExec:  String;
begin
  try
    with FQ_ALT do begin
      //SQL文字列作成
      sqlExec := '';
      sqlExec := sqlExec + 'SELECT ' + arg_List + ' ';
      sqlExec := sqlExec + 'FROM ' + arg_TblName + ' ';
      //WHERE句がある場合
      if not func_IsNullStr(arg_Where) then
      begin
        //WHERE句の作成
        sqlExec := sqlExec + ' WHERE ' + arg_Where + ' ';
      end;
      //WAIT、NOWAIT指定
      sqlExec := sqlExec + ' FOR UPDATE ' + arg_Wait;
      //SQL設定
      PrepareQuery(sqlExec);
      //SQL実行
      iRslt:= ExecSQL();
      if iRslt < 0 then begin
        //失敗
        Result := False;
        //
        Exit;
      end;
    end;
    //成功
    Result := True;
  except
    //失敗
    Result := False;
    //切断
    wg_DBFlg := False;
  end;
end;
//==============================================================================
//前処理↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓
//==============================================================================
{******************************************************************************}
{                                                                              }
{    関数名 func_DelOrder　　：受信データの削除                                }
{                                                                              }
{  返り値型 Boolean型                                                          }
{           True ：正常終了                                                    }
{           False：異常終了                                                    }
{                                                                              }
{      引数 型               名前             タイプ  説明                     }
{           Integer          arg_Keep           IN    保存期間                 }
{           String           arg_ErrMsg       IN/OUT  エラーメッセージ         }
{                                                                              }
{      例外 なし                                                               }
{                                                                              }
{  機能説明 受信済のインフォテーブルを削除する。                               }
{                                                                              }
{******************************************************************************}
function  TDb_RisSvr_Irai.func_DelOrder(    arg_Keep   : Integer;
                                        var arg_ErrMsg : String
                                        ):Boolean;
var
  iRslt:    Integer;
  sqlExec:  String;
  isCommit: Boolean;
begin
  //戻り値
  Result := True;
  iRslt := 0;
  isCommit := False;
  try
    //トランザクション開始
    FDB.StartTransaction;
    try
      with FQ_ALT do begin
        //SQL文字列作成
        sqlExec := '';
        sqlExec := sqlExec + 'DELETE FROM FROMHISINFO ';
        sqlExec := sqlExec + ' WHERE RECIEVEDATE < ( sysdate - ' + IntToStr(arg_Keep) + ')';
        sqlExec := sqlExec + ' AND (MESSAGETYPE = ''' + CST_APPTYPE_OI01 + '''';
        sqlExec := sqlExec + '  OR MESSAGETYPE = ''' + CST_APPTYPE_OI99 + '''';
        sqlExec := sqlExec + '  OR MESSAGETYPE = ''' + CST_APPTYPE_PI01 + '''';
        sqlExec := sqlExec + '  OR MESSAGETYPE = ''' + CST_APPTYPE_PI99 + ''')';
        //SQL設定
        PrepareQuery(sqlExec);
        //SQL実行
        iRslt:= ExecSQL();
        if iRslt < 0 then begin
          //失敗
          Result := False;
          //切断
          wg_DBFlg := False;
          //
          Exit;
        end;
      end;
      //成功
      Result := True;
      isCommit := True;
    except
      //失敗
      Result := False;
      //切断
      wg_DBFlg := False;
    end;
  finally
    if isCommit = True then begin
      //コミット
      FDB.Commit;
    end
    else begin
      //ロールバック
      FDB.Rollback;
    end;
  end;
end;
{******************************************************************************}
{                                                                              }
{    関数名 proc_MakeMsg 　　：返信電文作成                                    }
{                                                                              }
{  返り値型 なし                                                               }
{                                                                              }
{      引数 型               名前             タイプ  説明                     }
{           String           arg_System         IN    システム区分             }
{           String           arg_MsgKind        IN    電文種別                 }
{           String           arg_DID            IN    ステータス               }
{           String           arg_Command        IN    コマンド                 }
{           TStringStream    arg_Msg            IN    電文格納変数             }
{                                                                              }
{      例外 なし                                                               }
{                                                                              }
{  機能説明 返信用電文を作成します。                                           }
{                                                                              }
{******************************************************************************}
procedure TDb_RisSvr_Irai.proc_MakeMsg(arg_System  : String;
                                       arg_MsgKind : String;
                                       arg_DID     : String;
                                       arg_Command : String;
                                       arg_Msg     : TStringStream
                                       );
begin
  try
    //種別により電文に初期文字列を設定する
    proc_ClearStream(arg_System,arg_MsgKind,arg_Msg);
    //電文のヘッダに種別ごとの固定文字列を設定
    proc_SetStreamHDDef(arg_System,arg_MsgKind,arg_Msg);
    //ステータス
    proc_SetStringStream(arg_System, arg_MsgKind, arg_Msg, COMMON1STATUSNO,
                         arg_DID);
    //コマンド
    proc_SetStringStream(arg_System, arg_MsgKind, arg_Msg, COMMON1COMMANDNO,
                         arg_Command);
    //データ長
    proc_SetStringStream(arg_System, arg_MsgKind, arg_Msg, COMMON1DENLENNO,
                         '000000');
  except
    //エラー終了処理 発生しないはず
    Exit;
  end;
end;
//==============================================================================
//Main系Msg解析処理↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓
//==============================================================================
{******************************************************************************}
{                                                                              }
{    関数名 func_InquireMsg 　　：電文の解析とチェック                         }
{                                                                              }
{  返り値型 なし                                                               }
{                                                                              }
{      引数 型             名前              タイプ  説明                      }
{           TStringStream  arg_RecvMsgStream   IN    電文格納変数              }
{           String         arg_MsgKind       IN/OUT  電文種別                  }
{           String         arg_LogBuffer     IN/OUT  ログ内容                  }
{                                                                              }
{      例外 なし                                                               }
{                                                                              }
{  機能説明 受信電文の解析とチェックを行います。                               }
{                                                                              }
{******************************************************************************}
function  TDb_RisSvr_Irai.func_InquireMsg(    arg_RecvMsgStream : TStringStream;
                                          var arg_MsgKind       : String;
                                          var arg_LogBuffer     : String
                                          ):Boolean;
var
  res   : Boolean;
  w_Res : String;
begin
  try
    //電文の空チェック
    if func_IsNullStr(arg_RecvMsgStream.DataString) then
    begin
      //ログ出力
      proc_StrConcat(arg_LogBuffer,'電文長 NG [空電文]');
      //異常終了
      Result := False;
      //処理終了
      Exit;
    end;
    //コマンド名項目に移動（オーダ・患者・オーダキャンセルどれも項目位置は同じ）
    arg_RecvMsgStream.Position := g_Stream01_IRAI[IRAICOMMANDNO].offset;
    //コマンド名項目分読み込み
    w_Res := arg_RecvMsgStream.ReadString(g_Stream01_IRAI[IRAICOMMANDNO].size);
    //コマンド名が"オーダ情報","患者情報更新","患者死亡退院情報",
    //"オーダキャンセル"以外の場合
    if (CST_COMMAND_ORDER <> w_Res) and
      (CST_COMMAND_KANJAUP  <> w_Res) and
      (CST_COMMAND_KANJADEL  <> w_Res) and
      (CST_COMMAND_ORDERCANCEL <> w_Res) then
    begin
      //ログ出力
      proc_StrConcat(arg_LogBuffer,'電文長 OK ');
      //ログ出力
      proc_StrConcat(arg_LogBuffer,'「コマンド名異常NG（コマンド名＝' + w_Res +
                     '）」');
      //異常終了
      Result := False;
      //処理終了
      Exit;
    end;
    //ログ出力
    proc_StrConcat(arg_LogBuffer,'電文長 OK ');
    //ログ出力
    proc_StrConcat(arg_LogBuffer,'コマンド名 OK ');
    //コマンド名が"オーダ情報","患者情報更新","患者死亡退院情報",
    //"オーダキャンセル"以外の場合
    if (CST_COMMAND_ORDER = w_Res)  then
    begin
      //ログ出力
      proc_StrConcat(arg_LogBuffer,'オーダ情報 ');
    end
    else if (CST_COMMAND_KANJAUP = w_Res) then
    begin
      //ログ出力
      proc_StrConcat(arg_LogBuffer,'患者情報 ');
    end
    else if (CST_COMMAND_KANJADEL = w_Res) then
    begin
      //ログ出力
      proc_StrConcat(arg_LogBuffer,'死亡退院 ');
    end
    else if (CST_COMMAND_ORDERCANCEL = w_Res) then
    begin
      //ログ出力
      proc_StrConcat(arg_LogBuffer,'キャンセル ');
    end;
    //情報の取得
    //必要情報の取り出し
    res := func_GetDataMsg(G_MSG_SYSTEM_A, arg_RecvMsgStream, arg_LogBuffer);
    //正常終了ではない場合
    if not res then
    begin
      //戻り値
      Result := False;
      //処理終了
      Exit;
    end;
    //正常終了
    Result := True;
    //処理終了
    Exit;
  except
    on E:exception do
    begin
      //ログ文字列作成
      proc_StrConcat(arg_LogBuffer,'電文チェック�@NG「例外発生'+E.Message+'」');
      //戻り値
      Result := False;
      //処理終了
      Exit;
    end;
  end;
end;
{******************************************************************************}
{                                                                              }
{    関数名 func_GetDataMsg 　　：電文を変数に格納                             }
{                                                                              }
{  返り値型 なし                                                               }
{                                                                              }
{      引数 型             名前              タイプ  説明                      }
{           String         arg_System          IN    システム区分              }
{           TStringStream  arg_RecvMsgStream   IN    電文格納変数              }
{           String         arg_LogBuffer     IN/OUT  ログ内容                  }
{                                                                              }
{      例外 なし                                                               }
{                                                                              }
{  機能説明 受信電文を項目ごとに変数に格納します。                             }
{                                                                              }
{******************************************************************************}
function  TDb_RisSvr_Irai.func_GetDataMsg(     arg_System        : String;
                                               arg_RecvMsgStream : TStringStream;
                                           var arg_LogBuffer     : String
                                          ):Boolean;
var
//変換ワーク
  w_StremField : TStreamField;
  wi_GroupCount: Integer;
  wi_MeisaiCount: Integer;
  w_Loop_Bui   : Integer;
  ws_RecKbn    : String;
  wi_Index     : Integer;
  w_Loop_Meisai: Integer;
begin
  // 電文より必要情報を取り出す
  try
    //開始・終了（とりあえず）
    wg_Kind := G_MSGKIND_START;
    //初期化
    wg_ShmFlg := '0';

    wm_HeaderDate := FormatDateTime('MMDD',w_RecvMsgTime);
    wm_HeaderTime := FormatDateTime('HHNNSS',w_RecvMsgTime);

    //電文：送信先の取得
    wm_HeaderSendTo := '';
    wm_HeaderSendTo := func_GetStringStream(arg_System, wg_Kind,
                                              arg_RecvMsgStream,
                                              COMMON1SDIDNO);
    //半角ブランクの削除
    wm_HeaderSendTo := TrimRight(wm_HeaderSendTo);
    //電文：送信元の取得
    wm_HeaderFromTo := '';
    wm_HeaderFromTo := func_GetStringStream(arg_System, wg_Kind,
                                                arg_RecvMsgStream,
                                                COMMON1RVIDNO);
    //半角ブランクの削除
    wm_HeaderFromTo := TrimRight(wm_HeaderFromTo);
    //電文：ステータスの取得
    wm_HeaderStatus := '';
    wm_HeaderStatus := func_GetStringStream(arg_System, wg_Kind,
                                          arg_RecvMsgStream, COMMON1STATUSNO);
    //半角ブランクの削除
    wm_HeaderStatus := TrimRight(wm_HeaderStatus);

    //オーダ情報
    wg_Kind := G_MSGKIND_IRAI;
    //電文：コマンドの取得
    wm_HeaderCommand := '';
    { 2008.03.10
    wm_HeaderCommand := func_GetStringStream(arg_System, wg_Kind,
                                          arg_RecvMsgStream, COMMON1COMMANDNO);
    }
    wm_HeaderCommand := func_GetStringStream(arg_System, wg_Kind,
                                          arg_RecvMsgStream, IRAICOMMANDNO);
    //半角ブランクの削除
    wm_HeaderCommand := TrimRight(wm_HeaderCommand);
    //オーダ情報
    if wm_HeaderCommand = CST_COMMAND_ORDER then
    begin
      //オーダ情報
      wg_Kind := G_MSGKIND_IRAI;
      //電文：病院コードの取得
      wm_DataHospCode := '';
      wm_DataHospCode := func_GetStringStream(arg_System, wg_Kind,
                                              arg_RecvMsgStream,
                                              IRAIHOSPCODENO);
      //半角ブランクの削除
      wm_DataHospCode := TrimRight(wm_DataHospCode);
      //電文：患者番号の取得
      wm_KanjaPatientID := '';
      wm_KanjaPatientID := func_GetStringStream(arg_System, wg_Kind,
                                                arg_RecvMsgStream, IRAIPIDNO);
      //半角ブランクの削除
      wm_KanjaPatientID := TrimRight(wm_KanjaPatientID);
      //電文：患者氏名の取得
      wm_KanjaPatientName := '';
      wm_KanjaPatientName := func_GetStringStream(arg_System, wg_Kind,
                                                  arg_RecvMsgStream,
                                                  IRAIPNAMENO);
      //半角ブランクの削除
      wm_KanjaPatientName := TrimRight(wm_KanjaPatientName);
      //全角ブランクの削除
      wm_KanjaPatientName := func_MBTrimRight(wm_KanjaPatientName);
      //電文：患者カナ氏名の取得
      wm_KanjaPatientKana := '';
      wm_KanjaPatientKana := func_GetStringStream(arg_System, wg_Kind,
                                                  arg_RecvMsgStream,
                                                  IRAIPKANANO);
      //半角ブランクの削除
      wm_KanjaPatientKana := TrimRight(wm_KanjaPatientKana);
      //電文：性別の取得
      wm_KanjaSex := '';
      wm_KanjaSex := func_GetStringStream(arg_System, wg_Kind,
                                          arg_RecvMsgStream, IRAISEXNO);
      //半角ブランクの削除
      wm_KanjaSex := TrimRight(wm_KanjaSex);
      //電文：生年月日の取得
      wm_KanjaBirthday := '';
      wm_KanjaBirthday := func_GetStringStream(arg_System, wg_Kind,
                                               arg_RecvMsgStream,
                                               IRAIBIRTHDAYNO);
      //半角ブランクの削除
      wm_KanjaBirthday := TrimRight(wm_KanjaBirthday);
      //電文：郵便番号１の取得
      wm_KanjaPostCode1 := '';
      wm_KanjaPostCode1 := func_GetStringStream(arg_System, wg_Kind,
                                                arg_RecvMsgStream,
                                                IRAIPOSTCODE1NO);
      //半角ブランクの削除
      wm_KanjaPostCode1 := TrimRight(wm_KanjaPostCode1);
      //電文：住所１の取得
      wm_KanjaAddress1 := '';
      wm_KanjaAddress1 := func_GetStringStream(arg_System, wg_Kind,
                                               arg_RecvMsgStream,
                                               IRAIADDRESS1NO);
      //半角ブランクの削除
      wm_KanjaAddress1 := TrimRight(wm_KanjaAddress1);
      //全角ブランクの削除
      wm_KanjaAddress1 := func_MBTrimRight(wm_KanjaAddress1);
      //電文：電話番号１の取得
      wm_KanjaTEL1 := '';
      wm_KanjaTEL1 := func_GetStringStream(arg_System, wg_Kind,
                                           arg_RecvMsgStream, IRAITEL1NO);
      //半角ブランクの削除
      wm_KanjaTEL1 := TrimRight(wm_KanjaTEL1);
      //電文：郵便番号２の取得
      wm_KanjaPostCode2 := '';
      wm_KanjaPostCode2 := func_GetStringStream(arg_System, wg_Kind,
                                                arg_RecvMsgStream,
                                                IRAIPOSTCODE2NO);
      //半角ブランクの削除
      wm_KanjaPostCode2 := TrimRight(wm_KanjaPostCode2);
      //電文：住所２の取得
      wm_KanjaAddress2 := '';
      wm_KanjaAddress2 := func_GetStringStream(arg_System, wg_Kind,
                                               arg_RecvMsgStream,
                                               IRAIADDRESS2NO);
      //半角ブランクの削除
      wm_KanjaAddress2 := TrimRight(wm_KanjaAddress2);
      //全角ブランクの削除
      wm_KanjaAddress2 := func_MBTrimRight(wm_KanjaAddress2);
      //電文：電話番号２の取得
      wm_KanjaTEL2 := '';
      wm_KanjaTEL2 := func_GetStringStream(arg_System, wg_Kind,
                                           arg_RecvMsgStream, IRAITEL2NO);
      //半角ブランクの削除
      wm_KanjaTEL2 := TrimRight(wm_KanjaTEL2);
      //電文：病棟コードの取得
      wm_KanjaWardCode := '';
      wm_KanjaWardCode := func_GetStringStream(arg_System, wg_Kind,
                                               arg_RecvMsgStream,
                                               IRAIBYOUTOIDNO);
      //半角ブランクの削除
      wm_KanjaWardCode := TrimRight(wm_KanjaWardCode);
      //電文：病棟名称の取得
      wm_KanjaWardName := '';
      wm_KanjaWardName := func_GetStringStream(arg_System, wg_Kind,
                                               arg_RecvMsgStream,
                                               IRAIBYOUTONAMENO);
      //半角ブランクの削除
      wm_KanjaWardName := TrimRight(wm_KanjaWardName);
      //全角ブランクの削除
      wm_KanjaWardName := func_MBTrimRight(wm_KanjaWardName);
      //電文：病室コードの取得
      wm_KanjaSickroomCode := '';
      wm_KanjaSickroomCode := func_GetStringStream(arg_System, wg_Kind,
                                                   arg_RecvMsgStream,
                                                   IRAIROOMIDNO);
      //半角ブランクの削除
      wm_KanjaSickroomCode := TrimRight(wm_KanjaSickroomCode);
      {
      //電文：病室名称の取得
      wm_KanjaSickroomName := '';
      wm_KanjaSickroomName := func_GetStringStream(arg_System, wg_Kind,
                                                   arg_RecvMsgStream,
                                                   IRAIROOMNAMENO);
      //半角ブランクの削除
      wm_KanjaSickroomName := TrimRight(wm_KanjaSickroomName);
      //全角ブランクの削除
      wm_KanjaSickroomName := func_MBTrimRight(wm_KanjaSickroomName);
      }
      //電文：看護区分の取得
      wm_KanjaKangoKbn := '';
      wm_KanjaKangoKbn := func_GetStringStream(arg_System, wg_Kind,
                                               arg_RecvMsgStream,
                                               IRAIKANGOKBNNO);
      //半角ブランクの削除
      wm_KanjaKangoKbn := TrimRight(wm_KanjaKangoKbn);
      //電文：患者区分の取得
      wm_KanjaPatientKbn := '';
      wm_KanjaPatientKbn := func_GetStringStream(arg_System, wg_Kind,
                                                 arg_RecvMsgStream,
                                                 IRAIKANJAKBNNO);
      //半角ブランクの削除
      wm_KanjaPatientKbn := TrimRight(wm_KanjaPatientKbn);
      //電文：救護区分の取得
      wm_KanjaKyugoKbn := '';
      wm_KanjaKyugoKbn := func_GetStringStream(arg_System, wg_Kind,
                                               arg_RecvMsgStream,
                                               IRAIKYUGOKBNNO);
      //半角ブランクの削除
      wm_KanjaKyugoKbn := TrimRight(wm_KanjaKyugoKbn);
      //電文：予備区分の取得
      wm_KanjaYobiKbn := '';
      wm_KanjaYobiKbn := func_GetStringStream(arg_System, wg_Kind,
                                              arg_RecvMsgStream, IRAIYOBIKBNNO);
      //半角ブランクの削除
      wm_KanjaYobiKbn := TrimRight(wm_KanjaYobiKbn);
      //電文：障害情報の取得
      wm_KanjaSyougaiInfo := '';
      wm_KanjaSyougaiInfo := func_GetStringStream(arg_System, wg_Kind,
                                                  arg_RecvMsgStream,
                                                  IRAISYOGAINO);
      //電文：身長の取得
      wm_KanjaHeight := '';
      wm_KanjaHeight := func_GetStringStream(arg_System, wg_Kind,
                                             arg_RecvMsgStream, IRAIHEIGHTNO);
      //半角ブランクの削除
      wm_KanjaHeight := TrimRight(wm_KanjaHeight);
      //電文：体重の取得
      wm_KanjaWeight := '';
      wm_KanjaWeight := func_GetStringStream(arg_System, wg_Kind,
                                             arg_RecvMsgStream, IRAIWEIGHTNO);
      //半角ブランクの削除
      wm_KanjaWeight := TrimRight(wm_KanjaWeight);
      //電文：血液型ABOの取得
      wm_KanjaBloodAB := '';
      wm_KanjaBloodAB := func_GetStringStream(arg_System, wg_Kind,
                                              arg_RecvMsgStream,
                                              IRAIBLOODABONO);
      //半角ブランクの削除
      wm_KanjaBloodAB := TrimRight(wm_KanjaBloodAB);
      //電文：血液型RHの取得
      wm_KanjaBloodRH := '';
      wm_KanjaBloodRH := func_GetStringStream(arg_System, wg_Kind,
                                              arg_RecvMsgStream, IRAIBLOODRHNO);
      //半角ブランクの削除
      wm_KanjaBloodRH := TrimRight(wm_KanjaBloodRH);
      //電文：感染情報の取得
      wm_KanjaKansenInfo := '';
      wm_KanjaKansenInfo := func_GetStringStream(arg_System, wg_Kind,
                                                 arg_RecvMsgStream,
                                                 IRAIKANSENNO);
      //電文：感染コメントの取得
      wm_KanjaKansenCom := '';
      wm_KanjaKansenCom := func_GetStringStream(arg_System, wg_Kind,
                                                arg_RecvMsgStream,
                                                IRAIKANSENCOMNO);
      //半角ブランクの削除
      wm_KanjaKansenCom := TrimRight(wm_KanjaKansenCom);
      //全角ブランクの削除
      wm_KanjaKansenCom := func_MBTrimRight(wm_KanjaKansenCom);
      //電文：禁忌情報の取得
      wm_KanjaKinkiInfo := '';
      wm_KanjaKinkiInfo := func_GetStringStream(arg_System, wg_Kind,
                                                arg_RecvMsgStream,
                                                IRAIKINKINO);
      //電文：禁忌コメントの取得
      wm_KanjaKinkiCom := '';
      wm_KanjaKinkiCom := func_GetStringStream(arg_System, wg_Kind,
                                               arg_RecvMsgStream,
                                               IRAIKINKICOMNO);
      //半角ブランクの削除
      wm_KanjaKinkiCom := TrimRight(wm_KanjaKinkiCom);
      //全角ブランクの削除
      wm_KanjaKinkiCom := func_MBTrimRight(wm_KanjaKinkiCom);
      //電文：妊娠日の取得
      wm_KanjaNinsinDate := '';
      wm_KanjaNinsinDate := func_GetStringStream(arg_System, wg_Kind,
                                                 arg_RecvMsgStream,
                                                 IRAININSINNO);
      //半角ブランクの削除
      wm_KanjaNinsinDate := TrimRight(wm_KanjaNinsinDate);
      //電文：死亡退院日の取得
      wm_KanjaDeathDate := '';
      wm_KanjaDeathDate := func_GetStringStream(arg_System, wg_Kind,
                                                arg_RecvMsgStream,
                                                IRAIDETHDATENO);
      //半角ブランクの削除
      wm_KanjaDeathDate := TrimRight(wm_KanjaDeathDate);
      {
      //電文：予備の取得
      wm_KanjaYobi := '';
      wm_KanjaYobi := func_GetStringStream(arg_System, wg_Kind,
                                           arg_RecvMsgStream, IRAIYOBI1NO);
      //半角ブランクの削除
      wm_KanjaYobi := TrimRight(wm_KanjaYobi);
      }
      //電文：オーダ番号の取得
      wm_DataOrdeNo := '';
      wm_DataOrdeNo := func_GetStringStream(arg_System, wg_Kind,
                                            arg_RecvMsgStream, IRAIORDERNO);
      //半角ブランクの削除
      wm_DataOrdeNo := TrimRight(wm_DataOrdeNo);
      //電文：開始日の取得
      wm_DataStartDate := '';
      wm_DataStartDate := func_GetStringStream(arg_System, wg_Kind,
                                               arg_RecvMsgStream,
                                               IRAISTARTDATENO);
      //半角ブランクの削除
      wm_DataStartDate := TrimRight(wm_DataStartDate);
      //電文：開始時間の取得
      wm_DataStartTime := '';
      wm_DataStartTime := func_GetStringStream(arg_System, wg_Kind,
                                               arg_RecvMsgStream,
                                               IRAISTARTTIMENO);
      //半角ブランクの削除
      wm_DataStartTime := TrimRight(wm_DataStartTime);
      //電文：撮影種コードの取得
      wm_DataSatueiCode := '';
      wm_DataSatueiCode := func_GetStringStream(arg_System, wg_Kind,
                                                arg_RecvMsgStream,
                                                IRAISATUEICODENO);
      //半角ブランクの削除
      wm_DataSatueiCode := TrimRight(wm_DataSatueiCode);

      wm_RISKensaType := wm_DataSatueiCode;
      //電文：撮影種名称の取得
      wm_DataSatueiName := '';
      wm_DataSatueiName := func_GetStringStream(arg_System, wg_Kind,
                                                arg_RecvMsgStream,
                                                IRAISATUEINAMENO);
      //半角ブランクの削除
      wm_DataSatueiName := TrimRight(wm_DataSatueiName);
      //全角ブランクの削除
      wm_DataSatueiName := func_MBTrimRight(wm_DataSatueiName);
      //電文：入外区分の取得
      wm_DataInOutKbn := '';
      wm_DataInOutKbn := func_GetStringStream(arg_System, wg_Kind,
                                              arg_RecvMsgStream,
                                              IRAIINOUTKBNNO);
      //半角ブランクの削除
      wm_DataInOutKbn := TrimRight(wm_DataInOutKbn);
      //電文：依頼科コードの取得
      wm_DataSectionCode := '';
      wm_DataSectionCode := func_GetStringStream(arg_System, wg_Kind,
                                                 arg_RecvMsgStream,
                                                 IRAISECTIONCODENO);
      //半角ブランクの削除
      wm_DataSectionCode := TrimRight(wm_DataSectionCode);
      //電文：依頼科名称の取得
      wm_DataSectionName := '';
      wm_DataSectionName := func_GetStringStream(arg_System, wg_Kind,
                                                 arg_RecvMsgStream,
                                                 IRAISECTIONNAMENO);
      //半角ブランクの削除
      wm_DataSectionName := TrimRight(wm_DataSectionName);
      //全角ブランクの削除
      wm_DataSectionName := func_MBTrimRight(wm_DataSectionName);
      //電文：依頼医コードの取得
      wm_DataDoctorCode := '';
      wm_DataDoctorCode := func_GetStringStream(arg_System, wg_Kind,
                                                arg_RecvMsgStream,
                                                IRAIDOCTORCODENO);
      //半角ブランクの削除
      wm_DataDoctorCode := TrimRight(wm_DataDoctorCode);
      //電文：依頼医名称の取得
      wm_DataDoctorName := '';
      wm_DataDoctorName := func_GetStringStream(arg_System, wg_Kind,
                                                arg_RecvMsgStream,
                                                IRAIDOCTORNAMENO);
      //半角ブランクの削除
      wm_DataDoctorName := TrimRight(wm_DataDoctorName);
      //全角ブランクの削除
      wm_DataDoctorName := func_MBTrimRight(wm_DataDoctorName);
      {
      //電文：部署コードの取得
      wm_DataBusyoCode := '';
      wm_DataBusyoCode := func_GetStringStream(arg_System, wg_Kind,
                                               arg_RecvMsgStream,
                                               IRAIBUSYOCODENO);
      //半角ブランクの削除
      wm_DataBusyoCode := TrimRight(wm_DataBusyoCode);
      //電文：部署名称の取得
      wm_DataBusyoName := '';
      wm_DataBusyoName := func_GetStringStream(arg_System, wg_Kind,
                                               arg_RecvMsgStream,
                                               IRAIBUSYONAMENO);
      //半角ブランクの削除
      wm_DataBusyoName := TrimRight(wm_DataBusyoName);
      //全角ブランクの削除
      wm_DataBusyoName := func_MBTrimRight(wm_DataBusyoName);
      //電文：病棟コードの取得
      wm_DataWardCode := '';
      wm_DataWardCode := func_GetStringStream(arg_System, wg_Kind,
                                              arg_RecvMsgStream,
                                              IRAIONBYOTOCODENO);
      //半角ブランクの削除
      wm_DataWardCode := TrimRight(wm_DataWardCode);
      //電文：病棟名称の取得
      wm_DataWardName := '';
      wm_DataWardName := func_GetStringStream(arg_System, wg_Kind,
                                              arg_RecvMsgStream,
                                              IRAIONBYOTONAMENO);
      //半角ブランクの削除
      wm_DataWardName := TrimRight(wm_DataWardName);
      //全角ブランクの削除
      wm_DataWardName := func_MBTrimRight(wm_DataWardName);
      //電文：病室コードの取得
      wm_DataSickroomCode := '';
      wm_DataSickroomCode := func_GetStringStream(arg_System, wg_Kind,
                                                  arg_RecvMsgStream,
                                                  IRAIONROOMCODENO);
      //半角ブランクの削除
      wm_DataSickroomCode := TrimRight(wm_DataSickroomCode);
      //電文：病室名称の取得
      wm_DataSickroomName := '';
      wm_DataSickroomName := func_GetStringStream(arg_System, wg_Kind,
                                                  arg_RecvMsgStream,
                                                  IRAIONROOMNAMENO);
      //半角ブランクの削除
      wm_DataSickroomName := TrimRight(wm_DataSickroomName);
      //全角ブランクの削除
      wm_DataSickroomName := func_MBTrimRight(wm_DataSickroomName);
      }
      //電文：緊急区分の取得
      wm_DataKinkyuKbn := '';
      wm_DataKinkyuKbn := func_GetStringStream(arg_System, wg_Kind,
                                               arg_RecvMsgStream,
                                               IRAIKINKYUKBNNO);
      //半角ブランクの削除
      wm_DataKinkyuKbn := TrimRight(wm_DataKinkyuKbn);
      //電文：至急区分の取得
      wm_DataSikyuKbn := '';
      wm_DataSikyuKbn := func_GetStringStream(arg_System, wg_Kind,
                                              arg_RecvMsgStream,
                                              IRAISIKYUKBNNO);
      //半角ブランクの削除
      wm_DataSikyuKbn := TrimRight(wm_DataSikyuKbn);
      //電文：至急現像区分の取得
      wm_DataGenzoKbn := '';
      wm_DataGenzoKbn := func_GetStringStream(arg_System, wg_Kind,
                                              arg_RecvMsgStream,
                                              IRAIGENZOUKBNNO);
      //半角ブランクの削除
      wm_DataGenzoKbn := TrimRight(wm_DataGenzoKbn);
      //電文：予約区分の取得
      wm_DataYoyakuKbn := '';
      wm_DataYoyakuKbn := func_GetStringStream(arg_System, wg_Kind,
                                               arg_RecvMsgStream,
                                               IRAIYOYAKUKBNNO);
      //半角ブランクの削除
      wm_DataYoyakuKbn := TrimRight(wm_DataYoyakuKbn);
      //電文：読影区分の取得
      wm_DataDokueiKbn := '';
      wm_DataDokueiKbn := func_GetStringStream(arg_System, wg_Kind,
                                               arg_RecvMsgStream,
                                               IRAIDOKUEIKBNNO);
      //半角ブランクの削除
      wm_DataDokueiKbn := TrimRight(wm_DataDokueiKbn);
      //電文：区分６の取得
      wm_DataKbn6 := '';
      wm_DataKbn6 := func_GetStringStream(arg_System, wg_Kind,
                                          arg_RecvMsgStream, IRAIKBN6NO);
      //半角ブランクの削除
      wm_DataKbn6 := TrimRight(wm_DataKbn6);
      //電文：区分７の取得
      wm_DataKbn7 := '';
      wm_DataKbn7 := func_GetStringStream(arg_System, wg_Kind,
                                          arg_RecvMsgStream, IRAIKBN7NO);
      //半角ブランクの削除
      wm_DataKbn7 := TrimRight(wm_DataKbn7);
      {
      //電文：保険コード１の取得
      wm_DataHKCode1 := '';
      wm_DataHKCode1 := func_GetStringStream(arg_System, wg_Kind,
                                             arg_RecvMsgStream, IRAIHKCODE1NO);
      //半角ブランクの削除
      wm_DataHKCode1 := TrimRight(wm_DataHKCode1);
      //電文：保険コード２の取得
      wm_DataHKCode2 := '';
      wm_DataHKCode2 := func_GetStringStream(arg_System, wg_Kind,
                                             arg_RecvMsgStream, IRAIHKCODE2NO);
      //半角ブランクの削除
      wm_DataHKCode2 := TrimRight(wm_DataHKCode2);
      //電文：保険コード３の取得
      wm_DataHKCode3 := '';
      wm_DataHKCode3 := func_GetStringStream(arg_System, wg_Kind,
                                             arg_RecvMsgStream, IRAIHKCODE3NO);
      //半角ブランクの削除
      wm_DataHKCode3 := TrimRight(wm_DataHKCode3);
      //電文：保険コード４の取得
      wm_DataHKCode4 := '';
      wm_DataHKCode4 := func_GetStringStream(arg_System, wg_Kind,
                                             arg_RecvMsgStream, IRAIHKCODE4NO);
      //半角ブランクの削除
      wm_DataHKCode4 := TrimRight(wm_DataHKCode4);
      //電文：保険コード５の取得
      wm_DataHKCode5 := '';
      wm_DataHKCode5 := func_GetStringStream(arg_System, wg_Kind,
                                             arg_RecvMsgStream, IRAIHKCODE5NO);
      //半角ブランクの削除
      wm_DataHKCode5 := TrimRight(wm_DataHKCode5);
      }
      //電文：依頼年月日の取得
      wm_DataUpDateDate := '';
      wm_DataUpDateDate := func_GetStringStream(arg_System, wg_Kind,
                                                arg_RecvMsgStream,
                                                IRAIUPDATEDATENO);
      //半角ブランクの削除
      wm_DataUpDateDate := TrimRight(wm_DataUpDateDate);
      //電文：グループ数の取得
      wm_DataGroupCount := '';
      wm_DataGroupCount := func_GetStringStream(arg_System, wg_Kind,
                                                arg_RecvMsgStream,
                                                IRAIGROUPCOUNTNO);
      //半角ブランクの削除
      wm_DataGroupCount := TrimRight(wm_DataGroupCount);
      {
      //電文：オーダコメント長の取得
      wm_DataOrderComLen := '';
      wm_DataOrderComLen := func_GetStringStream(arg_System, wg_Kind,
                                                 arg_RecvMsgStream,
                                                 IRAIORDERCOMLENNO);
      //半角ブランクの削除
      wm_DataOrderComLen := TrimRight(wm_DataOrderComLen);
      }
      //初期化
      wm_Offset := 0;
      //検査目的長までのオフセットを取得
      w_StremField := func_FindMsgField(arg_System, wg_Kind, IRAIMOKUTEKILENNO);
      //オフセットを設定
      wm_Offset := w_StremField.offset;
      //項目コード開始オフセット位置
      wm_ComOffset := wm_Offset;
      //電文：検査目的長の取得
      wm_DataMokutekiComLen := '';
      wm_DataMokutekiComLen := func_GetStringStream3(arg_System, wg_Kind,
                                                     arg_RecvMsgStream,
                                                     wm_ComOffset,
                                                     IRAIMOKUTEKILENLEN);
      //半角ブランクの削除
      wm_DataMokutekiComLen := TrimRight(wm_DataMokutekiComLen);
      //オフセット位置の移動
      wm_ComOffset := wm_ComOffset + IRAIMOKUTEKILENLEN;
      //電文：検査目的の取得
      wm_DataMokutekiCom := '';
      wm_DataMokutekiCom := func_GetStringStream3(arg_System, wg_Kind,
                                                  arg_RecvMsgStream,
                                                  wm_ComOffset,
                                         StrToIntDef(wm_DataMokutekiComLen, 0));
      //半角ブランクの削除
      wm_DataMokutekiCom := TrimRight(wm_DataMokutekiCom);
      //全角ブランクの削除
      wm_DataMokutekiCom := func_MBTrimRight(wm_DataMokutekiCom);
      //オフセット位置の移動
      wm_ComOffset := wm_ComOffset + StrToIntDef(wm_DataMokutekiComLen, 0);
      //電文：特別指示長の取得
      wm_DataSijiComLen := '';
      wm_DataSijiComLen := func_GetStringStream3(arg_System, wg_Kind,
                                                 arg_RecvMsgStream,
                                                 wm_ComOffset, IRAISIJILENLEN);
      //半角ブランクの削除
      wm_DataSijiComLen := TrimRight(wm_DataSijiComLen);
      //オフセット位置の移動
      wm_ComOffset := wm_ComOffset + IRAISIJILENLEN;
      //電文：特別指示の取得
      wm_DataSijiCom := '';
      wm_DataSijiCom := func_GetStringStream3(arg_System, wg_Kind,
                                              arg_RecvMsgStream, wm_ComOffset,
                                             StrToIntDef(wm_DataSijiComLen, 0));
      //半角ブランクの削除
      wm_DataSijiCom := TrimRight(wm_DataSijiCom);
      //全角ブランクの削除
      wm_DataSijiCom := func_MBTrimRight(wm_DataSijiCom);
      //オフセット位置の移動
      wm_ComOffset := wm_ComOffset + StrToIntDef(wm_DataSijiComLen, 0);
      //電文：その他詳細長の取得
      wm_DataSonotaComLen := '';
      wm_DataSonotaComLen := func_GetStringStream3(arg_System, wg_Kind,
                                                   arg_RecvMsgStream,
                                                   wm_ComOffset,
                                                   IRAISONOTALENLEN);
      //半角ブランクの削除
      wm_DataSonotaComLen := TrimRight(wm_DataSonotaComLen);
      //オフセット位置の移動
      wm_ComOffset := wm_ComOffset + IRAISONOTALENLEN;
      //電文：その他詳細の取得
      wm_DataSonotaCom := '';
      wm_DataSonotaCom := func_GetStringStream3(arg_System, wg_Kind,
                                                arg_RecvMsgStream, wm_ComOffset,
                                           StrToIntDef(wm_DataSonotaComLen, 0));
      //半角ブランクの削除
      wm_DataSonotaCom := TrimRight(wm_DataSonotaCom);
      //全角ブランクの削除
      wm_DataSonotaCom := func_MBTrimRight(wm_DataSonotaCom);
      //オフセット位置の移動
      wm_ComOffset := wm_ComOffset + StrToIntDef(wm_DataSonotaComLen, 0);
      //電文：依頼時病名長の取得
      wm_DataByoumeiComLen := '';
      wm_DataByoumeiComLen := func_GetStringStream3(arg_System, wg_Kind,
                                                    arg_RecvMsgStream,
                                                    wm_ComOffset,
                                                    IRAIBYOUMEILENLEN);
      //半角ブランクの削除
      wm_DataByoumeiComLen := TrimRight(wm_DataByoumeiComLen);
      //オフセット位置の移動
      wm_ComOffset := wm_ComOffset + IRAIBYOUMEILENLEN;
      //電文：依頼時病名の取得
      wm_DataByoumeiCom := '';
      wm_DataByoumeiCom := func_GetStringStream3(arg_System, wg_Kind,
                                                 arg_RecvMsgStream,
                                                 wm_ComOffset,
                                          StrToIntDef(wm_DataByoumeiComLen, 0));
      //半角ブランクの削除
      wm_DataByoumeiCom := TrimRight(wm_DataByoumeiCom);
      //全角ブランクの削除
      wm_DataByoumeiCom := func_MBTrimRight(wm_DataByoumeiCom);
      //オフセット位置の移動
      wm_ComOffset := wm_ComOffset + StrToIntDef(wm_DataByoumeiComLen, 0);
      {
      //電文：読影コメント長の取得
      wm_DataDokueiComLen := '';
      wm_DataDokueiComLen := func_GetStringStream3(arg_System, wg_Kind,
                                                   arg_RecvMsgStream,
                                                   wm_ComOffset,
                                                   IRAIDOKUEICOMLENLEN);
      //半角ブランクの削除
      wm_DataDokueiComLen := TrimRight(wm_DataDokueiComLen);
      //オフセット位置の移動
      wm_ComOffset := wm_ComOffset + IRAIDOKUEICOMLENLEN;
      //電文：依頼時病名の取得
      wm_DataDokueiCom := '';
      wm_DataDokueiCom := func_GetStringStream3(arg_System, wg_Kind,
                                                arg_RecvMsgStream, wm_ComOffset,
                                           StrToIntDef(wm_DataDokueiComLen, 0));
      //半角ブランクの削除
      wm_DataDokueiCom := TrimRight(wm_DataDokueiCom);
      //全角ブランクの削除
      wm_DataDokueiCom := func_MBTrimRight(wm_DataDokueiCom);
      //オフセット位置の移動
      wm_ComOffset := wm_ComOffset + StrToIntDef(wm_DataDokueiComLen, 0);

      //電文：歯式部位の取得
      wm_DataSisikiCom := '';
      wm_DataSisikiCom := func_GetStringStream2(arg_System, wg_Kind,
                                                arg_RecvMsgStream,
                                                IRAISISIKIBUINO, wm_ComOffset);
      //半角ブランクの削除
      wm_DataSisikiCom := TrimRight(wm_DataSisikiCom);
      //全角ブランクの削除
      wm_DataSisikiCom := func_MBTrimRight(wm_DataSisikiCom);
      //歯式部位の長さを取得
      w_StremField := func_FindMsgField(arg_System, wg_Kind, IRAISISIKIBUINO);
      //オフセット位置の移動
      wm_ComOffset := wm_ComOffset + w_StremField.size;
      }
      //初期化
      SetLength(wm_OrderBui,0);
      //グループ数数値化
      wi_GroupCount := StrToIntDef(Trim(wm_DataGroupCount), 0);

      //グループ数分作成
      SetLength(wm_OrderBui, wi_GroupCount);

      for w_Loop_Bui := 0 to wi_GroupCount - 1 do
      begin
        //電文：グループ番号の取得
        wm_OrderBui[w_Loop_Bui].GroupNo := func_GetStringStream2(arg_System,
                                                                 wg_Kind,
                                                              arg_RecvMsgStream,
                                                                 IRAIGROUPNO,
                                                                 wm_ComOffset);
        //半角ブランクの削除
        wm_OrderBui[w_Loop_Bui].GroupNo :=
                                     TrimRight(wm_OrderBui[w_Loop_Bui].GroupNo);
        //グループ番号の長さを取得
        w_StremField := func_FindMsgField(arg_System, wg_Kind, IRAIGROUPNO);
        //オフセット位置の移動
        wm_ComOffset := wm_ComOffset + w_StremField.size;

        //電文：オーダ進捗の取得
        wm_OrderBui[w_Loop_Bui].OrderStatus := func_GetStringStream2(arg_System,
                                                                 wg_Kind,
                                                              arg_RecvMsgStream,
                                                              IRAIORDERSTATUSNO,
                                                                 wm_ComOffset);
        //半角ブランクの削除
        wm_OrderBui[w_Loop_Bui].OrderStatus :=
                                     TrimRight(wm_OrderBui[w_Loop_Bui].OrderStatus);
        //オーダ進捗の長さを取得
        w_StremField := func_FindMsgField(arg_System, wg_Kind,
                                          IRAIORDERSTATUSNO);
        //オフセット位置の移動
        wm_ComOffset := wm_ComOffset + w_StremField.size;

        //電文：会計進捗の取得
        wm_OrderBui[w_Loop_Bui].AccountStatus := func_GetStringStream2(arg_System,
                                                                 wg_Kind,
                                                              arg_RecvMsgStream,
                                                              IRAIACCOUNTSTATUSNO,
                                                                 wm_ComOffset);
        //半角ブランクの削除
        wm_OrderBui[w_Loop_Bui].AccountStatus :=
                                     TrimRight(wm_OrderBui[w_Loop_Bui].AccountStatus);
        //会計進捗の長さを取得
        w_StremField := func_FindMsgField(arg_System, wg_Kind,
                                          IRAIACCOUNTSTATUSNO);
        //オフセット位置の移動
        wm_ComOffset := wm_ComOffset + w_StremField.size;

        //電文：実施日の取得
        wm_OrderBui[w_Loop_Bui].ExDate := func_GetStringStream2(arg_System,
                                                                 wg_Kind,
                                                              arg_RecvMsgStream,
                                                              IRAIORDEREXDATENO,
                                                                 wm_ComOffset);
        //半角ブランクの削除
        wm_OrderBui[w_Loop_Bui].ExDate :=
                                     TrimRight(wm_OrderBui[w_Loop_Bui].ExDate);
        //実施日の長さを取得
        w_StremField := func_FindMsgField(arg_System, wg_Kind,
                                          IRAIORDEREXDATENO);
        //オフセット位置の移動
        wm_ComOffset := wm_ComOffset + w_StremField.size;

        //電文：実施時刻の取得
        wm_OrderBui[w_Loop_Bui].ExTime := func_GetStringStream2(arg_System,
                                                                 wg_Kind,
                                                              arg_RecvMsgStream,
                                                              IRAIORDEREXTIMENO,
                                                                 wm_ComOffset);
        //半角ブランクの削除
        wm_OrderBui[w_Loop_Bui].ExTime :=
                                     TrimRight(wm_OrderBui[w_Loop_Bui].ExTime);
        //実施時刻の長さを取得
        w_StremField := func_FindMsgField(arg_System, wg_Kind,
                                          IRAIORDEREXTIMENO);
        //オフセット位置の移動
        wm_ComOffset := wm_ComOffset + w_StremField.size;

        //電文：項目コードの取得
        wm_OrderBui[w_Loop_Bui].KmkCode := func_GetStringStream2(arg_System,
                                                                 wg_Kind,
                                                              arg_RecvMsgStream,
                                                              IRAIKOUMOKUCODENO,
                                                                 wm_ComOffset);
        //半角ブランクの削除
        wm_OrderBui[w_Loop_Bui].KmkCode :=
                                     TrimRight(wm_OrderBui[w_Loop_Bui].KmkCode);
        //項目コードの長さを取得
        w_StremField := func_FindMsgField(arg_System, wg_Kind,
                                          IRAIKOUMOKUCODENO);
        //オフセット位置の移動
        wm_ComOffset := wm_ComOffset + w_StremField.size;

        //電文：項目名称の取得
        wm_OrderBui[w_Loop_Bui].KmkName := func_GetStringStream2(arg_System,
                                                                 wg_Kind,
                                                              arg_RecvMsgStream,
                                                              IRAIKOUMOKUNAMENO,
                                                                 wm_ComOffset);
        //半角ブランクの削除
        wm_OrderBui[w_Loop_Bui].KmkName :=
                                     TrimRight(wm_OrderBui[w_Loop_Bui].KmkName);
        //全角ブランクの削除
        wm_OrderBui[w_Loop_Bui].KmkName :=
                              func_MBTrimRight(wm_OrderBui[w_Loop_Bui].KmkName);
        //項目名称の長さを取得
        w_StremField := func_FindMsgField(arg_System, wg_Kind,
                                          IRAIKOUMOKUNAMENO);
        //オフセット位置の移動
        wm_ComOffset := wm_ComOffset + w_StremField.size;

        //電文：撮影種コードの取得
        wm_OrderBui[w_Loop_Bui].SatueiCode := func_GetStringStream2(arg_System,
                                                                    wg_Kind,
                                                              arg_RecvMsgStream,
                                                             IRAIORDERSYUCODENO,
                                                                  wm_ComOffset);
        //半角ブランクの削除
        wm_OrderBui[w_Loop_Bui].SatueiCode :=
                                  TrimRight(wm_OrderBui[w_Loop_Bui].SatueiCode);
        //撮影種コードの長さを取得
        w_StremField := func_FindMsgField(arg_System, wg_Kind,
                                          IRAIORDERSYUCODENO);
        //オフセット位置の移動
        wm_ComOffset := wm_ComOffset + w_StremField.size;

        //電文：撮影種名称の取得
        wm_OrderBui[w_Loop_Bui].SatueiName := func_GetStringStream2(arg_System,
                                                                    wg_Kind,
                                                              arg_RecvMsgStream,
                                                             IRAIORDERSYUNAMENO,
                                                                  wm_ComOffset);
        //半角ブランクの削除
        wm_OrderBui[w_Loop_Bui].SatueiName :=
                                  TrimRight(wm_OrderBui[w_Loop_Bui].SatueiName);
        //全角ブランクの削除
        wm_OrderBui[w_Loop_Bui].SatueiName :=
                           func_MBTrimRight(wm_OrderBui[w_Loop_Bui].SatueiName);
        //撮影種名称の長さを取得
        w_StremField := func_FindMsgField(arg_System, wg_Kind,
                                          IRAIORDERSYUNAMENO);
        //オフセット位置の移動
        wm_ComOffset := wm_ComOffset + w_StremField.size;

        //電文：部位コードの取得
        wm_OrderBui[w_Loop_Bui].BuiCode := func_GetStringStream2(arg_System,
                                                                 wg_Kind,
                                                              arg_RecvMsgStream,
                                                                 IRAIBUICODENO,
                                                                 wm_ComOffset);
        //半角ブランクの削除
        wm_OrderBui[w_Loop_Bui].BuiCode :=
                                     TrimRight(wm_OrderBui[w_Loop_Bui].BuiCode);
        //部位コードの長さを取得
        w_StremField := func_FindMsgField(arg_System, wg_Kind, IRAIBUICODENO);
        //オフセット位置の移動
        wm_ComOffset := wm_ComOffset + w_StremField.size;

        //電文：部位名称の取得
        wm_OrderBui[w_Loop_Bui].BuiName := func_GetStringStream2(arg_System,
                                                                 wg_Kind,
                                                              arg_RecvMsgStream,
                                                                 IRAIBUINAMENO,
                                                                 wm_ComOffset);
        //半角ブランクの削除
        wm_OrderBui[w_Loop_Bui].BuiName :=
                                     TrimRight(wm_OrderBui[w_Loop_Bui].BuiName);
        //全角ブランクの削除
        wm_OrderBui[w_Loop_Bui].BuiName :=
                              func_MBTrimRight(wm_OrderBui[w_Loop_Bui].BuiName);
        //部位名称の長さを取得
        w_StremField := func_FindMsgField(arg_System, wg_Kind, IRAIBUINAMENO);
        //オフセット位置の移動
        wm_ComOffset := wm_ComOffset + w_StremField.size;

        //電文：検査室コードの取得
        wm_OrderBui[w_Loop_Bui].KensaRoomCode := func_GetStringStream2(
                                                                     arg_System,
                                                                        wg_Kind,
                                                              arg_RecvMsgStream,
                                                            IRAIKENSAROOMCODENO,
                                                                  wm_ComOffset);
        //半角ブランクの削除
        wm_OrderBui[w_Loop_Bui].KensaRoomCode :=
                               TrimRight(wm_OrderBui[w_Loop_Bui].KensaRoomCode);
        //検査室コードの長さを取得
        w_StremField := func_FindMsgField(arg_System, wg_Kind,
                                          IRAIKENSAROOMCODENO);
        //オフセット位置の移動
        wm_ComOffset := wm_ComOffset + w_StremField.size;

        //電文：検査室名称の取得
        wm_OrderBui[w_Loop_Bui].KensaRoomName := func_GetStringStream2(
                                                                     arg_System,
                                                                        wg_Kind,
                                                              arg_RecvMsgStream,
                                                            IRAIKENSAROOMNAMENO,
                                                                  wm_ComOffset);
        //半角ブランクの削除
        wm_OrderBui[w_Loop_Bui].KensaRoomName :=
                               TrimRight(wm_OrderBui[w_Loop_Bui].KensaRoomName);
        //全角ブランクの削除
        wm_OrderBui[w_Loop_Bui].KensaRoomName :=
                        func_MBTrimRight(wm_OrderBui[w_Loop_Bui].KensaRoomName);
        //検査室名称の長さを取得
        w_StremField := func_FindMsgField(arg_System, wg_Kind,
                                          IRAIKENSAROOMNAMENO);
        //オフセット位置の移動
        wm_ComOffset := wm_ComOffset + w_StremField.size;

        //電文：明細数の取得
        wm_OrderBui[w_Loop_Bui].MeisaiCount := func_GetStringStream2(
                                                                     arg_System,
                                                                        wg_Kind,
                                                              arg_RecvMsgStream,
                                                              IRAIMEISAICOUNTNO,
                                                                  wm_ComOffset);
        //半角ブランクの削除
        wm_OrderBui[w_Loop_Bui].MeisaiCount :=
                                 TrimRight(wm_OrderBui[w_Loop_Bui].MeisaiCount);
        //明細数の長さを取得
        w_StremField := func_FindMsgField(arg_System, wg_Kind,
                                          IRAIMEISAICOUNTNO);
        //オフセット位置の移動
        wm_ComOffset := wm_ComOffset + w_StremField.size;
        //明細数数値化
        wi_MeisaiCount := StrToIntDef(Trim(wm_OrderBui[w_Loop_Bui].MeisaiCount),
                                      0);

        for w_Loop_Meisai := 0 to wi_MeisaiCount - 1 do
        begin
          //電文：レコード区分の取得
          ws_RecKbn := func_GetStringStream2(arg_System, wg_Kind,
                                             arg_RecvMsgStream, IRAIYRECKBNNO,
                                             wm_ComOffset);
          //半角ブランクの削除
          ws_RecKbn := TrimRight(ws_RecKbn);
          //レコード区分の長さを取得
          w_StremField := func_FindMsgField(arg_System, wg_Kind,
                                            IRAIYRECKBNNO);
          //オフセット位置の移動
          wm_ComOffset := wm_ComOffset + w_StremField.size;

          //薬剤・手技・材料・フィルム
          if (ws_RecKbn = CST_RECORD_KBN_20) or
             (ws_RecKbn = CST_RECORD_KBN_30) or
             (ws_RecKbn = CST_RECORD_KBN_50) or
             (ws_RecKbn = CST_RECORD_KBN_57) then
          begin
            //格納場所作成
            SetLength(wm_OrderBui[w_Loop_Bui].Yakuzai,
                      Length(wm_OrderBui[w_Loop_Bui].Yakuzai) + 1);
            //格納位置指定
            wi_Index := Length(wm_OrderBui[w_Loop_Bui].Yakuzai) - 1;
            //電文：レコード区分の取得
            wm_OrderBui[w_Loop_Bui].Yakuzai[wi_Index].RecKbn := ws_RecKbn;

            //電文：項目コードの取得
            wm_OrderBui[w_Loop_Bui].Yakuzai[wi_Index].KmkCode :=
              func_GetStringStream2(arg_System, wg_Kind, arg_RecvMsgStream,
                                    IRAIYKMKCODENO, wm_ComOffset);
            //半角ブランクの削除
            wm_OrderBui[w_Loop_Bui].Yakuzai[wi_Index].KmkCode :=
                   TrimRight(wm_OrderBui[w_Loop_Bui].Yakuzai[wi_Index].KmkCode);
            //項目コードの長さを取得
            w_StremField := func_FindMsgField(arg_System, wg_Kind,
                                              IRAIYKMKCODENO);
            //オフセット位置の移動
            wm_ComOffset := wm_ComOffset + w_StremField.size;

            //電文：項目名称の取得
            wm_OrderBui[w_Loop_Bui].Yakuzai[wi_Index].KmkName :=
              func_GetStringStream2(arg_System, wg_Kind, arg_RecvMsgStream,
                                    IRAIYKMKNAMENO, wm_ComOffset);
            //半角ブランクの削除
            wm_OrderBui[w_Loop_Bui].Yakuzai[wi_Index].KmkName :=
                   TrimRight(wm_OrderBui[w_Loop_Bui].Yakuzai[wi_Index].KmkName);
            //全角ブランクの削除
            wm_OrderBui[w_Loop_Bui].Yakuzai[wi_Index].KmkName :=
                   func_MBTrimRight(wm_OrderBui[w_Loop_Bui].Yakuzai[wi_Index].KmkName);
            //項目コードの長さを取得
            w_StremField := func_FindMsgField(arg_System, wg_Kind,
                                              IRAIYKMKNAMENO);
            //オフセット位置の移動
            wm_ComOffset := wm_ComOffset + w_StremField.size;


            //電文：使用量の取得
            wm_OrderBui[w_Loop_Bui].Yakuzai[wi_Index].Use :=
              func_GetStringStream2(arg_System, wg_Kind, arg_RecvMsgStream,
                                    IRAIYUSENO, wm_ComOffset);
            //半角ブランクの削除
            wm_OrderBui[w_Loop_Bui].Yakuzai[wi_Index].Use :=
                       TrimRight(wm_OrderBui[w_Loop_Bui].Yakuzai[wi_Index].Use);
            //使用量の長さを取得
            w_StremField := func_FindMsgField(arg_System, wg_Kind,
                                              IRAIYUSENO);
            //オフセット位置の移動
            wm_ComOffset := wm_ComOffset + w_StremField.size;

            //電文：分割数の取得
            wm_OrderBui[w_Loop_Bui].Yakuzai[wi_Index].Bunkatu :=
              func_GetStringStream2(arg_System, wg_Kind, arg_RecvMsgStream,
                                    IRAIYBUNKATUNO, wm_ComOffset);
            //半角ブランクの削除
            wm_OrderBui[w_Loop_Bui].Yakuzai[wi_Index].Bunkatu :=
                   TrimRight(wm_OrderBui[w_Loop_Bui].Yakuzai[wi_Index].Bunkatu);
            //分割数の長さを取得
            w_StremField := func_FindMsgField(arg_System, wg_Kind,
                                              IRAIYBUNKATUNO);
            //オフセット位置の移動
            wm_ComOffset := wm_ComOffset + w_StremField.size;

            //電文：予備の取得
            wm_OrderBui[w_Loop_Bui].Yakuzai[wi_Index].Yobi :=
              func_GetStringStream2(arg_System, wg_Kind, arg_RecvMsgStream,
                                    IRAIYYOBINO, wm_ComOffset);
            //半角ブランクの削除
            wm_OrderBui[w_Loop_Bui].Yakuzai[wi_Index].Yobi :=
                      TrimRight(wm_OrderBui[w_Loop_Bui].Yakuzai[wi_Index].Yobi);
            //予備の長さを取得
            w_StremField := func_FindMsgField(arg_System, wg_Kind,
                                              IRAIYYOBINO);
            //オフセット位置の移動
            wm_ComOffset := wm_ComOffset + w_StremField.size;
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
            //格納場所作成
            SetLength(wm_OrderBui[w_Loop_Bui].Comment,
                      Length(wm_OrderBui[w_Loop_Bui].Comment) + 1);
            //格納位置指定
            wi_Index := Length(wm_OrderBui[w_Loop_Bui].Comment) - 1;
            //電文：レコード区分の取得
            wm_OrderBui[w_Loop_Bui].Comment[wi_Index].RecKbn := ws_RecKbn;

            //電文：項目コードの取得
            wm_OrderBui[w_Loop_Bui].Comment[wi_Index].KmkCode :=
              func_GetStringStream2(arg_System, wg_Kind, arg_RecvMsgStream,
                                    IRAICKMKCODENO, wm_ComOffset);
            //半角ブランクの削除
            wm_OrderBui[w_Loop_Bui].Comment[wi_Index].KmkCode :=
                   TrimRight(wm_OrderBui[w_Loop_Bui].Comment[wi_Index].KmkCode);
            //項目コードの長さを取得
            w_StremField := func_FindMsgField(arg_System, wg_Kind,
                                              IRAICKMKCODENO);
            //オフセット位置の移動
            wm_ComOffset := wm_ComOffset + w_StremField.size;

            //電文：項目名称の取得
            wm_OrderBui[w_Loop_Bui].Comment[wi_Index].KmkName :=
              func_GetStringStream2(arg_System, wg_Kind, arg_RecvMsgStream,
                                    IRAICKMKNAMENO, wm_ComOffset);
            //半角ブランクの削除
            wm_OrderBui[w_Loop_Bui].Comment[wi_Index].KmkName :=
                   TrimRight(wm_OrderBui[w_Loop_Bui].Comment[wi_Index].KmkName);
            //全角ブランクの削除
            wm_OrderBui[w_Loop_Bui].Comment[wi_Index].KmkName :=
            func_MBTrimRight(wm_OrderBui[w_Loop_Bui].Comment[wi_Index].KmkName);
            //項目名称の長さを取得
            w_StremField := func_FindMsgField(arg_System, wg_Kind,
                                              IRAICKMKNAMENO);
            //オフセット位置の移動
            wm_ComOffset := wm_ComOffset + w_StremField.size;

            //電文：予備の取得
            wm_OrderBui[w_Loop_Bui].Comment[wi_Index].Yobi :=
              func_GetStringStream2(arg_System, wg_Kind, arg_RecvMsgStream,
                                    IRAICYOBINO, wm_ComOffset);
            //半角ブランクの削除
            wm_OrderBui[w_Loop_Bui].Comment[wi_Index].Yobi :=
                      TrimRight(wm_OrderBui[w_Loop_Bui].Comment[wi_Index].Yobi);
            //予備の長さを取得
            w_StremField := func_FindMsgField(arg_System, wg_Kind, IRAICYOBINO);
            //オフセット位置の移動
            wm_ComOffset := wm_ComOffset + w_StremField.size;
          end
          //シェーマ
          else if ws_RecKbn = CST_RECORD_KBN_95 then
          begin
            //シェーマ有り
            wg_ShmFlg := '1';
            //格納場所作成
            SetLength(wm_OrderBui[w_Loop_Bui].Schema,
                      Length(wm_OrderBui[w_Loop_Bui].Schema) + 1);
            //格納位置指定
            wi_Index := Length(wm_OrderBui[w_Loop_Bui].Schema) - 1;
            //電文：レコード区分の取得
            wm_OrderBui[w_Loop_Bui].Schema[wi_Index].RecKbn := ws_RecKbn;

            //電文：シェーマ名の取得
            wm_OrderBui[w_Loop_Bui].Schema[wi_Index].SchemaName :=
              func_GetStringStream2(arg_System, wg_Kind, arg_RecvMsgStream,
                                    IRAISNAMENO, wm_ComOffset);
            //半角ブランクの削除
            wm_OrderBui[w_Loop_Bui].Schema[wi_Index].SchemaName :=
                 TrimRight(wm_OrderBui[w_Loop_Bui].Schema[wi_Index].SchemaName);
            //全角ブランクの削除
            wm_OrderBui[w_Loop_Bui].Schema[wi_Index].SchemaName :=
              func_MBTrimRight(
                           wm_OrderBui[w_Loop_Bui].Schema[wi_Index].SchemaName);
            //シェーマ情報の長さを取得
            w_StremField := func_FindMsgField(arg_System, wg_Kind, IRAISNAMENO);
            //オフセット位置の移動
            wm_ComOffset := wm_ComOffset + w_StremField.size;

            //電文：シェーマ情報の取得
            wm_OrderBui[w_Loop_Bui].Schema[wi_Index].SchemaInfo :=
              func_GetStringStream2(arg_System, wg_Kind, arg_RecvMsgStream,
                                    IRAISINFONO, wm_ComOffset);
            //半角ブランクの削除
            wm_OrderBui[w_Loop_Bui].Schema[wi_Index].SchemaInfo :=
                 TrimRight(wm_OrderBui[w_Loop_Bui].Schema[wi_Index].SchemaInfo);
            //全角ブランクの削除
            wm_OrderBui[w_Loop_Bui].Schema[wi_Index].SchemaInfo :=
              func_MBTrimRight(
                           wm_OrderBui[w_Loop_Bui].Schema[wi_Index].SchemaInfo);
            //シェーマ情報の長さを取得
            w_StremField := func_FindMsgField(arg_System, wg_Kind, IRAISINFONO);
            //オフセット位置の移動
            wm_ComOffset := wm_ComOffset + w_StremField.size;

            //電文：シェーマ予備の取得
            wm_OrderBui[w_Loop_Bui].Schema[wi_Index].SchemaYobi :=
              func_GetStringStream2(arg_System, wg_Kind, arg_RecvMsgStream,
                                    IRAISYOBINO, wm_ComOffset);
            //半角ブランクの削除
            wm_OrderBui[w_Loop_Bui].Schema[wi_Index].SchemaYobi :=
                 TrimRight(wm_OrderBui[w_Loop_Bui].Schema[wi_Index].SchemaYobi);
            //全角ブランクの削除
            wm_OrderBui[w_Loop_Bui].Schema[wi_Index].SchemaYobi :=
              func_MBTrimRight(
                           wm_OrderBui[w_Loop_Bui].Schema[wi_Index].SchemaYobi);
            //シェーマ情報の長さを取得
            w_StremField := func_FindMsgField(arg_System, wg_Kind, IRAISYOBINO);
            //オフセット位置の移動
            wm_ComOffset := wm_ComOffset + w_StremField.size;
          end;
        end;
      end;
    end
    //患者情報更新・患者死亡退院情報
    else if (wm_HeaderCommand = CST_COMMAND_KANJAUP) or
            (wm_HeaderCommand = CST_COMMAND_KANJADEL) then
    begin
      //患者情報更新・患者死亡退院情報
      wg_Kind := G_MSGKIND_KANJA;
      //電文：病院コードの取得
      wm_DataHospCode := '';
      wm_DataHospCode := func_GetStringStream(arg_System, wg_Kind,
                                              arg_RecvMsgStream,
                                              KANJAHOSPCODENO);
      //半角ブランクの削除
      wm_DataHospCode := TrimRight(wm_DataHospCode);
      //電文：患者番号の取得
      wm_KanjaPatientID := '';
      wm_KanjaPatientID := func_GetStringStream(arg_System, wg_Kind,
                                                arg_RecvMsgStream, KANJAPIDNO);
      //半角ブランクの削除
      wm_KanjaPatientID := TrimRight(wm_KanjaPatientID);
      //電文：患者氏名の取得
      wm_KanjaPatientName := '';
      wm_KanjaPatientName := func_GetStringStream(arg_System, wg_Kind,
                                                  arg_RecvMsgStream,
                                                  KANJAPNAMENO);
      //半角ブランクの削除
      wm_KanjaPatientName := TrimRight(wm_KanjaPatientName);
      //全角ブランクの削除
      wm_KanjaPatientName := func_MBTrimRight(wm_KanjaPatientName);
      //電文：患者カナ氏名の取得
      wm_KanjaPatientKana := '';
      wm_KanjaPatientKana := func_GetStringStream(arg_System, wg_Kind,
                                                  arg_RecvMsgStream,
                                                  KANJAPKANANO);
      //半角ブランクの削除
      wm_KanjaPatientKana := TrimRight(wm_KanjaPatientKana);
      //電文：性別の取得
      wm_KanjaSex := '';
      wm_KanjaSex := func_GetStringStream(arg_System, wg_Kind,
                                          arg_RecvMsgStream, KANJASEXNO);
      //半角ブランクの削除
      wm_KanjaSex := TrimRight(wm_KanjaSex);
      //電文：生年月日の取得
      wm_KanjaBirthday := '';
      wm_KanjaBirthday := func_GetStringStream(arg_System, wg_Kind,
                                               arg_RecvMsgStream,
                                               KANJABIRTHDAYNO);
      //半角ブランクの削除
      wm_KanjaBirthday := TrimRight(wm_KanjaBirthday);
      //電文：郵便番号１の取得
      wm_KanjaPostCode1 := '';
      wm_KanjaPostCode1 := func_GetStringStream(arg_System, wg_Kind,
                                                arg_RecvMsgStream,
                                                KANJAPOSTCODE1NO);
      //半角ブランクの削除
      wm_KanjaPostCode1 := TrimRight(wm_KanjaPostCode1);
      //電文：住所１の取得
      wm_KanjaAddress1 := '';
      wm_KanjaAddress1 := func_GetStringStream(arg_System, wg_Kind,
                                               arg_RecvMsgStream,
                                               KANJAADDRESS1NO);
      //半角ブランクの削除
      wm_KanjaAddress1 := TrimRight(wm_KanjaAddress1);
      //全角ブランクの削除
      wm_KanjaAddress1 := func_MBTrimRight(wm_KanjaAddress1);
      //電文：電話番号１の取得
      wm_KanjaTEL1 := '';
      wm_KanjaTEL1 := func_GetStringStream(arg_System, wg_Kind,
                                           arg_RecvMsgStream, KANJATEL1NO);
      //半角ブランクの削除
      wm_KanjaTEL1 := TrimRight(wm_KanjaTEL1);
      //電文：郵便番号２の取得
      wm_KanjaPostCode2 := '';
      wm_KanjaPostCode2 := func_GetStringStream(arg_System, wg_Kind,
                                                arg_RecvMsgStream,
                                                KANJAPOSTCODE2NO);
      //半角ブランクの削除
      wm_KanjaPostCode2 := TrimRight(wm_KanjaPostCode2);
      //電文：住所２の取得
      wm_KanjaAddress2 := '';
      wm_KanjaAddress2 := func_GetStringStream(arg_System, wg_Kind,
                                               arg_RecvMsgStream,
                                               KANJAADDRESS2NO);
      //半角ブランクの削除
      wm_KanjaAddress2 := TrimRight(wm_KanjaAddress2);
      //全角ブランクの削除
      wm_KanjaAddress2 := func_MBTrimRight(wm_KanjaAddress2);
      //電文：電話番号２の取得
      wm_KanjaTEL2 := '';
      wm_KanjaTEL2 := func_GetStringStream(arg_System, wg_Kind,
                                           arg_RecvMsgStream, KANJATEL2NO);
      //半角ブランクの削除
      wm_KanjaTEL2 := TrimRight(wm_KanjaTEL2);
      //電文：病棟コードの取得
      wm_KanjaWardCode := '';
      wm_KanjaWardCode := func_GetStringStream(arg_System, wg_Kind,
                                               arg_RecvMsgStream,
                                               KANJABYOUTOIDNO);
      //半角ブランクの削除
      wm_KanjaWardCode := TrimRight(wm_KanjaWardCode);
      //電文：病棟名称の取得
      wm_KanjaWardName := '';
      wm_KanjaWardName := func_GetStringStream(arg_System, wg_Kind,
                                               arg_RecvMsgStream,
                                               KANJABYOUTONAMENO);
      //半角ブランクの削除
      wm_KanjaWardName := TrimRight(wm_KanjaWardName);
      //全角ブランクの削除
      wm_KanjaWardName := func_MBTrimRight(wm_KanjaWardName);
      //電文：病室コードの取得
      wm_KanjaSickroomCode := '';
      wm_KanjaSickroomCode := func_GetStringStream(arg_System, wg_Kind,
                                                   arg_RecvMsgStream,
                                                   KANJAROOMIDNO);
      //半角ブランクの削除
      wm_KanjaSickroomCode := TrimRight(wm_KanjaSickroomCode);
      {
      //電文：病室名称の取得
      wm_KanjaSickroomName := '';
      wm_KanjaSickroomName := func_GetStringStream(arg_System, wg_Kind,
                                                   arg_RecvMsgStream,
                                                   KANJAROOMNAMENO);
      //半角ブランクの削除
      wm_KanjaSickroomName := TrimRight(wm_KanjaSickroomName);
      //全角ブランクの削除
      wm_KanjaSickroomName := func_MBTrimRight(wm_KanjaSickroomName);
      }
      //電文：看護区分の取得
      wm_KanjaKangoKbn := '';
      wm_KanjaKangoKbn := func_GetStringStream(arg_System, wg_Kind,
                                               arg_RecvMsgStream,
                                               KANJAKANGOKBNNO);
      //半角ブランクの削除
      wm_KanjaKangoKbn := TrimRight(wm_KanjaKangoKbn);
      //電文：患者区分の取得
      wm_KanjaPatientKbn := '';
      wm_KanjaPatientKbn := func_GetStringStream(arg_System, wg_Kind,
                                                 arg_RecvMsgStream,
                                                 KANJAKANJAKBNNO);
      //半角ブランクの削除
      wm_KanjaPatientKbn := TrimRight(wm_KanjaPatientKbn);
      //電文：救護区分の取得
      wm_KanjaKyugoKbn := '';
      wm_KanjaKyugoKbn := func_GetStringStream(arg_System, wg_Kind,
                                               arg_RecvMsgStream,
                                               KANJAKYUGOKBNNO);
      //半角ブランクの削除
      wm_KanjaKyugoKbn := TrimRight(wm_KanjaKyugoKbn);
      //電文：予備区分の取得
      wm_KanjaYobiKbn := '';
      wm_KanjaYobiKbn := func_GetStringStream(arg_System, wg_Kind,
                                              arg_RecvMsgStream,
                                              KANJAYOBIKBNNO);
      //半角ブランクの削除
      wm_KanjaYobiKbn := TrimRight(wm_KanjaYobiKbn);
      //電文：障害情報の取得
      wm_KanjaSyougaiInfo := '';
      wm_KanjaSyougaiInfo := func_GetStringStream(arg_System, wg_Kind,
                                                  arg_RecvMsgStream,
                                                  KANJASYOGAINO);
      //半角ブランクの削除
      wm_KanjaSyougaiInfo := TrimRight(wm_KanjaSyougaiInfo);
      //電文：身長の取得
      wm_KanjaHeight := '';
      wm_KanjaHeight := func_GetStringStream(arg_System, wg_Kind,
                                             arg_RecvMsgStream, KANJAHEIGHTNO);
      //半角ブランクの削除
      wm_KanjaHeight := TrimRight(wm_KanjaHeight);
      //電文：体重の取得
      wm_KanjaWeight := '';
      wm_KanjaWeight := func_GetStringStream(arg_System, wg_Kind,
                                             arg_RecvMsgStream, KANJAWEIGHTNO);
      //半角ブランクの削除
      wm_KanjaWeight := TrimRight(wm_KanjaWeight);
      //電文：血液型ABOの取得
      wm_KanjaBloodAB := '';
      wm_KanjaBloodAB := func_GetStringStream(arg_System, wg_Kind,
                                              arg_RecvMsgStream,
                                              KANJABLOODABONO);
      //半角ブランクの削除
      wm_KanjaBloodAB := TrimRight(wm_KanjaBloodAB);
      //電文：血液型RHの取得
      wm_KanjaBloodRH := '';
      wm_KanjaBloodRH := func_GetStringStream(arg_System, wg_Kind,
                                              arg_RecvMsgStream,
                                              KANJABLOODRHNO);
      //半角ブランクの削除
      wm_KanjaBloodRH := TrimRight(wm_KanjaBloodRH);
      //電文：感染情報の取得
      wm_KanjaKansenInfo := '';
      wm_KanjaKansenInfo := func_GetStringStream(arg_System, wg_Kind,
                                                 arg_RecvMsgStream,
                                                 KANJAKANSENNO);
      //電文：感染コメントの取得
      wm_KanjaKansenCom := '';
      wm_KanjaKansenCom := func_GetStringStream(arg_System, wg_Kind,
                                                arg_RecvMsgStream,
                                                KANJAKANSENCOMNO);
      //半角ブランクの削除
      wm_KanjaKansenCom := TrimRight(wm_KanjaKansenCom);
      //全角ブランクの削除
      wm_KanjaKansenCom := func_MBTrimRight(wm_KanjaKansenCom);
      //電文：禁忌情報の取得
      wm_KanjaKinkiInfo := '';
      wm_KanjaKinkiInfo := func_GetStringStream(arg_System, wg_Kind,
                                                arg_RecvMsgStream,
                                                KANJAKINKINO);
      //電文：禁忌コメントの取得
      wm_KanjaKinkiCom := '';
      wm_KanjaKinkiCom := func_GetStringStream(arg_System, wg_Kind,
                                               arg_RecvMsgStream,
                                               KANJAKINKICOMNO);
      //半角ブランクの削除
      wm_KanjaKinkiCom := TrimRight(wm_KanjaKinkiCom);
      //全角ブランクの削除
      wm_KanjaKinkiCom := func_MBTrimRight(wm_KanjaKinkiCom);
      //電文：妊娠日の取得
      wm_KanjaNinsinDate := '';
      wm_KanjaNinsinDate := func_GetStringStream(arg_System, wg_Kind,
                                                 arg_RecvMsgStream,
                                                 KANJANINSINNO);
      //半角ブランクの削除
      wm_KanjaNinsinDate := TrimRight(wm_KanjaNinsinDate);
      //電文：死亡退院日の取得
      wm_KanjaDeathDate := '';
      wm_KanjaDeathDate := func_GetStringStream(arg_System, wg_Kind,
                                                arg_RecvMsgStream,
                                                KANJADETHDATENO);
      //半角ブランクの削除
      wm_KanjaDeathDate := TrimRight(wm_KanjaDeathDate);
    end
    //オーダキャンセル
    else if wm_HeaderCommand = CST_COMMAND_ORDERCANCEL then
    begin
      //オーダキャンセル
      wg_Kind := G_MSGKIND_CANCEL;
      //電文：病院コードの取得
      wm_DataHospCode := '';
      wm_DataHospCode := func_GetStringStream(arg_System, wg_Kind,
                                              arg_RecvMsgStream,
                                              IRAICHOSPCODENO);
      //半角ブランクの削除
      wm_DataHospCode := TrimRight(wm_DataHospCode);

      //電文：患者番号の取得
      wm_KanjaPatientID := '';
      wm_KanjaPatientID := func_GetStringStream(arg_System, wg_Kind,
                                                arg_RecvMsgStream, IRAICPIDNO);
      //半角ブランクの削除
      wm_KanjaPatientID := TrimRight(wm_KanjaPatientID);

      //電文：オーダ番号の取得
      wm_DataOrdeNo := '';
      wm_DataOrdeNo := func_GetStringStream(arg_System, wg_Kind,
                                            arg_RecvMsgStream, IRAICORDERNO);
      //半角ブランクの削除
      wm_DataOrdeNo := TrimRight(wm_DataOrdeNo);

      //電文：開始日の取得
      wm_DataStartDate := '';
      wm_DataStartDate := func_GetStringStream(arg_System, wg_Kind,
                                               arg_RecvMsgStream,
                                               IRAICSTARTDATENO);
      //半角ブランクの削除
      wm_DataStartDate := TrimRight(wm_DataStartDate);

      //電文：開始時間の取得
      wm_DataStartTime := '';
      wm_DataStartTime := func_GetStringStream(arg_System, wg_Kind,
                                               arg_RecvMsgStream,
                                               IRAICSTARTTIMENO);
      //半角ブランクの削除
      wm_DataStartTime := TrimRight(wm_DataStartTime);

      //電文：操作者コードの取得
      wm_CancelOpeUserCode := '';
      wm_CancelOpeUserCode := func_GetStringStream(arg_System, wg_Kind,
                                                   arg_RecvMsgStream,
                                                   IRAICOPERATCODENO);
      //半角ブランクの削除
      wm_CancelOpeUserCode := TrimRight(wm_CancelOpeUserCode);

      //電文：操作者コードの取得
      wm_CancelOpeUserName := '';
      wm_CancelOpeUserName := func_GetStringStream(arg_System, wg_Kind,
                                                   arg_RecvMsgStream,
                                                   IRAICOPERATNAMENO);
      //半角ブランクの削除
      wm_CancelOpeUserName := TrimRight(wm_CancelOpeUserName);
    end;

    //正常終了
    Result := True;
    //処理終了
    Exit;
  except
    on E:exception do
    begin
      //ログ文字列作成
      proc_StrConcat(arg_LogBuffer,'電文データ取得NG「例外発生'+E.Message+'」');
      //戻り値
      Result := False;
      //処理終了
      Exit;
    end;
  end;
end;
//==============================================================================
//Main系DBチェック処理↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓
//==============================================================================
{******************************************************************************}
{                                                                              }
{    関数名 func_CheckKanjaHisID ：患者情報のマスタチェック                    }
{                                                                              }
{  返り値型 Boolean型                                                          }
{           True：成功                                                         }
{           False：失敗                                                        }
{                                                                              }
{      引数 型             名前              タイプ  説明                      }
{           String         arg_Flg             IN    確認DB先                  }
{           String         arg_DLog          IN/OUT  ログ内容                  }
{                                                                              }
{      例外 なし                                                               }
{                                                                              }
{  機能説明 患者情報の内容をマスタと比較して正否を確認する。                   }
{                                                                              }
{******************************************************************************}
function  TDb_RisSvr_Irai.func_CheckKanjaHisID(    arg_Flg  : String;
                                               var arg_DLog : String
                                               ):Boolean;
var
  res : Boolean;
  wi_Loop: Integer;
begin
  //初期復帰値
  Result := True;

  //オーダ情報・患者情報の場合
  if (wg_Kind = G_MSGKIND_IRAI) or
     (wg_Kind = G_MSGKIND_KANJA) then
  begin

    if (wm_KanjaSex <> CST_SEX_0_NAME) and
       (wm_KanjaSex <> CST_SEX_1_NAME) and
       (wm_KanjaSex <> CST_SEX_9P_NAME) then
    begin
      //患者 性別
      if CST_SEX_0 = wm_KanjaSex then
      begin
        //男
        wm_KanjaSex := CST_SEX_0_NAME;
      end
      else if CST_SEX_1 = wm_KanjaSex then
      begin
        //女
        wm_KanjaSex := CST_SEX_1_NAME;
      end
      else
      begin
        //不明
        wm_KanjaSex := CST_SEX_9P_NAME;
      end;
    end;
    //診断
    if arg_Flg = CST_RISTYPE then
    begin
      //病棟コードがある場合
      if wm_KanjaWardCode <> '' then
      begin
        //患者 入院中病棟
        res := func_CheckID('ByoutouMaster',
                            '( Byoutou_ID = ''' + wm_KanjaWardCode + ''' )');
        //異常の場合
        if not res then
        begin
          //ログ文字列作成
          proc_StrConcat(arg_DLog,'患者病棟ID = ' + wm_KanjaWardCode);
          //戻り値
          Result := False;
        end;
      end;
      //病室コードがある場合
      if wm_KanjaSickroomCode <> '' then
      begin
        //患者 入院中病室
        res := func_CheckID('BYOUSITUMASTER',
                            '(BYOUSITU_ID = ''' + wm_KanjaSickroomCode + ''') ');
        //異常の場合
        if not res then
        begin
          //ログ文字列作成
          proc_StrConcat(arg_DLog,'患者病室ID = ' + wm_KanjaSickroomCode);
          //戻り値
          Result := False;
        end;
      end;
    (*
    end
    else
    begin
      //病棟コードがある場合
      if wm_KanjaWardCode <> '' then
      begin
        //患者 入院中病棟
        res := func_RTCheckID(g_RRISUser + '.ByoutouMaster',
                            '( Byoutou_ID = ''' + wm_KanjaWardCode + ''' )');
        //異常の場合
        if not res then
        begin
          //ログ文字列作成
          proc_StrConcat(arg_DLog,'患者病棟ID = ' + wm_KanjaWardCode);
          //戻り値
          Result := False;
        end;
      end;
      //病室コードがある場合
      if wm_KanjaSickroomCode <> '' then
      begin
        //患者 入院中病室
        res := func_RTCheckID(g_RRISUser + '.BYOUSITUMASTER',
                            '(BYOUSITU_ID = ''' + wm_KanjaSickroomCode + ''') ');
        //異常の場合
        if not res then
        begin
          //ログ文字列作成
          proc_StrConcat(arg_DLog,'患者病室ID = ' + wm_KanjaSickroomCode);
          //戻り値
          Result := False;
        end;
      end;
    *)
    end;
    //看護区分がある場合
    if wm_KanjaKangoKbn <> '' then
    begin
      //初期化
      res := False;
      //iniファイル設定分
      for wi_Loop := 0 to g_KangoKbn_List.Count - 1 do
      begin
        //iniファイルにデータがある場合
        if wm_KanjaKangoKbn = g_KangoKbn_List[wi_Loop] then
          //正常
          res := True;
      end;
      //異常の場合
      if not res then
      begin
        //ログ文字列作成
        proc_StrConcat(arg_DLog,'看護区分 = ' + wm_KanjaKangoKbn);
        //戻り値
        Result := False;
      end;
    end;
    //患者区分がある場合
    if wm_KanjaPatientKbn <> '' then
    begin
      //初期化
      res := False;
      //iniファイル設定分
      for wi_Loop := 0 to g_KanjaKbn_List.Count - 1 do
      begin
        //iniファイルにデータがある場合
        if wm_KanjaPatientKbn = g_KanjaKbn_List[wi_Loop] then
          //正常
          res := True;
      end;
      //異常の場合
      if not res then
      begin
        //ログ文字列作成
        proc_StrConcat(arg_DLog,'患者区分 = ' + wm_KanjaPatientKbn);
        //戻り値
        Result := False;
      end;
    end;
    //救護区分がある場合
    if wm_KanjaKyugoKbn <> '' then
    begin
      //初期化
      res := False;
      //iniファイル設定分
      for wi_Loop := 0 to g_KyuugoKbn_List.Count - 1 do
      begin
        //iniファイルにデータがある場合
        if wm_KanjaKyugoKbn = g_KyuugoKbn_List[wi_Loop] then
          //正常
          res := True;
      end;
      //異常の場合
      if not res then
      begin
        //ログ文字列作成
        proc_StrConcat(arg_DLog,'救護区分 = ' + wm_KanjaKyugoKbn);
        //戻り値
        Result := False;
      end;
    end;
    //血液型ABOがある場合
    if wm_KanjaBloodAB <> '' then
    begin
      //初期化
      res := False;
      //iniファイル設定分
      for wi_Loop := 0 to g_ABOCode_List.Count - 1 do
      begin
        //iniファイルにデータがある場合
        if wm_KanjaBloodAB = g_ABOCode_List[wi_Loop] then
          //正常
          res := True;
      end;
      //異常の場合
      if not res then
      begin
        //ログ文字列作成
        proc_StrConcat(arg_DLog,'血液型ABO = ' + wm_KanjaBloodAB);
        //戻り値
        Result := False;
      end;
    end;
    //血液型RHがある場合
    if wm_KanjaBloodRH <> '' then
    begin
      //初期化
      res := False;
      //iniファイル設定分
      for wi_Loop := 0 to g_RHCode_List.Count - 1 do
      begin
        //iniファイルにデータがある場合
        if wm_KanjaBloodRH = g_RHCode_List[wi_Loop] then
          //正常
          res := True;
      end;
      //異常の場合
      if not res then
      begin
        //ログ文字列作成
        proc_StrConcat(arg_DLog,'血液型RH = ' + wm_KanjaBloodRH);
        //戻り値
        Result := False;
      end;
    end;
  end;

  //終了
  Exit;
end;
{******************************************************************************}
{                                                                              }
{    関数名 func_CheckID         ：テーブルに指定条件でデータ確認              }
{                                                                              }
{  返り値型 Boolean型                                                          }
{           True：データあり                                                   }
{           False：データ無し                                                  }
{                                                                              }
{      引数 型             名前              タイプ  説明                      }
{           String         arg_TblName         IN    テーブル                  }
{           String         arg_Where           IN    Where句                   }
{                                                                              }
{      例外 なし                                                               }
{                                                                              }
{  機能説明 指定テーブルに指定条件でデータがあるか確認する。                   }
{                                                                              }
{******************************************************************************}
function  TDb_RisSvr_Irai.func_CheckID(arg_TblName : String;
                                       arg_Where   : String
                                       ):Boolean;
var
  w_c :       Integer;
  sqlSelect:  String;
  iRslt:      Integer;
begin
  w_c := 0;
  try
    try
      with FQ_SEL do begin
        //SQL設定
        sqlSelect := '';
        sqlSelect := sqlSelect + 'SELECT COUNT(*) RES FROM ' + arg_TblName + ' ';
        if not func_IsNullStr(arg_Where) then
        begin
          sqlSelect := sqlSelect + 'WHERE ' + arg_Where + ' ';
        end;
        PrepareQuery(sqlSelect);
        //SQL実行
        iRslt:= OpenQuery();
        if iRslt < 0 then begin
          //例外エラー
          Result := False;
          //切断
          wg_DBFlg := False;
          //処理終了
          Exit;
        end;

        if Eof = False then begin
          // 対象データの取得
          w_c := StrToIntDef(GetString('RES'), 0);
        end;
      end;
    except
      //例外エラー
      Result := False;
      //切断
      wg_DBFlg := False;
      //処理終了
      Exit;
    end;
  finally
    //件数ありの場合
    if w_c > 0  then
    begin
      //存在する
      Result := True;
    end
    //件数なしの場合
    else begin
      //存在しない
      Result := False;
    end;
  end;
end;
{******************************************************************************}
{                                                                              }
{    関数名 func_CheckIraiHisID  ：マスタチェック                              }
{                                                                              }
{  返り値型 Boolean型                                                          }
{           True：成功                                                         }
{           False：失敗                                                        }
{                                                                              }
{      引数 型             名前              タイプ  説明                      }
{           String         arg_DLog          IN/OUT  ログ内容                  }
{                                                                              }
{      例外 なし                                                               }
{                                                                              }
{  機能説明 IDのマスタチェックを行う。                                         }
{                                                                              }
{******************************************************************************}
function  TDb_RisSvr_Irai.func_CheckIraiHisID(
                                              var arg_DLog: String
                                              ):Boolean;
var
  res     : Boolean;
  w_i     : Integer;
  wi_Loop : Integer;

  sqlSelect:  String;
  iRslt:      Integer;
begin
  //患者情報の確認を依頼
  Result := func_CheckKanjaHisID(CST_RISTYPE,arg_DLog);

  //オーダ情報・オーダキャンセルの場合
  if (wg_Kind = G_MSGKIND_IRAI) or
     (wg_Kind = G_MSGKIND_CANCEL) then
  begin
    //オーダNoの属性
    if not (func_IsNumberStr(wm_DataOrdeNo))then
    begin
      //ログ文字列作成
      proc_StrConcat(arg_DLog,'オーダNo属性 = ' + wm_DataOrdeNo);
      //戻り値
      Result := False;
    end;
  end;

  //オーダ情報の場合
  if (wg_Kind = G_MSGKIND_IRAI) then
  begin
    // 撮影系画面フラグ
    wm_KensaType01Flg := '';
    // ポータブル画面フラグ
    wm_KensaType02Flg := '';
    // 検査系画面フラグ
    wm_KensaType03Flg := '';
    // 核医学画面フラグ
    wm_KensaType04Flg := '';
    //オーダ 検査種別
    res := func_CheckID('KensaTypeMaster',
                        //'( KensaType_ID = ''' + wm_DataSatueiCode + ''' )');
                        '( KensaType_ID = ''' + wm_RISKensaType + ''' )');
    //異常の場合
    if not res then
    begin
      //ログ文字列作成
      //proc_StrConcat(arg_DLog,'検査種別ID = ' + wm_DataSatueiCode);
      proc_StrConcat(arg_DLog,'検査種別ID = ' + wm_RISKensaType);
      //戻り値
      Result := False;
    end
    else
    begin
      try
        with FQ_SEL do begin
          //SQL設定
          sqlSelect := '';
          sqlSelect := sqlSelect + 'SELECT PICTUREFLAG01, PICTUREFLAG02, PICTUREFLAG03, PICTUREFLAG04 ';
          sqlSelect := sqlSelect + ' FROM KENSATYPEMASTER';
          sqlSelect := sqlSelect + ' WHERE KENSATYPE_ID = :PKENSATYPE_ID';
          PrepareQuery(sqlSelect);
          //パラメータ設定
          SetParam('PKENSATYPE_ID', wm_RISKensaType);
          //SQL実行
          iRslt:= OpenQuery();
          if iRslt < 0 then begin
            //処理終了
            Exit;
          end;

          if Eof = False then begin
            // 対象データの取得
            //
            // 撮影系画面フラグ
            wm_KensaType01Flg := GetString('PICTUREFLAG01');
            // ポータブル画面フラグ
            wm_KensaType02Flg := GetString('PICTUREFLAG02');
            // 検査系画面フラグ
            wm_KensaType03Flg := GetString('PICTUREFLAG03');
            // 核医学画面フラグ
            wm_KensaType04Flg := GetString('PICTUREFLAG04');
            // フラグが設定されていない場合
            if (wm_KensaType01Flg = '') and
               (wm_KensaType02Flg = '') and
               (wm_KensaType03Flg = '') and
               (wm_KensaType04Flg = '') then
            begin
              //ログ文字列作成
              proc_StrConcat(arg_DLog,'検査種別に画面フラグが設定されていません。');
              //戻り値
              Result := False;
            end;
          end;
        end;
      except
      end;
    end;

    //オーダ 伝票入外区分
    //初期化
    res := False;
    //コードチェック
    if (wm_DataInOutKbn = CST_HIS_NYUGAIKBN_N) or
      (wm_DataInOutKbn = CST_HIS_NYUGAIKBN_G) or
      (wm_DataInOutKbn = CST_HIS_NYUGAIKBN_C) then
    begin
      if wm_DataInOutKbn = CST_HIS_NYUGAIKBN_N then
      begin
        wm_DataInOutKbn := CST_RIS_NYUGAIKBN_N;
      end
      else if wm_DataInOutKbn = CST_HIS_NYUGAIKBN_G then
      begin
        wm_DataInOutKbn := CST_RIS_NYUGAIKBN_G;
      end
      else if wm_DataInOutKbn = CST_HIS_NYUGAIKBN_C then
      begin
        wm_DataInOutKbn := CST_RIS_NYUGAIKBN_C;
      end;
      //正常
      res := True;
    end;
    //異常の場合
    if not res then
    begin
      //ログ文字列作成
      proc_StrConcat(arg_DLog,'入外区分 = ' + wm_DataInOutKbn);
      //戻り値
      Result := False;
    end;

    //オーダ 依頼科
    res := func_CheckID('SectionMaster',
                        '( Section_ID = ''' + wm_DataSectionCode + ''' )');
    //異常の場合
    if not res then
    begin
      //ログ文字列作成
      proc_StrConcat(arg_DLog,'依頼科ID = ' + wm_DataSectionCode);
      //戻り値
      Result := False;
    end;
    {
    //データがある場合
    if wm_DataWardCode <> '' then
    begin
      //オーダ 病棟
      res := func_CheckID('ByoutouMaster',
                          '( Byoutou_ID = ''' + wm_DataWardCode + ''' )');
      //異常の場合
      if not res then begin
        //ログ文字列作成
        proc_StrConcat(arg_DLog,'病棟ID = ' + wm_DataWardCode);
        //戻り値
        Result := False;
      end;
    end;
    //病室コードがある場合
    if wm_DataSickroomCode <> '' then
    begin
      //オーダ 病室
      res := func_CheckID('BYOUSITUMASTER',
                          '(BYOUSITU_ID = ''' + wm_DataSickroomCode + ''') ');
      //異常の場合
      if not res then
      begin
        //ログ文字列作成
        proc_StrConcat(arg_DLog,'病室ID = ' + wm_DataSickroomCode);
        //戻り値
        Result := False;
      end;
    end;
    }
    //緊急区分がある場合
    if wm_DataKinkyuKbn <> '' then
    begin
      //初期化
      res := False;
      //iniファイル設定分
      for wi_Loop := 0 to g_KinkyuKbn_List.Count - 1 do
      begin
        //iniファイルにデータがある場合
        if wm_DataKinkyuKbn = g_KinkyuKbn_List[wi_Loop] then begin
          //正常
          res := True;
          break;
        end;
      end;
      //異常の場合
      if not res then
      begin
        //ログ文字列作成
        proc_StrConcat(arg_DLog,'緊急区分 = ' + wm_DataKinkyuKbn);
        //戻り値
        Result := False;
      end;
    end;

    //至急区分がある場合
    if wm_DataSikyuKbn <> '' then
    begin
      //初期化
      res := False;
      //iniファイル設定分
      for wi_Loop := 0 to g_SikyuKbn_List.Count - 1 do
      begin
        //iniファイルにデータがある場合
        if wm_DataSikyuKbn = g_SikyuKbn_List[wi_Loop] then begin
          //正常
          res := True;
          break;
        end;
      end;
      //異常の場合
      if not res then
      begin
        //ログ文字列作成
        proc_StrConcat(arg_DLog,'至急区分 = ' + wm_DataSikyuKbn);
        //戻り値
        Result := False;
      end;
    end;

    //至急現像区分がある場合
    if wm_DataGenzoKbn <> '' then
    begin
      //初期化
      res := False;
      //iniファイル設定分
      for wi_Loop := 0 to g_GenzoKbn_List.Count - 1 do
      begin
        //iniファイルにデータがある場合
        if wm_DataGenzoKbn = g_GenzoKbn_List[wi_Loop] then begin
          //正常
          res := True;
          break;
        end;
      end;
      //異常の場合
      if not res then
      begin
        //ログ文字列作成
        proc_StrConcat(arg_DLog,'至急現像区分 = ' + wm_DataGenzoKbn);
        //戻り値
        Result := False;
      end;
    end;

    //予約区分がある場合
    if wm_DataYoyakuKbn <> '' then
    begin
      //初期化
      res := False;
      //iniファイル設定分
      for wi_Loop := 0 to g_YoyakuKbn_List.Count - 1 do
      begin
        //iniファイルにデータがある場合
        if wm_DataYoyakuKbn = g_YoyakuKbn_List[wi_Loop] then begin
          //正常
          res := True;
          break;
        end;
      end;
      //異常の場合
      if not res then
      begin
        //ログ文字列作成
        proc_StrConcat(arg_DLog,'予約区分 = ' + wm_DataYoyakuKbn);
        //戻り値
        Result := False;
      end;
    end;

    //読影区分がある場合
    if wm_DataDokueiKbn <> '' then
    begin
      //初期化
      res := False;
      //iniファイル設定分
      for wi_Loop := 0 to g_DokueiKbn_List.Count - 1 do
      begin
        //iniファイルにデータがある場合
        if wm_DataDokueiKbn = g_DokueiKbn_List[wi_Loop] then begin
          //正常
          res := True;
          break;
        end;
      end;
      //異常の場合
      if not res then
      begin
        //ログ文字列作成
        proc_StrConcat(arg_DLog,'読影区分 = ' + wm_DataDokueiKbn);
        //戻り値
        Result := False;
      end;
    end;

    //繰り返された分だけ
    for w_i := 0 to Length(wm_OrderBui) - 1 do
    begin
      //2018/08/30 部位情報 変更
      //撮影種コードと項目コードで確認
{
      res := func_CheckID('BUISETMASTER','KENSATYPE_ID = ''' +
                          //wm_DataSatueiCode + ''' ' +
                          wm_RISKensaType + ''' ' +
                        'AND BUISET_ID = ''' + wm_OrderBui[w_i].KmkCode + '''');
}
      res := func_CheckID('BUIMASTER','KENSATYPE_ID = ''' + wm_RISKensaType + ''' ' +
                        'AND SUBSTR(BUI_ID, 1, 6) = ''' + wm_OrderBui[w_i].KmkCode + '''');

      //異常の場合
      if not res then begin
        //ログ文字列作成
        proc_StrConcat(arg_DLog,'部位マスタ：撮影種コード = ' +
                       wm_RISKensaType + ' 項目コード = ' +
                       wm_OrderBui[w_i].KmkCode);
        //戻り値
        Result := False;
      end;

      try
        with FQ_SEL do begin
          //SQL設定
          //2018/08/30 部位情報 変更
{
          sqlSelect := sqlSelect + 'SELECT BUI_ID, HOUKOU_ID, SAYUU_ID, KENSAHOUHOU_ID';
          sqlSelect := sqlSelect + '  FROM BUISETMASTER';
          sqlSelect := sqlSelect + ' WHERE BUISET_ID = :PBUISET_ID';
          sqlSelect := sqlSelect + '   AND KENSATYPE_ID = :PKENSATYPE_ID';
}
          sqlSelect := 'SELECT BUI_ID, DEF_HOUKOU_ID, DEF_KENSAHOUHOU_ID'       + #10 +
                       'FROM BUIMASTER'                                         + #10 +
                       'WHERE SUBSTR(BUI_ID, 1, 6) = :PBUI_ID'                  + #10 +
                       'AND KENSATYPE_ID = :PKENSATYPE_ID';
          PrepareQuery(sqlSelect);
          //パラメータ
          SetParam('PBUI_ID',       wm_OrderBui[w_i].KmkCode);
          SetParam('PKENSATYPE_ID', wm_RISKensaType);
          //SQL実行
          iRslt:= OpenQuery();
          if iRslt < 0 then begin
            //例外エラー
            Result := False;
          end;

          if Eof = False Then begin
            //部位IDがある場合
            if GetString('BUI_ID') <> '' then begin
              wm_OrderBui[w_i].BuiID := GetString('BUI_ID');
            end
            //方向IDがない場合
            else
            begin
              //ログ文字列作成
              proc_StrConcat(arg_DLog,'部位コードがありません。' +
                             ' 撮影種コード = ' + wm_RISKensaType +
                             ' 項目コード = ' + wm_OrderBui[w_i].KmkCode +
                             ' 部位コード = ' + wm_OrderBui[w_i].BuiCode);
              //戻り値
              Result := False;
            end;
            //方向IDがある場合
            if GetString('DEF_HOUKOU_ID') <> '' then begin
              //方向ID設定
              wm_OrderBui[w_i].HoukouID := GetString('DEF_HOUKOU_ID');
            end
            //方向IDがない場合
            else
            begin
              //ログ文字列作成
              proc_StrConcat(arg_DLog,'方向コードがありません。' +
                             ' 撮影種コード = ' + wm_RISKensaType +
                             ' 項目コード = ' + wm_OrderBui[w_i].KmkCode +
                             ' 部位コード = ' + wm_OrderBui[w_i].BuiCode);
              //戻り値
              Result := False;
            end;
            {
            //左右IDがある場合
            if GetString('SAYUU_ID') <> '' then
            begin
              //左右ID設定
              wm_OrderBui[w_i].SayuID := GetString('SAYUU_ID');
            end
            //左右IDがない場合
            else
            begin
              //ログ文字列作成
              proc_StrConcat(arg_DLog,'左右コードがありません。' +
                             ' 撮影種コード = ' + wm_RISKensaType +
                             ' 項目コード = ' + wm_OrderBui[w_i].KmkCode +
                             ' 部位コード = ' + wm_OrderBui[w_i].BuiCode);
              //戻り値
              Result := False;
            end;
            }
            wm_OrderBui[w_i].SayuID := '0';   //固定
            
            //検査方法IDがある場合
            if GetString('DEF_KENSAHOUHOU_ID') <> '' then
            begin
              //検査方法ID設定
              wm_OrderBui[w_i].HouhouID := GetString('DEF_KENSAHOUHOU_ID');
            end
            //検査方法IDがない場合
            else
            begin
              //ログ文字列作成
              proc_StrConcat(arg_DLog,'検査方法コードがありません。' +
                             ' 撮影種コード = ' + wm_RISKensaType +
                             ' 項目コード = ' + wm_OrderBui[w_i].KmkCode +
                             ' 部位コード = ' + wm_OrderBui[w_i].BuiCode);
              //戻り値
              Result := False;
            end;

          end;
        end;
      except
        //例外エラー
        Result := False;
      end;

      if wm_OrderBui[w_i].KensaRoomCode <> '' then
      begin
        //2006.09.21
        //検査室コード
        {res := func_CheckID('EXAMROOMMASTER','KENSATYPE_ID = ''' +
                            wm_DataSatueiCode + ''' ' + 'AND EXAMROOM_ID = ''' +
                            wm_OrderBui[w_i].KensaRoomCode + '''');
                            }
        res := func_CheckID('EXAMROOMMASTER','KENSATYPE_ID LIKE ''%' +
                            wm_RISKensaType + '%'' ' + 'AND EXAMROOM_ID = ''' +
                            wm_OrderBui[w_i].KensaRoomCode + '''');
        //異常の場合
        if not res then
        begin
          //ログ文字列作成
          proc_StrConcat(arg_DLog,'検査室マスタ：撮影種コード = ' +
                         wm_RISKensaType +
                         ' 検査室コード = ' + wm_OrderBui[w_i].KensaRoomCode);
          //戻り値
          Result := False;
        end;
      end;
    end;
  end;
  //終了
  Exit;
end;
{******************************************************************************}
{                                                                              }
{    関数名 func_MakeKanjaTBL  ：患者マスタ更新                                }
{                                                                              }
{  返り値型 Boolean型                                                          }
{           True：成功                                                         }
{           False：失敗                                                        }
{                                                                              }
{      引数 型             名前              タイプ  説明                      }
{           String         arg_KanjaID         IN    患者ID                    }
{           String         arg_DLog          IN/OUT  ログ内容                  }
{                                                                              }
{      例外 なし                                                               }
{                                                                              }
{  機能説明 患者マスタの更新を行う。                                           }
{                                                                              }
{******************************************************************************}
function  TDb_RisSvr_Irai.func_MakeKanjaTBL(     arg_KanjaID       : String;
                                             var arg_LogBuffer     : String
                                            ):Boolean;
var
  w_Count:integer;
  w_res:boolean;
  wm_RomaSimei:String;
  ws_Height: String;
  we_Height: Extended;
  ws_Weight: String;
  we_Weight: Extended;
  ws_Syougai: String;
  ws_Kinki: String;
  ws_KansenFlg: String;
  ws_Kansen: String;
  ws_Ninsin: String;
  ws_ExtraProfile: String;
  ws_Jyusyo1: String;
  ws_Jyusyo2: String;
  WS_Date: String;
  WS_Time: String;

  sqlExec:    String;
  iRslt:      Integer;

  wkHIS_UPDATEDATE: String;
  wkDEATHDATE:      String;
begin
  //重複チェック
  w_Count := func_CoutRecord('PATIENTINFO', '(KANJA_ID = ''' + wm_KanjaPatientID
                             + ''') ');
  //重複レコードがない場合
  if w_Count < 1 then
  begin

    try
      with FQ_ALT do begin
        //SQL文字列作成
        sqlExec := '';
        sqlExec := sqlExec + 'INSERT INTO PATIENTINFO (';
        sqlExec := sqlExec + 'KANJA_ID,             '; //患者ID
        sqlExec := sqlExec + 'KANJISIMEI,           '; //患者漢字氏名
        sqlExec := sqlExec + 'ROMASIMEI,            '; //患者ローマ字氏名
        sqlExec := sqlExec + 'KANASIMEI,            '; //患者カナ氏名
        sqlExec := sqlExec + 'BIRTHDAY,             '; //生年月日
        sqlExec := sqlExec + 'SEX,                  '; //性別
        sqlExec := sqlExec + 'JUSYO1,               '; //住所1
        sqlExec := sqlExec + 'JUSYO2,               '; //住所2
        sqlExec := sqlExec + 'KANJA_NYUGAIKBN,      '; //患者入外区分
        sqlExec := sqlExec + 'BYOUTOU_ID,           '; //病棟ID
        sqlExec := sqlExec + 'BYOUSITU_ID,          '; //病室ID
        sqlExec := sqlExec + 'TALL,                 '; //身長
        sqlExec := sqlExec + 'WEIGHT,               '; //体重
        sqlExec := sqlExec + 'BLOOD,                '; //血液型
        sqlExec := sqlExec + 'TRANSPORTTYPE,        '; //患者移動情報
        sqlExec := sqlExec + 'HANDICAPPEDMARK,      '; //障害情報識別子
        sqlExec := sqlExec + 'HANDICAPPED,          '; //障害情報
        sqlExec := sqlExec + 'INFECTIONMARK,        '; //感染情報識別子
        sqlExec := sqlExec + 'INFECTION,            '; //感染情報
        sqlExec := sqlExec + 'CONTRAINDICATIONMARK, '; //禁忌情報識別子
        sqlExec := sqlExec + 'CONTRAINDICATION,     '; //禁忌情報
        sqlExec := sqlExec + 'PREGNANCYMARK,        '; //妊娠情報識別子
        sqlExec := sqlExec + 'PREGNANCY,            '; //妊娠情報
        sqlExec := sqlExec + 'NOTES,                '; //その他情報
        sqlExec := sqlExec + 'NOTESMARK,            '; //その他情報
        sqlExec := sqlExec + 'HIS_UPDATEDATE,       '; //HIS最新更新日時
        sqlExec := sqlExec + 'DEATHDATE             '; //死亡日
        sqlExec := sqlExec + ') Values (';
        sqlExec := sqlExec + ':PKANJA_ID,             '; //患者ID
        sqlExec := sqlExec + ':PKANJISIMEI,           '; //患者漢字氏名
        sqlExec := sqlExec + ':PROMASIMEI,            '; //患者ローマ字氏名
        sqlExec := sqlExec + ':PKANASIMEI,            '; //患者カナ氏名
        sqlExec := sqlExec + ':PBIRTHDAY,             '; //生年月日
        sqlExec := sqlExec + ':PSEX,                  '; //性別
        sqlExec := sqlExec + ':PJUSYO1,               '; //住所1
        sqlExec := sqlExec + ':PJUSYO2,               '; //住所2
        sqlExec := sqlExec + ':PKANJA_NYUGAIKBN,      '; //患者入外区分
        sqlExec := sqlExec + ':PBYOUTOU_ID,           '; //病棟ID
        sqlExec := sqlExec + ':PBYOUSITU_ID,          '; //病室ID
        sqlExec := sqlExec + ':PTALL,                 '; //身長
        sqlExec := sqlExec + ':PWEIGHT,               '; //体重
        sqlExec := sqlExec + ':PBLOOD,                '; //血液型
        sqlExec := sqlExec + ':PTRANSPORTTYPE,        '; //患者移動情報
        sqlExec := sqlExec + ':PHANDICAPPEDMARK,      '; //障害情報識別子
        sqlExec := sqlExec + ':PHANDICAPPED,          '; //障害情報
        sqlExec := sqlExec + ':PINFECTIONMARK,        '; //感染情報識別子
        sqlExec := sqlExec + ':PINFECTION,            '; //感染情報
        sqlExec := sqlExec + ':PCONTRAINDICATIONMARK, '; //禁忌情報識別子
        sqlExec := sqlExec + ':PCONTRAINDICATION,     '; //禁忌情報
        sqlExec := sqlExec + ':PPREGNANCYMARK,        '; //妊娠情報識別子
        sqlExec := sqlExec + ':PPREGNANCY,            '; //妊娠情報
        sqlExec := sqlExec + ':PNOTES,                '; //その他情報
        sqlExec := sqlExec + ':PNOTESMARK,            '; //その他情報
        sqlExec := sqlExec + '%s,';
        sqlExec := sqlExec + '%s ';
        //sqlExec := sqlExec + 'TO_DATE(:PHIS_UPDATEDATE, ''YYYY/MM/DD HI24:MI:SS''), '; //HIS最新更新日時
        //sqlExec := sqlExec + 'TO_DATE(:PDEATHDATE, ''YYYY/MM/DD'') '; //死亡日
        sqlExec := sqlExec + ') ';
        //TO_DATE
        wkDEATHDATE       := 'TO_DATE(''%s'', ''YYYY/MM/DD'')';
        wkHIS_UPDATEDATE  := 'TO_DATE(''%s'', ''YYYY/MM/DD HH24:MI:SS'')';
        //死亡日がある場合
        if wm_KanjaDeathDate <> '' then begin
          //死亡日
          wkDEATHDATE := Format(wkDEATHDATE, [func_Date8To10(wm_KanjaDeathDate)]);
        end
        else begin
          //死亡日
          wkDEATHDATE := 'NULL';
        end;
        if (wm_HeaderDate <> '') and
           (wm_HeaderTime <> '') then begin
          //年がないので、取得する
          WS_Date := FormatDateTime('YYYY', FQ_SEL.GetSysDate);
          WS_Date := func_Date8To10(WS_Date + wm_HeaderDate);
          WS_Time := func_Time6To8(wm_HeaderTime);
          //WD_DateTime := func_StrToDateTime(WS_Date + ' ' + WS_Time);
          //オーダ登録時
          wkHIS_UPDATEDATE := Format(wkHIS_UPDATEDATE, [WS_Date + ' ' + WS_Time]);
        end
        else begin
          //オーダ登録時
          wkHIS_UPDATEDATE := 'NULL';
        end;
        //SQL設定
        sqlExec := Format(sqlExec, [wkHIS_UPDATEDATE, wkDEATHDATE]);
        PrepareQuery(sqlExec);
        //パラメータ
        //患者ID
        SetParam('PKANJA_ID', wm_KanjaPatientID);
        //患者漢字氏名
        SetParam('PKANJISIMEI', wm_KanjaPatientName);
        //初期化
        wm_RomaSimei := '';
        //全角→半角変換
        wm_RomaSimei := func_Moji_Henkan(wm_KanjaPatientKana,1);
        //カナ→ローマ字変換
        wm_RomaSimei := func_Kana_To_Roma_n(wm_RomaSimei, g_RomaFlg_1,
                                            g_RomaFlg_2, g_RomaFlg_3,
                                            g_RomaFlg_4);
        //患者ローマ字氏名
        SetParam('PROMASIMEI', wm_RomaSimei);
        //患者カナ氏名
        SetParam('PKANASIMEI', wm_KanjaPatientKana);
        //生年月日
        SetParam('PBIRTHDAY', wm_KanjaBirthday);
        //性別
        SetParam('PSEX', wm_KanjaSex);
        //郵便番号がある場合
        if wm_KanjaPostCode1 <> '' then
          ws_Jyusyo1 := CST_POSTCODE_1 + Copy(wm_KanjaPostCode1, 1, 3) +
                        CST_POSTCODE_2 + Copy(wm_KanjaPostCode1, 4, 7);
        ws_Jyusyo1 := ws_Jyusyo1 + ' ' + wm_KanjaAddress1 + ' ';
        //電話番号がある場合
        if wm_KanjaTEL1 <> '' then
          ws_Jyusyo1 := ws_Jyusyo1 + CST_TEL + wm_KanjaTEL1;
        // 空白削除
        ws_Jyusyo1 := Trim(ws_Jyusyo1);

        //住所1
        SetParam('PJUSYO1', ws_Jyusyo1);
        //郵便番号がある場合
        if wm_KanjaPostCode2 <> '' then
          ws_Jyusyo2 := CST_POSTCODE_1 + Copy(wm_KanjaPostCode2, 1, 3) +
                        CST_POSTCODE_2 + Copy(wm_KanjaPostCode2, 4, 7);
        ws_Jyusyo2 := ws_Jyusyo2 + ' ' + wm_KanjaAddress2 + ' ';
        //電話番号がある場合
        if wm_KanjaTEL2 <> '' then
          ws_Jyusyo2 := ws_Jyusyo2 + CST_TEL + wm_KanjaTEL2;
        // 空白削除
        ws_Jyusyo2 := Trim(ws_Jyusyo2);

        //住所2
        SetParam('PJUSYO2', ws_Jyusyo2);
        //患者病棟コードがある場合
        if wm_KanjaWardCode <> '' then
        begin
          //患者入外区分 入院
          SetParam('PKANJA_NYUGAIKBN', CST_RIS_NYUGAIKBN_N);
        end
        //患者病棟コードがない場合
        else
        begin
          //患者入外区分 外来
          SetParam('PKANJA_NYUGAIKBN', CST_RIS_NYUGAIKBN_G);
        end;
        //病棟ID
        SetParam('PBYOUTOU_ID', wm_KanjaWardCode);
        //病室ID
        SetParam('PBYOUSITU_ID', wm_KanjaSickroomCode);
        //身長項目が"00000"の場合
        if (wm_KanjaHeight = CST_HEIGTH_NULL) or
           (wm_KanjaHeight = '') then
        begin
          //身長
          SetParam('PTALL', '');
        end
        //身長項目が"00000"以外の場合
        else
        begin
          //5桁を整数部3桁、小数部2桁に変換
          ws_Height := Copy(wm_KanjaHeight, 1, 3) +
                       '.' + Copy(wm_KanjaHeight, 4, 2);
          //実数型に変換
          we_Height := StrToCurr(ws_Height);
          //フォーマットをして文字列に変換
          ws_Height := FormatCurr('##0.00',we_Height);
          //身長
          SetParam('PTALL', ws_Height);
        end;
        //体重項目が"00000"の場合
        if (wm_KanjaWeight = CST_WEIGTH_NULL) or
           (wm_KanjaWeight = '') then
        begin
          //体重
          SetParam('PWEIGHT', '');
        end
        //体重項目が"00000"以外の場合
        else
        begin
          //5桁を整数部3桁、小数部2桁に変換
          ws_Weight := Copy(wm_KanjaWeight, 1, 3) +
                       '.' + Copy(wm_KanjaWeight, 4, 2);
          //実数型に変換
          we_Weight := StrToCurr(ws_Weight);
          //フォーマットをして文字列に変換
          ws_Weight := FormatCurr('##0.00',we_Weight);
          //体重
          SetParam('PWEIGHT', ws_Weight);
        end;
        //血液型
        SetParam('PBLOOD', func_Make_BloodType(wm_KanjaBloodAB, wm_KanjaBloodRH));
        //患者移動情報
        SetParam('PTRANSPORTTYPE', wm_KanjaKyugoKbn);
        //障害情報が'0'だけの場合
        if func_IsInstr(Trim(wm_KanjaSyougaiInfo),'0') then
        begin
          //障害情報識別子
          SetParam('PHANDICAPPEDMARK', DEF_SYOUGAI_0);
        end
        //上記以外の場合
        else
        begin
          //障害情報識別子
          SetParam('PHANDICAPPEDMARK', DEF_SYOUGAI_1);
        end;
        //禁忌情報が'0'だけの場合
        if func_IsInstr(Trim(wm_KanjaKinkiInfo),'0') then
        begin
          if wm_KanjaKinkiCom = '' then
          begin
            //禁忌情報識別子
            SetParam('PCONTRAINDICATIONMARK', DEF_KINKI_0);
          end
          else
          begin
            //禁忌情報識別子
            SetParam('PCONTRAINDICATIONMARK', DEF_KINKI_1);
          end;
        end
        //上記以外の場合
        else
        begin
          //禁忌情報識別子
          SetParam('PCONTRAINDICATIONMARK', DEF_KINKI_1);
        end;
        //障害情報・禁忌情報の作成
        proc_Make_RISInfo(wm_KanjaSyougaiInfo, wm_KanjaKinkiInfo, ws_Syougai,
                          ws_Kinki);
        //障害情報
        SetParam('PHANDICAPPED', ws_Syougai);
        if ws_Kinki <> '' then
        begin
          if wm_KanjaKinkiCom <> '' then
            ws_Kinki := ws_Kinki + ',' + wm_KanjaKinkiCom;
        end
        else
        begin
          ws_Kinki := wm_KanjaKinkiCom;
        end;
        //禁忌情報
        SetParam('PCONTRAINDICATION', ws_Kinki);
        //感染情報識別子、感染情報作成
        proc_Make_RISKansen(wm_KanjaKansenInfo, wm_KanjaKansenCom, ws_KansenFlg,
                            ws_Kansen);
        //感染情報識別子
        SetParam('PINFECTIONMARK', ws_KansenFlg);
        //感染情報
        SetParam('PINFECTION', ws_Kansen);
        //妊娠日がある場合
        if wm_KanjaNinsinDate <> '' then
        begin
          //妊娠情報識別子
          SetParam('PPREGNANCYMARK', CST_NINSIN_1);
        end
        else
        begin
          //妊娠情報識別子
          SetParam('PPREGNANCYMARK', CST_NINSIN_0);
        end;
        //妊娠日の作成
        proc_Make_RISNinsinDate(wm_KanjaNinsinDate, ws_Ninsin);
        //妊娠情報
        SetParam('PPREGNANCY', ws_Ninsin);
        //その他情報の作成
        ws_ExtraProfile := func_Make_ExtraProfile(wm_KanjaKangoKbn,wm_KanjaPatientKbn);
        //その他情報
        SetParam('PNOTES', ws_ExtraProfile);
        if ws_ExtraProfile <> '' then
          SetParam('PNOTESMARK', CST_NOTES_1)
        else
          SetParam('PNOTESMARK', CST_NOTES_0);
        //SQL実行
        iRslt:= ExecSQL();
        if iRslt < 0 then begin
          //失敗
          Result := False;
          //切断
          wg_DBFlg := False;
          //
          Exit;
        end;
      end;
      //成功
      Result := True;
    except
      //失敗
      Result := False;
      //切断
      wg_DBFlg := False;
      //
      Exit;
    end;

  end
  //重複レコードがある場合
  else
  begin
    //患者マスタテーブルをロックする
    w_res := func_LockTbl('PATIENTINFO','KANJA_ID','KANJA_ID = ''' +
                          wm_KanjaPatientID + ''' ', 'nowait');
    //異常終了の場合
    if w_res = False then
    begin
      //ログ文字列作成
      proc_StrConcat(arg_LogBuffer, ' 使用中 KANJA_ID = ' + wm_KanjaPatientID);
      //戻り値
      Result := False;
      //処理終了
      Exit;
    end;

    //UPDate
    try
      with FQ_ALT do begin
        //SQL文字列作成
        sqlExec := '';
        sqlExec := sqlExec + 'UPDATE PATIENTINFO SET ';
        sqlExec := sqlExec + 'KANJISIMEI           = :PKANJISIMEI,           '; //患者漢字氏名
        sqlExec := sqlExec + 'ROMASIMEI            = :PROMASIMEI,            '; //患者ローマ字氏名
        sqlExec := sqlExec + 'KANASIMEI            = :PKANASIMEI,            '; //患者カナ氏名
        sqlExec := sqlExec + 'BIRTHDAY             = :PBIRTHDAY,             '; //生年月日
        sqlExec := sqlExec + 'SEX                  = :PSEX,                  '; //性別
        sqlExec := sqlExec + 'JUSYO1               = :PJUSYO1,               '; //住所1
        sqlExec := sqlExec + 'JUSYO2               = :PJUSYO2,               '; //住所2
        sqlExec := sqlExec + 'KANJA_NYUGAIKBN      = :PKANJA_NYUGAIKBN,      '; //患者入外区分
        sqlExec := sqlExec + 'BYOUTOU_ID           = :PBYOUTOU_ID,           '; //病棟ID
        sqlExec := sqlExec + 'BYOUSITU_ID          = :PBYOUSITU_ID,          '; //病室ID
        sqlExec := sqlExec + 'TALL                 = :PTALL,                 '; //身長
        sqlExec := sqlExec + 'WEIGHT               = :PWEIGHT,               '; //体重
        sqlExec := sqlExec + 'BLOOD                = :PBLOOD,                '; //血液型
        sqlExec := sqlExec + 'TRANSPORTTYPE        = :PTRANSPORTTYPE,        '; //患者移動情報
        sqlExec := sqlExec + 'HANDICAPPEDMARK      = :PHANDICAPPEDMARK,      '; //障害情報識別子
        sqlExec := sqlExec + 'HANDICAPPED          = :PHANDICAPPED,          '; //障害情報
        sqlExec := sqlExec + 'INFECTIONMARK        = :PINFECTIONMARK,        '; //感染情報識別子
        sqlExec := sqlExec + 'INFECTION            = :PINFECTION,            '; //感染情報
        sqlExec := sqlExec + 'CONTRAINDICATIONMARK = :PCONTRAINDICATIONMARK, '; //禁忌情報識別子
        sqlExec := sqlExec + 'CONTRAINDICATION     = :PCONTRAINDICATION,     '; //禁忌情報
        sqlExec := sqlExec + 'PREGNANCYMARK        = :PPREGNANCYMARK,        '; //妊娠情報識別子
        sqlExec := sqlExec + 'PREGNANCY            = :PPREGNANCY,            '; //妊娠情報
        sqlExec := sqlExec + 'NOTES                = :PNOTES,                '; //その他情報
        sqlExec := sqlExec + 'NOTESMARK            = :PNOTESMARK,            '; //その他情報
        sqlExec := sqlExec + 'HIS_UPDATEDATE       = %s, '; //HIS最新更新日時
        sqlExec := sqlExec + 'DEATHDATE            = %s '; //死亡日
        //sqlExec := sqlExec + 'HIS_UPDATEDATE       = TO_DATE(:PHIS_UPDATEDATE, ''YYYY/MM/DD HH24:MI:SS''), '; //HIS最新更新日時
        //sqlExec := sqlExec + 'DEATHDATE            = TO_DATE(:PDEATHDATE, ''YYYY/MM/DD'') '; //死亡日
        sqlExec := sqlExec + 'WHERE KANJA_ID       = :PKANJA_ID              '; //患者ID
        //TO_DATE
        wkDEATHDATE       := 'TO_DATE(''%s'', ''YYYY/MM/DD'')';
        wkHIS_UPDATEDATE  := 'TO_DATE(''%s'', ''YYYY/MM/DD HH24:MI:SS'')';
        //死亡日がある場合
        if wm_KanjaDeathDate <> '' then begin
          //死亡日
          wkDEATHDATE := Format(wkDEATHDATE, [func_Date8To10(wm_KanjaDeathDate)]);
        end
        else begin
          //死亡日
          wkDEATHDATE := 'NULL';
        end;
        if (wm_HeaderDate <> '') and
           (wm_HeaderTime <> '') then begin
          //年がないので、取得する
          WS_Date := FormatDateTime('YYYY', FQ_SEL.GetSysDate);
          WS_Date := func_Date8To10(WS_Date + wm_HeaderDate);
          WS_Time := func_Time6To8(wm_HeaderTime);
          //WD_DateTime := func_StrToDateTime(WS_Date + ' ' + WS_Time);
          //オーダ登録時
          wkHIS_UPDATEDATE := Format(wkHIS_UPDATEDATE, [WS_Date + ' ' + WS_Time]);
        end
        else begin
          //オーダ登録時
          wkHIS_UPDATEDATE := 'NULL';
        end;
        //SQL設定
        sqlExec := Format(sqlExec, [wkHIS_UPDATEDATE, wkDEATHDATE]);
        PrepareQuery(sqlExec);
        //パラメータ
        //患者ID
        SetParam('PKANJA_ID', wm_KanjaPatientID);
        //患者漢字氏名
        SetParam('PKANJISIMEI', wm_KanjaPatientName);
        //初期化
        wm_RomaSimei := '';
        //全角→半角変換
        wm_RomaSimei := func_Moji_Henkan(wm_KanjaPatientKana,1);
        //カナ→ローマ字変換
        wm_RomaSimei := func_Kana_To_Roma_n(wm_RomaSimei, g_RomaFlg_1,
                                            g_RomaFlg_2, g_RomaFlg_3,
                                            g_RomaFlg_4);
        //患者ローマ字氏名
        SetParam('PROMASIMEI', wm_RomaSimei);
        //患者カナ氏名
        SetParam('PKANASIMEI', wm_KanjaPatientKana);
        //生年月日
        SetParam('PBIRTHDAY', wm_KanjaBirthday);
        //性別
        SetParam('PSEX', wm_KanjaSex);
        //郵便番号がある場合
        if wm_KanjaPostCode1 <> '' then
          ws_Jyusyo1 := CST_POSTCODE_1 + Copy(wm_KanjaPostCode1, 1, 3) +
                        CST_POSTCODE_2 + Copy(wm_KanjaPostCode1, 4, 7);
        ws_Jyusyo1 := ws_Jyusyo1 + ' ' + wm_KanjaAddress1 + ' ';
        //電話番号がある場合
        if wm_KanjaTEL1 <> '' then
          ws_Jyusyo1 := ws_Jyusyo1 + CST_TEL + wm_KanjaTEL1;
        // 空白削除
        ws_Jyusyo1 := Trim(ws_Jyusyo1);

        //住所1
        SetParam('PJUSYO1', ws_Jyusyo1);
        //郵便番号がある場合
        if wm_KanjaPostCode2 <> '' then
          ws_Jyusyo2 := CST_POSTCODE_1 + Copy(wm_KanjaPostCode2, 1, 3) +
                        CST_POSTCODE_2 + Copy(wm_KanjaPostCode2, 4, 7);
        ws_Jyusyo2 := ws_Jyusyo2 + ' ' + wm_KanjaAddress2 + ' ';
        //電話番号がある場合
        if wm_KanjaTEL2 <> '' then
          ws_Jyusyo2 := ws_Jyusyo2 + CST_TEL + wm_KanjaTEL2;
        // 空白削除
        ws_Jyusyo2 := Trim(ws_Jyusyo2);

        //住所2
        SetParam('PJUSYO2', ws_Jyusyo2);
        //患者病棟コードがある場合
        if wm_KanjaWardCode <> '' then
        begin
          //患者入外区分 入院
          SetParam('PKANJA_NYUGAIKBN', CST_RIS_NYUGAIKBN_N);
        end
        //患者病棟コードがない場合
        else
        begin
          //患者入外区分 外来
          SetParam('PKANJA_NYUGAIKBN', CST_RIS_NYUGAIKBN_G);
        end;
        //病棟ID
        SetParam('PBYOUTOU_ID', wm_KanjaWardCode);
        //病室ID
        SetParam('PBYOUSITU_ID', wm_KanjaSickroomCode);
        //身長項目が"00000"の場合
        if (wm_KanjaHeight = CST_HEIGTH_NULL) or
           (wm_KanjaHeight = '') then
        begin
          //身長
          SetParam('PTALL', '');
        end
        //身長項目が"00000"以外の場合
        else
        begin
          //5桁を整数部3桁、小数部2桁に変換
          ws_Height := Copy(wm_KanjaHeight, 1, 3) +
                       '.' + Copy(wm_KanjaHeight, 4, 2);
          //実数型に変換
          we_Height := StrToCurr(ws_Height);
          //フォーマットをして文字列に変換
          ws_Height := FormatCurr('##0.00',we_Height);
          //身長
          SetParam('PTALL', ws_Height);
        end;
        //体重項目が"00000"の場合
        if (wm_KanjaWeight = CST_WEIGTH_NULL) or
           (wm_KanjaWeight = '') then
        begin
          //体重
          SetParam('PWEIGHT', '');
        end
        //体重項目が"00000"以外の場合
        else
        begin
          //5桁を整数部3桁、小数部2桁に変換
          ws_Weight := Copy(wm_KanjaWeight, 1, 3) +
                       '.' + Copy(wm_KanjaWeight, 4, 2);
          //実数型に変換
          we_Weight := StrToCurr(ws_Weight);
          //フォーマットをして文字列に変換
          ws_Weight := FormatCurr('##0.00',we_Weight);
          //体重
          SetParam('PWEIGHT', ws_Weight);
        end;
        //血液型
        SetParam('PBLOOD', func_Make_BloodType(wm_KanjaBloodAB, wm_KanjaBloodRH));
        //患者移動情報
        SetParam('PTRANSPORTTYPE', wm_KanjaKyugoKbn);
        //障害情報が'0'だけの場合
        if func_IsInstr(Trim(wm_KanjaSyougaiInfo),'0') then
        begin
          //障害情報識別子
          SetParam('PHANDICAPPEDMARK', DEF_SYOUGAI_0);
        end
        //上記以外の場合
        else
        begin
          //障害情報識別子
          SetParam('PHANDICAPPEDMARK', DEF_SYOUGAI_1);
        end;
        //禁忌情報が'0'だけの場合
        if func_IsInstr(Trim(wm_KanjaKinkiInfo),'0') then
        begin
          if wm_KanjaKinkiCom = '' then
          begin
            //禁忌情報識別子
            SetParam('PCONTRAINDICATIONMARK', DEF_KINKI_0);
          end
          else
          begin
            //禁忌情報識別子
            SetParam('PCONTRAINDICATIONMARK', DEF_KINKI_1);
          end;
        end
        //上記以外の場合
        else
        begin
          //禁忌情報識別子
          SetParam('PCONTRAINDICATIONMARK', DEF_KINKI_1);
        end;
        //障害情報・禁忌情報の作成
        proc_Make_RISInfo(wm_KanjaSyougaiInfo, wm_KanjaKinkiInfo, ws_Syougai,
                          ws_Kinki);
        //障害情報
        SetParam('PHANDICAPPED', ws_Syougai);
        if ws_Kinki <> '' then
        begin
          if wm_KanjaKinkiCom <> '' then
            ws_Kinki := ws_Kinki + ',' + wm_KanjaKinkiCom;
        end
        else
        begin
          ws_Kinki := wm_KanjaKinkiCom;
        end;
        //禁忌情報
        SetParam('PCONTRAINDICATION', ws_Kinki);
        //感染情報識別子、感染情報作成
        proc_Make_RISKansen(wm_KanjaKansenInfo, wm_KanjaKansenCom, ws_KansenFlg,
                            ws_Kansen);
        //感染情報識別子
        SetParam('PINFECTIONMARK', ws_KansenFlg);
        //感染情報
        SetParam('PINFECTION', ws_Kansen);
        //妊娠日がある場合
        if wm_KanjaNinsinDate <> '' then
        begin
          //妊娠情報識別子
          SetParam('PPREGNANCYMARK', CST_NINSIN_1);
        end
        else
        begin
          //妊娠情報識別子
          SetParam('PPREGNANCYMARK', CST_NINSIN_0);
        end;
        //妊娠日の作成
        proc_Make_RISNinsinDate(wm_KanjaNinsinDate, ws_Ninsin);
        //妊娠情報
        SetParam('PPREGNANCY', ws_Ninsin);
        //その他情報の作成
        ws_ExtraProfile := func_Make_ExtraProfile(wm_KanjaKangoKbn,wm_KanjaPatientKbn);
        //その他情報
        SetParam('PNOTES', ws_ExtraProfile);
        if ws_ExtraProfile <> '' then begin
          SetParam('PNOTESMARK', CST_NOTES_1);
        end
        else begin
          SetParam('PNOTESMARK', CST_NOTES_0);
        end;
        //SQL実行
        iRslt:= ExecSQL();
        if iRslt < 0 then begin
          //失敗
          Result := False;
          //切断
          wg_DBFlg := False;
          //
          Exit;
        end;
      end;
      //成功
      Result := True;
    except
      //失敗
      Result := False;
      //切断
      wg_DBFlg := False;
    end;

  end;
end;
{******************************************************************************}
{                                                                              }
{    関数名 func_GetRisID  ：RISIDの特定                                       }
{                                                                              }
{  返り値型 Boolean型                                                          }
{           True：成功                                                         }
{           False：失敗                                                        }
{                                                                              }
{      引数 型             名前              タイプ  説明                      }
{           String         arg_ID1             IN    オーダ番号                }
{           String         arg_RISID         IN/OUT  RISID                     }
{           String         arg_DLog          IN/OUT  ログ内容                  }
{                                                                              }
{      例外 なし                                                               }
{                                                                              }
{  機能説明 RISIDの特定・進捗チェックを行う。                                  }
{                                                                              }
{******************************************************************************}
function  TDb_RisSvr_Irai.func_GetRisID(     arg_ID1           : String;
                                         var arg_RISID         : String;
                                         var arg_LogBuffer     : String
                                        ):Boolean;
var
  sqlSelect:  String;
  iRslt:      Integer;
begin
  try
    //オーダメインの検索
    //初期化
    arg_RISID := '';
    with FQ_SEL do begin
      //SQL設定
      sqlSelect := '';
      sqlSelect := sqlSelect + 'SELECT RIS_ID,ORDERNO';
      sqlSelect := sqlSelect + '  FROM ORDERMAINTABLE  ';
      sqlSelect := sqlSelect + ' WHERE ORDERNO = ''' + arg_ID1 + '''';
      PrepareQuery(sqlSelect);
      //SQL実行
      iRslt:= OpenQuery();
      if iRslt < 0 then begin
        //例外エラー
        Result := False;
        //切断
        wg_DBFlg := False;
        //処理終了
        Exit;
      end;

      //データがない場合
      if Eof = True then
      begin
        //ログ文字列作成
        proc_StrConcat(arg_LogBuffer,'RIS_ID=' + arg_RISID);
        //ログ文字列作成
        proc_StrConcat(arg_LogBuffer,'ID1=' + wm_DataOrdeNo);
        //ログ文字列作成
        proc_StrConcat(arg_LogBuffer,'ID2=' + wm_KanjaPatientID);
        //ログ文字列作成
        proc_StrConcat(arg_LogBuffer,
                                'RIS_IDの特定に失敗しました。「検索存在せず」');
        //戻り値
        Result := False;
        //処理終了
        Exit;
      end;
      //RIS_ID設定
      arg_RISID := GetString('RIS_ID');
      Result := True;
    end;

    //検査進捗チェック
    with FQ_SEL do begin
      //SQL設定
      sqlSelect := '';
      sqlSelect := sqlSelect + 'SELECT RIS_ID,STATUS ';
      sqlSelect := sqlSelect + '  FROM EXMAINTABLE';
      sqlSelect := sqlSelect + ' WHERE ( RIS_ID = ''' + arg_RISID + ''' )';
      sqlSelect := sqlSelect + '   AND ( STATUS < 10 )';
      PrepareQuery(sqlSelect);
      //SQL実行
      iRslt:= OpenQuery();
      if iRslt < 0 then begin
        //例外エラー
        Result := False;
        //切断
        wg_DBFlg := False;
        //処理終了
        Exit;
      end;
      //データがない場合
      if Eof = True then
      begin
        //ログ文字列作成
        proc_StrConcat(arg_LogBuffer,'RIS_ID=' + arg_RISID);
        //ログ文字列作成
        proc_StrConcat(arg_LogBuffer,'ID1=' + wm_DataOrdeNo);
        //ログ文字列作成
        proc_StrConcat(arg_LogBuffer,'ID2=' + wm_KanjaPatientID);
        //ログ文字列作成
        proc_StrConcat(arg_LogBuffer,'RIS_ID特定NG「検査進捗エラー」');
        //戻り値
        Result := False;
        //処理終了
        Exit;
      end;
    end;
    //正常終了
    //ログ文字列作成
    proc_StrConcat(arg_LogBuffer,'RIS_ID=' + arg_RISID);
    //ログ文字列作成
    proc_StrConcat(arg_LogBuffer,'ID1=' + wm_DataOrdeNo);
    //ログ文字列作成
    proc_StrConcat(arg_LogBuffer,'ID2=' + wm_KanjaPatientID);
    //戻り値
    Result := True;
  except
    on E:exception do
    begin
      //ログ文字列作成
      proc_StrConcat(arg_LogBuffer,'RIS_ID=' + arg_RISID);
      //ログ文字列作成
      proc_StrConcat(arg_LogBuffer,'ID1=' + wm_DataOrdeNo);
      //ログ文字列作成
      proc_StrConcat(arg_LogBuffer,'ID2=' + wm_KanjaPatientID);
      //ログ文字列作成
      proc_StrConcat(arg_LogBuffer,'RIS_IDの特定に失敗しました。「例外発生' +
                     E.Message+'」');
      //戻り値
      Result := False;
      //切断
      wg_DBFlg := False;
      //処理終了
      Exit;
    end;
  end;
end;
{******************************************************************************}
{                                                                              }
{    関数名 func_UpdateRisDBIrai  ：DBの更新                                   }
{                                                                              }
{  返り値型 Boolean型                                                          }
{           True：成功                                                         }
{           False：失敗                                                        }
{                                                                              }
{      引数 型             名前              タイプ  説明                      }
{           String         arg_DLog          IN/OUT  ログ内容                  }
{                                                                              }
{      例外 なし                                                               }
{                                                                              }
{  機能説明 依頼電文の登録を行う。                                             }
{                                                                              }
{******************************************************************************}
function  TDb_RisSvr_Irai.func_UpdateRisDBIrai(
                                               var arg_LogBuffer : String
                                               ):Boolean;
begin
  //戻り値
  Result := True;
  try
    //オーダ情報の場合
    if wg_Kind = G_MSGKIND_IRAI then
    begin
      //新規の場合
      if wm_OrderCount = 0 then
      begin
        //
        Result := func_UpdateRisDBIraiNew(arg_LogBuffer);
      end
      //更新の場合
      else if wm_OrderCount > 0 then
      begin
        //
        Result := func_UpdateRisDBIraiUp(arg_LogBuffer);
      end;
    end
    //患者情報の場合
    else if wg_Kind = G_MSGKIND_KANJA then
    begin
      //
      Result := func_UpdateRisDBPatient(arg_LogBuffer);
    end
    //オーダキャンセルの場合
    else if wg_Kind = G_MSGKIND_CANCEL then
    begin
      //
      Result := func_UpdateRisDBIraiDel(arg_LogBuffer);
    end
    //処理区分エラー
    else
    begin
      //これ以前にチェックするのでありえない
      proc_StrConcat(arg_LogBuffer,' コマンドNG');
      //戻り値
      Result := False;
    end;
    //正常終了
    Exit;
  except
    on E: exception do
    begin
      //ログ文字列作成
      proc_StrConcat(arg_LogBuffer,'DB反映NG「依頼テーブル反映 例外発生' +
                     E.Message+'」');
      //戻り値
      Result := False;
      //処理終了
      Exit;
    end;
  end
end;
{
-----------------------------------------------------------------------------
  名前   : func_UpdateRisDBIraiNew;
  引数   : arg_RecvMsgStream  : TStringStream 受信電文
           arg_LogBuffer      : String        ログバッファエリア
  機能   : 1.依頼電文の内容をRIS DBに新規作成する
  復帰値 : 例外は発生しない True 正常 False 異常
-----------------------------------------------------------------------------
}
function  TDb_RisSvr_Irai.func_UpdateRisDBIraiNew(
                                                  var arg_LogBuffer : String
                                                  ):Boolean;
var
  res    : Boolean;
  w_DLog : String;
label
  p_end,p_err;
begin
  //トランザクション開始
  FDB.StartTransaction;
  try
    //ログ文字列初期化
    w_DLog := '';
    //RISID作成
    res := func_MakeRisID(wm_DataOrdeNo, wm_RisID, w_DLog);
    //異常終了の場合
    if not res then
    begin
      //ログ文字列作成
      proc_StrConcat(arg_LogBuffer, 'DB反映NG「オーダメインレコード作成[' +
                     w_DLog + ']」');
      //p_errに移動
      goto p_err;
    end;
    //オーダメイン対象RISIDをロック
    res := func_LockTbl('OrderMainTable', 'Ris_ID', 'Ris_ID = ''' + wm_RisID +
                        '''', 'nowait');
    //異常終了の場合
    if not res then
    begin
      //ログ文字列作成
      proc_StrConcat(arg_LogBuffer, 'DB反映NG「オーダメインロックRIS_ID = ' +
                     wm_RisID + '」');
      //p_errに移動
      goto p_err;
    end;
    //拡張オーダ情報
    res := func_MakeOrderInfoTBL(wm_RisID, w_DLog);
    //異常終了の場合
    if not res then
    begin
      //ログ文字列作成
      proc_StrConcat(arg_LogBuffer, 'DB反映NG「拡張オーダ情報レコード作成[ '
                     + w_DLog + ']」');
      //p_errに移動
      goto p_err;
    end;
    //オーダ部位・詳細
    res := func_MakeOrderBuiTBL(wm_RisID, w_DLog);
    //異常終了の場合
    if not res then
    begin
      //ログ文字列作成
      proc_StrConcat(arg_LogBuffer, 'DB反映NG「部位レコード作成[' + w_DLog +
                     ']」');
      //p_errに移動
      goto p_err;
    end;
    //オーダ指示 無い時もレコードは作成する
    res := func_MakeOrderIndicateTBL(wm_RisID, w_DLog);
    //異常終了の場合
    if not res then
    begin
      //ログ文字列作成
      proc_StrConcat(arg_LogBuffer, 'DB反映NG「オーダ指示レコード作成[' +
                     w_DLog + ']」');
      //p_errに移動
      goto p_err;
    end;
    //実績メイン
    res := func_MakeExMainTBL(wm_RisID, w_DLog);
    //異常終了の場合
    if not res then
    begin
      //ログ文字列作成
      proc_StrConcat(arg_LogBuffer, 'DB反映NG「実績メインレコード作成[' +
                     w_DLog + ']」');
      //p_errに移動
      goto p_err;
    end;
    //患者
    res := func_MakeKanjaTBL(wm_KanjaPatientID, w_DLog);
    //異常終了の場合
    if not res then
    begin
      //ログ文字列作成
      proc_StrConcat(arg_LogBuffer, 'DB反映NG「患者マスタレコード作成[' +
                     w_DLog + ']」');
      //p_errに移動
      goto p_err;
    end;
    //正常終了
    p_end:
      //DB変更確定
      FDB.Commit;
      //ログ文字列作成
      proc_StrConcat(arg_LogBuffer, 'DB反映OK');
      //戻り値
      Result := True;
      //処理終了
      Exit;
    //異常終了
    p_err:
      //DB変更取り消し
      FDB.Rollback;
      //戻り値
      Result := False;
      //処理終了
      Exit;
  except
    on E: Exception do
    begin
      //ログ文字列作成
      proc_StrConcat(arg_LogBuffer, 'DB反映NG「依頼DB新規 例外発生' +
                     E.Message + '」');
      //変更取り消し
      FDB.Rollback;
      //戻り値
      Result := False;
      //処理終了
      Exit;
    end;
  end;
end;
{
-----------------------------------------------------------------------------
  名前   : func_MakeRisID
  引数   :     arg_RecvMsgStream : TStringStream 受信電文
               arg_ID1           : String        HIS ID
           var arg_RISID         : String        RIS ID
           var arg_LogBuffer     : String        ログバッファ
  機能   : 1.RIS IDのを発番する
           2.オーダメインにレコードを追加する。
            （タイムラグを考慮して同時に行う）
  復帰値 : 例外は発生しない True 正常 False 異常
-----------------------------------------------------------------------------
}
function TDb_RisSvr_Irai.func_MakeRisID(     arg_ID1           : String;
                                         var arg_RISID         : String;
                                         var arg_LogBuffer     : String
                                        ):Boolean;
var
  res: Boolean;
  ws_ExamRoom: String;
  ws_Kiki: String;
  ws_Kensa_Date: String;
  ws_BirthDay: String;
  wd_KesaDate: TDate;
  wd_BirthDay: TDate;
  ws_Tel: String;

  sqlExec:  String;
  iRslt:    Integer;
begin
  res := True;
  //RIS_IDが作成されていない場合
  if arg_RISID = '' then
    //RISID作成
    res := func_MakeRisID_No(arg_ID1,arg_RISID,arg_LogBuffer);
  //異常終了の場合
  if not res then
  begin
    //戻り値
    Result := False;
    //処理終了
    Exit;
  end;
  try

    with FQ_ALT do begin
      //SQL文字列作成
      sqlExec := '';
      sqlExec := sqlExec + 'INSERT INTO ORDERMAINTABLE( ';
      sqlExec := sqlExec + 'RIS_ID,              ';  //RIS_ID
      sqlExec := sqlExec + 'SYSTEMKBN,           ';  //オーダ区分
      sqlExec := sqlExec + 'STUDYINSTANCEUID,    ';  //スタディーインスタンスUID
      sqlExec := sqlExec + 'ORDERNO,             ';  //オーダ番号
      sqlExec := sqlExec + 'ACCESSIONNO,         ';  //AccessionNo（オーダ番号と同じ）
      sqlExec := sqlExec + 'KENSA_DATE,          ';  //予定検査日
      sqlExec := sqlExec + 'KENSA_STARTTIME,     ';  //検査開始時刻
      sqlExec := sqlExec + 'KENSATYPE_ID,        ';  //検査種別ID
      sqlExec := sqlExec + 'KENSASITU_ID,        ';  //予定検査室ID
      sqlExec := sqlExec + 'KENSAKIKI_ID,        ';  //予定検査機器ID
      sqlExec := sqlExec + 'SYOTISITU_FLG,       ';  //処置室使用フラグ
      sqlExec := sqlExec + 'KANJA_ID,            ';  //患者ID
      sqlExec := sqlExec + 'KENSA_DATE_AGE,      ';  //予定検査時年齢
      sqlExec := sqlExec + 'DENPYO_NYUGAIKBN,    ';  //伝票入外区分
      sqlExec := sqlExec + 'DENPYO_BYOUTOU_ID,   ';  //伝票病棟ID
      sqlExec := sqlExec + 'DENPYO_BYOSITU_ID,   ';  //伝票病室ID
      sqlExec := sqlExec + 'IRAI_SECTION_ID,     ';  //依頼科ID
      sqlExec := sqlExec + 'IRAI_DOCTOR_NAME,    ';  //依頼医師名
      sqlExec := sqlExec + 'IRAI_DOCTOR_NO,      ';  //依頼医ID
      sqlExec := sqlExec + 'IRAI_DOCTOR_RENRAKU, ';  //依頼医連絡先
      sqlExec := sqlExec + 'DOKUEI_FLG           ';  //読影フラグ
      sqlExec := sqlExec + ') Values (';
      sqlExec := sqlExec + ':PRIS_ID,              ';  //RIS_ID
      sqlExec := sqlExec + ':PSYSTEMKBN,           ';  //オーダ区分
      sqlExec := sqlExec + ':PSTUDYINSTANCEUID,    ';  //スタディーインスタンスUID
      sqlExec := sqlExec + ':PORDERNO,             ';  //オーダ番号
      sqlExec := sqlExec + ':PACCESSIONNO,         ';  //AccessionNo（オーダ番号と同じ）
      sqlExec := sqlExec + ':PKENSA_DATE,          ';  //予定検査日
      sqlExec := sqlExec + ':PKENSA_STARTTIME,     ';  //検査開始時刻
      sqlExec := sqlExec + ':PKENSATYPE_ID,        ';  //検査種別ID
      sqlExec := sqlExec + ':PKENSASITU_ID,        ';  //予定検査室ID
      sqlExec := sqlExec + ':PKENSAKIKI_ID,        ';  //予定検査機器ID
      sqlExec := sqlExec + ':PSYOTISITU_FLG,       ';  //処置室使用フラグ
      sqlExec := sqlExec + ':PKANJA_ID,            ';  //患者ID
      sqlExec := sqlExec + ':PKENSA_DATE_AGE,      ';  //予定検査時年齢
      sqlExec := sqlExec + ':PDENPYO_NYUGAIKBN,    ';  //伝票入外区分
      sqlExec := sqlExec + ':PDENPYO_BYOUTOU_ID,   ';  //伝票病棟ID
      sqlExec := sqlExec + ':PDENPYO_BYOSITU_ID,   ';  //伝票病室ID
      sqlExec := sqlExec + ':PIRAI_SECTION_ID,     ';  //依頼科ID
      sqlExec := sqlExec + ':PIRAI_DOCTOR_NAME,    ';  //依頼医師名
      sqlExec := sqlExec + ':PIRAI_DOCTOR_NO,      ';  //依頼医ID
      sqlExec := sqlExec + ':PIRAI_DOCTOR_RENRAKU, ';  //依頼医連絡先
      sqlExec := sqlExec + ':PDOKUEI_FLG           ';  //読影フラグ
      sqlExec := sqlExec + ')';
      //SQL設定
      PrepareQuery(sqlExec);
      //パラメータ
      //RIS_ID
      SetParam('PRIS_ID', arg_RISID);
      //オーダ区分
      SetParam('PSYSTEMKBN', CST_ORDER_KBN_0);
      //初期化
      wm_StudyInstanceUID := '';
      //StudyInstanceUID固定部取得
      wm_StudyInstanceUID := func_Get_StudyInstanceUID;
      //スタディインスタンスUID作成
      wm_StudyInstanceUID := wm_StudyInstanceUID
                            + arg_RISID;
      //スタディインスタンスUID
      SetParam('PSTUDYINSTANCEUID', wm_StudyInstanceUID);
      //オーダNo
      SetParam('PORDERNO', wm_DataOrdeNo);
      //AccessionNo
      SetParam('PACCESSIONNO', wm_DataOrdeNo);
      //予定検査日付
      SetParam('PKENSA_DATE', IntToStr(StrToIntDef(wm_DataStartDate, 0)));
      //"0000"の場合は、時間を"9999"で登録をする
      if wm_DataStartTime = CST_JISSITIME_NULL then
        //予約時刻
        SetParam('PKENSA_STARTTIME', IntToStr(StrToIntDef(CST_JISSITIME_NULL3, 0)))
      else
        //予約時刻
        SetParam('PKENSA_STARTTIME', wm_DataStartTime + '00');
      //検査種別
      SetParam('PKENSATYPE_ID', wm_RISKensaType);
      //検査室決定
      proc_GetExamRoom(ws_ExamRoom);
      //予定検査室ID
      SetParam('PKENSASITU_ID', ws_ExamRoom);
      //検査機器決定
      proc_GetKiki(ws_Kiki);
      //予定検査機器ID
      SetParam('PKENSAKIKI_ID', ws_Kiki);
      // 処置室使用フラグ
      wm_SyotiRoom := '';
      // 放科医立会いフラグ
      wm_Tatiai    := '';
      //処置室使用、放科医師立会いフラグ取得
      proc_GetSyoti(wm_SyotiRoom,wm_Tatiai);
      //処置室使用フラグ
      SetParam('PSYOTISITU_FLG', wm_SyotiRoom);
      //患者ID
      SetParam('PKANJA_ID', wm_KanjaPatientID);
      //予定検査日がある場合
      if (wm_DataStartDate <> CST_JISSIDATE_NULL) and
        (wm_DataStartDate <> '') and
        (wm_KanjaBirthday <> '') then
      begin
        //検査日をフォーマット
        ws_Kensa_Date := func_Date8To10(wm_DataStartDate);
        //実施日の設定
        wd_KesaDate := func_StrToDate(ws_Kensa_Date);
        //生年月日をフォーマット
        ws_BirthDay := func_Date8To10(wm_KanjaBirthday);
        //生年月日の設定
        wd_BirthDay := func_StrToDate(ws_BirthDay);
        //年齢の設定
        wm_Kensa_Date_Age := func_GetAgeofCase(wd_BirthDay,wd_KesaDate,JUSIN_D);
      end
      //年齢計算ができない場合
      else
      begin
        wm_Kensa_Date_Age := CST_AGE_ERR;
      end;
      //検査時年齢
      SetParam('PKENSA_DATE_AGE', IntToStr(wm_Kensa_Date_Age));
      //伝票入外区分
      SetParam('PDENPYO_NYUGAIKBN', wm_DataInOutKbn);
      //伝票病棟ID
      SetParam('PDENPYO_BYOUTOU_ID', wm_KanjaWardCode);
      //伝票病室ID
      SetParam('PDENPYO_BYOSITU_ID', wm_KanjaSickroomCode);
      //依頼科ID
      SetParam('PIRAI_SECTION_ID', wm_DataSectionCode);
      //依頼医師名
      SetParam('PIRAI_DOCTOR_NAME', wm_DataDoctorName);
      //依頼利用者番号
      SetParam('PIRAI_DOCTOR_NO', wm_DataDoctorCode);
      //依頼部署ID
      //SetParam('PORDER_SECTION_ID', wm_DataBusyoCode);
      //依頼医連絡先の取得
      proc_GetDrTEL(wm_DataDoctorCode, ws_Tel);
      //依頼医連絡先
      SetParam('PIRAI_DOCTOR_RENRAKU', ws_Tel);
      //読影フラグ
      SetParam('PDOKUEI_FLG', wm_DataDokueiKbn);

      //SQL実行
      iRslt:= ExecSQL();
      if iRslt < 0 then begin
        //失敗
        Result := False;
        //切断
        wg_DBFlg := False;
        //
        Exit;
      end;
    end;

    //ログ文字列作成
    proc_StrConcat(arg_LogBuffer,'オーダメイン追加OK');
    //戻り値
    Result := True;
    //処理終了
    Exit;
  except
    //エラー終了処理
    on E:exception do
    begin
      //ログ文字列作成
      proc_StrConcat(arg_LogBuffer,'オーダメイン追加NG「例外発生 ' +
                     E.Message + '」');
      //戻り値
      Result := False;
      //切断
      wg_DBFlg := False;
      //処理終了
      Exit;
    end;
  end;
end;
{
-----------------------------------------------------------------------------
  名前   : func_MakeExMainTBL
  引数   : arg_RISID         : String        RIS_ID
           arg_LogBuffer     : String        付加エラー詳細
  機能   : 1.拡張オーダ情報の追加
  復帰値 : True 成功 False 失敗 例外は発生しない
-----------------------------------------------------------------------------
}
function  TDb_RisSvr_Irai.func_MakeOrderInfoTBL(    arg_RISID         : String;
                                                var arg_LogBuffer     : String
                                                ):Boolean;
var
  w_Count : Integer;
  w_res   : Boolean;
  ws_Date: String;
  ws_Time: String;
  ws_RI: String;
  ws_Portable: String;

  sqlExec:  String;
  iRslt:    Integer;

  wkHIS_HAKKO_DATE:   String;
  wkHIS_UPDATE_DATE:  String;

const
  WCST_Irai_Count = 1;
begin
  //重複チェック
  w_Count := func_CoutRecord('EXTENDORDERINFO','(RIS_ID = ''' + wm_RisID +
                             ''')');
  //重複したレコードがある場合
  if w_Count > 0 then
  begin
    //ありえないがあれば削除する
    w_res := func_DelRecord('EXTENDORDERINFO', '(RIS_ID = ''' + wm_RisID +
                            ''')');
    //異常終了の場合
    if not w_res then
    begin
      //ログ文字列作成
      proc_StrConcat(arg_LogBuffer,' 拡張オーダ情報追加 ID既存 RIS_ID = ' +
                     wm_RisID);
      //戻り値
      Result := False;
      //処理終了
      Exit;
    end;
  end;
  //再度重複チェック
  w_Count := func_CoutRecord('EXTENDORDERINFO', '(RIS_ID = ''' + wm_RisID +
                             ''')');
  //重複レコードがない場合
  if w_Count < 1 then
  begin
    try
      with FQ_ALT do begin
        //SQL文字列作成
        sqlExec := '';
        sqlExec := sqlExec + 'INSERT INTO EXTENDORDERINFO ( ';
        sqlExec := sqlExec + 'RIS_ID,             ';  //RIS_ID
        sqlExec := sqlExec + 'HIS_HAKKO_DATE,     ';  //HIS発行日時
        sqlExec := sqlExec + 'HIS_HAKKO_TERMINAL, ';  //HIS発行端末
        sqlExec := sqlExec + 'HIS_HAKKO_USER,     ';  //HIS発行利用者
        sqlExec := sqlExec + 'HIS_UPDATE_DATE,    ';  //HISオーダ書込日時
        sqlExec := sqlExec + 'RI_ORDER_FLG,       ';  //RIオーダ区分
        sqlExec := sqlExec + 'SATUEI_PLACE,       ';  //撮影場所
        sqlExec := sqlExec + 'YOTEIKAIKEI_FLG,    ';  //予定会計送信種別フラグ
        sqlExec := sqlExec + 'ISITATIAI_FLG,      ';  //放科医立会いフラグ
        sqlExec := sqlExec + 'PORTABLE_FLG,       ';  //ポータブルフラグ
        sqlExec := sqlExec + 'SIKYU_FLG,          ';  //至急フラグ
        sqlExec := sqlExec + 'SEISAN_FLG,         ';  //清算区分
        sqlExec := sqlExec + 'ADDENDUM01,         ';  //緊急区分
        sqlExec := sqlExec + 'ADDENDUM02,         ';  //至急現像区分
        sqlExec := sqlExec + 'ADDENDUM03,         ';  //予約区分
        sqlExec := sqlExec + 'ADDENDUM04          ';  //グループ数
        sqlExec := sqlExec + ') values (';
        sqlExec := sqlExec + ':PRIS_ID,             ';  //RIS_ID
        sqlExec := sqlExec + '%s, ';  //HIS発行日時
        //sqlExec := sqlExec + 'TO_DATE(:PHIS_HAKKO_DATE, ''YYYY/MM/DD''), ';  //HIS発行日時
        sqlExec := sqlExec + ':PHIS_HAKKO_TERMINAL, ';  //HIS発行端末
        sqlExec := sqlExec + ':PHIS_HAKKO_USER,     ';  //HIS発行利用者
        sqlExec := sqlExec + '%s, ';  //HISオーダ書込日時
        //sqlExec := sqlExec + 'TO_DATE(:PHIS_UPDATE_DATE, ''YYYY/MM/DD HH24:MI:SS''), ';  //HISオーダ書込日時
        sqlExec := sqlExec + ':PRI_ORDER_FLG,       ';  //RIオーダ区分
        sqlExec := sqlExec + ':PSATUEI_PLACE,       ';  //撮影場所
        sqlExec := sqlExec + ':PYOTEIKAIKEI_FLG,    ';  //予定会計送信種別フラグ
        sqlExec := sqlExec + ':PISITATIAI_FLG,      ';  //放科医立会いフラグ
        sqlExec := sqlExec + ':PPORTABLE_FLG,       ';  //ポータブルフラグ
        sqlExec := sqlExec + ':PSIKYU_FLG,          ';  //至急フラグ
        sqlExec := sqlExec + ':PSEISAN_FLG,         ';  //清算区分
        sqlExec := sqlExec + ':PADDENDUM01,         ';  //緊急区分
        sqlExec := sqlExec + ':PADDENDUM02,         ';  //至急現像区分
        sqlExec := sqlExec + ':PADDENDUM03,         ';  //予約区分
        sqlExec := sqlExec + ':PADDENDUM04          ';  //グループ数
        sqlExec := sqlExec + ')';
        //TO_DATE
        wkHIS_HAKKO_DATE  := 'TO_DATE(''%s'', ''YYYY/MM/DD'')';  //HIS発行日時
        wkHIS_UPDATE_DATE := 'TO_DATE(''%s'', ''YYYY/MM/DD HH24:MI:SS'')';  //HISオーダ書込日時
        //依頼年月日がある場合
        if wm_DataUpDateDate <> '' then begin
          //HIS発行日時
          wkHIS_HAKKO_DATE := Format(wkHIS_HAKKO_DATE, [func_Date8To10(wm_DataUpDateDate)]);
        end
        else begin
          //HIS発行日時
          wkHIS_HAKKO_DATE := 'NULL';
        end;
        //日付がある場合
        if wm_HeaderDate <> '' then
        begin
          //年がないので、取得する
          ws_Date := FormatDateTime('YYYY', FQ_SEL.GetSysDate);
          //年を追加
          ws_Date := ws_Date + wm_HeaderDate;
          //YYYY/MM/DDに設定
          ws_Date := func_Date8To10(ws_Date);
        end
        //日付が無い場合
        else
        begin
          //現時日付を設定
          ws_Date := FormatDateTime('YYYY/MM/DD', FQ_SEL.GetSysDate);
        end;
        //時刻がある場合
        if wm_HeaderTime <> '' then
        begin
          //変数に格納
          ws_Time := wm_HeaderTime;
          //HH:MM:SSに設定
          ws_Time := func_Time6To8(ws_Time);
        end
        //日付が無い場合
        else
        begin
          //現時日付を設定
          ws_Time := FormatDateTime('HH:MM:SS', FQ_SEL.GetSysDate);
        end;
        //HIS発行日時
        wkHIS_UPDATE_DATE := Format(wkHIS_UPDATE_DATE, [ws_Date + ' ' + ws_Time]);
        //SQL設定
        sqlExec := Format(sqlExec, [wkHIS_HAKKO_DATE, wkHIS_UPDATE_DATE]);
        PrepareQuery(sqlExec);
        //パラメータ
        //RIS_ID
        SetParam('PRIS_ID', arg_RISID);
        //HIS発行端末
        SetParam('PHIS_HAKKO_TERMINAL', '');
        //HIS発行利用者
        SetParam('PHIS_HAKKO_USER', '');
        //RIオーダ区分の取得
        proc_GetRi(ws_RI);
        //RIオーダ区分
        SetParam('PRI_ORDER_FLG', ws_RI);
        //撮影場所
        SetParam('PSATUEI_PLACE', '');
        //注射の場合
        if ws_RI = GPCST_RI_ORDER_1 then
          //予定会計送信種別フラグ
          SetParam('PYOTEIKAIKEI_FLG', g_RIOrder)
        else
          //予定会計送信種別フラグ
          SetParam('PYOTEIKAIKEI_FLG', GPCST_KAIKEI_1);
        //放科医立会いフラグ
        SetParam('PISITATIAI_FLG', wm_Tatiai);
        //ポータブルフラグ取得
        proc_GetPortable(ws_Portable);
        //ポータブルフラグ
        SetParam('PPORTABLE_FLG', ws_Portable);
        //至急フラグ
        SetParam('PSIKYU_FLG', wm_DataKinkyuKbn);
        //清算区分
        SetParam('PSEISAN_FLG', GPCST_SEISAN_0);
        //緊急区分
        SetParam('PADDENDUM01', wm_DataSikyuKbn);
        //至急現像区分
        SetParam('PADDENDUM02', wm_DataGenzoKbn);
        //予約区分
        SetParam('PADDENDUM03', wm_DataYoyakuKbn);
        //グループ数
        SetParam('PADDENDUM04', wm_DataGroupCount);
        //SQL実行
        iRslt:= ExecSQL();
        if iRslt < 0 then begin
          //失敗
          Result := False;
          //切断
          wg_DBFlg := False;
          //
          Exit;
        end;
        //ログ文字列作成
        proc_StrConcat(arg_LogBuffer,'拡張オーダ情報追加OK');
        //戻り値
        Result := True;
        //処理終了
        Exit;
      end;
      //成功
      Result := True;
    except
      on E: exception do
      begin
        //ログ文字列作成
        proc_StrConcat(arg_LogBuffer,' 拡張オーダ情報追加 例外発生「' +
                       E.Message + '」');
        //切断
        wg_DBFlg := False;
        //戻り値
        Result := False;
        //処理終了
        Exit;
      end;
    end;
  end
  //重複レコードがある場合
  else
  begin
    //UPDateではなくエラーとする
    proc_StrConcat(arg_LogBuffer,' 拡張オーダ情報追加 ID既存「RIS_ID = ' +
                   wm_RisID + '」');
    //戻り値
    Result := False;
    //処理終了
    Exit;
  end;
end;
{
-----------------------------------------------------------------------------
  名前   : func_MakeOrderBuiTBL
  引数   : arg_RISID         ris ID
           arg_LogBuffer     付加エラー詳細
  機能   : 1.オーダ部位・詳細テーブルの追加
  復帰値 : True 成功 False 失敗 例外は発生しない
-----------------------------------------------------------------------------
}
function  TDb_RisSvr_Irai.func_MakeOrderBuiTBL(     arg_RISID         : String;
                                                var arg_LogBuffer     : String
                                               ):Boolean;

var
  w_Count    : Integer;
  w_res      : Boolean;
  w_i1       : Integer;
  w_No       : Integer;
  WIComLoop : Integer;
  WSWork: String;

  sqlExec:    String;
  iRslt:      Integer;
begin
  //オーダ部位重複チェック
  w_Count := func_CoutRecord('OrderBuiTable', '(RIS_ID = ''' + wm_RisID +
                             ''') ');
  //重複レコードがある場合
  if w_Count > 0 then
  begin
    //ありえないがあれば削除する
    w_res := func_DelRecord('OrderBuiTable', '(RIS_ID = ''' + wm_RisID +
                            ''') ');
    //異常終了の場合
    if not w_res then
    begin
      //ログ文字列作成
      proc_StrConcat(arg_LogBuffer, ' オーダ部位追加 ID既存 RIS_ID = ' +
                     wm_RisID);
      //戻り値
      Result := False;
      //処理終了
      Exit;
    end;
  end;
  //ありえないがあれば削除する
  w_res := func_DelRecord('ORDERDETAILTABLE_MMH', '(RIS_ID = ''' + wm_RisID +
                          ''') ');
  //異常終了の場合
  if not w_res then
  begin
    //ログ文字列作成
    proc_StrConcat(arg_LogBuffer, ' オーダ詳細追加 ID既存 RIS_ID = ' +
                   wm_RisID);
    //戻り値
    Result := False;
    //処理終了
    Exit;
  end;
  //ありえないがあれば削除する
  w_res := func_DelRecord('ORDERSHEMATABLE', '(RIS_ID = ''' + wm_RisID +
                          ''')');
  //異常終了の場合
  if not w_res then
  begin
    //ログ文字列作成
    proc_StrConcat(arg_LogBuffer, ' オーダシェーマ追加 ID既存 RIS_ID = ' +
                   wm_RisID);
    //戻り値
    Result := False;
    //処理終了
    Exit;
  end;

  //部位連番
  w_No := 0;
  //部位数分
  for w_i1 := 0 to Length(wm_OrderBui) - 1 do
  begin
    //部位連番
    w_No := w_No + 1;
    WSWork := '';
    //オーダ部位追加
    try
      with FQ_ALT do begin
        //SQL文字列作成
        sqlExec := '';
        sqlExec := sqlExec + 'INSERT INTO ORDERBUITABLE (';
        sqlExec := sqlExec + 'RIS_ID,         '; //RIS_ID
        sqlExec := sqlExec + 'NO,             '; //部位情報連番
        sqlExec := sqlExec + 'BUISET_ID,      '; //部位セットID
        sqlExec := sqlExec + 'BUI_ID,         '; //部位ID
        sqlExec := sqlExec + 'HOUKOU_ID,      '; //方向ID
        sqlExec := sqlExec + 'SAYUU_ID,       '; //左右ID
        sqlExec := sqlExec + 'KENSAHOUHOU_ID, '; //検査方法ID
        sqlExec := sqlExec + 'BUIORDER_NO,    '; //部位オーダ番号
        sqlExec := sqlExec + 'KENSASITU_ID,   '; //検査室コード
        sqlExec := sqlExec + 'ADDENDUM01,     '; //コメント01
        sqlExec := sqlExec + 'ADDENDUM02,     '; //コメント02
        sqlExec := sqlExec + 'ADDENDUM03,     '; //コメント03
        sqlExec := sqlExec + 'BUICOMMENT      '; //部位コメント
        sqlExec := sqlExec + ' ) Values ( ';
        sqlExec := sqlExec + ':PRIS_ID,         '; //RIS_ID
        sqlExec := sqlExec + ':PNO,             '; //部位情報連番
        sqlExec := sqlExec + ':PBUISET_ID,      '; //部位セットID
        sqlExec := sqlExec + ':PBUI_ID,         '; //部位ID
        sqlExec := sqlExec + ':PHOUKOU_ID,      '; //方向ID
        sqlExec := sqlExec + ':PSAYUU_ID,       '; //左右ID
        sqlExec := sqlExec + ':PKENSAHOUHOU_ID, '; //検査方法ID
        sqlExec := sqlExec + ':PBUIORDER_NO,    '; //部位オーダ番号
        sqlExec := sqlExec + ':PKENSASITU_ID,   '; //検査室コード
        sqlExec := sqlExec + ':PADDENDUM01,     '; //コメント01
        sqlExec := sqlExec + ':PADDENDUM02,     '; //コメント02
        sqlExec := sqlExec + ':PADDENDUM03,     '; //コメント03
        sqlExec := sqlExec + ':PBUICOMMENT      '; //部位コメント
        sqlExec := sqlExec + ')';
        //SQL設定
        PrepareQuery(sqlExec);
        //パラメータ
        //RIS_ID
        SetParam('PRIS_ID', wm_RisID);
        //部位情報連番
        SetParam('PNO', IntToStr(w_No));
        //部位セットID
        SetParam('PBUISET_ID', wm_OrderBui[w_i1].KmkCode);
        //部位ID
        SetParam('PBUI_ID', wm_OrderBui[w_i1].BuiID);
        //方向ID
        SetParam('PHOUKOU_ID', wm_OrderBui[w_i1].HoukouID);
        //左右ID
        SetParam('PSAYUU_ID', wm_OrderBui[w_i1].SayuID);
        //検査方法ID
        SetParam('PKENSAHOUHOU_ID', wm_OrderBui[w_i1].HouhouID);
        //部位オーダ番号
        SetParam('PBUIORDER_NO', wm_OrderBui[w_i1].GroupNo);
        //検査室コード
        SetParam('PKENSASITU_ID', wm_OrderBui[w_i1].KensaRoomCode);
        //コメントがある場合
        if Length(wm_OrderBui[w_i1].Comment) > 0 then
        begin

          WSWork := '';
          for WIComLoop := 0 to Length(wm_OrderBui[w_i1].Comment) - 1 do
          begin
            if (wm_OrderBui[w_i1].Comment[WIComLoop].RecKbn = CST_RECORD_KBN_88) or
               (wm_OrderBui[w_i1].Comment[WIComLoop].RecKbn = CST_RECORD_KBN_97) or
               (wm_OrderBui[w_i1].Comment[WIComLoop].RecKbn = CST_RECORD_KBN_98) or
               (wm_OrderBui[w_i1].Comment[WIComLoop].RecKbn = CST_RECORD_KBN_99) then
            begin
              if WSWork = '' then
                WSWork := wm_OrderBui[w_i1].Comment[WIComLoop].RecKbn
              else
                WSWork := WSWork + ',' + wm_OrderBui[w_i1].Comment[WIComLoop].RecKbn;
            end;
          end;
          //コメント01
          SetParam('PADDENDUM01', func_BCopy(WSWork,20));
          WSWork := '';
          for WIComLoop := 0 to Length(wm_OrderBui[w_i1].Comment) - 1 do
          begin
            if (wm_OrderBui[w_i1].Comment[WIComLoop].RecKbn = CST_RECORD_KBN_88) or
               (wm_OrderBui[w_i1].Comment[WIComLoop].RecKbn = CST_RECORD_KBN_97) or
               (wm_OrderBui[w_i1].Comment[WIComLoop].RecKbn = CST_RECORD_KBN_98) or
               (wm_OrderBui[w_i1].Comment[WIComLoop].RecKbn = CST_RECORD_KBN_99) then
            begin
              if WSWork = '' then
                WSWork := wm_OrderBui[w_i1].Comment[WIComLoop].KmkCode
              else
                WSWork := WSWork + ',' + wm_OrderBui[w_i1].Comment[WIComLoop].KmkCode;
            end;
          end;
          //コメント02
          SetParam('PADDENDUM02', func_BCopy(WSWork,20));

          WSWork := '';
          for WIComLoop := 0 to Length(wm_OrderBui[w_i1].Comment) - 1 do
          begin
            if (wm_OrderBui[w_i1].Comment[WIComLoop].RecKbn = CST_RECORD_KBN_88) or
               (wm_OrderBui[w_i1].Comment[WIComLoop].RecKbn = CST_RECORD_KBN_97) or
               (wm_OrderBui[w_i1].Comment[WIComLoop].RecKbn = CST_RECORD_KBN_98) or
               (wm_OrderBui[w_i1].Comment[WIComLoop].RecKbn = CST_RECORD_KBN_99) then
            begin
              if WSWork = '' then
                WSWork := wm_OrderBui[w_i1].Comment[WIComLoop].KmkName
              else
                WSWork := WSWork + ',' + wm_OrderBui[w_i1].Comment[WIComLoop].KmkName;
            end;
          end;

          //部位コメント
          SetParam('PBUICOMMENT', func_BCopy(WSWork,100));
        end
        else
        begin
          //コメント01
          SetParam('PADDENDUM01', '');
          //コメント02
          SetParam('PADDENDUM02', '');
          //部位コメント
          SetParam('PBUICOMMENT', '');
        end;
        //コメント03
        SetParam('PADDENDUM03', wm_OrderBui[w_i1].MeisaiCount);

        //SQL実行
        iRslt:= ExecSQL();
        if iRslt < 0 then begin
          //失敗
          Result := False;
          //切断
          wg_DBFlg := False;
          //
          Exit;
        end;
      end;
      //成功
      Result := True;
    except
      on E: Exception do
      begin
        //ログ文字列作成
        proc_StrConcat(arg_LogBuffer,' オーダ部位追加 例外発生「' + E.Message + '」');
        //戻り値
        Result := False;
        //切断
        wg_DBFlg := False;
        //処理終了
        Exit;
      end;
    end;

    for WIComLoop := 0 to Length(wm_OrderBui[w_i1].Comment) - 1 do
    begin
      try
        with FQ_ALT do begin
          //SQL文字列作成
          sqlExec := '';
          sqlExec := sqlExec + 'INSERT INTO ORDERDETAILTABLE_MMH (';
          sqlExec := sqlExec + 'RIS_ID, '; //RIS_ID
          sqlExec := sqlExec + 'NO,     '; //部位情報連番
          sqlExec := sqlExec + 'COMNO,  '; //コメント情報連番
          sqlExec := sqlExec + 'KUBUN,  '; //区分
          sqlExec := sqlExec + 'ID,     '; //ID
          sqlExec := sqlExec + 'COM,    '; //コメント
          sqlExec := sqlExec + 'TEMP    '; //予備
          sqlExec := sqlExec + ' ) Values ( ';
          sqlExec := sqlExec + ':PRIS_ID, '; //RIS_ID
          sqlExec := sqlExec + ':PNO,     '; //部位情報連番
          sqlExec := sqlExec + ':PCOMNO,  '; //コメント情報連番
          sqlExec := sqlExec + ':PKUBUN,  '; //区分
          sqlExec := sqlExec + ':PID,     '; //ID
          sqlExec := sqlExec + ':PCOM,    '; //コメント
          sqlExec := sqlExec + ':PTEMP    '; //予備
          sqlExec := sqlExec + ')';
          //SQL設定
          PrepareQuery(sqlExec);
          //パラメータ
          //RIS_ID
          SetParam('PRIS_ID', wm_RisID);
          //部位情報連番
          SetParam('PNO', IntToStr(w_No));
          //コメント情報連番
          SetParam('PCOMNO', IntToStr(WIComLoop + 1));
          //区分
          SetParam('PKUBUN', wm_OrderBui[w_i1].Comment[WIComLoop].RecKbn);
          //ID
          SetParam('PID', wm_OrderBui[w_i1].Comment[WIComLoop].KmkCode);
          //コメント
          SetParam('PCOM', wm_OrderBui[w_i1].Comment[WIComLoop].KmkName);
          //予備
          SetParam('PTEMP', '');
          //SQL実行
          iRslt:= ExecSQL();
          if iRslt < 0 then begin
            //失敗
            Result := False;
            //切断
            wg_DBFlg := False;
            //
            Exit;
          end;
        end;
        //成功
        Result := True;
      except
        on E: Exception do
        begin
          //ログ文字列作成
          proc_StrConcat(arg_LogBuffer,' オーダ部位詳細追加 例外発生「' +
                         E.Message + '」');
          //戻り値
          Result := False;
          //切断
          wg_DBFlg := False;
          //処理終了
          Exit;
        end;
      end;
    end;

    for WIComLoop := 0 to Length(wm_OrderBui[w_i1].Schema) - 1 do
    begin
      try
        with FQ_ALT do begin
          //SQL文字列作成
          sqlExec := '';
          sqlExec := sqlExec + 'INSERT INTO ORDERSHEMATABLE (';
          sqlExec := sqlExec + 'RIS_ID,    '; //RIS_ID
          sqlExec := sqlExec + 'NO,        '; //部位情報連番
          sqlExec := sqlExec + 'SHEMANO,   '; //シェーマ連番
          sqlExec := sqlExec + 'SHEMAPATH '; //シェーマパス
          sqlExec := sqlExec + ' ) Values ( ';
          sqlExec := sqlExec + ':PRIS_ID,    '; //RIS_ID
          sqlExec := sqlExec + ':PNO,        '; //部位情報連番
          sqlExec := sqlExec + ':PSHEMANO,   '; //シェーマ連番
          sqlExec := sqlExec + ':PSHEMAPATH '; //シェーマパス
          sqlExec := sqlExec + ')';
          //SQL設定
          PrepareQuery(sqlExec);
          //パラメータ
          //RIS_ID
          SetParam('PRIS_ID', wm_RisID);
          //部位情報連番
          SetParam('PNO', IntToStr(w_No));
          //シェーマ連番
          SetParam('PSHEMANO', IntToStr(WIComLoop + 1));
          //シェーマパス
          SetParam('PSHEMAPATH', wm_OrderBui[w_i1].Schema[WIComLoop].SchemaInfo);
          //SQL実行
          iRslt:= ExecSQL();
          if iRslt < 0 then begin
            //失敗
            Result := False;
            //切断
            wg_DBFlg := False;
            //
            Exit;
          end;
        end;
        //成功
        Result := True;
      except
        on E: Exception do
        begin
          //ログ文字列作成
          proc_StrConcat(arg_LogBuffer,' オーダシェーマ追加 例外発生「' + E.Message + '」');
          //戻り値
          Result := False;
          //切断
          wg_DBFlg := False;
          //処理終了
          Exit;
        end;
      end;
    end;


  end;
  //戻り値
  Result := True;
  //処理終了
  Exit;
end;
{
-----------------------------------------------------------------------------
  名前   : func_MakeOrderIndicateTBL
  引数   : arg_RISID         : String        RIS_ID
           arg_LogBuffer     : String        付加エラー詳細
  機能   : 1.オーダ指示の追加
  復帰値 : True 成功 False 失敗 例外は発生しない
-----------------------------------------------------------------------------
}
function  TDb_RisSvr_Irai.func_MakeOrderIndicateTBL(     arg_RISID     : String;
                                                     var arg_LogBuffer : String
                                                    ):Boolean;
var
  w_Count   : Integer;
  w_res     : Boolean;
  WSWork,WSWork2,WSWorkData: String;
  WIComLoop: Integer;
  w_i1: Integer;
  WSKbn: String;

  sqlExec:  String;
  iRslt:    Integer;
begin
  //重複チェック
  w_Count := func_CoutRecord('ORDERINDICATETABLE', '(RIS_ID = ''' + wm_RisID +
                             ''') ');
  //重複レコードがある場合
  if w_Count > 0 then
  begin
    //ありえないがあれば削除する
    w_res := func_DelRecord('ORDERINDICATETABLE','(RIS_ID = ''' + wm_RisID +
                            ''') ');
    //異常終了の場合
    if not w_res then
    begin
      //ログ文字列作成
      proc_StrConcat(arg_LogBuffer, ' オーダ指示追加 ID既存 RIS_ID = ' +
                     wm_RisID);
      //戻り値
      Result := False;
      //処理終了
      Exit;
    end;
  end;

  try
    with FQ_ALT do begin
      //SQL文字列作成
      sqlExec := '';
      sqlExec := sqlExec + 'INSERT INTO ORDERINDICATETABLE (';
      sqlExec := sqlExec + 'RIS_ID,     '; //RIS_ID
      sqlExec := sqlExec + 'ORDERCOMMENT_ID, '; //
      sqlExec := sqlExec + 'KENSA_SIJI, '; //検査目的
      sqlExec := sqlExec + 'RINSYOU,    '; //臨床診断
      sqlExec := sqlExec + 'REMARKS     '; //備考
      sqlExec := sqlExec + ') Values (';
      sqlExec := sqlExec + ':PRIS_ID,     '; //RIS_ID
      sqlExec := sqlExec + ':PORDERCOMMENT_ID, '; //
      sqlExec := sqlExec + ':PKENSA_SIJI, '; //検査目的
      sqlExec := sqlExec + ':PRINSYOU,    '; //臨床診断
      sqlExec := sqlExec + ':PREMARKS     '; //備考
      sqlExec := sqlExec + ')';
      //SQL設定
      PrepareQuery(sqlExec);
      //パラメータ
      //RIS_ID
      SetParam('PRIS_ID', wm_RisID);

      WSWorkData := '';

      WSWork := '';
      for w_i1 := 0 to Length(wm_OrderBui) - 1 do
      begin
        for WIComLoop := 0 to Length(wm_OrderBui[w_i1].Comment) - 1 do
        begin
          if (wm_OrderBui[w_i1].Comment[WIComLoop].RecKbn = CST_RECORD_KBN_88) then
          begin
            if WSWork = '' then
              WSWork := CST_RECORD_KBN_88_TITLE + wm_OrderBui[w_i1].Comment[WIComLoop].KmkName
            else
              WSWork := WSWork + wm_OrderBui[w_i1].Comment[WIComLoop].KmkName;
          end;
        end;
      end;

      WSWork2 := '';
      for w_i1 := 0 to Length(wm_OrderBui) - 1 do
      begin
        for WIComLoop := 0 to Length(wm_OrderBui[w_i1].Comment) - 1 do
        begin
          if (wm_OrderBui[w_i1].Comment[WIComLoop].RecKbn = CST_RECORD_KBN_90) then
          begin
            if WSWork2 = '' then
              WSWork2 := CST_RECORD_KBN_90_TITLE + wm_OrderBui[w_i1].Comment[WIComLoop].KmkName
            else
              WSWork2 := WSWork2 + wm_OrderBui[w_i1].Comment[WIComLoop].KmkName;
          end;
        end;
      end;

      WSWorkData := WSWork;

      if WSWork2 <> '' then
      begin
        if WSWorkData <> '' then
          WSWorkData := WSWorkData + #13#10 + WSWork2
        else
          WSWorkData := WSWork2;
      end;

      WSKbn := '';

      if wm_DataSikyuKbn = '1' then
        WSKbn := 'KUBUN1';

      if wm_DataGenzoKbn = '1' then
      begin
        if WSKbn <> '' then
          WSKbn := WSKbn + '|KUBUN2'
        else
          WSKbn := 'KUBUN2';
      end;

      if WSKbn <> '' then
      begin
        WSWorkData := WSKbn + '|' + #13#10 + WSWorkData;
      end;
      //
      SetParam('PORDERCOMMENT_ID', func_BCopy(WSWorkData,256));

      WSWorkData := '';
      WSWork := '';
      WSWorkData := wm_DataMokutekiCom;
      if WSWork <> '' then
      begin
        if WSWorkData <> '' then
          WSWorkData := WSWorkData + #13#10 + WSWork
        else
          WSWorkData := WSWork;
      end;

      //検査目的
      SetParam('PKENSA_SIJI', func_BCopy(WSWorkData, 2000));

      WSWorkData := '';

      WSWork := '';
      WSWorkData := wm_DataByoumeiCom;

      if WSWork <> '' then
      begin
        if WSWorkData <> '' then
          WSWorkData := WSWorkData + #13#10 + WSWork
        else
          WSWorkData := WSWork;
      end;
      //臨床診断
      SetParam('PRINSYOU', func_BCopy(wm_DataByoumeiCom, 2000));
      WSWorkData := '';
      WSWork := '';
      WSWork2 := '';
      WSWorkData := wm_DataSonotaCom;
      if wm_DataSijiCom <> '' then
      begin
        if WSWorkData <> '' then
          WSWorkData := WSWorkData + #13#10 + wm_DataSijiCom
        else
          WSWorkData := wm_DataSijiCom;
      end;

      if WSWork <> '' then
      begin
        if WSWorkData <> '' then
          WSWorkData := WSWorkData + #13#10 + WSWork
        else
          WSWorkData := WSWork;
      end;

      if WSWork2 <> '' then
      begin
        if WSWorkData <> '' then
          WSWorkData := WSWorkData + #13#10 + WSWork2
        else
          WSWorkData := WSWork2;
      end;
      //備考
      SetParam('PREMARKS',WSWorkData);

      //SQL実行
      iRslt:= ExecSQL();
      if iRslt < 0 then begin
        //失敗
        Result := False;
        //切断
        wg_DBFlg := False;
        //
        Exit;
      end;
    end;
    //成功
    Result := True;
  except
    on E: Exception do
    begin
      //ログ文字列作成
      proc_StrConcat(arg_LogBuffer, ' オーダ指示追加 例外発生「' + E.Message +
                     '」');
      //戻り値
      Result := False;
      //切断
      wg_DBFlg := False;
      //処理終了
      Exit;
    end;
  end;
end;
{
-----------------------------------------------------------------------------
  名前   : func_MakeOrderShemaTBL
  引数   : arg_RISID         : String        RIS_ID
           arg_LogBuffer     : String        付加エラー詳細
  機能   : 1.オーダシェーマの追加
  復帰値 : True 成功 False 失敗 例外は発生しない
-----------------------------------------------------------------------------
}
function  TDb_RisSvr_Irai.func_MakeOrderShemaTBL(    arg_RISID     : String;
                                                 var arg_LogBuffer : String
                                                 ):Boolean;
var
  w_Count: Integer;
  w_res: Boolean;
  wi_LoopBui: Integer;
  wi_LoopShe: Integer;
  wi_NoCount: Integer;

  sqlExec:  String;
  iRslt:    Integer;
begin
  //戻り値
  Result := True;
  //重複チェック
  w_Count := func_CoutRecord('ORDERSHEMAINFO', '(RIS_ID = ''' + wm_RisID +
                             ''') ');
  //重複レコードがある場合
  if w_Count > 0 then
  begin
    //ありえないがあれば削除する
    w_res := func_DelRecord('ORDERSHEMAINFO','(RIS_ID = ''' + wm_RisID +
                            ''') ');
    //異常終了の場合
    if not w_res then
    begin
      //ログ文字列作成
      proc_StrConcat(arg_LogBuffer, ' オーダシェーマ追加 ID既存 RIS_ID = ' +
                     wm_RisID);
      //戻り値
      Result := False;
      //処理終了
      Exit;
    end;
  end;

  //初期化
  wi_NoCount := 0;
  for wi_LoopBui := 0 to Length(wm_OrderBui) - 1 do
  begin
    for wi_LoopShe := 0 to Length(wm_OrderBui[wi_LoopBui].Schema) - 1 do
    begin
      //No+1
      inc(wi_NoCount);

      try
        with FQ_ALT do begin
          //SQL文字列作成
          sqlExec := '';
          sqlExec := sqlExec + 'INSERT INTO ORDERSHEMAINFO (';
          sqlExec := sqlExec + 'RIS_ID,        '; //RIS_ID
          sqlExec := sqlExec + 'NO,            '; //連番
          sqlExec := sqlExec + 'SHEMAPATH,     '; //シェーマ格納先
          sqlExec := sqlExec + 'SHEMAATTRIBUTE '; //シェーマ属性情報
          sqlExec := sqlExec + ') Values (';
          sqlExec := sqlExec + ':PRIS_ID,        '; //RIS_ID
          sqlExec := sqlExec + ':PNO,            '; //連番
          sqlExec := sqlExec + ':PSHEMAPATH,     '; //シェーマ格納先
          sqlExec := sqlExec + ':PSHEMAATTRIBUTE '; //シェーマ属性情報
          sqlExec := sqlExec + ')';
          //SQL設定
          PrepareQuery(sqlExec);
          //パラメータ
          //RIS_ID
          SetParam('PRIS_ID', wm_RisID);
          //連番
          SetParam('PNO', IntToStr(wi_NoCount));
          //シェーマ格納先
          SetParam('PSHEMAPATH', wm_OrderBui[wi_LoopBui].Schema[wi_LoopShe].SchemaInfo);
          //シェーマ属性情報
          SetParam('PSHEMAATTRIBUTE', wm_OrderBui[wi_LoopBui].KmkName);
          //SQL実行
          iRslt:= ExecSQL();
          if iRslt < 0 then begin
            //失敗
            Result := False;
            //切断
            wg_DBFlg := False;
            //
            Exit;
          end;
        end;
        //成功
        Result := True;
      except
        on E: Exception do
        begin
          //ログ文字列作成
          proc_StrConcat(arg_LogBuffer, ' オーダシェーマ追加 例外発生「' +
                         E.Message + '」');
          //戻り値
          Result := False;
          //切断
          wg_DBFlg := False;
          //処理終了
          Exit;
        end;
      end;
    end;
  end;
end;
{
-----------------------------------------------------------------------------
  名前   : func_MakeExMainTBL
  引数   : arg_RISID         : String        RIS_ID
           arg_LogBuffer     : String        付加エラー詳細
  機能   : 1.実績メインの追加
  復帰値 : True 成功 False 失敗 例外は発生しない
-----------------------------------------------------------------------------
}
function  TDb_RisSvr_Irai.func_MakeExMainTBL(    arg_RISID     : String;
                                             var arg_LogBuffer : String
                                             ):Boolean;
var
  w_Count: Integer;
  w_res: Boolean;

  sqlExec:  String;
  iRslt:    Integer;
begin
  //重複チェック
  w_Count := func_CoutRecord('EXMAINTABLE', '(RIS_ID = ''' + wm_RisID +
                             ''') ');
  //重複レコードがある場合
  if w_Count > 0 then
  begin
    //ありえないがあれば削除する
    w_res := func_DelRecord('EXMAINTABLE','(RIS_ID = ''' + wm_RisID +
                            ''') ');
    //異常終了の場合
    if not w_res then
    begin
      //ログ文字列作成
      proc_StrConcat(arg_LogBuffer, ' 実績メイン追加 ID既存 RIS_ID = ' +
                     wm_RisID);
      //戻り値
      Result := False;
      //処理終了
      Exit;
    end;
  end;
  try
    with FQ_ALT do begin
      //SQL文字列作成
      sqlExec := '';
      sqlExec := sqlExec + 'INSERT INTO EXMAINTABLE (';
      sqlExec := sqlExec + 'RIS_ID,   '; //RIS_ID
      sqlExec := sqlExec + 'KANJA_ID  '; //患者ID
      sqlExec := sqlExec + ') Values (';
      sqlExec := sqlExec + ':PRIS_ID,   '; //RIS_ID
      sqlExec := sqlExec + ':PKANJA_ID  '; //患者ID
      sqlExec := sqlExec + ')';
      //SQL設定
      PrepareQuery(sqlExec);
      //パラメータ
      //RIS_ID
      SetParam('PRIS_ID', wm_RisID);
      //患者ID
      SetParam('PKANJA_ID', wm_KanjaPatientID);
      //SQL実行
      iRslt:= ExecSQL();
      if iRslt < 0 then begin
        //失敗
        Result := False;
        //切断
        wg_DBFlg := False;
        //
        Exit;
      end;
    end;
    //成功
    Result := True;
  except
    on E: Exception do
    begin
      //ログ文字列作成
      proc_StrConcat(arg_LogBuffer, ' 実績メイン追加 例外発生「' +
                     E.Message + '」');
      //戻り値
      Result := False;
      //切断
      wg_DBFlg := False;
      //処理終了
      Exit;
    end;
  end;
end;
{
-----------------------------------------------------------------------------
  名前   : func_UpdateRisDBIraiUp
  引数   :     arg_RecvMsgStream : TStringStream 受信電文
           var arg_LogBuffer     : String        ログバッファエリア
  機能   : 1.依頼電文の内容をRIS DBに更新する
  復帰値 : True 正常 False 異常 例外は発生しない
-----------------------------------------------------------------------------
}
function  TDb_RisSvr_Irai.func_UpdateRisDBIraiUp(
                                                  var arg_LogBuffer : String
                                                 ):Boolean;
var
  res    : Boolean;
  w_DLog : String;
label
  p_end,p_err;
begin
  //トランザクション開始
  FDB.StartTransaction;
  try
    //ログ文字列初期化
    w_DLog := '';
    //オーダメイン対象RISIDをロック
    res := func_LockTbl('ORDERMAINTABLE','RIS_ID','RIS_ID = ''' + wm_RisID +
                        '''','nowait');
    //異常終了の場合
    if not res then
    begin
      //ログ文字列作成
      proc_StrConcat(arg_LogBuffer, 'DB反映NG「オーダメインロックRIS_ID = ' +
                     wm_RisID + '」');
      //p_errに移動
      goto p_err;
    end;
    //オーダメイン
    res := func_DelRecord('ORDERMAINTABLE', 'RIS_ID = ''' + wm_RisID + ''' ');
    //異常終了の場合
    if not res then
    begin
      //ログ文字列作成
      proc_StrConcat(arg_LogBuffer, 'DB反映NG「オーダメイン削除」');
      //p_errへ移動
      goto p_err;
    end;
    //拡張オーダ情報
    res := func_DelRecord('EXTENDORDERINFO', 'RIS_ID = ''' + wm_RisID + ''' ');
    //異常終了の場合
    if not res then
    begin
      //ログ文字列作成
      proc_StrConcat(arg_LogBuffer, 'DB反映NG「拡張オーダ情報削除」');
      //p_errへ移動
      goto p_err;
    end;
    //オーダ部位
    res := func_DelRecord('ORDERBUITABLE', 'RIS_ID = ''' + wm_RisID + ''' ');
    //異常終了の場合
    if not res then
    begin
      //ログ文字列作成
      proc_StrConcat(arg_LogBuffer, 'DB反映NG「オーダ部位削除」');
      //p_errへ移動
      goto p_err;
    end;
    //オーダ指示
    res := func_DelRecord('ORDERINDICATETABLE','RIS_ID = ''' + wm_RisID +
                          ''' ');
    //異常終了の場合
    if not res then
    begin
      //ログ文字列作成
      proc_StrConcat(arg_LogBuffer, 'DB反映NG「オーダ指示削除」');
      //p_errへ移動
      goto p_err;
    end;
    //オーダ部位詳細
    res := func_DelRecord('ORDERDETAILTABLE_MMH','RIS_ID = ''' + wm_RisID +
                          ''' ');
    //異常終了の場合
    if not res then
    begin
      //ログ文字列作成
      proc_StrConcat(arg_LogBuffer, 'DB反映NG「オーダ部位詳細削除」');
      //p_errへ移動
      goto p_err;
    end;
    //オーダシェーマ
    res := func_DelRecord('ORDERSHEMATABLE','RIS_ID = ''' + wm_RisID +
                          ''' ');
    //異常終了の場合
    if not res then
    begin
      //ログ文字列作成
      proc_StrConcat(arg_LogBuffer, 'DB反映NG「オーダシェーマ削除」');
      //p_errへ移動
      goto p_err;
    end;

    //ログ文字列初期化
    w_DLog := '';
    //RISID作成
    res := func_MakeRisID(wm_DataOrdeNo, wm_RisID, w_DLog);
    //異常終了の場合
    if not res then
    begin
      //ログ文字列作成
      proc_StrConcat(arg_LogBuffer, 'DB反映NG「オーダメインレコード作成[' +
                     w_DLog + ']」');
      //p_errに移動
      goto p_err;
    end;
    //オーダメイン対象RISIDをロック
    res := func_LockTbl('OrderMainTable', 'Ris_ID', 'Ris_ID = ''' + wm_RisID +
                        '''', 'nowait');
    //異常終了の場合
    if not res then
    begin
      //ログ文字列作成
      proc_StrConcat(arg_LogBuffer, 'DB反映NG「オーダメインロックRIS_ID = ' +
                     wm_RisID + '」');
      //p_errに移動
      goto p_err;
    end;

    //実績メイン情報
    res := func_UpExMainTBL(wm_RisID, w_DLog);
    //異常終了の場合
    if not res then
    begin
      //ログ文字列作成
      proc_StrConcat(arg_LogBuffer, 'DB反映NG「実績メイン情報レコード作成[ '
                     + w_DLog + ']」');
      //p_errに移動
      goto p_err;
    end;


    //拡張オーダ情報
    res := func_MakeOrderInfoTBL(wm_RisID, w_DLog);
    //異常終了の場合
    if not res then
    begin
      //ログ文字列作成
      proc_StrConcat(arg_LogBuffer, 'DB反映NG「拡張オーダ情報レコード作成[ '
                     + w_DLog + ']」');
      //p_errに移動
      goto p_err;
    end;
    //オーダ部位・詳細
    res := func_MakeOrderBuiTBL(wm_RisID, w_DLog);
    //異常終了の場合
    if not res then
    begin
      //ログ文字列作成
      proc_StrConcat(arg_LogBuffer, 'DB反映NG「部位レコード作成[' + w_DLog +
                     ']」');
      //p_errに移動
      goto p_err;
    end;
    //オーダ指示 無い時もレコードは作成する
    res := func_MakeOrderIndicateTBL(wm_RisID, w_DLog);
    //異常終了の場合
    if not res then
    begin
      //ログ文字列作成
      proc_StrConcat(arg_LogBuffer, 'DB反映NG「オーダ指示レコード作成[' +
                     w_DLog + ']」');
      //p_errに移動
      goto p_err;
    end;
    //患者
    res := func_MakeKanjaTBL(wm_KanjaPatientID, w_DLog);
    //異常終了の場合
    if not res then
    begin
      //ログ文字列作成
      proc_StrConcat(arg_LogBuffer, 'DB反映NG「患者マスタレコード作成[' +
                     w_DLog + ']」');
      //p_errに移動
      goto p_err;
    end;
    //正常終了
    p_end:
      //DB変更確定
      FDB.Commit;
      //ログ文字列作成
      proc_StrConcat(arg_LogBuffer,'DB反映OK');
      //戻り値
      Result := True;
      //処理終了
      Exit;
    //異常終了
    p_err:
      //DB変更取り消し
      FDB.Rollback;
      //戻り値
      Result := False;
      //処理終了
      Exit;
  except
    on E: Exception do
    begin
      //ログ文字列作成
      proc_StrConcat(arg_LogBuffer, 'DB反映NG「依頼DB変更 例外発生' +
                     E.Message + '」');
      //変更取り消し
      FDB.Rollback;
      //戻り値
      Result := False;
      //処理終了
      Exit;
    end;
  end;
end;
{
-----------------------------------------------------------------------------
  名前   : func_MakeExMainTBL
  引数   : arg_RISID         : String        RIS_ID
           arg_LogBuffer     : String        付加エラー詳細
  機能   : 1.実績メインの追加
  復帰値 : True 成功 False 失敗 例外は発生しない
-----------------------------------------------------------------------------
}
function  TDb_RisSvr_Irai.func_UpExMainTBL(    arg_RISID     : String;
                                           var arg_LogBuffer : String
                                           ):Boolean;
var
  sqlExec:  String;
  iRslt:    Integer;
begin
  try
    with FQ_ALT do begin
      //SQL文字列作成
      sqlExec := '';
      sqlExec := sqlExec + 'UPDATE EXMAINTABLE SET ';
      sqlExec := sqlExec + '  KANJA_ID = :PKANJA_ID ';  //患者ID
      sqlExec := sqlExec + ' ,STATUS = 0 ';             //2018/08/30 検査進捗　更新
      sqlExec := sqlExec + 'WHERE RIS_ID = :PRIS_ID';
      //SQL設定
      PrepareQuery(sqlExec);
      //パラメータ
      //RIS_ID
      SetParam('PRIS_ID', wm_RisID);
      //患者ID
      SetParam('PKANJA_ID', wm_KanjaPatientID);
      //SQL実行
      iRslt:= ExecSQL();
      if iRslt < 0 then begin
        //失敗
        Result := False;
        //切断
        wg_DBFlg := False;
        //
        Exit;
      end;
    end;
    //成功
    Result := True;
  except
    on E: Exception do
    begin
      //ログ文字列作成
      proc_StrConcat(arg_LogBuffer, ' 実績メイン更新 例外発生「' +
                     E.Message + '」');
      //戻り値
      Result := False;
      //切断
      wg_DBFlg := False;
      //処理終了
      Exit;
    end;
  end;
end;
{
-----------------------------------------------------------------------------
  名前   : func_UpdateRisDBPatient
  引数   : var arg_LogBuffer     : String        ログバッファエリア
  機能   : 1.患者電文の内容をRIS DBに更新する
  復帰値 : True 正常 False 異常 例外は発生しない
-----------------------------------------------------------------------------
}
function  TDb_RisSvr_Irai.func_UpdateRisDBPatient(
                                                  var arg_LogBuffer : String
                                                  ):Boolean;
var
  res    : Boolean;
  WB_RisRes    : Boolean;
  WB_TheraRisRes    : Boolean;
//  WB_ReportRes    : Boolean;
  w_DLog : String;
  w_Count : Integer;
//  ws_Svc_ID: String;
label
  p_end, p_err;  //,p_TheraRisend,p_TheraRiserr;
begin
  WB_RisRes := True;
  WB_TheraRisRes := True;
  try
    //トランザクション開始
    FDB.StartTransaction;
    //重複チェック
    w_Count := func_CoutRecord('PATIENTINFO', '(KANJA_ID = ''' + wm_KanjaPatientID
                               + ''') ');
    //レコードがある場合
    if w_Count > 0 then
    begin
      //患者
      res := func_MakeKanjaTBL(wm_KanjaPatientID, w_DLog);
      //異常終了の場合
      if not res then
      begin
        //ログ文字列作成
        proc_StrConcat(arg_LogBuffer, 'RISDB反映NG「患者マスタレコード作成[' +
                       w_DLog + ']」');
        //p_errに移動
        goto p_err;
      end;
    end
    else begin
      //ログ文字列作成
      proc_StrConcat(arg_LogBuffer, 'RISDB反映NG「患者マスタレコード作成[指定の患者IDは存在しません。= ' +
                     wm_KanjaPatientID + ']」');
      //p_errに移動
      goto p_err;
    end;
    //正常終了
    p_end:
      //DB変更確定
      FDB.Commit;
      //ログ文字列作成
      proc_StrConcat(arg_LogBuffer,'RISDB反映OK');
    if not res then
    begin
      //異常終了
      p_err:
        //DB変更取り消し
        FDB.Rollback;
        //戻り値
        WB_RisRes := False;
    end;
  except
    on E: Exception do
    begin
      //ログ文字列作成
      proc_StrConcat(arg_LogBuffer, 'RISDB反映NG「患者情報変更 例外発生' +
                     E.Message + '」');
      //変更取り消し
      FDB.Rollback;
      //戻り値
      WB_RisRes := False;
    end;
  end;

  WB_TheraRisRes := True;

  if (WB_RisRes) or
     (WB_TheraRisRes)then
    Result := True
  else
    Result := False;

end;
{
-----------------------------------------------------------------------------
  名前   : func_UpdateRisDBIraiDel
  引数   :     arg_RecvMsgStream : TStringStream 受信電文
           var arg_LogBuffer     : String        付加エラー詳細
  機能   : 1.依頼電文の内容をRIS DBに新規作成する
  復帰値 : True 正常 False 異常 例外は発生しない
-----------------------------------------------------------------------------
}
function  TDb_RisSvr_Irai.func_UpdateRisDBIraiDel(
                                                  var arg_LogBuffer : String
                                                  ):Boolean;
var
  res:boolean;
//  w_DLog: String;
label
  p_end,p_err;
begin
  //トランザクション開始
  FDB.StartTransaction;
  try
    //オーダメイン対象RISIDをロック
    res := func_LockTbl('ORDERMAINTABLE','RIS_ID','RIS_ID = ''' + wm_RisID +
                        '''','nowait');
    //異常終了の場合
    if not res then
    begin
      //ログ文字列作成
      proc_StrConcat(arg_LogBuffer, 'DB反映NG「オーダメインロックRIS_ID = ' +
                     wm_RisID + '」');
      //p_errに移動
      goto p_err;
    end;
    //オーダメイン
    res := func_DelRecord('ORDERMAINTABLE', 'RIS_ID = ''' + wm_RisID + ''' ');
    //異常終了の場合
    if not res then
    begin
      //ログ文字列作成
      proc_StrConcat(arg_LogBuffer, 'DB反映NG「オーダメイン削除」');
      //p_errへ移動
      goto p_err;
    end;
    //実績メイン
    res := func_DelRecord('EXMAINTABLE', 'RIS_ID = ''' + wm_RisID + ''' ');
    //異常終了の場合
    if not res then
    begin
      //ログ文字列作成
      proc_StrConcat(arg_LogBuffer, 'DB反映NG「実績メイン削除」');
      //p_errへ移動
      goto p_err;
    end;
    //拡張オーダ情報
    res := func_DelRecord('EXTENDORDERINFO', 'RIS_ID = ''' + wm_RisID + ''' ');
    //異常終了の場合
    if not res then
    begin
      //ログ文字列作成
      proc_StrConcat(arg_LogBuffer, 'DB反映NG「拡張オーダ情報削除」');
      //p_errへ移動
      goto p_err;
    end;
    //オーダ部位
    res := func_DelRecord('ORDERBUITABLE', 'RIS_ID = ''' + wm_RisID + ''' ');
    //異常終了の場合
    if not res then
    begin
      //ログ文字列作成
      proc_StrConcat(arg_LogBuffer, 'DB反映NG「オーダ部位削除」');
      //p_errへ移動
      goto p_err;
    end;
    //オーダ指示
    res := func_DelRecord('ORDERINDICATETABLE','RIS_ID = ''' + wm_RisID +
                          ''' ');
    //異常終了の場合
    if not res then
    begin
      //ログ文字列作成
      proc_StrConcat(arg_LogBuffer, 'DB反映NG「オーダ指示削除」');
      //p_errへ移動
      goto p_err;
    end;
    //オーダ部位詳細
    res := func_DelRecord('ORDERDETAILTABLE_MMH','RIS_ID = ''' + wm_RisID +
                          ''' ');
    //異常終了の場合
    if not res then
    begin
      //ログ文字列作成
      proc_StrConcat(arg_LogBuffer, 'DB反映NG「オーダ部位詳細削除」');
      //p_errへ移動
      goto p_err;
    end;
    //オーダシェーマ
    res := func_DelRecord('ORDERSHEMATABLE','RIS_ID = ''' + wm_RisID +
                          ''' ');
    //異常終了の場合
    if not res then
    begin
      //ログ文字列作成
      proc_StrConcat(arg_LogBuffer, 'DB反映NG「オーダシェーマ削除」');
      //p_errへ移動
      goto p_err;
    end;
    //正常終了
    p_end:
      //変更の確定
      FDB.Commit;
      //ログ文字列作成
      proc_StrConcat(arg_LogBuffer,'DB反映OK');
      //戻り値
      Result := True;
      //処理終了
      Exit;
    //異常終了
    p_err:
      //変更の取り消し
      FDB.Rollback;
      //戻り値
      Result := False;
      //処理終了
      Exit;
  except
    on E: exception do
    begin
      //ログ文字列作成
      proc_StrConcat(arg_LogBuffer, '依頼DB削除NG「例外発生' + E.Message +
                     '」');
      //変更の取り消し
      FDB.Rollback;
      //戻り値
      Result := False;
      //処理終了
      Exit;
    end;
  end
end;
{
-----------------------------------------------------------------------------
  名前   : func_MakeRisID_No
  引数   :     arg_ID1       : String HIS ID
           var arg_RISID     : String RIS ID
           var arg_LogBuffer : String ログバッファ
  機能   : RIS IDのを発番する
  復帰値 : True 正常 False 異常 例外は発生しない
-----------------------------------------------------------------------------
}
function  TDb_RisSvr_Irai.func_MakeRisID_No(    arg_ID1       : String;
                                            var arg_RISID     : String;
                                            var arg_LogBuffer : String
                                            ):Boolean;
var
  w_Sysdate  : TDateTime;
  w_RisNo    : Integer;
begin
  //初期値設定
  Result := True;
  //初期化
  arg_RISID := '';
  //Ris IDの生成
  //現在日時
  w_Sysdate  := FQ_SEL.GetSysDate;

  //Ris_ID発番
  w_RisNo := FQ_SEL.GetSequence('RISIDSEQUENCE');
  //Ris_IDが発番失敗の場合
  if w_RisNo <= 0 then
  begin
    //ログ文字列作成
    proc_StrConcat(arg_LogBuffer,'RIS_ID=' + '');
    //ログ文字列作成
    proc_StrConcat(arg_LogBuffer,'ID1='+wm_DataOrdeNo);
    //ログ文字列作成
    proc_StrConcat(arg_LogBuffer,'ID2='+wm_KanjaPatientID);
    //ログ文字列作成
    proc_StrConcat(arg_LogBuffer,'RIS_ID採番エラーNG「（RIS ID発番）」');
    //戻り値
    Result := False;
    //処理終了
    Exit;
  end;

  //RIS_ID作成
  arg_RISID := FormatDateTime('YYYYMMDD',w_Sysdate) +
               FormatCurr('00000000', w_RisNo);
  //ログ文字列作成
  proc_StrConcat(arg_LogBuffer,'RIS_ID=' + arg_RISID);
  //ログ文字列作成
  proc_StrConcat(arg_LogBuffer,'ID1='+wm_DataOrdeNo);
  //ログ文字列作成
  proc_StrConcat(arg_LogBuffer,'ID2='+wm_KanjaPatientID);
  //ログ文字列作成
  proc_StrConcat(arg_LogBuffer,'RIS_ID採番OK');
end;
//==============================================================================
//Main系DBチェック処理↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓
//==============================================================================
{
-----------------------------------------------------------------------------
  名前   : func_InquireMsgForDB
  引数   : arg_System        : String        作成マシン
           arg_MsgKind       : String        電文種別
           arg_RecvMsgStream : TStringStream 受信電文
           arg_TDate         : TDateTime     受信日時
           arg_LogBuffer     : String        ログバッファエリア
  機能   : 5 RIS_ID特定
           6 依頼オーダテーブル登録
           7 電文チェック�A
  復帰値 : True 正常 False 異常 例外は発生しない
-----------------------------------------------------------------------------
}
function  TDb_RisSvr_Irai.func_InquireMsgForDB(    arg_System        : String;
                                                   arg_MsgKind       : String;
                                                   arg_RecvMsgStream : TStringStream;
                                                   arg_TDate         : TDateTime;
                                               var arg_LogBuffer     : String
                                               ):Boolean;
var
  res     : Boolean;
  w_err   : Boolean;
begin
  //エラーでも処理を最後まで続ける
  w_err := False;
  //7.RIS_ID特定
  res := func_IdentifyRISID(arg_System, wm_RisID, arg_LogBuffer);
  //正常終了でない場合
  if not res then
  begin
    //エラー
    w_err := True;
  end;
  //8.依頼オーダテーブル登録
  res := func_SaveMsg(G_MSGKIND_IRAI, wm_SKbn, arg_TDate, arg_RecvMsgStream,
                      arg_LogBuffer);
  //正常終了でない場合
  if not res then
    //エラー
    w_err := True;
  //9.電文チェック�A
  //項目の並び順チェック
  res := func_InquireDB(arg_System, arg_MsgKind, arg_RecvMsgStream,
                        arg_LogBuffer);
  //異常終了の場合
  if not res then
    //エラー
    w_err := True;
  //エラー発生の判定
  //エラー無し
  if not w_err then
  begin
    //戻り値
    Result := True;
    //処理終了
    Exit;
  end
  //エラーあり
  else
  begin
    //戻り値
    Result := False;
    //処理終了
    Exit;
  end;
end;
{
-----------------------------------------------------------------------------
  名前   : func_IdentifyRISID
  引数   :     arg_System        : String        電文発生マシン
           var arg_RISID         : String        RIS ID
           var arg_LogBuffer     : String        ログバッファ
  機能   : RIS IDの特定
  復帰値 : True 正常 False 異常 例外は発生しない
-----------------------------------------------------------------------------
}
function  TDb_RisSvr_Irai.func_IdentifyRISID(    arg_System        : String;
                                             var arg_RISID         : String;
                                             var arg_LogBuffer     : String
                                             ):Boolean;
begin
  //初期値
  Result := False;
  try
    //依頼・オーダキャンセルの場合のみ
    if (wg_Kind = G_MSGKIND_IRAI) or
       (wg_Kind = G_MSGKIND_CANCEL) then
    begin
      //処理の判定
      wm_OrderCount := func_CoutRecord('ORDERMAINTABLE',
                                         'ORDERNO = ''' + wm_DataOrdeNo + '''');
      //依頼の場合
      if wg_Kind = G_MSGKIND_IRAI then
      begin
        //新規の場合
        if wm_OrderCount = 0 then
        begin
          //新規の場合
          proc_StrConcat(arg_LogBuffer,'新規');
          //RIS_IDの取得
          Result := func_MakeRisID_No(wm_DataOrdeNo, arg_RISID, arg_LogBuffer);
          if Result then
          begin
            //ログ文字列作成
            proc_StrConcat(arg_LogBuffer, 'RIS_ID特定 OK');
          end;
        end
        //更新の場合
        else if wm_OrderCount > 0 then
        begin
          //更新の場合
          proc_StrConcat(arg_LogBuffer,'更新');
          //RIS_IDを特定
          Result := func_GetRisID(wm_DataOrdeNo, arg_RISID, arg_LogBuffer);
          if Result then
          begin
            //ログ文字列作成
            proc_StrConcat(arg_LogBuffer, 'RIS_ID特定 OK');
          end;
        end;
      end
      //キャンセルの場合の場合
      else if wg_Kind = G_MSGKIND_CANCEL then
      begin
        //削除の場合
        proc_StrConcat(arg_LogBuffer,'削除');
        //RIS_IDを特定
        Result := func_GetRisID(wm_DataOrdeNo, arg_RISID, arg_LogBuffer);
        if Result then
        begin
          //ログ文字列作成
          proc_StrConcat(arg_LogBuffer, 'RIS_ID特定 OK');
        end;
      end
      //上記以外の場合
      else
      begin
        //ログ文字列作成
        proc_StrConcat(arg_LogBuffer, ' オーダ取得NG「オーダメイン検索失敗」');
        //戻り値
        Result := False;
        //処理終了
        Exit;
      end;
    end
    else if (wg_Kind = G_MSGKIND_KANJA) then
    begin
      if wm_HeaderCommand = CST_COMMAND_KANJAUP then
      begin
        //更新の場合
        proc_StrConcat(arg_LogBuffer,'更新');
        //患者ID
        proc_StrConcat(arg_LogBuffer,'ID1=' + wm_KanjaPatientID);
        //患者カナ
        proc_StrConcat(arg_LogBuffer,'ID2=' + wm_KanjaPatientKana);
        //戻り値
        Result := True;
      end
      else if wm_HeaderCommand = CST_COMMAND_KANJADEL then
      begin
        //削除の場合
        proc_StrConcat(arg_LogBuffer,'削除');
        //患者ID
        proc_StrConcat(arg_LogBuffer,'ID1=' + wm_KanjaPatientID);
        //患者カナ
        proc_StrConcat(arg_LogBuffer,'ID2=' + wm_KanjaPatientKana);
        //戻り値
        Result := True;
      end;
    end;
    //処理終了
    Exit;
  except
    on E:exception do
    begin
      //ログ文字列作成
      proc_StrConcat(arg_LogBuffer,'RIS_IDの特定例外エラーNG「'+E.Message+'」');
      //戻り値
      Result := False;
      //処理終了
      Exit;
    end;
  end;
end;
{
-----------------------------------------------------------------------------
  名前   : func_SaveMsg
  引数   :     arg_MsgKind   : String        形式種別
               arg_kbn       : String        処理区分
               arg_Date      : TDateTime     受信日時
               arg_Msg       : TStringStream 電文
           var arg_LogBuffer : String        エラー時：詳細原因 正常時：''
  機能   : 1. 受信オーダテーブルに電文を登録します。
  復帰値 : 例外ない  True 正常 False 異常
-----------------------------------------------------------------------------
}
function  TDb_RisSvr_Irai.func_SaveMsg(    arg_MsgKind   : String;
                                           arg_kbn       : String;
                                           arg_Date      : TDateTime;
                                           arg_Msg       : TStringStream;
                                       var arg_LogBuffer : String
                                       ):Boolean;
var
  ws_MsgType:       String;
  sqlExec:          String;
  iRslt:            Integer;

  wkPRECIEVEDATE:   String;
begin
  //初期化
  Result := True;
  //トランザクション開始
  FDB.StartTransaction;
  try
    with FQ_ALT do begin
      //SQL文字列作成
      sqlExec := '';
      sqlExec := sqlExec + 'INSERT INTO FROMHISINFO ( ';
      sqlExec := sqlExec + 'RECIEVEID,   ';  //受信番号
      sqlExec := sqlExec + 'RECIEVEDATE, ';  //受信日時
      sqlExec := sqlExec + 'MESSAGETYPE, ';  //受信データタイプ識別子
      sqlExec := sqlExec + 'RIS_ID,      ';  //RIS識別ID
      sqlExec := sqlExec + 'MESSAGEID1,  ';  //OIxx、ACxx：オーダ番号/PIxx：患者ID
      sqlExec := sqlExec + 'MESSAGEID2,  ';  //OIxx、ACxx：患者ID/PIxx：患者ｶﾅ名
      sqlExec := sqlExec + 'RECIEVETEXT  ';  //受信電文
      sqlExec := sqlExec + ') Values ( ';
      sqlExec := sqlExec + ':PRECIEVEID,   ';
      sqlExec := sqlExec + '%s, ';
      //sqlExec := sqlExec + 'TO_DATE(:PRECIEVEDATE, ''YYYY/MM/DD HH24:MI:SS''), ';
      sqlExec := sqlExec + ':PMESSAGETYPE, ';
      sqlExec := sqlExec + ':PRIS_ID,      ';
      sqlExec := sqlExec + ':PMESSAGEID1,  ';
      sqlExec := sqlExec + ':PMESSAGEID2,  ';
      sqlExec := sqlExec + ':PRECIEVETEXT  ';
      sqlExec := sqlExec + ')';
      //TO_DATE
      wkPRECIEVEDATE := 'TO_DATE(''%s'', ''YYYY/MM/DD HH24:MI:SS'')';
      //受信日時
      wkPRECIEVEDATE := Format(wkPRECIEVEDATE, [FormatDateTime('yyyy/mm/dd hh:nn:ss', arg_Date)]);
      //SQL設定
      sqlExec := Format(sqlExec, [wkPRECIEVEDATE]);
      PrepareQuery(sqlExec);
      //パラメータ
      //受信番号
      SetParam('PRECIEVEID', IntToStr(wg_DenbunNo));
      //受信電文から受信データタイプを取得
      ws_MsgType := func_Change_RVRISCommand(wm_HeaderCommand);
      //受信データタイプ識別子
      SetParam('PMESSAGETYPE', ws_MsgType);
      //オーダ情報・オーダキャンセル
      if (ws_MsgType = CST_APPTYPE_OI01) or
         (ws_MsgType = CST_APPTYPE_OI99) then
      begin
        //RIS識別ID
        SetParam('PRIS_ID', wm_RisID);
        //オーダ番号
        SetParam('PMESSAGEID1', wm_DataOrdeNo);
        //患者ID
        SetParam('PMESSAGEID2', wm_KanjaPatientID);
      end
      //患者情報・死亡退院情報
      else if (ws_MsgType = CST_APPTYPE_PI01) or
              (ws_MsgType = CST_APPTYPE_PI99) then
      begin
        //RIS識別ID
        SetParam('PRIS_ID', '');
        //患者ID
        SetParam('PMESSAGEID1', wm_KanjaPatientID);
        //患者ｶﾅ名
        SetParam('PMESSAGEID2', wm_KanjaPatientKana);
      end;
      //電文
      SetParam('PRECIEVETEXT', arg_Msg.DataString);
      //SQL実行
      iRslt:= ExecSQL();
      if iRslt < 0 then begin
        //ロールバック
        FDB.Rollback;
        //失敗
        Result := False;
        //切断
        wg_DBFlg := False;
        //
        Exit;
      end;
    end;
    //コミット
    FDB.Commit;
    //成功
    Result := True;
  except
    //エラー終了処理
    on E:exception do
    begin
      //ロールバック
      FDB.Rollback;
      //ログ文字列作成
      proc_StrConcat(arg_LogBuffer,'受信電文登録失敗NG「'+E.Message+'」');
      //戻り値
      Result := False;
      //切断
      wg_DBFlg := False;
      //処理終了
      Exit;
    end;
  end;
end;
{
-----------------------------------------------------------------------------
  名前   : func_SaveMsg
  引数   :     arg_MsgKind   : String        形式種別
               arg_kbn       : String        処理区分
               arg_Date      : TDateTime     受信日時
               arg_Msg       : TStringStream 電文
           var arg_LogBuffer : String        エラー時：詳細原因 正常時：''
  機能   : 1. 受信オーダテーブルに電文を登録します。
  復帰値 : 例外ない  True 正常 False 異常
-----------------------------------------------------------------------------
}
function  TDb_RisSvr_Irai.func_SaveMsgNG(arg_MsgKind   : String;
                                         arg_kbn       : String;
                                         arg_Date      : TDateTime;
                                         arg_Msg       : TStringStream;
                                     var arg_LogBuffer : String
                                        ):Boolean;
var
  ws_MsgType:       String;
  sqlExec:          String;
  iRslt:            Integer;

  wkPRECIEVEDATE:   String;
begin
  //初期化
  Result := True;
  //トランザクション開始
  FDB.StartTransaction;
  try
    with FQ_ALT do begin
      //SQL文字列作成
      sqlExec := '';
      sqlExec := sqlExec + 'DELETE FROM FROMHISINFO ';
      sqlExec := sqlExec + ' WHERE RECIEVEID = :PRECIEVEID';
      //SQL設定
      PrepareQuery(sqlExec);
      //受信番号
      SetParam('PRECIEVEID', IntToStr(wg_DenbunNo));
      //SQL実行
      iRslt:= ExecSQL();
      if iRslt < 0 then begin
        //失敗
        Result := False;
        //切断
        wg_DBFlg := False;
        //
        Exit;
      end;
      //SQL文字列作成
      sqlExec := '';
      sqlExec := sqlExec + 'INSERT INTO FROMHISINFO ( ';
      sqlExec := sqlExec + 'RECIEVEID,   ';  //受信番号
      sqlExec := sqlExec + 'RECIEVEDATE, ';  //受信日時
      sqlExec := sqlExec + 'MESSAGETYPE, ';  //受信データタイプ識別子
      sqlExec := sqlExec + 'RIS_ID,      ';  //RIS識別ID
      sqlExec := sqlExec + 'MESSAGEID1,  ';  //OIxx、ACxx：オーダ番号/PIxx：患者ID
      sqlExec := sqlExec + 'MESSAGEID2,  ';  //OIxx、ACxx：患者ID/PIxx：患者ｶﾅ名
      sqlExec := sqlExec + 'RECIEVETEXT  ';  //受信電文
      sqlExec := sqlExec + ') Values ( ';
      sqlExec := sqlExec + ':PRECIEVEID,   ';
      sqlExec := sqlExec + '%s, ';
      //sqlExec := sqlExec + 'TO_DATE(:PRECIEVEDATE, ''YYYY/MM/DD HH24:MI:SS''), ';
      sqlExec := sqlExec + ':PMESSAGETYPE, ';
      sqlExec := sqlExec + ':PRIS_ID,      ';
      sqlExec := sqlExec + ':PMESSAGEID1,  ';
      sqlExec := sqlExec + ':PMESSAGEID2,  ';
      sqlExec := sqlExec + ':PRECIEVETEXT  ';
      sqlExec := sqlExec + ')';
      //TO_DATE
      wkPRECIEVEDATE := 'TO_DATE(''%s'', ''YYYY/MM/DD HH24:MI:SS'')';
      //受信日時
      wkPRECIEVEDATE := Format(wkPRECIEVEDATE, [FormatDateTime('yyyy/mm/dd hh:nn:ss', arg_Date)]);
      //SQL設定
      sqlExec := Format(sqlExec, [wkPRECIEVEDATE]);
      PrepareQuery(sqlExec);
      //パラメータ
      //受信番号
      SetParam('PRECIEVEID', IntToStr(wg_DenbunNo));
      //受信電文から受信データタイプを取得
      ws_MsgType := func_Change_RVRISCommand(wm_HeaderCommand);
      //受信データタイプ識別子
      SetParam('PMESSAGETYPE', ws_MsgType);
      //オーダ情報・オーダキャンセル
      if (ws_MsgType = CST_APPTYPE_OI01) or
         (ws_MsgType = CST_APPTYPE_OI99) then
      begin
        //RIS識別ID
        SetParam('PRIS_ID', wm_RisID);
        //オーダ番号
        SetParam('PMESSAGEID1', wm_DataOrdeNo);
        //患者ID
        SetParam('PMESSAGEID2', wm_KanjaPatientID);
      end
      //患者情報・死亡退院情報
      else if (ws_MsgType = CST_APPTYPE_PI01) or
              (ws_MsgType = CST_APPTYPE_PI99) then
      begin
        //RIS識別ID
        SetParam('PRIS_ID', '');
        //患者ID
        SetParam('PMESSAGEID1', wm_KanjaPatientID);
        //患者ｶﾅ名
        SetParam('PMESSAGEID2', wm_KanjaPatientKana);
      end;
      //電文
      SetParam('PRECIEVETEXT', arg_Msg.DataString);
      //SQL実行
      iRslt:= ExecSQL();
      if iRslt < 0 then begin
        //ロールバック
        FDB.Rollback;
        //失敗
        Result := False;
        //切断
        wg_DBFlg := False;
        //
        Exit;
      end;

      //2018/08/30 エラー内容登録
      sqlExec := 'UPDATE EXTENDORDERINFO SET ADDENDUM20 =:ERR_MSG WHERE RIS_ID =:RIS_ID';
      //SQL設定
      PrepareQuery(sqlExec);
      //パラメータ
      SetParam('ERR_MSG', arg_LogBuffer);
      SetParam('RIS_ID', wm_RisID);

      //SQL実行
      iRslt:= ExecSQL();
      if iRslt < 0 then begin
        //ロールバック
        FDB.Rollback;
        //失敗
        Result := False;
        //切断
        wg_DBFlg := False;
        //
        Exit;
      end;
    end;

    //コミット
    FDB.Commit;
    //成功
    Result := True;
  except
    //エラー終了処理
    on E:exception do
    begin
      //ロールバック
      FDB.Rollback;
      //ログ文字列作成
      proc_StrConcat(arg_LogBuffer,'受信電文登録失敗NG「'+E.Message+'」');
      //戻り値
      Result := False;
      //切断
      wg_DBFlg := False;
      //処理終了
      Exit;
    end;
  end;
end;
{
-----------------------------------------------------------------------------
  名前   : func_InquireDB
  引数   : arg_System        : String        作成マシン
           arg_MsgKind       : String        電文種別
           arg_RecvMsgStream : TStringStream 受信電文
           arg_LogBuffer     : String        ログバッファエリア
  機能   : 1.電文とRIS DBの整合性チェック
  復帰値 : 例外は発生しない True 正常 False 異常
-----------------------------------------------------------------------------
}
function  TDb_RisSvr_Irai.func_InquireDB(    arg_System        : String;
                                             arg_MsgKind       : String;
                                             arg_RecvMsgStream : TStringStream;
                                         var arg_LogBuffer     : String
                                         ):Boolean;
var
  res1          : Boolean;
  res2          : Boolean;
  w_DLogBuffer  : String;
  w_SLog        : String;
begin
  try
    //初期化
    res2 := True;
    wm_ComIDCount    := 0;
    wm_Shoken_Youhi_Flg := CST_SHOKEN_YOUHI_FLG_OFF;
    //ID整合チェック
    res1 := func_CheckIraiHisID(w_DLogBuffer);
    //正常終了の場合
    if res1 then
    begin
      //ログ文字列作成
      proc_StrConcat(arg_LogBuffer, 'HISID整合OK');
    end
    //異常終了の場合
    else
    begin
       //ログ文字列の作成
       proc_StrConcat(arg_LogBuffer,
                      'HISID整合NG「不整合ID：' + w_DLogBuffer + '」');
    end;
    //項目属性最大数チェック
    if arg_MsgKind = G_MSGKIND_IRAI then
    begin
      //項目属性最大数チェック
      res2 := func_CheckMax999(w_SLog);
      //正常終了の場合
      if res2 then
      begin
        //ログ文字列作成
        proc_StrConcat(arg_LogBuffer,'最大数OK');
      end
      //異常終了の場合
      else
      begin
        //ログ文字列作成
        proc_StrConcat(arg_LogBuffer,'最大数NG「'+w_SLog+'」');
      end;
    end;
    //正常終了
    if (res1 and res2) then
    begin
      //戻り値
      Result := True;
    end
    //異常終了
    else
    begin
      //戻り値
      Result := False;
    end;
    //処理終了
    Exit;
  except
    on E: exception do
    begin
       //ログ文字列作成
       proc_StrConcat(arg_LogBuffer,
                      '電文チェック�ANG「例外発生' + E.Message + '」');
       //戻り値
       Result := False;
       //処理終了
       Exit;
    end;
  end;
end;
{
-----------------------------------------------------------------------------
  名前   : func_CheckMax999
  引数   : var arg_Msg : String エラー文字列格納
  機能   : 1.項目コードの最大数チェック
  復帰値 : 例外は発生しない True 正常 False 異常
-----------------------------------------------------------------------------
}
function TDb_RisSvr_Irai.func_CheckMax999(var arg_Msg : String):Boolean;
var
  w_Log : String;
begin
  //初期値
  Result := True;
  //グループ数が99以上の場合
  if Length(wm_OrderBui) > CST_GROUP_LOOP_MAX then
  begin
    //ログ文字列を作成
    proc_StrConcat(w_Log, CST_GROUP_OVER);
    //エラー文字列作成
    arg_Msg := arg_Msg + CST_GROUP_OVER;
    //戻り値
    Result := False;
  end;
  {
  //検査系種別
  if (wm_KensaType03Flg <> '') or
     (wm_KensaType04Flg <> '') then
  begin
    //グループ数が1以上の場合
    if Length(wm_OrderBui) > 1 then
    begin
      //ログ文字列を作成
      proc_StrConcat(w_Log, CST_KENSAGROUP_OVER);
      //エラー文字列作成
      arg_Msg := arg_Msg + CST_KENSAGROUP_OVER;
      //戻り値
      Result := False;
    end;
  end;
  }
end;
{
-----------------------------------------------------------------------------
  名前   : func_Get_StudyInstanceUID
  引数   : なし
  復帰値 : 例外は上にあげる
           スタディインスタンスUIDの固定部
  機能   : スタディインスタンスUIDの固定部をデータベースから取得
-----------------------------------------------------------------------------
}
function TDb_RisSvr_Irai.func_Get_StudyInstanceUID:String;
var
  ws_LicenseNo: String;
  sqlSelect:    String;
  iRslt:        Integer;
begin
  Result := '';
  Result := '';
  try
    with FQ_SEL do begin
      //SQL設定
      sqlSelect := '';
      sqlSelect := sqlSelect + 'SELECT LICENSENO FROM SYSTEMDEFINE ';
      PrepareQuery(sqlSelect);
      //SQL実行
      iRslt:= OpenQuery();
      if iRslt < 0 then begin
        //例外エラー
        Result := '';
        //切断
        wg_DBFlg := False;
        //処理終了
        Exit;
      end;
      if Eof = False then begin
        // 対象データの取得
        ws_LicenseNo := GetString('LICENSENO');
        //固定部＋ライセンス番号
        Result := CST_STUDYINSTANCEUID_FIXED + ws_LicenseNo + '.';
      end;
    end;
  except
    //例外エラー
    Result := '';
    //切断
    wg_DBFlg := False;
    //処理終了
    Exit;
  end;
end;
//==============================================================================
//その他処理↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓
//==============================================================================
{
-----------------------------------------------------------------------------
  名前 : proc_GetDokuei;
  引数 : var arg_Dokuei 読影要否フラグ
  機能 : 部位IDから読影要否フラグを取得
  復帰値：例外は発生しない
-----------------------------------------------------------------------------
}
procedure  TDb_RisSvr_Irai.proc_GetDokuei(var arg_Dokuei:String);
var
  w_i:          integer;
  w_Dokuei_N:   Integer;
  w_Dokuei_A:   Integer;
  w_Dokuei:     String;
  w_Bui:        String;
  sqlSelect:    String;
  iRslt:        Integer;
begin
  try
    //初期化
    w_Dokuei   := '';
    w_Bui      := '';
    w_Dokuei_N := 0;
    w_Dokuei_A := 0;
    //繰り返された分だけ
    for w_i := 0 to Length(wm_OrderBui) - 1 do
    begin
      //初回の場合
      if w_Bui = '' then
        //部位設定
        w_Bui := '''' + wm_OrderBui[w_i].BuiID + ''''
      else
        //部位設定
        w_Bui := w_Bui + ',' + '''' + wm_OrderBui[w_i].BuiID + '''';
    end;
    //部位IDがある場合
    if w_Bui <> '' then
    begin
      //部位から実施機器を取得
      try
        with FQ_SEL do begin
          //SQL設定
          sqlSelect := '';
          sqlSelect := sqlSelect + 'SELECT DISTINCT(DOKUEI_FLG)';
          sqlSelect := sqlSelect + ' FROM BUIMASTER';
          sqlSelect := sqlSelect + ' WHERE KENSATYPE_ID = :PKENSATYPE_ID';
          sqlSelect := sqlSelect + ' AND BUI_ID IN (' + w_Bui + ')';
          sqlSelect := sqlSelect + ' AND DOKUEI_FLG IS NOT NULL';
          PrepareQuery(sqlSelect);
          //パラメータ
          //検査種別
          SetParam('PKENSATYPE_ID', wm_RISKensaType);
          //SQL実行
          iRslt:= OpenQuery();
          if iRslt < 0 then begin
            //例外エラー
            //読影必要
            arg_Dokuei := GPCST_DOKUEI_1;
            //切断
            wg_DBFlg := False;
            //処理終了
            Exit;
          end;
          while not Eof do begin
            //読影不要
            if GPCST_DOKUEI_0 = GetString('DOKUEI_FLG') then begin
              //＋１
              inc(w_Dokuei_N);
            end
            //読影必要
            else if GPCST_DOKUEI_1 = GetString('DOKUEI_FLG') then begin
              //＋１
              inc(w_Dokuei_A);
            end;
            //次のレコード
            Next;
          end;
          //読影必要がある場合
          if w_Dokuei_A <> 0 then
          begin
            //読影必要
            arg_Dokuei := GPCST_DOKUEI_1;
          end
          //読影必要がなくて読影不要がある場合
          else if w_Dokuei_N <> 0 then
          begin
            //読影不要
            arg_Dokuei := GPCST_DOKUEI_0;
          end
          //上記以外の場合
          else
          begin
            //読影必要
            arg_Dokuei := GPCST_DOKUEI_1;
          end;
        end;
      except
        //例外エラー
        //読影必要
        arg_Dokuei := GPCST_DOKUEI_1;
        //切断
        wg_DBFlg := False;
        //処理終了
        Exit;
      end;
    end
    //部位IDがない場合？
    else
    begin
      //読影必要
      arg_Dokuei := GPCST_DOKUEI_1;
    end;
  except
    //読影必要
    arg_Dokuei := GPCST_DOKUEI_1;
    //切断
    wg_DBFlg := False;
    Exit;
  end;
end;
{
-----------------------------------------------------------------------------
  名前 : proc_GetSyoti;
  引数 : var arg_Syoti  処置室フラグ
         var arg_Tatiai 立会いフラグ
  機能 : 部位IDから処置室フラグ、立会いフラグを取得
  復帰値：例外は発生しない
-----------------------------------------------------------------------------
}
procedure TDb_RisSvr_Irai.proc_GetSyoti(var arg_Syoti,arg_Tatiai:String);
var
  w_i:        integer;
  w_Use:      Integer;
  w_Tatiai:   Integer;
  w_Bui:      String;
  sqlSelect:  String;
  iRslt:      Integer;
begin
  try
    //初期化
    w_Bui      := '';
    w_Use := 0;
    w_Tatiai := 0;
    //繰り返された分だけ
    for w_i := 0 to Length(wm_OrderBui) - 1 do
    begin
      //初回の場合
      if w_Bui = '' then
        //部位設定
        w_Bui := '''' + wm_OrderBui[w_i].BuiID + ''''
      else
        //部位設定
        w_Bui := w_Bui + ',' + '''' + wm_OrderBui[w_i].BuiID + '''';
    end;
    //部位IDがある場合
    if w_Bui <> '' then
    begin
      //部位から実施機器を取得
      try
        with FQ_SEL do begin
          //SQL設定
          sqlSelect := '';
          sqlSelect := sqlSelect + 'SELECT SYOTISITU_FLG,ISITATIAI_FLG';
          sqlSelect := sqlSelect + '  FROM BUIMASTER';
          sqlSelect := sqlSelect + ' WHERE KENSATYPE_ID = :PKENSATYPE_ID';
          sqlSelect := sqlSelect + '   AND BUI_ID IN (' + w_Bui + ')';
          PrepareQuery(sqlSelect);
          //パラメータ
          //検査種別
          SetParam('PKENSATYPE_ID', wm_RISKensaType);
          //SQL実行
          iRslt:= OpenQuery();
          if iRslt < 0 then begin
            //例外エラー
            //処置室使用なし
            arg_Syoti  := GPCST_SHOTI_0;
            //医師立会いなし
            arg_Tatiai := GPCST_ISITATIAI_0;
            //切断
            wg_DBFlg := False;
            //処理終了
            Exit;
          end;
          while not Eof do begin
            // 対象データの取得
            //処置室を使用する場合
            if GPCST_SHOTI_1 = GetString('SYOTISITU_FLG') then begin
              //＋１
              inc(w_Use);
            end;
            //医師立会いありの場合
            if GPCST_ISITATIAI_1 = GetString('ISITATIAI_FLG') then begin
              //＋１
              inc(w_Tatiai);
            end;
            //次のレコード
            Next;
          end;
          //処置室使用がある場合
          if (w_Use <> 0) then
          begin
            //処置室使用あり
            arg_Syoti  := GPCST_SHOTI_1;
          end
          //それ以外の場合
          else
          begin
            //処置室使用なし
            arg_Syoti  := GPCST_SHOTI_0;
          end;
          //医師立会いありがある場合
          if (w_Tatiai <> 0) then
          begin
            //医師立会いあり
            arg_Tatiai := GPCST_ISITATIAI_1;
          end
          //それ以外の場合
          else
          begin
            //医師立会いなし
            arg_Tatiai := GPCST_ISITATIAI_0;
          end;
        end;
      except
        //例外エラー
        //処置室使用なし
        arg_Syoti  := GPCST_SHOTI_0;
        //医師立会いなし
        arg_Tatiai := GPCST_ISITATIAI_0;
        //切断
        wg_DBFlg := False;
        //処理終了
        Exit;
      end;
    end
    //部位IDがない場合？
    else
    begin
      //処置室使用なし
      arg_Syoti  := GPCST_SHOTI_0;
      //医師立会いなし
      arg_Tatiai := GPCST_ISITATIAI_0;
    end;
  except
    //処置室使用なし
    arg_Syoti  := GPCST_SHOTI_0;
    //医師立会いなし
    arg_Tatiai := GPCST_ISITATIAI_0;
    //切断
    wg_DBFlg := False;
    Exit;
  end;
end;
{
-----------------------------------------------------------------------------
  名前 : proc_GetPortable
  引数 : var arg_Portable  ポータブルフラグ
  機能 : 部位IDからポータブルフラグを取得
  復帰値：例外は発生しない
-----------------------------------------------------------------------------
}
procedure TDb_RisSvr_Irai.proc_GetPortable(var arg_Portable:String);
var
  w_i:        integer;
  w_Bui:      String;
  sqlSelect:  String;
  iRslt:      Integer;
begin
  //初期化
  w_Bui      := '';
  try
    //繰り返された分だけ
    for w_i := 0 to Length(wm_OrderBui) - 1 do
    begin
      //初回の場合
      if w_Bui = '' then
        //部位設定
        w_Bui := '''' + wm_OrderBui[w_i].BuiID + ''''
      else
        //部位設定
        w_Bui := w_Bui + ',' + '''' + wm_OrderBui[w_i].BuiID + '''';
    end;
    //部位IDがある場合
    if w_Bui <> '' then
    begin
      //部位からポータブルフラグを取得
      try
        with FQ_SEL do begin
          //SQL設定
          sqlSelect := '';
          sqlSelect := sqlSelect + 'SELECT DISTINCT(PORTABLEFLAG)';
          sqlSelect := sqlSelect + '  FROM BUIMASTER';
          sqlSelect := sqlSelect + ' WHERE KENSATYPE_ID = :PKENSATYPE_ID';
          sqlSelect := sqlSelect + '   AND BUI_ID IN (' + w_Bui + ')';
          sqlSelect := sqlSelect + '   AND PORTABLEFLAG IS NOT NULL';
          PrepareQuery(sqlSelect);
          //パラメータ
          //検査種別
          SetParam('PKENSATYPE_ID', wm_RISKensaType);
          //SQL実行
          iRslt:= OpenQuery();
          if iRslt < 0 then begin
            //例外エラー
            //通常
            arg_Portable := GPCST_PORTABLE_FLG_0;
            //切断
            wg_DBFlg := False;
            //処理終了
            Exit;
          end;
          if Eof = False then begin
            // 対象データの取得
            //ポータブルフラグがポータブルのみの場合
            if GetString('PORTABLEFLAG') = GPCST_PORTABLE_FLG_1 then begin
              //ポータブル
              arg_Portable := GPCST_PORTABLE_FLG_1;
            end
            //ポータブルが手術室のみの場合
            else if GetString('PORTABLEFLAG') = GPCST_PORTABLE_FLG_2 then begin
              //手術室
              arg_Portable := GPCST_PORTABLE_FLG_2;
            end
            else begin
              //通常
              arg_Portable := GPCST_PORTABLE_FLG_0;
            end;
          end
          else begin
            //通常
            arg_Portable := GPCST_PORTABLE_FLG_0;
          end;
        end;
      except
        //例外エラー
        //通常
        arg_Portable := GPCST_PORTABLE_FLG_0;
        //切断
        wg_DBFlg := False;
        //処理終了
        Exit;
      end;
    end
    //部位IDがない場合？
    else begin
      //通常
      arg_Portable := GPCST_PORTABLE_FLG_0;
    end;
  except
    //通常
    arg_Portable := GPCST_PORTABLE_FLG_0;
    //切断
    wg_DBFlg := False;
    Exit;
  end;
end;
{
-----------------------------------------------------------------------------
  名前 : proc_GetRI;
  引数 : var arg_RI  RIフラグ
  機能 : 部位IDからRIフラグを取得
  復帰値：例外は発生しない
-----------------------------------------------------------------------------
}
procedure TDb_RisSvr_Irai.proc_GetRi(var arg_RI:String);
var
  w_i:        integer;
  w_Bui:      String;
  sqlSelect:  String;
  iRslt:      Integer;
begin
  //初期化
  w_Bui      := '';
  // 核医学画面フラグ
  if wm_KensaType04Flg <> '' then
  begin
    try
      //繰り返された分だけ
      for w_i := 0 to Length(wm_OrderBui) - 1 do
      begin
        //初回の場合
        if w_Bui = '' then
          //部位設定
          w_Bui := '''' + wm_OrderBui[w_i].BuiID + ''''
        else
          //部位設定
          w_Bui := w_Bui + ',' + '''' + wm_OrderBui[w_i].BuiID + '''';
      end;
      //部位IDがある場合
      if w_Bui <> '' then
      begin
        //部位からRIオーダ区分を取得
        try
          with FQ_SEL do begin
            //SQL設定
            sqlSelect := '';
            sqlSelect := sqlSelect + 'SELECT DISTINCT(RI_ORDER_FLG)';
            sqlSelect := sqlSelect + '  FROM BUIMASTER';
            sqlSelect := sqlSelect + ' WHERE KENSATYPE_ID = :PKENSATYPE_ID';
            sqlSelect := sqlSelect + '   AND BUI_ID IN (' + w_Bui + ')';
            sqlSelect := sqlSelect + '   AND RI_ORDER_FLG IS NOT NULL';
            PrepareQuery(sqlSelect);
            //パラメータ
            SetParam('PKENSATYPE_ID', wm_RISKensaType);
            //SQL実行
            iRslt:= OpenQuery();
            if iRslt < 0 then begin
              //例外エラー
              //検査
              arg_RI := GPCST_RI_ORDER_2;
              //切断
              wg_DBFlg := False;
              //処理終了
              Exit;
            end;
            if Eof = False then begin
              // 対象データの取得
              //RIオーダ区分が注射のみの場合
              if GetString('RI_ORDER_FLG') = GPCST_RI_ORDER_1 then begin
                //注射
                arg_RI := GPCST_RI_ORDER_1;
              end
              //RIオーダ区分が注射のみではないの場合
              else begin
                //検査
                arg_RI := GPCST_RI_ORDER_2;
              end;
            end
            else begin
              //検査
              arg_RI := GPCST_RI_ORDER_2;
            end;
          end;
        except
          //例外エラー
          //検査
          arg_RI := GPCST_RI_ORDER_2;
          //切断
          wg_DBFlg := False;
          //処理終了
          Exit;
        end;
      end
      //部位IDがない場合？
      else begin
        //検査
        arg_RI := GPCST_RI_ORDER_2;
      end;
    except
      //検査
      arg_RI := GPCST_RI_ORDER_2;
      Exit;
    end;
  end
  // 核医学以外の場合
  else
  begin
    //その他
    arg_RI := GPCST_RI_ORDER_0;
    //切断
    wg_DBFlg := False;
    Exit;
  end;
end;
{
-----------------------------------------------------------------------------
  名前 : proc_GetKiki;
  引数 : var arg_KIKI 実施機器コード
  機能 : 部位から実施機器を取得
  復帰値：例外は発生しない
-----------------------------------------------------------------------------
}
procedure  TDb_RisSvr_Irai.proc_GetKiki(var arg_KIKI:String);
var
  w_i:        integer;
  w_kiki:     String;
  w_Bui:      String;
  sqlSelect:  String;
  iRslt:      Integer;
begin
  //初期化
  w_kiki := '';
  try
    with FQ_SEL do begin
      //SQL設定
      sqlSelect := '';
      sqlSelect := sqlSelect + 'SELECT KENSAKIKI_ID';
      sqlSelect := sqlSelect + '  FROM KENSATYPEMASTER';
      sqlSelect := sqlSelect + ' WHERE KENSATYPE_ID = :PKENSATYPE_ID';
      PrepareQuery(sqlSelect);
      //パラメータ
      SetParam('PKENSATYPE_ID', wm_RISKensaType);
      //SQL実行
      iRslt:= OpenQuery();
      if iRslt < 0 then begin
        //例外エラー
        //実施機器なし
        arg_KIKI := '';
        //切断
        wg_DBFlg := False;
        //処理終了
        Exit;
      end;
      arg_KIKI := '';
      if Eof = False then begin
        // 対象データの取得
        arg_KIKI := GetString('KENSAKIKI_ID');
      end;
      if arg_KIKI = '' then begin
        //初期化
        w_Bui := '';
        //繰り返された分だけ
        for w_i := 0 to Length(wm_OrderBui) - 1 do
        begin
          //初回の場合
          if w_Bui = '' then
            //部位設定
            w_Bui := '''' + wm_OrderBui[w_i].BuiID + ''''
          else
            //部位設定
            w_Bui := w_Bui + ',' + '''' + wm_OrderBui[w_i].BuiID + '''';
        end;

        //部位IDがある場合
        if w_Bui <> '' then
        begin
          //部位から実施機器を取得

          with FQ_SEL do begin
            //SQL設定
            sqlSelect := '';
            sqlSelect := sqlSelect + 'SELECT DISTINCT(KENSAKIKI_ID) AS KENSAKIKI_ID';
            sqlSelect := sqlSelect + '  FROM BUIMASTER';
            sqlSelect := sqlSelect + ' WHERE KENSATYPE_ID = :PKENSATYPE_ID';
            sqlSelect := sqlSelect + '   AND BUI_ID IN (' + w_Bui + ')';
            PrepareQuery(sqlSelect);
            //パラメータ
            //検査種別
            SetParam('PKENSATYPE_ID', wm_RISKensaType);
            //SQL実行
            iRslt:= OpenQuery();
            if iRslt < 0 then begin
              //例外エラー
              //実施機器なし
              arg_KIKI := '';
              //切断
              wg_DBFlg := False;
              //処理終了
              Exit;
            end;
            if Eof = False then begin
              // 対象データの取得
              //実施機器ID設定
              arg_KIKI := GetString('KENSAKIKI_ID');
            end
            else begin
              //実施機器なし
              arg_KIKI := '';
            end;
          end;
        end
        //部位IDがない場合？
        else
        begin
          //実施機器なし
          arg_KIKI := '';
        end;
      end;
    end;
  except
    //例外エラー
    //実施機器なし
    arg_KIKI := '';
    //切断
    wg_DBFlg := False;
    //処理終了
    Exit;
  end;
end;
{
-----------------------------------------------------------------------------
  名前 : proc_GetExamRoom;
  引数 : var arg_Room 検査室コード
  機能 : 検査室コードの決定
  復帰値：例外は発生しない
-----------------------------------------------------------------------------
}
procedure  TDb_RisSvr_Irai.proc_GetExamRoom(var arg_Room:String);
var
  wi_Loop:    Integer;
  w_Room:     String;
  w_Bui:      String;
  sqlSelect:  String;
  iRslt:      Integer;
begin
  //初期化
  w_Room := '';
  try
    with FQ_SEL do begin
      //SQL設定
      sqlSelect := '';
      sqlSelect := sqlSelect + 'SELECT EXAMROOM_ID';
      sqlSelect := sqlSelect + '  FROM KENSATYPEMASTER';
      sqlSelect := sqlSelect + ' WHERE KENSATYPE_ID = :PKENSATYPE_ID';
      PrepareQuery(sqlSelect);
      //パラメータ
      //検査種別
      SetParam('PKENSATYPE_ID', wm_RISKensaType);
      //SQL実行
      iRslt:= OpenQuery();
      if iRslt < 0 then begin
        //例外エラー
        //検査室なし
        arg_Room := '';
        //切断
        wg_DBFlg := False;
        //処理終了
        Exit;
      end;
      arg_Room := '';
      if Eof = False then begin
        // 対象データの取得
        //検査室ID設定
        arg_Room := GetString('EXAMROOM_ID');
      end;
      if arg_Room = '' then begin
        //初期化
        w_Bui := '';
        //繰り返された分だけ
        for wi_Loop := 0 to Length(wm_OrderBui) - 1 do
        begin
          //初回の場合
          if w_Bui = '' then
            //部位設定
            w_Bui := '''' + wm_OrderBui[wi_Loop].BuiID + ''''
          else
            //部位設定
            w_Bui := w_Bui + ',' + '''' + wm_OrderBui[wi_Loop].BuiID + '''';
        end;
        //部位IDがある場合
        if w_Bui <> '' then
        begin
          //部位から実施機器を取得
          with FQ_SEL do begin
            //SQL設定
            sqlSelect := '';
            sqlSelect := sqlSelect + 'SELECT DISTINCT(EXAMROOM_ID)';
            sqlSelect := sqlSelect + '  FROM BUIMASTER';
            sqlSelect := sqlSelect + ' WHERE KENSATYPE_ID = :PKENSATYPE_ID';
            sqlSelect := sqlSelect + '   AND BUI_ID IN (' + w_Bui + ')';
            PrepareQuery(sqlSelect);
            //パラメータ
            //検査種別
            SetParam('PKENSATYPE_ID', wm_RISKensaType);
            //SQL実行
            iRslt:= OpenQuery();
            if iRslt < 0 then begin
              //例外エラー
              //検査室なし
              arg_Room := '';
              //切断
              wg_DBFlg := False;
              //処理終了
              Exit;
            end;
            //データがある場合
            if Eof = False then begin
              // 対象データの取得
              //検査室ID設定
              arg_Room := GetString('EXAMROOM_ID');
            end
            else begin
              //検査室なし
              arg_Room := '';
            end;
          end;
        end
        //部位IDがない場合？
        else
        begin
          //検査室なし
          arg_Room := '';
        end;
      end;
    end;
  except
    //例外エラー
    //検査室なし
    arg_Room := '';
    //切断
    wg_DBFlg := False;
    //処理終了
    Exit;
  end;
end;
{
-----------------------------------------------------------------------------
  名前 : proc_GetDrTEL;
  引数 :     arg_Dr   医師ID
         var arg_Tel  医師連絡先
  機能 : 医師連絡先を取得
  復帰値：例外は発生しない
-----------------------------------------------------------------------------
}
procedure TDb_RisSvr_Irai.proc_GetDrTEL(    arg_Dr: String;
                                        var arg_Tel:String
                                        );
var
  sqlSelect:  String;
  iRslt:      Integer;
begin
  try
    with FQ_SEL do begin
      //SQL設定
      sqlSelect := '';
      sqlSelect := sqlSelect + 'SELECT DOCTOR_TEL';
      sqlSelect := sqlSelect + '  FROM SECTIONDOCTORMASTER';
      sqlSelect := sqlSelect + ' WHERE DOCTOR_ID = :PDOCTOR_ID';
      PrepareQuery(sqlSelect);
      //パラメータ
      //医師ID
      SetParam('PDOCTOR_ID', arg_Dr);
      //SQL実行
      iRslt:= OpenQuery();
      if iRslt < 0 then begin
        //例外エラー
        arg_Tel := '';
        //切断
        wg_DBFlg := False;
        //処理終了
        Exit;
      end;
      if Eof = False then begin
        // 対象データの取得
        arg_Tel := GetString('DOCTOR_TEL');
      end
      else begin
        arg_Tel := '';
      end;
    end;
  except
    //例外エラー
    arg_Tel := '';
    //切断
    wg_DBFlg := False;
    //処理終了
    Exit;
  end;
end;
{
-----------------------------------------------------------------------------
  名前   : func_GetSequence
  引数   : var arg_Seq       : Integer  電文連番
           var arg_LogBuffer : String   エラー時：詳細原因 正常時：''
  機能   : 1. 電文連番を取得します
  復帰値 : 例外ない  True 正常 False 異常
-----------------------------------------------------------------------------
}
function  TDb_RisSvr_Irai.func_GetSequence(var arg_Seq: Integer;
                                           var arg_LogBuffer : String
                                           ):Boolean;
begin
  //初期化
  Result := True;
  try
    arg_Seq := FQ_SEL.GetSequence('FROMRISSEQUENCE');
    if arg_Seq <= 0 then begin
      //ログ文字列作成
      proc_StrConcat(arg_LogBuffer,'電文連番取得失敗NG');
      //戻り値
      Result := False;
      //切断
      wg_DBFlg := False;
      //処理終了
      Exit;
    end;
    //処理終了
    Exit;
  except
    //エラー終了処理
    on E:exception do
    begin
      //ログ文字列作成
      proc_StrConcat(arg_LogBuffer,'電文連番取得失敗NG「'+E.Message+'」');
      //戻り値
      Result := False;
      //切断
      wg_DBFlg := False;
      //処理終了
      Exit;
    end;
  end;
end;
//==============================================================================
//●患者↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓
//==============================================================================
{******************************************************************************}
{                                                                              }
{    関数名 func_InquireMsgForDB_Patient：電文チェック・患者の特定             }
{                                                                              }
{  返り値型 Boolean型                                                          }
{           True：成功                                                         }
{           False：失敗                                                        }
{                                                                              }
{      引数 型             名前              タイプ  説明                      }
{           String         arg_System          IN    作成マシン                }
{           String         arg_MsgKind         IN    電文種別                  }
{           TStringStream  arg_RecvMsgStream   IN    受信電文                  }
{           TDateTime      arg_TDate           IN    受信日時                  }
{           String         arg_LogBuffer     IN/OUT  ログ                      }
{                                                                              }
{      例外 なし                                                               }
{                                                                              }
{  機能説明 電文チェック・患者の特定を行う。                                   }
{                                                                              }
{******************************************************************************}
function  TDb_RisSvr_Irai.func_InquireMsgForDB_Patient(    arg_System        : String;
                                                           arg_MsgKind       : String;
                                                           arg_RecvMsgStream : TStringStream;
                                                           arg_TDate         : TDateTime;
                                                       var arg_LogBuffer     : String
                                                       ):Boolean;
var
  res     : Boolean;
  w_err   : Boolean;
begin
  //エラーでも処理を最後まで続ける
  w_err := False;
  //7.患者電文区分特定
  res := func_IdentifyPatientID(arg_LogBuffer);
  //正常終了でない場合
  if not res then
  begin
    //エラー
    w_err := True;
  end;
  //8.依頼オーダテーブル登録
  res := func_SaveMsg(G_MSGKIND_KANJA, wm_SKbn, arg_TDate, arg_RecvMsgStream,
                      arg_LogBuffer);
  //正常終了でない場合
  if not res then
    //エラー
    w_err := True;
  //9.電文チェック�A
  //患者情報の確認を依頼
  res := func_CheckKanjaHisID(CST_RISTYPE,arg_LogBuffer);
  //異常終了の場合
  if not res then
    //エラー
    w_err := True;
  //エラー無し
  if not w_err then
  begin
    //戻り値
    Result := True;
    //処理終了
    Exit;
  end
  //エラーあり
  else
  begin
    //戻り値
    Result := False;
    //処理終了
    Exit;
  end;
end;
{******************************************************************************}
{                                                                              }
{    関数名 func_IdentifyPatientID：患者電文区分の特定                         }
{                                                                              }
{  返り値型 Boolean型                                                          }
{           True：成功                                                         }
{           False：失敗                                                        }
{                                                                              }
{      引数 型             名前              タイプ  説明                      }
{           String         arg_LogBuffer     IN/OUT  ログ                      }
{                                                                              }
{      例外 なし                                                               }
{                                                                              }
{  機能説明 患者電文区分の特定を行う。                                         }
{                                                                              }
{******************************************************************************}
function  TDb_RisSvr_Irai.func_IdentifyPatientID(var arg_LogBuffer : String
                                                 ):Boolean;
begin
  //初期値
  Result := False;
  try
    if (wg_Kind = G_MSGKIND_KANJA) then
    begin
      if wm_HeaderCommand = CST_COMMAND_KANJAUP then
      begin
        //更新の場合
        proc_StrConcat(arg_LogBuffer,'更新');
        //患者ID
        proc_StrConcat(arg_LogBuffer,'ID1=' + wm_KanjaPatientID);
        //患者カナ
        proc_StrConcat(arg_LogBuffer,'ID2=' + wm_KanjaPatientKana);
        //戻り値
        Result := True;
      end
      else if wm_HeaderCommand = CST_COMMAND_KANJADEL then
      begin
        //削除の場合
        proc_StrConcat(arg_LogBuffer,'削除');
        //患者ID
        proc_StrConcat(arg_LogBuffer,'ID1=' + wm_KanjaPatientID);
        //患者カナ
        proc_StrConcat(arg_LogBuffer,'ID2=' + wm_KanjaPatientKana);
        //戻り値
        Result := True;
      end;
    end;
    //処理終了
    Exit;
  except
    on E:exception do
    begin
      //ログ文字列作成
      proc_StrConcat(arg_LogBuffer,'患者電文区分の特定例外エラーNG「'+E.Message+'」');
      //戻り値
      Result := False;
      //処理終了
      Exit;
    end;
  end;
end;
//--- 治療処理 ---
{******************************************************************************}
{                                                                              }
{    関数名 func_GetType 　　：電文保存先データベースの取得                    }
{                                                                              }
{  返り値型 String型                                                           }
{           CST_RISTYPE = 1：診断RIS                                           }
{           CST_THERARISTYPE = 2：治療RIS                                      }
{                                                                              }
{      引数 型             名前              タイプ  説明                      }
{           String         arg_LogBuffer     IN/OUT  ログ内容                  }
{                                                                              }
{      例外 なし                                                               }
{                                                                              }
{  機能説明 INIファイルの内容と撮影種コードを比較して保存先DBを確認する。      }
{                                                                              }
{******************************************************************************}
function  TDb_RisSvr_Irai.func_GetType(var arg_LogBuffer: String):String;
begin
  //
  Result := '';
  wm_RTRIS_TypeID := '';
  try
    (*
    if g_TheraRisType_List.Count > 0 then
    begin
      for WI_Loop := 0 to g_TheraRisType_List.Count - 1 do
      begin
        if wm_DataSatueiCode = g_TheraRisType_List.Strings[WI_Loop] then
        begin
          Result := CST_THERARISTYPE;
          //ログ文字列作成
          proc_StrConcat(arg_LogBuffer,'DB特定OK(rtris)');
          wm_RTRIS_TypeID := func_HisToRis(wm_DataSatueiCode);
          Exit;
        end;
      end;
    end;
    *)
    Result := CST_RISTYPE;
    //ログ文字列作成
    proc_StrConcat(arg_LogBuffer,'DB特定OK(rris)');
  except
    on E:exception do
    begin
      //ログ文字列作成
      proc_StrConcat(arg_LogBuffer,'保存先DB取得NG「例外発生'+E.Message+'」');
      //戻り値
      Result := '';
      //処理終了
      Exit;
    end;
  end;
end;
{******************************************************************************}
{                                                                              }
{    関数名 func_GetType_DB　：電文保存先データベースの取得                    }
{                                                                              }
{  返り値型 String型                                                           }
{           CST_RISTYPE = 1：診断RIS                                           }
{           CST_THERARISTYPE = 2：治療RIS                                      }
{                                                                              }
{      引数 型             名前              タイプ  説明                      }
{           String         arg_LogBuffer     IN/OUT  ログ内容                  }
{                                                                              }
{      例外 なし                                                               }
{                                                                              }
{  機能説明 INIファイルの内容と撮影種コードを比較して保存先DBを確認する。      }
{                                                                              }
{******************************************************************************}
function  TDb_RisSvr_Irai.func_GetType_DB(var arg_LogBuffer: String):String;
var
  res: Boolean;
begin
  //
  Result := '';
  try
    //オーダ検索
    res := func_CheckID('ORDERMAINTABLE',
                        '( ORDERNO = ''' + wm_DataOrdeNo + ''' )');
    if res then
    begin
      Result := CST_RISTYPE;
      //ログ文字列作成
      proc_StrConcat(arg_LogBuffer,'DB特定OK(rris)');
      Exit;
    end;

    (*
    //オーダ検索
    res := func_RTCheckID(g_RRISUser + '.ORDERMAINTABLE',
                           '( ORDERNO = ''' + wm_DataOrdeNo + ''' )');
    if res then
    begin
      Result := CST_THERARISTYPE;
      //ログ文字列作成
      proc_StrConcat(arg_LogBuffer,'DB特定OK(rtris)');
      Exit;
    end;
    *)
    //ログ文字列作成
    proc_StrConcat(arg_LogBuffer,'保存先DB取得NG「対象保存先が決定できません OrderNo = ' + wm_DataOrdeNo);
  except
    on E:exception do
    begin
      //ログ文字列作成
      proc_StrConcat(arg_LogBuffer,'保存先DB取得NG「例外発生'+E.Message+'」');
      //戻り値
      Result := '';
      //処理終了
      Exit;
    end;
  end;
end;


//2018/08/30 ToHisInfo登録
{
-----------------------------------------------------------------------------
  名前   : func_InsertToHisInfo
          ToHisInfo登録
-----------------------------------------------------------------------------
}
function TDb_RisSvr_Irai.func_InsertToHisInfo: boolean;
var
  sqlExec: String;
  iRslt:   integer;
begin
  //初期化
  Result := True;
  //トランザクション開始
  FDB.StartTransaction;
  try
    with FQ_ALT do begin
      //SQL文字列作成
      sqlExec :=  'INSERT INTO TOHISINFO'       + #10 +
                  '(REQUESTID, REQUESTDATE'     + #10 +
                  ' ,RIS_ID'                    + #10 +
                  ' ,REQUESTTYPE'               + #10 +
                  ' ,MESSAGEID1, MESSAGEID2'    + #10 +
                  ')VALUES('                    + #10 +
                  ' FROMRISSEQUENCE.NEXTVAL, SYSDATE' + #10 +
                  ',:RIS_ID'                    + #10 +
                  ',''PR01'''                   + #10 +
                  ',:MESSAGEID1, :MESSAGEID2'   + #10 +
                  ')';
      //SQL設定
      PrepareQuery(sqlExec);

      //パラメータ
      SetParam('RIS_ID',      wm_RisID);
      SetParam('MESSAGEID1',  wm_KanjaPatientID);
      SetParam('MESSAGEID2',  wm_KanjaPatientKana);

      //SQL実行
      iRslt:= ExecSQL();
      if iRslt < 0 then begin
        //ロールバック
        FDB.Rollback;
        //失敗
        Result := False;
        //切断
        wg_DBFlg := False;
        //
        Exit;
      end;
    end;
    //コミット
    FDB.Commit;
    //成功
    Result := True;
  except
    //エラー終了処理
    on E:exception do
    begin
      //ロールバック
      FDB.Rollback;
      //ログ文字列作成
      //proc_StrConcat(arg_LogBuffer,'ToHisInfo登録失敗NG「'+E.Message+'」');
      //戻り値
      Result := False;
      //切断
      wg_DBFlg := False;
      //処理終了
      Exit;
    end;
  end;

end;

end.
