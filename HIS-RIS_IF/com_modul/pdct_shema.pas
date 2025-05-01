unit pdct_shema;
{
���@�\���� �i�g�p�\��F����j
 EXE�v���W�F�N�g�̃V�F�[�}���ʃ��[�`��
������
�C��  �F2002.11.05�F���c
�C���@�F2003.02.07�F���c �F
�@�@�@�@�@�@�@�@�@�@�I�[�_NO�ύX�ɔ����C��
}
interface //*****************************************************************
//�g�p���j�b�g---------------------------------------------------------------
uses
//�V�X�e���|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|
  Windows,
  Messages,
  SysUtils,
  Classes,
  DBTables,
  IniFiles,
  FileCtrl,
  jis2sjis,
//�v���_�N�g�J�����ʁ|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|
  //NMFtp,
  Gval,
  risftp;

////�^�N���X�錾-------------------------------------------------------------
//type
//�萔�錾-------------------------------------------------------------------

const
CST_SHEMA_DIR = 'shema'; //�N���C�A���g�̃V�F�[�}�i�[��f�B���N�g��(�N���f�B���N�g��+)
CST_SHEMA_HTML_ORIGINAL = 'shemaoriginal.html';
CST_SHEMA_HTML_ORDER = 'shemaorder.html';
CST_SHEMA_END_TITLE = 'SHEMA'; //�V�F�[�}�p�u���E�U�I���^�C�g������������

CST_END_MODULE: string = '';
CST_END_TITLE_PTN1: string = '';
CST_END_TITLE_PTN2: string = '';

//�ϐ��錾-------------------------------------------------------------------
var
//���V�F�[�}�֐��̖߂�
  wg_Ret: Boolean;
  wg_Shema_Ret_Count: integer;
  wg_Shema_Ret_Code: string;
  wg_Shema_Ret_Message: string;
  //�u���E�U�I���p�^�C�g�����������񃊃X�g
  wg_EndTitle_List: array of string;
  wg_EndTitle_Count: integer;

//�֐��葱���錾-------------------------------------------------------------

//��FTP�֌W
  //�V�F�[�}���`�F�b�N
  function func_FTP_Data_Check(
           arg_FtpInfo : TFtp_Info;  //Ftp���
           arg_Shema_File: string;
           arg_MAIN_DIR: string;
           arg_SUB_DIR : string;
           arg_Local_File: string;
           var arg_Error_Code:string;    //�G���[�R�[�h
           var arg_Error_Message:string  //�G���[���b�Z�[�W
           ):Boolean;
  //�I�[�_���C���X�V
  function func_FTP_Update(
           arg_RIS_ID: string;
           arg_MAIN_DIR: string;
           arg_SUB_DIR : string;
           var arg_count: integer;
           var arg_Error_Code:string;    //�G���[�R�[�h
           var arg_Error_Message:string  //�G���[���b�Z�[�W
           ):Boolean;
//�����ϕ\���֌W
  //���[�J���t�@�C����(HIS��RIS����)�쐬
  function func_Shema_Make_FileName(
           arg_RIS_ID: string;
           var arg_count: integer;
           var arg_Error_Code:string;    //�G���[�R�[�h
           var arg_Error_Message:string  //�G���[���b�Z�[�W
           ):Boolean;
  //�V�F�[�}�t�@�C���R�s�[(RIS���ށ�RIS�ײ���)
  function func_Shema_Copy_File(
           var arg_count: integer;
           var arg_Error_Code:string;    //�G���[�R�[�h
           var arg_Error_Message:string  //�G���[���b�Z�[�W
           ):Boolean;
  //HTML�t�@�C���쐬
  function func_Shema_Make_HTML(
           arg_Mode: integer;            //�t�@�C���ʒu(0:�ײ��Ăɺ�߰�ρA1:۰�ق����̂܂܎g�p)
           arg_OrderNO: string;
           arg_KanjaID: string;
           arg_KanjaName: string;
           arg_KensaDate: string;
           arg_KensaType: string;
           arg_IraiSection: string;
           arg_IraiDoctor: string;
           var arg_Error_Code:string;    //�G���[�R�[�h
           var arg_Error_Message:string  //�G���[���b�Z�[�W
           ):Boolean;


implementation

uses DB;

//uses DB; //**************************************************************

//�g�p���j�b�g---------------------------------------------------------------
//uses

//�萔�錾       -------------------------------------------------------------
//const

//�ϐ��錾     ---------------------------------------------------------------
//var
//�֐��葱���錾--------------------------------------------------------------
//�g�p�\�֐��|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|

//******************************************************************************
// �V�F�[�}���`�F�b�N
//******************************************************************************
function func_FTP_Data_Check(
         arg_FtpInfo : TFtp_Info;  //Ftp���
         arg_Shema_File: string;
         arg_MAIN_DIR: string;
         arg_SUB_DIR : string;
         arg_Local_File: string;
         var arg_Error_Code:string;    //�G���[�R�[�h
         var arg_Error_Message:string  //�G���[���b�Z�[�W
         ):Boolean;
begin
  Result := False;
  arg_Error_Code := '';
  arg_Error_Message := '';

  if arg_FtpInfo.f_FtpServerName = '' then begin
    arg_Error_Message := #13#10+'�T�[�o���F'+arg_FtpInfo.f_FtpServerName;
    Exit;
  end;
  if arg_FtpInfo.f_FtpServerUID = '' then begin
    arg_Error_Message := #13#10+'���[�U�h�c�F'+arg_FtpInfo.f_FtpServerUID;
    Exit;
  end;
{
  if arg_FtpInfo.f_FtpServerPSW = '' then begin
    arg_Error_Message := #13#10+'�p�X���[�h�F'+arg_FtpInfo.f_FtpServerPSW;
    Exit;
  end;
}
  if arg_Shema_File = '' then begin
    arg_Error_Message := #13#10+'�V�F�[�}�t�@�C���F'+arg_Shema_File;
    Exit;
  end;

  if (arg_MAIN_DIR = '') and (arg_SUB_DIR = '') then begin
    arg_Error_Message := #13#10+'���[�J���f�B���N�g���F'+arg_MAIN_DIR+arg_SUB_DIR;
    Exit;
  end;
  if arg_Local_File = '' then begin
    arg_Error_Message := #13#10+'���[�J���t�@�C���F'+arg_Local_File;
    Exit;
  end;

  Result := True;
end;
//******************************************************************************
// �I�[�_���C���X�V����
//******************************************************************************
function func_FTP_Update(
         arg_RIS_ID: string;
         arg_MAIN_DIR: string;
         arg_SUB_DIR : string;
         var arg_count: integer;
         var arg_Error_Code:string;    //�G���[�R�[�h
         var arg_Error_Message:string  //�G���[���b�Z�[�W
         ):Boolean;
var
  w_DateTime:String;
  w_Ris_ID:String;
  SQL:TStrings;
  SetData:TStrings;
  ValueData:TStrings;
const
  CST_ERRCOD_00 = '00';
  CST_ERRMSG_00 = 'RIS_ID�Ɍ�肪����܂�';
  CST_ERRCOD_01 = '01';
  CST_ERRMSG_01 = '�V�F�[�}�摜������܂���';
  CST_ERRCOD_02 = '02';
  CST_ERRMSG_02 = '�V�F�[�}�摜���擾����Ă��܂���';
begin
{
  Result := False;
  arg_count := 0;
  arg_Error_Code := '';
  arg_Error_Message := '';

  if arg_RIS_ID = '' then begin
    arg_Error_Code    := CST_ERRCOD_00;
    arg_Error_Message := CST_ERRMSG_00;
    Exit;
  end;
  w_DateTime := FormatDateTime(CST_FORMATDATE_4, func_GetDBSysDate);
//�X�V����
  ProcDBTranStart;
  //2003.02.07
  //RIS_ID�̎擾
  w_Ris_ID := arg_RIS_ID;
  SQL := TStringList.Create;
  SetData := TStringList.Create;
  ValueData := TStringList.Create;
  try
    //�I�[�_���C���e�[�u��
    SQL.Add('UPDATE ORDERMAINTABLE SET ');
    SQL.Add(' SHEMA_DIR    = :PSHEMA_DIR ');
    SQL.Add(',SHEMA_SUBDIR = :PSHEMA_SUBDIR ');
    SQL.Add('WHERE RIS_ID = :PRIS_ID ');
    SetData.Add('PSHEMA_DIR');
    SetData.Add('PSHEMA_DIR');

    ValueData.Add(arg_MAIN_DIR)
    ValueData.Add(arg_SUB_DIR)
    ParamByName('PSHEMA_DIR').AsString     := arg_MAIN_DIR;
    ParamByName('PSHEMA_SUBDIR').AsString  := arg_SUB_DIR;
    ParamByName('PRIS_ID').AsString       := w_Ris_ID;


    ExecSQL;



    if w_Ris_ID <> '' then begin
      //���у��C���e�[�u��
      with arg_Query do begin
        Close;
        SQL.Clear;
        SQL.Add('UPDATE EXMAINTABLE SET ');
        SQL.Add(' SHEMA_SYUTOKU_DATE = :PSHEMA_SYUTOKU_DATE ');
        SQL.Add('WHERE RIS_ID = :PRIS_ID ');
        if not Prepared then Prepare;
        ParamByName('PSHEMA_SYUTOKU_DATE').AsDateTime := w_DateTime;
        ParamByName('PRIS_ID').AsString               := w_Ris_ID;

        ExecSQL;
      end;

    end;
    SQL.Free;
    SetData.Free;
    ValueData.Free;
    try
      ProcCommitDB; // ���������ꍇ�C�ύX���R�~�b�g����
    except
      on E: Exception do begin
        procRollBackDB; // �R�~�b�g�Ŏ��s�����ꍇ�C�ύX��������
        arg_Error_Code    := CST_ERRCOD_01;
        arg_Error_Message := '(COMMIT)'+E.Message;
        Exit;
      end;
    end;
  except
    on E: Exception do begin
      procRollBackDB; // ���s�����ꍇ�C�ύX��������
      arg_Error_Code    := CST_ERRCOD_01;
      arg_Error_Message := E.Message;
      Exit;
    end;
  end;
  }
  Result := True;
end;

//�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|
//******************************************************************************
// ���[�J���t�@�C����(HIS��RIS����)�쐬
//******************************************************************************
function func_Shema_Make_FileName(
         arg_RIS_ID: string;
         var arg_count: integer;
         var arg_Error_Code:string;    //�G���[�R�[�h
         var arg_Error_Message:string  //�G���[���b�Z�[�W
         ):Boolean;
var
  i: integer;
  w_OrderNO: string;
  w_Bui_File: string;
  w_Bui_Name: string;
  w_Bui_Comment: string;
  w_ShemaPass: string;
  w_ShemaDirM,w_ShemaDirS: string;
  w_Set_Count: integer;
  wPos0,wPos1,wPos2{,wPosLoop}: integer;
  wPos: integer;
  w_Comment: string;
  //2003.02.07
  w_Hakko_Date:String;
  SQL:TStrings;
//  SelectData:TArrayofString;
  SelectResult:integer;  //SQL���s����
const
  CST_ERRCOD_00 = '00';
  CST_ERRMSG_00 = '�I�[�_NO�Ɍ�肪����܂�';
  CST_ERRCOD_01 = '01';
  CST_ERRMSG_01 = '�V�F�[�}�摜������܂���';
  CST_ERRCOD_02 = '02';
  CST_ERRMSG_02 = '�V�F�[�}�摜���擾����Ă��܂���';
begin
(*
  Result := False;
  arg_count := 0;
  arg_Error_Code := '';
  arg_Error_Message := '';

  g_Shema_OrderNO := '';
  g_Shema_KanjaID := '';
  g_Shema_KanjaName := '';
  for i := 0 to 9 do begin
    g_Shema_Bui_File[i] := '';
    g_Shema_Bui_Name[i] := '';
    g_Shema_Bui_Comment[i] := '';
    g_Shema_DirM[i] := '';
    g_Shema_DirS[i] := '';
    g_Shema_File[i] := '';
  end;

  if arg_RIS_ID = '' then begin
    arg_Error_Code    := CST_ERRCOD_00;
    arg_Error_Message := CST_ERRMSG_00;
    Exit;
  end;

  SQL := TStringList.Create;
  try
    w_Set_Count := 0;
    try
      SQL.Add ('SELECT od.ORDERNO, ');
      SQL.Add ('       od.SHEMAPASS_01,od.SHEMAPASS_02,od.SHEMAPASS_03,od.SHEMAPASS_04,od.SHEMAPASS_05, ');
      SQL.Add ('       od.SHEMAPASS_06,od.SHEMAPASS_07,od.SHEMAPASS_08,od.SHEMAPASS_09,od.SHEMAPASS_10, ');
      SQL.Add ('       od.SHEMAJOUHOU_01,od.SHEMAJOUHOU_02,od.SHEMAJOUHOU_03,od.SHEMAJOUHOU_04, od.SHEMAJOUHOU_05, ');
      SQL.Add ('       od.SHEMAJOUHOU_06,od.SHEMAJOUHOU_07,od.SHEMAJOUHOU_08,od.SHEMAJOUHOU_09, od.SHEMAJOUHOU_10, ');
      SQL.Add ('       od.SHEMABUIJOUHOU_01,od.SHEMABUIJOUHOU_02, od.SHEMABUIJOUHOU_03,od.SHEMABUIJOUHOU_04, od.SHEMABUIJOUHOU_05, ');
      SQL.Add ('       od.SHEMABUIJOUHOU_06,od.SHEMABUIJOUHOU_07, od.SHEMABUIJOUHOU_08,od.SHEMABUIJOUHOU_09, od.SHEMABUIJOUHOU_10, ');
//        SQL.Add ('       od.SHEMA_DIR, od.SHEMA_SUBDIR,');
      SQL.Add ('       od.SHEMA_DIR, od.SHEMA_SUBDIR, TO_CHAR(od.HIS_HAKKO_DATE,''YYYYMMDD'') AS HIS_HAKKO_DATE,');
      SQL.Add ('       km.KANJAID,km.KANJISIMEI ');
      SQL.Add (' FROM '+GOrderMainTable+' od,'+ GPatient +' km');
      //2003.02.07
//        SQL.Add ('WHERE od.ORDERNO = ''' + arg_OrderNO + '''' );
      SQL.Add ('WHERE od.RIS_ID = ''' + arg_RIS_ID + '''' );
      SQL.Add ('  AND km.KANJAID = od.KANJAID ' );


      try
        //SQL���s
        SelectResult:=FuncSelectDB(SQL,nil,nil,SelectData);
      except
        raise;
        //Exit;
      end;


      if (SelectResult > 0) then begin
        g_Shema_OrderNO := SelectData[0][0];
        g_Shema_KanjaID := SelectData[0][34];
        g_Shema_KanjaName := SelectData[0][35];

        w_OrderNO   := SelectData[0][0];
        w_ShemaDirM := SelectData[0][31];
        w_ShemaDirS := SelectData[0][32];
        //2003.02.07
        w_Hakko_Date := SelectData[0][33];
        if w_OrderNO = '' then begin
          arg_Error_Code    := CST_ERRCOD_00;
          arg_Error_Message := CST_ERRMSG_00;
          Exit;
        end;
        //2002.11.05
        {if (w_ShemaDirM = '') and (w_ShemaDirS = '') then begin
          arg_Error_Code    := CST_ERRCOD_02;
          arg_Error_Message := CST_ERRMSG_02;
          Exit;
        end;}
        //���Ɋi�[�ς݂̏ꍇ�A���̑��݂��`�F�b�N����
        for i := 0 to 9 do begin
          w_Bui_File := SelectData[0][i+1];
          w_Bui_Name := SelectData[0][i+21];
          w_Bui_Comment := SelectData[0][i+11];

          if w_Bui_File <> '' then begin
            //�T�[�o�̃��[�J���t�@�C�����쐬
            w_ShemaPass := func_Make_ShemaName(w_OrderNO + w_Hakko_Date,
                                               w_Bui_File,
                                               i+1
                                               );
            if w_ShemaPass <> '' then begin
              g_Shema_Bui_File[i]   := w_Bui_File;
              g_Shema_Bui_Name[i]   := w_Bui_Name;
//2002.12.26
              //g_Shema_Bui_Comment[i]:= w_Bui_Comment;
              g_Shema_Bui_Comment[i]:= '';
              while AnsiPos('</COMMENT>',w_Bui_Comment) > 0 do begin
                wPos:=AnsiPos('</COMMENT>',w_Bui_Comment);
                wPos0:=AnsiPos('<COMMENT',w_Bui_Comment);
                if wPos0 > 0 then begin
                  w_Bui_Comment := Copy(w_Bui_Comment,wPos0+8,Length(w_Bui_Comment));
                  wPos1:=AnsiPos('>',w_Bui_Comment);
                  wPos2:=AnsiPos('<',w_Bui_Comment);
                  w_Comment := Copy(w_Bui_Comment,wPos1+1,wPos2-wPos1-1);
                  if g_Shema_Bui_Comment[i] = '' then
                    g_Shema_Bui_Comment[i]:=w_Comment
                  else
                    g_Shema_Bui_Comment[i]:=g_Shema_Bui_Comment[i]
                                           +#13#10
                                           +w_Comment;
                end;
                w_Bui_Comment := Copy(w_Bui_Comment,AnsiPos('</COMMENT>',w_Bui_Comment)+10,Length(w_Bui_Comment));
              end;

              g_Shema_DirM[i] := w_ShemaDirM;
              g_Shema_DirS[i] := w_ShemaDirS;
              g_Shema_File[i] := w_ShemaPass;
              w_Set_Count := w_Set_Count + 1;
              //���ʖ��̂����߂�
              if w_Bui_Name <> '' then begin
                SQL.Clear;
                SQL.Add ('SELECT bm.BUI_ID,bm.BUI_NAME ');
                SQL.Add (' FROM '+GBuiMaster +' bm');
                SQL.Add ('WHERE bm.BUI_ID = ''' + w_Bui_Name + '''' );
                try
                  //SQL���s
                  SelectResult:=FuncSelectDB(SQL,nil,nil,SelectData);
                except
                  raise;
                  //Exit;
                end;
                if (SelectResult > 0) then begin
                  g_Shema_Bui_Name[i]   := SelectData[0][1];
                end;
              end;
            end;
          end;
        end;
      end;
    except
      on E: Exception do begin
        arg_Error_Code    := CST_ERRCOD_00;
        arg_Error_Message := CST_ERRMSG_00 + E.Message;
        Exit;
      end;
    end;
  finally
  end;

  //�t�@�C�������݂��Ȃ��ꍇ�A�G���[�Ƃ���
  if w_Set_Count = 0 then begin
    arg_Error_Code    := CST_ERRCOD_01;
    arg_Error_Message := CST_ERRMSG_01;
    Exit;
  end;

  arg_count := w_Set_Count;
  SQL.free;
  *)
  Result := True;
end;
//******************************************************************************
// �V�F�[�}�t�@�C���R�s�[(RIS���ށ�RIS�ײ���)
//******************************************************************************
function func_Shema_Copy_File(
         var arg_count: integer;
         var arg_Error_Code:string;    //�G���[�R�[�h
         var arg_Error_Message:string  //�G���[���b�Z�[�W
         ):Boolean;
var
  i: integer;
  w_ClientDir: string;
  w_FileName: string;
  sr: TSearchRec;

  w_P: integer;
  w_Kakuchosi: string;

  w_ShemaFile: string;
  w_ClientFile: string;
  w_Set_Count: integer;
const
  CST_ERRCOD_01 = '01';
  CST_ERRMSG_01 = '�V�F�[�}�摜������܂���';
  CST_ERRCOD_02 = '02';
  CST_ERRMSG_02 = '�V�F�[�}�摜�̊g���q���擾�ł��܂���';
  CST_ERRCOD_03 = '03';
  CST_ERRMSG_03 = '�N���C�A���g�ւ̃R�s�[�Ɏ��s���܂���';
begin
  Result := False;
  arg_count := 0;
  arg_Error_Code := '';
  arg_Error_Message := '';
  (*
  for i := 0 to 9 do begin
    g_Shema_Client_File[i] := '';
  end;
//�N���C�A���g�̊i�[��t�H���_���̃t�@�C�����폜
  w_ClientDir := G_RunPath + CST_SHEMA_DIR + '\';
  if not DirectoryExists(w_ClientDir) then
    ForceDirectories(w_ClientDir);
  i := FindFirst(w_ClientDir+'*.*', faAnyFile, sr);
  try
    if i = 0 then begin
      repeat
        w_FileName := w_ClientDir+sr.Name;
        if FileExists(w_FileName) then
          DeleteFile(w_FileName);
      until FindNext(sr) <> 0;
    end;
  finally
    FindClose(sr);
  end;

//�R�s�[����
  w_Set_Count := 0;
  for i := 0 to 9 do begin
    if g_Shema_File[i] <> '' then begin
      if g_Shema_DirM[i] <> '' then
        if '\' <> Copy(g_Shema_DirM[i],Length(g_Shema_DirM[i]),1) then
          g_Shema_DirM[i] := g_Shema_DirM[i] + '\';
      if g_Shema_DirS[i] <> '' then
        if '\' <> Copy(g_Shema_DirS[i],Length(g_Shema_DirS[i]),1) then
          g_Shema_DirS[i] := g_Shema_DirS[i] + '\';
      //�R�s�[���t�@�C����
      w_ShemaFile := g_Shema_DirM[i] + g_Shema_DirS[i] + g_Shema_File[i];
      if FileExists(w_ShemaFile) then begin
        //�R�s�[���t�@�C�������g���q�ʒu�擾
        w_P := Pos('.',w_ShemaFile);
        if w_P <= 0 then begin
          arg_Error_Code    := CST_ERRCOD_02;
          arg_Error_Message := CST_ERRMSG_02;
          Exit;
        end;
        w_Kakuchosi := Copy(w_ShemaFile,w_P,Length(w_ShemaFile)-w_P+1);
        //�R�s�[��t�@�C����
        w_ClientFile := w_ClientDir + '\' + FormatFloat('00',i) + '_' + w_Kakuchosi;
        //�R�s�[
        if not CopyFile(PChar(w_ShemaFile), PChar(w_ClientFile), True) then begin
          arg_Error_Code    := CST_ERRCOD_03;
          arg_Error_Message := CST_ERRMSG_03;
          Exit;
        end;
        g_Shema_Client_File[i] := w_ClientFile;
        w_Set_Count := w_Set_Count + 1;
      end;
    end;
  end;

  //�t�@�C�������݂��Ȃ��ꍇ�A�G���[�Ƃ���
  if w_Set_Count = 0 then begin
    arg_Error_Code    := CST_ERRCOD_01;
    arg_Error_Message := CST_ERRMSG_01;
    Exit;
  end;

  arg_count := w_Set_Count;
  Result := True;
  *)
end;
//******************************************************************************
// HTML�t�@�C���쐬
//******************************************************************************
function func_Shema_Make_HTML(
         arg_Mode: integer;            //�t�@�C���ʒu(0:�ײ��Ăɺ�߰�ρA1:۰�ق����̂܂܎g�p)
         arg_OrderNO: string;
         arg_KanjaID: string;
         arg_KanjaName: string;
         arg_KensaDate: string;
         arg_KensaType: string;
         arg_IraiSection: string;
         arg_IraiDoctor: string;
         var arg_Error_Code:string;    //�G���[�R�[�h
         var arg_Error_Message:string  //�G���[���b�Z�[�W
         ):Boolean;
var
  TxtFile: TextFile;
  w_Record: string;
  w_GouNO: integer;
  w_HTML_Text: string;

  w_ShemaFile: string;
  w_Local_File: string;
  w_Bui_Name: string;
  w_Bui_Comment: string;
  i: integer;
  w_No: string;
  w_Name: string;
  ws_HTML_SHEMA:String;
  SQL:TStrings;
  SetData:TStrings;
  ValueData:TStrings;
//  SelectData:TArrayofString;
  SelectResult:integer;  //SQL���s����
const
  CST_ERRCOD_01 = '01';
  CST_ERRMSG_01 = '�V�F�[�}�摜������܂���';
  CST_ERRCOD_02 = '02';
  CST_ERRMSG_02 = '�t�@�C���̓ǂݍ��݂Ɏ��s���܂���';
  CST_ERRCOD_03 = '03';
  CST_ERRMSG_03 = 'HTML�t�@�C���̍쐬�Ɏ��s���܂���';
  CST_ERRCOD_04 = '04';
  CST_ERRMSG_04 = 'HTML�t�@�C�������݂��܂���';
begin
  Result := False;
  (*
  arg_Error_Code := '';
  arg_Error_Message := '';
//�T�[�o�̃��[�J���t�@�C�������̂܂܎g�p����ꍇ
  if arg_Mode = 1 then begin
    for i := 0 to 9 do begin
      g_Shema_Client_File[i] := '';
      //۰��̧�ٖ���ײ���̧�ٖ��ɺ�߰
      if g_Shema_File[i] <> '' then begin
        if g_Shema_DirM[i] <> '' then begin
          if ('\' <> Copy(g_Shema_DirM[i],Length(g_Shema_DirM[i]),1)) then
            g_Shema_DirM[i] := g_Shema_DirM[i] + '\';
        end;
        if g_Shema_DirS[i] <> '' then begin
          if ('\' <> Copy(g_Shema_DirS[i],Length(g_Shema_DirS[i]),1)) then
            g_Shema_DirS[i] := g_Shema_DirS[i] + '\';
          if ('\' = Copy(g_Shema_DirS[i],1,1)) then
            g_Shema_DirS[i] := Copy(g_Shema_DirS[i],2,Length(g_Shema_DirS[i])-1);
        end;
        //�R�s�[���t�@�C���������̂܂܃N���C�A���g�t�@�C�����Ɋi�[
        w_ShemaFile := g_Shema_DirM[i] + g_Shema_DirS[i] + g_Shema_File[i];
        if FileExists(w_ShemaFile) then begin
          g_Shema_Client_File[i] := w_ShemaFile;
        end else begin
{2003.01.29
          arg_Error_Code    := CST_ERRCOD_04;
          arg_Error_Message := CST_ERRMSG_04+#13#10+'HTML�F'+w_ShemaFile;
          Exit;
2003.01.29}
{2003.01.29 start}
          g_Shema_Client_File[i] := w_ShemaFile;
{2003.01.29 end}
        end;
      end;
    end;
  end;

//HTML�t�@�C�����쐬
  SQL :=TStringList.Create;
  SetData :=TStringList.Create;
  ValueData :=TStringList.Create;
  try
    SQL.Add ('SELECT Data ');
    SQL.Add ('FROM   '+GWinMaster );
    SQL.Add ('WHERE  WINKEY = :PWINKEY ');
    SQL.Add ('  AND  SECTION_KEY = :PSECTION_KEY ');
    SQL.Add ('  AND  DATA_KEY = :PDATA_KEY ');

    SetData.Add('PWINKEY');
    SetData.Add('PSECTION_KEY');
    SetData.Add('PDATA_KEY');

    ValueData.Add(g_SYSTEM);
    ValueData.Add(g_SHEMA);
    ValueData.Add(g_SHEMA_FILE_PASS);

    try
      //SQL���s
      SelectResult:=FuncSelectDB(SQL,SetData,ValueData,SelectData);
    except
      raise;
      //Exit;
    end;
    if (SelectResult > 0) then begin
        ws_HTML_SHEMA := SelectData[0][0];
    end;

    //...�I���W�i��
    if ws_HTML_SHEMA <> '' then
      g_Shema_HTML_Original_File := ws_HTML_SHEMA
    else
      g_Shema_HTML_Original_File := G_RunPath + CST_SHEMA_HTML_ORIGINAL;
    if not FileExists(g_Shema_HTML_Original_File) then begin
      arg_Error_Code    := CST_ERRCOD_01;
      arg_Error_Message := CST_ERRMSG_01+#13#10+'HTML�F'+g_Shema_HTML_Original_File;
      Exit;
    end;
    //...�i�[��
    g_Shema_HTML_File := ExtractFileDir(g_Shema_HTML_Original_File) + '\' + CST_SHEMA_HTML_ORDER;
  //HTML�I���W�i���̓��e���R�s�[
    w_GouNO := 0;
    w_HTML_Text := '';
    AssignFile(TxtFile, g_Shema_HTML_Original_File);
    Reset(TxtFile);
    try
      while not Eof(TxtFile) do
      begin
        w_GouNO := w_GouNO + 1;
        try
          Readln(TxtFile, w_Record);
        except
          on E:EInOutError do begin
            arg_Error_Code    := CST_ERRCOD_02;
            arg_Error_Message := g_Shema_HTML_Original_File +'�̓ǂݍ��݂Ɏ��s���܂����B�s�F'+IntToStr(w_GouNO)+E.Message;
            Exit;
          end;
        end;
        //�u����������
        if (Pos('<!--', w_Record) > 0) or
           (Pos('-->', w_Record) > 0) then begin
        end
        else begin
{
          //�^�C�g��
          if Pos('*�u���E�U�^�C�g��*', w_Record) > 0 then begin
            w_Record := StringReplace(w_Record,'*�u���E�U�^�C�g��*',CST_END_SYORI1,[rfReplaceAll])
          end;
}
  {
          //�F
          if Pos('*��ʔw�i�F*', w_Record) > 0 then begin
            w_Record := StringReplace(w_Record,'*��ʔw�i�F*','#FFFFCC',[rfReplaceAll])
          end;
          if Pos('*�e�[�u���w�i�F*', w_Record) > 0 then begin
            w_Record := StringReplace(w_Record,'*�e�[�u���w�i�F*','#FFCC66',[rfReplaceAll])
          end;
          if Pos('*�^�C�g���F*;', w_Record) > 0 then begin
            w_Record := StringReplace(w_Record,'*�^�C�g���F*;','#FFFF99',[rfReplaceAll])
          end;
          if Pos('*�f�[�^�w�_�[�F*', w_Record) > 0 then begin
            w_Record := StringReplace(w_Record,'*�f�[�^�w�_�[�F*','#FFFF99',[rfReplaceAll])
          end;
          if Pos('*�f�[�^�F*', w_Record) > 0 then begin
            w_Record := StringReplace(w_Record,'*�f�[�^�F*','#FFFFFF',[rfReplaceAll])
          end;
          if Pos('*���ʍs�F*', w_Record) > 0 then begin
            w_Record := StringReplace(w_Record,'*���ʍs�F*','#FFFF99',[rfReplaceAll])
          end;
          if Pos('*�摜�s�F*', w_Record) > 0 then begin
            w_Record := StringReplace(w_Record,'*�摜�s�F*','#FFFFFF',[rfReplaceAll])
          end;
          if Pos('*���ʃR�����g�s�F*', w_Record) > 0 then begin
            w_Record := StringReplace(w_Record,'*���ʃR�����g�s�F*','#DCDCDC',[rfReplaceAll])
          end;
  }
          //�w�_�[
          if Pos('*����ID*', w_Record) > 0 then begin
            if arg_KanjaID <> '' then
              w_Record := StringReplace(w_Record,'*����ID*',arg_KanjaID,[rfReplaceAll])
            else
              w_Record := StringReplace(w_Record,'*����ID*','<span class=dmy_txt></span>',[rfReplaceAll]);
          end;
          if Pos('*����*', w_Record) > 0 then begin
            if arg_KanjaName <> '' then
              w_Record := StringReplace(w_Record,'*����*',arg_KanjaName,[rfReplaceAll])
            else
              w_Record := StringReplace(w_Record,'*����*','<span class=dmy_txt></span>',[rfReplaceAll]);
          end;
          if Pos('*���{������*', w_Record) > 0 then begin
            if arg_KensaDate <> '' then
              w_Record := StringReplace(w_Record,'*���{������*',arg_KensaDate,[rfReplaceAll])
            else
              w_Record := StringReplace(w_Record,'*���{������*','<span class=dmy_txt></span>',[rfReplaceAll]);
          end;
          if Pos('*�������*', w_Record) > 0 then begin
            if arg_KensaType <> '' then
              w_Record := StringReplace(w_Record,'*�������*',arg_KensaType,[rfReplaceAll])
            else
              w_Record := StringReplace(w_Record,'*�������*','<span class=dmy_txt></span>',[rfReplaceAll]);
          end;
          if Pos('*����NO*', w_Record) > 0 then begin
            if arg_OrderNO <> '' then
              w_Record := StringReplace(w_Record,'*����NO*',arg_OrderNO,[rfReplaceAll])
            else
              w_Record := StringReplace(w_Record,'*����NO*','<span class=dmy_txt></span>',[rfReplaceAll]);
          end;
          if Pos('*�˗���*', w_Record) > 0 then begin
            if arg_IraiSection <> '' then
              w_Record := StringReplace(w_Record,'*�˗���*',arg_IraiSection,[rfReplaceAll])
            else
              w_Record := StringReplace(w_Record,'*�˗���*','<span class=dmy_txt></span>',[rfReplaceAll]);
          end;
          if Pos('*�˗���*', w_Record) > 0 then begin
            if arg_IraiDoctor <> '' then
              w_Record := StringReplace(w_Record,'*�˗���*',arg_IraiDoctor,[rfReplaceAll])
            else
              w_Record := StringReplace(w_Record,'*�˗���*','<span class=dmy_txt></span>',[rfReplaceAll]);
          end;
          //���ʁA�V�F�[�}�摜�A���ʃR�����g
          for i := 0 to 9 do begin
            w_Local_File  := g_Shema_Client_File[i];
            w_Bui_Name    := g_Shema_Bui_Name[i];
            w_Bui_Comment := g_Shema_Bui_Comment[i];
            w_No := FormatFloat('00', i + 1);
            //���ʖ�
            w_Name := '*����'+w_No+'*';
            if Pos(w_Name, w_Record) > 0 then begin
              if w_Bui_Name <> '' then
                w_Record := StringReplace(w_Record,w_Name,w_Bui_Name,[rfReplaceAll])
              else
                w_Record := '<TD><span class=dmy_gazou></span></TD>';
            end;
            //�V�F�[�}�摜
            w_Name := '*���ω摜'+w_No+'*';
            if Pos(w_Name, w_Record) > 0 then begin
              if w_Local_File <> '' then
                w_Record := StringReplace(w_Record,w_Name,w_Local_File,[rfReplaceAll])
              else
                w_Record := '<TD><span class=dmy_gazou></span></TD>';
            end;
            //���ʃR�����g
            w_Name := '*���ʺ���'+w_No+'*';
            if Pos(w_Name, w_Record) > 0 then begin
              if w_Bui_Comment <> '' then
                w_Record := StringReplace(w_Record,w_Name,w_Bui_Comment,[rfReplaceAll])
              else
                w_Record := '<TD><span class=dmy_gazou></span></TD>';
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
      AssignFile(TxtFile, g_Shema_HTML_File);
      Rewrite(TxtFile);
    except
      on E:EInOutError do begin
        arg_Error_Code    := CST_ERRCOD_03;
        arg_Error_Message := g_Shema_HTML_File +'�̃A�T�C���Ɏ��s���܂����B'+E.Message;
        Exit;
      end;
    end;
    try
      try
        Writeln(TxtFile, w_HTML_Text);
      except
        on E:EInOutError do begin
          arg_Error_Code    := CST_ERRCOD_03;
          arg_Error_Message := g_Shema_HTML_File +'�̏������݂Ɏ��s���܂����B'+E.Message;
          Exit;
        end;
      END;
    finally
      Flush(TxtFile);
      CloseFile(TxtFile);
    end;
  finally
    FreeAndNil(SQL);
    FreeAndNil(SetData);
    FreeAndNil(ValueData);

  end;
  Result := True;
  *)
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
