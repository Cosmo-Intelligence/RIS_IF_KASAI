unit pdct_uketuke;
{
■機能説明 （使用予定：あり）
 EXEプロジェクトの受付処理共通ルーチン

■履歴
　
修正：2002.11.08：谷川
　　　　　　　　　所在用のIDを検査種別IDから撮影室IDに変更。
追加：2002.11.12：増田 貴
                  当日以外のオーダの場合w_Not_Toujituを追加
                  当日以外オーダを受付する時表示時刻に価を入れない
修正：2003.12.10：谷川
　　　　　　　　　受付登録時,キャンセル時のTENSOUPACSTABLE,TENSOUREPORTTABLEへの書き込みを取り消し。
修正：2003.12.15：谷川
　　　　　　　　　オーダキャンセル時に使用している、オーダ部位テーブルの部位コメントID１～５を部位コメントに変更。
追加：2003.12.16：小泉
                  受付登録処理に同意書区分追加
変更：2004.03.05  実績メインテーブルに読影Fが追加されたことによって受付キャンセル時に読影Fをオーダ時に戻す
追加：2004.04.09：小泉
                  受付・受付キャンセル時に転送オーダテーブルと転送レポートテーブルへの書込み制御を追加
変更：2004.04.12：小泉
                  受付・受付キャンセル時、転送オーダテーブルと転送レポートテーブルに患者ｶﾅ氏名を登録するように変更
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
//  Graphics,
//  Controls,
//  Forms,
//  Dialogs,
  IniFiles,
  FileCtrl,
//  Registry,
//  ExtCtrls,
//  ComCtrls,
//  StdCtrls,
//  Grids,
  jis2sjis,
//プロダクト開発共通－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－
  Gval,
//  myInitInf,
//  pdct_ini,
  pdct_com,
//  KanaRoma,
  ErrorMsg,
  DB_ACC;
//  Trace;

////型クラス宣言-------------------------------------------------------------
//type
//定数宣言-------------------------------------------------------------------

const
CST_MODE_RISORDER = '1'; //RISオーダ登録画面
CST_ERRCODE_00 = '00'; //読み込みエラー
CST_ERRCODE_01 = '51'; //進捗エラー
CST_ERRCODE_02 = '52'; //検査進捗エラー
CST_ERRCODE_05 = '55'; //受付NO取得エラー
CST_ERRCODE_07 = '57'; //電文連番取得エラー
CST_ERRCODE_08 = '58'; //更新権利取得エラー
CST_ERRCODE_10 = '60'; //書き込みエラー

CST_ERRCODE_12 = '62'; //電文連番取得エラー(転送患者情報テーブル用)
CST_ERRCODE_13 = '63'; //電文連番取得エラー(Pacs-Ris転送オーダテーブル用)
CST_ERRCODE_14 = '64'; //電文連番取得エラー(Report-Ris転送オーダテーブル用)
CST_ERRCODE_16 = '66'; //優先フラグエラー
CST_ERRCODE_17 = '67'; //受付エラー
CST_YOBI_MODE_0 = '0'; //呼出解除モード
CST_YOBI_MODE_1 = '1'; //呼出/再呼モード

CST_KAKUHO_MODE_0 = '0'; //確保解除モード
CST_KAKUHO_MODE_1 = '1'; //確保モード

CST_TIKOKU_MODE_0 = '0'; //遅刻解除モード
CST_TIKOKU_MODE_1 = '1'; //遅刻モード

//コメントフィールド名称用
type COM_FIELD = array[1..15] of String;
const
  COM_FIELD_NAME : COM_FIELD =
  ('COMMENT_ID_01','COMMENT_ID_02','COMMENT_ID_03','COMMENT_ID_04','COMMENT_ID_05',
   'COMMENT_ID_06','COMMENT_ID_07','COMMENT_ID_08','COMMENT_ID_09','COMMENT_ID_10',
   'COMMENT_ID_11','COMMENT_ID_12','COMMENT_ID_13','COMMENT_ID_14','COMMENT_ID_15');
//コメントフィールド数
CST_COM_S = 1;
CST_COM_E = 15;

//変数宣言-------------------------------------------------------------------
//var
//関数手続き宣言-------------------------------------------------------------
//●機能（例外有）：受付処理
function func_Uketuke_Kyotu(
         arg_DB:TDatabase;             //接続されたDB
         arg_Mode:string;              //0:受付処理、1:RISオーダ登録の受付処理
         arg_PROG_ID:string;           //プログラムID
         arg_Ris_ID:TStrings;            //RIS識別ID
         arg_Kanja_ID:string;          //患者ID
         arg_KensaDate:string;         //予約日(yyyy/mm/dd)
         arg_Uketukesya_ID:string;     //受付者ID
         arg_Kensastatus_Flg:string;   //更新前の検査進捗
         arg_Kensasubstatus_Flg:string; //更新前の検査進捗ｻﾌﾞﾌﾗｸﾞ
         arg_Kensatype_ID:string;      //更新前の検査種別(RISオーダ登録のみ)
         arg_Kensatype_Name:string;    //更新前の検査種別名称(RISオーダ登録のみ)
         arg_Douji_Uke_Flg: string;    //同時受付の有無(0:なし、1:あり)(受付登録のみ)        －未使用
         arg_UkeJun:string;            //同時受付の受付順(受付登録のみ、同時受付有の場合のみ)－未使用
         arg_First_KensatypeID:string; //同時受付の最初の検査種別(受付登録のみ、同時受付有で受付順が２番目以降の場合のみ)－未使用
         arg_RenrakuMemo: string;      //連絡メモ
         arg_DouishoKbn: string;       //同意書区分 //2003.12.16
         var arg_Error_Code:string;    //エラーコード
         var arg_Error_Message:string; //エラーメッセージ
         var arg_Error_SQL:string;     //エラーSQL文
         var arg_Error_Haita:Boolean   //排他削除エラー True:排他ﾃｰﾌﾞﾙ削除失敗、False:排他ﾃｰﾌﾞﾙ削除成功
         ):Integer;                    //結果0:成功、1:排他/進捗ｴﾗｰ、2:進捗更新ｴﾗｰ、3:送信ﾃｰﾌﾞﾙ書込みｴﾗｰ
//●機能（例外有）：受付処理(ポータブル)
function func_Uketuke_Portable(
         arg_DB:TDatabase;             //接続されたDB
         arg_Mode:string;              //0:受付処理、1:RISオーダ登録の受付処理
         arg_PROG_ID:string;           //プログラムID
         arg_Ris_ID:TStrings;            //RIS識別ID
         arg_Kanja_ID:Tstrings;          //患者ID
         arg_KensaDate:string;         //予約日(yyyy/mm/dd)
         arg_Uketukesya_ID:string;     //受付者ID
         var arg_Error_Code:string;    //エラーコード
         var arg_Error_Message:string; //エラーメッセージ
         var arg_Error_SQL:string;     //エラーSQL文
         var arg_Error_Haita:Boolean   //排他削除エラー True:排他ﾃｰﾌﾞﾙ削除失敗、False:排他ﾃｰﾌﾞﾙ削除成功
         ):Integer;                    //結果0:成功、1:排他/進捗ｴﾗｰ、2:進捗更新ｴﾗｰ、3:送信ﾃｰﾌﾞﾙ書込みｴﾗｰ
//●機能（例外有）：RIS識別ID作成
function func_Uketuke_Make_RisID(
         arg_DB:TDatabase;             //接続されたDB
         arg_Query:TQuery;             //接続されたQuery
         arg_DateTime:string           //処理日時
         ):string;
//●機能（例外有）：オーダNO作成
function func_Uketuke_Make_OrderNO(
         arg_DB:TDatabase;             //接続されたDB
         arg_Query:TQuery;             //接続されたQuery
         arg_DateTime:string           //処理日時
         ):string;
//●機能（例外有）：受付NO作成
function func_Uketuke_Make_UketukeNO(
         arg_DB:TDatabase;             //接続されたDB
         arg_Query:TQuery;             //接続されたQuery
         arg_DateTime:string;          //処理日時
         arg_KID:string                //区分
         ):string;
//●機能（例外有）：当日NO作成
function func_Uketuke_Make_ToujituNO(
         arg_DB:TDatabase;             //接続されたDB
         arg_Query:TQuery;             //接続されたQuery
         arg_DateTime:string           //処理日時
         ):string;
//●機能（例外有）：電文連番作成
function func_Uketuke_Make_DenbunNO(
         arg_DB:TDatabase;             //接続されたDB
         arg_Query:TQuery;             //接続されたQuery
         arg_DateTime:string           //処理日時
         ):string;
//●機能（例外有）：電文連番作成(転送患者情報テーブル)
function func_Uketuke_Make_KanjaDenbunNO(
         arg_DB:TDatabase;             //接続されたDB
         arg_Query:TQuery;             //接続されたQuery
         arg_DateTime:string           //処理日時
         ):string;
//●機能（例外有）：電文連番作成(Pacs-Ris転送オーダテーブル)
function func_Uketuke_Make_PacsDenbunNO(
         arg_DB:TDatabase;             //接続されたDB
         arg_Query:TQuery;             //接続されたQuery
         arg_DateTime:string           //処理日時
         ):string;
//●機能（例外有）：電文連番作成(Report-Ris転送オーダテーブル)
function func_Uketuke_Make_ReportDenbunNO(
         arg_DB:TDatabase;             //接続されたDB
         arg_Query:TQuery;             //接続されたQuery
         arg_DateTime:string           //処理日時
         ):string;
//●機能（例外有）：SUID当日連番作成
function func_Uketuke_Make_ToujituSUID(
         arg_DB:TDatabase;             //接続されたDB
         arg_Query:TQuery;             //接続されたQuery
         arg_DateTime:string           //処理日時
         ):string;
//●機能（例外有）：受付キャンセル処理
function func_UketukeCancel_Kyotu(
         arg_DB:TDatabase;             //接続されたDB
         arg_PROG_ID:string;           //プログラムID
         arg_Ris_ID:string;            //RIS識別ID
         arg_Kanja_ID:string;          //患者ID
         arg_KensaDate:string;         //予約日(yyyy/mm/dd)
         arg_Uketukesya_Name:string;   //受付者名
         arg_Kensastatus_Flg:string;   //更新前の検査進捗
         arg_KensaSubstatus_Flg:string;   //更新前の検査進捗サブ
         var arg_Error_Code:string;    //エラーコード
         var arg_Error_Message:string; //エラーメッセージ
         var arg_Error_SQL:string;     //エラーSQL文
         var arg_Error_Haita:Boolean   //排他削除エラー True:排他ﾃｰﾌﾞﾙ削除失敗、False:排他ﾃｰﾌﾞﾙ削除成功
         ):Integer;                    //結果0:成功、1:排他/進捗ｴﾗｰ、2:進捗更新ｴﾗｰ、3:送信ﾃｰﾌﾞﾙ書込みｴﾗｰ


{2002.12.06
//●機能（例外有）：WorklistInfo作成
function func_WorklistInfo_Kyotu(
         arg_DB:TDatabase;             //接続されたDB
         arg_Ris_ID: string;           //RIS識別ID
         var arg_Error_Message:string  //エラーメッセージ
         ):Boolean;
2002.12.06}

//●機能（例外有）：受付優先フラグの切り替え処理
function func_Yuusen_Change(
         arg_DB:TDatabase;             //接続されたDB
         arg_PROG_ID:string;           //プログラムID
         arg_Ris_ID:string;            //RIS識別ID
         arg_YuusenFlg:string;         //優先フラグ（現在の値）
         arg_NewYuusenFlg:string;      //変更優先フラグ（変更すべき値）
         var arg_Error_Code:string;    //エラーコード
         var arg_Error_Message:string; //エラーメッセージ
         var arg_Error_SQL:string;      //エラーSQL文
         var arg_Error_Haita:Boolean   //排他削除エラー True:排他ﾃｰﾌﾞﾙ削除失敗、False:排他ﾃｰﾌﾞﾙ削除成功
         ):boolean;                    //結果True成功 False失敗


//●機能（例外有）：遅刻ステータスの切り替え処理
function func_Tikoku_Change(
         arg_DB:TDatabase;             //接続されたDB
         arg_PROG_ID:string;           //プログラムID
         arg_Ris_ID:string;            //RIS識別ID
         arg_Status:string;            //ステータス（未受/検中）
         arg_SubStatus:string;         //サブステータス（未受/呼出/再呼/保留/再受）
         arg_Mode:string;              //遅刻/解除モード（1:遅刻/0:解除）
         var arg_Error_Code:string;    //エラーコード
         var arg_Error_Message:string; //エラーメッセージ
         var arg_Error_SQL:string;     //エラーSQL文
         var arg_Error_Haita:Boolean   //排他削除エラー True:排他ﾃｰﾌﾞﾙ削除失敗、False:排他ﾃｰﾌﾞﾙ削除成功
         ):boolean;                    //結果True成功 False失敗

//●機能（例外有）：呼出、再呼ステータスの切り替え処理
function func_Yobidasi_Change(
         arg_DB:TDatabase;             //接続されたDB
         arg_PROG_ID:string;           //プログラムID
         arg_Ris_ID:string;            //RIS識別ID
         arg_Status:string;            //ステータス（未受/検中）
         arg_SubStatus:string;         //サブステータス（未受/呼出/再呼/保留/再受）
         arg_Mode:string;              //呼出/解除モード（1:呼出、再呼/0:解除）
         var arg_Error_Code:string;    //エラーコード
         var arg_Error_Message:string; //エラーメッセージ
         var arg_Error_SQL:string;     //エラーSQL文
         var arg_Error_Haita:Boolean   //排他削除エラー True:排他ﾃｰﾌﾞﾙ削除失敗、False:排他ﾃｰﾌﾞﾙ削除成功
         ):boolean;                    //結果True成功 False失敗

//●機能（例外有）：確保ステータスの切り替え処理
function func_Kakuho_Change(
         arg_DB:TDatabase;             //接続されたDB
         arg_PROG_ID:string;           //プログラムID
         arg_Ris_ID:string;            //RIS識別ID
         arg_Status:string;            //ステータス（受済）
         arg_Mode:string;              //呼出/解除モード（1:確保/0:解除）
         var arg_Error_Code:string;    //エラーコード
         var arg_Error_Message:string; //エラーメッセージ
         var arg_Error_SQL:string;     //エラーSQL文
         var arg_Error_Haita:Boolean   //排他削除エラー True:排他ﾃｰﾌﾞﾙ削除失敗、False:排他ﾃｰﾌﾞﾙ削除成功
         ):boolean;                    //結果True成功 False失敗

procedure proc_Get_Lock_HaitaData(
          arg_Query:TQuery;         //接続されたQuery
          arg_Ris_ID:String;        //RIS識別ID
          var arg_Tan:String;       //端末名
          var arg_Kanja:String;     //患者ID
          var arg_KensaDate:string; //検査日付YYYY/MM/DD
          var arg_Kensa_Name:String //検査名
          );   //検査種別名
//●更新と最新の進捗のチェック
function proc_Kousin_Sintyoku(
          arg_DB:TDatabase;             //接続されたDB
          arg_PROG_ID:string;           //プログラムID
          arg_Ris_ID:TStrings;
          arg_Kanja_ID:TStrings;
          arg_RomaSimei:TStrings;
          arg_main:TStrings;
          arg_Sub:TStrings;
          var arg_Error_Code:string;    //エラーコード
          var arg_Error_Message:string; //エラーメッセージ
          var arg_Error_SQL:string     //エラーSQL文
          ):Integer;                    //結果0:成功、1:排他/進捗ｴﾗｰ
//●更新権利の返還
procedure proc_Kousin_Henkan(
                               arg_DB:TDatabase;             //接続されたDB
                               arg_PROG_ID:string;           //プログラムID
                               arg_Ris_ID:TStrings
                               );


implementation

uses DB; //**************************************************************

//使用ユニット---------------------------------------------------------------
//uses

//定数宣言       -------------------------------------------------------------
const
//テーブル情報
CST_TBL_KANRI      = 'KanriTable';//管理テーブル名
CST_TBLIN_TAN_NAME = 'tan_name';  //管理テーブル項目名 端末名
CST_TBLIN_PRODID   = 'prog_id';   //管理テーブル項目名 プログラムID
CST_TBLIN_RISID    = 'ris_id';    //管理テーブル項目名 RIS識別ID
CST_TBLIN_SYORIMODE= 'syori_mode';//管理テーブル項目名 モード

//変数宣言     ---------------------------------------------------------------
//var
//関数手続き宣言--------------------------------------------------------------
//使用可能関数－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－


//名称コード変換処理－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－

//******************************************************************************
// ※受付処理
//******************************************************************************
function func_Uketuke_Kyotu(
         arg_DB:TDatabase;             //接続されたDB
         arg_Mode:string;              //0:受付処理、1:RISオーダ登録の受付処理
         arg_PROG_ID:string;           //プログラムID
         arg_Ris_ID:TStrings;            //RIS識別ID
         arg_Kanja_ID:string;          //患者ID
         arg_KensaDate:string;         //予約日(yyyy/mm/dd)
         arg_Uketukesya_ID:string;     //受付者ID
         arg_Kensastatus_Flg:string;   //更新前の検査進捗
         arg_Kensasubstatus_Flg:string; //更新前の検査進捗ｻﾌﾞﾌﾗｸﾞ
         arg_Kensatype_ID:string;      //更新前の検査種別(RISオーダ登録のみ)
         arg_Kensatype_Name:string;    //更新前の検査種別名称(RISオーダ登録のみ)
         arg_Douji_Uke_Flg: string;    //同時受付の有無(0:なし、1:あり)(受付登録のみ)        －未使用
         arg_UkeJun:string;            //同時受付の受付順(受付登録のみ、同時受付有の場合のみ)－未使用
         arg_First_KensatypeID:string; //同時受付の最初の検査種別(受付登録のみ、同時受付有で受付順が２番目以降の場合のみ)－未使用
         arg_RenrakuMemo: string;      //連絡メモ
         arg_DouishoKbn: string;       //同意書区分 //2003.12.16
         var arg_Error_Code:string;    //エラーコード
         var arg_Error_Message:string; //エラーメッセージ
         var arg_Error_SQL:string;     //エラーSQL文
         var arg_Error_Haita:Boolean   //排他削除エラー True:排他ﾃｰﾌﾞﾙ削除失敗、False:排他ﾃｰﾌﾞﾙ削除成功
         ):Integer;                    //結果0:成功、1:排他/進捗ｴﾗｰ、2:進捗更新ｴﾗｰ、3:送信ﾃｰﾌﾞﾙ書込みｴﾗｰ
var
  w_Query_Data: TQuery;
  w_Query_Update: TQuery;

  w_DateTime: TDateTime;
  w_Tan_Name: string;
  w_Date: string;
  w_Time: string;
//実績メインデータ
  w_EX_KENSASTATUS_FLG: string;
  w_EX_KENSASUBSTATUS_FLG: string;
  w_EX_KENSATYPE_ID: string;
  w_EX_KENSATYPE_NAME: string;
  w_EX_UKETUKE_TANTOU_ID: string;
  w_EX_Renraku_Memo: string;
  w_RenrakuMemo_FieldSize:Integer;
  w_EX_Kanja_ID: string;
//オーダメインデータ
  w_OD_SYSTEMKBN: string;
//患者マスタデータ
  w_KJ_ROMASIMEI: string;
  w_KJ_BIRTHDAY: string;
  w_KJ_SEX: string;
  w_KJ_KANJA_NYUGAIKBN: string;
  w_KJ_SECTION_ID: string;
  w_KJ_BYOUTOU_ID: string;
  w_KJ_BYOUSITU_ID: string;
//
  w_KensaDate_Age: string;      //検査時年齢
  w_New_Uketuke_NO: string;     //新規の受付NO
  w_New_Denbun_NO: string;      //新規の電文連番
  w_New_KanjaDenbun_NO: string; //新規の電文連番(転送患者情報テーブル)
  w_New_PacsDenbun_NO: string;  //新規の電文連番(Pacs-Ris転送オーダテーブル)
  w_New_ReportDenbun_NO: string;//新規の電文連番(Report-Risオーダテーブル)

  w_New_KENSA_DATE: string;     //検査日
  w_Now_KENSA_DATE: string;

  w_Flg_Kensa:string;           //検査進捗のﾁｪｯｸ
  w_New_AccessionNo:string;     //新AccessionNo.（オーダNo.+HIS発行日付）

  w_i:integer;

  wt_Flg_Kensa:TStrings;
  wt_Kensa_Date:TStrings;
  wt_RomaSimei:TStrings;
  wt_KensaType_Name:TStrings;
  wt_OrderNo:TStrings;
  wt_SystemKbn:TStrings;   //2004.02.05

  wt_New_Uketuke_NO:TStrings;   //2004.04.20

begin
  arg_Error_Code := '';
  arg_Error_Message := '';
  arg_Error_SQL := '';
  Result := 0;
  arg_Error_Haita := False;
  w_Query_Data := TQuery.Create(nil);
  w_Query_Data.DatabaseName := arg_DB.DatabaseName;
  w_Query_Update := TQuery.Create(nil);
  w_Query_Update.DatabaseName := arg_DB.DatabaseName;

  wt_Flg_Kensa  := TStringList.Create;
  wt_RomaSimei  := TStringList.Create;
  wt_Kensa_Date := TStringList.Create;
  wt_KensaType_Name := TStringList.Create;
  wt_OrderNo    := TStringList.Create;
  //2004.04.20
  wt_New_Uketuke_NO := TStringList.Create;

  //現在日時取得
  w_DateTime := func_GetDBSysDate(w_Query_Data);
  //現在日付取得
  w_Date := FormatDateTime(CST_FORMATDATE_1, w_DateTime);
  //現在時刻取得
  w_Time := FormatDateTime(CST_FORMATDATE_4, w_DateTime);
  //コンピュータ名取得
  w_Tan_Name := func_GetThisMachineName;
  //検査日
  w_New_KENSA_DATE := func_Date10To8(FormatDateTime(CST_FORMATDATE_1 ,w_DateTime));

  //検査進捗・排他管理処理
  try
    //トランザクション獲得
    arg_DB.StartTransaction;
    //ROOP
    for w_i := 0 to arg_Ris_ID.Count -1 do begin
      //更新権利取得
      if not func_GetWKAnriUketuke(arg_DB,     //接続されたDB
                            w_Tan_Name,        //PC名称
                            arg_PROG_ID,       //プログラムID
                            arg_Ris_ID[w_i]    //RIS識別ID
                           ) then begin
         proc_Get_Lock_HaitaData(w_Query_Data,
                                 arg_Ris_ID[w_i],
                                 w_Tan_Name,
                                 w_EX_Kanja_ID,
                                 w_Now_KENSA_DATE,
                                 w_EX_KENSATYPE_NAME);
         arg_Error_Message := #13#10
                            +#13#10+'端末名　　：'+w_Tan_Name
                            +#13#10+'患者ＩＤ　：'+w_EX_Kanja_ID
                            +#13#10+'実績検査日：'+w_Now_KENSA_DATE
                            +#13#10+'検査種別　：'+w_EX_KENSATYPE_ID
                            +#13#10+'ＲＩＳＩＤ：'+arg_Ris_ID[w_i]
                            ;
        arg_Error_Code := CST_ERRCODE_08; //更新権利取得エラー
        Result := 1;
        Break;
      end;
      //オーダメイン、実績メイン、患者マスタより最新情報の取得
      if arg_Mode = CST_MODE_RISORDER then begin
      end
      else begin
        with w_Query_Data do begin
          Close;
          SQL.Clear;
          SQL.Add ('SELECT exma.RIS_ID ');
          SQL.Add ('      ,exma.KANJAID ');
          SQL.Add ('      ,exma.KENSASTATUS_FLG ');
          SQL.Add ('      ,exma.KENSASUBSTATUS_FLG ');
          SQL.Add ('      ,exma.KENSATYPE_ID ');
          SQL.Add ('      ,exma.KENSA_DATE ');
          SQL.Add ('FROM   EXMAINTABLE exma ');
          SQL.Add ('WHERE  exma.RIS_ID  = :PRIS_ID ');
          SQL.Add ('  AND  exma.KANJAID = :PKANJAID ');
          if not Prepared then Prepare;
          ParamByName('PRIS_ID').AsString  := arg_Ris_ID[w_i];
          ParamByName('PKANJAID').AsString := arg_Kanja_ID;
          Open;
          Last;
          First;
          if not(w_Query_Data.Eof) and
            (w_Query_Data.RecordCount > 0) then begin
            //最新の検査進捗ﾁｪｯｸ
            if (FieldByName('KENSASTATUS_FLG').AsString <> GPCST_CODE_KENSIN_0) and
              (FieldByName('KENSASTATUS_FLG').AsString <>  GPCST_CODE_KENSIN_2) then begin
              //受付登録不可
              arg_Error_Code := CST_ERRCODE_02; //進捗エラー
              arg_Error_Message := #13#10
                                  +#13#10+'患者ＩＤ　：'+arg_Kanja_ID
                                  +#13#10+'ＲＩＳＩＤ：'+arg_Ris_ID[w_i]
                                  ;
              Result := 1;
              Close;
              Break;
            end;
            if (FieldByName('KENSASTATUS_FLG').AsString = GPCST_CODE_KENSIN_2) and
              ((FieldByName('KENSASUBSTATUS_FLG').AsString <> GPCST_CODE_KENSIN_SUB_8) and
              (FieldByName('KENSASUBSTATUS_FLG').AsString <> GPCST_CODE_KENSIN_SUB_9)) then begin
              //受付登録不可
              arg_Error_Code := CST_ERRCODE_02; //進捗エラー
              arg_Error_Message := #13#10
                                  +#13#10+'患者ＩＤ　：'+arg_Kanja_ID
                                  +#13#10+'ＲＩＳＩＤ：'+arg_Ris_ID[w_i]
                                  ;
              Result := 1;
              Close;
              Break;
            end;

            w_Now_KENSA_DATE      := func_Date8To10(FieldByName('KENSA_DATE').AsString);

            w_EX_KENSATYPE_ID     := FieldByName('KENSATYPE_ID').AsString;
          end
          else begin
            arg_Error_Code := CST_ERRCODE_01; //読み込みエラー
            arg_Error_Message := #13#10
                                +#13#10+'患者ＩＤ　：'+arg_Kanja_ID
                                +#13#10+'ＲＩＳＩＤ：'+arg_Ris_ID[w_i]
                                ;
            Result := 1;
            Close;
            Break;
          end;
          Close;
        end;
      end;
    end;  //Roop End
    //エラーチェック
    //エラーが存在した時は、排他管理Rollback
    //エラーが存在しなかった時は、排他管理Commit
    if Result <> 0 then begin
      arg_DB.Rollback;
      w_Query_Data.Close;
      Result := 1;

      w_Query_Data.Free;
      w_Query_Update.Free;

      wt_Flg_Kensa.Free;
      wt_RomaSimei.Free;
      wt_Kensa_Date.Free;
      wt_KensaType_Name.Free;
      wt_OrderNo.Free;
      //2004.04.20
      wt_New_Uketuke_NO.Free;

      Exit;
    end else begin
      arg_DB.Commit;
    end;
  Except
    on E: Exception do begin
      arg_DB.Rollback; // コミットで失敗した場合，変更を取り消す
      arg_Error_Code := CST_ERRCODE_10; //登録失敗
      arg_Error_Message := #13#10
                         + #13#10+'commit'
                         + #13#10+E.Message;
      arg_Error_SQL := w_Query_Data.SQL.Text;
      w_Query_Data.Close;
      Result := 1;

      w_Query_Data.Free;
      w_Query_Update.Free;

      wt_Flg_Kensa.Free;
      wt_RomaSimei.Free;
      wt_Kensa_Date.Free;
      wt_KensaType_Name.Free;
      wt_OrderNo.Free;
      //2004.04.20
      wt_New_Uketuke_NO.Free;
      Exit;
    end;
  end;

  try
{--- 2004.04.20 Start ---
  //受付番号取得
    //受付№(日付管理あり)
    w_New_Uketuke_NO := '';
    w_New_Uketuke_NO := func_Uketuke_Make_UketukeNO(arg_DB,
                                                    w_Query_Data,
                                                    FormatDateTime(CST_FORMATDATE_3, w_DateTime),
                                                    'UNO'
                                                   );
    if w_New_Uketuke_NO = '' then begin
      arg_Error_Code := CST_ERRCODE_05; //受付NO取得エラー
      Result := 1;
      Exit;
    end;
}
    try
      for w_i := 0 to arg_Ris_ID.Count -1 do begin
        //受付№(日付管理あり)
        wt_New_Uketuke_NO.Add('');
        wt_New_Uketuke_NO[w_i] := func_Uketuke_Make_UketukeNO(arg_DB,
                                                    w_Query_Data,
                                                    FormatDateTime(CST_FORMATDATE_3, w_DateTime),
                                                    'UNO'
                                                   );
        if wt_New_Uketuke_NO[w_i] = '' then begin
          arg_Error_Code := CST_ERRCODE_05; //受付NO取得エラー
          Result := 1;

          w_Query_Data.Free;
          w_Query_Update.Free;

          wt_Flg_Kensa.Free;
          wt_RomaSimei.Free;
          wt_Kensa_Date.Free;
          wt_KensaType_Name.Free;
          wt_OrderNo.Free;
          //2004.04.20
          wt_New_Uketuke_NO.Free;
          Exit;
        end;
      end;
    Except
      on E: Exception do begin
        arg_Error_Code := CST_ERRCODE_05; //登録失敗
        arg_Error_Message := #13#10
                           + #13#10+E.Message;
        w_Query_Data.Close;
        Result := 1;


        w_Query_Data.Free;
        w_Query_Update.Free;

        wt_Flg_Kensa.Free;
        wt_RomaSimei.Free;
        wt_Kensa_Date.Free;
        wt_KensaType_Name.Free;
        wt_OrderNo.Free;
        //2004.04.20
        wt_New_Uketuke_NO.Free;
        Exit;
      end;
    end;
//--- 2004.04.20 End---
    //2004.02.05
    wt_SystemKbn    := TStringList.Create;

    //実績ﾒｲﾝ・患者ﾏｽﾀ更新処理
    Try
      arg_DB.StartTransaction;

      for w_i := 0 to arg_Ris_ID.Count -1 do begin
        //オーダメイン、実績メイン、患者マスタより最新情報の取得
        if arg_Mode = CST_MODE_RISORDER then begin
          with w_Query_Data do begin
            Close;
            SQL.Clear;
            SQL.Add ('SELECT kj.ROMASIMEI ');
            SQL.Add ('      ,kj.BIRTHDAY ');
            SQL.Add ('      ,kj.SEX ');
            SQL.Add ('      ,kj.KANASIMEI'); //2004.04.12
            SQL.Add ('FROM   KANJAMASTER kj ');
            SQL.Add ('WHERE  kj.KANJAID   = :PKANJAID ');
            if not Prepared then Prepare;
            ParamByName('PKANJAID').AsString := arg_Kanja_ID;
            Open;
            Last;
            First;
            if not(w_Query_Data.Eof) and
              (w_Query_Data.RecordCount > 0) then begin
              //2004.04.12
              //w_KJ_ROMASIMEI       := FieldByName('ROMASIMEI').AsString;
              w_KJ_ROMASIMEI       := FieldByName('KANASIMEI').AsString;

              if FieldByName('BIRTHDAY').AsString <> '' then
                w_KJ_BIRTHDAY      := func_Date8To10(FieldByName('BIRTHDAY').AsString)
              else
                w_KJ_BIRTHDAY      := '';
              w_KJ_SEX       := FieldByName('SEX').AsString;
            end else begin
              arg_Error_Code := CST_ERRCODE_01; //読み込みエラー
              Result := 2;
              Exit;
            end;
            //その他の情報は固定値
            w_EX_KENSASTATUS_FLG    := GPCST_CODE_KENSIN_0; //未受付
            w_EX_KENSASUBSTATUS_FLG := '';
            w_EX_KENSATYPE_ID       := arg_Kensatype_ID;
            w_EX_KENSATYPE_NAME     := arg_Kensatype_Name;
            w_OD_SYSTEMKBN          := GPCST_CODE_SYSK_RIS; //RIS
            //更新前の検査進捗は未受付にする
            arg_Kensastatus_Flg     := GPCST_CODE_KENSIN_0;
            arg_Kensasubstatus_Flg  := '';
          end;
        end else begin
          with w_Query_Data do begin
            Close;
            SQL.Clear;
            SQL.Add ('SELECT exma.RIS_ID ');
            SQL.Add ('      ,exma.KANJAID ');
            SQL.Add ('      ,exma.KENSASTATUS_FLG ');
            SQL.Add ('      ,exma.KENSASUBSTATUS_FLG ');
            SQL.Add ('      ,exma.KENSATYPE_ID ');
            SQL.Add ('      ,ktyp.KENSATYPE_NAME ');
            SQL.Add ('      ,exma.KENSA_DATE ');
            SQL.Add ('      ,exma.UKETUKE_TANTOU_ID ');
            SQL.Add ('      ,exma.RENRAKU_MEMO ');
            SQL.Add ('      ,odma.SYSTEMKBN ');
            SQL.Add ('      ,odma.ORDERNO ');
{2003.02.05 start}
            SQL.Add ('      ,to_char(odma.HIS_HAKKO_DATE,''YYYYMMDD'') HIS_HAKKO_DATE ');
{2003.02.05 end}
            SQL.Add ('      ,kj.ROMASIMEI ');
            SQL.Add ('      ,kj.BIRTHDAY ');
            SQL.Add ('      ,kj.SEX ');
            SQL.Add ('      ,kj.KANJA_NYUGAIKBN ');
            SQL.Add ('      ,kj.SECTION_ID ');
            SQL.Add ('      ,kj.BYOUTOU_ID ');
            SQL.Add ('      ,kj.BYOUSITU_ID ');
            SQL.Add ('      ,kj.KANASIMEI '); //2004.04.12
            SQL.Add ('FROM   EXMAINTABLE exma,ORDERMAINTABLE odma,KANJAMASTER kj,KENSATYPEMASTER ktyp ');
            SQL.Add ('WHERE  exma.RIS_ID  = :PRIS_ID ');
            SQL.Add ('  AND  exma.KANJAID = :PKANJAID ');
            SQL.Add ('  AND  exma.KENSATYPE_ID = ktyp.KENSATYPE_ID(+) ');
            SQL.Add ('  AND  odma.RIS_ID  = exma.RIS_ID ');
            SQL.Add ('  AND  kj.KANJAID   = exma.KANJAID ');
            if not Prepared then Prepare;
            ParamByName('PRIS_ID').AsString  := arg_Ris_ID[w_i];
            ParamByName('PKANJAID').AsString := arg_Kanja_ID;
            Open;
            Last;
            First;
            if not(w_Query_Data.Eof) and
              (w_Query_Data.RecordCount > 0) then begin
              //検査進捗ﾒｲﾝﾌﾗｸﾞと検査進捗ｻﾌﾞﾌﾗｸﾞのﾁｪｯｸ
              //検査進捗ﾒｲﾝﾌﾗｸﾞが未受付で、検査進捗ｻﾌﾞﾌﾗｸﾞがDefの場合'0'をセット
              w_Flg_Kensa := '';
              if FieldByName('KENSASTATUS_FLG').AsString = GPCST_CODE_KENSIN_0 then begin
                w_Flg_Kensa := '0';
              end;
              //検査進捗ﾒｲﾝﾌﾗｸﾞが検中で、検査進捗ｻﾌﾞﾌﾗｸﾞが8：保留または9:再呼の場合'2'をセット
              if (FieldByName('KENSASTATUS_FLG').AsString = GPCST_CODE_KENSIN_2) and
                ((FieldByName('KENSASUBSTATUS_FLG').AsString = GPCST_CODE_KENSIN_SUB_8 ) or
                (FieldByName('KENSASUBSTATUS_FLG').AsString = GPCST_CODE_KENSIN_SUB_9 )) then begin
                w_Flg_Kensa := '2';
              end;

              wt_Flg_Kensa.Add(w_Flg_Kensa);
              wt_Kensa_Date.Add(FieldByName('KENSA_DATE').AsString);

              w_EX_KENSATYPE_ID           := FieldByName('KENSATYPE_ID').AsString;
              w_EX_UKETUKE_TANTOU_ID      := FieldByName('UKETUKE_TANTOU_ID').AsString;
              w_EX_Renraku_Memo           := FieldByName('RENRAKU_MEMO').AsString;
            {2002.12.26 start}
              w_RenrakuMemo_FieldSize     := FieldByName('RENRAKU_MEMO').Size;
            {2002.12.26 end}
              //2004.04.12
              //w_KJ_ROMASIMEI              := FieldByName('ROMASIMEI').AsString;
              w_KJ_ROMASIMEI              := FieldByName('KANASIMEI').AsString;

              w_EX_KENSATYPE_NAME         := Copy(FieldByName('KENSATYPE_NAME').AsString,1,20);
              wt_KensaType_Name.Add(w_EX_KENSATYPE_NAME);

              //オーダNoの格納 2003.01.08
{2003.02.05
              wt_OrderNo.Add(FieldByName('ORDERNO').AsString);
2003.02.05}
{2003.12.18 start}
              //新AccessionNo.の作成
              //w_New_AccessionNo := Right('00000000'+FieldByName('ORDERNO').AsString,8) + FieldByName('HIS_HAKKO_DATE').AsString;
              w_New_AccessionNo := FieldByName('ORDERNO').AsString;
              wt_OrderNo.Add(w_New_AccessionNo);
{2003.12.18 end}

              wt_RomaSimei.Add(w_KJ_ROMASIMEI);

              //2004.02.05
              wt_SystemKbn.Add(FieldByName('SYSTEMKBN').AsString);

              if FieldByName('BIRTHDAY').AsString <> '' then
                w_KJ_BIRTHDAY      := func_Date8To10(FieldByName('BIRTHDAY').AsString)
              else
                w_KJ_BIRTHDAY       := '';

              w_KJ_KANJA_NYUGAIKBN  := FieldByName('KANJA_NYUGAIKBN').AsString;
              w_KJ_SECTION_ID       := FieldByName('SECTION_ID').AsString;
              w_KJ_BYOUTOU_ID       := FieldByName('BYOUTOU_ID').AsString;
              w_KJ_BYOUSITU_ID      := FieldByName('BYOUSITU_ID').AsString;

            end else begin
              arg_Error_Code := CST_ERRCODE_01; //読み込みエラー
              arg_Error_Message := #13#10
                                  +#13#10+'患者ＩＤ　：'+arg_Kanja_ID
                                  +#13#10+'ＲＩＳＩＤ：'+arg_Ris_ID[w_i]
                                  ;
              Result := 2;
              break;
            end;
          end;
        end;
        //検査日年齢
        w_KensaDate_Age := '999';
        if w_KJ_BIRTHDAY <> '' then begin
          w_KensaDate_Age := IntToStr(func_GetAgeofCase(func_StrToDate(w_KJ_BIRTHDAY), func_StrToDate(arg_KensaDate), 0));
        end;
  //更新処理開始
    //RISオーダ登録---------------------------------------------------------------
        if arg_Mode = CST_MODE_RISORDER then begin

        end
    //通常登録--------------------------------------------------------------------
        else begin
          //ロック
          with w_Query_Data do begin
            Close;
            SQL.Clear;
            SQL.Add ('SELECT orma.RIS_ID ');
            SQL.Add ('FROM   ORDERMAINTABLE orma ');
            SQL.Add ('WHERE  orma.RIS_ID = :PRIS_ID ');
            SQL.Add (' for update ');
            if not Prepared then Prepare;
            ParamByName('PRIS_ID').AsString := arg_Ris_ID[w_i];
            ExecSQL;
          end;
          //実績メインテーブル
          with w_Query_Update do begin
            Close;
            SQL.Clear;
            SQL.Add('UPDATE EXMAINTABLE SET ');
            SQL.Add(' KENSASTATUS_FLG        = :PKENSASTATUS_FLG ');
            SQL.Add(',KENSASUBSTATUS_FLG     = :PKENSASUBSTATUS_FLG ');
            SQL.Add(',UKETUKE_TANTOU_ID      = :PUKETUKE_TANTOU_ID ');
            SQL.Add(',UKETUKE_UPDATE_DATE    = :PUKETUKE_UPDATE_DATE ');
            SQL.Add(',UKETUKE_JISSI_TERMINAL = :PUKETUKE_JISSI_TERMINAL ');
{2002.12.17
            SQL.Add(',KENSA_DATE             = :PKENSA_DATE ');
            SQL.Add(',KENSA_DATE_AGE         = :PKENSA_DATE_AGE ');
2002.12.17}
            SQL.Add(',KANJA_NYUGAIKBN        = :PKANJA_NYUGAIKBN ');
            SQL.Add(',KANJA_SECTION_ID       = :PKANJA_SECTION_ID ');
            SQL.Add(',KANJA_BYOUTOU_ID       = :PKANJA_BYOUTOU_ID ');
            SQL.Add(',KANJA_BYOUSITU_ID      = :PKANJA_BYOUSITU_ID ');
            SQL.Add(',RENRAKU_MEMO           = :PRENRAKU_MEMO ');
            SQL.Add(',DOUISHO_FLG            = :PDOUISHO_FLG '); //2003.12.16
            SQL.Add(',UKETUKE_NO             = :PUKETUKE_NO '); //2004.04.20
            SQL.Add('WHERE RIS_ID = :PRIS_ID ');
            if not Prepared then Prepare;

            //検査進捗ﾌﾗｸﾞが、0:未受付の時
            if w_Flg_Kensa = GPCST_CODE_KENSIN_0 then begin
              ParamByName('PKENSASTATUS_FLG').AsString      := GPCST_CODE_KENSIN_1; //受付済
              ParamByName('PKENSASUBSTATUS_FLG').AsString   := '';
              ParamByName('PUKETUKE_TANTOU_ID').AsString    := arg_Uketukesya_ID;
            end;
            //検査進捗ﾌﾗｸﾞが、2:検中で検査進捗ｻﾌﾞﾌﾗｸﾞが8:保留または9:再呼の時
            if w_Flg_Kensa = GPCST_CODE_KENSIN_2 then begin
              ParamByName('PKENSASTATUS_FLG').AsString      := GPCST_CODE_KENSIN_2; //受付済
              ParamByName('PKENSASUBSTATUS_FLG').AsString   := GPCST_CODE_KENSIN_SUB_10;
              ParamByName('PUKETUKE_TANTOU_ID').AsString    := w_EX_UKETUKE_TANTOU_ID;
            end;

            ParamByName('PUKETUKE_UPDATE_DATE').AsDateTime  := w_DateTime;
            ParamByName('PUKETUKE_JISSI_TERMINAL').AsString := w_Tan_Name;
            ParamByName('PRIS_ID').AsString                 := arg_Ris_ID[w_i];
{2002.12.17
            ParamByName('PKENSA_DATE').AsString             := w_New_KENSA_DATE;//func_Date10To8(FormatDateTime(CST_FORMATDATE_1 ,w_DateTime));
            ParamByName('PKENSA_DATE_AGE').AsString         := w_KensaDate_Age;
2002.12.17}
            ParamByName('PKANJA_NYUGAIKBN').AsString        := w_KJ_KANJA_NYUGAIKBN;
            ParamByName('PKANJA_SECTION_ID').AsString       := w_KJ_SECTION_ID;
            ParamByName('PKANJA_BYOUTOU_ID').AsString       := w_KJ_BYOUTOU_ID;
            ParamByName('PKANJA_BYOUSITU_ID').AsString      := w_KJ_BYOUSITU_ID;
{2002.12.04
            if w_EX_Renraku_Memo <> '' then begin
              ParamByName('PRENRAKU_MEMO').AsString         := w_EX_Renraku_Memo + arg_RenrakuMemo;
            end else begin
              ParamByName('PRENRAKU_MEMO').AsString         := copy(arg_RenrakuMemo,2,length(arg_RenrakuMemo) -1);
            end;
2002.12.04}
            if copy(arg_RenrakuMemo,2,length(arg_RenrakuMemo) -1) <> '' then begin
            {2002.12.26 start}
              if Length(w_EX_Renraku_Memo + arg_RenrakuMemo) > w_RenrakuMemo_FieldSize then begin
                ParamByName('PRENRAKU_MEMO').AsString       := w_EX_Renraku_Memo;
              end else begin
                if w_EX_Renraku_Memo <> '' then begin
                  ParamByName('PRENRAKU_MEMO').AsString     := w_EX_Renraku_Memo + arg_RenrakuMemo;
                end else begin
                  ParamByName('PRENRAKU_MEMO').AsString     := copy(arg_RenrakuMemo,2,length(arg_RenrakuMemo) -1);
                end;
              end;
            {2002.12.26 end}
{2002.12.26
              ParamByName('PRENRAKU_MEMO').AsString         := copy(arg_RenrakuMemo,2,length(arg_RenrakuMemo) -1);
2002.12.26}
            end else begin
              ParamByName('PRENRAKU_MEMO').AsString         := w_EX_Renraku_Memo;
            end;
            //2003.12.16
            //同意書区分
            ParamByName('PDOUISHO_FLG').AsString             := arg_DouishoKbn;
            //2004.04.20
            ParamByName('PUKETUKE_NO').AsString              := wt_New_Uketuke_NO[w_i];
            ExecSQL;
          end;
          {--- 2004.04.20 Start ---
          //患者マスタ
          with w_Query_Update do begin
            Close;
            SQL.Clear;
            SQL.Add('UPDATE KANJAMASTER SET ');
            SQL.Add(' UKETUKE_NO   = :PUKETUKE_NO ');
//RIS更新日時            SQL.Add(' RIS_UPDATEDATE   = :PRIS_UPDATEDATE ');
            SQL.Add('WHERE KANJAID = :PKANJAID ');
            if not Prepared then Prepare;
            ParamByName('PKANJAID').AsString := arg_Kanja_ID;

            ParamByName('PUKETUKE_NO').AsString  := w_New_Uketuke_NO;
//RIS更新日時            ParamByName('PRIS_UPDATEDATE').AsString  := w_DateTime;

            ExecSQL;
          end;
          --- 2004.04.20 End ---}
        end;
      end;  //Roop End
      try
        //エラーチェック
        //エラーが存在した時は、排他管理Rollback
        //エラーが存在しなかった時は、排他管理Commit
        if Result <> 0 then begin
          arg_DB.Rollback;

          if wt_Flg_Kensa <> nil then wt_Flg_Kensa.Free;
          if wt_RomaSimei <> nil then wt_RomaSimei.Free;
          if wt_Kensa_Date <> nil then wt_Kensa_Date.Free;
          if wt_KensaType_Name <> nil then wt_KensaType_Name.Free;
          if wt_OrderNo <> nil then wt_OrderNo.Free;
          if wt_SystemKbn <> nil then wt_SystemKbn.Free; //2004.02.05
          if wt_New_Uketuke_NO <> nil then wt_New_Uketuke_NO.Free; //2004.04.20

          Result := 2;
          Exit;
        end else begin
          arg_DB.Commit;
        end;
      finally
        w_Query_Data.Close;
        w_Query_Update.Close;

      end;
    except
      on E: Exception do begin
        arg_DB.Rollback; // コミットで失敗した場合，変更を取り消す
        arg_Error_Code := CST_ERRCODE_10; //登録失敗
        arg_Error_Message := #13#10
                           + #13#10+'commit'
                           + #13#10+E.Message;
        arg_Error_SQL := w_Query_Update.SQL.Text;
        w_Query_Data.Close;
        w_Query_Update.Close;

        w_Query_Data.Free;
        w_Query_Update.Free;

        wt_Flg_Kensa.Free;
        wt_RomaSimei.Free;
        wt_Kensa_Date.Free;
        wt_KensaType_Name.Free;
        wt_OrderNo.Free;
        wt_SystemKbn.Free;  //2004.02.05
        wt_New_Uketuke_NO.Free;  //2004.04.20

        Result := 2;
        Exit;
      end;
    end;  //Try End

    //転送テーブル等処理
    try
      for w_i := 0 to arg_Ris_ID.Count -1 do begin
        //検査進捗"未受"の時のみ、転送テーブルへ書き込む
        if wt_Flg_Kensa[w_i] = GPCST_CODE_KENSIN_0 then begin
          {//2004.04.09
          //RISオーダで送信キュー作成設定が"なし"の場合はキューを作成しない。 2004.02.05
          if (wt_SystemKbn[w_i] = GPCST_CODE_SYSK_RIS) and
             (g_RIS_Order_Sousin_Flg = GPCST_RISORDERSOUSIN_FLG_0) then
          else begin
          }
          //2004.04.09
          //RISオーダで送信キュー作成設定が"なし"or"HISなしRepあり"の場合はキューを作成しない。
          if func_Check_CueAndDummy(wt_SystemKbn[w_i],arg_Kanja_ID,1) then begin

            //電文連番:転送オーダテーブル(日付管理あり)
            w_New_Denbun_NO := '';
            w_New_Denbun_NO := func_Uketuke_Make_DenbunNO(arg_DB,
                                                          w_Query_Data,
                                                          FormatDateTime(CST_FORMATDATE_3, w_DateTime)
                                                         );

            if w_New_Denbun_NO = '' then begin
              if arg_Error_Code <> '' then begin
                arg_Error_Code := CST_ERRCODE_07; //電文連番取得エラー
                arg_Error_Message := #13#10
                                    +#13#10+'患者ＩＤ　：'+arg_Kanja_ID
                                    +#13#10+'ＲＩＳＩＤ：'+arg_Ris_ID[w_i]
                                    ;
              end;
              Result := 3;
            end else begin
              arg_DB.StartTransaction;
              try
                with w_Query_Update do begin
                  Close;
                  SQL.Clear;
                  SQL.Add('INSERT INTO TENSOUORDERTABLE( ');
                  SQL.Add('NO,');
                  SQL.Add('UPDATEDATE,');
                  SQL.Add('RIS_ID,');
                  SQL.Add('INFKBN,');
                  SQL.Add('SYORIKBN,');
                  SQL.Add('JOUTAIKBN,');
                  SQL.Add('SOUSIN_DATE,');
                  SQL.Add('SOUSIN_FLG,');
                  SQL.Add('SOUSIN_STATUS_NAME,');
                  SQL.Add('KENSATYPE_NAME,');
                  SQL.Add('KANJAID,');
                  SQL.Add('ROMASIMEI,');
                  SQL.Add('KENSA_DATE ');
                  SQL.Add(') VALUES ( ');
                  SQL.Add(':PNO,');
                  SQL.Add(':PUPDATEDATE,');
                  SQL.Add(':PRIS_ID,');
                  SQL.Add(':PINFKBN,');
                  SQL.Add(':PSYORIKBN,');
                  SQL.Add(':PJOUTAIKBN,');
                  SQL.Add(':PSOUSIN_DATE,');
                  SQL.Add(':PSOUSIN_FLG,');
                  SQL.Add(':PSOUSIN_STATUS_NAME,');
                  SQL.Add(':PKENSATYPE_NAME,');
                  SQL.Add(':PKANJAID,');
                  SQL.Add(':PROMASIMEI,');
                  SQL.Add(':PKENSA_DATE ');
                  SQL.Add(') ');
                  if not Prepared then Prepare;
                  ParamByName('PNO').AsString           := w_New_Denbun_NO;
                  ParamByName('PUPDATEDATE').AsDateTime := w_DateTime;
                  ParamByName('PRIS_ID').AsString       := arg_Ris_ID[w_i];
                  ParamByName('PINFKBN').AsString       := GPCST_INFKBN_FU;     //受付電文
                  ParamByName('PSYORIKBN').AsString     := GPCST_SYORIKBN_01;   //新規
                  ParamByName('PJOUTAIKBN').AsString    := '00'; //状態なし
                  ParamByName('PSOUSIN_DATE').AsString  := '';
                  ParamByName('PSOUSIN_FLG').AsString   := '0';  //未送信
                  ParamByName('PSOUSIN_STATUS_NAME').AsString := '';
                  ParamByName('PKENSATYPE_NAME').AsString     := wt_KensaType_Name[w_i];
                  ParamByName('PKANJAID').AsString      := arg_Kanja_ID;
                  ParamByName('PROMASIMEI').AsString    := wt_RomaSimei[w_i];
                  ParamByName('PKENSA_DATE').AsString   := wt_Kensa_Date[w_i];//func_Date10To8(FormatDateTime(CST_FORMATDATE_1 ,w_DateTime));
                  ExecSQL;
                end;

                try
                  arg_DB.Commit; // 成功した場合，変更をコミットする
                except
                  on E: Exception do begin
                    arg_DB.Rollback; // コミットで失敗した場合，変更を取り消す
                    arg_Error_Code := CST_ERRCODE_10; //登録失敗
                    arg_Error_Message := #13#10
                                       + #13#10+'commit'
                                       + #13#10+E.Message;
                    arg_Error_SQL := w_Query_Update.SQL.Text;
                    Result := 3;
                  end;
                end;
              except
                on E: Exception do begin
                  arg_DB.Rollback; // コミットで失敗した場合，変更を取り消す
                  arg_Error_Code := CST_ERRCODE_10; //登録失敗
                  arg_Error_Message := #13#10
                                     + #13#10+E.Message;
                  arg_Error_SQL := w_Query_Update.SQL.Text;
                  Result := 3;
                end;
              end;
            end;
          end; //2004.02.05
{2003.12.18
          //電文連番:PACS-RIS転送オーダテーブル(日付管理あり)
          w_New_PacsDenbun_NO := '';
          w_New_PacsDenbun_NO := func_Uketuke_Make_PacsDenbunNO(arg_DB,
                                                          w_Query_Data,
                                                          FormatDateTime(CST_FORMATDATE_3, w_DateTime)
                                                         );
          if w_New_PacsDenbun_NO = '' then begin
            if arg_Error_Code <> '' then begin
              arg_Error_Code := CST_ERRCODE_13; //電文連番取得エラー
              arg_Error_Message := #13#10
                                  +#13#10+'PACS-RIS転送テーブルの電文連番取得に失敗しました。'
                                  +#13#10+'患者ＩＤ　：'+arg_Kanja_ID
                                  +#13#10+'ＲＩＳＩＤ：'+arg_Ris_ID[w_i]
                                  ;
            end;
            Result := 3;
          end else begin
            arg_DB.StartTransaction;
            try
              //PACS-RIS転送オーダテーブルにも書き込む
              with w_Query_Update do begin
                Close;
                SQL.Clear;
                SQL.Add('INSERT INTO TENSOUPACSTABLE( ');
                SQL.Add('NO,');
                SQL.Add('UPDATEDATE,');
                SQL.Add('RIS_ID,');
                SQL.Add('INFKBN,');
                SQL.Add('SYORIKBN,');
                SQL.Add('JOUTAIKBN,');
                SQL.Add('SOUSIN_DATE,');
                SQL.Add('SOUSIN_FLG,');
                SQL.Add('SOUSIN_STATUS_NAME,');
                SQL.Add('KENSATYPE_NAME,');
                SQL.Add('KANJAID,');
                SQL.Add('ROMASIMEI,');
                SQL.Add('KENSA_DATE ');
                SQL.Add(') VALUES ( ');
                SQL.Add(':PNO,');
                SQL.Add(':PUPDATEDATE,');
                SQL.Add(':PRIS_ID,');
                SQL.Add(':PINFKBN,');
                SQL.Add(':PSYORIKBN,');
                SQL.Add(':PJOUTAIKBN,');
                SQL.Add(':PSOUSIN_DATE,');
                SQL.Add(':PSOUSIN_FLG,');
                SQL.Add(':PSOUSIN_STATUS_NAME,');
                SQL.Add(':PKENSATYPE_NAME,');
                SQL.Add(':PKANJAID,');
                SQL.Add(':PROMASIMEI,');
                SQL.Add(':PKENSA_DATE ');
                SQL.Add(') ');
                if not Prepared then Prepare;
                ParamByName('PNO').AsString           := w_New_PacsDenbun_NO;
                ParamByName('PUPDATEDATE').AsDateTime := w_DateTime;
                ParamByName('PRIS_ID').AsString       := wt_OrderNo[w_i];
                ParamByName('PINFKBN').AsString       := GPCST_INFKBN_FU;     //受付電文
                ParamByName('PSYORIKBN').AsString     := GPCST_SYORIKBN_02;   //更新
                ParamByName('PJOUTAIKBN').AsString    := '00'; //状態なし
                ParamByName('PSOUSIN_DATE').AsString  := '';
                ParamByName('PSOUSIN_FLG').AsString   := '0';  //未送信
                ParamByName('PSOUSIN_STATUS_NAME').AsString := '';
                ParamByName('PKENSATYPE_NAME').AsString     := wt_KensaType_Name[w_i];
                ParamByName('PKANJAID').AsString      := arg_Kanja_ID;
                ParamByName('PROMASIMEI').AsString    := wt_RomaSimei[w_i];
                ParamByName('PKENSA_DATE').AsString   := wt_Kensa_Date[w_i];//func_Date10To8(FormatDateTime(CST_FORMATDATE_1 ,w_DateTime));
                ExecSQL;
              end;
              try
                arg_DB.Commit; // 成功した場合，変更をコミットする
              except
                on E: Exception do begin
                  arg_DB.Rollback; // コミットで失敗した場合，変更を取り消す
                  arg_Error_Code := CST_ERRCODE_10; //登録失敗
                  arg_Error_Message := #13#10
                                     + #13#10+'commit'
                                     + #13#10+E.Message;
                  arg_Error_SQL := w_Query_Update.SQL.Text;
                  Result := 3;
                  break;
                end;
              end;
            except
              on E: Exception do begin
                  arg_DB.Rollback; // コミットで失敗した場合，変更を取り消す
                  arg_Error_Code := CST_ERRCODE_10; //登録失敗
                  arg_Error_Message := #13#10
                                     + #13#10+E.Message;
                  arg_Error_SQL := w_Query_Update.SQL.Text;

                  Result := 3;
                  break;
              end;
            end;
          end;
2003.12.18}
          //2004.04.09
          //送信キュー作成設定が"あり"or"HISなしRepあり"の場合はキューを作成する。
          if func_Check_CueAndDummy(wt_SystemKbn[w_i],arg_Kanja_ID,0) then begin

            //電文連番:REPORT-RIS転送オーダテーブル(日付管理あり)
            w_New_ReportDenbun_NO := '';
            w_New_ReportDenbun_NO := func_Uketuke_Make_ReportDenbunNO(arg_DB,
                                                            w_Query_Data,
                                                            FormatDateTime(CST_FORMATDATE_3, w_DateTime)
                                                           );
            if w_New_ReportDenbun_NO = '' then begin
              if arg_Error_Code <> '' then begin
                arg_Error_Code := CST_ERRCODE_14; //電文連番取得エラー
                arg_Error_Message := #13#10
                                    +#13#10+'REPORT-RIS転送テーブルの電文連番取得に失敗しました。'
                                    +#13#10+'患者ＩＤ　：'+arg_Kanja_ID
                                    +#13#10+'ＲＩＳＩＤ：'+arg_Ris_ID[w_i]
                                    ;
              end;
              Result := 3;
            end else begin

              arg_DB.StartTransaction;
              try
                //HISオーダの場合、REPORT-RIS転送オーダテーブルにも書き込む
                with w_Query_Update do begin
                  Close;
                  SQL.Clear;
                  SQL.Add('INSERT INTO TENSOUREPORTTABLE( ');
                  SQL.Add('NO,');
                  SQL.Add('UPDATEDATE,');
                  SQL.Add('RIS_ID,');
                  SQL.Add('INFKBN,');
                  SQL.Add('SYORIKBN,');
                  SQL.Add('JOUTAIKBN,');
                  SQL.Add('SOUSIN_DATE,');
                  SQL.Add('SOUSIN_FLG,');
                  SQL.Add('SOUSIN_STATUS_NAME,');
                  SQL.Add('KENSATYPE_NAME,');
                  SQL.Add('KANJAID,');
                  SQL.Add('ROMASIMEI,');
                  SQL.Add('KENSA_DATE ');
                  SQL.Add(') VALUES ( ');
                  SQL.Add(':PNO,');
                  SQL.Add(':PUPDATEDATE,');
                  SQL.Add(':PRIS_ID,');
                  SQL.Add(':PINFKBN,');
                  SQL.Add(':PSYORIKBN,');
                  SQL.Add(':PJOUTAIKBN,');
                  SQL.Add(':PSOUSIN_DATE,');
                  SQL.Add(':PSOUSIN_FLG,');
                  SQL.Add(':PSOUSIN_STATUS_NAME,');
                  SQL.Add(':PKENSATYPE_NAME,');
                  SQL.Add(':PKANJAID,');
                  SQL.Add(':PROMASIMEI,');
                  SQL.Add(':PKENSA_DATE ');
                  SQL.Add(') ');
                  if not Prepared then Prepare;
                  ParamByName('PNO').AsString           := w_New_ReportDenbun_NO;
                  ParamByName('PUPDATEDATE').AsDateTime := w_DateTime;
                  ParamByName('PRIS_ID').AsString       := wt_OrderNo[w_i];
                  ParamByName('PINFKBN').AsString       := GPCST_INFKBN_FU;     //受付電文
                  ParamByName('PSYORIKBN').AsString     := GPCST_SYORIKBN_02;   //更新
                  ParamByName('PJOUTAIKBN').AsString    := '00'; //状態なし
                  ParamByName('PSOUSIN_DATE').AsString  := '';
                  ParamByName('PSOUSIN_FLG').AsString   := '0';  //未送信
                  ParamByName('PSOUSIN_STATUS_NAME').AsString := '';
                  ParamByName('PKENSATYPE_NAME').AsString     := wt_KensaType_Name[w_i];
                  ParamByName('PKANJAID').AsString      := arg_Kanja_ID;
                  ParamByName('PROMASIMEI').AsString    := wt_RomaSimei[w_i];
                  ParamByName('PKENSA_DATE').AsString   := wt_Kensa_Date[w_i];//func_Date10To8(FormatDateTime(CST_FORMATDATE_1 ,w_DateTime));
                  ExecSQL;
                end;

                try
                  arg_DB.Commit; // 成功した場合，変更をコミットする
                except
                  on E: Exception do begin
                    arg_DB.Rollback; // コミットで失敗した場合，変更を取り消す
                    arg_Error_Code := CST_ERRCODE_10; //登録失敗
                    arg_Error_Message := #13#10
                                       + #13#10+'commit'
                                       + #13#10+E.Message;
                    arg_Error_SQL := w_Query_Update.SQL.Text;
                    Result := 3;
                  end;
                end;
              except
                on E: Exception do begin
                    arg_DB.Rollback; // コミットで失敗した場合，変更を取り消す
                    arg_Error_Code := CST_ERRCODE_10; //登録失敗
                    arg_Error_Message := #13#10
                                       + #13#10+E.Message;
                    arg_Error_SQL := w_Query_Update.SQL.Text;
                    Result := 3;
                end;
              end;
            end;
          end; //2004.04.09
        end;
      end;

      with w_Query_Data do begin
        Close;
        SQL.Clear;
        SQL.Add('SELECT *');
        SQL.Add('FROM TENSOUKANJATABLE');
        SQL.Add('WHERE KANJAID = '''+ arg_Kanja_ID +'''');
        SQL.Add('AND SOUSIN_FLG = '''+ GPCST_SOUSIN_FLG_0 +'''');
        if not Prepared then Prepare;
        Open;
        last;
        first;
        if not(Eof) then begin
          exit;
        end;
        Close;
      end;
      //電文連番:転送患者情報テーブル(日付管理あり)
      w_New_KanjaDenbun_NO := '';
      w_New_KanjaDenbun_NO := func_Uketuke_Make_KanjaDenbunNO(arg_DB,
                                                      w_Query_Data,
                                                      FormatDateTime(CST_FORMATDATE_3, w_DateTime)
                                                     );
      if w_New_KanjaDenbun_NO = '' then begin
        if arg_Error_Code <> '' then begin
          arg_Error_Code := CST_ERRCODE_12; //電文連番取得エラー
          arg_Error_Message := #13#10
                              +#13#10+'転送患者情報テーブルの電文連番取得に失敗しました。'
                              +#13#10+'患者ＩＤ　：'+arg_Kanja_ID
                              ;
        end;
         Result := 3;
      end else begin
        arg_DB.StartTransaction;
        try
          //転送患者情報テーブルにも書き込む
          with w_Query_Update do begin
            Close;
            SQL.Clear;
            SQL.Add('INSERT INTO TENSOUKANJATABLE( ');
            SQL.Add('NO,');
            SQL.Add('UPDATEDATE,');
            SQL.Add('SOUSIN_DATE,');
            SQL.Add('SOUSIN_FLG,');
            SQL.Add('SOUSIN_STATUS_NAME,');
            SQL.Add('ANS_SBT,');
            SQL.Add('KANJAID,');
            SQL.Add('ROMASIMEI,');
            SQL.Add('KENSA_DATE ');
            SQL.Add(') VALUES ( ');
            SQL.Add(':PNO,');
            SQL.Add(':PUPDATEDATE,');
            SQL.Add(':PSOUSIN_DATE,');
            SQL.Add(':PSOUSIN_FLG,');
            SQL.Add(':PSOUSIN_STATUS_NAME,');
            SQL.Add(':PANS_SBT,');
            SQL.Add(':PKANJAID,');
            SQL.Add(':PROMASIMEI,');
            SQL.Add(':PKENSA_DATE ');
            SQL.Add(') ');
            if not Prepared then Prepare;
            ParamByName('PNO').AsString           := w_New_KanjaDenbun_NO;
            ParamByName('PUPDATEDATE').AsDateTime := w_DateTime;
            ParamByName('PSOUSIN_DATE').AsString  := '';
            ParamByName('PSOUSIN_FLG').AsString   := '0';  //未送信
            ParamByName('PSOUSIN_STATUS_NAME').AsString := '';
            ParamByName('PANS_SBT').AsString      := '';
            ParamByName('PKANJAID').AsString      := arg_Kanja_ID;
            ParamByName('PROMASIMEI').AsString    := w_KJ_ROMASIMEI;
            ParamByName('PKENSA_DATE').AsString   := wt_Kensa_Date[0];//func_Date10To8(FormatDateTime(CST_FORMATDATE_1 ,w_DateTime));
            ExecSQL;
          end;
          try
            arg_DB.Commit; // 成功した場合，変更をコミットする
          except
            on E: Exception do begin
              arg_DB.Rollback; // コミットで失敗した場合，変更を取り消す
              arg_Error_Code := CST_ERRCODE_10; //登録失敗
              arg_Error_Message := #13#10
                                 + #13#10+'commit'
                                 + #13#10+E.Message;
              arg_Error_SQL := w_Query_Update.SQL.Text;
              Result := 3;
            end;
          end;
        except
          on E: Exception do begin
            arg_DB.Rollback; // コミットで失敗した場合，変更を取り消す
            arg_Error_Code := CST_ERRCODE_10; //登録失敗
            arg_Error_Message := #13#10
                             + #13#10+E.Message;
            arg_Error_SQL := w_Query_Update.SQL.Text;

            Result := 3;
          end;
        end;
      end;
    finally
      w_Query_Data.Free;
      w_Query_Update.Free;

      wt_Flg_Kensa.Free;
      wt_RomaSimei.Free;
      wt_Kensa_Date.Free;
      wt_KensaType_Name.Free;
      wt_OrderNo.Free;
      wt_SystemKbn.Free;  //2004.02.05
      wt_New_Uketuke_NO.Free;  //2004.04.20

    end;
  finally
    for w_i := 0 to arg_Ris_ID.Count -1 do begin
      //更新権利返還
      if not func_ReleasKAnri(arg_DB,            //接続されたDB
                              w_Tan_Name,        //PC名称
                              arg_PROG_ID,       //プログラムID
                              arg_Ris_ID[w_i],        //RIS識別ID
                              G_KANRI_TBL_WMODE  //返還権利種(G_KANRI_TBL_WMODE 更新権利)
                             ) then begin
        arg_Error_Haita := True;
      end;
    end;
  end;
end;
//******************************************************************************
// ※受付処理(ポータブル)12.21追加
//******************************************************************************
function func_Uketuke_Portable(
         arg_DB:TDatabase;             //接続されたDB
         arg_Mode:string;              //0:受付処理、1:RISオーダ登録の受付処理
         arg_PROG_ID:string;           //プログラムID
         arg_Ris_ID:TStrings;            //RIS識別ID
         arg_Kanja_ID:TStrings;          //患者ID
         arg_KensaDate:string;         //予約日(yyyy/mm/dd)
         arg_Uketukesya_ID:string;     //受付者ID
         var arg_Error_Code:string;    //エラーコード
         var arg_Error_Message:string; //エラーメッセージ
         var arg_Error_SQL:string;     //エラーSQL文
         var arg_Error_Haita:Boolean   //排他削除エラー True:排他ﾃｰﾌﾞﾙ削除失敗、False:排他ﾃｰﾌﾞﾙ削除成功
         ):Integer;                    //結果0:成功、1:排他/進捗ｴﾗｰ、2:進捗更新ｴﾗｰ、3:送信ﾃｰﾌﾞﾙ書込みｴﾗｰ
var
  w_Query_Data: TQuery;
  w_Query_Update: TQuery;

  w_DateTime: TDateTime;
  w_Tan_Name: string;
  w_Date: string;
  w_Time: string;
//実績メインデータ
  //w_EX_KENSASTATUS_FLG: string;
  //w_EX_KENSASUBSTATUS_FLG: string;
  w_EX_KENSATYPE_ID: string;
  w_EX_KENSATYPE_NAME: string;
  w_EX_UKETUKE_TANTOU_ID: string;
  w_EX_Renraku_Memo: string;
  //w_EX_Kanja_ID: string;
//オーダメインデータ
  //w_OD_SYSTEMKBN: string;
  w_OD_ORDERNO: string;   //2003.01.08
  w_New_AccessionNo:string;     //新AccessionNo.（オーダNo.+HIS発行日付）
//患者マスタデータ
  w_KJ_ROMASIMEI: string;
  w_KJ_BIRTHDAY: string;
  //w_KJ_SEX: string;
  w_KJ_KANJA_NYUGAIKBN: string;
  w_KJ_SECTION_ID: string;
  w_KJ_BYOUTOU_ID: string;
  w_KJ_BYOUSITU_ID: string;
//
  w_KensaDate_Age: string;      //検査時年齢
  w_New_Uketuke_NO: string;     //新規の受付NO
  w_New_Denbun_NO: string;      //新規の電文連番
  w_New_KanjaDenbun_NO: string; //新規の電文連番(転送患者情報テーブル)
  w_New_PacsDenbun_NO: string;  //新規の電文連番(Pacs-Ris転送オーダテーブル)
  w_New_ReportDenbun_NO: string;//新規の電文連番(Report-Risオーダテーブル)

  w_New_KENSA_DATE: string;     //検査日
  //w_Now_KENSA_DATE: string;

  w_Flg_Kensa:string;           //検査進捗のﾁｪｯｸ

  w_i:integer;
  w_KanjaExsist:String;
  w_OD_SYSTEMKBN :string;

//  wt_Flg_Kensa:TStrings;
//  wt_RomaSimei:TStrings;
begin
  arg_Error_Code := '';
  arg_Error_Message := '';
  arg_Error_SQL := '';
  Result := 0;
  arg_Error_Haita := False;
  w_Query_Data := TQuery.Create(nil);
  w_Query_Data.DatabaseName := arg_DB.DatabaseName;
  w_Query_Update := TQuery.Create(nil);
  w_Query_Update.DatabaseName := arg_DB.DatabaseName;

//  wt_Flg_Kensa := TStringList.Create;
//  wt_RomaSimei := TStringList.Create;

  //現在日時取得
  w_DateTime := func_GetDBSysDate(w_Query_Data);
  //現在日付取得
  w_Date := FormatDateTime(CST_FORMATDATE_1, w_DateTime);
  //現在時刻取得
  w_Time := FormatDateTime(CST_FORMATDATE_4, w_DateTime);
  //コンピュータ名取得
  w_Tan_Name := func_GetThisMachineName;
  //検査日
//  w_New_KENSA_DATE := func_Date10To8(FormatDateTime(CST_FORMATDATE_1 ,w_DateTime));

  //検査進捗・排他管理処理
  try


    //実績ﾒｲﾝ・患者ﾏｽﾀ更新処理
    Try

      for w_i := 0 to arg_Ris_ID.Count -1 do begin
        //受付番号取得
        //受付№(日付管理あり)
        w_New_Uketuke_NO := '';
        w_New_Uketuke_NO := func_Uketuke_Make_UketukeNO(arg_DB,
                                                        w_Query_Data,
                                                        FormatDateTime(CST_FORMATDATE_3, w_DateTime),
                                                        'UNO'
                                                       );
        if w_New_Uketuke_NO = '' then begin
          arg_Error_Code := CST_ERRCODE_05; //受付NO取得エラー
          Result := 1;
          Exit;
        end;
        //オーダメイン、実績メイン、患者マスタより最新情報の取得
        if arg_Mode = CST_MODE_RISORDER then begin
        end else begin
          with w_Query_Data do begin
            Close;
            SQL.Clear;
            SQL.Add ('SELECT exma.RIS_ID ');
            SQL.Add ('      ,exma.KANJAID ');
            SQL.Add ('      ,exma.KENSASTATUS_FLG ');
            SQL.Add ('      ,exma.KENSASUBSTATUS_FLG ');
            SQL.Add ('      ,exma.KENSATYPE_ID ');
            SQL.Add ('      ,ktyp.KENSATYPE_NAME ');
            SQL.Add ('      ,exma.KENSA_DATE ');
            SQL.Add ('      ,exma.UKETUKE_TANTOU_ID ');
            SQL.Add ('      ,exma.RENRAKU_MEMO ');
            SQL.Add ('      ,odma.SYSTEMKBN ');
            SQL.Add ('      ,odma.ORDERNO ');
{2003.02.05 start}
            SQL.Add ('      ,to_char(odma.HIS_HAKKO_DATE,''YYYYMMDD'') HIS_HAKKO_DATE ');
{2003.02.05 end}
            SQL.Add ('      ,kj.ROMASIMEI ');
            SQL.Add ('      ,kj.BIRTHDAY ');
            SQL.Add ('      ,kj.SEX ');
            SQL.Add ('      ,kj.KANJA_NYUGAIKBN ');
            SQL.Add ('      ,kj.SECTION_ID ');
            SQL.Add ('      ,kj.BYOUTOU_ID ');
            SQL.Add ('      ,kj.BYOUSITU_ID ');
            SQL.Add ('      ,kj.KANASIMEI '); //2004.04.12
            SQL.Add ('FROM   EXMAINTABLE exma,ORDERMAINTABLE odma,KANJAMASTER kj,KENSATYPEMASTER ktyp ');
            SQL.Add ('WHERE  exma.RIS_ID  = :PRIS_ID ');
            SQL.Add ('  AND  exma.KANJAID = :PKANJAID ');
            SQL.Add ('  AND  exma.KENSATYPE_ID = ktyp.KENSATYPE_ID(+) ');
            SQL.Add ('  AND  odma.RIS_ID  = exma.RIS_ID ');
            SQL.Add ('  AND  kj.KANJAID   = exma.KANJAID ');
            if not Prepared then Prepare;
            ParamByName('PRIS_ID').AsString  := arg_Ris_ID[w_i];
            ParamByName('PKANJAID').AsString := arg_Kanja_ID[w_i];
            Open;
            Last;
            First;
            if not(w_Query_Data.Eof) and
              (w_Query_Data.RecordCount > 0) then begin
              //検査進捗ﾒｲﾝﾌﾗｸﾞと検査進捗ｻﾌﾞﾌﾗｸﾞのﾁｪｯｸ
              //検査進捗ﾒｲﾝﾌﾗｸﾞが未受付で、検査進捗ｻﾌﾞﾌﾗｸﾞがDefの場合'0'をセット
              w_Flg_Kensa := '';
              if FieldByName('KENSASTATUS_FLG').AsString = GPCST_CODE_KENSIN_0 then begin
                w_Flg_Kensa := '0';
              end;
              //検査進捗ﾒｲﾝﾌﾗｸﾞが検中で、検査進捗ｻﾌﾞﾌﾗｸﾞが8：保留または9:再呼の場合'2'をセット
              if (FieldByName('KENSASTATUS_FLG').AsString = GPCST_CODE_KENSIN_2) and
                ((FieldByName('KENSASUBSTATUS_FLG').AsString = GPCST_CODE_KENSIN_SUB_8 ) or
                (FieldByName('KENSASUBSTATUS_FLG').AsString = GPCST_CODE_KENSIN_SUB_9 )) then begin
                w_Flg_Kensa := '2';
              end;

              w_EX_KENSATYPE_ID           := FieldByName('KENSATYPE_ID').AsString;
              w_EX_UKETUKE_TANTOU_ID      := FieldByName('UKETUKE_TANTOU_ID').AsString;
              w_EX_Renraku_Memo           := FieldByName('RENRAKU_MEMO').AsString;
              //2004.04.12
              //w_KJ_ROMASIMEI              := FieldByName('ROMASIMEI').AsString;
              w_KJ_ROMASIMEI              := FieldByName('KANASIMEI').AsString;

              w_EX_KENSATYPE_NAME         := Copy(FieldByName('KENSATYPE_NAME').AsString,1,20);
              w_New_KENSA_DATE            := FieldByName('KENSA_DATE').AsString;

{2003.02.05
              w_OD_ORDERNO                := FieldByName('ORDERNO').AsString;
2003.02.05}
{2003.12.18 start}
              //新AccessionNo.の作成
              //w_New_AccessionNo := Right('00000000'+FieldByName('ORDERNO').AsString,8) + FieldByName('HIS_HAKKO_DATE').AsString;
              w_New_AccessionNo := FieldByName('ORDERNO').AsString;
              w_OD_ORDERNO := w_New_AccessionNo;
{2003.12.18 end}

//              wt_RomaSimei.Add(w_KJ_ROMASIMEI);
              //2004.02.05
              w_OD_SYSTEMKBN := FieldByName('SYSTEMKBN').AsString;

              if FieldByName('BIRTHDAY').AsString <> '' then
                w_KJ_BIRTHDAY      := func_Date8To10(FieldByName('BIRTHDAY').AsString)
              else
                w_KJ_BIRTHDAY       := '';
              w_KJ_KANJA_NYUGAIKBN  := FieldByName('KANJA_NYUGAIKBN').AsString;
              w_KJ_SECTION_ID       := FieldByName('SECTION_ID').AsString;
              w_KJ_BYOUTOU_ID       := FieldByName('BYOUTOU_ID').AsString;
              w_KJ_BYOUSITU_ID      := FieldByName('BYOUSITU_ID').AsString;
            end else begin
              arg_Error_Code := CST_ERRCODE_01; //読み込みエラー
              arg_Error_Message := #13#10
                                  +#13#10+'患者ＩＤ　：'+arg_Kanja_ID[w_i]
                                  +#13#10+'ＲＩＳＩＤ：'+arg_Ris_ID[w_i]
                                  ;
              Result := 2;
              break;
            end;
          end;
        end;
        //検査日年齢
        w_KensaDate_Age := '999';
        if w_KJ_BIRTHDAY <> '' then begin
          w_KensaDate_Age := IntToStr(func_GetAgeofCase(func_StrToDate(w_KJ_BIRTHDAY), func_StrToDate(arg_KensaDate), 0));
        end;
  //更新処理開始
        arg_DB.StartTransaction;
        try
          //ロック
          with w_Query_Data do begin
            Close;
            SQL.Clear;
            SQL.Add ('SELECT orma.RIS_ID ');
            SQL.Add ('FROM   ORDERMAINTABLE orma ');
            SQL.Add ('WHERE  orma.RIS_ID = :PRIS_ID ');
            SQL.Add (' for update ');
            if not Prepared then Prepare;
            ParamByName('PRIS_ID').AsString := arg_Ris_ID[w_i];
            ExecSQL;
          end;
          //実績メインテーブル
          with w_Query_Update do begin
            Close;
            SQL.Clear;
            SQL.Add('UPDATE EXMAINTABLE SET ');
            SQL.Add(' KENSASTATUS_FLG        = :PKENSASTATUS_FLG ');
            SQL.Add(',KENSASUBSTATUS_FLG     = :PKENSASUBSTATUS_FLG ');
            SQL.Add(',UKETUKE_TANTOU_ID      = :PUKETUKE_TANTOU_ID ');
            SQL.Add(',UKETUKE_UPDATE_DATE    = :PUKETUKE_UPDATE_DATE ');
            SQL.Add(',UKETUKE_JISSI_TERMINAL = :PUKETUKE_JISSI_TERMINAL ');

            SQL.Add(',KANJA_NYUGAIKBN        = :PKANJA_NYUGAIKBN ');
            SQL.Add(',KANJA_SECTION_ID       = :PKANJA_SECTION_ID ');
            SQL.Add(',KANJA_BYOUTOU_ID       = :PKANJA_BYOUTOU_ID ');
            SQL.Add(',KANJA_BYOUSITU_ID      = :PKANJA_BYOUSITU_ID ');
            SQL.Add(',UKETUKE_NO             = :PUKETUKE_NO ');
            SQL.Add('WHERE RIS_ID = :PRIS_ID ');
            if not Prepared then Prepare;

            //検査進捗ﾌﾗｸﾞが、0:未受付の時
            if w_Flg_Kensa = GPCST_CODE_KENSIN_0 then begin
              ParamByName('PKENSASTATUS_FLG').AsString      := GPCST_CODE_KENSIN_1; //受付済
              ParamByName('PKENSASUBSTATUS_FLG').AsString   := '';
              ParamByName('PUKETUKE_TANTOU_ID').AsString    := arg_Uketukesya_ID;
            end;
            //検査進捗ﾌﾗｸﾞが、2:検中で検査進捗ｻﾌﾞﾌﾗｸﾞが8:保留または9:再呼の時
            if w_Flg_Kensa = GPCST_CODE_KENSIN_2 then begin
              ParamByName('PKENSASTATUS_FLG').AsString      := GPCST_CODE_KENSIN_2; //受付済
              ParamByName('PKENSASUBSTATUS_FLG').AsString   := GPCST_CODE_KENSIN_SUB_10;
              ParamByName('PUKETUKE_TANTOU_ID').AsString    := w_EX_UKETUKE_TANTOU_ID;
            end;

            ParamByName('PUKETUKE_UPDATE_DATE').AsDateTime  := w_DateTime;
            ParamByName('PUKETUKE_JISSI_TERMINAL').AsString := w_Tan_Name;
            ParamByName('PRIS_ID').AsString                 := arg_Ris_ID[w_i];

            ParamByName('PKANJA_NYUGAIKBN').AsString        := w_KJ_KANJA_NYUGAIKBN;
            ParamByName('PKANJA_SECTION_ID').AsString       := w_KJ_SECTION_ID;
            ParamByName('PKANJA_BYOUTOU_ID').AsString       := w_KJ_BYOUTOU_ID;
            ParamByName('PKANJA_BYOUSITU_ID').AsString      := w_KJ_BYOUSITU_ID;
            //2004.04.20
            ParamByName('PUKETUKE_NO').AsString             := w_New_Uketuke_NO;
            ExecSQL;
          end;
          arg_DB.Commit;
          {--- 2004.04.20 Start ---
          //患者マスタ
          with w_Query_Update do begin
            Close;
            SQL.Clear;
            SQL.Add('UPDATE KANJAMASTER SET ');
            SQL.Add(' UKETUKE_NO   = :PUKETUKE_NO ');
//RIS更新日時            SQL.Add(' RIS_UPDATEDATE   = :PRIS_UPDATEDATE ');
            SQL.Add('WHERE KANJAID = :PKANJAID ');
            if not Prepared then Prepare;
            ParamByName('PKANJAID').AsString := arg_Kanja_ID[w_i];

            ParamByName('PUKETUKE_NO').AsString  := w_New_Uketuke_NO;
//RIS更新日時            ParamByName('PRIS_UPDATEDATE').AsString  := w_DateTime;

            ExecSQL;

            arg_DB.Commit;

          end;
          --- 2004.04.20 End ---}
        except
          on E: Exception do begin
            arg_DB.Rollback; // コミットで失敗した場合，変更を取り消す
            arg_Error_Code := CST_ERRCODE_10; //登録失敗
            arg_Error_Message := #13#10
                               + #13#10+'commit'
                               + #13#10+E.Message;
            arg_Error_SQL := w_Query_Update.SQL.Text;
            w_Query_Data.Close;
            w_Query_Update.Close;

            w_Query_Data.Free;
            w_Query_Update.Free;

//            wt_Flg_Kensa.Free;
//            wt_RomaSimei.Free;

            Result := 2;
            Exit;
          end;
        end;

        if w_Flg_Kensa = GPCST_CODE_KENSIN_0 then begin
          {//2004.04.09
          //RISオーダで送信キュー作成設定が"なし"の場合はキューを作成しない。 2004.02.05
          if (w_OD_SYSTEMKBN = GPCST_CODE_SYSK_RIS) and
             (g_RIS_Order_Sousin_Flg = GPCST_RISORDERSOUSIN_FLG_0) then
          else begin
          }
          //2004.04.09
          //RISオーダで送信キュー作成設定が"なし"or"HISなしRepあり"の場合はキューを作成しない。
          if func_Check_CueAndDummy(w_OD_SYSTEMKBN,arg_Kanja_ID[w_i],1) then begin

            //電文連番:転送オーダテーブル(日付管理あり)
            w_New_Denbun_NO := '';
            w_New_Denbun_NO := func_Uketuke_Make_DenbunNO(arg_DB,
                                                          w_Query_Data,
                                                          FormatDateTime(CST_FORMATDATE_3, w_DateTime)
                                                         );

            if w_New_Denbun_NO = '' then begin
              if arg_Error_Code <> '' then begin
                arg_Error_Code := CST_ERRCODE_07; //電文連番取得エラー
                arg_Error_Message := #13#10
                                    +#13#10+'患者ＩＤ　：'+arg_Kanja_ID[w_i]
                                    +#13#10+'ＲＩＳＩＤ：'+arg_Ris_ID[w_i]
                                    ;
              end;
              Result := 3;
            end else begin
              arg_DB.StartTransaction;
              try
                with w_Query_Update do begin
                  Close;
                  SQL.Clear;
                  SQL.Add('INSERT INTO TENSOUORDERTABLE( ');
                  SQL.Add('NO,');
                  SQL.Add('UPDATEDATE,');
                  SQL.Add('RIS_ID,');
                  SQL.Add('INFKBN,');
                  SQL.Add('SYORIKBN,');
                  SQL.Add('JOUTAIKBN,');
                  SQL.Add('SOUSIN_DATE,');
                  SQL.Add('SOUSIN_FLG,');
                  SQL.Add('SOUSIN_STATUS_NAME,');
                  SQL.Add('KENSATYPE_NAME,');
                  SQL.Add('KANJAID,');
                  SQL.Add('ROMASIMEI,');
                  SQL.Add('KENSA_DATE ');
                  SQL.Add(') VALUES ( ');
                  SQL.Add(':PNO,');
                  SQL.Add(':PUPDATEDATE,');
                  SQL.Add(':PRIS_ID,');
                  SQL.Add(':PINFKBN,');
                  SQL.Add(':PSYORIKBN,');
                  SQL.Add(':PJOUTAIKBN,');
                  SQL.Add(':PSOUSIN_DATE,');
                  SQL.Add(':PSOUSIN_FLG,');
                  SQL.Add(':PSOUSIN_STATUS_NAME,');
                  SQL.Add(':PKENSATYPE_NAME,');
                  SQL.Add(':PKANJAID,');
                  SQL.Add(':PROMASIMEI,');
                  SQL.Add(':PKENSA_DATE ');
                  SQL.Add(') ');
                  if not Prepared then Prepare;
                  ParamByName('PNO').AsString           := w_New_Denbun_NO;
                  ParamByName('PUPDATEDATE').AsDateTime := w_DateTime;
                  ParamByName('PRIS_ID').AsString       := arg_Ris_ID[w_i];
                  ParamByName('PINFKBN').AsString       := GPCST_INFKBN_FU;     //受付電文
                  ParamByName('PSYORIKBN').AsString     := GPCST_SYORIKBN_01;   //新規
                  ParamByName('PJOUTAIKBN').AsString    := '00'; //状態なし
                  ParamByName('PSOUSIN_DATE').AsString  := '';
                  ParamByName('PSOUSIN_FLG').AsString   := '0';  //未送信
                  ParamByName('PSOUSIN_STATUS_NAME').AsString := '';
                  ParamByName('PKENSATYPE_NAME').AsString     := w_EX_KENSATYPE_NAME;
                  ParamByName('PKANJAID').AsString      := arg_Kanja_ID[w_i];
                  ParamByName('PROMASIMEI').AsString    := w_KJ_ROMASIMEI;
                  ParamByName('PKENSA_DATE').AsString   := w_New_KENSA_DATE;//func_Date10To8(FormatDateTime(CST_FORMATDATE_1 ,w_DateTime));
                  ExecSQL;
                end;

                try
                  arg_DB.Commit; // 成功した場合，変更をコミットする
                except
                  on E: Exception do begin
                    arg_DB.Rollback; // コミットで失敗した場合，変更を取り消す
                    arg_Error_Code := CST_ERRCODE_10; //登録失敗
                    arg_Error_Message := #13#10
                                       + #13#10+'commit'
                                       + #13#10+E.Message;
                    arg_Error_SQL := w_Query_Update.SQL.Text;
                    Result := 3;
                  end;
                end;
              except
                on E: Exception do begin
                  arg_DB.Rollback; // コミットで失敗した場合，変更を取り消す
                  arg_Error_Code := CST_ERRCODE_10; //登録失敗
                  arg_Error_Message := #13#10
                                     + #13#10+E.Message;
                  arg_Error_SQL := w_Query_Update.SQL.Text;
                  Result := 3;
                end;
              end;
            end;
          end; //2004.02.05
        {2003.12.18
          //電文連番:PACS-RIS転送オーダテーブル(日付管理あり)
          w_New_PacsDenbun_NO := '';
          w_New_PacsDenbun_NO := func_Uketuke_Make_PacsDenbunNO(arg_DB,
                                                          w_Query_Data,
                                                          FormatDateTime(CST_FORMATDATE_3, w_DateTime)
                                                         );
          if w_New_PacsDenbun_NO = '' then begin
            if arg_Error_Code <> '' then begin
              arg_Error_Code := CST_ERRCODE_13; //電文連番取得エラー
              arg_Error_Message := #13#10
                                  +#13#10+'PACS-RIS転送テーブルの電文連番取得に失敗しました。'
                                  +#13#10+'患者ＩＤ　：'+arg_Kanja_ID[w_i]
                                  +#13#10+'ＲＩＳＩＤ：'+arg_Ris_ID[w_i]
                                  ;
            end;
            Result := 3;
          end else begin
            arg_DB.StartTransaction;
            try
              //PACS-RIS転送オーダテーブルにも書き込む
              with w_Query_Update do begin
                Close;
                SQL.Clear;
                SQL.Add('INSERT INTO TENSOUPACSTABLE( ');
                SQL.Add('NO,');
                SQL.Add('UPDATEDATE,');
                SQL.Add('RIS_ID,');
                SQL.Add('INFKBN,');
                SQL.Add('SYORIKBN,');
                SQL.Add('JOUTAIKBN,');
                SQL.Add('SOUSIN_DATE,');
                SQL.Add('SOUSIN_FLG,');
                SQL.Add('SOUSIN_STATUS_NAME,');
                SQL.Add('KENSATYPE_NAME,');
                SQL.Add('KANJAID,');
                SQL.Add('ROMASIMEI,');
                SQL.Add('KENSA_DATE ');
                SQL.Add(') VALUES ( ');
                SQL.Add(':PNO,');
                SQL.Add(':PUPDATEDATE,');
                SQL.Add(':PRIS_ID,');
                SQL.Add(':PINFKBN,');
                SQL.Add(':PSYORIKBN,');
                SQL.Add(':PJOUTAIKBN,');
                SQL.Add(':PSOUSIN_DATE,');
                SQL.Add(':PSOUSIN_FLG,');
                SQL.Add(':PSOUSIN_STATUS_NAME,');
                SQL.Add(':PKENSATYPE_NAME,');
                SQL.Add(':PKANJAID,');
                SQL.Add(':PROMASIMEI,');
                SQL.Add(':PKENSA_DATE ');
                SQL.Add(') ');
                if not Prepared then Prepare;
                ParamByName('PNO').AsString           := w_New_PacsDenbun_NO;
                ParamByName('PUPDATEDATE').AsDateTime := w_DateTime;
                ParamByName('PRIS_ID').AsString       := w_OD_ORDERNO;
                ParamByName('PINFKBN').AsString       := GPCST_INFKBN_FU;     //受付電文
                ParamByName('PSYORIKBN').AsString     := GPCST_SYORIKBN_02;   //更新
                ParamByName('PJOUTAIKBN').AsString    := '00'; //状態なし
                ParamByName('PSOUSIN_DATE').AsString  := '';
                ParamByName('PSOUSIN_FLG').AsString   := '0';  //未送信
                ParamByName('PSOUSIN_STATUS_NAME').AsString := '';
                ParamByName('PKENSATYPE_NAME').AsString     := w_EX_KENSATYPE_NAME;
                ParamByName('PKANJAID').AsString      := arg_Kanja_ID[w_i];
                ParamByName('PROMASIMEI').AsString    := w_KJ_ROMASIMEI;
                ParamByName('PKENSA_DATE').AsString   := w_New_KENSA_DATE;//func_Date10To8(FormatDateTime(CST_FORMATDATE_1 ,w_DateTime));
                ExecSQL;
              end;
              try
                arg_DB.Commit; // 成功した場合，変更をコミットする
              except
                on E: Exception do begin
                  arg_DB.Rollback; // コミットで失敗した場合，変更を取り消す
                  arg_Error_Code := CST_ERRCODE_10; //登録失敗
                  arg_Error_Message := #13#10
                                     + #13#10+'commit'
                                     + #13#10+E.Message;
                  arg_Error_SQL := w_Query_Update.SQL.Text;
                  Result := 3;
                  break;
                end;
              end;
            except
              on E: Exception do begin
                  arg_DB.Rollback; // コミットで失敗した場合，変更を取り消す
                  arg_Error_Code := CST_ERRCODE_10; //登録失敗
                  arg_Error_Message := #13#10
                                     + #13#10+E.Message;
                  arg_Error_SQL := w_Query_Update.SQL.Text;

                  Result := 3;
                  break;
              end;
            end;
          end;
        2003.12.18}

          //2004.04.09
          //送信キュー作成設定が"あり"or"HISなしRepあり"の場合はキューを作成する。
          if func_Check_CueAndDummy(w_OD_SYSTEMKBN,arg_Kanja_ID[w_i],0) then begin
            //電文連番:REPORT-RIS転送オーダテーブル(日付管理あり)
            w_New_ReportDenbun_NO := '';
            w_New_ReportDenbun_NO := func_Uketuke_Make_ReportDenbunNO(arg_DB,
                                                            w_Query_Data,
                                                            FormatDateTime(CST_FORMATDATE_3, w_DateTime)
                                                           );
            if w_New_ReportDenbun_NO = '' then begin
              if arg_Error_Code <> '' then begin
                arg_Error_Code := CST_ERRCODE_14; //電文連番取得エラー
                arg_Error_Message := #13#10
                                    +#13#10+'REPORT-RIS転送テーブルの電文連番取得に失敗しました。'
                                    +#13#10+'患者ＩＤ　：'+arg_Kanja_ID[w_i]
                                    +#13#10+'ＲＩＳＩＤ：'+arg_Ris_ID[w_i]
                                    ;
              end;
              Result := 3;
            end else begin

              arg_DB.StartTransaction;
              try
                //HISオーダの場合、REPORT-RIS転送オーダテーブルにも書き込む
                with w_Query_Update do begin
                  Close;
                  SQL.Clear;
                  SQL.Add('INSERT INTO TENSOUREPORTTABLE( ');
                  SQL.Add('NO,');
                  SQL.Add('UPDATEDATE,');
                  SQL.Add('RIS_ID,');
                  SQL.Add('INFKBN,');
                  SQL.Add('SYORIKBN,');
                  SQL.Add('JOUTAIKBN,');
                  SQL.Add('SOUSIN_DATE,');
                  SQL.Add('SOUSIN_FLG,');
                  SQL.Add('SOUSIN_STATUS_NAME,');
                  SQL.Add('KENSATYPE_NAME,');
                  SQL.Add('KANJAID,');
                  SQL.Add('ROMASIMEI,');
                  SQL.Add('KENSA_DATE ');
                  SQL.Add(') VALUES ( ');
                  SQL.Add(':PNO,');
                  SQL.Add(':PUPDATEDATE,');
                  SQL.Add(':PRIS_ID,');
                  SQL.Add(':PINFKBN,');
                  SQL.Add(':PSYORIKBN,');
                  SQL.Add(':PJOUTAIKBN,');
                  SQL.Add(':PSOUSIN_DATE,');
                  SQL.Add(':PSOUSIN_FLG,');
                  SQL.Add(':PSOUSIN_STATUS_NAME,');
                  SQL.Add(':PKENSATYPE_NAME,');
                  SQL.Add(':PKANJAID,');
                  SQL.Add(':PROMASIMEI,');
                  SQL.Add(':PKENSA_DATE ');
                  SQL.Add(') ');
                  if not Prepared then Prepare;
                  ParamByName('PNO').AsString           := w_New_ReportDenbun_NO;
                  ParamByName('PUPDATEDATE').AsDateTime := w_DateTime;
                  ParamByName('PRIS_ID').AsString       := w_OD_ORDERNO;
                  ParamByName('PINFKBN').AsString       := GPCST_INFKBN_FU;     //受付電文
                  ParamByName('PSYORIKBN').AsString     := GPCST_SYORIKBN_02;   //更新
                  ParamByName('PJOUTAIKBN').AsString    := '00'; //状態なし
                  ParamByName('PSOUSIN_DATE').AsString  := '';
                  ParamByName('PSOUSIN_FLG').AsString   := '0';  //未送信
                  ParamByName('PSOUSIN_STATUS_NAME').AsString := '';
                  ParamByName('PKENSATYPE_NAME').AsString     := w_EX_KENSATYPE_NAME;
                  ParamByName('PKANJAID').AsString      := arg_Kanja_ID[w_i];
                  ParamByName('PROMASIMEI').AsString    := w_KJ_ROMASIMEI;
                  ParamByName('PKENSA_DATE').AsString   := w_New_KENSA_DATE;//func_Date10To8(FormatDateTime(CST_FORMATDATE_1 ,w_DateTime));
                  ExecSQL;
                end;

                try
                  arg_DB.Commit; // 成功した場合，変更をコミットする
                except
                  on E: Exception do begin
                    arg_DB.Rollback; // コミットで失敗した場合，変更を取り消す
                    arg_Error_Code := CST_ERRCODE_10; //登録失敗
                    arg_Error_Message := #13#10
                                       + #13#10+'commit'
                                       + #13#10+E.Message;
                    arg_Error_SQL := w_Query_Update.SQL.Text;
                    Result := 3;
                  end;
                end;
              except
                on E: Exception do begin
                    arg_DB.Rollback; // コミットで失敗した場合，変更を取り消す
                    arg_Error_Code := CST_ERRCODE_10; //登録失敗
                    arg_Error_Message := #13#10
                                       + #13#10+E.Message;
                    arg_Error_SQL := w_Query_Update.SQL.Text;
                    Result := 3;
                end;
              end;
            end;
          end; //2004.04.09
        end;
        w_KanjaExsist :='';
        with w_Query_Data do begin
          Close;
          SQL.Clear;
          SQL.Add('SELECT *');
          SQL.Add('FROM TENSOUKANJATABLE');
          SQL.Add('WHERE KANJAID = '''+ arg_Kanja_ID[w_i] +'''');
          SQL.Add('AND SOUSIN_FLG = '''+ GPCST_SOUSIN_FLG_0 +'''');
          if not Prepared then Prepare;
          Open;
          last;
          first;
          if not(Eof) then begin
            w_KanjaExsist :='1';
          end;
          Close;
        end;
        if w_KanjaExsist <>'1' then begin
          //電文連番:転送患者情報テーブル(日付管理あり)
          w_New_KanjaDenbun_NO := '';
          w_New_KanjaDenbun_NO := func_Uketuke_Make_KanjaDenbunNO(arg_DB,
                                                          w_Query_Data,
                                                          FormatDateTime(CST_FORMATDATE_3, w_DateTime)
                                                         );
          if w_New_KanjaDenbun_NO = '' then begin
            if arg_Error_Code <> '' then begin
              arg_Error_Code := CST_ERRCODE_12; //電文連番取得エラー
              arg_Error_Message := #13#10
                                  +#13#10+'転送患者情報テーブルの電文連番取得に失敗しました。'
                                  +#13#10+'患者ＩＤ　：'+arg_Kanja_ID[w_i]
                                  ;
            end;
             Result := 3;
          end else begin
            arg_DB.StartTransaction;
            try
              //転送患者情報テーブルにも書き込む
              with w_Query_Update do begin
                Close;
                SQL.Clear;
                SQL.Add('INSERT INTO TENSOUKANJATABLE( ');
                SQL.Add('NO,');
                SQL.Add('UPDATEDATE,');
                SQL.Add('SOUSIN_DATE,');
                SQL.Add('SOUSIN_FLG,');
                SQL.Add('SOUSIN_STATUS_NAME,');
                SQL.Add('ANS_SBT,');
                SQL.Add('KANJAID,');
                SQL.Add('ROMASIMEI,');
                SQL.Add('KENSA_DATE ');
                SQL.Add(') VALUES ( ');
                SQL.Add(':PNO,');
                SQL.Add(':PUPDATEDATE,');
                SQL.Add(':PSOUSIN_DATE,');
                SQL.Add(':PSOUSIN_FLG,');
                SQL.Add(':PSOUSIN_STATUS_NAME,');
                SQL.Add(':PANS_SBT,');
                SQL.Add(':PKANJAID,');
                SQL.Add(':PROMASIMEI,');
                SQL.Add(':PKENSA_DATE ');
                SQL.Add(') ');
                if not Prepared then Prepare;
                ParamByName('PNO').AsString           := w_New_KanjaDenbun_NO;
                ParamByName('PUPDATEDATE').AsDateTime := w_DateTime;
                ParamByName('PSOUSIN_DATE').AsString  := '';
                ParamByName('PSOUSIN_FLG').AsString   := '0';  //未送信
                ParamByName('PSOUSIN_STATUS_NAME').AsString := '';
                ParamByName('PANS_SBT').AsString      := '';
                ParamByName('PKANJAID').AsString      := arg_Kanja_ID[w_i];
                ParamByName('PROMASIMEI').AsString    := w_KJ_ROMASIMEI;
                ParamByName('PKENSA_DATE').AsString   := w_New_KENSA_DATE;//func_Date10To8(FormatDateTime(CST_FORMATDATE_1 ,w_DateTime));
                ExecSQL;
              end;
              try
                arg_DB.Commit; // 成功した場合，変更をコミットする
              except
                on E: Exception do begin
                  arg_DB.Rollback; // コミットで失敗した場合，変更を取り消す
                  arg_Error_Code := CST_ERRCODE_10; //登録失敗
                  arg_Error_Message := #13#10
                                     + #13#10+'commit'
                                     + #13#10+E.Message;
                  arg_Error_SQL := w_Query_Update.SQL.Text;
                  Result := 3;
                end;
              end;
            except
              on E: Exception do begin
                arg_DB.Rollback; // コミットで失敗した場合，変更を取り消す
                arg_Error_Code := CST_ERRCODE_10; //登録失敗
                arg_Error_Message := #13#10
                                 + #13#10+E.Message;
                arg_Error_SQL := w_Query_Update.SQL.Text;

                Result := 3;
              end;
            end;
          end;
        end;

      end;  //Roop End


    finally
      w_Query_Data.Free;
      w_Query_Update.Free;

//      wt_Flg_Kensa.Free;
//      wt_RomaSimei.Free;
    end;
  finally
    for w_i := 0 to arg_Ris_ID.Count -1 do begin
      //更新権利返還
      if not func_ReleasKAnri(arg_DB,            //接続されたDB
                              w_Tan_Name,        //PC名称
                              arg_PROG_ID,       //プログラムID
                              arg_Ris_ID[w_i],        //RIS識別ID
                              G_KANRI_TBL_WMODE  //返還権利種(G_KANRI_TBL_WMODE 更新権利)
                             ) then begin
        arg_Error_Haita := True;
      end;
    end;
  end;
end;
//******************************************************************************
// ※RIS識別ID作成
//******************************************************************************
function func_Uketuke_Make_RisID(
         arg_DB:TDatabase;             //接続されたDB
         arg_Query:TQuery;             //接続されたQuery
         arg_DateTime:string           //処理日時
         ):string;
var
  w_NO: integer;
begin
  Result := '';
  //RIS識別ID取得(日付管理あり)
  w_NO := func_Get_NumberControl(arg_DB,
                                 arg_Query,
                                 'RIS',
                                 FormatDateTime(CST_FORMATDATE_1, func_StrToDateTime(arg_DateTime))
                                );
  if w_NO <= 0 then begin
    Exit;
  end;
  Result := 'RIS_'
         + func_Date10To8(FormatDateTime(CST_FORMATDATE_1, func_StrToDateTime(arg_DateTime)))
         + '_'
         + FormatFloat('00000', w_NO);
end;
//******************************************************************************
// ※オーダNO作成
//******************************************************************************
function func_Uketuke_Make_OrderNO(
         arg_DB:TDatabase;             //接続されたDB
         arg_Query:TQuery;             //接続されたQuery
         arg_DateTime:string           //処理日時
         ):string;
var
  w_NO: integer;
begin
  Result := '';
  //オーダNO取得(日付管理なし)
  w_NO := func_Get_NumberControl(arg_DB,
                                 arg_Query,
                                 'ROD',
                                 ''
                                );
  if w_NO <= 0 then begin
    Exit;
  end;
  Result := FormatFloat('000000', w_NO);
end;
//******************************************************************************
// ※受付NO作成
//******************************************************************************
function func_Uketuke_Make_UketukeNO(
         arg_DB:TDatabase;             //接続されたDB
         arg_Query:TQuery;             //接続されたQuery
         arg_DateTime:string;          //処理日時
         arg_KID:string                //区分
         ):string;
var
  w_NO: integer;
begin
  //受付NO取得(日付管理あり)
  w_NO := func_Get_NumberControl(arg_DB,
                                 arg_Query,
                                 arg_KID,
                                 FormatDateTime(CST_FORMATDATE_1, func_StrToDateTime(arg_DateTime))
                                );
  if w_NO <= 0 then begin
    Exit;
  end;
  Result := FormatFloat('000', w_NO);
end;
//******************************************************************************
// ※当日NO作成
//******************************************************************************
function func_Uketuke_Make_ToujituNO(
         arg_DB:TDatabase;             //接続されたDB
         arg_Query:TQuery;             //接続されたQuery
         arg_DateTime:string           //処理日時
         ):string;
var
  w_NO: integer;
begin
  //当日№(日付管理あり)
  w_NO := func_Get_NumberControl(arg_DB,
                                 arg_Query,
                                 'TNO',
                                 FormatDateTime(CST_FORMATDATE_1, func_StrToDateTime(arg_DateTime))
                                );
  if w_NO <= 0 then begin
    Exit;
  end;
  Result := FormatFloat('000', w_NO);
end;
//******************************************************************************
// ※電文連番作成
//******************************************************************************
function func_Uketuke_Make_DenbunNO(
         arg_DB:TDatabase;             //接続されたDB
         arg_Query:TQuery;             //接続されたQuery
         arg_DateTime:string           //処理日時
         ):string;
var
  w_NO: integer;
begin
  //電文連番(受付用)(日付管理あり)
  w_NO := func_Get_NumberControl(arg_DB,
                                 arg_Query,
                                 'DBU',
                                 FormatDateTime(CST_FORMATDATE_1, func_StrToDateTime(arg_DateTime))
                                );
  if w_NO <= 0 then begin
    Exit;
  end;
  Result := FormatFloat('00000', w_NO);
end;
//******************************************************************************
// ※電文連番作成(転送患者情報テーブル)
//******************************************************************************
function func_Uketuke_Make_KanjaDenbunNO(
         arg_DB:TDatabase;             //接続されたDB
         arg_Query:TQuery;             //接続されたQuery
         arg_DateTime:string           //処理日時
         ):string;
var
  w_NO: integer;
begin
  //電文連番(受付用)(日付管理あり)
  w_NO := func_Get_NumberControl(arg_DB,
                                 arg_Query,
                                 'DBK',
                                 FormatDateTime(CST_FORMATDATE_1, func_StrToDateTime(arg_DateTime))
                                );
  if w_NO <= 0 then begin
    Exit;
  end;
  Result := FormatFloat('00000', w_NO);
end;
//******************************************************************************
// ※電文連番作成(Pacs-Risテーブル)
//******************************************************************************
function func_Uketuke_Make_PacsDenbunNO(
         arg_DB:TDatabase;             //接続されたDB
         arg_Query:TQuery;             //接続されたQuery
         arg_DateTime:string           //処理日時
         ):string;
var
  w_NO: integer;
begin
  //電文連番(受付用)(日付管理あり)
  w_NO := func_Get_NumberControl(arg_DB,
                                 arg_Query,
                                 'DBP',
                                 FormatDateTime(CST_FORMATDATE_1, func_StrToDateTime(arg_DateTime))
                                );
  if w_NO <= 0 then begin
    Exit;
  end;
  Result := FormatFloat('00000', w_NO);
end;
//******************************************************************************
// ※電文連番作成(Report-Risテーブル)
//******************************************************************************
function func_Uketuke_Make_ReportDenbunNO(
         arg_DB:TDatabase;             //接続されたDB
         arg_Query:TQuery;             //接続されたQuery
         arg_DateTime:string           //処理日時
         ):string;
var
  w_NO: integer;
begin
  //電文連番(受付用)(日付管理あり)
  w_NO := func_Get_NumberControl(arg_DB,
                                 arg_Query,
                                 'DBR',
                                 FormatDateTime(CST_FORMATDATE_1, func_StrToDateTime(arg_DateTime))
                                );
  if w_NO <= 0 then begin
    Exit;
  end;
  Result := FormatFloat('00000', w_NO);
end;
//******************************************************************************
// ※SUID当日連番作成
//******************************************************************************
function func_Uketuke_Make_ToujituSUID(
         arg_DB:TDatabase;             //接続されたDB
         arg_Query:TQuery;             //接続されたQuery
         arg_DateTime:string           //処理日時
         ):string;
var
  w_NO: integer;
begin
  //SUID当日連番(日付管理あり)
  w_NO := func_Get_NumberControl(arg_DB,
                                 arg_Query,
                                 'TID',
                                 FormatDateTime(CST_FORMATDATE_1, func_StrToDateTime(arg_DateTime))
                                );
  if w_NO <= 0 then begin
    Exit;
  end;
  Result := FormatFloat('0000', w_NO);
end;

//******************************************************************************
// ※受付キャンセル処理
//******************************************************************************
function func_UketukeCancel_Kyotu(
         arg_DB:TDatabase;             //接続されたDB
         arg_PROG_ID:string;           //プログラムID
         arg_Ris_ID:string;            //RIS識別ID
         arg_Kanja_ID:string;          //患者ID
         arg_KensaDate:string;         //予約日(yyyy/mm/dd)
         arg_Uketukesya_Name:string;   //受付者名
         arg_Kensastatus_Flg:string;   //更新前の検査進捗メイン
         arg_KensaSubstatus_Flg:string;   //更新前の検査進捗サブ
         var arg_Error_Code:string;    //エラーコード
         var arg_Error_Message:string; //エラーメッセージ
         var arg_Error_SQL:string;     //エラーSQL文
         var arg_Error_Haita:Boolean   //排他削除エラー True:排他ﾃｰﾌﾞﾙ削除失敗、False:排他ﾃｰﾌﾞﾙ削除成功
         ):Integer;                    //結果0:成功、1:排他/進捗ｴﾗｰ、2:進捗更新ｴﾗｰ、3:送信ﾃｰﾌﾞﾙ書込みｴﾗｰ
var
  w_Query_Data: TQuery;
  w_Query_Update: TQuery;

  w_DateTime: TDateTime;
  w_Tan_Name: string;
//実績メインデータ
  w_EX_KENSASTATUS_FLG: string;
  w_EX_KENSASUBSTATUS_FLG: string;
  w_EX_KENSATYPE_ID: string;
  w_EX_KENSATYPE_NAME: string;
  w_EX_UKETUKE_TANTOU_ID: string;
  w_EX_KANJAID: string;
  w_EX_KENSA_DATE: string;
//オーダメインデータ
  w_OD_KENSA_DATE: string;
  w_OD_KENSA_DATE_AGE: string;
  w_OD_ORDERNO: string;  //2003.01.08
  w_New_AccessionNo:string;     //新AccessionNo.（オーダNo.+HIS発行日付）
  w_OD_DENPYO_NYUGAIKBN: string;  //2003.03.14
  w_OD_KENSAKIKI_ID: string;      //2003.03.14
  w_OD_YOTEIKAIKEI_FLG: string;  //2003.03.14
  w_OD_DOKUEI_FLG: string;  //2004.03.05
//患者マスタデータ
  w_KJ_ROMASIMEI: string;
//
  w_New_Denbun_NO: string;     //新規の電文連番
  w_New_PacsDenbun_NO: string;
  w_New_ReportDenbun_NO: string;
  w_Now_KENSA_DATE: string;
  w_OD_SYSTEMKBN :string;
begin
  arg_Error_Code := '';
  arg_Error_Message := '';
  arg_Error_SQL := '';
  arg_Error_Haita := False;
  Result := 0;

  w_Query_Data := TQuery.Create(nil);
  w_Query_Data.DatabaseName := arg_DB.DatabaseName;
  w_Query_Update := TQuery.Create(nil);
  w_Query_Update.DatabaseName := arg_DB.DatabaseName;
  try
    //現在日時取得
    w_DateTime := func_GetDBSysDate(w_Query_Data);
    //コンピュータ名取得
    w_Tan_Name := func_GetThisMachineName;

    //更新権利取得
    if not func_GetWKAnri(arg_DB,            //接続されたDB
                          w_Tan_Name,        //PC名称
                          arg_PROG_ID,       //プログラムID
                          arg_Ris_ID         //RIS識別ID
                         ) then begin
      proc_Get_Lock_HaitaData(w_Query_Data,
                              arg_Ris_ID,
                              w_Tan_Name,
                              w_EX_KANJAID,
                              w_Now_KENSA_DATE,
                              w_EX_KENSATYPE_NAME);
      arg_Error_Message := #13#10
                          +#13#10+'端末名　　：'+w_Tan_Name
                          +#13#10+'患者ＩＤ　：'+w_EX_KANJAID
                          +#13#10+'実績検査日：'+w_Now_KENSA_DATE
                          +#13#10+'検査種別　：'+w_EX_KENSATYPE_NAME
                          +#13#10+'ＲＩＳＩＤ：'+arg_Ris_ID
                          ;
      arg_Error_Code := CST_ERRCODE_08; //更新権利取得エラー
      Result := 1;
      Exit;
    end;

    try
      try
        //オーダメイン、実績メイン、患者マスタより最新情報の取得
        with w_Query_Data do begin
          Close;
          SQL.Clear;
          SQL.Add ('SELECT exma.RIS_ID ');
          SQL.Add ('      ,exma.KANJAID ');
          SQL.Add ('      ,exma.KENSASTATUS_FLG ');
          SQL.Add ('      ,exma.KENSASUBSTATUS_FLG ');
          SQL.Add ('      ,exma.KENSATYPE_ID ');
          SQL.Add ('      ,exma.KENSA_DATE EX_KENSA_DATE ');
          SQL.Add ('      ,exma.KENSA_DATE KENSA_DATE_EX ');
          SQL.Add ('      ,odma.KENSA_DATE ');
          SQL.Add ('      ,odma.KENSA_DATE_AGE ');
          SQL.Add ('      ,odma.DENPYO_NYUGAIKBN ');
          SQL.Add ('      ,odma.KENSAKIKI_ID ');
          SQL.Add ('      ,odma.ORDERNO ');
        {2003.02.05 start}
          SQL.Add ('      ,to_char(odma.HIS_HAKKO_DATE,''YYYYMMDD'') HIS_HAKKO_DATE ');
        {2003.02.05 end}
        {2003.03.14 start}
          SQL.Add ('      ,odma.YOTEIKAIKEI_FLG ');
        {2003.03.14 end}
          SQL.Add ('      ,odma.DOKUEI_FLG '); //2004.03.05
          SQL.Add ('      ,odma.SYSTEMKBN ');  //2004.02.05
          SQL.Add ('      ,exma.UKETUKE_TANTOU_ID ');
          SQL.Add ('      ,mas.KENSATYPE_NAME ');
          SQL.Add ('      ,kj.ROMASIMEI ');
          SQL.Add ('      ,kj.KANASIMEI '); //2004.04.12
          SQL.Add ('FROM   EXMAINTABLE exma,ORDERMAINTABLE odma,KANJAMASTER kj, KENSATYPEMASTER mas ');
          SQL.Add ('WHERE  exma.RIS_ID  = :PRIS_ID ');
          SQL.Add ('  AND  exma.KANJAID = :PKANJAID ');
          SQL.Add ('  AND  exma.KENSATYPE_ID = mas.KENSATYPE_ID(+) ');
          SQL.Add ('  AND  odma.RIS_ID  = exma.RIS_ID ');
          SQL.Add ('  AND  kj.KANJAID   = exma.KANJAID ');
          if not Prepared then Prepare;
          ParamByName('PRIS_ID').AsString  := arg_Ris_ID;
          ParamByName('PKANJAID').AsString := arg_Kanja_ID;
          Open;
          Last;
          First;
          if not(w_Query_Data.Eof) and
            (w_Query_Data.RecordCount > 0) then begin
            w_EX_KENSASTATUS_FLG    := FieldByName('KENSASTATUS_FLG').AsString;           //検査メインステータス
            w_EX_KENSASUBSTATUS_FLG := FieldByName('KENSASUBSTATUS_FLG').AsString;        //検査サブステータス
            w_EX_KENSATYPE_ID       := FieldByName('KENSATYPE_ID').AsString;
            w_EX_KENSATYPE_NAME     := Copy(FieldByName('KENSATYPE_NAME').AsString,1,20);
            w_EX_UKETUKE_TANTOU_ID  := FieldByName('UKETUKE_TANTOU_ID').AsString;
            w_Now_KENSA_DATE        := func_Date8To10(FieldByName('EX_KENSA_DATE').AsString);
            w_OD_KENSA_DATE         := FieldByName('KENSA_DATE').AsString;
            w_OD_KENSA_DATE_AGE     := FieldByName('KENSA_DATE_AGE').AsString;
{2003.03.14 start}
            w_OD_DENPYO_NYUGAIKBN   := FieldByName('DENPYO_NYUGAIKBN').AsString;
            w_OD_KENSAKIKI_ID       := FieldByName('KENSAKIKI_ID').AsString;
            w_OD_YOTEIKAIKEI_FLG    := FieldByName('YOTEIKAIKEI_FLG').AsString;
            w_OD_DOKUEI_FLG         := FieldByName('DOKUEI_FLG').AsString; //2004.03.05
{2003.03.14 end}
            //2004.04.12
            //w_KJ_ROMASIMEI          := FieldByName('ROMASIMEI').AsString;
            w_KJ_ROMASIMEI          := FieldByName('KANASIMEI').AsString;

            w_EX_KENSA_DATE         := FieldByName('KENSA_DATE_EX').AsString;
{2003.02.05
            w_OD_ORDERNO            := FieldByName('ORDERNO').AsString;
2003.02.05}
{2003.12.18 start}
            //新AccessionNo.の作成
            //w_New_AccessionNo := Right('00000000'+FieldByName('ORDERNO').AsString,8) + FieldByName('HIS_HAKKO_DATE').AsString;
            w_New_AccessionNo := FieldByName('ORDERNO').AsString;
            w_OD_ORDERNO := w_New_AccessionNo;
            //2004.02.05
            w_OD_SYSTEMKBN := FieldByName('SYSTEMKBN').AsString;
{2003.12.18 end}
          end
          else begin
            arg_Error_Code := CST_ERRCODE_01; //読み込みエラー
            Result := 1;
            Exit;
          end;
          Close;

        end;
      except
        on E: Exception do begin
          arg_Error_Code := CST_ERRCODE_10; //登録失敗
          arg_Error_Message := #13#10
                             + #13#10+E.Message;
          arg_Error_SQL := w_Query_Data.SQL.Text;
          w_Query_Data.Close;
          Result := 1;
          exit;
        end;
      end;

      //最新検査進捗と比較し異なる場合にエラーとする
      if (w_EX_KENSASTATUS_FLG <> arg_Kensastatus_Flg)
      or (w_EX_KENSASUBSTATUS_FLG <> arg_KensaSubstatus_Flg) then begin
        arg_Error_Code := CST_ERRCODE_02; //検査進捗エラー
        Result := 1;
        Exit;
      end;

//更新処理開始
      arg_DB.StartTransaction;
      try
        //ロック
        with w_Query_Data do begin
          Close;
          SQL.Clear;
          SQL.Add ('SELECT orma.RIS_ID ');
          SQL.Add ('FROM OrderMainTable orma ');
          SQL.Add ('WHERE orma.RIS_ID = :PRIS_ID ');
          SQL.Add (' for update ');
          if not Prepared then Prepare;
          ParamByName('PRIS_ID').AsString := arg_Ris_ID;
          ExecSQL;
        end;

        //実績メインテーブル
        with w_Query_Update do begin
          Close;
          SQL.Add('UPDATE EXMAINTABLE SET ');
          SQL.Add(' KENSASTATUS_FLG        = :PKENSASTATUS_FLG ');
          SQL.Add(',KENSASUBSTATUS_FLG     = :PKENSASUBSTATUS_FLG ');
          SQL.Add(',UKETUKE_TANTOU_ID      = :PUKETUKE_TANTOU_ID ');
        {2003.12.19 start}
          //SQL.Add(',UKETUKE_UPDATE_DATE    = :PUKETUKE_UPDATE_DATE ');
          //SQL.Add(',UKETUKE_JISSI_TERMINAL = :PUKETUKE_JISSI_TERMINAL ');
          SQL.Add(',UKETUKECL_UPDATE_DATE    = :PUKETUKECL_UPDATE_DATE ');
          SQL.Add(',UKETUKECL_JISSI_TERMINAL = :PUKETUKECL_JISSI_TERMINAL ');
        {2003.12.19 end}
        {2002.12.17
          if w_EX_KENSASTATUS_FLG = GPCST_CODE_KENSIN_1 then begin
            SQL.Add(',KENSA_DATE             = :PKENSA_DATE ');
            SQL.Add(',KENSA_DATE_AGE         = :PKENSA_DATE_AGE ');
          end;
        2002.12.17}
        {2003.03.14 start}
          if w_EX_KENSASTATUS_FLG = GPCST_CODE_KENSIN_1 then begin
            SQL.Add(',NEWUPDATE_FLG        = :PNEWUPDATE_FLG ');
            SQL.Add(',KENSA_DATE           = :PKENSA_DATE ');
            SQL.Add(',KENSA_DATE_AGE       = :PKENSA_DATE_AGE ');
            SQL.Add(',DENPYO_NYUGAIKBN     = :PDENPYO_NYUGAIKBN ');
            SQL.Add(',JISSEKIKAIKEI_FLG    = :PJISSEKIKAIKEI_FLG ');
            SQL.Add(',KENSAKIKI_ID         = :PKENSAKIKI_ID ');
            SQL.Add(',EXAMNO1              = :PEXAMNO1 ');
            SQL.Add(',PROTOCOL             = :PPROTOCOL ');
            SQL.Add(',KENSA_KBN            = :PKENSA_KBN ');
            SQL.Add(',SYOKEN_COMMENT       = :PSYOKEN_COMMENT ');
            SQL.Add(',THREED_COMMENT       = :PTHREED_COMMENT ');
            SQL.Add(',RI_CANCEL            = :PRI_CANCEL ');
            SQL.Add(',TOUSITIME            = :PTOUSITIME ');
            SQL.Add(',BAKUSYASUU           = :PBAKUSYASUU ');
          {
            SQL.Add(',KENSA_START_DATE     = :PKENSA_START_DATEU ');
            SQL.Add(',KENSA_START_KAISUU   = :PKENSA_START_KAISUU ');
            SQL.Add(',KENSA_HORYUU_DATE    = :PKENSA_HORYUU_DATE ');
            SQL.Add(',KENSA_HORYUU_KAISUU  = :PKENSA_HORYUU_KAISUU ');
            SQL.Add(',JISSEKI_HOZON_DATE   = :PJISSEKI_HOZON_DATE ');
            SQL.Add(',JISSEKI_HOZON_KAISU  = :PJISSEKI_HOZON_KAISU ');
            SQL.Add(',JISSEKI_HOZON_TERMINAL = :PJISSEKI_HOZON_TERMINAL ');
            SQL.Add(',JISSEKI_UPDATE_DATE  = :PJISSEKI_UPDATE_DATE ');
            SQL.Add(',JISSEKI_UPDATE_KAISU = :PJISSEKI_UPDATE_KAISU ');
            SQL.Add(',JISSEKI_UPDATE_TERMINAL = :PJISSEKI_UPDATE_TERMINAL ');
          }
            SQL.Add(',KENSA_GISI_ID1       = :PKENSA_GISI_ID1 ');
            SQL.Add(',KENSA_GISI_ID2       = :PKENSA_GISI_ID2 ');
            SQL.Add(',NYURYOKU_KANGOSI_ID1 = :PNYURYOKU_KANGOSI_ID1 ');
            SQL.Add(',NYURYOKU_KANGOSI_ID2 = :PNYURYOKU_KANGOSI_ID2 ');
            SQL.Add(',KENSAI_SECTION_ID1   = :PKENSAI_SECTION_ID1 ');
            SQL.Add(',KENSAI_DOCTOR_NAME1  = :PKENSAI_DOCTOR_NAME1 ');
            SQL.Add(',KENSAI_SECTION_ID2   = :PKENSAI_SECTION_ID2 ');
            SQL.Add(',KENSAI_DOCTOR_NAME2  = :PKENSAI_DOCTOR_NAME2 ');
            SQL.Add(',BIKOU                = :PBIKOU ');
            SQL.Add(',DOKUEI_FLG           = :PDOKUEI_FLG ');
          //放医、施医、処方医のクリア 2004.03.31 →
            SQL.Add(',KENSAI_DOCTOR_ID1    = :PKENSAI_DOCTOR_ID1 ');
            SQL.Add(',KENSAI_DOCTOR_ID2    = :PKENSAI_DOCTOR_ID2 ');
            SQL.Add(',SYOHOISI_ID          = :PSYOHOISI_ID ');
          //2004.03.31 ←
          end;
        {2003.03.14 end}
          SQL.Add('WHERE RIS_ID = :PRIS_ID ');
          if not Prepared then Prepare;

          //検査進捗ﾌﾗｸﾞが、0:未受付の時
          if w_EX_KENSASTATUS_FLG = GPCST_CODE_KENSIN_1 then begin
            ParamByName('PKENSASTATUS_FLG').AsString      := GPCST_CODE_KENSIN_0;        //未受付
            ParamByName('PKENSASUBSTATUS_FLG').AsString   := '';                         //Default
            ParamByName('PUKETUKE_TANTOU_ID').AsString    := '';                         //受付担当者ｸﾘｱ
          {2002.12.17
            ParamByName('PKENSA_DATE').AsString             := w_OD_KENSA_DATE;            //予定検査日付
            ParamByName('PKENSA_DATE_AGE').AsString         := w_OD_KENSA_DATE_AGE;        //予定検査日年齢
          2002.12.17}
            ParamByName('PUKETUKE_TANTOU_ID').AsString    := '';                         //受付担当者ｸﾘｱ
          {2003.03.14 start}
            ParamByName('PNEWUPDATE_FLG').AsString        := '0';                        //新規登録ﾌﾗｸﾞ解除
            ParamByName('PKENSA_DATE').AsString           := w_OD_KENSA_DATE;            //検査日を戻す
            ParamByName('PKENSA_DATE_AGE').AsString       := w_OD_KENSA_DATE_AGE;        //検査日年齢を戻す
            ParamByName('PDENPYO_NYUGAIKBN').AsString     := w_OD_DENPYO_NYUGAIKBN;      //伝票入外区分を戻す
            ParamByName('PJISSEKIKAIKEI_FLG').AsString    := w_OD_YOTEIKAIKEI_FLG;       //実績会計ﾌﾗｸﾞを戻す
            ParamByName('PKENSAKIKI_ID').AsString         := w_OD_KENSAKIKI_ID;          //実施装置を戻す
            ParamByName('PEXAMNO1').AsString              := '';                         //管理項目（ExamNo1）
            ParamByName('PPROTOCOL').AsString             := '';                         //管理項目（プロトコル）
            ParamByName('PKENSA_KBN').AsString            := '';                         //管理項目（検査区分）
            ParamByName('PSYOKEN_COMMENT').AsString       := '';                         //管理項目（所見）
            ParamByName('PTHREED_COMMENT').AsString       := '';                         //管理項目（３Ｄ情報）
            ParamByName('PRI_CANCEL').AsString            := '';                         //管理項目（キャンセル）
            ParamByName('PTOUSITIME').AsString            := '';                         //管理項目（透視時間）
            ParamByName('PBAKUSYASUU').AsString           := '';                         //管理項目（総爆射数）

            ParamByName('PKENSA_GISI_ID1').AsString       := '';                         //技師1
            ParamByName('PKENSA_GISI_ID2').AsString       := '';                         //技師2
            ParamByName('PNYURYOKU_KANGOSI_ID1').AsString := '';                         //入力看護士1
            ParamByName('PNYURYOKU_KANGOSI_ID2').AsString := '';                         //入力看護士2
            ParamByName('PKENSAI_SECTION_ID1').AsString   := '';                         //検査担当医診療科1
            ParamByName('PKENSAI_DOCTOR_NAME1').AsString  := '';                         //検査担当氏名1
            ParamByName('PKENSAI_SECTION_ID2').AsString   := '';                         //検査担当医診療科2
            ParamByName('PKENSAI_DOCTOR_NAME2').AsString  := '';                         //検査担当氏名2
            ParamByName('PBIKOU').AsString                := '';                         //撮影コメント
          {2003.03.14 end}
            ParamByName('PDOKUEI_FLG').AsString           := w_OD_DOKUEI_FLG;            //読影Fを戻す
          //2004.03.31 →
            ParamByName('PKENSAI_DOCTOR_ID1').AsString    := '';                         //放医ID
            ParamByName('PKENSAI_DOCTOR_ID2').AsString    := '';                         //施医ID
            ParamByName('PSYOHOISI_ID').AsString           := '';                         //処方医ID
          //2004.03.31 ←
          end;
          //検査進捗ﾌﾗｸﾞが、2:検中で検査進捗ｻﾌﾞﾌﾗｸﾞが10:再受の時
          if w_EX_KENSASTATUS_FLG = GPCST_CODE_KENSIN_2 then begin
            ParamByName('PKENSASTATUS_FLG').AsString      := GPCST_CODE_KENSIN_2;        //検査中
            ParamByName('PKENSASUBSTATUS_FLG').AsString   := GPCST_CODE_KENSIN_SUB_8;    //保留
            ParamByName('PUKETUKE_TANTOU_ID').AsString    := w_EX_UKETUKE_TANTOU_ID;                           //受付担当者ｸﾘｱ
          end;

        {2003.12.19 start}
          //ParamByName('PUKETUKE_UPDATE_DATE').AsDateTime  := w_DateTime;                 //ｷｬﾝｾﾙ更新日時
         // ParamByName('PUKETUKE_JISSI_TERMINAL').AsString := w_Tan_Name;                 //ｷｬﾝｾﾙ更新端末
          ParamByName('PUKETUKECL_UPDATE_DATE').AsDateTime  := w_DateTime;                 //ｷｬﾝｾﾙ更新日時
          ParamByName('PUKETUKECL_JISSI_TERMINAL').AsString := w_Tan_Name;                 //ｷｬﾝｾﾙ更新端末
        {2003.12.19 end}
          ParamByName('PRIS_ID').AsString                 := arg_Ris_ID;                 //RIS識別ID

          ExecSQL;

          //検査進捗ﾌﾗｸﾞが、0:未受付の時
          if w_EX_KENSASTATUS_FLG = GPCST_CODE_KENSIN_1 then begin
            //実績部位テーブル(撮影進捗＝未撮影／詳細部位、プリセットのクリア)
            Close;
            SQL.Clear;
            SQL.Add ('UPDATE EXBUITABLE SET ');
            SQL.Add (' SATUEISTATUS    = :PSATUEISTATUS ');
            SQL.Add (',PRESET_NAME     = :PPRESET_NAME ');
            SQL.Add ('WHERE RIS_ID = :PRIS_ID');
            if not Prepared then Prepare;
            //未撮影にする
            ParamByName('PSATUEISTATUS').AsString := GPCST_CODE_SATUEI_0; //未撮影
            //クリア
            ParamByName('PPRESET_NAME').AsString     := '';
            //キー
            ParamByName('PRIS_ID').AsString:=arg_Ris_ID;
            ExecSQL;

          //実績部位テーブルの削除
            Close;
            SQL.Clear;
            SQL.Add ('DELETE FROM EXBUITABLE ');
            SQL.Add ('WHERE RIS_ID = :PRIS_ID ');
            SQL.Add ('  AND HIS_ORIGINAL_FLG = :PHIS_ORIGINAL_FLG'); //聖マリではｵﾘｼﾞﾅﾙは削除できない為、追加部位のみの削除でよい 2004.03.30
            if not Prepared then Prepare;
            ParamByName('PRIS_ID').AsString           := arg_Ris_ID;
            ParamByName('PHIS_ORIGINAL_FLG').AsString := '0'; //オリジナル以外 2004.03.30 復活
            ExecSQL;

          {RIS部位番号がある為、実績部位テーブルの入れ直しは行わない。上記ｵﾘｼﾞﾅﾙ部位以外の削除で対応する
          2004.03.30
          //実績部位テーブルをオーダ部位テーブルと同じ状態にする
            w_Query_Data.Close;
            w_Query_Data.SQL.Clear;
            w_Query_Data.SQL.Add('SELECT * FROM ORDERBUITABLE ');
            w_Query_Data.SQL.Add(' WHERE RIS_ID = :PRIS_ID ');
            if not w_Query_Data.Prepared then w_Query_Data.Prepare;
            w_Query_Data.ParamByName('PRIS_ID').AsString := arg_Ris_ID;
            w_Query_Data.Open;
            w_Query_Data.Last;
            w_Query_Data.First;
            while not(w_Query_Data.Eof) do begin
              Close;
              SQL.Clear;
              SQL.Add ('INSERT INTO EXBUITABLE (');
              SQL.Add (' RIS_ID ');
              SQL.Add (',NO ');
              SQL.Add (',BUI_ID ');
              SQL.Add (',HOUKOU_ID ');
              SQL.Add (',SAYUU_ID ');
              SQL.Add (',KENSAHOUHOU_ID ');
              SQL.Add (',SATUEISTATUS ');
              SQL.Add (',HIS_ORIGINAL_FLG ');
              SQL.Add (',PRESET_NAME ');
              SQL.Add (',BUICOMMENT ');
              //2003.12.15
              //SQL.Add (',BUICOMMENT_ID1 ');
              //SQL.Add (',BUICOMMENT_ID2 ');
              //SQL.Add (',BUICOMMENT_ID3 ');
              //SQL.Add (',BUICOMMENT_ID4 ');
              //SQL.Add (',BUICOMMENT_ID5 ');
              SQL.Add (') VALUES ( ');
              SQL.Add (' :PRIS_ID ');
              SQL.Add (',:PNO ');
              SQL.Add (',:PBUI_ID ');
              SQL.Add (',:PHOUKOU_ID ');
              SQL.Add (',:PSAYUU_ID ');
              SQL.Add (',:PKENSAHOUHOU_ID ');
              SQL.Add (',:PSATUEISTATUS ');
              SQL.Add (',:PHIS_ORIGINAL_FLG ');
              SQL.Add (',:PPRESET_NAME ');
              SQL.Add (',:PBUICOMMENT ');
              //2003.12.15
              //SQL.Add (',:PBUICOMMENT_ID1 ');
              //SQL.Add (',:PBUICOMMENT_ID2 ');
              //SQL.Add (',:PBUICOMMENT_ID3 ');
              //SQL.Add (',:PBUICOMMENT_ID4 ');
              //SQL.Add (',:PBUICOMMENT_ID5 ');
              SQL.Add (') ');
              if not Prepared then Prepare;
              ParamByName('PRIS_ID').AsString           := arg_Ris_ID;
              ParamByName('PNO').AsString               := w_Query_Data.FieldByName('NO').AsString;
              ParamByName('PBUI_ID').AsString           := w_Query_Data.FieldByName('BUI_ID').AsString;
              ParamByName('PHOUKOU_ID').AsString        := w_Query_Data.FieldByName('HOUKOU_ID').AsString;
              ParamByName('PSAYUU_ID').AsString         := w_Query_Data.FieldByName('SAYUU_ID').AsString;
              ParamByName('PKENSAHOUHOU_ID').AsString   := w_Query_Data.FieldByName('KENSAHOUHOU_ID').AsString;
              ParamByName('PSATUEISTATUS').AsString     := GPCST_CODE_SATUEI_0;
              ParamByName('PHIS_ORIGINAL_FLG').AsString := '1';
              ParamByName('PPRESET_NAME').AsString      := '';
              ParamByName('PBUICOMMENT').AsString       := w_Query_Data.FieldByName('BUICOMMENT').AsString;
              //2003.12.15
              //ParamByName('PBUICOMMENT_ID1').AsString   := w_Query_Data.FieldByName('BUICOMMENT_ID1').AsString;
              //ParamByName('PBUICOMMENT_ID2').AsString   := w_Query_Data.FieldByName('BUICOMMENT_ID2').AsString;
              //ParamByName('PBUICOMMENT_ID3').AsString   := w_Query_Data.FieldByName('BUICOMMENT_ID3').AsString;
              //ParamByName('PBUICOMMENT_ID4').AsString   := w_Query_Data.FieldByName('BUICOMMENT_ID4').AsString;
              //ParamByName('PBUICOMMENT_ID5').AsString   := w_Query_Data.FieldByName('BUICOMMENT_ID5').AsString;
              ExecSQL;

              w_Query_Data.Next;
            end;
          2004.03.30}

          //実績フィルムテーブル
            Close;
            SQL.Clear;
            SQL.Add ('DELETE FROM EXFILMTABLE ');
            SQL.Add ('WHERE RIS_ID = :PRIS_ID');
            if not Prepared then Prepare;
            ParamByName('PRIS_ID').AsString := arg_Ris_ID;
            ExecSQL;

          //実績造影剤テーブル
            Close;
            SQL.Clear;
            SQL.Add ('DELETE FROM EXZOUEIZAITABLE ');
            SQL.Add ('WHERE RIS_ID = :PRIS_ID');
            if not Prepared then Prepare;
            ParamByName('PRIS_ID').AsString := arg_Ris_ID;
            ExecSQL;

          //実績手技テーブル
            Close;
            SQL.Clear;
            SQL.Add ('DELETE FROM EXINFUSETABLE ');
            SQL.Add ('WHERE RIS_ID = :PRIS_ID');
            if not Prepared then Prepare;
            ParamByName('PRIS_ID').AsString := arg_Ris_ID;
            ExecSQL;

          //実績撮影テーブル
            Close;
            SQL.Clear;
            SQL.Add ('DELETE FROM EXSATUEITABLE ');
            SQL.Add ('WHERE RIS_ID = :PRIS_ID');
            if not Prepared then Prepare;
            ParamByName('PRIS_ID').AsString := arg_Ris_ID;
            ExecSQL;
          end;

        end;

        try
          arg_DB.Commit; // 成功した場合，変更をコミットする
        except
          on E: Exception do begin
                arg_DB.Rollback; // コミットで失敗した場合，変更を取り消す
                arg_Error_Code := CST_ERRCODE_10; //登録失敗
                arg_Error_Message := #13#10
                                   + #13#10+'commit'
                                   + #13#10+E.Message;
                arg_Error_SQL := w_Query_Update.SQL.Text;
                Result := 2;
          end;
        end;
      except
        on E: Exception do begin
              arg_DB.Rollback; // コミットで失敗した場合，変更を取り消す
              arg_Error_Code := CST_ERRCODE_10; //登録失敗
              arg_Error_Message := #13#10
                                 + #13#10+E.Message;
              arg_Error_SQL := w_Query_Update.SQL.Text;
              Result := 2;
        end;
      end;

      //検査進捗"受済"→"未受"の時のみ、転送テーブルへ書き込む
      if arg_Kensastatus_Flg = GPCST_CODE_KENSIN_1 then begin
        {//2004.04.09
        //RISオーダで送信キュー作成設定が"なし"の場合はキューを作成しない。 2004.02.05
        if (w_OD_SYSTEMKBN = GPCST_CODE_SYSK_RIS) and
           (g_RIS_Order_Sousin_Flg = GPCST_RISORDERSOUSIN_FLG_0) then
        else begin
        }
        //2004.04.09
        //RISオーダで送信キュー作成設定が"なし"or"HISなしRepあり"の場合はキューを作成しない。
        if func_Check_CueAndDummy(w_OD_SYSTEMKBN,arg_Kanja_ID,1) then begin

          //電文連番:転送オーダテーブル(日付管理あり)
          w_New_Denbun_NO := '';
          w_New_Denbun_NO := func_Uketuke_Make_DenbunNO(arg_DB,
                                                        w_Query_Data,
                                                        FormatDateTime(CST_FORMATDATE_3, w_DateTime)
                                                       );

          if w_New_Denbun_NO = '' then begin
            if arg_Error_Code <> '' then begin
                arg_Error_Code := CST_ERRCODE_07; //電文連番取得エラー
                arg_Error_Message := #13#10
                                    +#13#10+'患者ＩＤ　：'+ arg_Kanja_ID
                                    +#13#10+'ＲＩＳＩＤ：'+ arg_Ris_ID
                                    ;
            end;
            arg_Error_Code := CST_ERRCODE_07; //電文連番取得エラー
            Result := 3;
          end else begin
            arg_DB.StartTransaction;
            try
              with w_Query_Update do begin
                Close;
                SQL.Clear;
                SQL.Add('INSERT INTO TENSOUORDERTABLE( ');
                SQL.Add('NO,');
                SQL.Add('UPDATEDATE,');
                SQL.Add('RIS_ID,');
                SQL.Add('INFKBN,');
                SQL.Add('SYORIKBN,');
                SQL.Add('JOUTAIKBN,');
                SQL.Add('SOUSIN_DATE,');
                SQL.Add('SOUSIN_FLG,');
                SQL.Add('SOUSIN_STATUS_NAME,');
                SQL.Add('KENSATYPE_NAME,');
                SQL.Add('KANJAID,');
                SQL.Add('ROMASIMEI,');
                SQL.Add('KENSA_DATE ');
                SQL.Add(') VALUES ( ');
                SQL.Add(':PNO,');
                SQL.Add(':PUPDATEDATE,');
                SQL.Add(':PRIS_ID,');
                SQL.Add(':PINFKBN,');
                SQL.Add(':PSYORIKBN,');
                SQL.Add(':PJOUTAIKBN,');
                SQL.Add(':PSOUSIN_DATE,');
                SQL.Add(':PSOUSIN_FLG,');
                SQL.Add(':PSOUSIN_STATUS_NAME,');
                SQL.Add(':PKENSATYPE_NAME,');
                SQL.Add(':PKANJAID,');
                SQL.Add(':PROMASIMEI,');
                SQL.Add(':PKENSA_DATE ');
                SQL.Add(') ');
                if not Prepared then Prepare;
                ParamByName('PNO').AsString           := w_New_Denbun_NO;
                ParamByName('PUPDATEDATE').AsDateTime := w_DateTime;
                ParamByName('PRIS_ID').AsString       := arg_Ris_ID;
                ParamByName('PINFKBN').AsString       := GPCST_INFKBN_FC;     //受付電文
                ParamByName('PSYORIKBN').AsString     := GPCST_SYORIKBN_03;   //削除
                ParamByName('PJOUTAIKBN').AsString    := '00'; //状態なし
                ParamByName('PSOUSIN_DATE').AsString  := '';
                ParamByName('PSOUSIN_FLG').AsString   := '0';  //未送信
                ParamByName('PSOUSIN_STATUS_NAME').AsString := '';
                ParamByName('PKENSATYPE_NAME').AsString     := w_EX_KENSATYPE_NAME;
                ParamByName('PKANJAID').AsString      := arg_Kanja_ID;
                ParamByName('PROMASIMEI').AsString    := w_KJ_ROMASIMEI;
                ParamByName('PKENSA_DATE').AsString   := w_EX_KENSA_DATE; //func_Date10To8(FormatDateTime(CST_FORMATDATE_1 ,w_DateTime));
                ExecSQL;
              end;

              try
                arg_DB.Commit; // 成功した場合，変更をコミットする
              except
                on E: Exception do begin
                    arg_DB.Rollback; // コミットで失敗した場合，変更を取り消す
                    arg_Error_Code := CST_ERRCODE_10; //登録失敗
                    arg_Error_Message := #13#10
                                       + #13#10+'commit'
                                       + #13#10+E.Message;
                      arg_Error_SQL := w_Query_Update.SQL.Text;
                  Result := 3;
                end;
              end;
            except
              on E: Exception do begin
                  arg_DB.Rollback; // コミットで失敗した場合，変更を取り消す
                  arg_Error_Code := CST_ERRCODE_10; //登録失敗
                  arg_Error_Message := #13#10
                                     + #13#10+E.Message;
                  arg_Error_SQL := w_Query_Update.SQL.Text;
                  Result := 3;
              end;
            end;
          end;
        end; //2004.02.05
      {2003.12.18
        //電文連番:PACS-RIS転送オーダテーブル(日付管理あり)
        w_New_PacsDenbun_NO := '';
        w_New_PacsDenbun_NO := func_Uketuke_Make_PacsDenbunNO(arg_DB,
                                                          w_Query_Data,
                                                          FormatDateTime(CST_FORMATDATE_3, w_DateTime)
                                                         );
        if w_New_PacsDenbun_NO = '' then begin
          if arg_Error_Code <> '' then begin
              arg_Error_Code := CST_ERRCODE_13; //電文連番取得エラー
              arg_Error_Message := #13#10
                                  +#13#10+'PACS-RIS転送テーブルの電文連番取得に失敗しました。'
                                  +#13#10+'患者ＩＤ　：'+ arg_Kanja_ID
                                  +#13#10+'ＲＩＳＩＤ：'+ arg_Ris_ID
                                  ;
          end;
          Result := 3;
        end else begin
          arg_DB.StartTransaction;
          try
            //PACS-RIS転送オーダテーブルにも書き込む
            with w_Query_Update do begin
              Close;
              SQL.Clear;
              SQL.Add('INSERT INTO TENSOUPACSTABLE( ');
              SQL.Add('NO,');
              SQL.Add('UPDATEDATE,');
              SQL.Add('RIS_ID,');
              SQL.Add('INFKBN,');
              SQL.Add('SYORIKBN,');
              SQL.Add('JOUTAIKBN,');
              SQL.Add('SOUSIN_DATE,');
              SQL.Add('SOUSIN_FLG,');
              SQL.Add('SOUSIN_STATUS_NAME,');
              SQL.Add('KENSATYPE_NAME,');
              SQL.Add('KANJAID,');
              SQL.Add('ROMASIMEI,');
              SQL.Add('KENSA_DATE ');
              SQL.Add(') VALUES ( ');
              SQL.Add(':PNO,');
              SQL.Add(':PUPDATEDATE,');
              SQL.Add(':PRIS_ID,');
              SQL.Add(':PINFKBN,');
              SQL.Add(':PSYORIKBN,');
              SQL.Add(':PJOUTAIKBN,');
              SQL.Add(':PSOUSIN_DATE,');
              SQL.Add(':PSOUSIN_FLG,');
              SQL.Add(':PSOUSIN_STATUS_NAME,');
              SQL.Add(':PKENSATYPE_NAME,');
              SQL.Add(':PKANJAID,');
              SQL.Add(':PROMASIMEI,');
              SQL.Add(':PKENSA_DATE ');
              SQL.Add(') ');
              if not Prepared then Prepare;
              ParamByName('PNO').AsString           := w_New_PacsDenbun_NO;
              ParamByName('PUPDATEDATE').AsDateTime := w_DateTime;
              ParamByName('PRIS_ID').AsString       := w_OD_ORDERNO;
              ParamByName('PINFKBN').AsString       := GPCST_INFKBN_FC;     //受付電文
              ParamByName('PSYORIKBN').AsString     := GPCST_SYORIKBN_03;   //削除
              ParamByName('PJOUTAIKBN').AsString    := '00'; //状態なし
              ParamByName('PSOUSIN_DATE').AsString  := '';
              ParamByName('PSOUSIN_FLG').AsString   := '0';  //未送信
              ParamByName('PSOUSIN_STATUS_NAME').AsString := '';
              ParamByName('PKENSATYPE_NAME').AsString     := w_EX_KENSATYPE_NAME;
              ParamByName('PKANJAID').AsString      := arg_Kanja_ID;
              ParamByName('PROMASIMEI').AsString    := w_KJ_ROMASIMEI;
              ParamByName('PKENSA_DATE').AsString   := w_EX_KENSA_DATE; //func_Date10To8(FormatDateTime(CST_FORMATDATE_1 ,w_DateTime));
              ExecSQL;
            end;
            try
              arg_DB.Commit; // 成功した場合，変更をコミットする
            except
              on E: Exception do begin
                  arg_DB.Rollback; // コミットで失敗した場合，変更を取り消す
                  arg_Error_Code := CST_ERRCODE_10; //登録失敗
                  arg_Error_Message := #13#10
                                     + #13#10+'commit'
                                     + #13#10+E.Message;
                  arg_Error_SQL := w_Query_Update.SQL.Text;
                  Result := 3;

                  Exit;
              end;
            end;
          except
            on E: Exception do begin
                arg_DB.Rollback; // コミットで失敗した場合，変更を取り消す
                arg_Error_Code := CST_ERRCODE_10; //登録失敗
                arg_Error_Message := #13#10
                                   + #13#10+E.Message;
                arg_Error_SQL := w_Query_Update.SQL.Text;

                Result := 3;
                Exit;
            end;
          end;
        end;
      2003.12.18}

        //2004.04.09
        //送信キュー作成設定が"あり"or"HISなしRepあり"の場合はキューを作成する。
        if func_Check_CueAndDummy(w_OD_SYSTEMKBN,arg_Kanja_ID,0) then begin

          //電文連番:REPORT-RIS転送オーダテーブル(日付管理あり)
          w_New_ReportDenbun_NO := '';
          w_New_ReportDenbun_NO := func_Uketuke_Make_ReportDenbunNO(arg_DB,
                                                            w_Query_Data,
                                                            FormatDateTime(CST_FORMATDATE_3, w_DateTime)
                                                           );
          if w_New_ReportDenbun_NO = '' then begin
            if arg_Error_Code <> '' then begin
              arg_Error_Code := CST_ERRCODE_14; //電文連番取得エラー
              arg_Error_Message := #13#10
                                  +#13#10+'REPORT-RIS転送テーブルの電文連番取得に失敗しました。'
                                  +#13#10 + '患者ＩＤ　：' + arg_Kanja_ID
                                  +#13#10 + 'ＲＩＳＩＤ：' + arg_Ris_ID
                                  ;
            end;
            Result := 3;
          end else begin

            arg_DB.StartTransaction;
            try
              //HISオーダの場合、REPORT-RIS転送オーダテーブルにも書き込む
              with w_Query_Update do begin
                Close;
                SQL.Clear;
                SQL.Add('INSERT INTO TENSOUREPORTTABLE( ');
                SQL.Add('NO,');
                SQL.Add('UPDATEDATE,');
                SQL.Add('RIS_ID,');
                SQL.Add('INFKBN,');
                SQL.Add('SYORIKBN,');
                SQL.Add('JOUTAIKBN,');
                SQL.Add('SOUSIN_DATE,');
                SQL.Add('SOUSIN_FLG,');
                SQL.Add('SOUSIN_STATUS_NAME,');
                SQL.Add('KENSATYPE_NAME,');
                SQL.Add('KANJAID,');
                SQL.Add('ROMASIMEI,');
                SQL.Add('KENSA_DATE ');
                SQL.Add(') VALUES ( ');
                SQL.Add(':PNO,');
                SQL.Add(':PUPDATEDATE,');
                SQL.Add(':PRIS_ID,');
                SQL.Add(':PINFKBN,');
                SQL.Add(':PSYORIKBN,');
                SQL.Add(':PJOUTAIKBN,');
                SQL.Add(':PSOUSIN_DATE,');
                SQL.Add(':PSOUSIN_FLG,');
                SQL.Add(':PSOUSIN_STATUS_NAME,');
                SQL.Add(':PKENSATYPE_NAME,');
                SQL.Add(':PKANJAID,');
                SQL.Add(':PROMASIMEI,');
                SQL.Add(':PKENSA_DATE ');
                SQL.Add(') ');
                if not Prepared then Prepare;
                ParamByName('PNO').AsString           := w_New_ReportDenbun_NO;
                ParamByName('PUPDATEDATE').AsDateTime := w_DateTime;
                ParamByName('PRIS_ID').AsString       := w_OD_ORDERNO;
                ParamByName('PINFKBN').AsString       := GPCST_INFKBN_FC;     //受付電文
                ParamByName('PSYORIKBN').AsString     := GPCST_SYORIKBN_03;   //削除
                ParamByName('PJOUTAIKBN').AsString    := '00';                //状態なし
                ParamByName('PSOUSIN_DATE').AsString  := '';
                ParamByName('PSOUSIN_FLG').AsString   := '0';                 //未送信
                ParamByName('PSOUSIN_STATUS_NAME').AsString := '';
                ParamByName('PKENSATYPE_NAME').AsString     := w_EX_KENSATYPE_NAME;
                ParamByName('PKANJAID').AsString      := arg_Kanja_ID;
                ParamByName('PROMASIMEI').AsString    := w_KJ_ROMASIMEI;
                ParamByName('PKENSA_DATE').AsString   := w_EX_KENSA_DATE; //func_Date10To8(FormatDateTime(CST_FORMATDATE_1 ,w_DateTime));
                ExecSQL;
              end;

              try
                arg_DB.Commit; // 成功した場合，変更をコミットする
              except
                on E: Exception do begin
                    arg_DB.Rollback; // コミットで失敗した場合，変更を取り消す
                    arg_Error_Code := CST_ERRCODE_10; //登録失敗
                    arg_Error_Message := #13#10
                                       + #13#10+'commit'
                                       + #13#10+E.Message;
                    arg_Error_SQL := w_Query_Update.SQL.Text;
                    Result := 3;
                end;
              end;
            except
              on E: Exception do begin
                  arg_DB.Rollback; // コミットで失敗した場合，変更を取り消す
                  arg_Error_Code := CST_ERRCODE_10; //登録失敗
                  arg_Error_Message := #13#10
                                     + #13#10+E.Message;
                  arg_Error_SQL := w_Query_Update.SQL.Text;
                  Result := 3;
              end;
            end;
          end;
        end; //2004.04.09
      end;

    finally
      //更新権利返還
      if not func_ReleasKAnri(arg_DB,            //接続されたDB
                              w_Tan_Name,        //PC名称
                              arg_PROG_ID,       //プログラムID
                              arg_Ris_ID,        //RIS識別ID
                              G_KANRI_TBL_WMODE  //返還権利種(G_KANRI_TBL_WMODE 更新権利)
                             ) then begin
        arg_Error_Haita := True;
      end;
    end;
  finally
    w_Query_Data.Free;
    w_Query_Update.Free;
  end;
end;

//******************************************************************************
//受付優先フラグの切り替え
//******************************************************************************
function func_Yuusen_Change(
         arg_DB:TDatabase;             //接続されたDB
         arg_PROG_ID:string;           //プログラムID
         arg_Ris_ID:string;            //RIS識別ID
         arg_YuusenFlg:string;         //変更優先フラグ（現在の値）
         arg_NewYuusenFlg:string;      //変更優先フラグ（変更すべき値）
         var arg_Error_Code:string;    //エラーコード
         var arg_Error_Message:string; //エラーメッセージ
         var arg_Error_SQL:string;      //エラーSQL文
         var arg_Error_Haita:Boolean   //排他削除エラー True:排他ﾃｰﾌﾞﾙ削除失敗、False:排他ﾃｰﾌﾞﾙ削除成功
         ):boolean;                    //結果True成功 False失敗

var
  w_Query_Data: TQuery;
  w_Query_Update: TQuery;
  
  w_DateTime: TDateTime;
  w_Date: string;
  w_Time: string;
  w_Tan_Name:string;
  w_YUUSEN, w_KENSASTATUS, w_KENSASUBSTATUS, w_KENSA_DATE, w_KENSATYPE_ID, w_KENSATYPE_NAME, w_KANJAID:string;
begin

  Result := True;
  arg_Error_Haita := False;

  //コンピュータ名取得
  w_Tan_Name := func_GetThisMachineName;

  try
    w_Query_Data := TQuery.Create(nil);
    w_Query_Data.DatabaseName := arg_DB.DatabaseName;
    w_Query_Update := TQuery.Create(nil);
    w_Query_Update.DatabaseName := arg_DB.DatabaseName;

    //現在日時取得
    w_DateTime := func_GetDBSysDate(w_Query_Data);
    //現在日付取得
    w_Date := FormatDateTime(CST_FORMATDATE_1, w_DateTime);
    //現在時刻取得
    w_Time := FormatDateTime(CST_FORMATDATE_4, w_DateTime);

    //更新権利取得
    if not func_GetWKAnri(arg_DB,            //接続されたDB
                          w_Tan_Name,        //PC名称
                          arg_PROG_ID,       //プログラムID
                          arg_Ris_ID         //RIS識別ID
                         ) then begin
      proc_Get_Lock_HaitaData(w_Query_Data,
                              arg_Ris_ID,
                              w_Tan_Name,
                              w_KANJAID,
                              w_KENSA_DATE,
                              w_KENSATYPE_NAME);
      arg_Error_Message := #13#10
                          +#13#10+'端末名　　：'+w_Tan_Name
                          +#13#10+'患者ＩＤ　：'+w_KANJAID
                          +#13#10+'実績検査日：'+w_KENSA_DATE
                          +#13#10+'検査種別　：'+w_KENSATYPE_NAME
                          +#13#10+'ＲＩＳＩＤ：'+arg_Ris_ID
                          ;
      arg_Error_Code := CST_ERRCODE_08; //更新権利取得エラー
      Result := False;
      Exit;
    end;

    try
      try
        //排他ロックを参照し存在する場合にメッセージを表示＆再表示
        with w_Query_Data do begin
          SQL.Clear;
          SQL.Add ('SELECT RIS_ID ');
          SQL.Add ('      ,KANJAID ');
          SQL.Add ('      ,YUUSEN_FLG ');
          SQL.Add ('      ,KENSASTATUS_FLG ');
          SQL.Add ('      ,KENSASUBSTATUS_FLG ');
          SQL.Add ('      ,KENSA_DATE ');
          SQL.Add ('      ,KENSATYPE_ID ');
          SQL.Add ('FROM EXMAINTABLE ');
          SQL.Add ('WHERE RIS_ID           = :PRIS_ID ');
          if not Prepared then Prepare;
          ParamByName('PRIS_ID').AsString:=arg_Ris_ID;
          Open;
          Last;
          First;
          if not(Eof) then begin
            w_KANJAID        := FieldByName('KANJAID').AsString;
            w_YUUSEN         := FieldByName('YUUSEN_FLG').AsString;
            w_KENSASTATUS    := FieldByName('KENSASTATUS_FLG').AsString;
            w_KENSASUBSTATUS := FieldByName('KENSASUBSTATUS_FLG').AsString;
            w_KENSA_DATE     := func_Date8To10(FieldByName('KENSA_DATE').AsString);
            w_KENSATYPE_ID   := FieldByName('KENSATYPE_ID').AsString;
          end else begin
            arg_Error_Code := CST_ERRCODE_01; //読込みエラー
            Result := False;
            Close;
            Exit;
          end;
          Close;
        end;

      except
        on E: Exception do begin
          arg_Error_Code := CST_ERRCODE_10; //登録失敗
          arg_Error_Message := #13#10
                             + #13#10+E.Message;
          arg_Error_SQL := w_Query_Data.SQL.Text;
          Result := False;
          Exit;
        end;
      end;

      if arg_YuusenFlg = w_YUUSEN then begin
        if arg_NewYuusenFlg = GPCST_YUUSEN_0 then begin
          if (w_YUUSEN = GPCST_YUUSEN_1)
          or (w_YUUSEN = GPCST_YUUSEN_2) then
          else begin
            Result := False;
          end;
        end
        else
        if arg_NewYuusenFlg = GPCST_YUUSEN_1 then begin
          if (w_YUUSEN = GPCST_YUUSEN_1) then
          begin
            Result := False;
          end;
        end
        else
        if arg_NewYuusenFlg = GPCST_YUUSEN_2 then begin
          if (w_YUUSEN = GPCST_YUUSEN_2) then
          begin
            Result := False;
          end;
        end
        else begin
          Result := False;
        end;
      end else begin
          Result := False;
      end;
      if not Result then begin
        arg_Error_Code := CST_ERRCODE_16; //優先フラグエラー
        Exit;
      end;

      try
        //トランザクションスタート
        arg_DB.StartTransaction;

        with w_Query_Update do begin
          Close;
          SQL.Clear;
          SQL.Add ('UPDATE EXMAINTABLE SET ');
          SQL.Add ('  YUUSEN_FLG = :PYUUSEN_FLG ');
          SQL.Add ('WHERE RIS_ID        = :PRIS_ID');
          if not Prepared then Prepare;
          //優先フラグの変更
          ParamByName('PYUUSEN_FLG').AsString := arg_NewYuusenFlg;
          //
          ParamByName('PRIS_ID').AsString := arg_Ris_ID;
          ExecSQL;
        end;

        arg_DB.Commit;

      except
        on E: Exception do begin
          arg_DB.Rollback;
          arg_Error_Code := CST_ERRCODE_10; //登録失敗
          arg_Error_Message := #13#10
                             + #13#10+E.Message;
          arg_Error_SQL := w_Query_Update.SQL.Text;
          Result := False;
          Exit;
        end;
      end;
    finally
      //更新権利返還
      if not func_ReleasKAnri(arg_DB,            //接続されたDB
                              w_Tan_Name,        //PC名称
                              arg_PROG_ID,       //プログラムID
                              arg_Ris_ID,        //RIS識別ID
                              G_KANRI_TBL_WMODE  //返還権利種(G_KANRI_TBL_WMODE 更新権利)
                              ) then
        arg_Error_Haita := True;
    end;
  finally
    if w_Query_Data <> nil then w_Query_Data.Free;
    if w_Query_Update <> nil then w_Query_Update.Free;
  end;
end;

//******************************************************************************
//遅刻の切り替え
//******************************************************************************
function func_Tikoku_Change(
         arg_DB:TDatabase;             //接続されたDB
         arg_PROG_ID:string;           //プログラムID
         arg_Ris_ID:string;            //RIS識別ID
         arg_Status:string;            //ステータス（未受/検中）
         arg_SubStatus:string;         //サブステータス（未受/呼出/再呼/保留/再受）
         arg_Mode:string;              //遅刻/解除モード（1:遅刻/0:解除）
         var arg_Error_Code:string;    //エラーコード
         var arg_Error_Message:string; //エラーメッセージ
         var arg_Error_SQL:string;     //エラーSQL文
         var arg_Error_Haita:Boolean   //排他削除エラー True:排他ﾃｰﾌﾞﾙ削除失敗、False:排他ﾃｰﾌﾞﾙ削除成功
         ):boolean;                    //結果True成功 False失敗

var
  w_Query_Data: TQuery;
  w_Query_Update: TQuery;
  
  w_DateTime: TDateTime;
  w_Date: string;
  w_Time: string;
  w_Tan_Name:string;
  w_KENSASTATUS, w_KENSASUBSTATUS, w_KENSA_DATE, w_KENSATYPE_ID, w_KENSATYPE_NAME, w_KANJAID:string;
  w_UpSubStatus:string;
begin

  Result := True;
  arg_Error_Haita := False;

  //コンピュータ名取得
  w_Tan_Name := func_GetThisMachineName;

  try
    w_Query_Data := TQuery.Create(nil);
    w_Query_Data.DatabaseName := arg_DB.DatabaseName;
    w_Query_Update := TQuery.Create(nil);
    w_Query_Update.DatabaseName := arg_DB.DatabaseName;

    //現在日時取得
    w_DateTime := func_GetDBSysDate(w_Query_Data);
    //現在日付取得
    w_Date := FormatDateTime(CST_FORMATDATE_1, w_DateTime);
    //現在時刻取得
    w_Time := FormatDateTime(CST_FORMATDATE_4, w_DateTime);

    //更新権利取得
    if not func_GetWKAnri(arg_DB,            //接続されたDB
                          w_Tan_Name,        //PC名称
                          arg_PROG_ID,       //プログラムID
                          arg_Ris_ID         //RIS識別ID
                         ) then begin
      proc_Get_Lock_HaitaData(w_Query_Data,
                              arg_Ris_ID,
                              w_Tan_Name,
                              w_KANJAID,
                              w_KENSA_DATE,
                              w_KENSATYPE_NAME);
      arg_Error_Message := #13#10
                          +#13#10+'端末名　　：'+w_Tan_Name
                          +#13#10+'患者ＩＤ　：'+w_KANJAID
                          +#13#10+'実績検査日：'+w_KENSA_DATE
                          +#13#10+'検査種別　：'+w_KENSATYPE_NAME
                          +#13#10+'ＲＩＳＩＤ：'+arg_Ris_ID
                          ;
      arg_Error_Code := CST_ERRCODE_08; //更新権利取得エラー
      Result := False;
      Exit;
    end;

    try
      try
        //排他ロックを参照し存在する場合にメッセージを表示＆再表示
        with w_Query_Data do begin
          SQL.Clear;
          SQL.Add ('SELECT RIS_ID ');
          SQL.Add ('      ,KANJAID ');
          SQL.Add ('      ,KENSASTATUS_FLG ');
          SQL.Add ('      ,KENSASUBSTATUS_FLG ');
          SQL.Add ('      ,KENSA_DATE ');
          SQL.Add ('      ,KENSATYPE_ID ');
          SQL.Add ('FROM EXMAINTABLE ');
          SQL.Add ('WHERE RIS_ID           = :PRIS_ID ');
          if not Prepared then Prepare;
          ParamByName('PRIS_ID').AsString:=arg_Ris_ID;
          Open;
          Last;
          First;
          if not(Eof) then begin
            w_KANJAID        := FieldByName('KANJAID').AsString;
            w_KENSASTATUS    := FieldByName('KENSASTATUS_FLG').AsString;
            w_KENSASUBSTATUS := FieldByName('KENSASUBSTATUS_FLG').AsString;
            w_KENSA_DATE     := func_Date8To10(FieldByName('KENSA_DATE').AsString);
            w_KENSATYPE_ID   := FieldByName('KENSATYPE_ID').AsString;
          end else begin
            arg_Error_Code := CST_ERRCODE_01; //読込みエラー
            Result := False;
            Close;
            Exit;
          end;
          Close;
        end;

      except
        on E: Exception do begin
          arg_Error_Code := CST_ERRCODE_10; //登録失敗
          arg_Error_Message := #13#10
                             + #13#10+E.Message;
          arg_Error_SQL := w_Query_Data.SQL.Text;
          Result := False;
          Exit;
        end;
      end;

      if (arg_Status = w_KENSASTATUS) and
         (arg_SubStatus = w_KENSASUBSTATUS) then begin
        //遅刻
        if arg_Mode = CST_TIKOKU_MODE_1 then begin
          if (w_KENSASTATUS = GPCST_CODE_KENSIN_0)
          and ((w_KENSASUBSTATUS = '')
          or (w_KENSASUBSTATUS = GPCST_CODE_KENSIN_SUB_5)) then begin
            //サブステータス遅刻セット
            w_UpSubStatus := GPCST_CODE_KENSIN_SUB_6;
          end
          else begin
            Result := False;
          end;
        end
        else
        //遅刻解除
        if arg_Mode = CST_TIKOKU_MODE_0 then begin
          if (w_KENSASTATUS = GPCST_CODE_KENSIN_0)
          and (w_KENSASUBSTATUS = GPCST_CODE_KENSIN_SUB_6) then begin
            //サブステータス未受Defaultセット
            w_UpSubStatus := '';
          end
          else begin
            Result := False;
          end;
        end
        else begin
          Result := False;
        end;
      end else begin
        Result := False;
      end;

      if not Result then begin
        arg_Error_Code := CST_ERRCODE_02; //検査進捗エラー
        Exit;
      end;

      try
        //トランザクションスタート
        arg_DB.StartTransaction;

        with w_Query_Update do begin
          Close;
          SQL.Clear;
        //ロック
          SQL.Add ('SELECT orma.RIS_ID ');
          SQL.Add ('FROM OrderMainTable orma ');
          SQL.Add ('WHERE orma.RIS_ID = :PRIS_ID ');
          SQL.Add (' for update ');
          if not Prepared then Prepare;
          ParamByName('PRIS_ID').AsString := arg_Ris_ID;
          ExecSQL;
          Close;
          SQL.Clear;
        //更新
          SQL.Add ('UPDATE EXMAINTABLE SET ');
          SQL.Add ('  KENSASUBSTATUS_FLG = :PKENSASUBSTATUS_FLG ');
          if arg_Mode = CST_TIKOKU_MODE_1 then begin
            SQL.Add (' ,CALL_TIKOKU_DATE = :PCALL_TIKOKU_DATE ');
          end;
          SQL.Add ('WHERE RIS_ID        = :PRIS_ID');
          if not Prepared then Prepare;
          //サブステータスの変更
          ParamByName('PKENSASUBSTATUS_FLG').AsString := w_UpSubStatus;

          if arg_Mode = CST_TIKOKU_MODE_1 then begin
            //遅刻日時の変更
            ParamByName('PCALL_TIKOKU_DATE').AsDateTime := w_DateTime;
          end;
          //
          ParamByName('PRIS_ID').AsString := arg_Ris_ID;
          ExecSQL;
        end;

        arg_DB.Commit;

      except
        on E: Exception do begin
          arg_DB.Rollback;
          arg_Error_Code := CST_ERRCODE_10; //登録失敗
          arg_Error_Message := #13#10
                             + #13#10+E.Message;
          arg_Error_SQL := w_Query_Update.SQL.Text;
          Result := False;
          Exit;
        end;
      end;
    finally
      //更新権利返還
      if not func_ReleasKAnri(arg_DB,            //接続されたDB
                              w_Tan_Name,        //PC名称
                              arg_PROG_ID,       //プログラムID
                              arg_Ris_ID,        //RIS識別ID
                              G_KANRI_TBL_WMODE  //返還権利種(G_KANRI_TBL_WMODE 更新権利)
                              ) then
        arg_Error_Haita := True;
    end;
  finally
    if w_Query_Data <> nil then w_Query_Data.Free;
    if w_Query_Update <> nil then w_Query_Update.Free;
  end;
end;

//******************************************************************************
//呼出、再呼の切り替え
//******************************************************************************
function func_Yobidasi_Change(
         arg_DB:TDatabase;             //接続されたDB
         arg_PROG_ID:string;           //プログラムID
         arg_Ris_ID:string;            //RIS識別ID
         arg_Status:string;            //ステータス（未受/検中）
         arg_SubStatus:string;         //サブステータス（未受/呼出/再呼/保留/再受）
         arg_Mode:string;              //呼出/解除モード（1:呼出、再呼/0:解除）
         var arg_Error_Code:string;    //エラーコード
         var arg_Error_Message:string; //エラーメッセージ
         var arg_Error_SQL:string;      //エラーSQL文
         var arg_Error_Haita:Boolean   //排他削除エラー True:排他ﾃｰﾌﾞﾙ削除失敗、False:排他ﾃｰﾌﾞﾙ削除成功
         ):boolean;                    //結果True成功 False失敗

var
  w_Query_Data: TQuery;
  w_Query_Update: TQuery;
  
  w_DateTime: TDateTime;
  w_Date: string;
  w_Time: string;
  w_Tan_Name:string;
  w_KENSASTATUS, w_KENSASUBSTATUS, w_KENSA_DATE, w_KENSATYPE_ID, w_KENSATYPE_NAME, w_KANJAID:string;
  w_UpSubStatus:string;
begin

  Result := True;
  arg_Error_Haita := False;

  //コンピュータ名取得
  w_Tan_Name := func_GetThisMachineName;

  try
    w_Query_Data := TQuery.Create(nil);
    w_Query_Data.DatabaseName := arg_DB.DatabaseName;
    w_Query_Update := TQuery.Create(nil);
    w_Query_Update.DatabaseName := arg_DB.DatabaseName;

    //現在日時取得
    w_DateTime := func_GetDBSysDate(w_Query_Data);
    //現在日付取得
    w_Date := FormatDateTime(CST_FORMATDATE_1, w_DateTime);
    //現在時刻取得
    w_Time := FormatDateTime(CST_FORMATDATE_4, w_DateTime);

    //更新権利取得
    if not func_GetWKAnri(arg_DB,            //接続されたDB
                          w_Tan_Name,        //PC名称
                          arg_PROG_ID,       //プログラムID
                          arg_Ris_ID         //RIS識別ID
                         ) then begin
      proc_Get_Lock_HaitaData(w_Query_Data,
                              arg_Ris_ID,
                              w_Tan_Name,
                              w_KANJAID,
                              w_KENSA_DATE,
                              w_KENSATYPE_NAME);
      arg_Error_Message := #13#10
                          +#13#10+'端末名　　：'+w_Tan_Name
                          +#13#10+'患者ＩＤ　：'+w_KANJAID
                          +#13#10+'実績検査日：'+w_KENSA_DATE
                          +#13#10+'検査種別　：'+w_KENSATYPE_NAME
                          +#13#10+'ＲＩＳＩＤ：'+arg_Ris_ID
                          ;
      arg_Error_Code := CST_ERRCODE_08; //更新権利取得エラー
      Result := False;
      Exit;
    end;

    try
      try
        //排他ロックを参照し存在する場合にメッセージを表示＆再表示
        with w_Query_Data do begin
          SQL.Clear;
          SQL.Add ('SELECT RIS_ID ');
          SQL.Add ('      ,KANJAID ');
          SQL.Add ('      ,KENSASTATUS_FLG ');
          SQL.Add ('      ,KENSASUBSTATUS_FLG ');
          SQL.Add ('      ,KENSA_DATE ');
          SQL.Add ('      ,KENSATYPE_ID ');
          SQL.Add ('FROM EXMAINTABLE ');
          SQL.Add ('WHERE RIS_ID           = :PRIS_ID ');
          if not Prepared then Prepare;
          ParamByName('PRIS_ID').AsString:=arg_Ris_ID;
          Open;
          Last;
          First;
          if not(Eof) then begin
            w_KANJAID        := FieldByName('KANJAID').AsString;
            w_KENSASTATUS    := FieldByName('KENSASTATUS_FLG').AsString;
            w_KENSASUBSTATUS := FieldByName('KENSASUBSTATUS_FLG').AsString;
            w_KENSA_DATE     := func_Date8To10(FieldByName('KENSA_DATE').AsString);
            w_KENSATYPE_ID   := FieldByName('KENSATYPE_ID').AsString;
          end else begin
            arg_Error_Code := CST_ERRCODE_01; //読込みエラー
            Result := False;
            Close;
            Exit;
          end;
          Close;
        end;

      except
        on E: Exception do begin
          arg_Error_Code := CST_ERRCODE_10; //登録失敗
          arg_Error_Message := #13#10
                             + #13#10+E.Message;
          arg_Error_SQL := w_Query_Data.SQL.Text;
          Result := False;
          Exit;
        end;
      end;

      if (arg_Status = w_KENSASTATUS) and
         (arg_SubStatus = w_KENSASUBSTATUS) then begin
        //未受
        if arg_Status = GPCST_CODE_KENSIN_0 then begin
          //呼出
          if arg_Mode = CST_YOBI_MODE_1 then begin
            if (w_KENSASTATUS = GPCST_CODE_KENSIN_0)
            and ((w_KENSASUBSTATUS = '')
             or (w_KENSASUBSTATUS = GPCST_CODE_KENSIN_SUB_6)) then begin
              //サブステータス呼出セット
              w_UpSubStatus := GPCST_CODE_KENSIN_SUB_5;
            end
            else begin
              Result := False;
            end;
          end
          else
          //呼出解除
          if arg_Mode = CST_YOBI_MODE_0 then begin
            if (w_KENSASTATUS = GPCST_CODE_KENSIN_0)
            and (w_KENSASUBSTATUS = GPCST_CODE_KENSIN_SUB_5) then begin
              //サブステータス未受Defaultセット
              w_UpSubStatus := '';
            end
            else begin
              Result := False;
            end;
          end
          else begin
            Result := False;
          end;
        end
        else
        //検中
        if arg_Status = GPCST_CODE_KENSIN_2 then begin
          //呼出
          if arg_Mode = CST_YOBI_MODE_1 then begin
{2003.03.03
            if (w_KENSASTATUS = GPCST_CODE_KENSIN_2)
            and ((w_KENSASUBSTATUS = '')
            or (w_KENSASUBSTATUS = GPCST_CODE_KENSIN_SUB_8)
            or (w_KENSASUBSTATUS = GPCST_CODE_KENSIN_SUB_10)) then begin
2003.03.03}
            if ((w_KENSASUBSTATUS = GPCST_CODE_KENSIN_SUB_8) or
                (w_KENSASUBSTATUS = GPCST_CODE_KENSIN_SUB_10)) then begin
              //サブステータス再呼セット
              w_UpSubStatus := GPCST_CODE_KENSIN_SUB_9;
            end
            else begin
              Result := False;
            end;
          end
          else
          //呼出解除
          if arg_Mode = CST_YOBI_MODE_0 then begin
            if (w_KENSASTATUS = GPCST_CODE_KENSIN_2)
            and (w_KENSASUBSTATUS = GPCST_CODE_KENSIN_SUB_9) then begin
              //サブステータス保留セット
              w_UpSubStatus := GPCST_CODE_KENSIN_SUB_8;
  //            //サブステータス検中Defaultセット
  //            w_UpSubStatus := '';
            end
            else begin
              Result := False;
            end;
          end
          else begin
            Result := False;
          end;
        end
        else begin
          Result := False;
        end;
      end else begin
        Result := False;
      end;

      if not Result then begin
        arg_Error_Code := CST_ERRCODE_02; //検査進捗エラー
        Exit;
      end;

      //トランザクションスタート
      arg_DB.StartTransaction;
      try

        with w_Query_Update do begin
          Close;
          SQL.Clear;
        //ロック
          SQL.Add ('SELECT orma.RIS_ID ');
          SQL.Add ('FROM OrderMainTable orma ');
          SQL.Add ('WHERE orma.RIS_ID = :PRIS_ID ');
          SQL.Add (' for update ');
          if not Prepared then Prepare;
          ParamByName('PRIS_ID').AsString := arg_Ris_ID;
          ExecSQL;
          Close;
          SQL.Clear;
        //更新
          SQL.Add ('UPDATE EXMAINTABLE SET ');
          SQL.Add ('  KENSASUBSTATUS_FLG = :PKENSASUBSTATUS_FLG ');
          if arg_Mode = CST_YOBI_MODE_1 then begin
            SQL.Add (' ,CALL_TIKOKU_DATE = :PCALL_TIKOKU_DATE ');
          end;
          SQL.Add ('WHERE RIS_ID        = :PRIS_ID');
          if not Prepared then Prepare;
          //サブステータスの変更
          ParamByName('PKENSASUBSTATUS_FLG').AsString := w_UpSubStatus;

          if arg_Mode = CST_YOBI_MODE_1 then begin
            //呼出日時の変更
            ParamByName('PCALL_TIKOKU_DATE').AsDateTime := w_DateTime;
          end;
          //
          ParamByName('PRIS_ID').AsString := arg_Ris_ID;
          ExecSQL;
        end;

        arg_DB.Commit;

      except
        on E: Exception do begin
          arg_DB.Rollback;
          arg_Error_Code := CST_ERRCODE_10; //登録失敗
          arg_Error_Message := #13#10
                             + #13#10+E.Message;
          arg_Error_SQL := w_Query_Update.SQL.Text;
          Result := False;
          Exit;
        end;
      end;
    finally
      //更新権利返還
      if not func_ReleasKAnri(arg_DB,            //接続されたDB
                              w_Tan_Name,        //PC名称
                              arg_PROG_ID,       //プログラムID
                              arg_Ris_ID,        //RIS識別ID
                              G_KANRI_TBL_WMODE  //返還権利種(G_KANRI_TBL_WMODE 更新権利)
                              ) then
        arg_Error_Haita := True;
    end;
  finally
    if w_Query_Data <> nil then w_Query_Data.Free;
    if w_Query_Update <> nil then w_Query_Update.Free;
  end;
end;

//******************************************************************************
//確保の切り替え
//******************************************************************************
function func_Kakuho_Change(
         arg_DB:TDatabase;             //接続されたDB
         arg_PROG_ID:string;           //プログラムID
         arg_Ris_ID:string;            //RIS識別ID
         arg_Status:string;            //ステータス（受済）
         arg_Mode:string;              //呼出/解除モード（1:確保/0:解除）
         var arg_Error_Code:string;    //エラーコード
         var arg_Error_Message:string; //エラーメッセージ
         var arg_Error_SQL:string;     //エラーSQL文
         var arg_Error_Haita:Boolean   //排他削除エラー True:排他ﾃｰﾌﾞﾙ削除失敗、False:排他ﾃｰﾌﾞﾙ削除成功
         ):boolean;                    //結果True成功 False失敗

var
  w_Query_Data: TQuery;
  w_Query_Update: TQuery;

  w_DateTime: TDateTime;
  w_Date: string;
  w_Time: string;
  w_Tan_Name:string;
  w_KENSASTATUS, w_KENSASUBSTATUS, w_KENSA_DATE, w_KENSATYPE_ID, w_KENSATYPE_NAME, w_KANJAID:string;
  w_UpSubStatus:string;
begin

  Result := True;
  arg_Error_Haita := False;

  //コンピュータ名取得
  w_Tan_Name := func_GetThisMachineName;

  try
    w_Query_Data := TQuery.Create(nil);
    w_Query_Data.DatabaseName := arg_DB.DatabaseName;
    w_Query_Update := TQuery.Create(nil);
    w_Query_Update.DatabaseName := arg_DB.DatabaseName;

    //現在日時取得
    w_DateTime := func_GetDBSysDate(w_Query_Data);
    //現在日付取得
    w_Date := FormatDateTime(CST_FORMATDATE_1, w_DateTime);
    //現在時刻取得
    w_Time := FormatDateTime(CST_FORMATDATE_4, w_DateTime);

    //更新権利取得
    if not func_GetWKAnri(arg_DB,            //接続されたDB
                          w_Tan_Name,        //PC名称
                          arg_PROG_ID,       //プログラムID
                          arg_Ris_ID         //RIS識別ID
                         ) then begin
      proc_Get_Lock_HaitaData(w_Query_Data,
                              arg_Ris_ID,
                              w_Tan_Name,
                              w_KANJAID,
                              w_KENSA_DATE,
                              w_KENSATYPE_NAME);
      arg_Error_Message := #13#10
                          +#13#10+'端末名　　：'+w_Tan_Name
                          +#13#10+'患者ＩＤ　：'+w_KANJAID
                          +#13#10+'実績検査日：'+w_KENSA_DATE
                          +#13#10+'検査種別　：'+w_KENSATYPE_NAME
                          +#13#10+'ＲＩＳＩＤ：'+arg_Ris_ID
                          ;
      arg_Error_Code := CST_ERRCODE_08; //更新権利取得エラー
      Result := False;
      Exit;
    end;

    try
      try
        //排他ロックを参照し存在する場合にメッセージを表示＆再表示
        with w_Query_Data do begin
          SQL.Clear;
          SQL.Add ('SELECT RIS_ID ');
          SQL.Add ('      ,KANJAID ');
          SQL.Add ('      ,KENSASTATUS_FLG ');
          SQL.Add ('      ,KENSASUBSTATUS_FLG ');
          SQL.Add ('      ,KENSA_DATE ');
          SQL.Add ('      ,KENSATYPE_ID ');
          SQL.Add ('FROM EXMAINTABLE ');
          SQL.Add ('WHERE RIS_ID           = :PRIS_ID ');
          if not Prepared then Prepare;
          ParamByName('PRIS_ID').AsString:=arg_Ris_ID;
          Open;
          Last;
          First;
          if not(Eof) then begin
            w_KANJAID        := FieldByName('KANJAID').AsString;
            w_KENSASTATUS    := FieldByName('KENSASTATUS_FLG').AsString;
            w_KENSASUBSTATUS := FieldByName('KENSASUBSTATUS_FLG').AsString;
            w_KENSA_DATE     := func_Date8To10(FieldByName('KENSA_DATE').AsString);
            w_KENSATYPE_ID   := FieldByName('KENSATYPE_ID').AsString;
          end else begin
            arg_Error_Code := CST_ERRCODE_01; //読込みエラー
            Result := False;
            Close;
            Exit;
          end;
          Close;
        end;

      except
        on E: Exception do begin
          arg_Error_Code := CST_ERRCODE_10; //登録失敗
          arg_Error_Message := #13#10
                             + #13#10+E.Message;
          arg_Error_SQL := w_Query_Data.SQL.Text;
          Result := False;
          Exit;
        end;
      end;

      //受付済
      if arg_Status = GPCST_CODE_KENSIN_1 then begin
        //確保
        if arg_Mode = CST_KAKUHO_MODE_1 then begin
          //受付済
          if (w_KENSASTATUS = GPCST_CODE_KENSIN_1) and
             (w_KENSASUBSTATUS = '') then begin
            //サブステータス呼出セット
            w_UpSubStatus := GPCST_CODE_KENSIN_SUB_7;
          end
          else begin
            Result := False;
          end;
        end
        else
        //確保解除
        if arg_Mode = CST_KAKUHO_MODE_0 then begin
          if (w_KENSASTATUS = GPCST_CODE_KENSIN_1) and
             (w_KENSASUBSTATUS = GPCST_CODE_KENSIN_SUB_7) then begin
            //サブステータス未受Defaultセット
            w_UpSubStatus := '';
          end
          else begin
            Result := False;
          end;
        end
        else begin
          Result := False;
        end;
      end
      else begin
        Result := False;
      end;

      if not Result then begin
        arg_Error_Code := CST_ERRCODE_02; //検査進捗エラー
        Exit;
      end;

      //トランザクションスタート
      arg_DB.StartTransaction;
      try

        with w_Query_Update do begin
          Close;
          SQL.Clear;
        //ロック
          SQL.Add ('SELECT orma.RIS_ID ');
          SQL.Add ('FROM OrderMainTable orma ');
          SQL.Add ('WHERE orma.RIS_ID = :PRIS_ID ');
          SQL.Add (' for update ');
          if not Prepared then Prepare;
          ParamByName('PRIS_ID').AsString := arg_Ris_ID;
          ExecSQL;
          Close;
          SQL.Clear;
        //更新
          SQL.Add ('UPDATE EXMAINTABLE SET ');
          SQL.Add ('  KENSASUBSTATUS_FLG = :PKENSASUBSTATUS_FLG ');
//          if arg_Mode = CST_KAKUHO_MODE_1 then begin
//            SQL.Add (' ,CALL_TIKOKU_DATE = :PCALL_TIKOKU_DATE ');
//          end;
          SQL.Add ('WHERE RIS_ID        = :PRIS_ID');
          if not Prepared then Prepare;
          //サブステータスの変更
          ParamByName('PKENSASUBSTATUS_FLG').AsString := w_UpSubStatus;

//          if arg_Mode = CST_KAKUHO_MODE_1 then begin
//            //呼出日時の変更
//            ParamByName('PCALL_TIKOKU_DATE').AsDateTime := w_DateTime;
//          end;
          //
          ParamByName('PRIS_ID').AsString := arg_Ris_ID;
          ExecSQL;
        end;

        arg_DB.Commit;

      except
        on E: Exception do begin
          arg_DB.Rollback;
          arg_Error_Code := CST_ERRCODE_10; //登録失敗
          arg_Error_Message := #13#10
                             + #13#10+E.Message;
          arg_Error_SQL := w_Query_Update.SQL.Text;
          Result := False;
          Exit;
        end;
      end;
    finally
      //更新権利返還
      if not func_ReleasKAnri(arg_DB,            //接続されたDB
                              w_Tan_Name,        //PC名称
                              arg_PROG_ID,       //プログラムID
                              arg_Ris_ID,        //RIS識別ID
                              G_KANRI_TBL_WMODE  //返還権利種(G_KANRI_TBL_WMODE 更新権利)
                              ) then
        arg_Error_Haita := True;
    end;
  finally
    if w_Query_Data <> nil then w_Query_Data.Free;
    if w_Query_Update <> nil then w_Query_Update.Free;
  end;
end;

//******************************************************************************
// 使用中の他端末を調べる
//******************************************************************************
procedure proc_Get_Lock_HaitaData(arg_Query:TQuery;
                                  arg_Ris_ID:String;
                                  var arg_Tan:String;
                                  var arg_Kanja:String;
                                  var arg_KensaDate:string;
                                  var arg_Kensa_Name:String);
begin
  //排他情報取得
  with arg_Query do begin
    //閉じる
    Close;
    //前回SQL文のクリア
    SQL.Clear;
    //SQL文作成
    SQL.Add('SELECT kan.TAN_NAME, kan.PROG_ID, kan.RIS_ID, kan.SYORI_MODE, exma.KENSA_DATE, exma.KANJAID, mas.KENSATYPE_NAME ');
    SQL.Add('FROM KANRITABLE kan, EXMAINTABLE exma, KENSATYPEMASTER mas');
    SQL.Add('WHERE exma.KENSATYPE_ID = mas.KENSATYPE_ID(+)');
    SQL.Add('  AND kan.RIS_ID = exma.RIS_ID');
    SQL.Add('  AND kan.RIS_ID = '''+ arg_Ris_ID + '''');
    SQL.Add('  AND kan.SYORI_MODE = '+ G_KANRI_TBL_WMODE + '');
    //問合せ確認
    if not Prepared then
      //問合せ処理
      Prepare;
    //開く
    Open;
    //最後のレコードに移動
    Last;
    //最初のレコードに移動
    First;
    //端末名称
    arg_Kanja      := FieldByName('KANJAID').AsString;
    arg_Kensa_Name := FieldByName('KENSATYPE_NAME').AsString;
    arg_KensaDate  := func_Date8To10(FieldByName('KENSA_DATE').AsString);
    arg_Tan        := FieldByName('TAN_NAME').AsString;
    //閉じる
    Close;
  end;
end;
//******************************************************************************
//更新権利の取得と最新進捗の比較
//******************************************************************************
function proc_Kousin_Sintyoku(
                               arg_DB:TDatabase;             //接続されたDB
                               arg_PROG_ID:string;           //プログラムID
                               arg_Ris_ID:TStrings;
                               arg_Kanja_ID:TStrings;
                               arg_RomaSimei:TStrings;
                               arg_main:TStrings;
                               arg_Sub:TStrings;
                               var arg_Error_Code:string;    //エラーコード
                               var arg_Error_Message:string; //エラーメッセージ
                               var arg_Error_SQL:string     //エラーSQL文
                               ):Integer;                    //結果0:成功、1:排他/進捗ｴﾗｰ、2：他端末で更新中

var
  w_i:integer;
  w_Tan_Name: string;
  w_Query_Data: TQuery;
  w_Query_Update: TQuery;
  w_Now_KENSA_DATE: string;
  w_EX_KENSATYPE_NAME: string;
  w_EX_KENSATYPE_ID: string;
  wt_Flg_Kensa:TStrings;
  wt_RomaSimei:TStrings;
  w_Status :TStrings;
  w_Sintyoku :String;
  w_Kanja:string;
  w_Err_Flg:string;
  w_Data:string;
  w_Syutoku_Err:integer;
begin
  w_Query_Data := TQuery.Create(nil);
  w_Query_Data.DatabaseName := arg_DB.DatabaseName;
  w_Query_Update := TQuery.Create(nil);
  w_Query_Update.DatabaseName := arg_DB.DatabaseName;

  wt_Flg_Kensa := TStringList.Create;
  wt_RomaSimei := TStringList.Create;
  w_Status     := TStringList.Create;
  w_Err_Flg :='';
  Result :=0;
  w_Syutoku_Err :=0;

  //コンピュータ名取得
  w_Tan_Name := func_GetThisMachineName;
  try
    //トランザクション獲得
    arg_DB.StartTransaction;
    //ROOP
    for w_i := 0 to arg_Ris_ID.Count -1 do begin
      //更新権利取得
      if not func_GetWKAnriUketuke(arg_DB,     //接続されたDB
                            w_Tan_Name,        //PC名称
                            arg_PROG_ID,       //プログラムID
                            arg_Ris_ID[w_i]    //RIS識別ID
                           ) then begin
         proc_Get_Lock_HaitaData(w_Query_Data,
                                 arg_Ris_ID[w_i],
                                 w_Tan_Name,
                                 w_Kanja,
                                 w_Now_KENSA_DATE,
                                 w_EX_KENSATYPE_NAME);
         arg_Error_Message := #13#10
                            +#13#10+'端末名　　：'+w_Tan_Name
                            +#13#10+'患者ＩＤ　：'+w_Kanja
                            +#13#10+'実績検査日：'+w_Now_KENSA_DATE
                            +#13#10+'検査種別　：'+w_EX_KENSATYPE_ID
                            +#13#10+'ＲＩＳＩＤ：'+arg_Ris_ID[w_i]
                            ;
        w_Err_Flg :='1';
        w_Syutoku_Err := w_i -1;
        arg_Error_Code := CST_ERRCODE_08; //更新権利取得エラー
        Result := 2;
        Break;
      end;
      //オーダメイン、実績メイン、患者マスタより最新情報の取得
      with w_Query_Data do begin
        Close;
        SQL.Clear;
        SQL.Add ('SELECT exma.*,km.ROMASIMEI ');
        SQL.Add ('FROM   EXMAINTABLE exma ');
        SQL.Add ('　　   ,KanjaMaster km');
        SQL.Add ('WHERE  exma.KANJAID =km.KANJAID(+) ');
        SQL.Add ('  AND  exma.RIS_ID  = :PRIS_ID ');
        SQL.Add ('  AND  exma.KANJAID = :PKANJAID ');
        if not Prepared then Prepare;
        ParamByName('PRIS_ID').AsString  := arg_Ris_ID[w_i];
        ParamByName('PKANJAID').AsString := arg_Kanja_ID[w_i];
        Open;
        Last;
        First;
        if not(w_Query_Data.Eof) and
          (RecordCount > 0) then begin

          if (FieldByName('KENSASTATUS_FLG').AsString <> arg_main[w_i]) or
          (FieldByName('KENSASUBSTATUS_FLG').AsString <> arg_Sub[w_i]) then begin
            w_Err_Flg :='2';
            w_Sintyoku :=func_PIND_Change_KENSIN(FieldByName('KENSASTATUS_FLG').AsString,
                                    FieldByName('KENSASUBSTATUS_FLG').AsString
                                    );

            w_Status.Add(w_Sintyoku);
            w_Data := w_Data+#13#10+FieldByName('KANJAID').AsString+'/'+FieldByName('ROMASIMEI').AsString+':'+w_Sintyoku;
          end
          else begin
            //最新の検査進捗ﾁｪｯｸ
            if ((FieldByName('KENSASTATUS_FLG').AsString <> GPCST_CODE_KENSIN_0) and
              (FieldByName('KENSASTATUS_FLG').AsString <>  GPCST_CODE_KENSIN_2)) or
              ((FieldByName('KENSASTATUS_FLG').AsString = GPCST_CODE_KENSIN_2) and
              ((FieldByName('KENSASUBSTATUS_FLG').AsString <> GPCST_CODE_KENSIN_SUB_8) and
              (FieldByName('KENSASUBSTATUS_FLG').AsString <> GPCST_CODE_KENSIN_SUB_9))) then begin
              //受付登録不可
              w_Err_Flg :='2';
              w_Sintyoku :=func_PIND_Change_KENSIN(FieldByName('KENSASTATUS_FLG').AsString,
                                      FieldByName('KENSASUBSTATUS_FLG').AsString
                                      );

              w_Status.Add(w_Sintyoku);
              w_Data := w_Data+#13#10+FieldByName('KANJAID').AsString+'/'+FieldByName('ROMASIMEI').AsString+':'+w_Sintyoku;
            end;
          end;

          w_Now_KENSA_DATE      := func_Date8To10(FieldByName('KENSA_DATE').AsString);

          w_EX_KENSATYPE_ID     := FieldByName('KENSATYPE_ID').AsString;
        end
        else begin
          w_Err_Flg :='2';
          w_Sintyoku :='オーダキャンセル';
          w_Status.Add(w_Sintyoku);
          w_Data := w_Data+#13#10+arg_Kanja_ID[w_i]+'/'+arg_RomaSimei[w_i]+':'+w_Sintyoku;

        end;
        Close;
      end;
    end;  //Roop End
    //エラーチェック
    if w_Err_Flg ='2' then begin
      arg_Error_Message := w_Data;
      arg_Error_Code := CST_ERRCODE_17;
      Result :=1;
    end;
    //エラーが存在した時は、排他管理Rollback
    //エラーが存在しなかった時は、排他管理Commit
    if Result = 1 then begin
      arg_DB.Rollback;
      w_Query_Data.Close;
      Result := 1;

      w_Query_Data.Free;
      w_Query_Update.Free;

      wt_Flg_Kensa.Free;
      wt_RomaSimei.Free;

      Exit;
    end;
    //
    if Result = 2 then begin
      arg_DB.Rollback;
      w_Query_Data.Close;


      w_Query_Data.Free;
      w_Query_Update.Free;

      wt_Flg_Kensa.Free;
      wt_RomaSimei.Free;
      //更新権利の返還
      for w_i :=0 to w_Syutoku_Err do begin
         func_ReleasKAnri(arg_DB,            //接続されたDB
                          w_Tan_Name,        //PC名称
                          arg_PROG_ID,       //プログラムID
                          arg_Ris_ID[w_i],   //RIS識別ID
                          G_KANRI_TBL_WMODE  //返還権利種(G_KANRI_TBL_WMODE 更新権利)
                          )
      end;
      Exit;
    end;
    if Result = 0 then begin
      arg_DB.Commit;
    end;
  Except
    on E: Exception do begin
      arg_DB.Rollback; // コミットで失敗した場合，変更を取り消す
      arg_Error_Code := CST_ERRCODE_10; //登録失敗
      arg_Error_Message := #13#10
                         + #13#10+'commit'
                         + #13#10+E.Message;
      arg_Error_SQL := w_Query_Data.SQL.Text;
      w_Query_Data.Close;
      Result := 1;

      w_Query_Data.Free;
      w_Query_Update.Free;

      wt_Flg_Kensa.Free;
      wt_RomaSimei.Free;

      Exit;
    end;
  end;
end;
//******************************************************************************
procedure proc_Kousin_Henkan(
                               arg_DB:TDatabase;             //接続されたDB
                               arg_PROG_ID:string;           //プログラムID
                               arg_Ris_ID:TStrings
                               );
var
 w_Tan_Name:string;
 w_i:integer;
 //arg_Error_Haita :Boolean;
begin
  //コンピュータ名取得
  w_Tan_Name := func_GetThisMachineName;

  for w_i := 0 to arg_Ris_ID.Count -1 do begin
    //更新権利返還
    if not func_ReleasKAnri(arg_DB,            //接続されたDB
                            w_Tan_Name,        //PC名称
                            arg_PROG_ID,       //プログラムID
                            arg_Ris_ID[w_i],        //RIS識別ID
                            G_KANRI_TBL_WMODE  //返還権利種(G_KANRI_TBL_WMODE 更新権利)
                           ) then begin
      //arg_Error_Haita := True;
    end;
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
