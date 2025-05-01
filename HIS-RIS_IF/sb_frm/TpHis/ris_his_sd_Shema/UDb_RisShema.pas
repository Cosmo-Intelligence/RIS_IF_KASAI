unit UDb_RisShema;
(**
���@�\����
  �V�F�[�}���擾�T�[�r�X��RisDB�ւ̃A�N�Z�X����
������
�V�K�쐬�F2004.10.18�F�S�����c
*)

interface

uses
//�V�X�e���|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, IniFiles,
  ScktComp,SvcMgr, //Db, DBTables,
//�v���_�N�g�J�����ʁ|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|
  Gval,
  HisMsgDef,
  pdct_shema,
  TcpSocket,
  Unit_Log, Unit_DB
  ;
type  //�V�F�[�}���i�[�\����
  TOrderSchema_List = record
    RIS_ID       : String;  //RIS_ID
    NO           : String;  //�V�F�[�}���ʘA��
    SHEMANO      : String;  //�V�F�[�}�A��
    SHEMAPASS    : String;  //�V�F�[�}�p�X
    SHEMANM      : String;  //�V�F�[�}�t�@�C����
    STATUS       : String;  //�X�e�[�^�X
    ERRMSG       : String;  //�G���[���b�Z�[�W
    RISSHEMAPASS : String;  //RIS�V�F�[�}�t�@�C����
    RISHTMLPASS  : String;  //RISHTML�t�@�C����
    RISBUINAME   : String;  //RIS���ʖ�
  end;
type  //�V�F�[�}���i�[�\����
  TSchema_List = record
    PASS : array [1..10] of String;  //�V�F�[�}�p�X���
    DATA : array [1..10] of String;  //�V�F�[�}���
    NO   : array [1..10] of String;  //�A��
  end;
type
  TDB_RisShema = class    //RIS DB
    (*
    TQ_Order: TQuery;  //ExMainTable_���у��C���e�[�u��
    TQ_Etc: TQuery;       //����̨��
    TQ_ExMain: TQuery;          //�敪
    TQ_DateTime: TQuery;     //����
    *)
  private
    { Private �錾 }
  public
    { Public �錾 }
    (*
    DatabaseRis: TDatabase;    //RIS DB
    *)
    wg_DBFlg:Boolean;
    wg_Shema_Ret_Count : Integer;
    wg_Shema_Ret_Code  : String;
    wg_Shema_Ret_Message : String;
    wg_Log_Flg:String;
    wg_OrderSchame_List: Array of TOrderSchema_List;
    function  RisDBOpen(var arg_Flg    : Boolean;
                        var arg_ErrMsg : String;
                            arg_Svc    : TService
                        ): Boolean;
    procedure RisDBClose;
    function  func_GetOrder(
                  var rec_count: Integer;
                  var arg_ErrMsg:string
                 ):boolean;
    function  func_SelectOrder(    arg_Ris_ID:String;
                               var arg_ErrMsg,arg_NullFlg:string
                              ):Boolean;
    (*
    function  func_GetSysDate:string;
    *)
    function  func_SetOrderResult(
                 var arg_ErrMsg:string
                 ):boolean;
    function func_Del_Schema(arg_path,arg_RIS_ID,arg_Html:String;var arg_ErrMsg:String):Boolean;
    function func_GET_Shema(var arg_flg,arg_Err:String):Boolean;
    function func_Chack_HIS(arg_path:String;var arg_ErrMsg:String):Boolean;
    function  func_SetOrderResult_Up(
                 arg_RIS_ID,arg_Result,arg_Err:string;
                 var arg_ErrMsg:string
                 ):boolean;
    function func_Make_HTML(
                            var arg_ErrMsg:string
                           ):boolean;
    function func_UpDate_ExtendOrderMain(var arg_ErrMsg:string):boolean;
    function func_LogonExecute(Host, UserName, Passwd: string): DWord;
    function func_LogoffExecute(Host: string): DWord;
    function func_Logon(argDrive: String; var argErrmsg: String):Boolean;
    function func_Logout(argDrive: String; var argErrmsg: String):Boolean;
  end;

var
  DB_RisShema: TDB_RisShema;

implementation


const
//���t�t�H�[�}�b�g������
CST_DATE_FORMAT='YYYY/MM/DD';
//�G���[�����ꏊ���胁�b�Z�[�W
CST_GETORDERERR_MSG = '���擾���R�[�h�擾���ɃG���[���N���܂����B';
CST_GETORDERMAINERR_MSG = '�I�[�_�V�F�[�}���R�[�h�擾���ɃG���[���N���܂����B';
CST_KENSACHKERR_MSG = '�V�F�[�}���擾���ɃG���[���N���܂����B';
CST_KEKKAERR_MSG = '�I�[�_�V�F�[�}�e�[�u�����ʕۑ����ɃG���[���N���܂����B';
CST_INS = '01';
CST_UP  = '02';
CST_DEL = '03';
//���擾
CST_GETNO_FLG='00';
//�擾
CST_GETOK_FLG='01';
//���s
CST_GETNG_FLG='02';
//�Ď擾
CST_GETRE_FLG='03';

//����
CST_FTPOK_FLG='0';
//�ڑ����s
CST_FTPERR_FLG='1';
//���s
CST_FTPNG_FLG='2';
//���s
CST_FTPOTHER_FLG='3';

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
function TDB_RisShema.RisDBOpen(var arg_Flg    : Boolean;
                              var arg_ErrMsg : String;
                                  arg_Svc    : TService):Boolean;
var
  RetryCnt: integer;
begin
  //�߂�l
  Result := True;

  //���O�쐬
  if not Assigned(FLog) then begin
    FLog := T_FileLog.Create(g_DBLOG04_PATH,
                             g_DBLOG04_PREFIX,
                             g_DBLOG04_LOGGING,
                             g_DBLOG04_KEEPDAYS,
                             g_LogFileSize, //2018/08/30 ���O�t�@�C���ύX
                             nil);
  end;
  if not Assigned(FDebug) then begin
    FDebug := T_FileLog.Create(g_DBLOGDBG04_PATH,
                               g_DBLOGDBG04_PREFIX,
                               g_DBLOGDBG04_LOGGING,
                               g_DBLOGDBG04_KEEPDAYS,
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

          TQ_Etc.Close;
          if TQ_Etc.DatabaseName <> DatabaseRis.DatabaseName then
            TQ_Etc.DatabaseName := DatabaseRis.DatabaseName;

          TQ_ExMain.Close;
          if TQ_ExMain.DatabaseName <> DatabaseRis.DatabaseName then
            TQ_ExMain.DatabaseName := DatabaseRis.DatabaseName;

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
procedure TDB_RisShema.RisDBClose;
begin
  wg_DBFlg := False;
  try
    FDB.DBDisConnect();
  except
  end;
  (*
  try
    TQ_Order.Close;
    TQ_Etc.Close;
    TQ_ExMain.Close;
    TQ_DateTime.Close;
    if DatabaseRis<>nil then
    begin
      DatabaseRis.Connected := False;
      sleep(100);
      DatabaseRis.Close;
      sleep(100);
      DatabaseRis.Free;
      sleep(100);
      DatabaseRis:=nil;
      wg_DBFlg := False;
    end;
  except
    DatabaseRis.Connected := False;
    sleep(100);
    DatabaseRis.Close;
    sleep(100);
    DatabaseRis.Free;
    sleep(100);
    DatabaseRis:=nil;
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
    1. ��M�I�[�_�e�[�u�����疢�擾���R�[�h���I�[�_���M�����̌Â����Ɏ擾�B
 *
-----------------------------------------------------------------------------
}
function  TDB_RisShema.func_GetOrder(
    var rec_count: Integer;
    var arg_ErrMsg:string
    ):boolean;
var
  sqlSelect:  String;
  iRslt:      Integer;
begin
  //�߂�l
  Result:=True;
  rec_count := 0;
  try
    with FQ_SEL_ORD do begin
      //SQL�ݒ�
      sqlSelect := '';
      sqlSelect := sqlSelect + 'SELECT DISTINCT(RIS_ID)';
      sqlSelect := sqlSelect + ' FROM ORDERSHEMATABLE';
      sqlSelect := sqlSelect + ' WHERE STATUS = :PSTATUS';
      sqlSelect := sqlSelect + ' ORDER BY RIS_ID';
      PrepareQuery(sqlSelect);
      //�p�����[�^
      //�V�F�[�}�t���O"���擾"
      SetParam('PSTATUS', CST_GETNO_FLG);
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
    on E: Exception do begin
      //�G���[�I������
      Result := False;
      //�G���[��ԃ��b�Z�[�W�擾
      arg_ErrMsg := CST_GETORDERERR_MSG + E.Message;
      //�����I��
      Exit;
    end;
  end;
end;
{
-----------------------------------------------------------------------------
  ���O :func_SelectOrder
  ���� :
        arg_Ris_ID:String  RIS_ID
    var arg_ErrMsg:string �G���[���F�ڍ׌��� ���펞�F''
    var arg_NullFlg:string �f�[�^�̗L��
  ���A�l�F��O�Ȃ�  True ���� False �ُ�
  �@�\ :
    1. �I�[�_�V�F�[�}�e�[�u������V�F�[�}�f�B���N�g���Ȃǂ̏����擾�B
 *
-----------------------------------------------------------------------------
}
function  TDB_RisShema.func_SelectOrder(    arg_Ris_ID: String;
                                        var arg_ErrMsg,arg_NullFlg: String
                                       ):Boolean;
var
  WILoop:     Integer;
  sqlSelect:  String;
  iRslt:      Integer;
  rec_count:  Integer;
begin
  //�߂�l
  Result:=True;
  try
    with FQ_SEL do begin
      //SQL�ݒ�
      sqlSelect := '';
      sqlSelect := sqlSelect + 'SELECT Os.RIS_ID, Os.NO, Os.SHEMANO, Os.SHEMAPATH, Os.SHEMANM, Os.STATUS, Bm.BUI_NAME';
      sqlSelect := sqlSelect + ' FROM ORDERSHEMATABLE Os, ORDERBUITABLE Ob, BUIMASTER Bm';
      sqlSelect := sqlSelect + ' WHERE Os.RIS_ID = :PRIS_ID';
      sqlSelect := sqlSelect + ' AND (Os.RIS_ID = Ob.RIS_ID';
      sqlSelect := sqlSelect + ' AND Os.NO = Ob.NO)';
      sqlSelect := sqlSelect + ' AND Ob.BUI_ID = Bm.BUI_ID(+)';
      sqlSelect := sqlSelect + ' ORDER BY Os.RIS_ID, Os.NO, Os.SHEMANO';
      PrepareQuery(sqlSelect);
      //�p�����[�^
      //RIS_ID
      SetParam('PRIS_ID', arg_Ris_ID);
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
      rec_count := iRslt;
      //���R�[�h������ꍇ
      if rec_count > 0 then
      begin
        SetLength(wg_OrderSchame_List, rec_count);
        for WILoop := 0 to rec_count - 1 do
        begin
          wg_OrderSchame_List[WILoop].RIS_ID := GetString('RIS_ID');
          wg_OrderSchame_List[WILoop].NO := GetString('NO');
          wg_OrderSchame_List[WILoop].SHEMANO := GetString('SHEMANO');
          wg_OrderSchame_List[WILoop].SHEMAPASS := IncludeTrailingPathDelimiter(ExtractFileDir(StringReplace(GetString('SHEMAPATH'),'/','\',[rfReplaceAll])));
          wg_OrderSchame_List[WILoop].SHEMANM := ExtractFileName(StringReplace(GetString('SHEMAPATH'),'/','\',[rfReplaceAll]));
          wg_OrderSchame_List[WILoop].STATUS := GetString('STATUS');
          wg_OrderSchame_List[WILoop].RISSHEMAPASS := g_SHEMA_LOCAL_PASS + GetString('RIS_ID') + '_' + FormatFloat('00',StrToIntDef(GetString('NO'), 0)) + '.jpg';
          wg_OrderSchame_List[WILoop].RISHTMLPASS := g_SHEMA_HTML_PASS + GetString('RIS_ID') + '_' + FormatFloat('00',StrToIntDef(GetString('NO'), 0)) + '.HTML';
          wg_OrderSchame_List[WILoop].RISBUINAME := GetString('BUI_NAME');
          Next;
        end;
      end
      //���R�[�h���Ȃ��ꍇ
      else begin
        //�f�[�^����
        arg_NullFlg := '1';
        arg_ErrMsg := '�I�[�_�V�F�[�}�e�[�u���Ƀf�[�^������܂���B';
        //�����I��
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
      arg_NullFlg := '1';
      //�G���[�I������
      Result := False;
      //�G���[��ԃ��b�Z�[�W�擾
      arg_ErrMsg := CST_GETORDERMAINERR_MSG + E.Message;
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
function  TDB_RisShema.func_GetSysDate:string;
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
    var arg_ErrMsg:string �G���[���F�ڍ׌��� ���펞�F''
  ���A�l�F��O�Ȃ�
          True ���� False �ُ�
  �@�\ :
    1. ��M�I�[�_�e�[�u���̃J�����g���R�[�h�Ɏ�M���ʂ�o�^���܂��B
 *
-----------------------------------------------------------------------------
}
function  TDB_RisShema.func_SetOrderResult(
    var arg_ErrMsg:string
    ):boolean;
var
  WILoop:   Integer;
  sqlExec:  String;
  iRslt:    Integer;
begin
  //�߂�l
  Result := True;
  try
    //HIS���M���ʕۑ�SQL�쐬
    with FQ_ALT do begin
      if Length(wg_OrderSchame_List) > 0 then
      begin
        for WILoop := 0 to Length(wg_OrderSchame_List) - 1 do
        begin
          //SQL������쐬
          sqlExec := '';
          sqlExec := sqlExec + 'UPDATE ORDERSHEMATABLE';
          sqlExec := sqlExec + ' SET STATUS = :PSTATUS,';
          sqlExec := sqlExec + ' RESULTDATE = SYSDATE,';
          sqlExec := sqlExec + ' RESULT = :PRESULT,';
          sqlExec := sqlExec + ' RESULTBIKOU = :PRESULTBIKOU';
          sqlExec := sqlExec + ' WHERE RIS_ID = :PRIS_ID';
          sqlExec := sqlExec + ' AND NO = :PNO';
          //SQL�ݒ�
          PrepareQuery(sqlExec);
          //�p�����[�^
          if wg_OrderSchame_List[WILoop].STATUS = CST_GETNO_FLG then
          begin
            //�X�e�[�^�X
            SetParam('PSTATUS', wg_OrderSchame_List[WILoop].STATUS);
            //����
            SetParam('PRESULT', '�ʐM�s��');
          end
          else if wg_OrderSchame_List[WILoop].STATUS = CST_GETOK_FLG then
          begin
            //�X�e�[�^�X
            SetParam('PSTATUS', wg_OrderSchame_List[WILoop].STATUS);
            //����
            SetParam('PRESULT', '�n�j');
          end
          else if wg_OrderSchame_List[WILoop].STATUS = CST_GETNG_FLG then
          begin
            //�X�e�[�^�X
            SetParam('PSTATUS', CST_GETOK_FLG);
            //����
            SetParam('PRESULT', '�m�f');
          end;
          //���b�Z�[�W
          SetParam('PRESULTBIKOU', wg_OrderSchame_List[WILoop].ERRMSG);
          //RIS_ID
          SetParam('PRIS_ID', wg_OrderSchame_List[WILoop].RIS_ID);
          //NO
          SetParam('PNO', wg_OrderSchame_List[WILoop].NO);
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
      arg_ErrMsg := CST_KEKKAERR_MSG + E.Message;
      //�����I��
      Exit;
    end;
  end;
end;

function  TDB_RisShema.func_SetOrderResult_Up(
    arg_RIS_ID,arg_Result,arg_Err:string;
    var arg_ErrMsg:string
    ):boolean;
var
  sqlExec:  String;
  iRslt:    Integer;
begin
  //�߂�l
  Result := True;
  try
    //HIS���M���ʕۑ�SQL�쐬
    with FQ_ALT do begin
      //SQL������쐬
      sqlExec := '';
      sqlExec := sqlExec + 'UPDATE ORDERSHEMATABLE';
      sqlExec := sqlExec + ' SET STATUS = :PSTATUS,';
      sqlExec := sqlExec + ' RESULTDATE = SYSDATE,';
      sqlExec := sqlExec + ' RESULT = :PRESULT,';
      sqlExec := sqlExec + ' RESULTBIKOU = :PRESULTBIKOU';
      sqlExec := sqlExec + ' WHERE RIS_ID = :PRIS_ID';
      //SQL�ݒ�
      PrepareQuery(sqlExec);
      //�p�����[�^
      if arg_Result = CST_GETNO_FLG then
      begin
        //�X�e�[�^�X
        SetParam('PSTATUS', arg_Result);
        //����
        SetParam('PRESULT', '�ʐM�s��');
      end
      else if arg_Result = CST_GETOK_FLG then
      begin
        //�X�e�[�^�X
        SetParam('PSTATUS', arg_Result);
        //����
        SetParam('PRESULT', '�n�j');
      end
      else if arg_Result = CST_GETNG_FLG then
      begin
        //�X�e�[�^�X
        SetParam('PSTATUS', CST_GETOK_FLG);
        //����
        SetParam('PRESULT', '�m�f');
      end
      else if arg_Result = CST_GETRE_FLG then
      begin
        //�X�e�[�^�X
        SetParam('PSTATUS', CST_GETNO_FLG);
        //����
        SetParam('PRESULT', '�m�f');
      end;
      //���b�Z�[�W
      SetParam('PRESULTBIKOU', arg_Err);
      //RIS_ID
      SetParam('PRIS_ID', arg_RIS_ID);
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
    on E: Exception do begin
      //�G���[�I������
      Result := False;
      //�G���[��ԃ��b�Z�[�W�擾
      arg_ErrMsg := CST_KEKKAERR_MSG + E.Message;
      //�����I��
      Exit;
    end;
  end;
end;
{
-----------------------------------------------------------------------------
  ���O :func_Del_Schema
  ���� :
    arg_path:String    �t�H���_��
    arg_RIS_ID:String  RIS_ID
    var arg_ErrMsg:string  �G���[���F�ڍ׌��� ���펞�F''
  ���A�l�F��O�Ȃ�
  �@�\ :
    1. �w��RIS_ID�̃V�F�[�}�t�@�C��������΍폜�B
 *
-----------------------------------------------------------------------------
}
function TDB_RisShema.func_Del_Schema(arg_path,arg_RIS_ID,arg_Html:String;var arg_ErrMsg:String):Boolean;
var
  SearchRec: TSearchRec;
  PathName: string;
  FileNameList:TStrings;
  w_i:Integer;
  wi_Pos: Integer;
begin
  //������
  Result := False;
  //�t�H���_�����݂��Ă��Ȃ��ꍇ�ɂ͐���I��
  if (DirectoryExists(arg_path) = False) then begin
    //�߂�l
    Result := True;
    //�����I��
    Exit;
  end
  //�t�@�C�������݂���΂����ɂ͍폜���s��
  else begin
    FileNameList:=TStringList.Create;
    FileNameList.Clear;
    try
      //�V�F�[�}�t�@�C���擾
      if not IsPathDelimiter(arg_path, Length(arg_path)) then
        arg_path := arg_path + '\';
      SysUtils.FindFirst(arg_path +'*.*', faAnyFile, SearchRec);
      try
        if SearchRec.Name='' then Exit;
        repeat
          //�g���q�������������������o�ł���֐��I  EX.Test.txt�@���@Test
          PathName:= ChangeFileExt(SearchRec.Name,'');
          if (SearchRec.Name<>'.') and (SearchRec.Name<>'..') then
            FileNameList.Add(SearchRec.Name);
          until SysUtils.FindNext(SearchRec)<>0;
      finally
        SysUtils.FindClose(SearchRec);
      end;
      //�w���RIS_ID�̃V�F�[�}�t�@�C��������
      for w_i := 0 to FileNameList.Count -1 do begin
        //RIS_ID�̎擾
        wi_Pos := Pos('_',FileNameList[w_i]);
        //�w���RIS_ID�̃t�@�C���̏ꍇ
        if Copy(FileNameList[w_i],1,wi_Pos - 1) = arg_RIS_ID then begin
          //���݊m�F
          if FileExists(arg_path + FileNameList[w_i]) then begin
            try
              //�폜
              DeleteFile(arg_path + FileNameList[w_i]);
            except
              on E:Exception do begin
                //�G���[���b�Z�[�W
                arg_ErrMsg := E.Message;
                //�����I��
                Exit;
              end;
            end;
          end;
        end;
      end;
      //�t�H���_�����݂��Ă��Ȃ��ꍇ�ɂ͐���I��
      if (DirectoryExists(arg_Html) = False) then begin
        //�߂�l
        Result := True;
        //�����I��
        Exit;
      end
      else
      begin
        FileNameList.Clear;
        //HTML�t�@�C���擾
        if not IsPathDelimiter(arg_Html, Length(arg_Html)) then
          arg_Html := arg_Html + '\';
        SysUtils.FindFirst(arg_Html +'*.*', faAnyFile, SearchRec);
        try
          if SearchRec.Name='' then Exit;
          repeat
            //�g���q�������������������o�ł���֐��I  EX.Test.txt�@���@Test
            PathName:= ChangeFileExt(SearchRec.Name,'');
            if (SearchRec.Name<>'.') and (SearchRec.Name<>'..') then
              FileNameList.Add(SearchRec.Name);
            until SysUtils.FindNext(SearchRec)<>0;
        finally
          SysUtils.FindClose(SearchRec);
        end;
        //�w���RIS_ID��HTML�t�@�C��������
        for w_i := 0 to FileNameList.Count -1 do begin
          //RIS_ID�̎擾
          wi_Pos := Pos('_',FileNameList[w_i]);
          //�w���RIS_ID�̃t�@�C���̏ꍇ
          if Copy(FileNameList[w_i],1,wi_Pos - 1) = arg_RIS_ID then begin
            //���݊m�F
            if FileExists(arg_Html + FileNameList[w_i]) then begin
              try
                //�폜
                DeleteFile(arg_Html + FileNameList[w_i]);
              except
                on E:Exception do begin
                  //�G���[���b�Z�[�W
                  arg_ErrMsg := E.Message;
                  //�����I��
                  Exit;
                end;
              end;
            end;
          end;
        end;
      end;
      //�߂�l
      Result := True;
    finally
      //�J��
      FreeAndNil(FileNameList);
    end;
  end;
end;

function TDB_RisShema.func_Chack_HIS(arg_path:String;var arg_ErrMsg:String):Boolean;
begin
  //������
  Result := True;

  if (DirectoryExists(arg_path) = False) then begin
    //�߂�l
    Result := False;
    //�����I��
    Exit;
  end;
end;

function TDB_RisShema.func_GET_Shema(var arg_flg,arg_Err:String):Boolean;
var
  i: integer;
  w_Flg:String;
  WILoop: Integer;
  WSConnectErr: String;
begin
  //�����l
  Result := True;
  w_Flg := '';
  //�����ݒ�
  arg_flg := CST_GETOK_FLG;

  if Length(wg_OrderSchame_List) = 0 then
  begin
    //���O������쐬
    proc_StrConcat(arg_Err,'�V�F�[�}��');
    wg_Log_Flg := G_LOG_LINE_HEAD_NG;
    //�擾���s
    arg_flg := CST_GETNG_FLG;
    //�����I��
    Exit;
  end
  else
  begin
    //���O������쐬
    proc_StrConcat(arg_Err,'�V�F�[�}�L');
  end;

//�A
  //�V�F�[�}�t�@�C��(HIS��RIS����)�_�E�����[�h
  wg_Shema_Ret_Count := 0;
  for i := 0 to Length(wg_OrderSchame_List) - 1 do begin
    if (wg_OrderSchame_List[i].RISSHEMAPASS <> '') and
       //(g_SHEMA_HIS_PASS + wg_OrderSchame_List[i].SHEMAPASS <> '') then begin
       (wg_OrderSchame_List[i].SHEMAPASS <> '') then begin
      //�t�@�C�������݂��Ă��Ȃ����GET����
      if not(FileExists(wg_OrderSchame_List[i].RISSHEMAPASS)) then begin
        try

          if func_Logon(wg_OrderSchame_List[i].SHEMAPASS,WSConnectErr) then
          begin
            //���O������쐬
            proc_StrConcat(arg_Err,'HIS���L�t�H���_�ڑ� OK');
            //if not(DirectoryExists(g_SHEMA_HIS_PASS)) then
            if not(DirectoryExists(wg_OrderSchame_List[i].SHEMAPASS)) then
            begin
              wg_Log_Flg := G_LOG_LINE_HEAD_NG;
              wg_OrderSchame_List[i].STATUS := CST_GETNO_FLG;
              wg_OrderSchame_List[i].ERRMSG := 'HIS�t�H���_�Ȃ�';
              //���O������쐬
              proc_StrConcat(arg_Err,
                             FormatFloat('00',i + 1) +
                             '�u' + wg_OrderSchame_List[i].SHEMAPASS + '�v' +
                             '�uHIS�t�H���_�Ȃ��G���[�v' );
              //���擾
              arg_flg := CST_GETNO_FLG;
              //�߂�l
              Result := False;
            end;

            //if not(FileExists(g_SHEMA_HIS_PASS + wg_OrderSchame_List[i].SHEMAPASS)) then
            if not(FileExists(wg_OrderSchame_List[i].SHEMAPASS + wg_OrderSchame_List[i].SHEMANM)) then
            begin
              wg_Log_Flg := G_LOG_LINE_HEAD_NG;
              wg_OrderSchame_List[i].STATUS := CST_GETNG_FLG;
              wg_OrderSchame_List[i].ERRMSG := '�t�@�C���Ȃ�';
              //���O������쐬
              proc_StrConcat(arg_Err,
                             FormatFloat('00',i + 1) +
                             '�u' + wg_OrderSchame_List[i].SHEMAPASS + wg_OrderSchame_List[i].SHEMANM + '�v' +
                             '�u�t�@�C���Ȃ��G���[�v' );
              //�擾��
              arg_flg := CST_GETNG_FLG;
              //�߂�l
              Result := False;

              for WILoop := 0 to Length(wg_OrderSchame_List) - 1 do
              begin
                wg_OrderSchame_List[WILoop].STATUS := CST_GETNG_FLG;
              end;

              Exit;
            end;
            try
              //�R�s�[����
              //proc_CopyFile(g_SHEMA_HIS_PASS + wg_OrderSchame_List[i].SHEMAPASS,
              proc_CopyFile(wg_OrderSchame_List[i].SHEMAPASS + wg_OrderSchame_List[i].SHEMANM,
                            wg_OrderSchame_List[i].RISSHEMAPASS);
              wg_OrderSchame_List[i].STATUS := CST_GETOK_FLG;
              wg_OrderSchame_List[i].ERRMSG := '';
              //���O������쐬
              proc_StrConcat(arg_Err,
                             FormatFloat('00',i + 1) +
                             '�u' + wg_OrderSchame_List[i].SHEMAPASS + wg_OrderSchame_List[i].SHEMANM + '�v' +
                             '�u' + wg_OrderSchame_List[i].RISSHEMAPASS + '�v' );
            except
              on E:Exception do
              begin
                wg_Log_Flg := G_LOG_LINE_HEAD_NG;
                wg_OrderSchame_List[i].STATUS := CST_GETNO_FLG;
                wg_OrderSchame_List[i].ERRMSG := '�R�s�[������O�G���[�u' + E.Message + '�v';
                //���O������쐬
                proc_StrConcat(arg_Err,
                               FormatFloat('00',i + 1) +
                               '�u' + wg_OrderSchame_List[i].SHEMAPASS + wg_OrderSchame_List[i].SHEMANM + '�v' +
                               '�u' + E.Message + '�v' );
                //�擾��
                arg_flg := CST_GETNO_FLG;
                //�߂�l
                Result := False;
              end;
            end;
          end
          else
          begin
            wg_Log_Flg := G_LOG_LINE_HEAD_NG;
            wg_OrderSchame_List[i].STATUS := CST_GETNO_FLG;
            wg_OrderSchame_List[i].ERRMSG := 'HIS���L�t�H���_�ڑ��s�u' + WSConnectErr + '�v';
            //���O������쐬
            proc_StrConcat(arg_Err,
                           FormatFloat('00',i + 1) +
                           '�u' + wg_OrderSchame_List[i].SHEMAPASS + '�v' +
                           'HIS���L�t�H���_�ڑ��s�u' + WSConnectErr + '�v' );
            //���擾
            arg_flg := CST_GETNO_FLG;
            //�߂�l
            Result := False;
          end;
          wg_Shema_Ret_Count := wg_Shema_Ret_Count + 1;
        finally
          if func_Logon(wg_OrderSchame_List[i].SHEMAPASS,WSConnectErr) then
          begin
            //���O������쐬
            proc_StrConcat(arg_Err,'HIS���L�t�H���_�ؒf OK');
          end
          else
          begin
            //���O������쐬
            proc_StrConcat(arg_Err,'HIS���L�t�H���_�ؒf NG �u' + WSConnectErr + '�v');
          end;
        end;
      end
      //���ɑ��݂��Ă���Ή������Ȃ�
      else begin
        wg_Shema_Ret_Count := wg_Shema_Ret_Count + 1;
        wg_Log_Flg := G_LOG_LINE_HEAD_NG;
        wg_OrderSchame_List[i].STATUS := CST_GETNG_FLG;
        wg_OrderSchame_List[i].ERRMSG := '�����t�@�C������';
        //���O������쐬
        proc_StrConcat(arg_Err,
                       FormatFloat('00',i + 1) +
                       '�u' + wg_OrderSchame_List[i].SHEMAPASS + wg_OrderSchame_List[i].SHEMANM + '�v' +
                       '�u�����t�@�C������G���[�v' );
        //�擾��
        arg_flg := CST_GETNG_FLG;
        //�߂�l
        Result := False;
      end;
    end;
  end;
end;

function  TDB_RisShema.func_Make_HTML(
                                      var arg_ErrMsg:string
                                     ):boolean;
var
  WSKANJA_ID: String;
  WSKANJISIMEI: String;
  WSKENSA_DATE: String;
  WSKENSATYPE_NAME: String;
  WSORDERNO: String;
  WSSECTION_NAME: String;
  WSIRAI_DOCTOR_NAME: String;
  w_HTML_Text: String;
  TxtFile: TextFile;
  w_Record: string;
  i: Integer;
  w_No: string;
  w_Name: string;

  sqlSelect:  String;
  iRslt:      Integer;
  cnt_record: Integer;
begin
  //�߂�l
  Result := True;
  try
    //HIS���M���ʕۑ�SQL�쐬
    with FQ_SEL do begin
      if Length(wg_OrderSchame_List) > 0 then
      begin
        //SQL�ݒ�
        sqlSelect := '';
        sqlSelect := sqlSelect + 'SELECT Om.KANJA_ID, Pa.KANJISIMEI, Em.KENSA_DATE, Km.KENSATYPE_NAME, Om.ORDERNO, Sm.SECTION_NAME,Om.IRAI_DOCTOR_NAME';
        sqlSelect := sqlSelect + ' FROM ORDERMAINTABLE Om, PATIENTINFO Pa, EXMAINTABLE Em, KENSATYPEMASTER Km, SECTIONMASTER Sm';
        sqlSelect := sqlSelect + ' WHERE Om.RIS_ID = :PRIS_ID';
        sqlSelect := sqlSelect + '  AND Om.RIS_ID = Em.RIS_ID(+)';
        sqlSelect := sqlSelect + '  AND Om.KANJA_ID = Pa.KANJA_ID(+)';
        sqlSelect := sqlSelect + '  AND Om.KENSATYPE_ID = Km.KENSATYPE_ID(+)';
        sqlSelect := sqlSelect + '  AND Om.IRAI_SECTION_ID = Sm.SECTION_ID(+)';
        PrepareQuery(sqlSelect);
        //�p�����[�^
        //RIS_ID
        SetParam('PRIS_ID', wg_OrderSchame_List[0].RIS_ID);
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
        cnt_record := iRslt;
        //���R�[�h������ꍇ
        if cnt_record > 0 then
        begin
          WSKANJA_ID         := GetString('KANJA_ID');
          WSKANJISIMEI       := GetString('KANJISIMEI');
          WSKENSA_DATE       := GetString('KENSA_DATE');
          WSKENSATYPE_NAME   := GetString('KENSATYPE_NAME');
          WSORDERNO          := GetString('ORDERNO');
          WSSECTION_NAME     := GetString('SECTION_NAME');
          WSIRAI_DOCTOR_NAME := GetString('IRAI_DOCTOR_NAME');
        end
        //���R�[�h���Ȃ��ꍇ
        else
        begin
          //�߂�l
          Result := False;
          //�f�[�^����
          arg_ErrMsg := '�I�[�_���C���e�[�u���Ƀf�[�^������܂���B';
          //�����I��
          Exit;
        end;
        g_Shema_HTML_Original_File := G_RunPath + CST_SHEMA_HTML_ORIGINAL;
        if not FileExists(g_Shema_HTML_Original_File) then
        begin
          //�߂�l
          Result := False;
          arg_ErrMsg := 'HTML�t�@�C����������܂���F'+g_Shema_HTML_Original_File;
          Exit;
        end;
        //...�i�[��
        //g_Shema_HTML_File := ExtractFileDir(g_Shema_HTML_Original_File) + '\' + CST_SHEMA_HTML_ORDER;
        //HTML�I���W�i���̓��e���R�s�[
        w_HTML_Text := '';
        AssignFile(TxtFile, g_Shema_HTML_Original_File);
        Reset(TxtFile);
        try
          while not system.Eof(TxtFile) do
          begin
            try
              Readln(TxtFile, w_Record);
            except
              on E:EInOutError do
              begin
                //�߂�l
                Result := False;
                arg_ErrMsg := 'HTML�t�@�C���̓Ǎ��Ɏ��s���܂����F' + E.Message;
                Exit;
              end;
            end;
            //�u����������
            if (Pos('<!--', w_Record) > 0) or
               (Pos('-->', w_Record) > 0) then begin
            end
            else begin
              //�w�_�[
              if Pos('*����ID*', w_Record) > 0 then begin
                if WSKANJA_ID <> '' then
                  w_Record := StringReplace(w_Record,'*����ID*',WSKANJA_ID,[rfReplaceAll])
                else
                  w_Record := StringReplace(w_Record,'*����ID*','<span class=dmy_txt></span>',[rfReplaceAll]);
              end;
              if Pos('*����*', w_Record) > 0 then begin
                if WSKANJISIMEI <> '' then
                  w_Record := StringReplace(w_Record,'*����*',WSKANJISIMEI,[rfReplaceAll])
                else
                  w_Record := StringReplace(w_Record,'*����*','<span class=dmy_txt></span>',[rfReplaceAll]);
              end;
              if Pos('*���{������*', w_Record) > 0 then begin
                if WSKENSA_DATE <> '' then
                  w_Record := StringReplace(w_Record,'*���{������*',func_Date8To10(WSKENSA_DATE),[rfReplaceAll])
                else
                  w_Record := StringReplace(w_Record,'*���{������*','<span class=dmy_txt></span>',[rfReplaceAll]);
              end;
              if Pos('*�������*', w_Record) > 0 then begin
                if WSKENSATYPE_NAME <> '' then
                  w_Record := StringReplace(w_Record,'*�������*',WSKENSATYPE_NAME,[rfReplaceAll])
                else
                  w_Record := StringReplace(w_Record,'*�������*','<span class=dmy_txt></span>',[rfReplaceAll]);
              end;
              if Pos('*����NO*', w_Record) > 0 then begin
                if WSORDERNO <> '' then
                  w_Record := StringReplace(w_Record,'*����NO*',WSORDERNO,[rfReplaceAll])
                else
                  w_Record := StringReplace(w_Record,'*����NO*','<span class=dmy_txt></span>',[rfReplaceAll]);
              end;
              if Pos('*�˗���*', w_Record) > 0 then begin
                if WSSECTION_NAME <> '' then
                  w_Record := StringReplace(w_Record,'*�˗���*',WSSECTION_NAME,[rfReplaceAll])
                else
                  w_Record := StringReplace(w_Record,'*�˗���*','<span class=dmy_txt></span>',[rfReplaceAll]);
              end;
              if Pos('*�˗���*', w_Record) > 0 then begin
                if WSIRAI_DOCTOR_NAME <> '' then
                  w_Record := StringReplace(w_Record,'*�˗���*',WSIRAI_DOCTOR_NAME,[rfReplaceAll])
                else
                  w_Record := StringReplace(w_Record,'*�˗���*','<span class=dmy_txt></span>',[rfReplaceAll]);
              end;
              //���ʁA�V�F�[�}�摜�A���ʃR�����g
              for i := 0 to 9 do
              begin
                w_No := FormatFloat('00', i + 1);
                if Length(wg_OrderSchame_List) - 1 >= i then
                begin
                  //���ʖ�
                  w_Name := '*����'+w_No+'*';
                  if Pos(w_Name, w_Record) > 0 then begin
                    if wg_OrderSchame_List[i].RISBUINAME <> '' then
                      w_Record := StringReplace(w_Record,w_Name,wg_OrderSchame_List[i].RISBUINAME,[rfReplaceAll])
                    else
                      w_Record := '<TD><span class=dmy_gazou></span></TD>';
                  end;
                  //�V�F�[�}�摜
                  w_Name := '*���ω摜'+w_No+'*';
                  if Pos(w_Name, w_Record) > 0 then begin
                    if wg_OrderSchame_List[i].RISSHEMAPASS <> '' then
                      w_Record := StringReplace(w_Record,w_Name,wg_OrderSchame_List[i].RISSHEMAPASS,[rfReplaceAll])
                    else
                      w_Record := '<TD><span class=dmy_gazou></span></TD>';
                  end;
                  //���ʃR�����g
                  w_Name := '*���ʺ���'+w_No+'*';
                  if Pos(w_Name, w_Record) > 0 then begin
                    w_Record := '<TD><span class=dmy_gazou></span></TD>';
                  end;
                end
                else
                begin
                  //���ʖ�
                  w_Name := '*����'+w_No+'*';
                  if Pos(w_Name, w_Record) > 0 then begin
                    w_Record := '<TD><span class=dmy_gazou></span></TD>';
                  end;
                  //�V�F�[�}�摜
                  w_Name := '*���ω摜'+w_No+'*';
                  if Pos(w_Name, w_Record) > 0 then begin
                    w_Record := '<TD><span class=dmy_gazou></span></TD>';
                  end;
                  //���ʃR�����g
                  w_Name := '*���ʺ���'+w_No+'*';
                  if Pos(w_Name, w_Record) > 0 then begin
                    w_Record := '<TD><span class=dmy_gazou></span></TD>';
                  end;
                end;
              end;
            end;
            // �ǂݍ��񂾍s���ް������݂���ꍇ
            if w_HTML_Text = '' then
              w_HTML_Text := w_HTML_Text + w_Record
            else
              w_HTML_Text := w_HTML_Text + #13#10 + w_Record;
          end;
        finally
          CloseFile(TxtFile);
        end;

        //HTML�t�@�C���쐬
        try
          AssignFile(TxtFile, wg_OrderSchame_List[0].RISHTMLPASS);
          Rewrite(TxtFile);
        except
          on E:EInOutError do begin
            Result := False;
            arg_ErrMsg := wg_OrderSchame_List[0].RISHTMLPASS +'�̃A�T�C���Ɏ��s���܂����B'+E.Message;
            Exit;
          end;
        end;
        try
          try
            Writeln(TxtFile, w_HTML_Text);
          except
            on E:EInOutError do begin
              Result := False;
              arg_ErrMsg := wg_OrderSchame_List[0].RISHTMLPASS +'�̏������݂Ɏ��s���܂����B'+E.Message;
              Exit;
            end;
          END;
        finally
          Flush(TxtFile);
          CloseFile(TxtFile);
        end;
        Result := True;
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
      arg_ErrMsg := 'HTML�t�@�C���̍쐬�Ɏ��s���܂����B' + E.Message;
      //�����I��
      Exit;
    end;
  end;
end;

function  TDB_RisShema.func_UpDate_ExtendOrderMain(
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
      sqlExec := sqlExec + 'UPDATE EXTENDORDERINFO';
      sqlExec := sqlExec + ' SET SHEMAURL = :PSHEMAURL';
      sqlExec := sqlExec + ' WHERE RIS_ID = :PRIS_ID';
      //SQL�ݒ�
      PrepareQuery(sqlExec);
      //�p�����[�^
      //����
      SetParam('PSHEMAURL', wg_OrderSchame_List[0].RISHTMLPASS);
      //RIS_ID
      SetParam('PRIS_ID', wg_OrderSchame_List[0].RIS_ID);
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
    on E: Exception do begin
      //�G���[�I������
      Result := False;
      //�G���[��ԃ��b�Z�[�W�擾
      arg_ErrMsg := '�g���I�[�_���̓o�^�Ɏ��s���܂����B' + E.Message;
      //�����I��
      Exit;
    end;
  end;
end;

function TDB_RisShema.func_LogonExecute(Host, UserName, Passwd: string): DWord;
var
  NetRes : TNetResource;
  str: string;
begin
  FillChar(NetRes, SizeOf(NetRes), 0);
  NetRes.dwType := RESOURCETYPE_DISK;

  NetRes.lpRemoteName := PChar(Host);

  Result := WNetAddConnection2(NetRes, PChar(Passwd), PChar(UserName),
                                     0);
end;

// Host�ɂ�IP�A�h���X���w��ł��܂��B
function TDB_RisShema.func_LogoffExecute(Host: string): DWord;
var
  str: string;
begin
  Result := WNetCancelConnection2(PChar(Host), 0, true);
end;

function TDB_RisShema.func_Logon(argDrive: String; var argErrmsg: String):Boolean;
var
  WDWord: DWord;
  WILoop: Integer;
  WICount: Integer;
begin

  Result := True;

  WICount := g_LOGONRETRY;

  for WILoop := 0 to WICount - 1 do
  begin
    try

      Sleep(500);

      WDWord := func_LogonExecute(ExtractFileDrive(argDrive),g_LOGONUSER,g_LOGONPASS);

      if WDWord = NO_ERROR then
      begin
        argErrmsg := '����';
        Result := True;
        Break;
      end
      else if WDWord = ERROR_ACCESS_DENIED then
      begin
        argErrmsg := '�l�b�g���[�N�����ւ̃A�N�Z�X�����ۂ���܂����B';
        Result := False;
      end
      else if WDWord = ERROR_ALREADY_ASSIGNED then
      begin
        argErrmsg := 'lpLocalName �Ŏw�肵�����[�J���f�o�C�X�͊��Ƀl�b�g���[�N�����ɐڑ�����Ă��܂��B';
        Result := False;
      end
      else if WDWord = ERROR_BAD_DEV_TYPE then
      begin
        argErrmsg := '���[�J���f�o�C�X�̎�ނƃl�b�g���[�N�����̎�ނ���v���܂���B';
        Result := False;
      end
      else if WDWord = ERROR_BAD_DEVICE then
      begin
        argErrmsg := 'lpLocalName �Ŏw�肵���l�������ł��B';
        Result := False;
      end
      else if WDWord = ERROR_BAD_NET_NAME then
      begin
        argErrmsg := 'lpRemoteName �Ŏw�肵���l���A�ǂ̃l�b�g���[�N�����̃v���o�C�_���󂯕t���܂���B�����̖��O���������A�w�肵��������������܂���B';
        Result := False;
      end
      else if WDWord = ERROR_BAD_PROFILE then
      begin
        argErrmsg := '���[�U�[�v���t�@�C���̌`��������������܂���B';
        Result := False;
      end
      else if WDWord = ERROR_BAD_PROVIDER then
      begin
        argErrmsg := 'lpProvider �Ŏw�肵���l���ǂ̃v���o�C�_�Ƃ���v���܂���B';
        Result := False;
      end
      else if WDWord = ERROR_BUSY then
      begin
        argErrmsg := '���[�^�[�܂��̓v���o�C�_���r�W�[�i �����炭���������j�ł��B���̊֐���������x�Ăяo���Ă��������B';
        Result := False;
      end
      else if WDWord = ERROR_CANCELLED then
      begin
        argErrmsg := '�l�b�g���[�N�����̃v���o�C�_�̂����ꂩ�Ń��[�U�[���_�C�A���O�{�b�N�X���g���Đڑ�����������������A�ڑ���̎������ڑ�������������܂����B';
        Result := False;
      end
      else if WDWord = ERROR_CANNOT_OPEN_PROFILE then
      begin
        argErrmsg := '�P�v�I�Ȑڑ����������邽�߂̃��[�U�[�v���t�@�C�����J�����Ƃ��ł��܂���B';
        Result := False;
      end
      else if WDWord = ERROR_DEVICE_ALREADY_REMEMBERED then
      begin
        argErrmsg := 'lpLocalName �Ŏw�肵���f�o�C�X�̃G���g���͊��Ƀ��[�U�[�v���t�@�C�����ɑ��݂��܂��B';
        Result := False;
      end
      else if WDWord = ERROR_EXTENDED_ERROR then
      begin
        argErrmsg := '�l�b�g���[�N�ŗL�̃G���[���������܂����B';
        Result := False;
      end
      else if WDWord = ERROR_NO_NET_OR_BAD_PATH then
      begin
        argErrmsg := '�w�肵���p�X���[�h�������ł��B';
        Result := False;
      end
      else if WDWord = ERROR_NO_NET_OR_BAD_PATH then
      begin
        argErrmsg := '�l�b�g���[�N�R���|�[�l���g���J�n����Ă��Ȃ����A�w�肵�����O�����p�ł��Ȃ����߂ɁA������s���܂���ł����B';
        Result := False;
      end
      else if WDWord = ERROR_NO_NETWORK then
      begin
        argErrmsg := '�l�b�g���[�N�ɐڑ�����Ă��܂���B';
        Result := False;
      end
      else
      begin
        try
          Result := False;
          RaiseLastOSError;
        except
          on E: Exception do
          begin
            argErrmsg := e.Message;
            Continue;
          end;
        end;
      end;
    except
      on E: Exception do
      begin
        argErrmsg := e.Message;
        Result := False;
      end;
    end;
  end;


end;

function TDB_RisShema.func_Logout(argDrive: String; var argErrmsg: String):Boolean;
var
  WDWord: DWord;
  WILoop: Integer;
  WICount: Integer;
begin

  Result := True;

  WICount := g_LOGONRETRY;

  for WILoop := 0 to WICount - 1 do
  begin
    try
      Sleep(500);

      WDWord := func_LogoffExecute(ExtractFileDrive(argDrive));

      if WDWord = NO_ERROR then
      begin
        argErrmsg := '����';
        Result := True;
        Break;
      end
      else if WDWord = ERROR_BAD_PROFILE then
      begin
        argErrmsg := '���[�U�[�v���t�@�C���̌`��������������܂���B';
        Result := False;
      end
      else if WDWord = ERROR_CANNOT_OPEN_PROFILE then
      begin
        argErrmsg := '�P�v�I�Ȑڑ����������邽�߂̃��[�U�[�v���t�@�C�����J�����Ƃ��ł��܂���B';
        Result := False;
      end
      else if WDWord = ERROR_DEVICE_IN_USE then
      begin
        argErrmsg := '�w�肵���f�o�C�X���A�N�e�B�u�ȃv���Z�X�ɂ���Ďg�p���̂��߁A�ؒf�ł��܂���B';
        Result := False;
      end
      else if WDWord = ERROR_EXTENDED_ERROR then
      begin
        argErrmsg := '�l�b�g���[�N�ŗL�̃G���[���������܂����B';
        Result := False;
      end
      else if WDWord = ERROR_NOT_CONNECTED then
      begin
        argErrmsg := 'lpName �p�����[�^�Ŏw�肵�����O�����_�C���N�g����Ă���f�o�C�X��\���Ă��Ȃ����AlpName �Ŏw�肵���f�o�C�X�ɃV�X�e�����ڑ����Ă��܂���B';
        Result := False;
      end
      else if WDWord = ERROR_OPEN_FILES then
      begin
        argErrmsg := '�J���Ă���t�@�C��������AfForce �� FALSE �ł��B';
        Result := False;
      end
      else
      begin
        try
          Result := False;
          RaiseLastOSError;
        except
          on E: Exception do
          begin
            argErrmsg := e.Message;
            Continue;
          end;
        end;
      end;
    except
      on E:Exception do
      begin
        Result := False;
        argErrmsg := e.Message;
      end;

    end;
  end;

end;

end.
