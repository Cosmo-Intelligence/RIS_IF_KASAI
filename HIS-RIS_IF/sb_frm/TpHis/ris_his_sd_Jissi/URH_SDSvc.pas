unit URH_SDSvc;
(**
���@�\����
  His�ւ̏�񑗐M�T�[�r�X�̐���

������
�@�V�K�쐬�F2004.10.12�F�S�� ���c �F
*)
interface //*****************************************************************
//�g�p���j�b�g---------------------------------------------------------------
uses
//�V�X�e���|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|
  Windows, Messages, SysUtils, Classes, Graphics, Controls, SvcMgr,
  IniFiles, Dialogs, ExtCtrls,ScktComp,WinSvc,Forms, //Db, DBTables,QForms,
//�v���_�N�g�J�����ʁ|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|
  Gval,
  HisMsgDef,
  HisMsgDef02_JISSI,
  TcpSocket,
  UDb_RisSD,
  Unit_Log, Unit_DB
  ;

////�^�N���X�錾-------------------------------------------------------------
type
  TRisHisSDSvc_Jissi = class(TService)
    ClientSocket1: TClientSocket;
    procedure ServiceExecute(Sender: TService);
    procedure ServiceDestroy(Sender: TObject);
    procedure ServiceStop(Sender: TService; var Stopped: Boolean);
    procedure ServiceCreate(Sender: TObject);
    procedure ClientSocket1Connect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure ClientSocket1Disconnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure ClientSocket1Error(Sender: TObject; Socket: TCustomWinSocket;
      ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure ClientSocket1Read(Sender: TObject; Socket: TCustomWinSocket);
    procedure ClientSocket1Write(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure ServiceAfterInstall(Sender: TService);
    procedure ServiceAfterUninstall(Sender: TService);
    procedure ServiceStart(Sender: TService; var Started: Boolean);
  private
    { Private �錾 }
    w_SendMsgStream : TStringStream;
    w_RecvMsgStream : TStringStream;
    //wb_ConnectFlg: Boolean;
    wgs_IPPort: String;
    wgi_Pos: Integer;
    //wgs_Host: String;
    wg_RetryCount: Integer;
    procedure proc_C_StatusList(arg_Status: string;arg_string: string);
    function func_SendStream(
                    arg_SendStream    : TStringStream;
                    arg_SendStream_Len: Longint;
                    arg_TimeOut       : DWORD;
                    arg_MsgKind       : string;
                    arg_RecvStream: TStringStream
                    ): string;
    function func_SendMsgBase(
                    arg_SendStream    : TStringStream;
                    arg_SendStream_Len: Longint;
                    arg_TimeOut       : DWORD;
                    arg_MsgKind       : string;
                    arg_RecvStream: TStringStream
                    ): string;
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
var
  RisHisSDSvc_Jissi: TRisHisSDSvc_Jissi;
//�֐��葱���錾-------------------------------------------------------------

implementation //**************************************************************

//�g�p���j�b�g---------------------------------------------------------------
//uses UDb_Ris;
{$R *.DFM}

//�萔�錾       -------------------------------------------------------------
//const

//�ϐ��錾     ---------------------------------------------------------------
//var

//�֐��葱���錾--------------------------------------------------------------
//=============================================================================
//�T�[�r�X�֘A������������������������������������������������������������������
//=============================================================================
procedure ServiceController(CtrlCode: DWord); stdcall;
begin
  RisHisSDSvc_Jissi.Controller(CtrlCode);
end;

function TRisHisSDSvc_Jissi.GetServiceController: TServiceController;
begin
  Result := ServiceController;
end;

//�T�[�r�X�쐬
procedure TRisHisSDSvc_Jissi.ServiceCreate(Sender: TObject);
begin
  //DB�N���X�쐬
  DB_RisSD := TDB_RisSD.Create();
  //�d���i�[��m��
  w_SendMsgStream := TStringStream.Create('');
  w_RecvMsgStream := TStringStream.Create('');
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
procedure TRisHisSDSvc_Jissi.ServiceDestroy(Sender: TObject);
begin
  //DB�N���X�쐬
  if Assigned(DB_RisSD) then FreeAndNil(DB_RisSD);
  //�d����̉��
  w_SendMsgStream.Free;
  w_RecvMsgStream.Free;
  //�T�[�r�X����
  proc_LogOut(G_LOG_LINE_HEAD_NP, '', G_LOG_KIND_SVC_NUM,
              '*****�T�[�r�X��j�����܂���*****');
end;
//
procedure TRisHisSDSvc_Jissi.ServiceStart(Sender: TService;
  var Started: Boolean);
begin
//
end;
//�T�[�r�X��~
procedure TRisHisSDSvc_Jissi.ServiceStop(Sender: TService;
  var Stopped: Boolean);
begin
  //���O�o��
  proc_LogOut(G_LOG_LINE_HEAD_NP, '', G_LOG_KIND_SVCDEF_NUM,
              '*****�T�[�r�X���~���܂���*****');
end;
//�T�[�r�X�C���X�g�[��
procedure TRisHisSDSvc_Jissi.ServiceAfterInstall(Sender: TService);
begin
  //���O�o��
  proc_LogOut(G_LOG_LINE_HEAD_NP, '', G_LOG_KIND_SVCDEF_NUM,
              '*****�T�[�r�X���C���X�g�[�����܂���*****');
end;
//�T�[�r�X�A���C���X�g�[��
procedure TRisHisSDSvc_Jissi.ServiceAfterUninstall(Sender: TService);
begin
  //���O�o��
  proc_LogOut(G_LOG_LINE_HEAD_NP, '', G_LOG_KIND_SVCDEF_NUM,
              '*****�T�[�r�X���A���C���X�g�[�����܂���*****');
end;

//�T�[�r�X���s����
procedure TRisHisSDSvc_Jissi.ServiceExecute(Sender: TService);
var
  w_StopTimestamp:  TTimeStamp;
  w_StopDateTime:   TDateTime ;
  res:              boolean;
  w_sErr:           string;

  cnt_record:       Integer;
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
      wg_RetryCount := 0;
      ClientSocket1.Active := False;

      //�T�[�r�X���s��
      while not Terminated do
      begin
        //�A�N�e�B�u���̂ݓ��삷��
        if g_Svc_Ex_Acvite = g_SOCKET_ACTIVE then
        begin
          //DB���I�[�v������ ��O�𔭐����Ȃ��悤��
          if DB_RisSD.RisDBOpen(w_sErr, self) then
          begin
            proc_LogOut(G_LOG_LINE_HEAD_OK, '', G_LOG_KIND_DB_NUM, 'DB�ڑ�OK');
            //�K��������
            w_SendMsgStream := TStringStream.Create('');
            w_RecvMsgStream := TStringStream.Create('');
            if wgs_IPPort = '' then
            begin
              try
                  //IP�A�h���X�E�|�[�g�̎擾
                  wgs_IPPort := func_GetServiceInfo(CST_APPID_HSND02,
                                                    FQ_SEL,
                                                    DB_RisSD.wg_DBFlg,
                                                    w_sErr);
                  //";"�i��؂蕶���j�̌���
                  wgi_Pos := Pos(CST_IPPORT_SP, wgs_IPPort);
                  //���O�o��
                  proc_LogOut(G_LOG_LINE_HEAD_NP, '', G_LOG_KIND_SK_CL_NUM,
                              'IP = ' + Copy(wgs_IPPort, 1, wgi_Pos - 1));
                  //���O�o��
                  proc_LogOut(G_LOG_LINE_HEAD_NP, '', G_LOG_KIND_SK_CL_NUM,
                              '�|�[�g = ' + Copy(wgs_IPPort, wgi_Pos + 1,
                              Length(wgs_IPPort)));
                  //�T�[�r�X���I���̏ꍇ
                  if Terminated then
                  begin
                    //�����𔲂���
                    Break;
                  end;
              except
                //�G���[�I������
                on E:exception do
                begin
                  //���O�o��
                  proc_LogOut(G_LOG_LINE_HEAD_NG, '', G_LOG_KIND_NG_NUM,
                              'Socket���擾NG�u'+ E.Message + '�v');
                  //�T�[�r�X���I���̏ꍇ
                  if Terminated then
                  begin
                    //�����𔲂���
                    Break;
                  end;
                end;
              end;
            end;
            try
              //His���M����
              //2.���M�I�[�_�e�[�u������s�v���R�[�h���폜
              res := DB_RisSD.func_DelOrder(g_RisDB_SndEXKeep,w_sErr);
              //����I���̏ꍇ
              if res then begin
                //���O�o��
                proc_LogOut(G_LOG_LINE_HEAD_OK,'',G_LOG_KIND_DB_IN_NUM,'HIS���M���N�G�X�g�e�[�u���s�v���R�[�h�폜OK');
              end
              //�ُ�I��
              else begin
                //���O�o��
                proc_LogOut(G_LOG_LINE_HEAD_NG,'',G_LOG_KIND_NG_NUM,'HIS���M���N�G�X�g�e�[�u���s�v���R�[�h�폜NG�u'+w_sErr+'�v');
              end;
              //���M�I�[�_�e�[�u���̎擾
              res := DB_RisSD.func_GetOrder(cnt_record, w_sErr);
              //����I���̏ꍇ
              if res then
              begin
                //���O�\��
                proc_LogOut(G_LOG_LINE_HEAD_OK, '', G_LOG_KIND_DB_NUM,
                            'HIS���M���N�G�X�g�e�[�u���擾OK�u' +
                            IntToStr(cnt_record) +
                            '���v');
                //�T�[�r�X�N������
                //���R�[�h��������
                //�擾���R�[�h�̍Ō�Ŗ����ꍇ
                while (not Terminated) and
                      (cnt_record > 0) and
                      (not (FQ_SEL_ORD.Eof)) do
                begin
                  //��M�̈悪�쐬����Ă���ꍇ
                  if w_RecvMsgStream <> nil then
                  begin
                    //�J��
                    FreeAndNil(w_RecvMsgStream);
                  end;
                  //���M�̈悪�쐬����Ă���ꍇ
                  if w_SendMsgStream <> nil then
                  begin
                    //�J��
                    FreeAndNil(w_SendMsgStream);
                  end;
                  //���M�̈�쐬
                  w_SendMsgStream := TStringStream.Create('');
                  //��M�̈�쐬
                  w_RecvMsgStream := TStringStream.Create('');

                  //4-8�̏���
                  proc_Main;

                  if wg_RetryCount = 0 then
                    //���̃��R�[�h�Ɉړ�
                    FQ_SEL_ORD.Next;
                end;
              end
              //�ُ�I���̏ꍇ
              else
              begin
                proc_LogOut(G_LOG_LINE_HEAD_NG, '', G_LOG_KIND_NG_NUM,
                            '���M�I�[�_�e�[�u���擾NG�u' + w_sErr + '�v');
              end;
            Except
              //DB�̐ؒf
              DB_RisSD.RisDBClose;
              proc_LogOut(G_LOG_LINE_HEAD_NP, '', G_LOG_KIND_DB_NUM,
                          '*****RIS DB�ڑ����I�����܂���*****');
            end;
          //DB�I�[�v�����s
          end
          else
          begin
            proc_LogOut(G_LOG_LINE_HEAD_NG, '', G_LOG_KIND_NG_NUM,
                        'RIS DB�ڑ�NG�u' + w_sErr + '�v');
          end;

          //��M�̈悪�쐬����Ă���ꍇ
          if w_RecvMsgStream <> nil then
          begin
            //�J��
            FreeAndNil(w_RecvMsgStream);
          end;
          //���M�̈悪�쐬����Ă���ꍇ
          if w_SendMsgStream <> nil then
          begin
            //�J��
            FreeAndNil(w_SendMsgStream);
          end;
          //���M�̈�쐬
          w_SendMsgStream := TStringStream.Create('');
          //��M�̈�쐬
          w_RecvMsgStream := TStringStream.Create('');
          //�^�C���X�^���v�̎擾
          w_StopTimestamp := DateTimeToTimeStamp(now);
          //�I�������̎擾
          w_StopTimestamp.Time := w_StopTimestamp.Time + g_Svc_Ex_Cycle * 1000;
          //�I�������̐ݒ�
          w_StopDateTime := TimeStampToDateTime(w_StopTimestamp);
          //�I���������z���邩�A�T�[�r�X���I�����ꂽ�ꍇ
          while (not Terminated) and (w_StopDateTime>Now) do
          begin
            sleep(1000);
            ServiceThread.ProcessRequests(false);
          end;
          //�G���[���b�Z�[�W������
          w_sErr := '';
        end
        else
        begin
          ServiceThread.ProcessRequests(false);
        end;
      end;
      //DB�̐ؒf
      DB_RisSD.RisDBClose;
      proc_LogOut(G_LOG_LINE_HEAD_NP, '', G_LOG_KIND_SVC_NUM,
                  '*****�T�[�r�X���I�����܂�*****');
      //�����I��
      Exit;
    except
      //DB�̐ؒf
      DB_RisSD.RisDBClose;
      //�����I��
      Exit;
    end;
  finally
    //�J��
    if Assigned(FQ_SEL) then FreeAndNil(FQ_SEL);
    if Assigned(FQ_SEL_ORD) then FreeAndNil(FQ_SEL_ORD);
    if Assigned(FQ_SEL_BUI) then FreeAndNil(FQ_SEL_BUI);
    if Assigned(FQ_ALT) then FreeAndNil(FQ_ALT);
    if Assigned(FLog) then FreeAndNil(FLog);
    if Assigned(FDebug) then FreeAndNil(FDebug);
  end;
end;

//=============================================================================
//�N���C�A���g�\�P�b�g������������������������������������������������������������������
//=============================================================================
//�N���C�A���g�\�P�b�g�ڑ��ʒm
procedure TRisHisSDSvc_Jissi.ClientSocket1Connect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  proc_C_StatusList('OK','Connected to: ' + Socket.RemoteAddress);
end;
//�N���C�A���g�\�P�b�g�ؒf�ʒm
procedure TRisHisSDSvc_Jissi.ClientSocket1Disconnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  proc_C_StatusList('OK','DisConnected to: ' + Socket.RemoteAddress);

end;
//�N���C�A���g�\�P�b�g�G���[�ʒm
procedure TRisHisSDSvc_Jissi.ClientSocket1Error(Sender: TObject;
  Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
  var ErrorCode: Integer);
begin
  proc_LogOut(G_LOG_LINE_HEAD_NG, '', G_LOG_KIND_NG_NUM,
              'Error...'+IntToStr(ErrorCode));
  ErrorCode:=0; //��O�͔��������Ȃ�
end;
//�N���C�A���g�\�P�b�g������M�ʒm
procedure TRisHisSDSvc_Jissi.ClientSocket1Read(Sender: TObject;
  Socket: TCustomWinSocket);
begin
//��u���b�L���O�̏���
end;
procedure TRisHisSDSvc_Jissi.ClientSocket1Write(Sender: TObject;
  Socket: TCustomWinSocket);
begin
//
end;
//�X�e�[�^�X�\��
procedure TRisHisSDSvc_Jissi.proc_C_StatusList(arg_Status: string;arg_string: string);
begin
  try
    proc_LogOut(arg_Status,'',G_LOG_KIND_SK_CL_NUM,arg_string);
  except
    exit;
  end;
end;
//=============================================================================
//�N���C�A���g�\�P�b�g��������������������������������������������������������������������
//=============================================================================
//=============================================================================
//�N���C�A���g�\�P�b�g�d�����M������������������������������������������������������������������
//=============================================================================
{
-----------------------------------------------------------------------------
  ���O : func_SendStream;
  ���� : �Ȃ�
   arg_SendStream:TStringStream; ���M�f�[�^
   arg_SendStream_Len: Longint;  ���M�f�[�^��
   arg_TimeOut   : DWORD         �^�C���A�E�g����ms
   arg_MsgKind   : string;       �d�����
   arg_RecvStream: TStringStream �߂��M�d��
  �@�\ : ���ēd�����M�@�\
  ���A�l�F��O�͔������Ȃ�
      �װ����(2�� YY
              YY�F�ڍ�
              00�F����
              01�F���M���s
              02�F������
              03�F��M���s
              )
-----------------------------------------------------------------------------
}
function TRisHisSDSvc_Jissi.func_SendStream(
                    arg_SendStream    : TStringStream;
                    arg_SendStream_Len: Longint;
                    arg_TimeOut       : DWORD;
                    arg_MsgKind       : string;
                    arg_RecvStream: TStringStream
                    ): string;
var
   res:Longint;
   w_SocketStream:TWinSocketStream;
   w_SendStream_Buf:TBuffur;
   w_ReadStream_Buf:TBuffur;
   w_s:string;
   w_p:Longint;
begin
//��O�͔��������Ȃ�
//�@���M �i����OBJ�j�� �i���ēd��������j�𑗐M����B
{
 �N���C�A���g�u���b�L���O�ڑ��ƃN���C�A���g��u���b�L���O�ڑ�
 �̂����u���b�L���O�ڑ����g���B
}
  // �N���C�A���g�u���b�L���O�ڑ�
  try
    //�������ݽ�ذт��쐬
    w_SocketStream := TWinSocketStream.Create(ClientSocket1.Socket, arg_TimeOut);
    try
      arg_SendStream.Position := 0;
      arg_SendStream.Read(w_SendStream_Buf, arg_SendStream_Len);
      //��������
      proc_C_StatusList(G_LOG_LINE_HEAD_NP,'�d�����M�J�n...< ' + ' >');
      res := w_SocketStream.Write(w_SendStream_Buf, arg_SendStream_Len);
      //���s�F01
      if (res < arg_SendStream_Len) then
      begin
        Result := G_TCPSND_PRTCL_ERR01;
        proc_LogOut(G_LOG_LINE_HEAD_NG, '', G_LOG_KIND_NG_NUM,
                    'Error...func_SendStream:�i�@�s���S���M�j' + Result);
        Exit;
  //�@<<----
      end;
    finally
      FreeAndNil(w_SocketStream);
    end;
    proc_LogOut(G_LOG_LINE_HEAD_NP, '', G_LOG_KIND_DEBUG_NUM,
                '���M�d�� = ' + arg_SendStream.DataString);
    proc_C_StatusList(G_LOG_LINE_HEAD_NP, '���M�T�C�Y = ' + IntToStr(res) +
                      'Byte');
    proc_C_StatusList(G_LOG_LINE_HEAD_NP, '�d�����M����...');
  except
    on E: Exception do
    begin
      Result := G_TCPSND_PRTCL_ERR01;

      proc_LogOut(G_LOG_LINE_HEAD_NG, '', G_LOG_KIND_NG_NUM,
                  'Error...func_SendStream:�i�A���M��O' + E.Message + '�j' + Result);
      Exit;
    end;
  //�A<<----
  end;
  //�A������M
  //  �X���b�h���쐬�i�ԓ���A�^�C���A�E�g�b��ms�j���ď�L�̕ԓ���҂i�^�C���A�E�g���Ԃ����j
  // �N���C�A���g�u���b�L���O�ڑ�
  try
    //�Ǎ��݃X�g���[�����쐬
    w_SocketStream := TWinSocketStream.Create(ClientSocket1.Socket, arg_TimeOut);
    try
      //��M�Ǎ��ݏ���
      if False = w_SocketStream.WaitForData(arg_TimeOut) then
      begin
        //�^�C���A�E�g
        Result := G_TCPSND_PRTCL_ERR02;

        proc_LogOut(G_LOG_LINE_HEAD_NG, '', G_LOG_KIND_NG_NUM,
                    'Error...func_SendStream:�i�B�^�C���A�E�g�j' + Result);
        Exit;
  //�B<<----
      end
      else
      begin//�Ǎ���
        //�����Ǎ��ݕK�v��
        w_p := 0;
        arg_RecvStream.Position := 0;
        while (w_p < g_Stream_Base[COMMON1DENLENNO].offset) do
        begin
          res := w_SocketStream.Read(w_ReadStream_Buf, sizeof(w_ReadStream_Buf));
          if res=0 then
          begin
            Result := G_TCPSND_PRTCL_ERR02;

            proc_LogOut(G_LOG_LINE_HEAD_NG, '', G_LOG_KIND_NG_NUM,
                        'Error...func_SendStream:�i�C��^�C���A�E�g�j' + Result);
            Exit;
  //�C<<----
          end;
          arg_RecvStream.Write(w_ReadStream_Buf, res);
          w_p := w_p + res;
        end;
        //�T�C�Y�̂���ŏ��܂œǂ߂�
        arg_RecvStream.Position := g_Stream_Base[COMMON1DENLENNO].offset;

        w_s := arg_RecvStream.ReadString(g_Stream_Base[COMMON1DENLENNO].size);

        arg_RecvStream.Position := w_p;

        while (w_p - G_MSGSIZE_START < StrToIntDef(w_s, 0)) do
        begin
          res := w_SocketStream.Read(w_ReadStream_Buf,sizeof(w_ReadStream_Buf));
          arg_RecvStream.Write(w_ReadStream_Buf, res);
          w_p := w_p + res;
          if res = 0 then
            Break;
        end;

      end;
      //��M�d���̒����`�F�b�N
      if w_p - G_MSGSIZE_START <> StrToIntDef(w_s, 0) then
      begin
        Result := G_TCPSND_PRTCL_ERR03;
        proc_LogOut(G_LOG_LINE_HEAD_NG, '', G_LOG_KIND_NG_NUM,
                    'Error...func_SendStream:�i�D��M�d���̒��j' + Result);
        Exit;
  //�D<<----
      end;
      proc_LogOut(G_LOG_LINE_HEAD_NP, '', G_LOG_KIND_DEBUG_NUM,
                  '��M�d�� = ' + arg_RecvStream.DataString);
      proc_C_StatusList(G_LOG_LINE_HEAD_NP,
                '�����d����M...< ' + IntToStr(arg_RecvStream.Size) + ' >Byte');
    finally
      FreeAndNil(w_SocketStream);
    end;
  //�B�I������ ���한�A�̐ݒ�
    Result := G_TCPSND_PRTCL_ERR00;
    proc_C_StatusList(G_LOG_LINE_HEAD_OK, 'Complete...func_SendStream:' +
                      Result);
    Exit;
  //�E<<----
  except
    on E: Exception do
    begin
      Result := G_TCPSND_PRTCL_ERR03;
      proc_LogOut(G_LOG_LINE_HEAD_NG, '', G_LOG_KIND_NG_NUM,
                  'Error...func_SendStream:�i�F��M��O:' + E.Message +'�j' + Result);
      Exit;
  //�F<<----
    end;
  end;
end;

(**
-----------------------------------------------------------------------------
 * @outline       func_SendMsgBase
   arg_SendStream    : TStringStream;  ���M�f�[�^
   arg_SendStream_Len: Longint;       ���M�f�[�^��
   arg_TimeOut       : DWORD;         �^�C���A�E�g����ms
   arg_MsgKind       : string;        �d�����
   arg_RecvStream: TStringStream   �߂��M�d��
                    ): string;
  ���A�l�F��O�Ȃ�  �װ����
  �װ����(4�� XXYY
              XX�F�����ʒu01�`07
              00�F�Œ�
                YY�F�ڍ�
                00�F����
                01�F���M���s
                02�F������
                03�F��M���s
              )
 * �@�\ : ����M�̊�{�֐�
    1.�\�P�b�g�̃I�[�v��
    2.�d�����M�̈˗�
    3.�d����M
    4.�\�P�b�g�̃N���[�Y
 *
-----------------------------------------------------------------------------
 *)
function TRisHisSDSvc_Jissi.func_SendMsgBase(
                    arg_SendStream    : TStringStream;
                    arg_SendStream_Len: Longint;
                    arg_TimeOut       : DWORD;
                    arg_MsgKind       : string;
                    arg_RecvStream: TStringStream
                    ): string;
var
  w_RtCode: string;
begin
  try
    //IP�A�h���X�̐ݒ�
    ClientSocket1.Address := Copy(wgs_IPPort, 1, wgi_Pos - 1);
    //�|�[�g�̐ݒ�
    ClientSocket1.Port := StrToIntDef(Copy(wgs_IPPort, wgi_Pos + 1,
                                           Length(wgs_IPPort)),0);
    ClientSocket1.Active := True;
    //�\�P�b�g�ڑ�
    ClientSocket1.Open;
    //���S�ɏI���������܂ő҂�
    repeat
      Application.ProcessMessages;
      //�ҋ@����
      sleep(1000);
    until (ClientSocket1.Socket.Connected);
    //���O�o��
    proc_LogOut(G_LOG_LINE_HEAD_OK,'',G_LOG_KIND_SK_CL_NUM,'Socket�̐ڑ��ɐ������܂����B');
    //�v���g�R�����M�@�\
    w_RtCode := func_SendStream(arg_SendStream, arg_SendStream_Len,
                                arg_TimeOut, arg_MsgKind, arg_RecvStream);
    Result := G_TCPSND_PRTCL00 + w_RtCode;

    proc_C_StatusList(G_LOG_LINE_HEAD_OK,'Complete...func_SendMsgBase:'+result);

    ClientSocket1.Close;
    //���S�ɏI���������܂ő҂�
    repeat
      Application.ProcessMessages;
      Sleep(1000);
    until not(ClientSocket1.Socket.Connected);
    //���O�o��
    proc_LogOut(G_LOG_LINE_HEAD_OK,'',G_LOG_KIND_SK_CL_NUM,'Socket�̐ؒf�ɐ������܂����B');
    Exit;
//�@<<----
  except
    on E: Exception do
    begin
      Result := G_TCPSND_PRTCL00 +G_TCPSND_PRTCL_ERR01;
      proc_LogOut(G_LOG_LINE_HEAD_NG, '', G_LOG_KIND_NG_NUM,
                  'Error...func_SendMsgBase:(��O�ʐM��ُ�:' + E.Message + ')' + Result);
      Exit;
    end;
//�A<<----
  end;
end;
//=============================================================================
//����������������������������������������������������������������
//=============================================================================

//=============================================================================
//�d���쐬�y�ё��M������������������������������������������������������������������
//=============================================================================
{-----------------------------------------------------------------------------
  ���O : proc_Main;
  ���� : �Ȃ�
  �@�\ :
  �P�g�����U�N�V��������
  �d���̍쐬�Ƒ��M
  ���A�l�F��O�͔������Ȃ�
-----------------------------------------------------------------------------}
//HIS�ւ̂P�d�����M����
procedure TRisHisSDSvc_Jissi.proc_Main;
var
  res:boolean;
  w_sErr:string;
  w_result:string;
  w_orderkinf:string;
  w_sysdate:string;
  w_Flg:String;
  w_NullFlg:String;
label
  p_err,
  p_end;
begin
  //��ݻ޸��݊J�n
  FDB.StartTransaction;
  try
    //������
    w_NullFlg := '';

    proc_LogOut(G_LOG_LINE_HEAD_OK, '', G_LOG_KIND_MS_ANLZ_NUM,
                '���M�d���A�� = ' + FQ_SEL_ORD.GetString('REQUESTID'));
    //4 �J�����g�̃I�[�_�œd�����쐬����
    res := DB_RisSD.func_MakeMsg(w_SendMsgStream, w_sErr, w_NullFlg);
    //����I���̏ꍇ
    if res then
    begin
      //�d���쐬�f�[�^�L��
      if w_NullFlg = '' then
      begin
        proc_LogOut(G_LOG_LINE_HEAD_OK, '', G_LOG_KIND_MS_ANLZ_NUM,
                    '���M�d���̍쐬OK');
      end
      //�d���쐬�f�[�^�Ȃ�
      else if w_NullFlg = '1' then
      begin
        proc_LogOut(G_LOG_LINE_HEAD_NG,'',G_LOG_KIND_NG_NUM,
        '���M�d���̍쐬NG�u�d���쐬�̂��߂̃f�[�^������܂���B ' + w_sErr + '�v') ;
      end;
    end
    //�ُ�I���̏ꍇ
    else
    begin
      proc_LogOut(G_LOG_LINE_HEAD_NG, '', G_LOG_KIND_NG_NUM,
                  '���M�d���̍쐬NG�u' + w_sErr + '�v');
      //�G���[�I��
      goto p_err;
    end;
//4 �d����o�^����
    //�f�[�^����̏ꍇ
    if w_NullFlg = '' then
    begin
      //�d���o�^�t���O��ON�̏ꍇ
      if g_Rig_LogIncMsg <> CST_SAVE_OFF then
      begin
        //�d���̓o�^
        res := DB_RisSD.func_SaveMsg(w_SendMsgStream,w_sErr);
        //����I���̏ꍇ
        if res then
        begin
          proc_LogOut(G_LOG_LINE_HEAD_OK, '', G_LOG_KIND_DB_OUT_NUM,
                      '���M�d���̓o�^OK');
        end
        //�ُ�I���̏ꍇ
        else
        begin
          proc_LogOut(G_LOG_LINE_HEAD_NG, '', G_LOG_KIND_NG_NUM,
                      '���M�d���̓o�^NG�u' + w_sErr + '�v');
          //�G���[�I��
          goto p_err;
        end;
      end;
    end;
    if w_NullFlg = '' then
    begin
  //5�����i���`�F�b�N
      res := DB_RisSD.func_CheckOrder(w_sErr,w_Flg,w_NullFlg);
      //�����i���G���[�̏ꍇ
      if (w_Flg = '1') then
      begin
        proc_LogOut(G_LOG_LINE_HEAD_NG, '', G_LOG_KIND_NG_NUM,
                    '�����i���`�F�b�NNG�u' + w_sErr + '�v');
      end
      //�����i�����������ꍇ
      else
      begin
        //�����f�[�^������ꍇ
        if w_NullFlg = '' then
        begin
          proc_LogOut(G_LOG_LINE_HEAD_OK, '', G_LOG_KIND_DB_OUT_NUM,
                      '�����i���`�F�b�NOK');
        end
        //�f�[�^���Ȃ��ꍇ
        else
        begin
          //�����I�Ƀt���O��ύX
          res := False;
          proc_LogOut(G_LOG_LINE_HEAD_NG, '', G_LOG_KIND_NG_NUM,
                      '�����i���`�F�b�NNG�u' + w_sErr + '�v');
        end;
      end;
    end
    else if w_NullFlg = '2' then
    begin
      //�����I�Ƀt���O��ύX
      res := False;
      proc_LogOut(G_LOG_LINE_HEAD_OK, '', G_LOG_KIND_NG_NUM,
                  'HIS���M�`�F�b�N�u' + w_sErr + '�v');
    end
    else
    begin
      //�����I�Ƀt���O��ύX
      res := False;
    end;
    //����I���̏ꍇ
    if res then
    begin
    //�i���`�F�b�NOK
//6 ���M
      //�����敪�̎擾
      w_orderkinf := FQ_SEL_ORD.GetString('REQUESTTYPE');
      //������
      w_result := '';
      //���{�d���̏ꍇ
      if (w_orderkinf = CST_APPTYPE_OP01) or
         (w_orderkinf = CST_APPTYPE_OP02) or
         (w_orderkinf = CST_APPTYPE_OP99) then
      begin
        //���M
        w_result := self.func_SendMsgBase(w_SendMsgStream,w_SendMsgStream.Size,
                                          g_C_Socket_Info_03.f_TimeOut,
                                          G_MSGKIND_JISSI,
                                          w_RecvMsgStream);
      end
      //����ȊO�̏ꍇ
      else
      begin
        //�d����� �����敪 �ݒ肠��܂�
        proc_LogOut(G_LOG_LINE_HEAD_NG, '', G_LOG_KIND_NG_NUM,
        '���M����NG�u���M�I�[�_�e�[�u���ɐ����������敪���ݒ肳��Ă��܂���v');
        //�G���[�I��
        goto p_err;
      end;
      //����I���̏ꍇ
      if w_result = G_TCPSND_PRTCL00 + G_TCPSND_PRTCL_ERR00 then
      begin
        //���{�d���̏ꍇ
        if (w_orderkinf = CST_APPTYPE_OP01) or
           (w_orderkinf = CST_APPTYPE_OP02) or
           (w_orderkinf = CST_APPTYPE_OP99) then
        begin
          //������ʂ̎擾
          w_result := func_GetStringStream(G_MSG_SYSTEM_C, G_MSGKIND_START,
                                           w_RecvMsgStream,
                                           COMMON1STATUSNO
                                           );
          //���e�R�[�h��SS�̏ꍇ
          if w_result = CST_DENBUNID_OK then
          begin
            //����I��
            proc_LogOut(G_LOG_LINE_HEAD_OK,'',G_LOG_KIND_MS_ANLZ_NUM,'����I��');
            //OK
            w_result := CST_ORDER_RES_OK;

            wg_RetryCount := 0;
          end
          //������ʂ�OK�ȊO�̏ꍇ
          else if w_result = CST_DENBUNID_NG then
          begin
            //�ُ�I��
            proc_LogOut(G_LOG_LINE_HEAD_NG,'',G_LOG_KIND_NG_NUM,'�ُ�I��');
            inc(wg_RetryCount);

            wg_RetryCount := 0;
            //NG
            w_result := CST_ORDER_RES_NG2;
          end
          //������ʂ�OK�ȊO�̏ꍇ
          else if w_result = CST_DENBUNID_RE then
          begin
            //�ُ�I��
            proc_LogOut(G_LOG_LINE_HEAD_NG,'',G_LOG_KIND_NG_NUM,'���g���C');
            inc(wg_RetryCount);

            if wg_RetryCount = g_C_Socket_Info_03.f_Retry then
            begin
              wg_RetryCount := 0;
              //NG
              w_result := CST_ORDER_RES_NG2;
            end
            else
            begin
              //NG
              w_result := CST_ORDER_RES_NG3;
            end;
          end;
        end
        //�ُ�I���̏ꍇ
        else
        begin
          //�d����� �����敪 �ݒ肠��܂�
          proc_LogOut(G_LOG_LINE_HEAD_NG,'',G_LOG_KIND_NG_NUM,'�ʐM�L�����Z��');
          //�ʐM�G���[
          w_result := CST_ORDER_RES_CL;
        end;
      end
      //�^�C���A�E�g�I��
      else if w_result = G_TCPSND_PRTCL00 + G_TCPSND_PRTCL_ERR02 then
      begin
        //�^�C���A�E�g
        proc_LogOut(G_LOG_LINE_HEAD_NG,'',G_LOG_KIND_NG_NUM,'�^�C���A�E�g�I��');
        inc(wg_RetryCount);

        if wg_RetryCount = g_C_Socket_Info_03.f_Retry then
        begin
          wg_RetryCount := 0;
          //NG
          w_result := CST_ORDER_RES_NG1;
        end
        else
        begin
          //NG
          w_result := CST_ORDER_RES_NG3;
        end;
      end
      else
      begin
        inc(wg_RetryCount);
        if wg_RetryCount = g_C_Socket_Info_03.f_Retry then
        begin
          wg_RetryCount := 0;
          //NG
          w_result := CST_ORDER_RES_NG1;
        end
        else
        begin
          //NG
          w_result := CST_ORDER_RES_NG3;
        end;
      end;
    end
    //�����i���G���[�̏ꍇ
    else
    begin
      //�i���`�F�b�N �L�����Z��
      w_result := CST_ORDER_RES_CL;
      wg_RetryCount := 0;
    end;
//7���M���ʂ𑗐M�I�[�_�e�[�u���֓o�^
    w_sysdate := FQ_SEL.GetSysDateYMDHNS;
    //���M���ʓo�^
    res := DB_RisSD.func_SetOrderResult(
                            w_SendMsgStream,
                            w_sysdate,
                            w_result,
                            w_sErr);
    //����I���̏ꍇ
    if res then
    begin
      proc_LogOut(G_LOG_LINE_HEAD_OK, '', G_LOG_KIND_DB_OUT_NUM, '���M���ʂ̓o�^OK');
    end
    //�ُ�I���̏ꍇ
    else
    begin
      proc_LogOut(G_LOG_LINE_HEAD_NG, '', G_LOG_KIND_NG_NUM,
                  '���M���ʂ̓o�^NG�u' + w_sErr + '�v');
    end;
    //���ׂĐ���̏ꍇ
    p_end:
      Sleep(100);
      try
        //�R�~�b�g
        FDB.Commit;
      except
        raise;
      end;
      //�����I��
      Exit;
    p_err:
      Sleep(100);
      //���[���o�b�N
      FDB.Rollback;
      //�����I��
      Exit;
  except
    on E:Exception do
    begin
      proc_LogOut(G_LOG_LINE_HEAD_NG,'',G_LOG_KIND_NG_NUM,
                  '�\�z�O�̃G���[���������܂����B ' + E.Message);
      //���[���o�b�N
      FDB.Rollback;
      //�����I��
      Exit;
    end;
  end
end;
//=============================================================================
//����������������������������������������������������������������
//=============================================================================

//=============================================================================
//���̑��C�x���g������������������������������������������������������������������
//=============================================================================

//------------------------------------------------------------------------------

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
