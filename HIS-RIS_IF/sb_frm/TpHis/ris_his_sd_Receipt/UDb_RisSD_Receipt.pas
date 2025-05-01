unit UDb_RisSD_Receipt;
(**
���@�\����
  HIS�ւ̑��M�T�[�r�X�p��RisDB�ւ̃A�N�Z�X����

������
�V�K�쐬�F2004.09.27�F�S�� ���c �F
*)

interface

uses
//�V�X�e���|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, IniFiles,
  ScktComp,SvcMgr, //Db, DBTables,
//�v���_�N�g�J�����ʁ|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|
  Gval,
  HisMsgDef,
  HisMsgDef06_RCE,
  TcpSocket,
  Unit_Log, Unit_DB
  ;
type
  TDB_RisSD_Receipt = class    //RIS DB
    (*
    TQ_Order: TQuery;        //TensouOrderTable_�]���I�[�_�e�[�u��
    TQ_ExMainTable: TQuery;  //ExMainTable_���у��C���e�[�u��
    TQ_Etc: TQuery;          //�敪
    TQ_DateTime: TQuery;     //����
    *)
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
    function  RisDBOpen(var arg_Flg    : Boolean;
                        var arg_ErrMsg : String;
                            arg_Svc    : TService
                        ): Boolean;
    procedure RisDBClose;
    function  func_GetOrder(var rec_count: Integer;var arg_ErrMsg: String): Boolean;
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
    (*
    function  func_GetSysDate:string;
    *)
    function  func_SetOrderResult(
                 arg_Msg:TStringStream;
                 arg_SendDate:string;
                 arg_Result:string;
                 var arg_ErrMsg:string
                 ):boolean;
    function func_OrderMain(
                            var arg_PatientID,
                                arg_OrderNo,
                                arg_StartDate,
                                arg_StartTime,
                                arg_ErrMsg,
                                arg_NullFlg: String
                            ):Boolean;
    function func_ExMain(var arg_Tantou,
                             arg_ErrMsg,
                             arg_NullFlg:string):Boolean;
    function  func_DelOrder(
                 arg_Keep:integer;
                 var arg_ErrMsg:string
                 ):boolean;

  end;

const
  CST_ORDER_RES_OK  = 'OK';  //�F���M����
  CST_ORDER_RES_NG1 = 'NG1'; //�F���M���s �ʐM�s��
  CST_ORDER_RES_NG2 = 'NG2'; //�F���M���s �d��NG
  CST_ORDER_RES_NG3 = 'NG3'; //�F���M���s �d��NG(���g���C��)
  CST_ORDER_RES_CL =  'CL';  //�F���M�L�����Z��

var
  DB_RisSD_Receipt: TDB_RisSD_Receipt;

implementation


const
//�G���[�����ꏊ���胁�b�Z�[�W
CST_DELERR_MSG = '�ۑ����Ԃ��߂������R�[�h�̍폜���ɃG���[���N���܂����B';
CST_GETORDERERR_MSG = '�����M���R�[�h�擾���ɃG���[���N���܂����B';
CST_GETMAINERR_MSG = '�d���쐬���A�I�[�_���C���e�[�u�����擾�G���[���N���܂����B';
CST_TEN_HOZONERR_MSG = '�d���ۑ����ɃG���[���N���܂����B';
CST_KENSACHKERR_MSG = '�����i���`�F�b�N���ɃG���[���N���܂����B';
CST_KEKKAERR_MSG = '���M���ʕۑ����ɃG���[���N���܂����B';
CST_JISSIHOZONERR_MSG = '���ё��엚�����e�[�u���ۑ����ɃG���[���N���܂����B';
CST_GETEXMAINERR_MSG = '�d���쐬���A���у��C���e�[�u�����擾�G���[���N���܂����B';

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
function TDB_RisSD_Receipt.RisDBOpen(var arg_Flg    : Boolean;
                                     var arg_ErrMsg : String;
                                         arg_Svc    : TService):Boolean;
var
  RetryCnt: integer;
begin
  //�߂�l
  Result := True;

  //���O�쐬
  if not Assigned(FLog) then begin
    FLog := T_FileLog.Create(g_DBLOG02_PATH,
                             g_DBLOG02_PREFIX,
                             g_DBLOG02_LOGGING,
                             g_DBLOG02_KEEPDAYS,
                             g_LogFileSize, //2018/08/30 ���O�t�@�C���ύX
                             nil);
  end;
  if not Assigned(FDebug) then begin
    FDebug := T_FileLog.Create(g_DBLOGDBG02_PATH,
                               g_DBLOGDBG02_PREFIX,
                               g_DBLOGDBG02_LOGGING,
                               g_DBLOGDBG02_KEEPDAYS,
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
  //�߂�l
  Result := True;
  //DB�ڑ�������Ă��Ȃ��ꍇ
  if (not arg_Flg) or (not DatabaseRis.Connected) then
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
            arg_Flg := True;
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
        if DatabaseRis.Connected then
        begin
          //�x�z����Qery�ɐݒ�
          TQ_Order.Close;
          if TQ_Order.DatabaseName <> DatabaseRis.DatabaseName then
            TQ_Order.DatabaseName := DatabaseRis.DatabaseName;

          TQ_ExMainTable.Close;
          if TQ_ExMainTable.DatabaseName <> DatabaseRis.DatabaseName then
            TQ_ExMainTable.DatabaseName := DatabaseRis.DatabaseName;

          TQ_Etc.Close;
          if TQ_Etc.DatabaseName <> DatabaseRis.DatabaseName then
            TQ_Etc.DatabaseName := DatabaseRis.DatabaseName;

          TQ_DateTime.Close;
          if TQ_DateTime.DatabaseName <> DatabaseRis.DatabaseName then
            TQ_DateTime.DatabaseName := DatabaseRis.DatabaseName;
          //�G���[�Ȃ�
          arg_ErrMsg := '';
        end;
        //�����I��
        Exit;
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
          arg_Flg := False;
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
        arg_Flg := False;
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
procedure TDB_RisSD_Receipt.RisDBClose;
begin
  wg_DBFlg := False;
  try
    FDB.DBDisConnect();
  except
  end;
  (*
  try
    TQ_Order.Close;
    TQ_ExMainTable.Close;
    TQ_Etc.Close;
    TQ_DateTime.Close;
    if DatabaseRis <> nil then
    begin
      DatabaseRis.Connected := False;
      sleep(100);
      DatabaseRis.Close;
      sleep(100);
      FreeAndNil(DatabaseRis);
      wg_DBFlg := False;
    end;
  except
    DatabaseRis.Connected := False;
    sleep(100);
    DatabaseRis.Close;
    sleep(100);
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
function TDB_RisSD_Receipt.func_GetOrder(
    var rec_count: Integer;
    var arg_ErrMsg: String): Boolean;
var
  sqlSelect:  String;
  iRslt:      Integer;
begin
  //�߂�l
  Result    := True;
  rec_count := 0;
  try
    with FQ_SEL_ORD do begin
      //SQL�ݒ�
      sqlSelect := '';
      sqlSelect := sqlSelect + 'SELECT ROWID, REQUESTID, REQUESTDATE, RIS_ID, REQUESTUSER,';
      sqlSelect := sqlSelect + ' REQUESTTERMINALID, REQUESTTYPE, ';
      sqlSelect := sqlSelect + ' MESSAGEID1, MESSAGEID2, TRANSFERSTATUS, TRANSFERDATE, ';
      sqlSelect := sqlSelect + ' TRANSFERRESULT';
      sqlSelect := sqlSelect + ' FROM TOHISINFO';
      sqlSelect := sqlSelect + ' WHERE TRANSFERSTATUS = ''00''';
      sqlSelect := sqlSelect + ' AND (REQUESTTYPE = ''' + CST_APPTYPE_RC01 + ''' OR REQUESTTYPE = ''' + CST_APPTYPE_RC99 + ''')';
      sqlSelect := sqlSelect + ' ORDER BY REQUESTDATE';
      PrepareQuery(sqlSelect);
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
    end;
    rec_count := iRslt;
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
function  TDB_RisSD_Receipt.func_MakeMsg(
    var arg_Msg:TStringStream;
    var arg_ErrMsg:string;
    var arg_NullFlg:String
    ):boolean;
var
  ws_PatientID: String;
  ws_OrderNo: String;
  ws_StartDate: String;
  ws_StartTime: String;

  wd_ReceiptDate: TDateTime;
  ws_ReceiptDate: String;
  ws_ReceiptTime: String;
  ws_Tantou: String;
  WILoop: Integer;

  wkREQUESTTYPE:  String;
begin
  //�߂�l
  Result:=True;
  wg_KensaType := '';
  try
    wkREQUESTTYPE := FQ_SEL_ORD.GetString('REQUESTTYPE');
    //��t�E��t�L�����Z���d���̏ꍇ
    if (wkREQUESTTYPE = CST_APPTYPE_RC01) or
       (wkREQUESTTYPE = CST_APPTYPE_RC99) then
    begin
      //��ʂɂ��d���ɏ����������ݒ肷��
      proc_ClearStream(G_MSG_SYSTEM_C,G_MSGKIND_UKETUKE,arg_Msg);
      //�d���̃w�b�_�Ɏ�ʂ��Ƃ̌Œ蕶�����ݒ�
      proc_SetStreamHDDef(G_MSG_SYSTEM_C,G_MSGKIND_UKETUKE,arg_Msg);
      //��t�̏ꍇ
      if wkREQUESTTYPE = CST_APPTYPE_RC01 then
      begin
        //�����敪�F��t
        proc_SetStringStream(G_MSG_SYSTEM_C, G_MSGKIND_UKETUKE, arg_Msg,
                             RECSYORIKBNNO, CST_ORDER_RECEIPT_0);
      end
      //��t�L�����Z���̏ꍇ
      else if wkREQUESTTYPE = CST_APPTYPE_RC99 then
      begin
        //�����敪�F�L�����Z��
        proc_SetStringStream(G_MSG_SYSTEM_C, G_MSGKIND_UKETUKE, arg_Msg,
                             RECSYORIKBNNO, CST_ORDER_RECEIPT_1);
      end;

      //�I�[�_�[���C�����擾
      if not func_OrderMain(ws_PatientID,ws_OrderNo,ws_StartDate,ws_StartTime,
                            arg_ErrMsg,arg_NullFlg) then
      begin
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
      //���у��C�����擾
      if not func_ExMain(ws_Tantou,arg_ErrMsg,arg_NullFlg) then
      begin
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
      proc_SetStringStream(G_MSG_SYSTEM_C, G_MSGKIND_UKETUKE, arg_Msg, RECPIDNO,
                           ws_PatientID);
      //�I�[�_�ԍ��ݒ�(16�o�C�g)
      proc_SetStringStream(G_MSG_SYSTEM_C, G_MSGKIND_UKETUKE, arg_Msg,
                           RECORDERNO, ws_OrderNo);
      //�J�n���ݒ�(8�o�C�g)
      proc_SetStringStream(G_MSG_SYSTEM_C, G_MSGKIND_UKETUKE, arg_Msg,
                           RECSTARTDATENO, ws_StartDate);
      //�J�n���Ԑݒ�(6�o�C�g)
      proc_SetStringStream(G_MSG_SYSTEM_C, G_MSGKIND_UKETUKE, arg_Msg,
                           RECSTARTTIMENO, ws_StartTime);
      //��t����
      wd_ReceiptDate := StrToDateTime(FQ_SEL_ORD.GetString('REQUESTDATE'));
      //��t��
      ws_ReceiptDate := FormatDateTime('YYYYMMDD', wd_ReceiptDate);
      //��t����
      ws_ReceiptTime := FormatDateTime('HHMM', wd_ReceiptDate);

      //��t���ݒ�(8�o�C�g)
      proc_SetStringStream(G_MSG_SYSTEM_C, G_MSGKIND_UKETUKE, arg_Msg,
                           RECUKETUKEDATENO, ws_ReceiptDate);
      //��t���Ԑݒ�(4�o�C�g)
      proc_SetStringStream(G_MSG_SYSTEM_C, G_MSGKIND_UKETUKE, arg_Msg,
                           RECUKETUKETIMENO, ws_ReceiptTime);
      //��t�S���Ґݒ�(10�o�C�g)
      proc_SetStringStream(G_MSG_SYSTEM_C, G_MSGKIND_UKETUKE, arg_Msg,
                           RECUKETUKEUSERNO, ws_Tantou);
      //�d�����ݒ�(4�o�C�g)
      proc_SetStringStream(G_MSG_SYSTEM_C, G_MSGKIND_UKETUKE, arg_Msg,
                           COMMON1DENLENNO, func_LeftZero(COMMON1DENLENLEN,IntToStr(length(arg_Msg.DataString) - G_MSGSIZE_START)));
    end
    else
    begin
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
function  TDB_RisSD_Receipt.func_SaveMsg(
                                             arg_Msg: TStringStream;
                                         var arg_ErrMsg: String
                                         ): Boolean;
var
  sqlExec:  String;
  iRslt:    Integer;
begin
  //�߂�l
  Result := True;
  try
    //HIS���M�d���ۑ�SQL�쐬
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
function  TDB_RisSD_Receipt.func_CheckOrder(
    var arg_ErrMsg,
        arg_Flg,
        arg_NullFlg:string
    ):boolean;
var
  w_iCount:   Integer;
  sqlSelect:  String;
  iRslt:      Integer;
begin
  arg_Flg := '0';
  try
    //HIS�d�����M�O�`�F�b�NSQL�쐬
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
        arg_Flg := '1';
        //��O�G���[
        Result := False;
        //�ؒf
        wg_DBFlg := False;
        //�����I��
        Exit;
      end;
      w_iCount := iRslt;
      if w_iCount <> 0 then
      begin
        //��t�d���̏ꍇ
        if FQ_SEL_ORD.GetString('REQUESTTYPE') = CST_APPTYPE_RC01 then
        begin
          //����t�ȊO�̏ꍇ
          if StrToIntDef(GetString('STATUS'), 0) >= 10 then
          begin
            //�߂�l
            Result := True;
            //����I������
            arg_ErrMsg := '';
            //�����I��
            Exit;
          end
          //����t�̏ꍇ
          else
          begin
            //�߂�l
            Result := False;
            //�G���[����
            arg_Flg := '1';
            //�ُ�I������
            arg_ErrMsg := CST_KENSACHKERR_MSG + '�����i������t�ȑO�ł��B' +
                          '{�X�e�[�^�X = ' + GetString('STATUS') +
                          '}';
            //�����I��
            Exit;
          end;
        end
        //
        else if FQ_SEL_ORD.GetString('REQUESTTYPE') = CST_APPTYPE_RC99 then
        begin
          //����t�̏ꍇ
          if StrToIntDef(GetString('STATUS'), 0) < 10 then
          begin
            //�߂�l
            Result := True;
            //����I������
            arg_ErrMsg := '';
            //�����I��
            Exit;
          end
          //����t�ȊO�̏ꍇ
          else
          begin
            //�߂�l
            Result := False;
            //�G���[����
            arg_Flg := '1';
            //�ُ�I������
            arg_ErrMsg := CST_KENSACHKERR_MSG + '�����i��������t�ȍ~�ł��B';
            //�����I��
            Exit;
          end;
        end
        else
        begin
          //�߂�l
          Result := False;
          //�ُ�I������
          arg_ErrMsg := CST_KENSACHKERR_MSG + '��ʂ�����t�E��t�ȊO�ł��B';
          //�����I��
          Exit;
        end;
      end
      else begin
        //�f�[�^�Ȃ��t���O�ݒ�
        arg_NullFlg := '1';
        //�ُ�I������
        arg_ErrMsg := '�����i���`�F�b�N{���у��C���f�[�^���Ȃ��̂ő��M���L�����Z�����܂��B}';
        //�߂�l
        Result := False;
      end;
    end;
  except
    on E: Exception do
    begin
      //�G���[�I������
      Result := False;
      arg_Flg := '1';
      //�G���[��ԃ��b�Z�[�W�擾
      arg_ErrMsg := CST_KENSACHKERR_MSG + E.Message;
      //�ؒf
      wg_DBFlg := False;
      //�����I��
      Exit;
    end;
  end;
end;
{
-----------------------------------------------------------------------------
  ���O :func_GetSysDate
  ���� :����
  ���A�l�F��O�Ȃ�
          'YYYY/MM/DD HH:MI:SS'
  �@�\ :
    1. �f�[�^�x�[�X�̃V�X�e�����t�������擾����B
    ���ɂ܂�ł͂��邪�G���[�̏ꍇ�̓}�V���̓��t��Ԋ҂���B
 *
-----------------------------------------------------------------------------
}
(*
function  TDB_RisSD_Receipt.func_GetSysDate:string;
var
   w_TDateTime:TDateTime;
begin
  try
    TQ_DateTime.SQL.Clear;
    TQ_DateTime.SQL.Add('SELECT SYSDATE FROM DUAL ');
    TQ_DateTime.Open;
    w_TDateTime := TQ_DateTime.FieldValues['SYSDATE'];
    TQ_DateTime.close;
    Result:=FormatDateTime('yyyy/mm/dd hh:nn:ss', w_TDateTime);
    exit;
  except
    Result:=FormatDateTime('yyyy/mm/dd hh:nn:ss', Now);
    exit;
  end;
end;
*)

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
function  TDB_RisSD_Receipt.func_SetOrderResult(
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
        SetParam('PTRANSFERSTATUS', '00');
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
      //�ʐM����'�d��NG'�̏ꍇ(���g���C��)
      else if arg_Result = CST_ORDER_RES_NG3 then
      begin
        //���M�t���O
        SetParam('PTRANSFERSTATUS', '00');
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
      //Where��
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
  ���O :func_OrderMain
  ���� :
    var arg_PatientID: String ����ID
        arg_OrderNo: String   �I�[�_�[No
        arg_StartDate: String �J�n��
        arg_StartTime: String �J�n����
        arg_ErrMsg: String    �G���[���F�ڍ׌��� ���펞�F''
        arg_NullFlg: String   �f�[�^�Ȃ��F'1' ���펞�F''
  ���A�l�F��O�Ȃ� True ���� False �ُ�
  �@�\ :
    1. ���M���R�[�h�̊���ID�A�I�[�_�[No�A�J�n��
    �@ �J�n���Ԃ��擾���܂��B
 *
-----------------------------------------------------------------------------
}
function TDB_RisSD_Receipt.func_OrderMain(
                                          var arg_PatientID,
                                              arg_OrderNo,
                                              arg_StartDate,
                                              arg_StartTime,
                                              arg_ErrMsg,
                                              arg_NullFlg: String
                                         ):Boolean;
var
  w_iCount:   Integer;
  sqlSelect:  String;
  iRslt:      Integer;
begin
  //�߂�l
  Result := True;
  try
    with FQ_SEL do begin
      //SQL�ݒ�
      sqlSelect := '';
      sqlSelect := sqlSelect + 'SELECT KANJA_ID, ORDERNO, KENSA_DATE, KENSA_STARTTIME,KENSATYPE_ID';
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
      if w_iCount <> 0 then
      begin
        //����ID�K�{�`�F�b�N
        if GetString('KANJA_ID') = '' then
        begin
          //�G���[�I������
          Result := False;
          //�G���[�I������
          arg_ErrMsg := CST_GETMAINERR_MSG + '����ID������܂���B';
          //�����I��
          Exit;
        end
        else
          //����ID�擾
          arg_PatientID :=
                         func_RigthSpace(10,GetString('KANJA_ID'));
        //�I�[�_�ԍ��K�{�`�F�b�N
        if Trim(GetString('ORDERNO')) = '' then
        begin
          //�G���[�I������
          Result := False;
          //�G���[�I������
          arg_ErrMsg := CST_GETMAINERR_MSG + '�I�[�_�ԍ�������܂���B';
          //�����I��
          Exit;
        end
        else
          //�I�[�_�[No�擾
          arg_OrderNo :=
                    func_RigthSpace(16,Trim(GetString('ORDERNO')));

        //�J�n���K�{�`�F�b�N
        if Trim(GetString('KENSA_DATE')) = '' then
        begin
          //�G���[�I������
          Result := False;
          //�G���[�I������
          arg_ErrMsg := CST_GETMAINERR_MSG + '�J�n��������܂���B';
          //�����I��
          Exit;
        end
        else
          //�J�n���擾
          arg_StartDate :=
                  func_RigthSpace(8,Trim(GetString('KENSA_DATE')));

        //�J�n���ԕK�{�`�F�b�N
        if Trim(GetString('KENSA_STARTTIME')) = '' then
        begin
          //�G���[�I������
          Result := False;
          //�G���[�I������
          arg_ErrMsg := CST_GETMAINERR_MSG + '�J�n���Ԃ�����܂���B';
          //�����I��
          Exit;
        end
        else if (Trim(GetString('KENSA_STARTTIME')) = CST_JISSITIME_NULL2) or
                (Trim(GetString('KENSA_STARTTIME')) = CST_JISSITIME_NULL3) then
        begin
          //�J�n���Ԏ擾
          arg_StartTime := '0000';
        end
        else
          //�J�n���Ԏ擾
          arg_StartTime :=
               Copy(func_LeftZero(6,Trim(GetString('KENSA_STARTTIME'))),1,4);
        wg_KensaType := GetString('KENSATYPE_ID');
      end
      //�f�[�^�Ȃ��̏ꍇ
      else
      begin
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
    on E: Exception do
    begin
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
function  TDB_RisSD_Receipt.func_DelOrder(
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
        sqlExec := sqlExec + ' AND (REQUESTTYPE = ''' + CST_APPTYPE_RC01 + ''' OR REQUESTTYPE = ''' + CST_APPTYPE_RC99 + ''')';
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

function TDB_RisSD_Receipt.func_ExMain(var arg_Tantou,
                                           arg_ErrMsg,
                                           arg_NullFlg:string):Boolean;
var
  w_iCount:Integer;
var
  sqlSelect:  String;
  iRslt:      Integer;
begin
  //�߂�l
  Result := True;
  try
    //���у��C�����擾SQL���쐬
    with FQ_SEL do begin
      //SQL�ݒ�
      sqlSelect := '';
      sqlSelect := sqlSelect + 'SELECT UKETUKE_TANTOU_ID';
      sqlSelect := sqlSelect + ' FROM EXMAINTABLE';
      sqlSelect := sqlSelect + ' WHERE RIS_ID = :PRIS_ID';
      PrepareQuery(sqlSelect);
      //�p�����[�^
      //RIS_ID
      SetParam('PRIS_ID', FQ_SEL_ORD.GetString('RIS_ID'));
      //SQL���s
      iRslt:= OpenQuery();
      if iRslt < 0 then begin
        arg_NullFlg := '1';
        //��O�G���[
        Result := False;
        //�ؒf
        wg_DBFlg := False;
        //�����I��
        Exit;
      end;
      w_iCount := iRslt;
      if w_iCount <> 0 then begin
        //��t�S���Ҏ擾
        arg_Tantou := func_RigthSpace(RECUKETUKEUSERLEN,Trim(GetString('UKETUKE_TANTOU_ID')));
      end
      else begin
        //���R�[�h�Ȃ��t���O�ݒ�
        arg_NullFlg := '1';
      end;
    end;
  except
    on E: Exception do begin
      arg_NullFlg := '1';
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

end.
