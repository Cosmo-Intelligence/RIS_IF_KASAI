unit HisMsgDef;
{
■機能説明
  HISの通信電文の共通定義
  処理は記述しないこと
■履歴
新規作成：2004.08.26：担当 増田
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
  //FileCtrl,                     
  Registry,
  ExtCtrls
//プロダクト開発共通－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－
  ;
//参照定数-----------------------------------------------------------------
const
  G_MAX_STREAM_SIZE = 65000; //電文送信最大サイズ 本来はﾈｯﾄﾜｰｸの性能で決める
  G_ONCE_STREAM_SIZE = 15936; //一度に遅れる電文長
  G_MSG_SYSTEM_C    = 'C';   //コマンド
  G_MSG_SYSTEM_A    = 'A';   //返答

  G_MSGKIND_NONE    = '0'; //送信メッセージ種別 無効 NOP
  G_MSGKIND_IRAI    = '1'; //送信メッセージ種別 依頼
  G_MSGKIND_JISSI   = '2'; //送信メッセージ種別 実施
  G_MSGKIND_CANCEL  = '3'; //送信メッセージ種別 オーダキャンセル
  G_MSGKIND_KANJA   = '4'; //送信メッセージ種別 患者情報
  G_MSGKIND_KAIKEI  = '5'; //送信メッセージ種別 会計情報
  G_MSGKIND_UKETUKE = '6'; //送信メッセージ種別 受付
  G_MSGKIND_RESEND  = '7'; //送信メッセージ種別 再送要求
  G_MSGKIND_START   = '8'; //送信メッセージ種別 セッション開始・終了

  //ソケット電文バイナリサイズ
  G_MSGSIZE_IRAI    = 65000; // 依頼
  G_MSGSIZE_JISSI   = 65000; // 実施
  G_MSGSIZE_CANCEL  = 110;   // オーダキャンセル
  G_MSGSIZE_KANJA   = 567;   // 患者情報
  G_MSGSIZE_KAIKEI  = 82;    // 会計情報
  G_MSGSIZE_UKETUKE = 93;    // 受付
  G_MSGSIZE_RESEND  = 109;   // 再送要求
  G_MSGSIZE_START   = 32;    // セッション開始・終了

  G_MSGFNUM_B1     = 5;    //電文定義 1 ～ 7 のヘッダ部長

  G_MSGFNUM_IRAI    = G_MSGFNUM_B1 + 59871; //電文定義 依頼
  G_MSGFNUM_JISSI   = G_MSGFNUM_B1 + 79; //電文定義 実施
  G_MSGFNUM_CANCEL  = G_MSGFNUM_B1 + 8;  //電文定義 オーダキャンセル
  G_MSGFNUM_KANJA   = G_MSGFNUM_B1 + 31; //電文定義 患者情報
  G_MSGFNUM_KAIKEI  = G_MSGFNUM_B1 + 6;  //電文定義 会計情報
  G_MSGFNUM_UKETUKE = G_MSGFNUM_B1 + 9;  //電文定義 受付
  G_MSGFNUM_RESEND  = G_MSGFNUM_B1 + 6;  //電文定義 再送要求
  G_MSGFNUM_START   = G_MSGFNUM_B1;      //電文定義 セッション開始・終了
  {
  //放射線依頼情報電文
  //項目ループ開始位置
  G_MSG_IRAI_KMK_START  = 48;
  //項目ループ終了位置
  G_MSG_IRAI_KMK_END    = 52;
  //項目個数位置
  G_MSG_IRAI_KMK_NO     = 28;
  //項目個数最大値
  G_MSG_IRAI_KMK_MAX    = 300;
  //項目ループ項目数
  G_MSG_IRAI_KMK_COU    = 5;
  //項目一項目長
  G_MSG_IRAI_KMK_LEN    = 69;

  //プロファイルループ開始位置
  G_MSG_IRAI_PROF_START = 54;
  //プロファイルループ終了位置
  G_MSG_IRAI_PROF_END   = 58;
  //プロファイル個数位置
  G_MSG_IRAI_PROF_NO    = 29;
  //プロファイル個数最大値
  G_MSG_IRAI_PROF_MAX   = 30;
  //プロファイルループ項目数
  G_MSG_IRAI_PROF_COU   = 5;
  //プロファイル一項目長
  G_MSG_IRAI_PROF_LEN   = 91;
  //デリミタ位置
  G_MSG_IRAI_DERI       = 59;

  //実施電文用デリミタ位置
  G_MSG_JISSI_DERI      = 1274;
  }
const
  G_MSG_OUTOU_ED        = 'ED'; //電文の応答種別 なし
  G_MSG_RESULT_OK       = 'OK'; //電文の応答種別 OK
  G_MSG_RESULT_NG       = 'NG'; //電文の応答種別 NG
  G_MSG_RESULT_NP       = '  '; //電文の応答種別 ノップ
  G_MSG_RESULT_NP0      = 'ER'; //電文の応答種別 ノップ
  G_MSG_KEISIKI_IRAI    = 'F';  //電文01の形式種別 依頼
  G_MSG_KEISIKI_KANJA   = 'C';  //電文01の形式種別 患者
  G_MSG_SHORIKBN_NEW    = '01'; //電文01 処理区分 新規
  G_MSG_SHORIKBN_UP     = '02'; //電文01 処理区分 更新
  G_MSG_SHORIKBN_DEL    = '03'; //電文01 処理区分 削除
  G_MSG_DENBUN_SEQ      = '01'; //電文SEQ
  OFFSETF_SYORI         = 11;
  OFFSETF_OKNG          = 12;
  //OFFSETF_DenbunChou    = 10;
  OFFSET_DenbunChou_13  = 45;
  OFFSETF_DenbunSEQ     = 15;
  CST_RIS_NYUGAI_NYUIN  = '1';  //RIS入院
  CST_RIS_NYUGAI_GAIRAI = '2';  //RIS外来
  CST_HIS_NYUGAI_NYUIN  = '2';  //HIS入院
  CST_HIS_NYUGAI_GAIRAI = '1';  //HIS外来
  CST_JISSIDATE_NULL    = '20991231';
  CST_JISSITIME_NULL    = '0000';
  CST_JISSITIME_NULL2   = '9999';
  CST_JISSITIME_NULL3   = '999999';
  //年齢計算不能の場合
  CST_AGE_ERR           = 999;
  //継続フラグ（継続有り）
  CST_KEIZOKU           = '1';
  //継続フラグ（継続無し）
  CST_KEIZOKU_END       = '0';
  //電文ID
  //APデータ送信電文
  CST_DENBUNID_SD       = 'SD';
  //メッセージ電文
  CST_DENBUNID_SM       = 'SM';
  //内容コード
  //クライアント⇒サーバ
  CST_DETAILS_C_SS      = 'SS';
  CST_DETAILS_C_SE      = 'SE';
  //サーバ⇒クライアント
  CST_DETAILS_S_SS      = 'SS';
  CST_DETAILS_S_ES      = 'ES';
  CST_DETAILS_S_CS      = 'CS';
  CST_DETAILS_S_EC      = 'EC';
  CST_DETAILS_S_RE      = 'RE';
  //OK
  CST_DENBUNID_OK       = '000000';
  //NG
  CST_DENBUNID_NG       = '999999';
  //NG
  CST_DENBUNID_RE       = '??????';
  //電文コマンド
  //オーダ情報
  CST_COMMAND_ORDER       = 'D-ORDDAT';
  //患者情報更新
  CST_COMMAND_KANJAUP     = 'C-KNJUPD';
  //患者死亡退院情報
  CST_COMMAND_KANJADEL    = 'C-KNJDEL';
  //オーダキャンセル
  CST_COMMAND_ORDERCANCEL = 'C-ORDCNL';
  //会計通知
  CST_COMMAND_KAIKEI      = 'C-ORDACC';
  //患者受付
  CST_COMMAND_UKETUKE     = 'D-PATAPT';
  //撮影実施通知
  CST_COMMAND_JISSI       = 'D-RETDAT';
  //オーダ再送要求
  CST_COMMAND_RESEND      = 'D-ORDSND';
  //APP_ID
  //オーダ受信サービス
  CST_APPID_HRCV01        = 'HRCV01';
  //患者情報受信サービス
	CST_APPID_HRCV02        = 'HRCV02';
  //会計通知受信サービス
	CST_APPID_HRCV03        = 'HRCV03';
  //受付通知送信サービス
  CST_APPID_HSND01        = 'HSND01';
  //実績送信サービス
	CST_APPID_HSND02        = 'HSND02';
  //再送要求サービス
	CST_APPID_HSND03        = 'HSND03';
  //予約送信サービス（治療）
  CST_APPRTID_HSND01        = 'HSND01';
  //実績送信サービス（治療）
	CST_APPRTID_HSND02        = 'HSND02';
  //オーダ情報
  CST_APPTYPE_OI01      = 'OI01';
  //オーダ情報
  CST_APPTYPE_OI02      = 'OI02';
  //オーダキャンセル
  CST_APPTYPE_OI99      = 'OI99';
  //患者情報
  CST_APPTYPE_PI01      = 'PI01';
  //死亡退院情報
  CST_APPTYPE_PI99      = 'PI99';
  //会計通知
  CST_APPTYPE_AC01      = 'AC01';
  //受付通知
  CST_APPTYPE_RC01      = 'RC01';
  //受付取消
  CST_APPTYPE_RC99      = 'RC99';
  //実施通知
  CST_APPTYPE_OP01      = 'OP01';
  //実施通知（再送）
  CST_APPTYPE_OP02      = 'OP02';
  //実施通知（中止）
  CST_APPTYPE_OP99      = 'OP99';
  //オーダ取得
  CST_APPTYPE_OR01      = 'OR01';
  //新規予約
  CST_APPTYPE_OC01      = 'OC01';
  //予約更新
  CST_APPTYPE_OC02      = 'OC02';
  //予約削除
  CST_APPTYPE_OC99      = 'OC99';
  //治療適用通知
  CST_APPTYPE_TQ01      = 'TQ01';
  //治療適用通知（再送）
  CST_APPTYPE_TQ02      = 'TQ02';
  //治療適用通知（中止）
  CST_APPTYPE_TQ99      = 'TQ99';

  //操作種別：HIS受付送信
  CST_OPETYPE_13      = '13';
  //操作種別：HIS実績送信
  CST_OPETYPE_24      = '24';
  //送信済
  CST_SOUSIN_FLG      = '01';
  //通信結果名称
  CST_ORDER_RES_OK_NAME  = 'ＯＫ';       //：送信成功
  CST_ORDER_RES_NG1_NAME = '送信不可';   //：送信失敗 通信不可
  CST_ORDER_RES_NG2_NAME = '電文ＮＧ';   //：送信失敗 電文NG
  CST_ORDER_RES_NG3_NAME = 'リトライ';   //：送信失敗 電文NG
  CST_ORDER_RES_CL_NAME  = 'キャンセル'; //：送信キャンセル
  //再送（オーダ番号使用）
  CST_RESEND_ORDER = '1';

  //薬剤
  CST_RECORD_KBN_20     = '20';
  //手技
  CST_RECORD_KBN_30     = '30';
  //手技
  CST_RECORD_KBN_41     = '41';
  //手技
  CST_RECORD_KBN_42     = '42';
  //手技
  CST_RECORD_KBN_45     = '45';
  //手技
  CST_RECORD_KBN_60     = '60';
  //材料
  CST_RECORD_KBN_50     = '50';
  //フィルム
  CST_RECORD_KBN_57     = '57';
  //シェーマ
  CST_RECORD_KBN_95     = '95';
  //歯式部位
  CST_RECORD_KBN_88     = '88';
  //読影コメント
  CST_RECORD_KBN_90     = '90';
  //病名
  CST_RECORD_KBN_91     = '91';
  //検査目的
  CST_RECORD_KBN_92     = '92';
  //特別指示
  CST_RECORD_KBN_93     = '93';
  //その他詳細
  CST_RECORD_KBN_94     = '94';
  //選択コメント
  CST_RECORD_KBN_97     = '97';
  //必須コメント
  CST_RECORD_KBN_98     = '98';
  //フリーコメント
  CST_RECORD_KBN_99     = '99';
  //歯式部位
  CST_RECORD_KBN_88_TITLE = '【歯式部位】';
  //読影コメント
  CST_RECORD_KBN_90_TITLE = '【読影コメント】';

  //シェーマステータス
  //未取得
  CST_SHEMAFLG_00       = '00';
  //失敗
  CST_SHEMAFLG_09       = '09';
  //済
  CST_SHEMAFLG_10       = '10';

  //RISオーダ
  CST_ORDER_KBN_0     = '0';
  //HISオーダ
  CST_ORDER_KBN_1     = '1';

  //処理区分：受付
  CST_ORDER_RECEIPT_0 = '0';
  //処理区分：キャンセル
  CST_ORDER_RECEIPT_1 = '1';

  //清算区分：未
  CST_SEISAN_0 = '0';
  //清算区分：済
  CST_SEISAN_1 = '1';

  //会計区分：オンライン
  CST_HISKAIKEI_Y = 'Y';
  //会計区分：オフライン
  CST_HISKAIKEI_Z = 'Z';
  //会計区分：オンライン
  CST_RISKAIKEI_Y = '1';
  //会計区分：オフライン
  CST_RISKAIKEI_Z = '0';

  //実施区分：実施
  CST_HISJISSI_Y = 'Y';
  //実施区分：中止
  CST_HISJISSI_Z = 'Z';
  //実施区分：実施
  CST_RISJISSI_Y = '1';
  //実施区分：中止
  CST_RISJISSI_Z = '2';

  //病院コード
  CST_HOSPCODE = '01';
  //IPアドレス・ポート区切り文字
  CST_IPPORT_SP = ';';

  // 性別
  //HISコード
  //女
  CST_SEX_0 = '0';
  //男
  CST_SEX_1 = '1';
  //不明
  CST_SEX_2 = '';
  //RISコード
  //女
  CST_SEX_0_NAME = 'F';
  //男
  CST_SEX_1_NAME = 'M';
  //不明（表示用）
  CST_SEX_9_NAME = '不明';
  //不明（コード）
  CST_SEX_9P_NAME = 'O';
  //男
  CST_SEX_1_THERA = '1';
  //女
  CST_SEX_2_THERA = '2';
  //不明
  CST_SEX_3_THERA = '3';

  // 入外区分
  //HISコード
  //入院
  CST_HIS_NYUGAIKBN_N = 'N';
  //外来
  CST_HIS_NYUGAIKBN_G = 'G';
  //入院中外来
  CST_HIS_NYUGAIKBN_C = 'C';
  //RISコード
  //入院
  CST_RIS_NYUGAIKBN_N = '2';
  //外来
  CST_RIS_NYUGAIKBN_G = '1';
  //入院中外来
  CST_RIS_NYUGAIKBN_C = '3';
  //名称
  CST_NYUGAIKBN_N_NAME = '入院';
  CST_NYUGAIKBN_G_NAME = '外来';
  CST_NYUGAIKBN_C_NAME = '入院中外来';
  //部位コメントの最大格納数
  CST_BUICOM_MAX = 5;
  //身長Null値
  CST_HEIGTH_NULL = '00000';
  //体重Null値
  CST_WEIGTH_NULL = '00000';
  // 妊娠状態
  //なし
  CST_NINSIN_0 = '0';
  //有り
  CST_NINSIN_1 = '1';

  //スタディーインスタンスUID
  CST_STUDYINSTANCEUID_FIXED = '1.2.392.200045.6960.4.7.';

  //患者住所対応
  CST_POSTCODE_1 = '〒';
  CST_POSTCODE_2 = '-';
  CST_TEL = '電話番号：';
  // 看護区分・患者区分
  //なし
  CST_NOTES_0 = '0';
  //有り
  CST_NOTES_1 = '1';

  //繰り返し開始位置
  CST_IRAI_LOOPSTART = 55;
  //繰り返し開始位置
  CST_JISSI_LOOPSTART = 22;

  CST_SENDTO = 'SVIF12';
  CST_FROMTO = 'RIS   ';

  //2011.06 DBExpress対応
  (*
  COMMON1SDIDNO    : Integer = 0;
  COMMON1RVIDNO    : Integer = 0;
  COMMON1COMMANDNO : Integer = 0;
  COMMON1STATUSNO  : Integer = 0;
  COMMON1DENLENNO  : Integer = 0;
  *)

  COMMON1SDIDLEN    = 6;
  COMMON1RVIDLEN    = 6;
  COMMON1COMMANDLEN = 8;
  COMMON1STATUSLEN  = 6;
  COMMON1DENLENLEN  = 6;

  COMMON1SDIDNAME    = '送信先ID';
  COMMON1RVIDNAME    = '送信元ID';
  COMMON1COMMANDNAME = '処理コマンド';
  COMMON1STATUSNAME  = '受信結果';
  COMMON1DENLENNAME  = '電文長';

const
  G_FIELD_C  = 'X';  //電文定義 フィールド種別 文字
  G_FIELD_N  = '9';  //電文定義 フィールド種別 数字
////型クラス宣言-------------------------------------------------------------
type //電文定義体
  TStreamField = record
     name   : String[50]; //名称
     x9     : String[1];  //種別 X 9
     size   : Integer;    //サイズ
     offset : Integer;    //オフセット
  End;

type
  TBuffur = record
    data  : array[1..G_MAX_STREAM_SIZE] of byte
  End;
type TBuf = array of byte;
//全電文バイナリ系
type
  TStream_Data = TStringStream;
//定数宣言-------------------------------------------------------------------
//変数宣言-------------------------------------------------------------------
var
//電文フォーマット定義記憶部 未使用
  g_Stream_Base : array[1..G_MSGFNUM_B1] of TStreamField;

  //2011.06 DBExpress対応
  COMMON1SDIDNO    : Integer = 0;
  COMMON1RVIDNO    : Integer = 0;
  COMMON1COMMANDNO : Integer = 0;
  COMMON1STATUSNO  : Integer = 0;
  COMMON1DENLENNO  : Integer = 0;
//関数手続き宣言-------------------------------------------------------------

implementation //**************************************************************

//使用ユニット---------------------------------------------------------------
//uses

//定数宣言       -------------------------------------------------------------
//const

//変数宣言     ---------------------------------------------------------------
var
  g_wi  : INTEGER;
//関数手続き宣言--------------------------------------------------------------

initialization
begin
  //
  g_wi := 1;
  COMMON1SDIDNO := g_wi;
  g_Stream_Base[g_wi].name   := COMMON1SDIDNAME;
  g_Stream_Base[g_wi].x9     := G_FIELD_C;
  g_Stream_Base[g_wi].size   := COMMON1SDIDLEN;
  g_Stream_Base[g_wi].offset := 0;
  //
  inc(g_wi);
  COMMON1RVIDNO := g_wi;
  g_Stream_Base[g_wi].name   := COMMON1RVIDNAME;
  g_Stream_Base[g_wi].x9     := G_FIELD_C;
  g_Stream_Base[g_wi].size   := COMMON1RVIDLEN;
  g_Stream_Base[g_wi].offset := g_Stream_Base[g_wi - 1].size + g_Stream_Base[g_wi - 1].offset;
  //
  inc(g_wi);
  COMMON1COMMANDNO := g_wi;
  g_Stream_Base[g_wi].name   := COMMON1COMMANDNAME;
  g_Stream_Base[g_wi].x9     := G_FIELD_C;
  g_Stream_Base[g_wi].size   := COMMON1COMMANDLEN;
  g_Stream_Base[g_wi].offset := g_Stream_Base[g_wi - 1].size + g_Stream_Base[g_wi - 1].offset;
  //
  inc(g_wi);
  COMMON1STATUSNO := g_wi;
  g_Stream_Base[g_wi].name   := COMMON1STATUSNAME;
  g_Stream_Base[g_wi].x9     := G_FIELD_C;
  g_Stream_Base[g_wi].size   := COMMON1STATUSLEN;
  g_Stream_Base[g_wi].offset := g_Stream_Base[g_wi - 1].size + g_Stream_Base[g_wi - 1].offset;
  //
  inc(g_wi);
  COMMON1DENLENNO := g_wi;
  g_Stream_Base[g_wi].name   := COMMON1DENLENNAME;
  g_Stream_Base[g_wi].x9     := G_FIELD_C;
  g_Stream_Base[g_wi].size   := COMMON1DENLENLEN;
  g_Stream_Base[g_wi].offset := g_Stream_Base[g_wi - 1].size + g_Stream_Base[g_wi - 1].offset;
end;

finalization
begin
//
end;

end.
