unit URH_ShemaSvc;
(**
���@�\����
 �V�F�[�}���擾�T�[�r�X�̐���

������
�V�K�쐬�F2004.10.18�F�S�� ���c
*)
interface //*****************************************************************
//�g�p���j�b�g---------------------------------------------------------------
uses
//�V�X�e���|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|
  Windows, Messages, SysUtils, Classes, Graphics, Controls, SvcMgr,
  IniFiles, Dialogs, ExtCtrls,ScktComp, //Db, DBTables, 
//�v���_�N�g�J�����ʁ|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|
  Gval,
  HisMsgDef,
  TcpSocket,
  pdct_shema,
  UDb_RisShema,
  Unit_Log, Unit_DB
  ;

////�^�N���X�錾-------------------------------------------------------------
type
  TRisHisSvc_Shema = class(TService)
    procedure ServiceExecute(Sender: TService);
    procedure ServiceDestroy(Sender: TObject);
    procedure ServiceStop(Sender: TService; var Stopped: Boolean);
    procedure ServiceCreate(Sender: TObject);
    procedure ServiceAfterInstall(Sender: TService);
    procedure ServiceAfterUninstall(Sender: TService);
    procedure ServiceStart(Sender: TService; var Started: Boolean);
  private
    { Private �錾 }
    wg_ErrMSG:String;
    wg_RIS_ID:String;
    wg_Order_NO:String;
    wg_MainDIR:String;
    wg_SubDIR:String;
    procedure proc_Main;

  public
    StopMode: integer;
    function GetServiceController: TServiceController; override;
    { Public �錾 }
  end;
//�萔�錾-------------------------------------------------------------------
//�ϐ��錾-------------------------------------------------------------------
var
//ini���
   g_TcpIniPath:string;
    ini: TIniFile;
    LogFlag : Integer;      // ���O�o�͗L�� 1: On 0: Off
    LogFile : string;       // ���O�t�@�C����
    LogSize : Integer;      // ���O�T�C�Y
    TestMode: Integer;      // �e�X�g���[�h 1: Test 0: �ғ�
    TestSyori: string;
    SleepTime:Integer;
    RDatabaseName:String;
    RDriverName:String;
    RServerName:String;
    RNetProtocol:String;
    RLangDriver:String;
    RUserName:String;
    RPassword:String;
    HServerName:String;
    HUserID:string;
    HPassword:String;
    HSleepTime:Integer;
    HRetry_Cnt:Integer;
var
  RisHisSvc_Shema: TRisHisSvc_Shema;
//�֐��葱���錾-------------------------------------------------------------

implementation //**************************************************************

//�g�p���j�b�g---------------------------------------------------------------
//uses UDb_Ris;
{$R *.DFM}

//�萔�錾       -------------------------------------------------------------
const
  CST_FTP_NON = '00';
  CST_FTP_GET = '01';
  CST_FTP_ERR = '02';
  CST_FTP_ERR2 = '03';
//�ϐ��錾     ---------------------------------------------------------------
//var

//�֐��葱���錾--------------------------------------------------------------
//=============================================================================
//�T�[�r�X�֘A������������������������������������������������������������������
//=============================================================================
procedure ServiceController(CtrlCode: DWord); stdcall;
begin
  RisHisSvc_Shema.Controller(CtrlCode);
end;

function TRisHisSvc_Shema.GetServiceController: TServiceController;
begin
  Result := ServiceController;
end;

//�T�[�r�X�쐬
procedure TRisHisSvc_Shema.ServiceCreate(Sender: TObject);
begin
  //DB�N���X�쐬
  DB_RisShema := TDB_RisShema.Create();
  //INI�t�@�C����ǂݍ���
  if not func_TcpReadiniFile then
  begin
    //���O�o��
    proc_LogOut(G_LOG_LINE_HEAD_NG, '', G_LOG_KIND_NG_NUM,
                'ini�t�@�C���ǂݍ���NG');
  end;

  //�T�[�r�X�쐬�������O
  proc_LogOut(G_LOG_LINE_HEAD_NP, '', G_LOG_KIND_SVCDEF_NUM,
              '*****�T�[�r�X���쐬���܂���*****');
end;
//�T�[�r�X�j��
procedure TRisHisSvc_Shema.ServiceDestroy(Sender: TObject);
begin
  //DB�N���X�쐬
  if Assigned(DB_RisShema) then FreeAndNil(DB_RisShema);
  //�T�[�r�X����
  proc_LogOut(G_LOG_LINE_HEAD_NP, '', G_LOG_KIND_SVC_NUM,
              '*****�T�[�r�X��j�����܂���*****');
end;
//
procedure TRisHisSvc_Shema.ServiceStart(Sender: TService;
  var Started: Boolean);
begin
//
end;
//�T�[�r�X��~
procedure TRisHisSvc_Shema.ServiceStop(Sender: TService;
  var Stopped: Boolean);
begin
  //���O�o��
  proc_LogOut(G_LOG_LINE_HEAD_NP, '', G_LOG_KIND_SVCDEF_NUM,
              '*****�T�[�r�X���~���܂���*****');
end;
//�T�[�r�X�C���X�g�[��
procedure TRisHisSvc_Shema.ServiceAfterInstall(Sender: TService);
begin
  //���O�o��
  proc_LogOut(G_LOG_LINE_HEAD_NP, '', G_LOG_KIND_SVCDEF_NUM,
              '*****�T�[�r�X���C���X�g�[�����܂���*****');
end;
//�T�[�r�X�A���C���X�g�[��
procedure TRisHisSvc_Shema.ServiceAfterUninstall(Sender: TService);
begin
  //���O�o��
  proc_LogOut(G_LOG_LINE_HEAD_NP, '', G_LOG_KIND_SVCDEF_NUM,
              '*****�T�[�r�X���A���C���X�g�[�����܂���*****');
end;

//�T�[�r�X���s����
procedure TRisHisSvc_Shema.ServiceExecute(Sender: TService);
var
  w_StopTimestamp:TTimeStamp;
  w_StopDateTime:TDateTime ;
  res:boolean;
  w_sErr:string;
  cnt_record:  Integer;
begin
  try
    try
      //�T�[�r�X�N���̂��т�INI�t�@�C����ǂݍ���
      if not func_TcpReadiniFile then
      begin
        //���O�o��
        proc_LogOut(G_LOG_LINE_HEAD_NG, '', G_LOG_KIND_NG_NUM,
                    'ini�t�@�C���ǂݍ���NG');
        //�T�[�r�X��~
        ServiceThread.Terminate;
        //�����I��
        Exit;
      end;
      //���O�o��
      proc_LogOut(G_LOG_LINE_HEAD_NP, '', G_LOG_KIND_SVC_NUM,
                  '*****�T�[�r�X���J�n���܂�*****');
      //���O�o��
      proc_LogOut(G_LOG_LINE_HEAD_NP, '', G_LOG_KIND_SK_CL_NUM,
                  '�N���p�X�F' + g_TcpIniPath);
      //�T�[�r�X���s��
      while not Terminated do
      begin
        //�A�N�e�B�u���̂ݓ��삷��
        if g_Svc_Shema_Acvite = g_SOCKET_ACTIVE then
        begin
          //DB���I�[�v������ ��O�𔭐����Ȃ��悤��
          if DB_RisShema.RisDBOpen(DB_RisShema.wg_DBFlg,w_sErr,self) then begin
            wg_ErrMSG := '';
            try
              proc_LogOut(G_LOG_LINE_HEAD_OK,'',G_LOG_KIND_DB_NUM,'RIS DB�ڑ�OK');
              //3.��M�I�[�_�e�[�u���̎擾
              res := DB_RisShema.func_GetOrder(cnt_record, w_sErr);
              if res then
              begin
                if cnt_record > 0 then
                begin
                  (*
                  //�Ō�̃��R�[�h�Ɉړ�
                  DB_RisShema.TQ_Order.Last;
                  //�ŏ��̃��R�[�h�Ɉړ�
                  DB_RisShema.TQ_Order.First;
                  *)
                  //���O�\��
                  proc_LogOut(G_LOG_LINE_HEAD_OK,'',G_LOG_KIND_DB_NUM,'�I�[�_�V�F�[�}�e�[�u���擾OK�u' + IntToStr(cnt_record) + '���v');
                  while (not Terminated)                    and
                        (cnt_record > 0) and
                        (not (FQ_SEL_ORD.Eof))       do begin
                    wg_ErrMSG := '';
                    //RIS_ID�擾
                    wg_RIS_ID := FQ_SEL_ORD.GetString('RIS_ID');
                    {
                    //�V�F�[�}����No�擾
                    wg_ShemaBuiNo := DB_RisShema.TQ_Order.FieldByName('NO').AsString;
                    //�V�F�[�}No�擾
                    wg_ShemaNo := DB_RisShema.TQ_Order.FieldByName('SHEMANO').AsString;
                    }
                    //���O�t���O������
                    DB_RisShema.wg_Log_Flg := '';
                    //4-8�̏���
                    proc_Main;
                    //���̃��R�[�h�Ɉړ�
                    FQ_SEL_ORD.Next;
                    //���O�̏o��
                    proc_LogOut(DB_RisShema.wg_Log_Flg,'',G_LOG_KIND_DB_NUM,wg_ErrMSG);
                  end;
                end
                else begin
                  proc_StrConcat(wg_ErrMSG,'�I�[�_�V�F�[�}�e�[�u���Ώۃ��R�[�h�Ȃ�');
                  //���O�̏o��
                  proc_LogOut(G_LOG_LINE_HEAD_OK,'',G_LOG_KIND_DB_NUM,wg_ErrMSG);
                end;
              end
              //�ُ�I���̏ꍇ
              else begin
                proc_LogOut(G_LOG_LINE_HEAD_NG,'',G_LOG_KIND_DB_NUM,'�I�[�_�V�F�[�}�e�[�u���擾NG�u'+w_sErr+'�v');
              end;
            Except
              on e:exception do begin
                //DB�̐ؒf
                DB_RisShema.RisDBClose;
                proc_LogOut(G_LOG_LINE_HEAD_NP,'',G_LOG_KIND_DB_NUM,'*****RIS DB�ڑ����I�����܂���*****' + e.Message) ;
              end;
            end;
          //DB�I�[�v�����s
          end
          else begin
            proc_LogOut(G_LOG_LINE_HEAD_NG,'',G_LOG_KIND_DB_NUM,'RIS DB�ڑ�NG�u'+w_sErr+'�v') ;
          end;
          proc_LogOut(G_LOG_LINE_HEAD_NP,'',G_LOG_KIND_DB_NUM,'*****�ҋ@�J�n*****') ;
          //�^�C�}���[�v����
          //�^�C���X�^���v�̎擾
          w_StopTimestamp := DateTimeToTimeStamp(now);
          //�I�������̎擾
          w_StopTimestamp.Time := w_StopTimestamp.Time + g_Svc_Shema_Cycle * 1000;
          //�I�������̐ݒ�
          w_StopDateTime := TimeStampToDateTime(w_StopTimestamp);
          //�I���������z���邩�A�T�[�r�X���I�����ꂽ�ꍇ
          while (not Terminated) and (w_StopDateTime>Now) do begin
            sleep(1000);
            ServiceThread.ProcessRequests(false);
          end;
          w_sErr := '';
          proc_LogOut(G_LOG_LINE_HEAD_NP,'',G_LOG_KIND_DB_NUM,'*****�ҋ@�I��*****') ;
        end
        else begin
          ServiceThread.ProcessRequests(false);
        end;
      end;
      //DB�̐ؒf
      DB_RisShema.RisDBClose;
      //�����I��
      Exit;
    except
     //DB�̐ؒf
     DB_RisShema.RisDBClose;
     //�����I��
     Exit;
    end;
  finally
    //�J��
    if Assigned(FQ_SEL) then FreeAndNil(FQ_SEL);
    if Assigned(FQ_SEL_ORD) then FreeAndNil(FQ_SEL_ORD);
    if Assigned(FQ_ALT) then FreeAndNil(FQ_ALT);
    if Assigned(FLog) then FreeAndNil(FLog);
    if Assigned(FDebug) then FreeAndNil(FDebug);
  end;
end;

//=============================================================================
//�V�F�[�}���擾������������������������������������������������������������������
//=============================================================================
{-----------------------------------------------------------------------------
  ���O : proc_Main;
  ���� : �Ȃ�
  �@�\ :
  �P�g�����U�N�V��������
  ���A�l�F��O�͔������Ȃ�
-----------------------------------------------------------------------------}
procedure TRisHisSvc_Shema.proc_Main;
var
  res:boolean;
  w_sErr:string;
  w_result:string;
  w_sysdate:string;
  w_NullFlg:String;
  WSWorkErr: String;
label
  p_err,
  p_end,
  p_UpDate;
begin
  try
    //������
    wg_Order_NO := '';
    wg_MainDIR  := '';
    wg_SubDIR   := '';
    w_NullFlg   := '';
    WSWorkErr   := '';
    DB_RisShema.wg_Log_Flg := G_LOG_LINE_HEAD_OK;
    SetLength(DB_RisShema.wg_OrderSchame_List,0);

    //��ݻ޸��݊J�n
    FDB.StartTransaction;
    {
    res := DB_RisShema.func_Chack_HIS(g_SHEMA_HIS_PASS,w_sErr);
    //����I���̏ꍇ
    if res then
    begin
      //���O������쐬
      proc_StrConcat(wg_ErrMSG,'�T�[�o�[�`�F�b�NOK �t�H���_=' + g_SHEMA_HIS_PASS);
    end
    //�ُ�I���̏ꍇ
    else begin
      proc_StrConcat(wg_ErrMSG,'�T�[�o�[�`�F�b�NNG �t�H���_=' + g_SHEMA_HIS_PASS);
      WSWorkErr := '�T�[�o�[�`�F�b�N NG';
      //�r���I��
      //"��"�ɕύX
      w_result := CST_FTP_NON;
      DB_RisShema.wg_Log_Flg := G_LOG_LINE_HEAD_NG;
      //�d���o�^�C����
      goto p_UpDate;
    end;
    }
    //���O������쐬
    proc_StrConcat(wg_ErrMSG,'RIS_ID=' + wg_RIS_ID);


    //�����V�F�[�}�t�@�C���̍폜
    res := DB_RisShema.func_Del_Schema(g_SHEMA_LOCAL_PASS,wg_RIS_ID,g_SHEMA_HTML_PASS,w_sErr);
    //����I���̏ꍇ
    if res then begin
      //�폜����
      proc_StrConcat(wg_ErrMSG,'�t�@�C���폜OK');
    end
    //�ُ�I���̏ꍇ
    else begin
      proc_StrConcat(wg_ErrMSG,'�t�@�C���폜NG�u'+w_sErr+'�v');
      WSWorkErr := '�t�@�C���폜 NG';
      //�r���I��
      //"��"�ɕύX
      w_result := CST_FTP_NON;
      DB_RisShema.wg_Log_Flg := G_LOG_LINE_HEAD_NG;
      //�d���o�^�C����
      goto p_UpDate;
    end;

    //�I�[�_�V�F�[�}�e�[�u��������̎擾
    res := DB_RisShema.func_SelectOrder(wg_RIS_ID,w_sErr,w_NullFlg);
    //����I���̏ꍇ
    if res then
    begin
      //�f�[�^�L��
      if w_NullFlg = '' then begin
        proc_StrConcat(wg_ErrMSG,'RIS_ID���� OK');
      end
      //�f�[�^�Ȃ�
      else begin
        proc_StrConcat(wg_ErrMSG,'RIS_ID���� NG�u' + w_sErr + '�v');
        WSWorkErr := 'RIS_ID���� NG';
        //�r���I��
        //"��"�ɕύX
        w_result := CST_FTP_ERR;
        DB_RisShema.wg_Log_Flg := G_LOG_LINE_HEAD_NG;
        //�d���o�^�C����
        goto p_UpDate;
      end;
    end
    //�ُ�I���̏ꍇ
    else begin
      proc_StrConcat(wg_ErrMSG,'RIS_ID���� NG�u' + w_sErr + '�v');
      WSWorkErr := 'RIS_ID���� NG';
      //�r���I��
      //"��"�ɕύX
      w_result := CST_FTP_ERR;
      DB_RisShema.wg_Log_Flg := G_LOG_LINE_HEAD_NG;
      //�d���o�^�C����
      goto p_UpDate;
    end;

    //�V�F�[�}���̎擾  w_result�F���擾���
    res := DB_RisShema.func_GET_Shema(w_result,w_sErr);

    proc_StrConcat(wg_ErrMSG,w_sErr);

    if w_result = '01' then
    begin
      //HTML�t�@�C�����X�V
      res := DB_RisShema.func_Make_HTML(w_sErr);
      //����I���̏ꍇ
      if res then begin
        proc_StrConcat(wg_ErrMSG,'HTML�t�@�C���̍쐬OK');
      end
      //�ُ�I���̏ꍇ
      else begin
        proc_StrConcat(wg_ErrMSG,'HTML�t�@�C���̍쐬NG�u'+w_sErr+'�v');
        DB_RisShema.wg_Log_Flg := G_LOG_LINE_HEAD_NG;
        WSWorkErr := 'HTML�쐬 NG';
        w_result := CST_FTP_ERR2;
        //�G���[�I���̏ꍇ
        goto p_UpDate;
      end;
      res := DB_RisShema.func_UpDate_ExtendOrderMain(w_sErr);
      //����I���̏ꍇ
      if res then begin
        proc_StrConcat(wg_ErrMSG,'URL���̓o�^OK');
      end
      //�ُ�I���̏ꍇ
      else begin
        proc_StrConcat(wg_ErrMSG,'URL���̓o�^NG�u'+w_sErr+'�v');
        WSWorkErr := 'URL���o�^ NG';
        DB_RisShema.wg_Log_Flg := G_LOG_LINE_HEAD_NG;
        w_result := CST_FTP_ERR2;
        //�G���[�I���̏ꍇ
        goto p_UpDate;
      end;
    end;

    //���M���ʓo�^
    res := DB_RisShema.func_SetOrderResult(w_sErr);
    //����I���̏ꍇ
    if res then begin
      proc_StrConcat(wg_ErrMSG,'�V�F�[�}�擾���ʂ̓o�^OK');
    end
    //�ُ�I���̏ꍇ
    else begin
      proc_StrConcat(wg_ErrMSG,'�V�F�[�}�擾���ʂ̓o�^NG�u'+w_sErr+'�v');
      DB_RisShema.wg_Log_Flg := G_LOG_LINE_HEAD_NG;
      //�G���[�I���̏ꍇ
      goto p_err;
    end;
    //���ׂĐ���̏ꍇ
    p_end:
      try
        //�R�~�b�g
        FDB.Commit;
      except
        //���[���o�b�N
        FDB.Rollback;
        raise;
      end;
      //�����I��
      Exit;
    //�r���Ŏ��s�����ꍇ
    p_UpDate:
      //8.��M���ʂ���M�I�[�_�e�[�u���֓o�^
      w_sysdate := FQ_SEL.GetSysDateYMDHNS;
      //���M���ʓo�^
      res := DB_RisShema.func_SetOrderResult_Up(wg_RIS_ID, w_result, WSWorkErr, w_sErr);
      //����I���̏ꍇ
      if res then begin
        proc_StrConcat(wg_ErrMSG,'�V�F�[�}�擾���ʂ̓o�^OK');
      end
      //�ُ�I���̏ꍇ
      else begin
        proc_StrConcat(wg_ErrMSG,'�V�F�[�}�擾���ʂ̓o�^NG�u'+w_sErr+'�v');
        DB_RisShema.wg_Log_Flg := G_LOG_LINE_HEAD_NG;
        //�G���[�I���̏ꍇ
        goto p_err;
      end;

      try
        //�R�~�b�g
        FDB.Commit;
      except
        //���[���o�b�N
        FDB.Rollback;
        raise;
      end;
      //�����I��
      Exit;
    p_err:
      try
        //�R�~�b�g
        FDB.Rollback;
      except
        //���[���o�b�N
        FDB.Rollback;
        raise;
      end;
      //�����I��
      Exit;
  except
    on E:Exception do
    begin
      DB_RisShema.wg_Log_Flg := G_LOG_LINE_HEAD_NG;
      proc_StrConcat(wg_ErrMSG,'�\�z�O�̃G���[���������܂��� ' + E.Message);
      //proc_LogOut('NG','',G_LOG_KIND_DB_NUM,'�\�z�O�̃G���[���������܂��� ' + E.Message);
      //�����I��
      Exit;
    end;
  end
end;
//=============================================================================
//����������������������������������������������������������������
//=============================================================================
initialization
begin
//1)�N��PASS���m��
     g_TcpIniPath := ExtractFilePath( ParamStr(0) );
end;

finalization
begin
//
end;

end.
