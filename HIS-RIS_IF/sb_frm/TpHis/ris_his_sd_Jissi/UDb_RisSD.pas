unit UDb_RisSD;
(**
���@�\����
  HIS�ւ̑��M�T�[�r�X�p��RisDB�ւ̃A�N�Z�X����

������
�V�K�쐬�F2004.10.12�F�S�� ���c �F
*)

interface

uses
//�V�X�e���|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, IniFiles,
  ScktComp,SvcMgr, //Db, DBTables, 
//�v���_�N�g�J�����ʁ|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|
  Gval,
  HisMsgDef,
  HisMsgDef02_JISSI,
  TcpSocket,
  Unit_Log, Unit_DB
  ;
type //��܏��i�[�\����
  TYakuzai_Code = record
    RecKbn: String;
    KoumokuCd: String;
    Use: String;
    Bunkatu: String;
    Yobi: String;
  end;
type //�R�����g���i�[�\����
  TComment_Code = record
    RecKbn: String;
    KoumokuCd: String;
    Comment: String;
    Yobi: String;
  end;
type
  TGroup = record
    GroupNo: String;
    Account: String;
    ExKbn: String;
    Koumoku: String;
    TypeID: String;
    BuiCode: String;
    RoomCode: String;
    Operator: String;
    BuiCount: String;
    Portble: String;
    Meisai: String;
    Yakuzai: Array of TYakuzai_Code;
    Comment: Array of TComment_Code;
  end;

type
  TDB_RisSD = class
  private
    { Private �錾 }
  public
    { Public �錾 }
    wg_SyoriKbn:String;  //�����敪�i�[
    wg_OffSet:Integer;   //�I�t�Z�b�g
    (*
    DatabaseRis: TDatabase;    //RIS DB
    *)
    wg_DBFlg:Boolean;
    wg_KensaType :String; //�������
    wg_DataCount: Extended; //�f�[�^�J�E���^
    wg_Seq: String;       //�f�[�^SEQ
    wg_Kensa_Code:array of TGroup;
    wg_Memo: String;
    function  RisDBOpen(var arg_ErrMsg : String;
                            arg_Svc    : TService
                        ): Boolean;
    procedure RisDBClose;
    function  func_GetOrder(
                  var rec_count: Integer;
                  var arg_ErrMsg:string
                 ):boolean;
    function  func_MakeMsg(
                 var arg_Msg:TStringStream;
                 var arg_ErrMsg:string;
                 var arg_NullFlg:String
                 ):boolean;
    function  func_SaveMsg(
                 arg_Msg:TStringStream;
                 var arg_ErrMsg:string
                 ):boolean;
    function  func_CheckOrder(
                 var arg_ErrMsg,
                 arg_Flg,
                 arg_NullFlg:string
                 ):boolean;
    function  func_SetOrderResult(
                 arg_Msg:TStringStream;
                 arg_SendDate:string;
                 arg_Result:string;
                 var arg_ErrMsg:string
                 ):boolean;
    function func_JouhouKbn(
                 var arg_ErrMsg:string;
                 var arg_NullFlg:String
                 ):String;
    function func_OrderMain(var arg_OrderNo,
                                arg_KensaDate,
                                arg_KensaTime,
                                arg_SystemKbn,
                                arg_SectionID,
                                arg_DrNo,
                                //arg_OrderSection,
                                arg_Dokuei,
                                arg_ErrMsg,
                                arg_NullFlg:string):Boolean;
    function func_KanjaMaster(
                 var arg_Code,
                 arg_SituCode,
                 arg_ErrMsg,
                 arg_NullFlg:string
                 ):Boolean;
    function func_ExMain(var arg_Patient,
                             arg_KensaType,
                             //arg_InOut,
                             arg_JisTanto,
                             arg_ErrMsg,
                             arg_NullFlg:string):Boolean;
    function func_ExtendOrderInfo(var arg_Kbn1,
                                      arg_Kbn2,
                                      arg_Sikyu,
                                      arg_ErrMsg,
                                      arg_NullFlg:string):Boolean;
    function func_ExtendExamInfo(var arg_kaikei,
                                     arg_ErrMsg,
                                     arg_NullFlg:string):Boolean;
    function func_Make_Msg_Kensa(
                     arg_kaikei: String;
                 var arg_TypeID:string;
                 var arg_ErrMsg:string
                 ):Boolean;

    function func_Get_OffSet(arg_No,arg_OffSet:Integer): Integer;
    {
    function func_ToHISInfo(var arg_Date,
                                arg_Time,
                                arg_ErrMsg,
                                arg_NullFlg:string):Boolean;
    }
    function  func_DelOrder(
                 arg_Keep:integer;
                 var arg_ErrMsg:string
                 ):boolean;
  end;

const
  CST_ORDER_RES_OK  = 'OK';  //�F���M����
  CST_ORDER_RES_NG1 = 'NG1'; //�F���M���s �ʐM�s��
  CST_ORDER_RES_NG2 = 'NG2'; //�F���M���s �d��NG
  CST_ORDER_RES_NG3 = 'NG3'; //�F���M���s �d��NG
  CST_ORDER_RES_CL =  'CL';  //�F���M�L�����Z��

var
  DB_RisSD: TDB_RisSD;

implementation


const
CST_PROG_ID='RisHisSD';
CST_PROG_NAME='HIS�|��t�E���я�� ���M����';
//���t�t�H�[�}�b�g������
CST_DATE_FORMAT='YYYY/MM/DD';
//���M��
CST_SOUSIN_FLG='01';
//�����M
CST_MISOUSIN_FLG='00';
//�ʐM���ʖ���
CST_ORDER_RES_OK_NAME  = '�n�j';       //�F���M����
CST_ORDER_RES_NG1_NAME = '���M�s��';   //�F���M���s �ʐM�s��
CST_ORDER_RES_NG2_NAME = '�d���m�f';   //�F���M���s �d��NG
CST_ORDER_RES_CL_NAME  = '�L�����Z��'; //�F���M�L�����Z��
//�G���[�����ꏊ���胁�b�Z�[�W
CST_DELERR_MSG = '�ۑ����Ԃ��߂������R�[�h�̍폜���ɃG���[���N���܂����B';
CST_GETORDERERR_MSG = '�����M���R�[�h�擾���ɃG���[���N���܂����B';
CST_GETTOHISERR_MSG = 'HIS���M���擾���ɃG���[���N���܂����B';
CST_GETKBNERR_MSG = '�d���쐬���A�����敪�擾�G���[���N���܂����B';
CST_GETRIERR_MSG = '�d���쐬���A����ʎ擾�G���[���N���܂����B';
CST_GETMAINERR_MSG = '�d���쐬���A�I�[�_���C���e�[�u�����擾�G���[���N���܂����B';
CST_GETEXMAINERR_MSG = '�d���쐬���A���у��C���e�[�u�����擾�G���[���N���܂����B';
CST_GETORDERSNERR_MSG = '�d���쐬���A�I�[�_���C��SN�e�[�u�����擾�G���[���N���܂����B';
CST_GETORDERINFOERR_MSG = '�d���쐬���A�I�[�_���e�[�u�����擾�G���[���N���܂����B';
CST_GETEXPATIENTERR_MSG = '�d���쐬���A���ъ��҃e�[�u�����擾�G���[���N���܂����B';
CST_GETEXTENDORDERERR_MSG = '�d���쐬���A�g���I�[�_�e�[�u�����擾�G���[���N���܂����B';
CST_GETEXTENDEXAMERR_MSG = '�d���쐬���A�g�����уe�[�u�����擾�G���[���N���܂����B';
CST_GETROOMERR_MSG = '�d���쐬���A�a��ID�擾�G���[���N���܂����B';
CST_GETCOMERR_MSG = '�d���쐬���A�R�����g���擾�G���[���N���܂����B';
CST_SYUGIERR_MSG = '�d���쐬���A���u���ݒ�G���[���N���܂����B';
CST_KENSAERR_MSG = '�d���쐬���A�������ݒ�G���[���N���܂����B';
CST_TEN_HOZONERR_MSG = '���M�I�[�_�e�[�u���d���ۑ����ɃG���[���N���܂����B';
CST_KENSACHKERR_MSG = '�����i���`�F�b�N���ɃG���[���N���܂����B';
CST_KEKKAERR_MSG = '���M�I�[�_�e�[�u�����M���ʕۑ����ɃG���[���N���܂����B';
CST_JISSIHOZONERR_MSG = '���у��C���e�[�u�����M�����ۑ����ɃG���[���N���܂����B';
CST_GETKANJAERR_MSG = '�d���쐬���A����ID�����G���[���N���܂����B';
CST_INS = '01';
CST_CAN = '02';
CST_DEL = '03';
CST_UKETUKE   = '2';
CST_UKETUKE_C = '1';
CST_JISSISUMI = '3';

{
-----------------------------------------------------------------------------
  ���O :RisDBOpen
  ���� :
    var arg_ErrMsg:string �G���[���F�ڍ׌��� ���펞�F''
  ���A�l�F��O�Ȃ�  True ���� False �ُ�
  �@�\ :
    1. �A�v���P�[�V�����ŗL�̃��[�J��BDE�G���A�X���쐬���āAOracle�ɐڑ����܂��B
 *
-----------------------------------------------------------------------------
}
function TDB_RisSD.RisDBOpen(var arg_ErrMsg : String;
                                 arg_Svc    : TService):Boolean;
var
  RetryCnt: integer;
begin
  //�߂�l
  Result := True;

  //���O�쐬
  if not Assigned(FLog) then begin
    FLog := T_FileLog.Create(g_DBLOG03_PATH,
                             g_DBLOG03_PREFIX,
                             g_DBLOG03_LOGGING,
                             g_DBLOG03_KEEPDAYS,
                             g_LogFileSize, //2018/08/30 ���O�t�@�C���ύX
                             nil);
  end;
  if not Assigned(FDebug) then begin
    FDebug := T_FileLog.Create(g_DBLOGDBG03_PATH,
                               g_DBLOGDBG03_PREFIX,
                               g_DBLOGDBG03_LOGGING,
                               g_DBLOGDBG03_KEEPDAYS,
                               g_LogFileSize, //2018/08/30 ���O�t�@�C���ύX
                               nil);
  end;
  //�����؂ꃍ�O�폜
  FLog.DayChange;
  FDebug.DayChange;

  //�ݒ�
  wg_DBFlg := True;
  if FDB = nil then begin
    //�f�[�^�x�[�X���쐬
    FDB := T_ORADB.Create(g_RisDB_Name,
                          g_RisDB_Uid,
                          g_RisDB_Pas,
                          FLog, FDebug);
  end;
  //�N�G���[�쐬
  if not Assigned(FQ_SEL) then begin
    FQ_SEL := T_Query.Create(FDB, FLog, FDebug);
  end;
  if not Assigned(FQ_SEL_ORD) then begin
    FQ_SEL_ORD := T_Query.Create(FDB, FLog, FDebug);
  end;
  if not Assigned(FQ_SEL_BUI) then begin
    FQ_SEL_BUI := T_Query.Create(FDB, FLog, FDebug);
  end;
  if not Assigned(FQ_ALT) then begin
    FQ_ALT := T_Query.Create(FDB, FLog, FDebug);
  end;
  //DB�ڑ�
  if FDB.DBConnect() = false then begin
    //���g���C�񐔏�����
    RetryCnt := 0;
    while RetryCnt < g_RisDB_Retry do begin
      //�ҋ@����
      Sleep(10000);
      //�Đڑ�
      if FDB.DBConnect() = True then begin
        Exit;
      end;
    end;
    if RetryCnt > g_RisDB_Retry then begin
      wg_DBFlg := False;
      Result := False;
    end;
  end;
  //���������̂Ń��g���C�񐔂�ݒ�
  if wg_DBFlg = True Then begin
    //���O�o��
    proc_LogOut(G_LOG_LINE_HEAD_OK,'',G_LOG_KIND_DB_NUM,'RIS DB�ڑ�OK');
  end
  else begin
    //���O�o��
    proc_LogOut(G_LOG_LINE_HEAD_OK,'',G_LOG_KIND_DB_NUM,'RIS DB�ڑ�NG');
  end;
  (*
  //DB�ڑ�������Ă��Ȃ��ꍇ
  if (not wg_DBFlg) or (not DatabaseRis.Connected) then
  begin
    if DatabaseRis = nil then
      //�f�[�^�x�[�X���쐬
      DatabaseRis := TDatabase.Create(self);
    try
      //�f�[�^�x�[�X�ւ̒P�ƃA�N�Z�X�s��
      DatabaseRis.Exclusive := False;
      //�f�[�^�x�[�X�n���h���̋��L
      DatabaseRis.HandleShared := True;
      //�I�[�v������Ă���f�[�^�Z�b�g���Ȃ��Ă��A�v���P�[�V�������f�[�^�x�[�X�ɐڑ����Ă���
      DatabaseRis.KeepConnection := True;
      //���O�C���_�C�A���O�\���Ȃ�
      DatabaseRis.LoginPrompt := False;
      //�����l�ݒ�
      Result := True;
      //���g���C�񐔏�����
      RetryCnt := 0;
      try
        //�ݒ肳�ꂽ���g���C�񐔂𒴂���܂�
        while RetryCnt < g_RisDB_Retry do
        begin
          //���g���C�񐔁{1
          inc(RetryCnt);
          try
            //DB�̐ڑ����̐ݒ�
            //�ڑ������
            DatabaseRis.Close;
            //�f�[�^�x�[�X���ݒ�
            DatabaseRis.DatabaseName               := g_RisDB_Name;
            //���[�U�[���ݒ�
            DatabaseRis.Params.Values['USER NAME'] := g_RisDB_Uid;
            //�p�X���[�h�ݒ�
            DatabaseRis.Params.Values['PASSWORD']  := g_RisDB_Pas;
            //���O�C���_�C�A���O�{�b�N�X��\�����Ȃ��l�ɂ���
            DatabaseRis.LoginPrompt := False;
            //Oracle�ɐڑ�
            DatabaseRis.Open;
            //�߂�l
            Result := True;
            //�ڑ��L��
            wg_DBFlg := True;
            //���������̂Ń��g���C�񐔂�ݒ�
            RetryCnt := g_RisDB_Retry;
          except
            on E: Exception do
            begin
              //���s�����ꍇ�͕��A�l��False�ɂ��ă��g���C
              Result := False;
              //�G���[���b�Z�[�W
              arg_ErrMsg := E.Message;
              //�ҋ@����
              Sleep(10000);
              //�T�[�r�X������ꍇ
              if arg_Svc <> nil then
              begin
                //�T�[�r�X���N�����Ă���ꍇ
                if not (arg_Svc.Terminated) then
                begin
                  //���g���C
                  Continue;
                end
                //�T�[�r�X���N�����Ă��Ȃ��ꍇ
                else
                begin
                  //�����I��
                  Exit;
                end;
              end
              //�T�[�r�X���Ȃ��ꍇ
              else
              begin
                //���g���C
                Continue;
              end;
            end;
          end;
        end;
        //OPEN�ł����炻�̑��ݒ������i�����łȂ��Ă��ǂ��H �j
        if DatabaseRis.Connected then begin
          //�x�z����Qery�ɐݒ�
          {
          TQ_Order.Close;
          if TQ_Order.DatabaseName <> DatabaseRis.DatabaseName then
            TQ_Order.DatabaseName := DatabaseRis.DatabaseName;
          TQ_ExMainTable.Close;
          if TQ_ExMainTable.DatabaseName <> DatabaseRis.DatabaseName then
            TQ_ExMainTable.DatabaseName := DatabaseRis.DatabaseName;
          }

          TQ_Etc.Close;
          if TQ_Etc.DatabaseName <> DatabaseRis.DatabaseName then
            TQ_Etc.DatabaseName := DatabaseRis.DatabaseName;

          TQ_ExBui.Close;
          if TQ_ExBui.DatabaseName <> DatabaseRis.DatabaseName then
            TQ_ExBui.DatabaseName := DatabaseRis.DatabaseName;

          TQ_ExSyugi.Close;
          if TQ_ExSyugi.DatabaseName <> DatabaseRis.DatabaseName then
            TQ_ExSyugi.DatabaseName := DatabaseRis.DatabaseName;

          {
          TQ_ExFilm.Close;
          if TQ_ExFilm.DatabaseName <> DatabaseRis.DatabaseName then
            TQ_ExFilm.DatabaseName := DatabaseRis.DatabaseName;

          TQ_ExMain.Close;
          if TQ_ExMain.DatabaseName <> DatabaseRis.DatabaseName then
            TQ_ExMain.DatabaseName := DatabaseRis.DatabaseName;

          TQ_Kbn.Close;
          if TQ_Kbn.DatabaseName <> DatabaseRis.DatabaseName then
            TQ_Kbn.DatabaseName := DatabaseRis.DatabaseName;
          TQ_DateTime.Close;
          if TQ_DateTime.DatabaseName <> DatabaseRis.DatabaseName then
            TQ_DateTime.DatabaseName := DatabaseRis.DatabaseName;
          }
          //�G���[�Ȃ�
          arg_ErrMsg := '';
        end;
      except
        on E: Exception do
        begin
          //�f�[�^�x�[�X���ڑ�����Ă����ꍇ
          if DatabaseRis.Connected then
            //�ؒf
            DatabaseRis.Close;
          //�G���[���b�Z�[�W
          arg_ErrMsg := E.Message;
          //�߂�l
          Result := False;
          //�t���O�ݒ�
          wg_DBFlg := False;
          //�����I��
          Exit;
        end;
      end;
    except
      on E: Exception do
      begin
        //�f�[�^�x�[�X���쐬����Ă����ꍇ
        if DatabaseRis <> nil then
        begin
         //�J��
         DatabaseRis.Free;
         Sleep(1000);
         //nil�ݒ�
         DatabaseRis := nil;
        end;
        //�G���[���b�Z�[�W
        arg_ErrMsg := E.Message;
        //�߂�l
        Result := False;
        //�t���O�ݒ�
        wg_DBFlg := False;
        //�����I��
        Exit;
      end;
    end;
  end;
  *)
end;

{
-----------------------------------------------------------------------------
  ���O :RisDBClose
  ���� :
  ���A�l�F��O�Ȃ� ����
  �@�\ :
    1. Oracle��DB�֘A�N���[�Y�B
 *
-----------------------------------------------------------------------------
}
procedure TDB_RisSD.RisDBClose;
begin
  wg_DBFlg := False;
  try
    FDB.DBDisConnect();
  except
  end;
  (*
  try
    //TQ_Order.Close;
    //TQ_ExMainTable.Close;
    //TQ_Etc.Close;
    //TQ_ExBui.Close;
    //TQ_ExSyugi.Close;
    //TQ_ExFilm.Close;
    //TQ_ExMain.Close;
    //TQ_Kbn.Close;
    //TQ_DateTime.Close;
    if DatabaseRis <> nil then begin
      FreeAndNil(DatabaseRis);
      wg_DBFlg := False;
    end;
  except
    FreeAndNil(DatabaseRis);
    wg_DBFlg := False;
  end;
  *)
end;

{
-----------------------------------------------------------------------------
  ���O :func_GetOrder
  ���� :
    var arg_ErrMsg:string �G���[���F�ڍ׌��� ���펞�F''
  ���A�l�F��O�Ȃ�  True ���� False �ُ�
  �@�\ :
    1. ���M�I�[�_�e�[�u�����疢���M���R�[�h���I�[�_���M�����̌Â����Ɏ擾�B
 *
-----------------------------------------------------------------------------
}
function  TDB_RisSD.func_GetOrder(
    var rec_count: Integer;
    var arg_ErrMsg:string
    ):boolean;
var
  sqlSelect:  String;
  iRslt:      Integer;
begin
  //�߂�l
  Result := True;
  rec_count := 0;
  try
    with FQ_SEL_ORD do begin
      //SQL�ݒ�
      sqlSelect := '';
      sqlSelect := sqlSelect + 'SELECT';
      sqlSelect := sqlSelect + ' HIS.ROWID';
      sqlSelect := sqlSelect + ',HIS.REQUESTID';
      sqlSelect := sqlSelect + ',TO_CHAR(HIS.REQUESTDATE, ''YYYY/MM/DD HH24:MI:SS'') AS REQUESTDATE';
      sqlSelect := sqlSelect + ',HIS.RIS_ID';
      sqlSelect := sqlSelect + ',HIS.REQUESTUSER';
      sqlSelect := sqlSelect + ',HIS.REQUESTTERMINALID';
      sqlSelect := sqlSelect + ',HIS.REQUESTTYPE';
      sqlSelect := sqlSelect + ',HIS.MESSAGEID1';
      sqlSelect := sqlSelect + ',HIS.MESSAGEID2';
      sqlSelect := sqlSelect + ',HIS.TRANSFERSTATUS';
      sqlSelect := sqlSelect + ',HIS.TRANSFERDATE';
      sqlSelect := sqlSelect + ',HIS.TRANSFERRESULT';
      sqlSelect := sqlSelect + ',TO_CHAR(EX.EXAMENDDATE, ''YYYY/MM/DD HH24:MI:SS'') AS EXAMENDDATE';
      sqlSelect := sqlSelect + ' FROM TOHISINFO HIS, EXMAINTABLE EX';
      sqlSelect := sqlSelect + ' WHERE HIS.TRANSFERSTATUS = ''00''';
      sqlSelect := sqlSelect + ' AND (HIS.REQUESTTYPE = ''' + CST_APPTYPE_OP01 + ''' OR HIS.REQUESTTYPE = ''' + CST_APPTYPE_OP99 + ''' OR HIS.REQUESTTYPE = ''' + CST_APPTYPE_OP02 + ''')';
      sqlSelect := sqlSelect + ' AND HIS.RIS_ID = EX.RIS_ID(+)';
      sqlSelect := sqlSelect + ' ORDER BY REQUESTDATE';
      (*
      sqlSelect := '';
      sqlSelect := sqlSelect + 'SELECT';
      sqlSelect := sqlSelect + ' ROWID';
      sqlSelect := sqlSelect + ',REQUESTID';
      sqlSelect := sqlSelect + ',TO_CHAR(REQUESTDATE, ''YYYY/MM/DD HH24:MI:SS'') AS REQUESTDATE';
      sqlSelect := sqlSelect + ',RIS_ID';
      sqlSelect := sqlSelect + ',REQUESTUSER';
      sqlSelect := sqlSelect + ',REQUESTTERMINALID';
      sqlSelect := sqlSelect + ',REQUESTTYPE';
      sqlSelect := sqlSelect + ',MESSAGEID1';
      sqlSelect := sqlSelect + ',MESSAGEID2';
      sqlSelect := sqlSelect + ',TRANSFERSTATUS';
      sqlSelect := sqlSelect + ',TRANSFERDATE';
      sqlSelect := sqlSelect + ',TRANSFERRESULT';
      sqlSelect := sqlSelect + ' FROM TOHISINFO';
      sqlSelect := sqlSelect + ' WHERE TRANSFERSTATUS = ''00''';
      sqlSelect := sqlSelect + ' AND (REQUESTTYPE = ''' + CST_APPTYPE_OP01 + ''' OR REQUESTTYPE = ''' + CST_APPTYPE_OP99 + ''' OR REQUESTTYPE = ''' + CST_APPTYPE_OP02 + ''')';
      sqlSelect := sqlSelect + ' ORDER BY REQUESTDATE';
      *)
      PrepareQuery(sqlSelect);
      //SQL���s
      iRslt := OpenQuery();
      if iRslt < 0 then begin
        //��O�G���[
        Result := False;
        //�ؒf
        wg_DBFlg := False;
        //�����I��
        Exit;
      end;
      rec_count := iRslt;
      //����I������
      arg_ErrMsg := '';
      //�����I��
      Exit;
    end;
  except
    on E: Exception do
    begin
      //�G���[�I������
      Result := False;
      //�G���[��ԃ��b�Z�[�W�擾
      arg_ErrMsg := CST_GETORDERERR_MSG + E.Message;
      //�ؒf
      wg_DBFlg := False;
      //�����I��
      Exit;
    end;
  end;
end;
{
-----------------------------------------------------------------------------
  ���O :func_MakeMsg
  ���� :
    var arg_Msg:TStringStream His���M�d��
    arg_ErrMsg:string �G���[���F�ڍ׌��� ���펞�F''
    var arg_NullFlg:String �f�[�^�Ȃ��F'1' ���펞�F''
  ���A�l�F��O�Ȃ�  True ���� False �ُ�
  �@�\ :
    1. ���M�I�[�_�e�[�u���̃J�����g���R�[�h���His���M�d�����쐬���܂��B�B
 *
-----------------------------------------------------------------------------
}
function  TDB_RisSD.func_MakeMsg(
    var arg_Msg:TStringStream;
    var arg_ErrMsg:string;
    var arg_NullFlg:String
    ):boolean;
var
  w_SysD:TDateTime;
  w_sysdate,w_systime:String;
  w_offset:integer;
  w_size  :integer;
  w_StremField : TStreamField;

  ws_MachineName: String;
  ws_OrderNo: String;
  ws_StartDate: String;
  ws_StartTime: String;
  ws_OrderKbn: String;
  ws_Section: String;
  ws_DrNo: String;
  ws_OrderSection: String;
  ws_PatientID: String;
  ws_Kensatype: String;
  ws_InOut: String;
  ws_ExTanto: String;
  wd_ExDate: TDateTime;
  ws_ExDate: String;
  ws_ExTime: String;
  ws_Byouto: String;
  ws_Byousitu: String;
  ws_Kbn1: String;
  ws_Kbn2: String;
  ws_Sikyu: String;
  ws_Kbn4: String;
  ws_Kbn5: String;
  ws_Hoken1: String;
  ws_Hoken2: String;
  ws_Hoken3: String;
  ws_IraiDate: String;
  ws_Kaikei: String;
  wi_BuiLoop: Integer;
  wi_YLoop: Integer;
  wi_FLoop: Integer;
  wi_SLoop: Integer;
  wi_CLoop: Integer;
  WILoop: Integer;

  wkREQUESTTYPE:  String;
begin
  //�߂�l
  Result:=True;
  wg_KensaType := '';
  try
    //���{�d���̏ꍇ
    wkREQUESTTYPE := FQ_SEL_ORD.GetString('REQUESTTYPE');
    if (wkREQUESTTYPE = CST_APPTYPE_OP01) or
       (wkREQUESTTYPE = CST_APPTYPE_OP02) or
       (wkREQUESTTYPE = CST_APPTYPE_OP99) then
    begin
      //��ʂɂ��d���ɏ����������ݒ肷��
      proc_ClearStream2(G_MSG_SYSTEM_C,G_MSGKIND_JISSI,arg_Msg);
      //�d���̃w�b�_�Ɏ�ʂ��Ƃ̌Œ蕶�����ݒ�
      proc_SetStreamHDDef(G_MSG_SYSTEM_C,G_MSGKIND_JISSI,arg_Msg);
      //�V�X�e���������擾���d���ɐݒ肷��
      //�V�X�e�����t�擾
      w_SysD := FQ_SEL.GetSysDate;
      //���t�ϊ�(MMDD)
      w_sysdate := FormatDateTime('mmdd', w_SysD);
      //�I�[�_�[���C�����擾
      if not func_OrderMain(ws_OrderNo,ws_StartDate,ws_StartTime,
                            ws_OrderKbn,ws_Section,ws_DrNo,ws_Kbn5,
                                              arg_ErrMsg,arg_NullFlg) then begin
        //�G���[�I������
        Result := False;
        //�����I��
        Exit;
      end;
      //�f�[�^�Ȃ��̂��ߏI���i�G���[�I���Ƃ͈Ⴄ�j
      if arg_NullFlg = '1' then begin
        //�����I��
        Exit;
      end;
      //���я��擾
      if not func_ExMain(ws_PatientID,ws_Kensatype,ws_ExTanto,arg_ErrMsg,arg_NullFlg) then begin
        //�G���[�I������
        Result := False;
        //�����I��
        Exit;
      end;
      //�f�[�^�Ȃ��̂��ߏI���i�G���[�I���Ƃ͈Ⴄ�j
      if arg_NullFlg = '1' then begin
        //�����I��
        Exit;
      end;
      {
      //���ъ��ҏ��擾
      if not func_ExKanja(ws_Byouto,ws_Byousitu,arg_ErrMsg,arg_NullFlg) then begin
        //�G���[�I������
        Result := False;
        //�����I��
        Exit;
      end;
      //�f�[�^�Ȃ��̂��ߏI���i�G���[�I���Ƃ͈Ⴄ�j
      if arg_NullFlg = '1' then begin
        //�����I��
        Exit;
      end;
      }
      //�g���I�[�_���擾
      if not func_ExtendOrderInfo(ws_Kbn1,ws_Kbn2,ws_Sikyu,
                                              arg_ErrMsg,arg_NullFlg) then begin
        //�G���[�I������
        Result := False;
        //�����I��
        Exit;
      end;
      //�f�[�^�Ȃ��̂��ߏI���i�G���[�I���Ƃ͈Ⴄ�j
      if arg_NullFlg = '1' then begin
        //�����I��
        Exit;
      end;
      //�g�����я��擾
      if not func_ExtendExamInfo(ws_Kaikei,arg_ErrMsg,arg_NullFlg) then begin
        //�G���[�I������
        Result := False;
        //�����I��
        Exit;
      end;
      //�f�[�^�Ȃ��̂��ߏI���i�G���[�I���Ƃ͈Ⴄ�j
      if arg_NullFlg = '1' then begin
        //�����I��
        Exit;
      end;
      {
      //�g�����я��擾
      if not func_ToHISInfo(ws_ExDate,ws_ExTime,arg_ErrMsg,arg_NullFlg) then begin
        //�G���[�I������
        Result := False;
        //�����I��
        Exit;
      end;
      //�f�[�^�Ȃ��̂��ߏI���i�G���[�I���Ƃ͈Ⴄ�j
      if arg_NullFlg = '1' then begin
        //�����I��
        Exit;
      end;
      }
      //���@�̏ꍇ
      if ws_InOut = CST_HIS_NYUGAIKBN_N then begin
        //�a���܂��͕a���h�c���Ȃ��ꍇ
        if (ws_Byouto = '') or (ws_Byousitu = '') then begin
          //�G���[��ԃ��b�Z�[�W�擾
          arg_ErrMsg := CST_GETROOMERR_MSG + '�u�a��ID�A�a��ID������܂���B�v';
          //�G���[�I������
          Result := False;
          //�����I��
          Exit;
        end;
      end;
      {
      for WILoop := 0 to g_HIS_List.Count - 1 do
      begin
        if g_HIS_List.Strings[WILoop] = wg_KensaType then
        begin
          arg_ErrMsg := '�������=' + wg_KensaType;
          arg_NullFlg := '2';
          //�����I��
          Exit;
        end;
      end;
      }
      //���Ҕԍ��ݒ�(10�o�C�g)
      proc_SetStringStream(G_MSG_SYSTEM_C,G_MSGKIND_JISSI,arg_Msg,JISSIPIDNO,
                           ws_PatientID);
      //�I�[�_�ԍ��ݒ�(16�o�C�g)
      proc_SetStringStream(G_MSG_SYSTEM_C,G_MSGKIND_JISSI,arg_Msg,JISSIORDERNO,
                           ws_OrderNo);
      //�J�n���ݒ�(8�o�C�g)
      proc_SetStringStream(G_MSG_SYSTEM_C,G_MSGKIND_JISSI,arg_Msg,JISSISTARTDATENO,
                           ws_StartDate);
      //�J�n�����ݒ�(4�o�C�g)
      proc_SetStringStream(G_MSG_SYSTEM_C,G_MSGKIND_JISSI,arg_Msg,JISSISTARTTIMENO,
                           ws_StartTime);
      //���{����
      wd_ExDate := StrToDateTime(FQ_SEL_ORD.GetString('EXAMENDDATE'));
      //wd_ExDate := StrToDateTime(FQ_SEL_ORD.GetString('REQUESTDATE'));
      //���{��
      ws_ExDate := FormatDateTime('YYYYMMDD', wd_ExDate);
      //���{����
      ws_ExTime := FormatDateTime('HHMM', wd_ExDate);

      //���{���ݒ�(8�o�C�g)
      proc_SetStringStream(G_MSG_SYSTEM_C, G_MSGKIND_JISSI, arg_Msg,
                           JISSIOPERATIONDATENO, ws_ExDate);
      //���{�����ݒ�(4�o�C�g)
      proc_SetStringStream(G_MSG_SYSTEM_C, G_MSGKIND_JISSI, arg_Msg,
                           JISSIOPERATIONTIMENO, ws_ExTime);
      //���{�҃R�[�h�ݒ�(10�o�C�g)
      proc_SetStringStream(G_MSG_SYSTEM_C, G_MSGKIND_JISSI, arg_Msg,
                           JISSIJISSICODENO, ws_ExTanto);
      //�I�[�_�敪�ݒ�(1�o�C�g)
      proc_SetStringStream(G_MSG_SYSTEM_C,G_MSGKIND_JISSI,arg_Msg,JISSIORDERKBNNO,
                           ws_OrderKbn);
      //�˗��Ȑݒ�(2�o�C�g)
      proc_SetStringStream(G_MSG_SYSTEM_C,G_MSGKIND_JISSI,arg_Msg,JISSISECTIONCODENO,
                           ws_Section);
      //�˗���R�[�h�ݒ�(10�o�C�g)
      proc_SetStringStream(G_MSG_SYSTEM_C,G_MSGKIND_JISSI,arg_Msg,JISSIDRNO,
                           ws_DrNo);
      //�敪1�ݒ�(1�o�C�g)
      proc_SetStringStream(G_MSG_SYSTEM_C,G_MSGKIND_JISSI,arg_Msg,JISSIKINKYUKBNNO,
                           ws_Sikyu);
      //�敪2�ݒ�(1�o�C�g)
      proc_SetStringStream(G_MSG_SYSTEM_C,G_MSGKIND_JISSI,arg_Msg,JISSISIKYUKBNNO,
                           ws_Kbn1);
      //�敪3�ݒ�(1�o�C�g)
      proc_SetStringStream(G_MSG_SYSTEM_C,G_MSGKIND_JISSI,arg_Msg,JISSIGENZOKBNNO,
                           ws_Kbn2);
      //�敪4�ݒ�(1�o�C�g)
      proc_SetStringStream(G_MSG_SYSTEM_C,G_MSGKIND_JISSI,arg_Msg,JISSIYOYAKUKBNNO,
                           ws_Kbn5);
      //�ǉe�σt���O�ݒ�(1�o�C�g)
      proc_SetStringStream(G_MSG_SYSTEM_C,G_MSGKIND_JISSI,arg_Msg,JISSIDOKUEIKBNNO,
                           '0');

      //�������ʏ��ݒ�
      if not func_Make_Msg_Kensa(ws_Kaikei,ws_Kensatype,arg_ErrMsg) then begin
        //�G���[�I������
        Result := False;
        //�����I��
        Exit;
      end;

      //�O���[�v���ݒ�(2�o�C�g)
      proc_SetStringStream(G_MSG_SYSTEM_C,G_MSGKIND_JISSI,arg_Msg,JISSIGROUPCOUNTNO,
           func_LeftZero(JISSIGROUPCOUNTLEN,IntToStr(Length(wg_Kensa_Code))));


      for wi_BuiLoop := 0 to Length(wg_Kensa_Code) - 1 do
      begin
        if wi_BuiLoop = 0 then
        begin
          //�w��d�����ڂ̏��擾
          w_StremField := func_FindMsgField(G_MSG_SYSTEM_C,G_MSGKIND_JISSI,JISSIGROUPCOUNTNO);
          //�I�t�Z�b�g
          w_offset := w_StremField.offset;
          //�T�C�Y
          w_size   := w_StremField.size;
          //���݂̃I�t�Z�b�g�ʒu�擾
          wg_OffSet := w_offset + w_size;
        end
        else
        begin
          //�w��d�����ڂ̏��擾
          w_StremField := func_FindMsgField(G_MSG_SYSTEM_C,G_MSGKIND_JISSI,JISSIGROUPCOUNTNO);
          //�T�C�Y
          w_size   := w_StremField.size;
          //���݂̃I�t�Z�b�g�ʒu�擾
          wg_OffSet := wg_OffSet + w_size;
        end;

        //�O���[�v�ԍ��ݒ�(3�o�C�g)
        proc_SetStringStream2(G_MSG_SYSTEM_C,G_MSGKIND_JISSI,arg_Msg,JISSIGROUPNO,
                                   wg_OffSet,wg_Kensa_Code[wi_BuiLoop].GroupNo);
        //�w��d�����ڂ̏��擾
        w_StremField := func_FindMsgField(G_MSG_SYSTEM_C,G_MSGKIND_JISSI,JISSIGROUPNO);
        //�T�C�Y
        w_size   := w_StremField.size;
        //���݂̃I�t�Z�b�g�ʒu�擾
        wg_OffSet := wg_OffSet + w_size;
        //��v�敪�ݒ�(1�o�C�g)
        proc_SetStringStream2(G_MSG_SYSTEM_C,G_MSGKIND_JISSI,arg_Msg,JISSIKAIKEIKBNNO,
                                   wg_OffSet,wg_Kensa_Code[wi_BuiLoop].Account);
        //�w��d�����ڂ̏��擾
        w_StremField := func_FindMsgField(G_MSG_SYSTEM_C,G_MSGKIND_JISSI,JISSIKAIKEIKBNNO);
        //�T�C�Y
        w_size   := w_StremField.size;
        //���݂̃I�t�Z�b�g�ʒu�擾
        wg_OffSet := wg_OffSet + w_size;
        //���{�敪�ݒ�(1�o�C�g)
        proc_SetStringStream2(G_MSG_SYSTEM_C,G_MSGKIND_JISSI,arg_Msg,JISSIJISSIKBNNO,
                                   wg_OffSet,wg_Kensa_Code[wi_BuiLoop].ExKbn);
        //�w��d�����ڂ̏��擾
        w_StremField := func_FindMsgField(G_MSG_SYSTEM_C,G_MSGKIND_JISSI,JISSIJISSIKBNNO);
        //�T�C�Y
        w_size   := w_StremField.size;
        //���݂̃I�t�Z�b�g�ʒu�擾
        wg_OffSet := wg_OffSet + w_size;
        //���ڃR�[�h�ݒ�(6�o�C�g)
        proc_SetStringStream2(G_MSG_SYSTEM_C,G_MSGKIND_JISSI,arg_Msg,JISSIKMKCODENO,
                                   wg_OffSet,wg_Kensa_Code[wi_BuiLoop].Koumoku);
        //�w��d�����ڂ̏��擾
        w_StremField := func_FindMsgField(G_MSG_SYSTEM_C,G_MSGKIND_JISSI,JISSIKMKCODENO);
        //�T�C�Y
        w_size   := w_StremField.size;
        //���݂̃I�t�Z�b�g�ʒu�擾
        wg_OffSet := wg_OffSet + w_size;
        //�����񐔐ݒ�(4�o�C�g)
        proc_SetStringStream2(G_MSG_SYSTEM_C,G_MSGKIND_JISSI,arg_Msg,JISSIKENSACOUNTNO,
                                   wg_OffSet,wg_Kensa_Code[wi_BuiLoop].BuiCount);
        //�w��d�����ڂ̏��擾
        w_StremField := func_FindMsgField(G_MSG_SYSTEM_C,G_MSGKIND_JISSI,JISSIKENSACOUNTNO);
        //�T�C�Y
        w_size   := w_StremField.size;
        //���݂̃I�t�Z�b�g�ʒu�擾
        wg_OffSet := wg_OffSet + w_size;
        //�B�e��R�[�h�ݒ�(6�o�C�g)
        proc_SetStringStream2(G_MSG_SYSTEM_C,G_MSGKIND_JISSI,arg_Msg,JISSIBUISATUEICODENO,
                                   wg_OffSet,wg_Kensa_Code[wi_BuiLoop].TypeID);
        //�w��d�����ڂ̏��擾
        w_StremField := func_FindMsgField(G_MSG_SYSTEM_C,G_MSGKIND_JISSI,JISSIBUISATUEICODENO);
        //�T�C�Y
        w_size   := w_StremField.size;
        //���݂̃I�t�Z�b�g�ʒu�擾
        wg_OffSet := wg_OffSet + w_size;
        //���ʃR�[�h�ݒ�(6�o�C�g)
        proc_SetStringStream2(G_MSG_SYSTEM_C,G_MSGKIND_JISSI,arg_Msg,JISSIBUICODENO,
                                   wg_OffSet,wg_Kensa_Code[wi_BuiLoop].BuiCode);
        //�w��d�����ڂ̏��擾
        w_StremField := func_FindMsgField(G_MSG_SYSTEM_C,G_MSGKIND_JISSI,JISSIBUICODENO);
        //�T�C�Y
        w_size   := w_StremField.size;
        //���݂̃I�t�Z�b�g�ʒu�擾
        wg_OffSet := wg_OffSet + w_size;
        //�������R�[�h�ݒ�(6�o�C�g)
        proc_SetStringStream2(G_MSG_SYSTEM_C,G_MSGKIND_JISSI,arg_Msg,JISSIKENSAROOMCODENO,
                                   wg_OffSet,wg_Kensa_Code[wi_BuiLoop].RoomCode);
        //�w��d�����ڂ̏��擾
        w_StremField := func_FindMsgField(G_MSG_SYSTEM_C,G_MSGKIND_JISSI,JISSIKENSAROOMCODENO);
        //�T�C�Y
        w_size   := w_StremField.size;
        //���݂̃I�t�Z�b�g�ʒu�擾
        wg_OffSet := wg_OffSet + w_size;
        //�|�[�^�u���ݒ�(1�o�C�g)
        proc_SetStringStream2(G_MSG_SYSTEM_C,G_MSGKIND_JISSI,arg_Msg,JISSIPORTABLENO,
                                   wg_OffSet,wg_Kensa_Code[wi_BuiLoop].Portble);
        //�w��d�����ڂ̏��擾
        w_StremField := func_FindMsgField(G_MSG_SYSTEM_C,G_MSGKIND_JISSI,JISSIPORTABLENO);
        //�T�C�Y
        w_size   := w_StremField.size;
        //���݂̃I�t�Z�b�g�ʒu�擾
        wg_OffSet := wg_OffSet + w_size;
        //���א��ݒ�(2�o�C�g)
        proc_SetStringStream2(G_MSG_SYSTEM_C,G_MSGKIND_JISSI,arg_Msg,JISSIMEISAICOUNTNO,
                                   wg_OffSet,wg_Kensa_Code[wi_BuiLoop].Meisai);
        //���א����ő�𒴂����ꍇ
        if StrToIntDef(Trim(wg_Kensa_Code[wi_BuiLoop].Meisai),0) > CST_MEISAI_MAX then begin
          //�G���[��ԃ��b�Z�[�W�擾
          arg_ErrMsg := CST_KENSAERR_MSG + '�u���א����ő�l�𒴂��Ă��܂��B�v';
          //�G���[�I������
          Result := False;
          //�����I��
          Exit;
        end;
        //��ܐݒ�
        for wi_YLoop := 0 to Length(wg_Kensa_Code[wi_BuiLoop].Yakuzai) - 1 do
        begin
          //�w��d�����ڂ̏��擾
          w_StremField := func_FindMsgField(G_MSG_SYSTEM_C,G_MSGKIND_JISSI,JISSIMEISAICOUNTNO);
          //�T�C�Y
          w_size   := w_StremField.size;
          //���݂̃I�t�Z�b�g�ʒu�擾
          wg_OffSet := wg_OffSet + w_size;
          //���R�[�h�敪�ݒ�(2�o�C�g)
          proc_SetStringStream2(G_MSG_SYSTEM_C,G_MSGKIND_JISSI,arg_Msg,JISSIYRECORDKBNNO,
                                     wg_OffSet,wg_Kensa_Code[wi_BuiLoop].Yakuzai[wi_YLoop].RecKbn);
          //�w��d�����ڂ̏��擾
          w_StremField := func_FindMsgField(G_MSG_SYSTEM_C,G_MSGKIND_JISSI,JISSIYRECORDKBNNO);
          //�T�C�Y
          w_size   := w_StremField.size;
          //���݂̃I�t�Z�b�g�ʒu�擾
          wg_OffSet := wg_OffSet + w_size;
          //���ڃR�[�h�ݒ�(6�o�C�g)
          proc_SetStringStream2(G_MSG_SYSTEM_C,G_MSGKIND_JISSI,arg_Msg,JISSIYKMKCODENO,
                                     wg_OffSet,wg_Kensa_Code[wi_BuiLoop].Yakuzai[wi_YLoop].KoumokuCd);
          //�w��d�����ڂ̏��擾
          w_StremField := func_FindMsgField(G_MSG_SYSTEM_C,G_MSGKIND_JISSI,JISSIYKMKCODENO);
          //�T�C�Y
          w_size   := w_StremField.size;
          //���݂̃I�t�Z�b�g�ʒu�擾
          wg_OffSet := wg_OffSet + w_size;
          //�I�[�_�g�p�ʐݒ�(9�o�C�g)
          proc_SetStringStream2(G_MSG_SYSTEM_C,G_MSGKIND_JISSI,arg_Msg,JISSIYORDERUSENO,
                                     wg_OffSet,wg_Kensa_Code[wi_BuiLoop].Yakuzai[wi_YLoop].Use);
          //�w��d�����ڂ̏��擾
          w_StremField := func_FindMsgField(G_MSG_SYSTEM_C,G_MSGKIND_JISSI,JISSIYORDERUSENO);
          //�T�C�Y
          w_size   := w_StremField.size;
          //���݂̃I�t�Z�b�g�ʒu�擾
          wg_OffSet := wg_OffSet + w_size;
          //�������ݒ�(2�o�C�g)
          proc_SetStringStream2(G_MSG_SYSTEM_C,G_MSGKIND_JISSI,arg_Msg,JISSIYBUNKATUNO,
                                     wg_OffSet,wg_Kensa_Code[wi_BuiLoop].Yakuzai[wi_YLoop].Bunkatu);
          //�w��d�����ڂ̏��擾
          w_StremField := func_FindMsgField(G_MSG_SYSTEM_C,G_MSGKIND_JISSI,JISSIYBUNKATUNO);
          //�T�C�Y
          w_size   := w_StremField.size;
          //���݂̃I�t�Z�b�g�ʒu�擾
          wg_OffSet := wg_OffSet + w_size;
          //�\���ݒ�(45�o�C�g)
          proc_SetStringStream2(G_MSG_SYSTEM_C,G_MSGKIND_JISSI,arg_Msg,JISSIYYOBINO,
                                     wg_OffSet,wg_Kensa_Code[wi_BuiLoop].Yakuzai[wi_YLoop].Yobi);
          //�w��d�����ڂ̏��擾
          w_StremField := func_FindMsgField(G_MSG_SYSTEM_C,G_MSGKIND_JISSI,JISSIYYOBINO);
          //�T�C�Y
          w_size   := w_StremField.size;
          //���݂̃I�t�Z�b�g�ʒu�擾
          wg_OffSet := wg_OffSet + w_size;
        end;
        //�R�����g�ݒ�
        for wi_CLoop := 0 to Length(wg_Kensa_Code[wi_BuiLoop].Comment) - 1 do
        begin
          //�w��d�����ڂ̏��擾
          w_StremField := func_FindMsgField(G_MSG_SYSTEM_C,G_MSGKIND_JISSI,JISSIMEISAICOUNTNO);
          //�T�C�Y
          w_size   := w_StremField.size;
          //���݂̃I�t�Z�b�g�ʒu�擾
          wg_OffSet := wg_OffSet + w_size;
          //���R�[�h�敪�ݒ�(2�o�C�g)
          proc_SetStringStream2(G_MSG_SYSTEM_C,G_MSGKIND_JISSI,arg_Msg,JISSICRECORDKBNNO,
                                     wg_OffSet,wg_Kensa_Code[wi_BuiLoop].Comment[wi_CLoop].RecKbn);
          //�w��d�����ڂ̏��擾
          w_StremField := func_FindMsgField(G_MSG_SYSTEM_C,G_MSGKIND_JISSI,JISSICRECORDKBNNO);
          //�T�C�Y
          w_size   := w_StremField.size;
          //���݂̃I�t�Z�b�g�ʒu�擾
          wg_OffSet := wg_OffSet + w_size;
          //���ڃR�[�h�ݒ�(6�o�C�g)
          proc_SetStringStream2(G_MSG_SYSTEM_C,G_MSGKIND_JISSI,arg_Msg,JISSICKMKCODENO,
                                     wg_OffSet,wg_Kensa_Code[wi_BuiLoop].Comment[wi_CLoop].KoumokuCd);
          //�w��d�����ڂ̏��擾
          w_StremField := func_FindMsgField(G_MSG_SYSTEM_C,G_MSGKIND_JISSI,JISSICKMKCODENO);
          //�T�C�Y
          w_size   := w_StremField.size;
          //���݂̃I�t�Z�b�g�ʒu�擾
          wg_OffSet := wg_OffSet + w_size;
          //�R�����g�ݒ�(60�o�C�g)
          proc_SetStringStream2(G_MSG_SYSTEM_C,G_MSGKIND_JISSI,arg_Msg,JISSICCOMNO,
                                     wg_OffSet,wg_Kensa_Code[wi_BuiLoop].Comment[wi_CLoop].Comment);
          //�w��d�����ڂ̏��擾
          w_StremField := func_FindMsgField(G_MSG_SYSTEM_C,G_MSGKIND_JISSI,JISSICCOMNO);
          //�T�C�Y
          w_size   := w_StremField.size;
          //���݂̃I�t�Z�b�g�ʒu�擾
          wg_OffSet := wg_OffSet + w_size;
          //�\���ݒ�(11�o�C�g)
          proc_SetStringStream2(G_MSG_SYSTEM_C,G_MSGKIND_JISSI,arg_Msg,JISSICYOBINO,
                                     wg_OffSet,wg_Kensa_Code[wi_BuiLoop].Comment[wi_CLoop].Yobi);
          //�w��d�����ڂ̏��擾
          w_StremField := func_FindMsgField(G_MSG_SYSTEM_C,G_MSGKIND_JISSI,JISSICYOBINO);
          //�T�C�Y
          w_size   := w_StremField.size;
          //���݂̃I�t�Z�b�g�ʒu�擾
          wg_OffSet := wg_OffSet + w_size;
        end;
      end;
      //�d�����ݒ�(6�o�C�g)
      proc_SetStringStream(G_MSG_SYSTEM_C,G_MSGKIND_JISSI,arg_Msg,COMMON1DENLENNO,
                           func_LeftZero(COMMON1DENLENLEN, IntToStr(Length(arg_Msg.DataString) - G_MSGSIZE_START)));
      //�\���̏�����
      SetLength(wg_Kensa_Code,0);
    end
    else begin
      //�ُ�I������
      arg_ErrMsg := '�����敪������������܂���B';
      //�G���[�I������
      Result := False;
      //�����I��
      Exit;
    end;
    //����I������
    arg_ErrMsg := '';
    //�����I��
    Exit;
  except
    //�G���[�I������
    Result := False;
    //�����I��
    Exit;
  end;
end;
{
-----------------------------------------------------------------------------
  ���O :func_SaveMsg
  ���� :
    arg_Msg:TStringStream His���M�d��
    var arg_ErrMsg:string �G���[���F�ڍ׌��� ���펞�F''
  ���A�l�F��O�Ȃ�  True ���� False �ُ�
  �@�\ :
    1. ���M�I�[�_�e�[�u���̃J�����g���R�[�h��His���M�d����ۑ����܂��B
 *
-----------------------------------------------------------------------------
}
function  TDB_RisSD.func_SaveMsg(
    arg_Msg:TStringStream;
    var arg_ErrMsg:string
    ):boolean;
var
  sqlExec:  String;
  iRslt:    Integer;
begin
  //�߂�l
  Result := True;
  try
    with FQ_ALT do begin
      //SQL������쐬
      sqlExec := '';
      sqlExec := sqlExec + 'UPDATE TOHISINFO';
      sqlExec := sqlExec + ' SET TRANSFERTEXT = :PTRANSFERTEXT';
      sqlExec := sqlExec + ' WHERE ROWID = :PROWID';
      //SQL�ݒ�
      PrepareQuery(sqlExec);
      //�p�����[�^
      //�d��
      SetParam('PTRANSFERTEXT', arg_Msg.DataString);
      //ROWID
      SetParam('PROWID', FQ_SEL_ORD.GetString('ROWID'));
      //SQL���s
      iRslt:= ExecSQL();
      if iRslt < 0 then begin
        //���s
        Result := False;
        //�ؒf
        wg_DBFlg := False;
        //
        Exit;
      end;
      //����I������
      arg_ErrMsg := '';
      //�����I��
      Exit;
    end;
    //����
    Result := True;
  except
    on E: Exception do begin
      //�G���[�I������
      Result := False;
      //�G���[��ԃ��b�Z�[�W�擾
      arg_ErrMsg := CST_TEN_HOZONERR_MSG + E.Message;
      //�ؒf
      wg_DBFlg := False;
      //�����I��
      Exit;
    end;
  end;
end;
{
-----------------------------------------------------------------------------
  ���O :func_CheckOrder
  ���� :
    arg_Msg:TStringStream His���M�d��
    var arg_ErrMsg:string �G���[���F�ڍ׌��� ���펞�F''
    arg_Flg:String �G���[���F'1' ���펞�F'0'
    var arg_NullFlg:String �f�[�^�Ȃ��F'1' ���펞�F''
  ���A�l�F��O�Ȃ�  True �����������i�� False �������Ȃ������i��
  �@�\ :
    1. ���M�I�[�_�e�[�u���̃J�����g���R�[�h�̌����i�����`�F�b�N����B
 *
-----------------------------------------------------------------------------
}
function  TDB_RisSD.func_CheckOrder(
    var arg_ErrMsg,
        arg_Flg,
        arg_NullFlg:string
    ):boolean;
var
  w_iCount:       Integer;
  wkREQUESTTYPE:  String;
  sqlSelect:      String;
  iRslt:          Integer;
begin
  //�߂�l
  Result := False;
  arg_Flg := '0';
  try
    with FQ_SEL do begin
      //SQL�ݒ�
      sqlSelect := '';
      sqlSelect := sqlSelect + 'SELECT STATUS';
      sqlSelect := sqlSelect + ' FROM EXMAINTABLE';
      sqlSelect := sqlSelect + ' WHERE RIS_ID = :PRIS_ID';
      PrepareQuery(sqlSelect);
      //�p�����[�^
      //RIS_ID
      SetParam('PRIS_ID', FQ_SEL_ORD.GetString('RIS_ID'));
      //SQL���s
      iRslt:= OpenQuery();
      if iRslt < 0 then begin
        //��O�G���[
        Result := False;
        //�ؒf
        wg_DBFlg := False;
        //�����I��
        Exit;
      end;
      w_iCount := iRslt;
      if w_iCount <> 0 then begin
        //���{�d���̏ꍇ
        wkREQUESTTYPE := FQ_SEL_ORD.GetString('REQUESTTYPE');
        if (wkREQUESTTYPE = CST_APPTYPE_OP01) or
           (wkREQUESTTYPE = CST_APPTYPE_OP02) then
        begin
          //�����ς̏ꍇ
          if (StrToIntDef(GetString('STATUS'), 0) = 90) then begin
            //�߂�l
            Result := True;
            //����I������
            arg_ErrMsg := '';
            //�����I��
            Exit;
          end
          //�����ψȊO�̏ꍇ
          else begin
            //�߂�l
            Result := False;
            arg_Flg := '1';
            //�ُ�I������
            arg_ErrMsg := CST_KENSACHKERR_MSG + '�����i���������ψȊO�ł��B';
            //�����I��
            Exit;
          end;
        end
        //�������~�̏ꍇ
        else if (wkREQUESTTYPE = CST_APPTYPE_OP99) then
        begin
          //�������~�̏ꍇ
          if (StrToIntDef(GetString('STATUS'), 0) = 91) then begin
            //�߂�l
            Result := True;
            //����I������
            arg_ErrMsg := '';
            //�����I��
            Exit;
          end
          //�����ψȊO�̏ꍇ
          else begin
            //�߂�l
            Result := False;
            arg_Flg := '1';
            //�ُ�I������
            arg_ErrMsg := CST_KENSACHKERR_MSG + '�����i�������~�ȊO�ł��B';
            //�����I��
            Exit;
          end;
        end;
      end
      else begin
        //�f�[�^�Ȃ��t���O�ݒ�
        arg_NullFlg := '1';
        //�ُ�I������
        arg_ErrMsg := '�����i���`�F�b�N{���уf�[�^���Ȃ��̂ő��M���L�����Z�����܂��B}';
        //�߂�l
        Result := False;
      end;
    end;
  except
    on E: Exception do begin
      //�G���[�I������
      Result := False;
      arg_Flg := '1';
      //�ؒf
      wg_DBFlg := False;
      //�G���[��ԃ��b�Z�[�W�擾
      arg_ErrMsg := CST_KENSACHKERR_MSG + E.Message;
      //�����I��
      Exit;
    end;
  end;
end;
{
-----------------------------------------------------------------------------
  ���O :func_SetOrderResult
  ���� :
    arg_Msg:TStringStream His���M�d��
    arg_SendDate:string;  ���M���� 'YYYY/MM/DD HH:MI:SS'
    arg_Result:string     ����
                          OK�F���M����
                          NG1�F���M���s �ʐM�s��
                          NG2�F���M���s �d��NG
                          CL�F���M�L�����Z��
                          �ȊO�F���M����
    var arg_ErrMsg:string �G���[���F�ڍ׌��� ���펞�F''
  ���A�l�F��O�Ȃ�
          True ���� False �ُ�
  �@�\ :
    1. ���M�I�[�_�e�[�u���̃J�����g���R�[�h�ɑ��M���ʂ�o�^���܂��B
 *
-----------------------------------------------------------------------------
}
function  TDB_RisSD.func_SetOrderResult(
    arg_Msg:TStringStream;
    arg_SendDate:string;
    arg_Result:string;
    var arg_ErrMsg:string
    ):boolean;
var
  sqlExec:          String;
  iRslt:            Integer;

  wkTRANSFERDATE:   String;
begin
  //�߂�l
  Result := True;
  try
    with FQ_ALT do begin
      //SQL������쐬
      sqlExec := '';
      sqlExec := sqlExec + 'UPDATE TOHISINFO';
      sqlExec := sqlExec + ' SET TRANSFERDATE = %s,';
      //sqlExec := sqlExec + ' SET TRANSFERDATE = TO_DATE(:PTRANSFERDATE, ''YYYY/MM/DD HH24:MI:SS''),';
      sqlExec := sqlExec + ' TRANSFERSTATUS = :PTRANSFERSTATUS,';
      sqlExec := sqlExec + ' TRANSFERRESULT = :PTRANSFERRESULT';
      sqlExec := sqlExec + ' WHERE ROWID = :PROWID';
      //TO_DATE
      wkTRANSFERDATE := 'TO_DATE(''%s'', ''YYYY/MM/DD HH24:MI:SS'')';
      //���M���t
      if Length(arg_SendDate) > 0 then begin
        wkTRANSFERDATE := Format(wkTRANSFERDATE, [arg_SendDate]);
      end
      else begin
        wkTRANSFERDATE := 'NULL';
      end;
      //SQL�ݒ�
      sqlExec := Format(sqlExec, [wkTRANSFERDATE]);
      PrepareQuery(sqlExec);
      //�p�����[�^
      //�ʐM����'OK'�̏ꍇ
      if arg_Result = CST_ORDER_RES_OK then
      begin
        //���M�t���O
        SetParam('PTRANSFERSTATUS', CST_SOUSIN_FLG);
        //�ʐM����
        SetParam('PTRANSFERRESULT', CST_ORDER_RES_OK_NAME);
      end
      //�ʐM����'�ʐM�s��'�̏ꍇ
      else if arg_Result = CST_ORDER_RES_NG1 then
      begin
        //���M�t���O
        SetParam('PTRANSFERSTATUS', CST_MISOUSIN_FLG);
        //�ʐM����
        SetParam('PTRANSFERRESULT', CST_ORDER_RES_NG1_NAME);
      end
      //�ʐM����'�d��NG'�̏ꍇ
      else if arg_Result = CST_ORDER_RES_NG2 then
      begin
        //���M�t���O
        SetParam('PTRANSFERSTATUS', CST_SOUSIN_FLG);
        //�ʐM����
        SetParam('PTRANSFERRESULT', CST_ORDER_RES_NG2_NAME);
      end
      //�ʐM����'�d��NG'�̏ꍇ
      else if arg_Result = CST_ORDER_RES_NG3 then
      begin
        //���M�t���O
        SetParam('PTRANSFERSTATUS', CST_MISOUSIN_FLG);
        //�ʐM����
        SetParam('PTRANSFERRESULT', CST_ORDER_RES_NG3_NAME);
      end
      //�ʐM����'�L�����Z��'�̏ꍇ
      else if arg_Result = CST_ORDER_RES_CL then
      begin
        //���M�t���O
        SetParam('PTRANSFERSTATUS', CST_SOUSIN_FLG);
        //�ʐM����
        SetParam('PTRANSFERRESULT', CST_ORDER_RES_CL_NAME);
      end
      //�ʐM���ʏ�L�ȊO�̏ꍇ
      else
      begin
        //���M�t���O
        SetParam('PTRANSFERSTATUS', CST_SOUSIN_FLG);
        //�ʐM����
        SetParam('PTRANSFERRESULT', CST_ORDER_RES_OK_NAME);
      end;
      //ROWID
      SetParam('PROWID', FQ_SEL_ORD.GetString('ROWID'));
      //SQL���s
      iRslt:= ExecSQL();
      if iRslt < 0 then begin
        //���s
        Result := False;
        //�ؒf
        wg_DBFlg := False;
        //
        Exit;
      end;
    end;
    //����I������
    arg_ErrMsg := '';
    //�����I��
    Exit;
  except
    on E: Exception do
    begin
      //�G���[�I������
      Result := False;
      //�G���[��ԃ��b�Z�[�W�擾
      arg_ErrMsg := CST_KEKKAERR_MSG + E.Message;
      //�ؒf
      wg_DBFlg := False;
      //�����I��
      Exit;
    end;
  end;
end;
{
-----------------------------------------------------------------------------
  ���O :func_JouhouKbn
  ���� :
    var arg_ErrMsg:string  �G���[���F�ڍ׌��� ���펞�F''
    var arg_NullFlg:String �f�[�^�Ȃ��F'1' ���펞�F''
  ���A�l�F��O�Ȃ� '01','02' ���� '' �ُ�
  �@�\ :
    1. ���M���R�[�h�̏��敪���擾���܂��B
 *
-----------------------------------------------------------------------------
}
function TDB_RisSD.func_JouhouKbn(var arg_ErrMsg:string;var arg_NullFlg:String):String;
var
  w_Kbn:String;
  w_Kaikei:String;
  sqlSelect:  String;
  iRslt:      Integer;
begin
  w_Kbn := '02';
  try
    with FQ_SEL do begin
      //SQL�ݒ�
      sqlSelect := '';
      sqlSelect := sqlSelect + 'SELECT JISSEKIKAIKEI_FLG';
      sqlSelect := sqlSelect + ' FROM EXMAINTABLE';
      sqlSelect := sqlSelect + ' WHERE RIS_ID = :PRIS_ID';
      PrepareQuery(sqlSelect);
      //�p�����[�^
      //RIS_ID
      SetParam('PRIS_ID', FQ_SEL_ORD.GetString('RIS_ID'));
      //SQL���s
      iRslt:= OpenQuery();
      if iRslt < 0 then begin
        //��O�G���[
        Result := '';
        //�ؒf
        wg_DBFlg := False;
        //�����I��
        Exit;
      end;
      if Eof = False then begin
        //��v�t���O�擾
        w_Kaikei := GetString('JISSEKIKAIKEI_FLG');
        //��v�t���O��''�ȊO�̏ꍇ
        if w_Kaikei <> '' then begin
          //��v���M�Ȃ��̏ꍇ
          if w_Kaikei = GPCST_KAIKEI_0 then begin
            //���{�ʒm
            w_Kbn := '02';
          end
          //��v���M����̏ꍇ
          else if w_Kaikei = GPCST_KAIKEI_1 then begin
            //��v���M
            w_Kbn := '01';
          end;
        end;
      end;
      //����I������
      arg_ErrMsg := '';
      //�G���[�I������
      Result := w_Kbn;
      //�����I��
      Exit;
    end;
  except
    on E: Exception do begin
      //�G���[�I������
      Result := '';
      //�G���[��ԃ��b�Z�[�W�擾
      arg_ErrMsg := CST_GETRIERR_MSG + E.Message;
      //�����I��
      Exit;
    end;
  end;
end;
{
-----------------------------------------------------------------------------
  ���O :func_OrderMain
  ���� :
    var arg_OrderNo:string       �I�[�_�ԍ�
        arg_KensaDate:string     �����J�n��
        arg_KensaTime:string     �����J�n����
        arg_SystemKbn:string     �������敪
        arg_SectionID:string     �˗���
        arg_DrNo:string          �˗��㗘�p�Ҕԍ�
        arg_OrderSection:string  �˗�����ID
        arg_Dokuei:string        �ǉe�t���O
        arg_ErrMsg:string        �G���[���F�ڍ׌��� ���펞�F''
        arg_NullFlg:String       �f�[�^�Ȃ��F'1' ���펞�F''
  ���A�l�F��O�Ȃ� True ���� False �ُ�
  �@�\ :
    1. ���M���R�[�h�̃I�[�_���C�������擾���܂��B
 *
-----------------------------------------------------------------------------
}
function TDB_RisSD.func_OrderMain(var arg_OrderNo,
                                      arg_KensaDate,
                                      arg_KensaTime,
                                      arg_SystemKbn,
                                      arg_SectionID,
                                      arg_DrNo,
                                      //arg_OrderSection,
                                      arg_Dokuei,
                                      arg_ErrMsg,
                                      arg_NullFlg:string):Boolean;
var
  w_iCount:Integer;
  sqlSelect:  String;
  iRslt:      Integer;
begin
  //�߂�l
  Result := True;
  try
    with FQ_SEL do begin
      //SQL�ݒ�
      sqlSelect := '';
      sqlSelect := sqlSelect + 'SELECT ORDERNO, KENSA_DATE, KENSA_STARTTIME, SYSTEMKBN,';
      sqlSelect := sqlSelect + '       IRAI_SECTION_ID, IRAI_DOCTOR_NO, ORDER_SECTION_ID, DOKUEI_FLG';
      sqlSelect := sqlSelect + '  FROM ORDERMAINTABLE';
      sqlSelect := sqlSelect + ' WHERE RIS_ID = :PRIS_ID';
      PrepareQuery(sqlSelect);
      //�p�����[�^
      //RIS_ID
      SetParam('PRIS_ID', FQ_SEL_ORD.GetString('RIS_ID'));
      //SQL���s
      iRslt:= OpenQuery();
      if iRslt < 0 then begin
        //��O�G���[
        Result := False;
        //�ؒf
        wg_DBFlg := False;
        //�����I��
        Exit;
      end;
      w_iCount := iRslt;
      //�f�[�^����̏ꍇ
      if w_iCount <> 0 then begin
        //�I�[�_�ԍ��K�{�`�F�b�N
        if Trim(GetString('ORDERNO')) = '' then begin
          //�G���[�I������
          Result := False;
          //�G���[�I������
          arg_ErrMsg := CST_GETMAINERR_MSG + '�I�[�_�ԍ�������܂���B';
          //�����I��
          Exit;
        end
        else
          //�I�[�_�[No�擾
          arg_OrderNo := func_RigthSpace(JISSIORDERLEN,Trim(GetString('ORDERNO')));
        //�\�茟�����K�{�`�F�b�N
        if GetString('KENSA_DATE') = '' then begin
          //�G���[�I������
          Result := False;
          //�G���[�I������
          arg_ErrMsg := CST_GETMAINERR_MSG + '�\�茟����������܂���B';
          //�����I��
          Exit;
        end
        else
          //�\�茟�����擾
          arg_KensaDate := func_RigthSpace(JISSISTARTDATELEN,GetString('KENSA_DATE'));
        //�\�茟�������K�{�`�F�b�N
        if GetString('KENSA_STARTTIME') = '' then begin
          //�G���[�I������
          Result := False;
          //�G���[�I������
          arg_ErrMsg := CST_GETMAINERR_MSG + '�\�茟������������܂���B';
          //�����I��
          Exit;
        end
        else begin
          if (GetString('KENSA_STARTTIME') = CST_JISSITIME_NULL2) or
             (GetString('KENSA_STARTTIME') = CST_JISSITIME_NULL3) then
            //�\�茟�������擾
            arg_KensaTime := CST_JISSITIME_NULL
          else
            //�\�茟�������擾
            arg_KensaTime := func_LeftZero(JISSISTARTTIMELEN,func_LeftZero(6, GetString('KENSA_STARTTIME')));
        end;
        //�������敪�K�{�`�F�b�N
        if GetString('SYSTEMKBN') = '' then begin
          //�G���[�I������
          Result := False;
          //�G���[�I������
          arg_ErrMsg := CST_GETMAINERR_MSG + '�������敪������܂���B';
          //�����I��
          Exit;
        end
        else
          //�������敪�擾
          arg_SystemKbn := func_RigthSpace(JISSIORDERKBNLEN,GetString('SYSTEMKBN'));
          //�˗��Ȏ擾
          arg_SectionID := func_RigthSpace(JISSISECTIONCODELEN,GetString('IRAI_SECTION_ID'));
          //�˗��㗘�p�Ҕԍ��擾
          arg_DrNo := func_RigthSpace(JISSIDRLEN,GetString('IRAI_DOCTOR_NO'));
        //�ǉe�擾
        arg_Dokuei := func_RigthSpace(JISSIDOKUEIKBNLEN,GetString('DOKUEI_FLG'));
      end
      //�f�[�^�Ȃ��̏ꍇ
      else begin
        //����I������
        arg_ErrMsg := '';
        //�f�[�^�Ȃ��t���O�̐ݒ�
        arg_NullFlg := '1';
        //�����I��
        Exit;
      end;
      //����I������
      arg_ErrMsg := '';
      //�����I��
      Exit;
    end;
  except
    on E: Exception do begin
      //�G���[�I������
      Result := False;
      //�G���[��ԃ��b�Z�[�W�擾
      arg_ErrMsg := CST_GETMAINERR_MSG + E.Message;
      //�ؒf
      wg_DBFlg := False;
      //�����I��
      Exit;
    end;
  end;
end;
{
-----------------------------------------------------------------------------
  ���O :func_KanjaMaster
  ���� :
    var arg_Code:string     �a���R�[�h
        arg_SituCode:string �a���R�[�h
        arg_ErrMsg:string   �G���[���F�ڍ׌��� ���펞�F''
        arg_NullFlg:String  �f�[�^�Ȃ��F'1' ���펞�F''
  ���A�l�F��O�Ȃ� True ���� False �ُ�
  �@�\ :
    1. ���M���R�[�h�̕a���R�[�h���擾���܂��B
 *
-----------------------------------------------------------------------------
}
function TDB_RisSD.func_KanjaMaster(var arg_Code,
                                        arg_SituCode,
                                        arg_ErrMsg,
                                        arg_NullFlg:string):Boolean;
var
  w_iCount:Integer;
  sqlSelect:  String;
  iRslt:      Integer;
begin
  //�߂�l
  Result := True;
  try
    with FQ_SEL do begin
      //SQL�ݒ�
      sqlSelect := '';
      sqlSelect := sqlSelect + 'SELECT BYOUTOU_ID,BYOUSITU_ID';
      sqlSelect := sqlSelect + ' FROM KANJAMASTER';
      sqlSelect := sqlSelect + ' WHERE KANJAID = :PKANJAID';
      PrepareQuery(sqlSelect);
      //�p�����[�^
      //����ID
      SetParam('PKANJAID', FQ_SEL_ORD.GetString('KANJAID'));
      //SQL���s
      iRslt:= OpenQuery();
      if iRslt < 0 then begin
        //��O�G���[
        Result := False;
        //�ؒf
        wg_DBFlg := False;
        //�����I��
        Exit;
      end;
      w_iCount := iRslt;
      if w_iCount <> 0 then begin
        if GetString('BYOUTOU_ID') <> '' then
          //�a��ID�擾
          arg_Code := func_RigthSpace(3,Trim(GetString('BYOUTOU_ID')));
        if GetString('BYOUSITU_ID') <> '' then
          //�a��ID�擾
          arg_SituCode := func_RigthSpace(5,Trim(GetString('BYOUSITU_ID')));
      end
      else begin
        //�f�[�^�Ȃ��t���O�ݒ�
        arg_NullFlg := '1';
      end;
    end;
  except
    on E: Exception do begin
      //�G���[�I������
      Result := False;
      //�ؒf
      wg_DBFlg := False;
      //�G���[��ԃ��b�Z�[�W�擾
      arg_ErrMsg := CST_GETROOMERR_MSG + E.Message;
      //�����I��
      Exit;
    end;
  end;
end;
{
-----------------------------------------------------------------------------
  ���O :func_ExMain
  ���� :
    var arg_Patient:string    ����ID
        arg_KensaType:string  �B�e���
        arg_InOut:string      �`�[���O�敪
        arg_JisTanto:string   ���ђS����
        arg_ErrMsg:string     �G���[���F�ڍ׌��� ���펞�F''
        arg_NullFlg:String    �f�[�^�Ȃ��F'1' ���펞�F''
  ���A�l�F��O�Ȃ� True ���� False �ُ�
  �@�\ :
    1. ���M���R�[�h�̎��у��C�������擾���܂��B
 *
-----------------------------------------------------------------------------
}
function TDB_RisSD.func_ExMain(var arg_Patient,
                                   arg_KensaType,
                                   //arg_InOut,
                                   arg_JisTanto,
                                   arg_ErrMsg,
                                   arg_NullFlg:string):Boolean;
var
  w_iCount:Integer;
  sqlSelect:  String;
  iRslt:      Integer;
begin
  //�߂�l
  Result := True;
  try
    with FQ_SEL do begin
      //SQL�ݒ�
      sqlSelect := '';
      sqlSelect := sqlSelect + 'SELECT KANJA_ID, KENSATYPE_ID, DENPYO_NYUGAIKBN, KENSA_GISI_ID, BIKOU, JISISYA_ID';
      sqlSelect := sqlSelect + ' FROM EXMAINTABLE';
      sqlSelect := sqlSelect + ' WHERE RIS_ID = :PRIS_ID';
      PrepareQuery(sqlSelect);
      //�p�����[�^
      //RIS_ID
      SetParam('PRIS_ID', FQ_SEL_ORD.GetString('RIS_ID'));
      //SQL���s
      iRslt:= OpenQuery();
      if iRslt < 0 then begin
        //��O�G���[
        Result := False;
        //�ؒf
        wg_DBFlg := False;
        //�����I��
        Exit;
      end;
      w_iCount := iRslt;
      if w_iCount <> 0 then begin
        //���Ҕԍ����Ȃ��ꍇ
        if Trim(GetString('KANJA_ID')) = '' then
        begin
          //�G���[�I������
          Result := False;
          //�G���[�I������
          arg_ErrMsg := CST_GETEXMAINERR_MSG + '���Ҕԍ�������܂���B';
          //�����I��
          Exit;
        end
        else
          //����ID�擾
          arg_Patient := func_RigthSpace(JISSIPIDLEN,Trim(GetString('KANJA_ID')));
        //������ʂ��Ȃ��ꍇ
        if Trim(GetString('KENSATYPE_ID')) = '' then
        begin
          //�G���[�I������
          Result := False;
          //�G���[�I������
          arg_ErrMsg := CST_GETEXMAINERR_MSG + '������ʂ�����܂���B';
          //�����I��
          Exit;
        end
        else
          //������ʎ擾
          arg_KensaType := func_RigthSpace(JISSIBUISATUEICODELEN,Trim(GetString('KENSATYPE_ID')));

        wg_KensaType := GetString('KENSATYPE_ID');
        //���{�S����ID�擾
        arg_JisTanto := func_RigthSpace(JISSIJISSICODELEN,
                                        Trim(GetString('JISISYA_ID')));
(*
        if Pos(',',Trim(GetString('KENSA_GISI_ID'))) <> 0 then
        begin
          //���{�S����ID�擾
          arg_JisTanto := func_RigthSpace(JISSIJISSICODELEN,
                                          Copy(Trim(GetString('KENSA_GISI_ID')), 1,
                                          Pos(',',Trim(GetString('KENSA_GISI_ID'))) - 1));
        end
        else begin
          //���{�S����ID�擾
          arg_JisTanto := func_RigthSpace(JISSIJISSICODELEN,
                                          Trim(GetString('KENSA_GISI_ID')));
        end;
*)
        wg_Memo := func_RigthSpace(JISSICCOMLEN,Trim(GetString('BIKOU')));
      end
      else begin
        //���R�[�h�Ȃ��t���O�ݒ�
        arg_NullFlg := '1';
      end;
    end;
    //����I������
    arg_ErrMsg := '';
    //�����I��
    Exit;
  except
    on E: Exception do begin
      //�G���[�I������
      Result := False;
      //�ؒf
      wg_DBFlg := False;
      //�G���[��ԃ��b�Z�[�W�擾
      arg_ErrMsg := CST_GETEXMAINERR_MSG + E.Message;
      //�����I��
      Exit;
    end;
  end;
end;
{
-----------------------------------------------------------------------------
  ���O :func_ExtendOrderInfo
  ���� :
    var arg_Kbn1:string      �敪1
        arg_Kbn2:string      �敪2
        arg_Sikyu:string     ���}�敪
        arg_ErrMsg:string    �G���[���F�ڍ׌��� ���펞�F''
        arg_NullFlg:String   �f�[�^�Ȃ��F'1' ���펞�F''
  ���A�l�F��O�Ȃ� True ���� False �ُ�
  �@�\ :
    1. ���M���R�[�h�̊g���I�[�_�����擾���܂��B
 *
-----------------------------------------------------------------------------
}
function TDB_RisSD.func_ExtendOrderInfo(var arg_Kbn1,
                                            arg_Kbn2,
                                            arg_Sikyu,
                                            arg_ErrMsg,
                                            arg_NullFlg:string):Boolean;
var
  w_iCount:Integer;
  sqlSelect:  String;
  iRslt:      Integer;
begin
  //�߂�l
  Result := True;
  try
    with FQ_SEL do begin
      //SQL�ݒ�
      sqlSelect := '';
      sqlSelect := sqlSelect + 'SELECT ADDENDUM01, ADDENDUM02,SIKYU_FLG';
      sqlSelect := sqlSelect + ' FROM EXTENDORDERINFO';
      sqlSelect := sqlSelect + ' WHERE RIS_ID = :PRIS_ID';
      PrepareQuery(sqlSelect);
      //�p�����[�^
      //RIS_ID
      SetParam('PRIS_ID', FQ_SEL_ORD.GetString('RIS_ID'));
      //SQL���s
      iRslt:= OpenQuery();
      if iRslt < 0 then begin
        //��O�G���[
        Result := False;
        //�ؒf
        wg_DBFlg := False;
        //�����I��
        Exit;
      end;
      w_iCount := iRslt;
      if w_iCount <> 0 then begin
        //�敪1�擾
        arg_Kbn1 := func_RigthSpace(JISSIKINKYUKBNLEN,
                                    Trim(GetString('ADDENDUM01')));
        //�敪2�擾
        arg_Sikyu := func_RigthSpace(JISSISIKYUKBNLEN,
                                    Trim(GetString('SIKYU_FLG')));
        //�敪2�擾
        arg_Kbn2 := func_RigthSpace(JISSIGENZOKBNLEN,
                                    Trim(GetString('ADDENDUM02')));
      end
      else begin
        //���R�[�h�Ȃ��t���O�ݒ�
        arg_NullFlg := '1';
      end;
    end;
    //����I������
    arg_ErrMsg := '';
    //�����I��
    Exit;
  except
    on E: Exception do begin
      //�G���[�I������
      Result := False;
      //�ؒf
      wg_DBFlg := False;
      //�G���[��ԃ��b�Z�[�W�擾
      arg_ErrMsg := CST_GETEXTENDORDERERR_MSG + E.Message;
      //�����I��
      Exit;
    end;
  end;
end;
{
-----------------------------------------------------------------------------
  ���O :func_ExtendExamInfo
  ���� :
    var arg_kaikei:string    ��v�t���O
        arg_ErrMsg:string    �G���[���F�ڍ׌��� ���펞�F''
        arg_NullFlg:String   �f�[�^�Ȃ��F'1' ���펞�F''
  ���A�l�F��O�Ȃ� True ���� False �ُ�
  �@�\ :
    1. ���M���R�[�h�̊g�����я����擾���܂��B
 *
-----------------------------------------------------------------------------
}
function TDB_RisSD.func_ExtendExamInfo(var arg_kaikei,
                                           arg_ErrMsg,
                                           arg_NullFlg:string):Boolean;
var
  w_iCount:Integer;
  sqlSelect:  String;
  iRslt:      Integer;
begin
  //�߂�l
  Result := True;
  try
    with FQ_SEL do begin
      //SQL�ݒ�
      sqlSelect := '';
      sqlSelect := sqlSelect + 'SELECT JISSEKIKAIKEI_FLG';
      sqlSelect := sqlSelect + ' FROM EXTENDEXAMINFO';
      sqlSelect := sqlSelect + ' WHERE RIS_ID = :PRIS_ID';
      PrepareQuery(sqlSelect);
      //�p�����[�^
      //RIS_ID
      SetParam('PRIS_ID', FQ_SEL_ORD.GetString('RIS_ID'));
      //SQL���s
      iRslt:= OpenQuery();
      if iRslt < 0 then begin
        //��O�G���[
        Result := False;
        //�ؒf
        wg_DBFlg := False;
        //�����I��
        Exit;
      end;
      w_iCount := iRslt;
      if w_iCount <> 0 then begin
        if Trim(GetString('JISSEKIKAIKEI_FLG')) = CST_RISKAIKEI_Z then
          //��v�t���O�擾
          arg_kaikei := func_RigthSpace(JISSIKAIKEIKBNLEN,CST_HISKAIKEI_Z)
        else if Trim(GetString('JISSEKIKAIKEI_FLG')) = CST_RISKAIKEI_Y then
          //��v�t���O�擾
          arg_kaikei := func_RigthSpace(JISSIKAIKEIKBNLEN,CST_HISKAIKEI_Y);
      end
      else begin
        //���R�[�h�Ȃ��t���O�ݒ�
        arg_NullFlg := '1';
      end;
    end;
    //����I������
    arg_ErrMsg := '';
    //�����I��
    Exit;
  except
    on E: Exception do begin
      //�G���[�I������
      Result := False;
      //�ؒf
      wg_DBFlg := False;
      //�G���[��ԃ��b�Z�[�W�擾
      arg_ErrMsg := CST_GETEXTENDEXAMERR_MSG + E.Message;
      //�����I��
      Exit;
    end;
  end;
end;
{
-----------------------------------------------------------------------------
  ���O :func_Make_Msg_Kensa
  ���� :
        arg_Type: String;      �������
        arg_Gisi: String;      ���{�S���Z�t
        var arg_ErrMsg:string  �G���[���F�ڍ׌��� ���펞�F''
  ���A�l�F��O�Ȃ� True ���� False �ُ�
  �@�\ :
    1. ���M�d���̌����R�[�h�A�����R�[�h�}�ԁA���E�敪�A�����w�����ڃR�[�h
    �@ �R�����g�R�[�h�A�t�B�����R�[�h�A�t�B�����ʑ������A�t�B��������
    �@ �t�B������������ݒ肵�܂��B
 *
-----------------------------------------------------------------------------
}
function TDB_RisSD.func_Make_Msg_Kensa(arg_kaikei: String;var arg_TypeID:string;var arg_ErrMsg:string):Boolean;
var
  rec_count_bui:  Integer;

  w_i,w_i2,w_NoCount,w_iKensa_Count,w_iFilm_Count:Integer;
  w_Count,w_iSiji,w_iFCount,w_iLoss,w_iAdju,w_iKCount:Integer;
  w_KensaType,w_Flg,w_KensaCode,w_Kensahouhou:String;
  w_i_Count,w_i_Count2:integer;
  w_Kaisu:String;
  w_RCode,w_JTime,w_SGisi:String;
  wi_Bui_Loop,wi_Bui_Loop2:integer;
  w_Bui_Flg : Boolean;
  wi_Loop_Yakuzai: Integer;
  wi_Yakuzai_Count: Integer;
  wi_Same_Loop: Integer;
  wi_Same_Code: Integer;
  wb_Same_Flg: Boolean;
  wi_Loop_Film: Integer;
  wi_Film_Count: Integer;
  wi_Film_Index: Integer;
  wi_Zairyo_Count: Integer;
  wi_Loop_Inf: Integer;
  wi_Inf_Count: Integer;
  wi_Loop_Com: Integer;
  wi_Com_Count: Integer;
  wb_Yoyaku_Flg: Boolean;
  wi_Index: Integer;
  w_Kensa_Code_Save:array of TGroup;
  wi_Same_Count: Integer;
  WB_Flg,WB_Flg2:Boolean;

  rec_count:  Integer;
  sqlSelect:  String;
  iRslt:      Integer;
  wkBuiID:    String;
begin
  //�߂�l
  Result := True;
  //������
  w_iKensa_Count := 0;
  w_NoCount := 0;
  WB_Flg  := False;
  WB_Flg2 := False;
  try
    //���ѕ��ʃe�[�u�����擾SQL���쐬
    with FQ_SEL_BUI do begin
      wb_Yoyaku_Flg := False;
      //SQL�ݒ�
      sqlSelect := '';
      //2018/08/30 ���ʏ��@�ύX Ex.BUISET_ID �g�p���Ȃ�
      //2018/09/03 ���~���ʑ��M HIS_ORIGINAL_FLG�s�v
      sqlSelect := sqlSelect + 'SELECT Ex.BUIORDER_NO, Ex.SATUEISTATUS, Ex.NO,';
      //sqlSelect := sqlSelect + ' Ex.KENSASITU_ID, Ex.HIS_ORIGINAL_FLG, Ex.BUI_ID';
      sqlSelect := sqlSelect + ' Ex.KENSASITU_ID, Ex.BUI_ID';
      sqlSelect := sqlSelect + '  FROM EXBUITABLE Ex ';
      sqlSelect := sqlSelect + ' WHERE Ex.RIS_ID = :PRIS_ID';
      sqlSelect := sqlSelect + '   AND (Ex.SATUEISTATUS = :PSATUEISTATUS';
      sqlSelect := sqlSelect + '    OR Ex.SATUEISTATUS = :PSATUEISTATUS2)';
      sqlSelect := sqlSelect + ' ORDER BY Ex.NO';
      PrepareQuery(sqlSelect);
      //Where��
      //�p�����[�^
      //RIS_ID
      SetParam('PRIS_ID', FQ_SEL_ORD.GetString('RIS_ID'));
      //�B�e�i��(�B�e��)
      SetParam('PSATUEISTATUS', GPCST_CODE_SATUEIS_1);
      //�B�e�i��(���~)
      SetParam('PSATUEISTATUS2', GPCST_CODE_SATUEIS_2);
      //SQL���s
      iRslt:= OpenQuery();
      if iRslt < 0 then begin
        //��O�G���[
        Result := False;
        //�ؒf
        wg_DBFlg := False;
        //�����I��
        Exit;
      end;
      rec_count := iRslt;
      //���R�[�h���ő吔�ȉ��̏ꍇ
      if rec_count <= CST_KENSA_LOOP then begin
        w_i_Count := rec_count;
      end
      //���R�[�h���ő吔�ȏ�̏ꍇ
      else begin
        w_i_Count := CST_KENSA_LOOP;
      end;
      SetLength(wg_Kensa_Code,0);
      //���R�[�h������ꍇ
      if w_i_Count <> 0 then begin
        //���R�[�h��Loop
        for w_i := 0 to w_i_Count - 1 do begin
          //������
          wi_Same_Count := 0;
          wi_Yakuzai_Count := 0;
          wi_Zairyo_Count := 0;
          wi_Film_Count := 0;
          wi_Inf_Count := 0;
          wi_Com_Count := 0;
          //�\��Ȃ��̏ꍇ
          if not wb_Yoyaku_Flg then
          begin
            //2018/09/03 ���~���ʑ��M --->
            {
            //RIS�쐬�I�[�_�Łh���~�h�̏ꍇ
            if (GetString('HIS_ORIGINAL_FLG') <> CST_ORDER_KBN_1) and
               (GetString('SATUEISTATUS') = GPCST_CODE_SATUEIS_2) then
            begin
              //���̃��R�[�h�Ɉړ�
              Next;
              //��������
              Continue;
            end;
            }
            //2018/09/03 ���~���ʑ��M <---
          end
          //�\�񂠂�̏ꍇ
          else
          begin
            //���łɕ��ʂ��o�^����Ă���ꍇ
            if Length(wg_Kensa_Code) > 0 then
            begin
              //���̃��R�[�h�Ɉړ�
              Next;
              //��������
              Continue;
            end;
            //�h���~�h�̏ꍇ
            if GetString('SATUEISTATUS') = GPCST_CODE_SATUEIS_2 then
            begin
              //���~�̃f�[�^�̃Z�[�u���쐬
              if Length(wg_Kensa_Code) = 0 then
              begin
                //�\���̍쐬
                SetLength(w_Kensa_Code_Save,Length(w_Kensa_Code_Save) + 1);
                //�C���f�b�N�X
                wi_Index := Length(w_Kensa_Code_Save) - 1;
                //�O���[�v�ԍ�
                //w_Kensa_Code_Save[wi_Index].GroupNo := func_LeftZero(JISSIGROUPLEN,Trim(GetString('NO')));
                w_Kensa_Code_Save[wi_Index].GroupNo := func_LeftZero(JISSIGROUPLEN,'001');
                //��v�敪
                w_Kensa_Code_Save[wi_Index].Account := arg_kaikei;
                //���{�̏ꍇ
                if Trim(GetString('SATUEISTATUS')) = CST_RISJISSI_Y then
                  //���{�敪
                  w_Kensa_Code_Save[wi_Index].ExKbn := CST_HISJISSI_Y
                //���~�̏ꍇ
                else if Trim(GetString('SATUEISTATUS')) = CST_RISJISSI_Z then
                  //���{�敪
                  w_Kensa_Code_Save[wi_Index].ExKbn := CST_HISJISSI_Z;

                //���ڃR�[�h
                //2018/08/30 ���ʏ��@�ύX
                //����ID �擪6��
                //w_Kensa_Code_Save[wi_Index].Koumoku := func_RigthSpace(JISSIKMKCODELEN,Trim(GetString('BUISET_ID')));
                wkBuiID:= Trim(GetString('BUI_ID'));
                w_Kensa_Code_Save[wi_Index].Koumoku := func_RigthSpace(JISSIKMKCODELEN, Copy(wkBuiID, 1, 6));

                //�B�e��R�[�h
                w_Kensa_Code_Save[wi_Index].TypeID := func_RigthSpace(JISSIBUISATUEICODELEN,Trim(arg_TypeID));
                //���ʃR�[�h
                wkBuiID := '70' + Copy(wkBuiID, 7, 4);
                w_Kensa_Code_Save[wi_Index].BuiCode := func_RigthSpace(JISSIBUICODELEN, wkBuiID);
                //�������R�[�h
                w_Kensa_Code_Save[wi_Index].RoomCode := func_RigthSpace(JISSIKENSAROOMCODELEN,Trim(GetString('KENSASITU_ID')));

                //�|�[�^�u���i�Œ�j
                w_Kensa_Code_Save[wi_Index].Portble := ' ';
                //�����񐔁i�Œ�j
                w_Kensa_Code_Save[wi_Index].BuiCount := '0000';
                //������
                wi_Same_Code := 0;
                //--- ��� ---
                with FQ_SEL do begin
                  //SQL�ݒ�
                  sqlSelect := '';
                  sqlSelect := sqlSelect + 'SELECT Pm.ZOUEIZAIIJITANNI_ID, Ez.PARTS_ID, Ez.SUURYOU_IJI, Ez.SUURYOU';
                  sqlSelect := sqlSelect + ' FROM EXZOUEIZAITABLE Ez, PARTSMASTER Pm';
                  sqlSelect := sqlSelect + ' WHERE Ez.RIS_ID = :PRIS_ID';
                  sqlSelect := sqlSelect + ' AND Ez.BUI_NO = :PBUI_NO';
                  sqlSelect := sqlSelect + ' AND Ez.PARTS_ID = Pm.ZOUEIZAI_ID(+)';
                  sqlSelect := sqlSelect + ' AND Pm.ZOUEIZAIKBN = :PZOUEIZAIKBN';
                  sqlSelect := sqlSelect + ' ORDER BY Ez.NO';
                  PrepareQuery(sqlSelect);
                  //�p�����[�^
                  //RIS_ID
                  SetParam('PRIS_ID', FQ_SEL_ORD.GetString('RIS_ID'));
                  //BUI_NO
                  SetParam('PBUI_NO', FQ_SEL_BUI.GetString('NO'));
                  //���e�܋敪�i20�F��܁j
                  SetParam('PZOUEIZAIKBN', CST_RECORD_KBN_20);
                  //SQL���s
                  iRslt:= OpenQuery();
                  if iRslt < 0 then begin
                    //��O�G���[
                    Result := False;
                    //�ؒf
                    wg_DBFlg := False;
                    //�����I��
                    Exit;
                  end;
                  //���R�[�h������ꍇ
                  rec_count := iRslt;
                  if rec_count > 0 then begin
                    //����
                    wi_Yakuzai_Count := rec_count;
                    for wi_Loop_Yakuzai := 0 to wi_Yakuzai_Count - 1 do
                    begin
                      //������
                      wb_Same_Flg := False;
                      //�\���̂̒����瓯��ID��T��
                      for wi_Same_Loop := 0 to Length(w_Kensa_Code_Save[wi_Index].Yakuzai) - 1 do
                      begin
                        //����ID�̏ꍇ
                        if w_Kensa_Code_Save[wi_Index].Yakuzai[wi_Same_Loop].KoumokuCd = func_RigthSpace(JISSIYKMKCODELEN,GetString('PARTS_ID')) then
                        begin
                          //�t���O�ݒ�
                          wb_Same_Flg := True;
                          //����ID�C���f�b�N�X
                          wi_Same_Code := wi_Same_Loop;
                          inc(wi_Same_Count);
                          Break;
                        end;
                      end;
                      //����ID���Ȃ��ꍇ
                      if not wb_Same_Flg then
                      begin
                        //�\���̍쐬
                        SetLength(w_Kensa_Code_Save[wi_Index].Yakuzai, Length(w_Kensa_Code_Save[wi_Index].Yakuzai) + 1);
                        //���R�[�h�敪
                        w_Kensa_Code_Save[wi_Index].Yakuzai[Length(w_Kensa_Code_Save[wi_Index].Yakuzai) - 1].RecKbn := func_RigthSpace(JISSIYRECORDKBNLEN,CST_RECORD_KBN_20);
                        //���ڃR�[�h
                        w_Kensa_Code_Save[wi_Index].Yakuzai[Length(w_Kensa_Code_Save[wi_Index].Yakuzai) - 1].KoumokuCd := func_RigthSpace(JISSIYKMKCODELEN,GetString('PARTS_ID'));
                        //�g�p��
                        w_Kensa_Code_Save[wi_Index].Yakuzai[Length(w_Kensa_Code_Save[wi_Index].Yakuzai) - 1].Use := func_LeftZero(JISSIYORDERUSELEN,FloatToStr(StrToFloatDef(GetString('SUURYOU_IJI'), 0) * 10000));
                        //������
                        w_Kensa_Code_Save[wi_Index].Yakuzai[Length(w_Kensa_Code_Save[wi_Index].Yakuzai) - 1].Bunkatu := func_RigthSpace(JISSIYBUNKATULEN,'');
                        //�\��
                        w_Kensa_Code_Save[wi_Index].Yakuzai[Length(w_Kensa_Code_Save[wi_Index].Yakuzai) - 1].Yobi := func_RigthSpace(JISSIYYOBILEN,'');
                      end
                      //����ID����
                      else
                      begin
                        //���{�g�p��
                        w_Kensa_Code_Save[wi_Index].Yakuzai[wi_Same_Code].Use :=
                                     func_LeftZero(JISSIYORDERUSELEN,FloatToStr(
                                                   StrToIntDef(w_Kensa_Code_Save[wi_Index].Yakuzai[wi_Same_Code].Use,0) +
                                                   (StrToFloatDef(GetString('SUURYOU_IJI'), 0) * 10000)));
                      end;
                      Next;
                    end;
                  end;
                end;
                //������
                wi_Same_Code := 0;
                with FQ_SEL do begin
                  //SQL�ݒ�
                  sqlSelect := '';
                  sqlSelect := sqlSelect + 'SELECT Pm.ZOUEIZAIIJITANNI_ID, Ez.PARTS_ID, Ez.SUURYOU_IJI';
                  sqlSelect := sqlSelect + ' FROM EXZOUEIZAITABLE Ez, PARTSMASTER Pm';
                  sqlSelect := sqlSelect + ' WHERE Ez.RIS_ID = :PRIS_ID';
                  sqlSelect := sqlSelect + ' AND Ez.BUI_NO = :PBUI_NO';
                  sqlSelect := sqlSelect + ' AND Ez.PARTS_ID = Pm.ZOUEIZAI_ID(+)';
                  sqlSelect := sqlSelect + ' AND Pm.ZOUEIZAIKBN = :PZOUEIZAIKBN';
                  sqlSelect := sqlSelect + ' ORDER BY Ez.NO';
                  PrepareQuery(sqlSelect);
                  //�p�����[�^
                  //RIS_ID
                  SetParam('PRIS_ID', FQ_SEL_ORD.GetString('RIS_ID'));
                  //BUI_NO
                  SetParam('PBUI_NO', FQ_SEL_BUI.GetString('NO'));
                  //���e�܋敪�i50�F�ޗ��j
                  SetParam('PZOUEIZAIKBN', CST_RECORD_KBN_50);
                  //SQL���s
                  iRslt:= OpenQuery();
                  if iRslt < 0 then begin
                    //��O�G���[
                    Result := False;
                    //�ؒf
                    wg_DBFlg := False;
                    //�����I��
                    Exit;
                  end;
                  rec_count := iRslt;
                  //���R�[�h������ꍇ
                  if rec_count <> 0 then
                  begin
                    //����
                    wi_Zairyo_Count := rec_count;
                    for wi_Loop_Film := 0 to wi_Zairyo_Count - 1 do
                    begin
                      //������
                      wb_Same_Flg := False;
                      //�\���̂̒����瓯��ID��T��
                      for wi_Same_Loop := 0 to Length(w_Kensa_Code_Save[wi_Index].Yakuzai) - 1 do
                      begin
                        //����ID�̏ꍇ
                        if (w_Kensa_Code_Save[wi_Index].Yakuzai[wi_Same_Loop].KoumokuCd = func_RigthSpace(JISSIYKMKCODELEN,GetString('PARTS_ID'))) and
                           (w_Kensa_Code_Save[wi_Index].Yakuzai[wi_Same_Loop].RecKbn = CST_RECORD_KBN_50) then
                        begin
                          //�t���O�ݒ�
                          wb_Same_Flg := True;
                          //����ID�C���f�b�N�X
                          wi_Same_Code := wi_Same_Loop;
                          inc(wi_Same_Count);
                          Break;
                        end;
                      end;
                      //����ID���Ȃ��ꍇ
                      if not wb_Same_Flg then
                      begin
                        //�\���̍쐬
                        SetLength(w_Kensa_Code_Save[wi_Index].Yakuzai, Length(w_Kensa_Code_Save[wi_Index].Yakuzai) + 1);
                        //���R�[�h�敪
                        w_Kensa_Code_Save[wi_Index].Yakuzai[Length(w_Kensa_Code_Save[wi_Index].Yakuzai) - 1].RecKbn := func_RigthSpace(JISSIYRECORDKBNLEN,CST_RECORD_KBN_50);
                        //���ڃR�[�h
                        w_Kensa_Code_Save[wi_Index].Yakuzai[Length(w_Kensa_Code_Save[wi_Index].Yakuzai) - 1].KoumokuCd := func_RigthSpace(JISSIYKMKCODELEN,GetString('PARTS_ID'));
                        //�g�p��
                        w_Kensa_Code_Save[wi_Index].Yakuzai[Length(w_Kensa_Code_Save[wi_Index].Yakuzai) - 1].Use := func_LeftZero(JISSIYORDERUSELEN,FloatToStr(StrToFloatDef(GetString('SUURYOU_IJI'), 0) * 10000));
                        //������
                        w_Kensa_Code_Save[wi_Index].Yakuzai[Length(w_Kensa_Code_Save[wi_Index].Yakuzai) - 1].Bunkatu := func_LeftZero(JISSIYBUNKATULEN,'');
                        //�\��
                        w_Kensa_Code_Save[wi_Index].Yakuzai[Length(w_Kensa_Code_Save[wi_Index].Yakuzai) - 1].Yobi := func_RigthSpace(JISSIYYOBILEN,'');
                      end
                      //����ID����
                      else
                      begin
                        //�g�p��
                        w_Kensa_Code_Save[wi_Index].Yakuzai[wi_Same_Code].Use :=
                                     func_LeftZero(JISSIYORDERUSELEN,FloatToStr(
                                     StrToIntDef(w_Kensa_Code_Save[wi_Index].Yakuzai[wi_Same_Code].Use,0) +
                                     (StrToFloatDef(GetString('SUURYOU_IJI'), 0) * 10000)));
                      end;
                      Next;
                    end;
                  end;
                end;
                //������
                wi_Same_Code := 0;
                with FQ_SEL do begin
                  //SQL�ݒ�
                  sqlSelect := '';
                  sqlSelect := sqlSelect + 'SELECT Pm.ZOUEIZAIIJITANNI_ID, Ez.PARTS_ID, Ez.SUURYOU_IJI';
                  sqlSelect := sqlSelect + ' FROM EXZOUEIZAITABLE Ez, PARTSMASTER Pm';
                  sqlSelect := sqlSelect + ' WHERE Ez.RIS_ID = :PRIS_ID';
                  sqlSelect := sqlSelect + ' AND Ez.BUI_NO = :PBUI_NO';
                  sqlSelect := sqlSelect + ' AND Ez.PARTS_ID = Pm.ZOUEIZAI_ID(+)';
                  sqlSelect := sqlSelect + ' AND Pm.ZOUEIZAIKBN = :PZOUEIZAIKBN';
                  sqlSelect := sqlSelect + ' ORDER BY Ez.NO';
                  PrepareQuery(sqlSelect);
                  //�p�����[�^
                  //RIS_ID
                  SetParam('PRIS_ID', FQ_SEL_ORD.GetString('RIS_ID'));
                  //BUI_NO
                  SetParam('PBUI_NO', FQ_SEL_BUI.GetString('NO'));
                  //���e�܋敪�i50�F�ޗ��j
                  SetParam('PZOUEIZAIKBN', CST_RECORD_KBN_50);
                  //SQL���s
                  iRslt:= OpenQuery();
                  if iRslt < 0 then begin
                    //��O�G���[
                    Result := False;
                    //�ؒf
                    wg_DBFlg := False;
                    //�����I��
                    Exit;
                  end;
                  rec_count := iRslt;
                  //���R�[�h������ꍇ
                  if rec_count <> 0 then
                  begin
                    //����
                    wi_Zairyo_Count := rec_count;
                    for wi_Loop_Film := 0 to wi_Zairyo_Count - 1 do
                    begin
                      //������
                      wb_Same_Flg := False;
                      //�\���̂̒����瓯��ID��T��
                      for wi_Same_Loop := 0 to Length(w_Kensa_Code_Save[wi_Index].Yakuzai) - 1 do
                      begin
                        //����ID�̏ꍇ
                        if (w_Kensa_Code_Save[wi_Index].Yakuzai[wi_Same_Loop].KoumokuCd = func_RigthSpace(JISSIYKMKCODELEN,GetString('PARTS_ID'))) and
                           (w_Kensa_Code_Save[wi_Index].Yakuzai[wi_Same_Loop].RecKbn = CST_RECORD_KBN_50) then
                        begin
                          //�t���O�ݒ�
                          wb_Same_Flg := True;
                          //����ID�C���f�b�N�X
                          wi_Same_Code := wi_Same_Loop;
                          inc(wi_Same_Count);
                          Break;
                        end;
                      end;
                      //����ID���Ȃ��ꍇ
                      if not wb_Same_Flg then
                      begin
                        //�\���̍쐬
                        SetLength(w_Kensa_Code_Save[wi_Index].Yakuzai, Length(w_Kensa_Code_Save[wi_Index].Yakuzai) + 1);
                        //���R�[�h�敪
                        w_Kensa_Code_Save[wi_Index].Yakuzai[Length(w_Kensa_Code_Save[wi_Index].Yakuzai) - 1].RecKbn := func_RigthSpace(JISSIYRECORDKBNLEN,CST_RECORD_KBN_50);
                        //���ڃR�[�h
                        w_Kensa_Code_Save[wi_Index].Yakuzai[Length(w_Kensa_Code_Save[wi_Index].Yakuzai) - 1].KoumokuCd := func_RigthSpace(JISSIYKMKCODELEN,GetString('PARTS_ID'));
                        //�g�p��
                        w_Kensa_Code_Save[wi_Index].Yakuzai[Length(w_Kensa_Code_Save[wi_Index].Yakuzai) - 1].Use := func_LeftZero(JISSIYORDERUSELEN,FloatToStr(StrToFloatDef(GetString('SUURYOU_IJI'), 0) * 10000));
                        //������
                        w_Kensa_Code_Save[wi_Index].Yakuzai[Length(w_Kensa_Code_Save[wi_Index].Yakuzai) - 1].Bunkatu := func_LeftZero(JISSIYBUNKATULEN,'');
                        //�\��
                        w_Kensa_Code_Save[wi_Index].Yakuzai[Length(w_Kensa_Code_Save[wi_Index].Yakuzai) - 1].Yobi := func_RigthSpace(JISSIYYOBILEN,'');
                      end
                      //����ID����
                      else
                      begin
                        //�g�p��
                        w_Kensa_Code_Save[wi_Index].Yakuzai[wi_Same_Code].Use :=
                                     func_LeftZero(JISSIYORDERUSELEN,FloatToStr(
                                     StrToIntDef(w_Kensa_Code_Save[wi_Index].Yakuzai[wi_Same_Code].Use,0) +
                                     (StrToFloatDef(GetString('SUURYOU_IJI'), 0) * 10000)));
                      end;
                      Next;
                    end;
                  end;
                  //������
                  wi_Same_Code := 0;
                  //--- �t�B���� ---
                  //SQL�ݒ�
                  sqlSelect := '';
                  sqlSelect := sqlSelect + 'SELECT Fm.ZOUEIZAITANNI_ID, Ef.FILM_ID, Ef.PARTITION, Ef.USED, Ef.LOSS';
                  sqlSelect := sqlSelect + ' FROM EXFILMTABLE Ef, FILMMASTER Fm';
                  sqlSelect := sqlSelect + ' WHERE Ef.RIS_ID = :PRIS_ID';
                  sqlSelect := sqlSelect + ' AND Ef.BUI_NO = :PBUI_NO';
                  sqlSelect := sqlSelect + ' AND Ef.FILM_ID = Fm.FILM_ID(+)';
                  sqlSelect := sqlSelect + ' ORDER BY Ef.NO';
                  PrepareQuery(sqlSelect);
                  //�p�����[�^
                  //RIS_ID
                  SetParam('PRIS_ID', FQ_SEL_ORD.GetString('RIS_ID'));
                  //BUI_NO
                  SetParam('PBUI_NO', FQ_SEL_BUI.GetString('NO'));
                  //SQL���s
                  iRslt:= OpenQuery();
                  if iRslt < 0 then begin
                    //��O�G���[
                    Result := False;
                    //�ؒf
                    wg_DBFlg := False;
                    //�����I��
                    Exit;
                  end;
                  rec_count := iRslt;
                  //���R�[�h������ꍇ
                  if rec_count <> 0 then
                  begin
                    //����
                    wi_Film_Count := rec_count;
                    for wi_Loop_Film := 0 to wi_Film_Count - 1 do
                    begin
                      //������
                      wb_Same_Flg := False;
                      //�\���̂̒����瓯��ID��T��
                      for wi_Same_Loop := 0 to Length(w_Kensa_Code_Save[wi_Index].Yakuzai) - 1 do
                      begin
                        //����ID�̏ꍇ
                        if (w_Kensa_Code_Save[wi_Index].Yakuzai[wi_Same_Loop].KoumokuCd = func_RigthSpace(JISSIYKMKCODELEN,GetString('FILM_ID'))) and
                           (w_Kensa_Code_Save[wi_Index].Yakuzai[wi_Same_Loop].Bunkatu = func_LeftZero(JISSIYBUNKATULEN,GetString('PARTITION'))) and
                           (w_Kensa_Code_Save[wi_Index].Yakuzai[wi_Same_Loop].RecKbn = CST_RECORD_KBN_57) then
                        begin
                          //�t���O�ݒ�
                          wb_Same_Flg := True;
                          //����ID�C���f�b�N�X
                          wi_Same_Code := wi_Same_Loop;
                          inc(wi_Same_Count);
                          Break;
                        end;
                      end;
                      //����ID���Ȃ��ꍇ
                      if not wb_Same_Flg then
                      begin
                        //�\���̍쐬
                        SetLength(w_Kensa_Code_Save[wi_Index].Yakuzai, Length(w_Kensa_Code_Save[wi_Index].Yakuzai) + 1);
                        //���R�[�h�敪
                        w_Kensa_Code_Save[wi_Index].Yakuzai[Length(w_Kensa_Code_Save[wi_Index].Yakuzai) - 1].RecKbn := func_RigthSpace(JISSIYRECORDKBNLEN,CST_RECORD_KBN_57);
                        //���ڃR�[�h
                        w_Kensa_Code_Save[wi_Index].Yakuzai[Length(w_Kensa_Code_Save[wi_Index].Yakuzai) - 1].KoumokuCd := func_RigthSpace(JISSIYKMKCODELEN,GetString('FILM_ID'));
                        //�g�p��
                        w_Kensa_Code_Save[wi_Index].Yakuzai[Length(w_Kensa_Code_Save[wi_Index].Yakuzai) - 1].Use := func_LeftZero(JISSIYORDERUSELEN,FloatToStr(StrToFloatDef(GetString('USED'), 0) * 10000));
                        //������
                        w_Kensa_Code_Save[wi_Index].Yakuzai[Length(w_Kensa_Code_Save[wi_Index].Yakuzai) - 1].Bunkatu := func_LeftZero(JISSIYBUNKATULEN,GetString('PARTITION'));
                        //�\��
                        w_Kensa_Code_Save[wi_Index].Yakuzai[Length(w_Kensa_Code_Save[wi_Index].Yakuzai) - 1].Yobi := func_RigthSpace(JISSIYYOBILEN,'');
                      end
                      //����ID����
                      else
                      begin
                        //�g�p��
                        w_Kensa_Code_Save[wi_Index].Yakuzai[wi_Same_Code].Use :=
                                     func_LeftZero(JISSIYORDERUSELEN,FloatToStr(
                                     StrToIntDef(w_Kensa_Code_Save[wi_Index].Yakuzai[wi_Same_Code].Use,0) +
                                     (StrToFloatDef(GetString('USED'), 0) * 10000)));
                      end;
                      Next;
                    end;
                  end;
                end;
                //������
                wi_Same_Code := 0;
                with FQ_SEL do begin
                  //SQL�ݒ�
                  sqlSelect := '';
                  sqlSelect := sqlSelect + 'SELECT Ei.INFUSE_ID,Ei.SUURYOU_IJI,Im.INFUSEKBN';
                  sqlSelect := sqlSelect + ' FROM EXINFUSETABLE Ei, INFUSEMASTER Im';
                  sqlSelect := sqlSelect + ' WHERE Ei.RIS_ID = :PRIS_ID';
                  sqlSelect := sqlSelect + ' AND Ei.BUI_NO = :PBUI_NO';
                  sqlSelect := sqlSelect + ' AND Ei.INFUSE_ID = Im.INFUSE_ID(+)';
                  sqlSelect := sqlSelect + ' AND Im.INFUSEKBN = :PINFUSEKBN1';
                  sqlSelect := sqlSelect + ' ORDER BY Im.INFUSEKBN,Ei.NO';
                  PrepareQuery(sqlSelect);
                  //�p�����[�^
                  //RIS_ID
                  SetParam('PRIS_ID', FQ_SEL_ORD.GetString('RIS_ID'));
                  //BUI_NO
                  SetParam('PBUI_NO', FQ_SEL_BUI.GetString('NO'));
                  //BUI_NO
                  SetParam('PINFUSEKBN1', '30');
                  //SQL���s
                  iRslt:= OpenQuery();
                  if iRslt < 0 then begin
                    //��O�G���[
                    Result := False;
                    //�ؒf
                    wg_DBFlg := False;
                    //�����I��
                    Exit;
                  end;
                  rec_count := iRslt;
                  //���R�[�h������ꍇ
                  if rec_count <> 0 then
                  begin
                    //����
                    wi_Inf_Count := rec_count;
                    for wi_Loop_Inf := 0 to wi_Inf_Count - 1 do
                    begin
                      //������
                      wb_Same_Flg := False;
                      //�\���̂̒����瓯��ID��T��
                      for wi_Same_Loop := 0 to Length(w_Kensa_Code_Save[wi_Index].Yakuzai) - 1 do
                      begin
                        //����ID�̏ꍇ
                        if (w_Kensa_Code_Save[wi_Index].Yakuzai[wi_Same_Loop].KoumokuCd = func_RigthSpace(JISSIYKMKCODELEN,GetString('INFUSE_ID'))) and
                           (w_Kensa_Code_Save[wi_Index].Yakuzai[wi_Same_Loop].RecKbn = CST_RECORD_KBN_30) then
                        begin
                          //�t���O�ݒ�
                          wb_Same_Flg := True;
                          //����ID�C���f�b�N�X
                          wi_Same_Code := wi_Same_Loop;
                          inc(wi_Same_Count);
                          Break;
                        end;
                      end;
                      //����ID���Ȃ��ꍇ
                      if not wb_Same_Flg then
                      begin
                        //�\���̍쐬
                        SetLength(w_Kensa_Code_Save[wi_Index].Yakuzai, Length(w_Kensa_Code_Save[wi_Index].Yakuzai) + 1);
                        //���R�[�h�敪
                        w_Kensa_Code_Save[wi_Index].Yakuzai[Length(w_Kensa_Code_Save[wi_Index].Yakuzai) - 1].RecKbn := func_RigthSpace(JISSIYRECORDKBNLEN,CST_RECORD_KBN_30);
                        //���ڃR�[�h
                        w_Kensa_Code_Save[wi_Index].Yakuzai[Length(w_Kensa_Code_Save[wi_Index].Yakuzai) - 1].KoumokuCd := func_RigthSpace(JISSIYKMKCODELEN,GetString('INFUSE_ID'));
                        //��
                        w_Kensa_Code_Save[wi_Index].Yakuzai[Length(w_Kensa_Code_Save[wi_Index].Yakuzai) - 1].Use := func_LeftZero(JISSIYORDERUSELEN,FloatToStr(StrToFloatDef(GetString('SUURYOU_IJI'), 0) * 10000));
                        //������Z
                        w_Kensa_Code_Save[wi_Index].Yakuzai[Length(w_Kensa_Code_Save[wi_Index].Yakuzai) - 1].Bunkatu := func_RigthSpace(JISSIYBUNKATULEN,'');
                        //�\��
                        w_Kensa_Code_Save[wi_Index].Yakuzai[Length(w_Kensa_Code_Save[wi_Index].Yakuzai) - 1].Yobi := func_RigthSpace(JISSIYYOBILEN,'');
                      end
                      //����ID����
                      else
                      begin
                        //��
                        //w_Kensa_Code_Save[wi_Index].Yakuzai[wi_Same_Code].Use := func_LeftZero(JISSIYORDERUSELEN,IntToStr(StrToIntDef(w_Kensa_Code_Save[wi_Index].Yakuzai[wi_Same_Code].Use,0) + StrToIntDef(GetString('SUURYOU_IJI'), 0)));
                        w_Kensa_Code_Save[wi_Index].Yakuzai[wi_Same_Code].Use :=
                                     func_LeftZero(JISSIYORDERUSELEN,FloatToStr(
                                     StrToIntDef(w_Kensa_Code_Save[wi_Index].Yakuzai[wi_Same_Code].Use,0) +
                                     (StrToFloatDef(GetString('SUURYOU_IJI'), 0) * 10000)));
                      end;
                      Next;
                    end;
                  end;
                end;
                //--- �R�����g ---
                with FQ_SEL do begin
                  //SQL�ݒ�
                  sqlSelect := '';
                  sqlSelect := sqlSelect + 'SELECT KUBUN,ID,COM';
                  sqlSelect := sqlSelect + ' FROM ORDERDETAILTABLE_MMH';
                  sqlSelect := sqlSelect + ' WHERE RIS_ID = :PRIS_ID';
                  sqlSelect := sqlSelect + ' AND NO = :PBUI_NO';
                  sqlSelect := sqlSelect + ' ORDER BY COMNO';
                  PrepareQuery(sqlSelect);
                  //�p�����[�^
                  //RIS_ID
                  SetParam('PRIS_ID', FQ_SEL_ORD.GetString('RIS_ID'));
                  //BUI_NO
                  SetParam('PBUI_NO', FQ_SEL_BUI.GetString('NO'));
                  //SQL���s
                  iRslt:= OpenQuery();
                  if iRslt < 0 then begin
                    //��O�G���[
                    Result := False;
                    //�ؒf
                    wg_DBFlg := False;
                    //�����I��
                    Exit;
                  end;
                  rec_count := iRslt;
                  //���R�[�h������ꍇ
                  if rec_count <> 0 then
                  begin
                    //����
                    wi_Inf_Count := rec_count;
                    for wi_Loop_Inf := 0 to wi_Inf_Count - 1 do
                    begin
                      //�\���̍쐬
                      SetLength(w_Kensa_Code_Save[wi_Index].Comment, Length(w_Kensa_Code_Save[wi_Index].Comment) + 1);
                      //���R�[�h�敪
                      w_Kensa_Code_Save[wi_Index].Comment[Length(w_Kensa_Code_Save[wi_Index].Comment) - 1].RecKbn := func_RigthSpace(JISSICRECORDKBNLEN,GetString('KUBUN'));
                      //���ڃR�[�h
                      w_Kensa_Code_Save[wi_Index].Comment[Length(w_Kensa_Code_Save[wi_Index].Comment) - 1].KoumokuCd := func_RigthSpace(JISSICKMKCODELEN,GetString('ID'));
                      //���ڋ敪
                      w_Kensa_Code_Save[wi_Index].Comment[Length(w_Kensa_Code_Save[wi_Index].Comment) - 1].Comment := func_RigthSpace(JISSICCOMLEN,GetString('COM'));
                      //�\��
                      w_Kensa_Code_Save[wi_Index].Comment[Length(w_Kensa_Code_Save[wi_Index].Comment) - 1].Yobi := func_RigthSpace(JISSICYOBILEN,'');
                      Next;
                    end;
                  end;
                end;

                if not WB_Flg then
                begin
                  if Trim(wg_Memo) <> '' then
                  begin
                    //�\���̍쐬
                    SetLength(w_Kensa_Code_Save[wi_Index].Comment, Length(w_Kensa_Code_Save[wi_Index].Comment) + 1);
                    //���R�[�h�敪
                    w_Kensa_Code_Save[wi_Index].Comment[Length(w_Kensa_Code_Save[wi_Index].Comment) - 1].RecKbn := func_RigthSpace(JISSICRECORDKBNLEN,'98');
                    //���ڃR�[�h
                    w_Kensa_Code_Save[wi_Index].Comment[Length(w_Kensa_Code_Save[wi_Index].Comment) - 1].KoumokuCd := func_RigthSpace(JISSICKMKCODELEN,'');
                    //���ڋ敪
                    w_Kensa_Code_Save[wi_Index].Comment[Length(w_Kensa_Code_Save[wi_Index].Comment) - 1].Comment := func_RigthSpace(JISSICCOMLEN,wg_Memo);
                    //�\��
                    w_Kensa_Code_Save[wi_Index].Comment[Length(w_Kensa_Code_Save[wi_Index].Comment) - 1].Yobi := func_RigthSpace(JISSICYOBILEN,'');
                  end;
                  WB_Flg := True;
                end;
                //���א�
                w_Kensa_Code_Save[wi_Index].Meisai := func_LeftZero(JISSIMEISAICOUNTLEN,
                                             IntToStr(Length(w_Kensa_Code_Save[wi_Index].Yakuzai) + Length(w_Kensa_Code_Save[wi_Index].Comment)));
              end;
              //���̃��R�[�h�Ɉړ�
              Next;
              //��������
              Continue;
              wi_Yakuzai_Count := 0;
              wi_Zairyo_Count := 0;
              wi_Film_Count := 0;
              wi_Inf_Count := 0;
              wi_Com_Count := 0;
            end;
          end;
          //�\���̍쐬
          SetLength(wg_Kensa_Code,Length(wg_Kensa_Code) + 1);
          //���ʃC���f�b�N�X
          wi_Index := Length(wg_Kensa_Code) - 1;
          //�O���[�v�ԍ�
          //wg_Kensa_Code[wi_Index].GroupNo := func_LeftZero(JISSIGROUPLEN,Trim(GetString('NO')));
          wg_Kensa_Code[wi_Index].GroupNo := func_LeftZero(JISSIGROUPLEN,IntToStr(wi_Index + 1));
          //��v�敪
          wg_Kensa_Code[wi_Index].Account := arg_kaikei;
          //���{�̏ꍇ
          if Trim(GetString('SATUEISTATUS')) = CST_RISJISSI_Y then
            //���{�敪
            wg_Kensa_Code[wi_Index].ExKbn := CST_HISJISSI_Y
          //���~�̏ꍇ
          else if Trim(GetString('SATUEISTATUS')) = CST_RISJISSI_Z then
            //���{�敪
            wg_Kensa_Code[wi_Index].ExKbn := CST_HISJISSI_Z;

          //���ڃR�[�h
          //2018/08/30 ���ʏ��@�ύX
          //wg_Kensa_Code[wi_Index].Koumoku := func_RigthSpace(JISSIKMKCODELEN,Trim(GetString('BUISET_ID')));
          wkBuiID:= Trim(GetString('BUI_ID'));
          wg_Kensa_Code[wi_Index].Koumoku := func_RigthSpace(JISSIKMKCODELEN, Copy(wkBuiID, 1, 6));

          //�B�e��R�[�h
          wg_Kensa_Code[wi_Index].TypeID := func_RigthSpace(JISSIBUISATUEICODELEN,Trim(arg_TypeID));
          //���ʃR�[�h
          wkBuiID := '70' + Copy(wkBuiID, 7, 4);
          wg_Kensa_Code[wi_Index].BuiCode := func_RigthSpace(JISSIBUICODELEN, wkBuiID);
          //�������R�[�h
          wg_Kensa_Code[wi_Index].RoomCode := func_RigthSpace(JISSIKENSAROOMCODELEN,Trim(GetString('KENSASITU_ID')));
          //�|�[�^�u���i�Œ�j
          wg_Kensa_Code[wi_Index].Portble := ' ';
          //�����񐔁i�Œ�j
          wg_Kensa_Code[wi_Index].BuiCount := '0000';
          //������
          wi_Same_Code := 0;

          //--- ��� ---
          with FQ_SEL do begin
            //SQL�ݒ�
            sqlSelect := '';
            sqlSelect := sqlSelect + 'SELECT Pm.ZOUEIZAIIJITANNI_ID, Ez.PARTS_ID, Ez.SUURYOU_IJI';
            sqlSelect := sqlSelect + ' FROM EXZOUEIZAITABLE Ez, PARTSMASTER Pm';
            sqlSelect := sqlSelect + ' WHERE Ez.RIS_ID = :PRIS_ID';
            sqlSelect := sqlSelect + ' AND Ez.BUI_NO = :PBUI_NO';
            sqlSelect := sqlSelect + ' AND Ez.PARTS_ID = Pm.ZOUEIZAI_ID(+)';
            sqlSelect := sqlSelect + ' AND Pm.ZOUEIZAIKBN = :PZOUEIZAIKBN';
            sqlSelect := sqlSelect + ' ORDER BY Ez.NO';
            PrepareQuery(sqlSelect);
            //�p�����[�^
            //RIS_ID
            SetParam('PRIS_ID', FQ_SEL_ORD.GetString('RIS_ID'));
            //BUI_NO
            SetParam('PBUI_NO', FQ_SEL_BUI.GetString('NO'));
            //���e�܋敪�i20�F��܁j
            SetParam('PZOUEIZAIKBN', CST_RECORD_KBN_20);
            //SQL���s
            iRslt:= OpenQuery();
            if iRslt < 0 then begin
              //��O�G���[
              Result := False;
              //�ؒf
              wg_DBFlg := False;
              //�����I��
              Exit;
            end;
            rec_count := iRslt;
            //�\���̍쐬
            SetLength(wg_Kensa_Code[wi_Index].Yakuzai, 0);
            //���R�[�h������ꍇ
            if rec_count <> 0 then
            begin
              //����
              wi_Yakuzai_Count := rec_count;
              for wi_Loop_Yakuzai := 0 to wi_Yakuzai_Count - 1 do
              begin
                //������
                wb_Same_Flg := False;
                //�\���̂̒����瓯��ID��T��
                for wi_Same_Loop := 0 to Length(wg_Kensa_Code[wi_Index].Yakuzai) - 1 do
                begin
                  //����ID�̏ꍇ
                  if wg_Kensa_Code[wi_Index].Yakuzai[wi_Same_Loop].KoumokuCd = func_RigthSpace(JISSIYKMKCODELEN,GetString('PARTS_ID')) then
                  begin
                    //�t���O�ݒ�
                    wb_Same_Flg := True;
                    //����ID�C���f�b�N�X
                    wi_Same_Code := wi_Same_Loop;
                    inc(wi_Same_Count);
                    Break;
                  end;
                end;
                //����ID���Ȃ��ꍇ
                if not wb_Same_Flg then
                begin
                  //�\���̍쐬
                  SetLength(wg_Kensa_Code[wi_Index].Yakuzai, Length(wg_Kensa_Code[wi_Index].Yakuzai) + 1);
                  //���R�[�h�敪
                  wg_Kensa_Code[wi_Index].Yakuzai[Length(wg_Kensa_Code[wi_Index].Yakuzai) - 1].RecKbn := func_RigthSpace(JISSIYRECORDKBNLEN,CST_RECORD_KBN_20);
                  //���ڃR�[�h
                  wg_Kensa_Code[wi_Index].Yakuzai[Length(wg_Kensa_Code[wi_Index].Yakuzai) - 1].KoumokuCd := func_RigthSpace(JISSIYKMKCODELEN,GetString('PARTS_ID'));
                  //�I�[�_�g�p��
                  wg_Kensa_Code[wi_Index].Yakuzai[Length(wg_Kensa_Code[wi_Index].Yakuzai) - 1].Use := func_LeftZero(JISSIYORDERUSELEN,FloatToStr(StrToFloatDef(GetString('SUURYOU_IJI'), 0) * 10000));
                  //�P�ʃR�[�h
                  wg_Kensa_Code[wi_Index].Yakuzai[Length(wg_Kensa_Code[wi_Index].Yakuzai) - 1].Bunkatu := func_RigthSpace(JISSIYBUNKATULEN,'');
                  //�\��
                  wg_Kensa_Code[wi_Index].Yakuzai[Length(wg_Kensa_Code[wi_Index].Yakuzai) - 1].Yobi := func_RigthSpace(JISSIYYOBILEN,'');
                end
                //����ID����
                else
                begin
                  //���{�g�p��
                  wg_Kensa_Code[wi_Index].Yakuzai[wi_Same_Code].Use :=
                               func_LeftZero(JISSIYORDERUSELEN,FloatToStr(
                                             StrToIntDef(wg_Kensa_Code[wi_Index].Yakuzai[wi_Same_Code].Use,0) +
                                             (StrToFloatDef(GetString('SUURYOU_IJI'), 0) * 10000)));
                end;
                Next;
              end;
            end;
          end;
          //������
          wi_Same_Code := 0;
          //--- �ޗ� ---

          with FQ_SEL do begin
            //SQL�ݒ�
            sqlSelect := '';
            sqlSelect := sqlSelect + 'SELECT Pm.ZOUEIZAIIJITANNI_ID, Ez.PARTS_ID, Ez.SUURYOU_IJI';
            sqlSelect := sqlSelect + ' FROM EXZOUEIZAITABLE Ez, PARTSMASTER Pm';
            sqlSelect := sqlSelect + ' WHERE Ez.RIS_ID = :PRIS_ID';
            sqlSelect := sqlSelect + ' AND Ez.BUI_NO = :PBUI_NO';
            sqlSelect := sqlSelect + ' AND Ez.PARTS_ID = Pm.ZOUEIZAI_ID(+)';
            sqlSelect := sqlSelect + ' AND Pm.ZOUEIZAIKBN = :PZOUEIZAIKBN';
            sqlSelect := sqlSelect + ' ORDER BY Ez.NO';
            PrepareQuery(sqlSelect);
            //�p�����[�^
            //RIS_ID
            SetParam('PRIS_ID', FQ_SEL_ORD.GetString('RIS_ID'));
            //BUI_NO
            SetParam('PBUI_NO', FQ_SEL_BUI.GetString('NO'));
            //���e�܋敪�i50�F�ޗ��j
            SetParam('PZOUEIZAIKBN', CST_RECORD_KBN_50);
            //SQL���s
            iRslt:= OpenQuery();
            if iRslt < 0 then begin
              //��O�G���[
              Result := False;
              //�ؒf
              wg_DBFlg := False;
              //�����I��
              Exit;
            end;
            rec_count := iRslt;
            //���R�[�h������ꍇ
            if rec_count <> 0 then
            begin
              //����
              wi_Zairyo_Count := rec_count;
              for wi_Loop_Film := 0 to wi_Zairyo_Count - 1 do
              begin
                //������
                wb_Same_Flg := False;
                //�\���̂̒����瓯��ID��T��
                for wi_Same_Loop := 0 to Length(wg_Kensa_Code[wi_Index].Yakuzai) - 1 do
                begin
                  //����ID�̏ꍇ
                  if (wg_Kensa_Code[wi_Index].Yakuzai[wi_Same_Loop].KoumokuCd = func_RigthSpace(JISSIYKMKCODELEN,GetString('PARTS_ID'))) and
                     (wg_Kensa_Code[wi_Index].Yakuzai[wi_Same_Loop].RecKbn = CST_RECORD_KBN_50) then
                  begin
                    //�t���O�ݒ�
                    wb_Same_Flg := True;
                    //����ID�C���f�b�N�X
                    wi_Same_Code := wi_Same_Loop;
                    inc(wi_Same_Count);
                    Break;
                  end;
                end;
                //����ID���Ȃ��ꍇ
                if not wb_Same_Flg then
                begin
                  //�\���̍쐬
                  SetLength(wg_Kensa_Code[wi_Index].Yakuzai, Length(wg_Kensa_Code[wi_Index].Yakuzai) + 1);
                  //���R�[�h�敪
                  wg_Kensa_Code[wi_Index].Yakuzai[Length(wg_Kensa_Code[wi_Index].Yakuzai) - 1].RecKbn := func_RigthSpace(JISSIYRECORDKBNLEN,CST_RECORD_KBN_50);
                  //���ڃR�[�h
                  wg_Kensa_Code[wi_Index].Yakuzai[Length(wg_Kensa_Code[wi_Index].Yakuzai) - 1].KoumokuCd := func_RigthSpace(JISSIYKMKCODELEN,GetString('PARTS_ID'));
                  //�g�p��
                  wg_Kensa_Code[wi_Index].Yakuzai[Length(wg_Kensa_Code[wi_Index].Yakuzai) - 1].Use := func_LeftZero(JISSIYORDERUSELEN,FloatToStr(StrToFloatDef(GetString('SUURYOU_IJI'), 0) * 10000));
                  //������
                  wg_Kensa_Code[wi_Index].Yakuzai[Length(wg_Kensa_Code[wi_Index].Yakuzai) - 1].Bunkatu := func_LeftZero(JISSIYBUNKATULEN,'');
                  //�\��
                  wg_Kensa_Code[wi_Index].Yakuzai[Length(wg_Kensa_Code[wi_Index].Yakuzai) - 1].Yobi := func_RigthSpace(JISSIYYOBILEN,'');
                end
                //����ID����
                else
                begin
                  //�g�p��
                  wg_Kensa_Code[wi_Index].Yakuzai[wi_Same_Code].Use :=
                               func_LeftZero(JISSIYORDERUSELEN,FloatToStr(
                               StrToIntDef(wg_Kensa_Code[wi_Index].Yakuzai[wi_Same_Code].Use,0) +
                               (StrToFloatDef(GetString('SUURYOU_IJI'), 0) * 10000)));
                end;
                Next;
              end;
            end;
            //������
            wi_Same_Code := 0;
            //--- �t�B���� ---
            //SQL�ݒ�
            sqlSelect := '';
            sqlSelect := sqlSelect + 'SELECT Fm.ZOUEIZAITANNI_ID, Ef.FILM_ID, Ef.PARTITION, Ef.USED, Ef.LOSS';
            sqlSelect := sqlSelect + ' FROM EXFILMTABLE Ef, FILMMASTER Fm';
            sqlSelect := sqlSelect + ' WHERE Ef.RIS_ID = :PRIS_ID';
            sqlSelect := sqlSelect + ' AND Ef.BUI_NO = :PBUI_NO';
            sqlSelect := sqlSelect + ' AND Ef.FILM_ID = Fm.FILM_ID(+)';
            sqlSelect := sqlSelect + ' ORDER BY Ef.NO';
            PrepareQuery(sqlSelect);
            //�p�����[�^
            //RIS_ID
            SetParam('PRIS_ID', FQ_SEL_ORD.GetString('RIS_ID'));
            //BUI_NO
            SetParam('PBUI_NO', FQ_SEL_BUI.GetString('NO'));
            //SQL���s
            iRslt:= OpenQuery();
            if iRslt < 0 then begin
              //��O�G���[
              Result := False;
              //�ؒf
              wg_DBFlg := False;
              //�����I��
              Exit;
            end;
            rec_count := iRslt;
            //���R�[�h������ꍇ
            if rec_count <> 0 then
            begin
              //����
              wi_Film_Count := rec_count;
              for wi_Loop_Film := 0 to wi_Film_Count - 1 do
              begin
                //������
                wb_Same_Flg := False;
                //�\���̂̒����瓯��ID��T��
                for wi_Same_Loop := 0 to Length(wg_Kensa_Code[wi_Index].Yakuzai) - 1 do
                begin
                  //����ID�̏ꍇ
                  if (wg_Kensa_Code[wi_Index].Yakuzai[wi_Same_Loop].KoumokuCd = func_RigthSpace(JISSIYKMKCODELEN,GetString('FILM_ID'))) and
                     (wg_Kensa_Code[wi_Index].Yakuzai[wi_Same_Loop].Bunkatu = func_LeftZero(JISSIYBUNKATULEN,GetString('PARTITION'))) and
                     (wg_Kensa_Code[wi_Index].Yakuzai[wi_Same_Loop].RecKbn = CST_RECORD_KBN_57) then
                  begin
                    //�t���O�ݒ�
                    wb_Same_Flg := True;
                    //����ID�C���f�b�N�X
                    wi_Same_Code := wi_Same_Loop;
                    inc(wi_Same_Count);
                    Break;
                  end;
                end;
                //����ID���Ȃ��ꍇ
                if not wb_Same_Flg then
                begin
                  //�\���̍쐬
                  SetLength(wg_Kensa_Code[wi_Index].Yakuzai, Length(wg_Kensa_Code[wi_Index].Yakuzai) + 1);
                  //���R�[�h�敪
                  wg_Kensa_Code[wi_Index].Yakuzai[Length(wg_Kensa_Code[wi_Index].Yakuzai) - 1].RecKbn := func_RigthSpace(JISSIYRECORDKBNLEN,CST_RECORD_KBN_57);
                  //���ڃR�[�h
                  wg_Kensa_Code[wi_Index].Yakuzai[Length(wg_Kensa_Code[wi_Index].Yakuzai) - 1].KoumokuCd := func_RigthSpace(JISSIYKMKCODELEN,GetString('FILM_ID'));
                  //�g�p��
                  wg_Kensa_Code[wi_Index].Yakuzai[Length(wg_Kensa_Code[wi_Index].Yakuzai) - 1].Use := func_LeftZero(JISSIYORDERUSELEN,FloatToStr(StrToFloatDef(GetString('USED'), 0) * 10000));
                  //������
                  wg_Kensa_Code[wi_Index].Yakuzai[Length(wg_Kensa_Code[wi_Index].Yakuzai) - 1].Bunkatu := func_LeftZero(JISSIYBUNKATULEN,GetString('PARTITION'));
                  //�\��
                  wg_Kensa_Code[wi_Index].Yakuzai[Length(wg_Kensa_Code[wi_Index].Yakuzai) - 1].Yobi := func_RigthSpace(JISSIYYOBILEN,'');
                end
                //����ID����
                else
                begin
                  //�g�p��
                  wg_Kensa_Code[wi_Index].Yakuzai[wi_Same_Code].Use :=
                               func_LeftZero(JISSIYORDERUSELEN,FloatToStr(
                               StrToIntDef(wg_Kensa_Code[wi_Index].Yakuzai[wi_Same_Code].Use,0) +
                               (StrToFloatDef(GetString('USED'), 0) * 10000)));
                end;
                Next;
              end;
            end;
          end;
          //������
          wi_Same_Code := 0;
          //--- ��Z ---
          with FQ_SEL do begin
            //SQL�ݒ�
            sqlSelect := '';
            sqlSelect := sqlSelect + 'SELECT Ei.INFUSE_ID,Ei.SUURYOU_IJI,Im.INFUSEKBN';
            sqlSelect := sqlSelect + ' FROM EXINFUSETABLE Ei, INFUSEMASTER Im';
            sqlSelect := sqlSelect + ' WHERE Ei.RIS_ID = :PRIS_ID';
            sqlSelect := sqlSelect + ' AND Ei.BUI_NO = :PBUI_NO';
            sqlSelect := sqlSelect + ' AND Ei.INFUSE_ID = Im.INFUSE_ID(+)';
            sqlSelect := sqlSelect + ' AND Im.INFUSEKBN = :PINFUSEKBN1';
            sqlSelect := sqlSelect + ' ORDER BY Im.INFUSEKBN,Ei.NO';
            PrepareQuery(sqlSelect);
            //�p�����[�^
            //RIS_ID
            SetParam('PRIS_ID', FQ_SEL_ORD.GetString('RIS_ID'));
            //BUI_NO
            SetParam('PBUI_NO', FQ_SEL_BUI.GetString('NO'));
            //BUI_NO
            SetParam('PINFUSEKBN1', CST_RECORD_KBN_30);
            //SQL���s
            iRslt:= OpenQuery();
            if iRslt < 0 then begin
              //��O�G���[
              Result := False;
              //�ؒf
              wg_DBFlg := False;
              //�����I��
              Exit;
            end;
            rec_count := iRslt;
            //���R�[�h������ꍇ
            if rec_count <> 0 then
            begin
              //����
              wi_Inf_Count := rec_count;
              for wi_Loop_Inf := 0 to wi_Inf_Count - 1 do
              begin
                //������
                wb_Same_Flg := False;
                //�\���̂̒����瓯��ID��T��
                for wi_Same_Loop := 0 to Length(wg_Kensa_Code[wi_Index].Yakuzai) - 1 do
                begin
                  //����ID�̏ꍇ
                  if (wg_Kensa_Code[wi_Index].Yakuzai[wi_Same_Loop].KoumokuCd = func_RigthSpace(JISSIYKMKCODELEN,GetString('INFUSE_ID'))) and
                     (wg_Kensa_Code[wi_Index].Yakuzai[wi_Same_Loop].RecKbn = CST_RECORD_KBN_30) then
                  begin
                    //�t���O�ݒ�
                    wb_Same_Flg := True;
                    //����ID�C���f�b�N�X
                    wi_Same_Code := wi_Same_Loop;
                    inc(wi_Same_Count);
                    Break;
                  end;
                end;
                //����ID���Ȃ��ꍇ
                if not wb_Same_Flg then
                begin
                  //�\���̍쐬
                  SetLength(wg_Kensa_Code[wi_Index].Yakuzai, Length(wg_Kensa_Code[wi_Index].Yakuzai) + 1);
                  //���R�[�h�敪
                  wg_Kensa_Code[wi_Index].Yakuzai[Length(wg_Kensa_Code[wi_Index].Yakuzai) - 1].RecKbn := func_RigthSpace(JISSIYRECORDKBNLEN,CST_RECORD_KBN_30);
                  //���ڃR�[�h
                  wg_Kensa_Code[wi_Index].Yakuzai[Length(wg_Kensa_Code[wi_Index].Yakuzai) - 1].KoumokuCd := func_RigthSpace(JISSIYKMKCODELEN,GetString('INFUSE_ID'));
                  //��
                  wg_Kensa_Code[wi_Index].Yakuzai[Length(wg_Kensa_Code[wi_Index].Yakuzai) - 1].Use := func_LeftZero(JISSIYORDERUSELEN,FloatToStr(StrToFloatDef(GetString('SUURYOU_IJI'), 0) * 10000));

                  //������Z
                  wg_Kensa_Code[wi_Index].Yakuzai[Length(wg_Kensa_Code[wi_Index].Yakuzai) - 1].Bunkatu := func_RigthSpace(JISSIYBUNKATULEN,'');
                  //�\��
                  wg_Kensa_Code[wi_Index].Yakuzai[Length(wg_Kensa_Code[wi_Index].Yakuzai) - 1].Yobi := func_RigthSpace(JISSIYYOBILEN,'');
                end
                //����ID����
                else
                begin
                  //��
                  //wg_Kensa_Code[wi_Index].Yakuzai[wi_Same_Code].Use := func_LeftZero(JISSIYORDERUSELEN,IntToStr(StrToIntDef(wg_Kensa_Code[wi_Index].Yakuzai[wi_Same_Code].Use,0) + StrToIntDef(GetString('SUURYOU_IJI'),0)));
                  wg_Kensa_Code[wi_Index].Yakuzai[wi_Same_Code].Use :=
                               func_LeftZero(JISSIYORDERUSELEN,FloatToStr(
                               StrToIntDef(wg_Kensa_Code[wi_Index].Yakuzai[wi_Same_Code].Use,0) +
                               (StrToFloatDef(GetString('SUURYOU_IJI'), 0) * 10000)));
                end;
                Next;
              end;
            end;
          end;
          //--- �R�����g ---
          with FQ_SEL do begin
            //SQL�ݒ�
            sqlSelect := '';
            sqlSelect := sqlSelect + 'SELECT KUBUN,ID,COM';
            sqlSelect := sqlSelect + ' FROM ORDERDETAILTABLE_MMH';
            sqlSelect := sqlSelect + ' WHERE RIS_ID = :PRIS_ID';
            sqlSelect := sqlSelect + ' AND NO = :PBUI_NO';
            sqlSelect := sqlSelect + ' ORDER BY COMNO';
            PrepareQuery(sqlSelect);
            //�p�����[�^
            //RIS_ID
            SetParam('PRIS_ID', FQ_SEL_ORD.GetString('RIS_ID'));
            //BUI_NO
            SetParam('PBUI_NO', FQ_SEL_BUI.GetString('NO'));
            //SQL���s
            iRslt:= OpenQuery();
            if iRslt < 0 then begin
              //��O�G���[
              Result := False;
              //�ؒf
              wg_DBFlg := False;
              //�����I��
              Exit;
            end;
            rec_count := iRslt;
            //���R�[�h������ꍇ
            if rec_count <> 0 then
            begin
              //����
              wi_Inf_Count := rec_count;
              for wi_Loop_Inf := 0 to wi_Inf_Count - 1 do
              begin
                //�\���̍쐬
                SetLength(wg_Kensa_Code[wi_Index].Comment, Length(wg_Kensa_Code[wi_Index].Comment) + 1);
                //���R�[�h�敪
                wg_Kensa_Code[wi_Index].Comment[Length(wg_Kensa_Code[wi_Index].Comment) - 1].RecKbn := func_RigthSpace(JISSICRECORDKBNLEN,GetString('KUBUN'));
                //���ڃR�[�h
                wg_Kensa_Code[wi_Index].Comment[Length(wg_Kensa_Code[wi_Index].Comment) - 1].KoumokuCd := func_RigthSpace(JISSICKMKCODELEN,GetString('ID'));
                //���ڋ敪
                wg_Kensa_Code[wi_Index].Comment[Length(wg_Kensa_Code[wi_Index].Comment) - 1].Comment := func_RigthSpace(JISSICCOMLEN,GetString('COM'));
                //�\��
                wg_Kensa_Code[wi_Index].Comment[Length(wg_Kensa_Code[wi_Index].Comment) - 1].Yobi := func_RigthSpace(JISSICYOBILEN,'');
                Next;
              end;
            end;
          end;
          if not WB_Flg2 then
          begin
            if Trim(wg_Memo) <> '' then
            begin
              //�\���̍쐬
              SetLength(wg_Kensa_Code[wi_Index].Comment, Length(wg_Kensa_Code[wi_Index].Comment) + 1);
              //���R�[�h�敪
              wg_Kensa_Code[wi_Index].Comment[Length(wg_Kensa_Code[wi_Index].Comment) - 1].RecKbn := func_RigthSpace(JISSICRECORDKBNLEN,'99');
              //���ڃR�[�h
              wg_Kensa_Code[wi_Index].Comment[Length(wg_Kensa_Code[wi_Index].Comment) - 1].KoumokuCd := func_RigthSpace(JISSICKMKCODELEN,'');
              //���ڋ敪
              wg_Kensa_Code[wi_Index].Comment[Length(wg_Kensa_Code[wi_Index].Comment) - 1].Comment := func_RigthSpace(JISSICCOMLEN,wg_Memo);
              //�\��
              wg_Kensa_Code[wi_Index].Comment[Length(wg_Kensa_Code[wi_Index].Comment) - 1].Yobi := func_RigthSpace(JISSICYOBILEN,'');
            end;
            WB_Flg2 := True;
          end;
          //���א�
          wg_Kensa_Code[wi_Index].Meisai := func_LeftZero(JISSIMEISAICOUNTLEN,
                                             IntToStr(Length(wg_Kensa_Code[wi_Index].Yakuzai) + Length(wg_Kensa_Code[wi_Index].Comment)));
          //���̃��R�[�h�Ɉړ�
          Next;
          wi_Same_Count := 0;
          wi_Yakuzai_Count := 0;
          wi_Zairyo_Count := 0;
          wi_Film_Count := 0;
          wi_Inf_Count := 0;
          wi_Com_Count := 0;
        end;
      end;
    end;

    //�\�񂠂��
    //���ʏ��Ȃ���
    //���~��񂪂���ꍇ
    if (wb_Yoyaku_Flg) and
       (Length(wg_Kensa_Code) = 0) and
       (Length(w_Kensa_Code_Save) <> 0) then
    begin
      //�\���̍쐬
      SetLength(wg_Kensa_Code,1);
      wg_Kensa_Code[0].GroupNo  :=  w_Kensa_Code_Save[0].GroupNo;
      wg_Kensa_Code[0].Account  :=  w_Kensa_Code_Save[0].Account;
      wg_Kensa_Code[0].ExKbn    :=  w_Kensa_Code_Save[0].ExKbn;
      wg_Kensa_Code[0].Koumoku  :=  w_Kensa_Code_Save[0].Koumoku;
      wg_Kensa_Code[0].TypeID   :=  w_Kensa_Code_Save[0].TypeID;
      wg_Kensa_Code[0].BuiCode  :=  w_Kensa_Code_Save[0].BuiCode;
      wg_Kensa_Code[0].RoomCode :=  w_Kensa_Code_Save[0].RoomCode;
      wg_Kensa_Code[0].Operator :=  w_Kensa_Code_Save[0].Operator;
      wg_Kensa_Code[0].BuiCount :=  w_Kensa_Code_Save[0].BuiCount;
      wg_Kensa_Code[0].Portble  :=  w_Kensa_Code_Save[0].Portble;
      wg_Kensa_Code[0].Meisai   :=  w_Kensa_Code_Save[0].Meisai;
      SetLength(wg_Kensa_Code[0].Yakuzai,Length(w_Kensa_Code_Save[0].Yakuzai));
      if Length(wg_Kensa_Code[0].Yakuzai) > 0 then
      begin
        wg_Kensa_Code[0].Yakuzai[0].RecKbn    := w_Kensa_Code_Save[0].Yakuzai[0].RecKbn;
        wg_Kensa_Code[0].Yakuzai[0].KoumokuCd := w_Kensa_Code_Save[0].Yakuzai[0].KoumokuCd;
        wg_Kensa_Code[0].Yakuzai[0].Use       := w_Kensa_Code_Save[0].Yakuzai[0].Use;
        wg_Kensa_Code[0].Yakuzai[0].Bunkatu   := w_Kensa_Code_Save[0].Yakuzai[0].Bunkatu;
        wg_Kensa_Code[0].Yakuzai[0].Yobi      := w_Kensa_Code_Save[0].Yakuzai[0].Yobi;
      end;
      SetLength(wg_Kensa_Code[0].Comment,Length(w_Kensa_Code_Save[0].Comment));
      if Length(wg_Kensa_Code[0].Comment) > 0 then
      begin
        wg_Kensa_Code[0].Comment[0].RecKbn    := w_Kensa_Code_Save[0].Comment[0].RecKbn;
        wg_Kensa_Code[0].Comment[0].KoumokuCd := w_Kensa_Code_Save[0].Comment[0].KoumokuCd;
        wg_Kensa_Code[0].Comment[0].Comment   := w_Kensa_Code_Save[0].Comment[0].Comment;
        wg_Kensa_Code[0].Comment[0].Yobi      := w_Kensa_Code_Save[0].Comment[0].Yobi;
      end;
    end;
    //����I������
    arg_ErrMsg := '';
    //�����I��
    Exit;
  except
    on E: Exception do begin
      //�G���[�I������
      Result := False;
      //�G���[��ԃ��b�Z�[�W�擾
      arg_ErrMsg := CST_KENSAERR_MSG + E.Message;
      wg_DBFlg := False;
      //�����I��
      Exit;
    end;
  end;
end;
{
-----------------------------------------------------------------------------
  ���O :func_Get_OffSet
  ���� :
    arg_No:Integer     ����No
    arg_OffSet:Integer �I�t�Z�b�g�ʒu
  ���A�l�F��O�Ȃ�
  �@�\ :
    1. �I�t�Z�b�g�ʒu�ɁA�w��̍��ڃT�C�Y��ǉ��������̂�ϊ�
 *
-----------------------------------------------------------------------------
}
function TDB_RisSD.func_Get_OffSet(arg_No,arg_OffSet:Integer): Integer;
var
  w_size  :integer;
  w_StremField : TStreamField;
begin
  inherited;
  //�w��d�����ڂ̏��擾
  w_StremField := func_FindMsgField(G_MSG_SYSTEM_C,G_MSGKIND_JISSI,arg_No);
  //�T�C�Y
  w_size   := w_StremField.size;
  //�T�C�Y���i�߂�
  Result := arg_Offset + w_size;
end;
{
-----------------------------------------------------------------------------
  ���O :func_DelOrder
  ���� :
    arg_Keep:integer      �ۑ����� ��
    var arg_ErrMsg:string �G���[���F�ڍ׌��� ���펞�F''
  ���A�l�F��O�Ȃ�  True ���� False �ُ�
  �@�\ :
    1. ���M�I�[�_�e�[�u�����瑗�M�ς݂��ۑ����Ԃ̉߂������R�[�h��
    �폜�B
    2. Commit����B
 *
-----------------------------------------------------------------------------
}
function  TDB_RisSD.func_DelOrder(
    arg_Keep:integer;
    var arg_ErrMsg:string
    ):boolean;
var
  iRslt:    Integer;
  sqlExec:  String;
  isCommit: Boolean;
begin
  //�߂�l
  Result := True;
  iRslt := 0;
  isCommit := False;
  try
    //�g�����U�N�V�����J�n
    FDB.StartTransaction;
    try
      with FQ_ALT do begin
        //SQL������쐬
        sqlExec := '';
        sqlExec := sqlExec + 'DELETE FROM TOHISINFO';
        sqlExec := sqlExec + ' WHERE TRANSFERSTATUS = ''' + CST_SOUSIN_FLG + '''';
        sqlExec := sqlExec + ' AND REQUESTDATE < ( SYSDATE - ' + IntToStr(arg_Keep) + ')';
        sqlExec := sqlExec + ' AND (REQUESTTYPE = ''' + CST_APPTYPE_OP01 + ''' OR REQUESTTYPE = ''' + CST_APPTYPE_OP02 + ''' OR REQUESTTYPE = ''' + CST_APPTYPE_OP99 + ''')';
        //SQL�ݒ�
        PrepareQuery(sqlExec);
        //SQL���s
        iRslt:= ExecSQL();
        if iRslt < 0 then begin
          //���s
          Result := False;
          //�ؒf
          wg_DBFlg := False;
          //
          Exit;
        end;
      end;
      //����
      Result := True;
      isCommit := True;
    except
      on E: Exception do
      begin
        //�G���[�I������
        Result := False;
        //�G���[��ԃ��b�Z�[�W�擾
        arg_ErrMsg := CST_DELERR_MSG + E.Message;
        //DB�ؒf
        wg_DBFlg := False;
        //�����I��
        Exit;
      end;
    end;
  finally
    if isCommit = True then begin
      //�R�~�b�g
      FDB.Commit;
    end
    else begin
      //���[���o�b�N
      FDB.Rollback;
    end;
  end;

end;
{
-----------------------------------------------------------------------------
  ���O :func_ExtendExamInfo
  ���� :
    var arg_kaikei:string    ��v�t���O
        arg_ErrMsg:string    �G���[���F�ڍ׌��� ���펞�F''
        arg_NullFlg:String   �f�[�^�Ȃ��F'1' ���펞�F''
  ���A�l�F��O�Ȃ� True ���� False �ُ�
  �@�\ :
    1. ���M���R�[�h�̊g�����я����擾���܂��B
 *
-----------------------------------------------------------------------------
}
{
function TDB_RisSD.func_ToHISInfo(var arg_Date,
                                      arg_Time,
                                      arg_ErrMsg,
                                      arg_NullFlg:string):Boolean;
var
  w_iCount:Integer;
begin
  //�߂�l
  Result := True;
  try
    try
      //�g�����я��擾SQL���쐬
      with TQ_Etc do begin
        //����
        Close;
        //SQL�����N���A
        SQL.Clear;
        //SQL���쐬
        SQL.Add('SELECT REQUESTDATE');
        SQL.Add('FROM TOHISINFO');
        SQL.Add('WHERE RIS_ID = :PRIS_ID');
        SQL.Add('  AND REQUESTTYPE = :PREQUESTTYPE');
        SQL.Add('ORDER BY REQUESTDATE');

        //Where��
        //RIS_ID
        ParamByName('PRIS_ID').AsString := TQ_Order.FieldByName('RIS_ID').AsString;
        ParamByName('PREQUESTTYPE').AsString := CST_APPTYPE_OP01;

        //�J��
        Open;
        //�Ō�̃��R�[�h�Ɉړ�
        Last;
        //�ŏ��̃��R�[�h�Ɉړ�
        First;
        //2001.12.13
        w_iCount := RecordCount;
        if w_iCount <> 0 then begin
          arg_Date := FormatDateTime('YYYYMMDD', FieldByName('REQUESTDATE').AsDateTime);
          arg_Time := FormatDateTime('HHMM', FieldByName('REQUESTDATE').AsDateTime);
        end
        else begin
          //����
          Close;
          //SQL�����N���A
          SQL.Clear;
          //SQL���쐬
          SQL.Add('SELECT REQUESTDATE');
          SQL.Add('FROM TOHISINFO');
          SQL.Add('WHERE RIS_ID = :PRIS_ID');
          SQL.Add('  AND REQUESTTYPE = :PREQUESTTYPE');
          SQL.Add('ORDER BY REQUESTDATE');

          //Where��
          //RIS_ID
          ParamByName('PRIS_ID').AsString := TQ_Order.FieldByName('RIS_ID').AsString;
          ParamByName('PREQUESTTYPE').AsString := CST_APPTYPE_OP02;

          //�J��
          Open;
          //�Ō�̃��R�[�h�Ɉړ�
          Last;
          //�ŏ��̃��R�[�h�Ɉړ�
          First;
          //2001.12.13
          w_iCount := RecordCount;
          if w_iCount <> 0 then begin
            arg_Date := FormatDateTime('YYYYMMDD', FieldByName('REQUESTDATE').AsDateTime);
            arg_Time := FormatDateTime('HHMM', FieldByName('REQUESTDATE').AsDateTime);
          end
          else
          begin
            //����
            Close;
            //SQL�����N���A
            SQL.Clear;
            //SQL���쐬
            SQL.Add('SELECT REQUESTDATE');
            SQL.Add('FROM TOHISINFO');
            SQL.Add('WHERE RIS_ID = :PRIS_ID');
            SQL.Add('  AND REQUESTTYPE = :PREQUESTTYPE');
            SQL.Add('ORDER BY REQUESTDATE');

            //Where��
            //RIS_ID
            ParamByName('PRIS_ID').AsString := TQ_Order.FieldByName('RIS_ID').AsString;
            ParamByName('PREQUESTTYPE').AsString := CST_APPTYPE_OP99;

            //�J��
            Open;
            //�Ō�̃��R�[�h�Ɉړ�
            Last;
            //�ŏ��̃��R�[�h�Ɉړ�
            First;
            //2001.12.13
            w_iCount := RecordCount;
            if w_iCount <> 0 then begin
              arg_Date := FormatDateTime('YYYYMMDD', FieldByName('REQUESTDATE').AsDateTime);
              arg_Time := FormatDateTime('HHMM', FieldByName('REQUESTDATE').AsDateTime);
            end
            else
            begin
              arg_NullFlg := '1';
            end;
          end;
        end;
      end;
      //����I������
      arg_ErrMsg := '';
      //�����I��
      Exit;
    except
      on E: Exception do begin
        //�G���[�I������
        Result := False;
        //�ؒf
        wg_DBFlg := False;
        //�G���[��ԃ��b�Z�[�W�擾
        arg_ErrMsg := CST_GETTOHISERR_MSG + E.Message;
        //�����I��
        Exit;
      end;
    end;
  finally
    TQ_Etc.Close;
  end;
end;
}
end.
