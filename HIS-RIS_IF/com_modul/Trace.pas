unit Trace;
{
���@�\�����i�g�p�\��F����j
  �g���[�X���[�`���p
  �|inisiarize�Ńt�@�C�����̏�����
  �|�o�͐�F���p�X�܂��͎��s�p�X��DOCTRC.SYS
��
proc_EntTrace('MA010','XXXX, XXXXXXX,XXXX ,XXXXxX');
proc_DumpTrace('SQL��','XXXXXXXXXXXXXXXX',length('XXXXXXXXXXXXXXXX'));
proc_EndTrace( 'MA010' );

�g���[�X�C���[�W
*********+*********+*********+*********+*********+*********+*********+*********+
Start: MA010 ---------------------------------------------------------------
      Time(12/11/14 �ߌ� 12:14:46)
      TimeStamp[ 44086226]
      param:"1","01","$00FFFFFF","1","0","1","0","",
      [MemoryLoad][TotalPhys][AvailPhys][TotalPageFile][AvailPageFile][TotalVirtual][AvailVirtual]
DUMP : Message
      TimeStamp[ 44086226]
      XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
END  : MA010 ---------------------------------------------------------------------
      Time(12/11/14 �ߌ� 12:14:46)
      TimeStamp[ 44086226]
      [MemoryLoad][TotalPhys][AvailPhys][TotalPageFile][AvailPageFile][TotalVirtual][AvailVirtual]

*********+*********+*********+*********+*********+*********+*********+*********+

������
�V�K�쐬�F99.06.17�F�S�� iwai
�C��    �F99.10.20�F�S�� iwai
  ��O�����������̃��O�o�͂�ǉ�  proc_TraceException

�C��    �F00.06.09�F�S�� iwai
w_TraceMode��ǉ�
w_TraceMode�Fini�̒l�����̂܂ܕۑ������l�͂O
�O�F�Ȃ�
�P�F�ڍ�
   proc_EntTrace proc_EndTrace proc_DumpTrace
�Q�F�����Əo���Ɨ�O�Ǝw��̂�
   proc_EntTrace proc_EndTrace proc_TraceException proc_TraceMsgLog
�֐��ǉ�
   procedure proc_TraceMsgLog(arg_place:string; arg_msg:string; arg_tracemode:string);

�ڐݍ쐬�F2000.11.08�F�S�� iwai
  �����L�[�F�ǉ�RIS     //���ǉ�RIS��
�N�����ɁALog�t�@�C�����w��T�C�Y�𒴂����Ƃ���
Log�t�@�C�����V���A���ԍ����J�E���g���ĐV�K�ɍ쐬����B
proc_MemSpaceTrace:�������X�y�[�X���o�͂���B
���C�A�E�g��ύX
}

interface //*******************************************************************
//�g�p���j�b�g---------------------------------------------------------------
uses
//�V�X�e���|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|
    Forms,
    Windows,
    Classes,
    SysUtils,
    FileCtrl,
//�v���_�N�g�J�����ʁ|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|
    Gval,
    myInitInf
    ;

////�^�N���X�錾-------------------------------------------------------------
//type
//�萔�錾-------------------------------------------------------------------
const
  wCST_TRAC_MODE0 = '0';
  wCST_TRAC_MODE1 = '1';
  wCST_TRAC_MODE2 = '2';
  wCST_TRAC_MODE3 = '3';
//�ϐ��錾-------------------------------------------------------------------
var
 wi_int:integer;
//�֐��葱���錾-------------------------------------------------------------
//���@�\�F�������c�t�l�o�i�e��ʂ͓K�X�Ăԁj
//�i�p�����j�ďo����:com00.pas
procedure proc_DumpTrace(
                        arg_Msg:string;   //���o���i��FSQL���j
                        arg_point:string;//�擪�A�h���X�i��FXXXXXXXXXXXXXXXX�j
                        arg_lLen:Longint  //������L�̒���
                         );

//���@�\�F�����̎n�܂�ŌĂԓ�����g���[�X
//�i�p�����Ŏg�p�e��ʂ͈ӎ��s�v�j�ďo����:com00.pas
procedure proc_EntTrace(
                        arg_Pid:string;  // �v���O�����h�c���w��i��FMA010�j
                        arg_Param:string // �p�����^���w�肷��
                                         //�i��FXXXX, XXXXXXX,XXXX ,XXXXxX�j
                        );
//���@�\�F�����̏I���ŌĂԏo���g���[�X
//�i�p�����Ŏg�p�e��ʂ͈ӎ��s�v�j�ďo����:com00.pas
procedure proc_EndTrace(
                        arg_Pid : string // �v���O�����h�c���w��i��FMA010�j
                        );
//���@�\�F��O�̃��O�o�́i�e��ʂ͈ӎ��s�v�j
//�i�A�v���P�[�V�����o���ŌĂяo���̂�Ҳ݂���Ă΂�锃����ʂ͈ӎ��s�v�j
//  Application.OnException := xxxxxxxxx; �Ƃ��ēo�^���Ďg�p����B
procedure proc_TraceException(
                        Sender: TObject; //��O������޼ު�� nil�ł��悢
                        E: Exception     //������O
                        );
//���@�\�F���x�����O�o�́i�e��ʂ͈ӎ��s�v�j
//
procedure proc_TraceMsgLog(
                        arg_place:string;     //�ꏊ�R�[�h
                        arg_msg:string;       //���b�Z�[�W
                        arg_tracemode:string  //���O�o�̓��x�� �g���[�X���[�h
                        );
//���@�\�F���������i�K�v�ȂƂ���j
procedure proc_MemSpaceTrace;

implementation //**************************************************************

//�萔�錾       -------------------------------------------------------------
const
  G_TRACE_FILE_PREFIX = 'SysTRC';
  G_TRACE_FILE_EXT    = '.log';
//�ϐ��錾     ---------------------------------------------------------------
var
  wini_TRACE_Key: TStrings;  // �g���[�Xini���[
  wini_TRACE: TAarrayTStrings;// �g���[�X���

  w_FileList: TStringList;  // ���X�g
  g_TRACE_FILENAME:string;
  w_TraceFlg: boolean;
  w_TraceFile: TextFile;
  w_FILENAME:string;
  w_FILENO:string;
  w_FileSize:Longint;
  //INI���̎擾
  w_TracePath: string;
  w_TraceMode: string;
  w_TraceFileSize:string;
  wi_TraceFileSize:Longint;

//�֐��葱���錾--------------------------------------------------------------
//���@�\�����̎n�܂�
//��O�͔��������Ȃ�
procedure proc_EntTrace(
                        arg_Pid:string;  // �v���O�����h�c���w��i��FMA010�j
                        arg_Param:string // �p�����^���w�肷��
                                         //�i��FXXXX, XXXXXXX,XXXX ,XXXXxX�j
                        );
var
  w_Str: string;
  w_DateTimm:TDateTime;
  w_MemoryInf: TMEMORYSTATUS;

begin
{���C�A�E�g
Start: M0000 ---------------------------------------------------------------
      Time(12/11/14 �ߌ� 12:14:46)
      TimeStamp[ 44086226]
      param:"1","01","$00FFFFFF","1","0","1","0","",
      [MemoryLoad][TotalPhys][AvailPhys][TotalPageFile][AvailPageFile][TotalVirtual][AvailVirtual]

MemoryLoad;	/* �g�p���̃������̊���	*/
TotalPhys;	/* �����������̃o�C�g��	*/
AvailPhys;	/* �󂫕����������̃o�C�g��	*/
TotalPageFile;	/* �y�[�W���O �t�@�C���̃o�C�g��	*/
AvailPageFile;	/* �y�[�W���O �t�@�C���̋󂫃o�C�g��	*/
TotalVirtual;	/* �A�h���X��Ԃ̃��[�U�[ �o�C�g��	*/
AvailVirtual;	/* �󂫃��[�U�[ �o�C�g��	*/

}
try
  if  w_TraceFlg<> true  then exit;
  if (wCST_TRAC_MODE1 <> w_TraceMode)
     and
     (wCST_TRAC_MODE2 <> w_TraceMode)
   then exit;
  //���������擾
  GlobalMemoryStatus(w_MemoryInf);
  //���Ԃ̎擾
  w_DateTimm:=Now;
  //�o��
  w_Str:= 'START: '
         + arg_Pid
         + ' ------------------------------------------------------------------------';
  Writeln(w_TraceFile,
          w_Str);

  w_Str:= '      Time'
         + '(' + DateTimeToStr (w_DateTimm) + ')';
  Writeln(w_TraceFile,
          w_Str);

  w_Str:= '      TimeStamp'
         + '[ '
         + IntToStr(DateTimeToTimeStamp(w_DateTimm).Time)
         + ']';
  Writeln(w_TraceFile,
          w_Str);

  w_Str:= '      Param:' + arg_Param;
  Writeln(w_TraceFile,
          w_Str);

  w_Str:= '      '
        +'['+IntToStr(w_MemoryInf.dwMemoryLoad)+']'
        +'['+IntToStr(w_MemoryInf.dwTotalPhys)+']'
        +'['+IntToStr(w_MemoryInf.dwAvailPhys)+']'
        +'['+IntToStr(w_MemoryInf.dwTotalPageFile)+']'
        +'['+IntToStr(w_MemoryInf.dwAvailPageFile)+']'
        +'['+IntToStr(w_MemoryInf.dwTotalVirtual)+']'
        +'['+IntToStr(w_MemoryInf.dwAvailVirtual)+']'
           ;

  Writeln(w_TraceFile,
          w_Str);

  Writeln(w_TraceFile);
except
   exit;
end;

end;
//���@�\�������c�t�l�o
//��O�͔��������Ȃ�
procedure proc_DumpTrace(
                        arg_Msg:string;   //���o���i��FSQL���j
                        arg_point:string;//�擪�A�h���X�i��FXXXXXXXXXXXXXXXX�j
                        arg_lLen:Longint  //������L�̒���
                         );
var
  w_Str: string;
  w_DateTimm:TDateTime;
begin
{���C�A�E�g
DUMP : MA010
      Time(12/11/14 �ߌ� 12:14:46)
      XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
}
try
  if  w_TraceFlg<> true  then exit;
  if (wCST_TRAC_MODE1 <> w_TraceMode)
  then exit;

  w_DateTimm:=Now;
  w_Str := 'DUMP : '+ arg_Msg ;
  Writeln(w_TraceFile,
          w_Str);

  w_Str:= '      TimeStamp'
         + '[ '
         + IntToStr(DateTimeToTimeStamp(w_DateTimm).Time)
         + ']';
  Writeln(w_TraceFile,
          w_Str);

  w_Str := '       ' + copy(arg_point,1,arg_lLen);
  Writeln(w_TraceFile,
          w_Str);

  Writeln(w_TraceFile);
except
   exit;
end;
end;
//���@�\�����̏I���
//��O�͔��������Ȃ�
procedure proc_EndTrace(
                        arg_Pid : string // �v���O�����h�c���w��i��FMA010�j
                        );
var
  w_Str: string;
  w_DateTimm:TDateTime;
  w_MemoryInf: TMEMORYSTATUS;
begin
{���C�A�E�g
END  : MA010 ---------------------------------------------------------------------
      Time(12/11/14 �ߌ� 12:14:46)
      TimeStamp[ 44086226]
      [MemoryLoad][TotalPhys][AvailPhys][TotalPageFile][AvailPageFile][TotalVirtual][AvailVirtual]

}
try
  if  w_TraceFlg<> true  then exit;
  if (wCST_TRAC_MODE1 <> w_TraceMode)
     and
     (wCST_TRAC_MODE2 <> w_TraceMode)
   then exit;

  //���������擾
  GlobalMemoryStatus(w_MemoryInf);
  //���Ԃ̎擾
  w_DateTimm:=Now;

  //�o��
  w_Str:= 'END  : ' + arg_Pid
         + ' ------------------------------------------------------------------------';
  Writeln(w_TraceFile,
          w_Str);

  w_Str:= '      Time'
         + '(' + DateTimeToStr (w_DateTimm) + ')';
  Writeln(w_TraceFile,
          w_Str);

  w_Str:= '      TimeStamp'
         + '[ '
         + IntToStr(DateTimeToTimeStamp(w_DateTimm).Time)
         + ']';
  Writeln(w_TraceFile,
          w_Str);

  w_Str:= '      '
        +'['+IntToStr(w_MemoryInf.dwMemoryLoad)+']'
        +'['+IntToStr(w_MemoryInf.dwTotalPhys)+']'
        +'['+IntToStr(w_MemoryInf.dwAvailPhys)+']'
        +'['+IntToStr(w_MemoryInf.dwTotalPageFile)+']'
        +'['+IntToStr(w_MemoryInf.dwAvailPageFile)+']'
        +'['+IntToStr(w_MemoryInf.dwTotalVirtual)+']'
        +'['+IntToStr(w_MemoryInf.dwAvailVirtual)+']'
           ;

  Writeln(w_TraceFile,
          w_Str);

  Writeln(w_TraceFile);
except
   exit;
end;
end;

//���@�\�����̎n�܂�
//��O�͔��������Ȃ�
procedure proc_MemSpaceTrace;
var
  w_Str: string;
  w_MemoryInf: TMEMORYSTATUS;
begin
{���C�A�E�g
-------------------------------------------------------------------------------------
MEMIF:[MemoryLoad][TotalPhys][AvailPhys][TotalPageFile][AvailPageFile][TotalVirtual][AvailVirtual]
-------------------------------------------------------------------------------------

MemoryLoad;	/* �g�p���̃������̊���	*/
TotalPhys;	/* �����������̃o�C�g��	*/
AvailPhys;	/* �󂫕����������̃o�C�g��	*/
TotalPageFile;	/* �y�[�W���O �t�@�C���̃o�C�g��	*/
AvailPageFile;	/* �y�[�W���O �t�@�C���̋󂫃o�C�g��	*/
TotalVirtual;	/* �A�h���X��Ԃ̃��[�U�[ �o�C�g��	*/
AvailVirtual;	/* �󂫃��[�U�[ �o�C�g��	*/

}
try
  if  w_TraceFlg<> true  then exit;
  if (wCST_TRAC_MODE1 <> w_TraceMode) then exit;
  //���������擾
  GlobalMemoryStatus(w_MemoryInf);
  //�o��
  w_Str:= '-------------------------------------------------------------------------------------';
  Writeln(w_TraceFile,
          w_Str);

  w_Str:= 'MEMIF:'
        +'['+IntToStr(w_MemoryInf.dwMemoryLoad)+']'
        +'['+IntToStr(w_MemoryInf.dwTotalPhys)+']'
        +'['+IntToStr(w_MemoryInf.dwAvailPhys)+']'
        +'['+IntToStr(w_MemoryInf.dwTotalPageFile)+']'
        +'['+IntToStr(w_MemoryInf.dwAvailPageFile)+']'
        +'['+IntToStr(w_MemoryInf.dwTotalVirtual)+']'
        +'['+IntToStr(w_MemoryInf.dwAvailVirtual)+']' ;
  Writeln(w_TraceFile,
          w_Str);

  w_Str:= '-------------------------------------------------------------------------------------';
  Writeln(w_TraceFile,
          w_Str);

  Writeln(w_TraceFile);

except
   exit;
end;
end;

//���@�\�F��O�̃��O�o��
//��O�͔��������Ȃ�
procedure proc_TraceException(Sender: TObject; E: Exception);
var
  w_Str: string;
  w_DateTimm:TDateTime;
  w_heaher:string;
  w_msg:string;
begin
  //��O�͂��̂܂ܕ\��
  //Application.ShowException(E);
try
  if  w_TraceFlg<> true  then exit;
  w_heaher:= '�I�I�I�I�I ��O���� �I�I�I�I�I' +
             '(' + DateTimeToStr (now) + ')';
  w_msg := E.Message;

  w_DateTimm:=Now;
  w_Str:= w_heaher + ':['+IntToStr(DateTimeToTimeStamp(w_DateTimm).Time) +']';
  Writeln(w_TraceFile,
          w_Str);
  w_Str := copy(w_msg,1,Length(w_msg));
  Writeln(w_TraceFile,
          w_Str);
  Writeln(w_TraceFile);

except
   exit;
end;
   exit;
end;

//���@�\�F���x�����O�o��
//��O�͔��������Ȃ�
procedure proc_TraceMsgLog(arg_place:string; arg_msg:string; arg_tracemode:string);
var
  w_Str: string;
  w_DateTimm:TDateTime;
  w_heaher:string;
begin
  //��O�͂��̂܂ܕ\��
  //Application.ShowException(E);
try
  if  w_TraceFlg<> true  then exit;
  if  0 >= length(trim(arg_tracemode))  then exit;

  if (StrToIntDef(arg_tracemode,3) < StrToInt(w_TraceMode)) then exit;
  w_heaher:= '���������� ���b�Z�[�W���O ����������' +
             '(' + DateTimeToStr (now) + ')';
  w_DateTimm:=Now;
  w_Str:= w_heaher + ':['+IntToStr(DateTimeToTimeStamp(w_DateTimm).Time) +']';
  Writeln(w_TraceFile,
          w_Str);
  w_Str:= arg_place + ' : ';
  Writeln(w_TraceFile,
          w_Str);
  w_Str:= arg_msg  ;
  Writeln(w_TraceFile,
          w_Str);
  Writeln(w_TraceFile);

except
   exit;
end;
   exit;
end;
//���@�\
{
function func_XXX( arg_XXXXXX: string):Txxxx;

begin

end;
}

initialization
begin
//*********+*********+*********+*********+*********+*********+*********+*********+
//�@�����񏉊��l�ݒ�
    w_TraceFlg:= false;
    w_TraceMode:= wCST_TRAC_MODE0;
//�ATRACE INI���ǂݍ���
     wini_TRACE_Key :=
            func_ReadIniSecKeyToTStrings(
                                      g_product_inifile_name,
                                      g_TRACE_SECSION
                                                         );
     //INI���Ȃ���Γ����Ȃ��B
     if (wini_TRACE_Key= nil) or
        (wini_TRACE_Key.Count=0)then Exit;
     //���i�[��z��̑傫���ݒ�   gini_Wareki  wa_KeyValues
     SetLength ( wini_TRACE ,wini_TRACE_Key.Count);
     if wini_TRACE_Key.Count < 1 then exit;
     if False=func_ReadIniSecToATStrings(
                                g_product_inifile_name,
                                g_TRACE_SECSION,
                                wini_TRACE_Key,
                                wini_TRACE
                                                   ) then Exit;
    //�g���[�X���[�h����
    if (high(wini_TRACE)<0) then exit;
    w_TraceMode:=func_IniKeyValue(wini_TRACE_Key,
                                   wini_TRACE,
                                   g_MODE_KEY,
                                   0,
                                   wCST_TRAC_MODE0);
    if (wCST_TRAC_MODE1 <> w_TraceMode)
       and
       (wCST_TRAC_MODE2 <> w_TraceMode)
       and
       (wCST_TRAC_MODE3 <> w_TraceMode)
    then exit;
//�B�g���[�X�p�X�ݒ�
    w_TracePath:=G_EnvPath;
{
    w_TracePath:= func_IniKeyValue(wini_TRACE_Key,
                                   wini_TRACE,
                                   g_PATH_KEY,
                                   0,
                                   w_TracePath);
}
    w_TracePath:= func_ReadIniKeyVale(
                                   g_TRACE_SECSION,
                                   g_PATH_KEY,
                                   w_TracePath);

    if (length(w_TracePath)=0) or
       (DirectoryExists(w_TracePath)=False) then
       wini_TRACE[1][0]:=G_EnvPath;
//�C�t�@�C���T�C�Y�ݒ�  //���ǉ�RIS��
    w_TraceFileSize:=G_FILESIZE;
    w_TraceFileSize:=func_ReadIniKeyVale(
                                   g_TRACE_SECSION,
                                   g_FILESIZE_KEY,
                                   w_TraceFileSize);
    if StrToIntDef(w_TraceFileSize,0)<=0 then
    begin
      w_TraceFileSize:=G_FILESIZE;
    end;
    wi_TraceFileSize:=StrToInt(w_TraceFileSize);
//�E�g���[�X�t�@�C��������  //���ǉ�RIS��
    w_FileList:=func_FileList(w_TracePath+G_TRACE_FILE_PREFIX+'*'+G_TRACE_FILE_EXT);
    if (w_FileList<>nil)
      and
       (w_FileList.Count>=1)
    then
    begin
      w_FileList.Sort;
      w_FILENAME:=w_FileList[w_FileList.count-1];
      w_FileSize:=func_FileSize(w_TracePath+w_FILENAME);
      if w_FileSize>wi_TraceFileSize then
      begin
        w_FILENO:=Copy(w_FILENAME,length(G_TRACE_FILE_PREFIX)+1,2);
        w_FILENO:=FormatFloat('00',StrToInt(w_FILENO)+1);
        g_TRACE_FILENAME:= G_TRACE_FILE_PREFIX+w_FILENO+ G_TRACE_FILE_EXT;
      end else
      begin
        g_TRACE_FILENAME:=w_FILENAME;
      end;
    end else
    begin
      g_TRACE_FILENAME:= G_TRACE_FILE_PREFIX+'01'+ G_TRACE_FILE_EXT;
    end;

//�E�g���[�X������
    try
    AssignFile(w_TraceFile, w_TracePath + g_TRACE_FILENAME);
    try
      {$I-}
      if (FileExists(w_TracePath + g_TRACE_FILENAME)) then
        Append(w_TraceFile)
      else
        Rewrite(w_TraceFile);
      {$I+}
      if IOResult = 0 then
      Begin
        Writeln(w_TraceFile,
'*********+*********+*********+*********+*********+*********+*********+*********+'
         );
        Writeln(w_TraceFile);
        w_TraceFlg:= true;
      end;
    except
      CloseFile(w_TraceFile);
      exit;
    end;
    except
      exit;
    end;

end;

finalization
begin
//�g���[�X�I����
  if  w_TraceFlg= true then
  begin
    w_TraceFlg:=false;
    Writeln(w_TraceFile,
'*********+*********+*********+*********+*********+*********+*********+*********+'
);
    Writeln(w_TraceFile);
    CloseFile(w_TraceFile);
  end;
//�̈�̉��
  if wini_TRACE_Key<> nil then
  begin
     wini_TRACE_Key.free;
     wini_TRACE_Key:=nil;
  end;
//�̈�̉��
  wi_int:=0 ;
  while  wi_int <= ( high(wini_TRACE) - 1 ) do
  begin
    if wini_TRACE[wi_int] <> nil then
    begin
      wini_TRACE[wi_int].Free;
      wini_TRACE[wi_int]:=nil;
    end;
    wi_int := wi_int + 1;
  end;
end;

end.
