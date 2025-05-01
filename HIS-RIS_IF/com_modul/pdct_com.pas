unit pdct_com;
{
���@�\���� �i�g�p�\��F����j
 EXE�v���W�F�N�g�ɌŗL�̋��ʃ��[�`��
�� DB�ėp�c�[��
�ėp�|DB_ACC�ɈڊǗ\��|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|
//�����g�p�� �@�\�i��O���j�FDate��Between����쐬
function func_DateBetween(
       arg_FName:string;   //���ږ�
       arg_Date1:TDate;    //����
       arg_Date2:TDate     //�I��
       ):string;

//�����g�p���@�\�i��O�L�j�FListView�̓��e��CSV�t�@�C���ۑ�
procedure proc_ListViewToFile(
       arg_FName:string;      //�ۑ��t�@�C����
       arg_ListView:TListView //�Ώ�
       );

//�����g�p���@�\�i��O�L�j�FStringGrid�̓��e��CSV�t�@�C���ۑ�
procedure proc_StringGridToFile(
       arg_FName:string;          //�ۑ��t�@�C����
       arg_StringGrid:TStringGrid //�Ώ�
       );
//�����g�p���@�\�i��O�L�j�FStringGrid�̓��e��CSV�t�@�C���ۑ�
//                            ��\���J�����͕ۑ����Ȃ�
procedure proc_StringGridToFile2(
       arg_FName:string;          //�ۑ��t�@�C����
       arg_StringGrid:TStringGrid //�Ώ�
       );
�� low���x���֐�
//�����g�p���@�\�i��O�L�j�FSQL�̌��ʂ̃��R�[�h����Ԃ�
function func_SqlCount(
       arg_DB:TDatabase;          //�ڑ����ꂽDB
       arg_Sql:Tstrings):Integer; //�L����SQL
//�����g�p���@�\�i��O�L�j�FSQL�̎��s���ʂ�Ԃ� �����FTrue ���s�Ffalse
function func_SqlExec(
       arg_DB:TDatabase;          //�ڑ����ꂽDB
       arg_Sql:Tstrings):boolean; //�L����SQL

����|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|
//�����g�p���@�\�i��O���j�F���ނ𖼑O�ɕϊ��o�^ ��Z�敪
function func_PIND_Change_SYUGI(
       arg_Code:string    //����
       ):string;          //����
//�����g�p���@�\�i��O���j�F���ނ𖼑O�ɕϊ��o�^ ���e�܋敪
function func_PIND_Change_ZOUEI(
       arg_Code:string    //����
       ):string;          //����
//�����g�p���@�\�i��O���j�F���ނ𖼑O�ɕϊ��o�^ �B�e�i��  SATUEI
function func_PIND_Change_SATUEI(
       arg_Code:string    //����
       ):string;          //����
//�����g�p���@�\�i��O���j�F���ނ𖼑O�ɕϊ��o�^ ���ԊO�敪
function func_PIND_Change_JIKAN(
       arg_Code:string    //����
       ):string;          //����
//�����g�p���@�\�i��O���j�F���ނ𖼑O�ɕϊ��o�^ RI���{�t���O
function func_PIND_Change_RI(
       arg_Code:string    //����
       ):string;          //����
//�����g�p���@�\�i��O���j�F���ނ𖼑O�ɕϊ��o�^ �����˗��t���O
function func_PIND_Change_SYOKEN(
       arg_Code:string    //����
       ):string;          //����
//�����g�p���@�\�i��O���j�F���ނ𖼑O�ɕϊ��o�^ �����i��  KENSIN
function func_PIND_Change_KENSIN(
       arg_Code:string    //����
       ):string;          //����
//�����g�p���@�\�i��O���j�F���ނ𖼑O�ɕϊ��o�^�V�X�e���敪
function func_PIND_Change_SYSK(
       arg_Code:string    //����
       ):string;          //����
//�����g�p���@�\�i��O���j�F���ނ𖼑O�ɕϊ� ��
function func_PIND_Change_Sex(
       arg_Code:string    //����
       ):string;          //����
//�����g�p���@�\�i��O���j�F���ނ𖼑O�ɕϊ� ���O�敪
function func_PIND_Change_Nyugai(
       arg_Code:string    //����
       ):string;          //����

�� KANRI�e�[�u���̏�Ԑ��� �֐� �Q ---------------------------------------------
�Ǘ��e�[�u���̐���ł̓g�����U�N�V�������g������
�Ăяo���Ƃ��̓g�����U�N�V��������Ă����K�v���L��܂�
//�����g�p���@�\�i��O�L�j�FKANRI�e�[�u���̍X�V�����擾
function func_GetWKAnri(
       arg_DB:TDatabase;         //�ڑ����ꂽDB�i�K�{�j
       arg_TanName:string;       //PC����       �i�K�{�j
       arg_ProgId:string;        //�v���O����ID �i�K�{�j
       arg_RisId:string          //RIS����ID    �i�K�{�j
       ):boolean;                //����True�F�����擾���� False�F�����擾���s
 ��L�̃p�����^�ōX�V�������擾����
 arg_KanjaId arg_OrderId arg_KensaDate �ōX�V�̂��̂����ɂȂ���Ύ擾��������
 ����ȊO�͎擾���s����B

//�����g�p���@�\�i��O�L�j�FKANRI�e�[�u���̎Q�ƌ����擾
function func_GetRKAnri(
       arg_DB:TDatabase;         //�ڑ����ꂽDB �i�K�{�j
       arg_TanName:string;       //PC����       �i�K�{�j
       arg_ProgId:string;        //�v���O����ID �i�K�{�j
       arg_RisId:string          //RIS����ID    �i�K�{�j
       ):boolean;                //����True�F�����擾���� False�F�����擾���s
 ��L�̃p�����^�ŎQ�ƌ������擾����
 �����DB�װ�����Ȃ���Ώ�Ɏ擾��������B

//�����g�p���@�\�i��O�L�j�FKANRI�e�[�u���̌����Ԋ�
function func_ReleasKAnri(
       arg_DB:TDatabase;         //�ڑ����ꂽDB �i�K�{�j
       arg_TanName:string;       //PC����       �i�K�{�j
       arg_ProgId:string;        //�v���O����ID �i�K�{�j
       arg_RisId:string;         //RIS����ID    �i�K�{�j
       arg_SyoriMode:string      //�ԊҌ����� G_KANRI_TBL_RMODE �Q�ƌ��� �i�K�{�j
                                 //           G_KANRI_TBL_WMODE �X�V����

       ):boolean;                //����True�F���� False�F���s
 ��L�̃p�����^�Ŏ擾�ɐ��������������A�K�v�Ȃ��Ȃ�����K���ϊ�����B

//�����g�p���@�\�i��O�L�j�FKANRI�e�[�u���̌����S�폜
function func_DelKAnri(
       arg_DB:TDatabase;         //�ڑ����ꂽDB �i�K�{�j
       arg_TanName:string       //PC����        �i�K�{�j
       ):boolean;                //����True���� False���s
�w��arg_TanName�̑S�������ꊇ�폜����B�ʏ��Main�v���O�����̍ŏ��ɌĂяo���B

//�����g�p���@�\�i��O���j�FCardReader��ԃ`�F�b�N�֐��i�c�a�ݒ�j
function proc_ChkCardPort : Boolean;
//�����g�p���@�\�i��O���j�FCardReader��ԃ`�F�b�N�֐��i�ʐM�|�[�g�ݒ�j
function proc_ChkCardPort_Com : integer;
//2002.11.21
//�����g�p���@�\�i��O�L�j�FKANRI�e�[�u���̍X�V�����擾
function func_GetWKAnriUketuke(
       arg_DB:TDatabase;         //�ڑ����ꂽDB�i�K�{�j
       arg_TanName:string;       //PC����       �i�K�{�j
       arg_ProgId:string;        //�v���O����ID �i�K�{�j
       arg_RisId:string          //RIS����ID    �i�K�{�j
       ):boolean;                //����True�F�����擾���� False�F�����擾���s
 ��L�̃p�����^�ōX�V�������擾����
 arg_KanjaId arg_OrderId arg_KensaDate �ōX�V�̂��̂����ɂȂ���Ύ擾��������
 ����ȊO�͎擾���s����B


//�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|
//�g�p�s�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|
//�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|
//�����g�p�s���@�\�i��O�L�j�FNameMS�̓���敪���R���{�ɐݒ�i�R���{�N���A����j
procedure proc_NameMSToComb(
   arg_Qry:TQuery;
   arg_KBN:string;
   arg_Comb: TComboBox
   );

//�����g�p�s���@�\�i��O�L�j�FNameMS�̓���敪���R���{�ɐݒ�i�R���{�N���A���Ȃ��j
procedure proc_NameMSToComb1(
   arg_Qry:TQuery;
   arg_KBN:string;
   arg_Comb: TComboBox
   );

�� ���[�U�̓o�^�m�F
//�����g�p�s���@�\�i��O�L�j�FUSERMS��User_name���m�F
function func_ChkUserName(
       arg_DB:TDatabase;         //�ڑ����ꂽDB
       arg_UserName:string       //���[�U��
       ):boolean;
//�����g�p�s���@�\�i��O�L�j�FUSERMS��User_name��PASSWORD���m�F
function func_ChkUserPass(
       arg_DB:TDatabase;
       arg_UserName:string;
       arg_Password:string
       ):boolean;
//�����g�p�s���@�\�i��O�L�j�FUSERMS��User_name��class���m�F
function func_ChkUserClass(
       arg_DB:TDatabase;         //�ڑ����ꂽDB
       arg_UserName:string;      //���[�U��
       arg_Class:string          //�N���X
       ):boolean;
//�����g�p���@�\�i��O���j�F���[�N���X�g�\��e�[�u���p�L�[���ڕҏW
function func_WorklistInfo_Key_Make(
         //IN
         arg_KanjaID: string;
         arg_OrderNO: string;
         //OUT
         var arg_Rcv_ACCESSION_NUMBER: string;
         var arg_Rcv_PATIENT_ID: string
        ): Boolean;
���[�N���X�g�\��e�[�u���̃L�[���ڂ�ҏW����B
//�����g�p���@�\�i��O���j�F���[�N���X�g�\��e�[�u���p�S���ڕҏW
function func_WorklistInfo_Make(
         //IN
         arg_Query: TQuery;
         arg_Group_No: string;
         arg_SysDate: string;
         arg_SysTime: string;
         arg_KanjaID: string;
         arg_OrderNO: string;
         arg_SimeiKana: string;
         arg_SimeiKanji: string;
         arg_Sex: string;
         arg_BirthDay: string;
         arg_Start_Date: string;
         arg_Start_Time: string;
         arg_Irai_Doctor_Name: string;
         arg_Irai_Section_Name: string;
         arg_Irai_Section_Kana: string;
         arg_KensaKikiName: string;
         arg_Modality_Type: string;
         arg_KensaComment1: string;
         arg_SUID: string;
         //OUT
         var arg_Rcv_SCH_STATION_AE_TITLE: string;
         var arg_Rcv_SCH_PROC_STEP_LOCATION: string;
         var arg_Rcv_SCH_PROC_STEP_START_DATE: string;
         var arg_Rcv_SCH_PROC_STEP_START_TIME: string;
         var arg_Rcv_SCH_PERF_PHYSICIANS_NAME_ROMA: string;
         var arg_Rcv_SCH_PERF_PHYSICIANS_NAME_KANJI: string;
         var arg_Rcv_SCH_PERF_PHYSICIANS_NAME_KANA: string;
         var arg_Rcv_SCH_PROC_STEP_DESCRIPTION: string;
         var arg_Rcv_SCH_PROC_STEP_ID: string;
         var arg_Rcv_COMMENTS_ON_THE_SCH_PROC_STEP: string;
         var arg_Rcv_MODALITY: string;
         var arg_Rcv_REQ_PROC_ID: string;
         var arg_Rcv_STUDY_INSTANCE_UID: string;
         var arg_Rcv_REQ_PROC_DESCRIPTION: string;
         var arg_Rcv_REQUESTING_PHYSICIAN: string;
         var arg_Rcv_REQUESTING_SERVICE: string;
         var arg_Rcv_ACCESSION_NUMBER: string;
         var arg_Rcv_INSTITUTION: string;
         var arg_Rcv_INSTITUTION_ADDRESS: string;
         var arg_Rcv_PATIENT_NAME_ROMA: string;
         var arg_Rcv_PATIENT_NAME_KANJI: string;
         var arg_Rcv_PATIENT_NAME_KANA: string;
         var arg_Rcv_PATIENT_ID: string;
         var arg_Rcv_PATIENT_BIRTH_DATE: string;
         var arg_Rcv_PATIENT_SEX: string;
         var arg_Rcv_PATIENT_WEIGHT: string
        ): Boolean;
���[�N���X�g�\��e�[�u���̑S���ڂ�ҏW����B
//�����g�p���@�\�i��O���j�F�J�^�J�i�����[�}���ϊ�
function func_Kana_To_Roma(
         arg_Kana: string
         ): string;

�ԍ��Ǘ��e�[�u�����w��敪�̌��ݔԍ����擾���A
�{�P�����l��Ԃ��B�܂��A���̌��ʂ����ݔԍ��ɏ������ށB
�{�P�������ʁA�w��敪�̍ő�l�𒴂���ꍇ�ł��l��Ԃ��̂�
�ďo���Ń`�F�b�N���܂��B
��O�͖߂�l�ɂO���Z�b�g����Ă���ꍇ�ł��B
�y���������z
  arg_Database:TQuery; �| �������ݗp�f�[�^�x�[�X(�K�{)
  arg_Query:TQuery;    �| �ǂݍ��ޗp�N�G���[(�K�{)
  arg_Kubun:string;    �| �w��敪(�K�{)
  arg_Date:string      �| �������t(���t�Ǘ����s���敪�̂ݎw��)�|yyyy/mm/dd
//�����g�p���@�\�i��O�L�j�F���ݔԍ�+1�擾
function func_Get_NumberControl(
         arg_Database:TDatabase;
         arg_Query:TQuery;
         arg_Kubun:string;
         arg_Date:string
         ):integer;
�ԍ��Ǘ��e�[�u���̎w��敪�̌��ݔԍ����X�V����B
��L�Ŏg�p����֐�
�y���������z
  arg_Database:TQuery; �| �������ݗp�f�[�^�x�[�X(�K�{)
  arg_Query:TQuery;    �| �ǂݍ��ޗp�N�G���[(�K�{)
  arg_Mode:integer;    �| �P�F�V�K�A�Q�F�C��
  arg_Kubun:string;    �| �w��敪(�K�{)
  arg_UpdateDate:string�| �������t�|yyyy/mm/dd
  arg_Now_NO:integer   �| �X�V�̌��ݔԍ�(�K�{)
//�����g�p���@�\�i��O�L�j�F���ݔԍ��X�V
function func_NumberControl_Update(
         arg_Database:TDatabase;
         arg_Query:TQuery;
         arg_Mode:integer;
         arg_Kubun:string;
         arg_UpdateDate:string;
         arg_Now_NO:integer
         ):Boolean;
//�����g�p���@�\�i��O���j�F�S������̑S�p�`�F�b�N
func_ALL_ZENKAKU_CHECK(arg_text: string):Boolean;
//�����g�p���@�\�i��O���j�F�S������̔��p�`�F�b�N
func_ALL_HANKAKU_CHECK(arg_text: string):Boolean;
//2002.11.18
//���@�\�i��O���j�F�S������̔��p�`�F�b�N
func_ALL_HANKAKU_AISUU_CHECK(arg_text: string):Boolean;



������
�V�K�쐬�F2000.04.12�F�S��  iwai
�C��    �F2000.05.11�F�S��  iwai
//���@�\�i��O�L�j�FListView�̓��e��CSV�t�@�C���ۑ�
procedure proc_ListViewToFile();
//���@�\�i��O�L�j�FNameMS�̓���敪���R���{�ɐݒ�i�R���{�N���A����j
procedure proc_NameMSToComb();
//���@�\�i��O�L�j�FNameMS�̓���敪���R���{�ɐݒ�i�R���{�N���A���Ȃ��j
procedure proc_NameMSToComb1();
��ǉ�
�C��    �F2000.11.30�F�S��  iwai
�R�[�h�ϊ�������ǉ�
func_PIND_Change_Nyugai
func_PIND_Change_Sex
func_PIND_Change_SYSK
func_PIND_Change_KENSIN
func_PIND_Change_SYOKEN
func_PIND_Change_RI
func_PIND_Change_JIKAN
func_PIND_Change_SATUEI
func_PIND_Change_ZOUEI
func_PIND_Change_SYUGI

�C��    �F2000.12.04�F�S��  iwai
���[�ԍ��̒�`��ǉ�

�C��    �F2000.12.19�F�S��  iwai
�J�[�h���[�_�̃`�F�b�N�֐���ǉ�

�C��    �F2000.12.22�F�S��  ���c
GPCST_NAME_JIKAN_2 = '�x��',GPCST_NAME_JIKAN_3 = '����'
                           ��
GPCST_NAME_JIKAN_2 = '����',GPCST_NAME_JIKAN_3 = '�x��'
�ɏC��

�C��    �F2001.01.11�F�S��  iwai
�Ǘ��e�[�u�����䃋�[�`�����C�����f
�g�����͕ύX�Ȃ�
KANRI�e�[�u���̍X�V�����擾 function func_GetWKAnri
KANRI�e�[�u���̎Q�ƌ����擾 function func_GetRKAnri
KANRI�e�[�u���̌����Ԋ� function func_ReleasKAnri
KANRI�e�[�u���̌����S�폜 function func_DelKAnri

�C��    �F2001.01.18�F�S��  ���R
���[�N���X�g�\��e�[�u���p�L�[���ڕҏW func_WorklistInfo_Key_Make
�C��    �F2001.01.18�F�S��  ���R
���[�N���X�g�\��e�[�u���p�S���ڕҏW func_WorklistInfo_Make
�C��    �F2001.01.18�F�S��  ���R
�J�^�J�i�����[�}���ϊ� func_Kana_To_Roma
�C��    �F2001.03.15�F���c
�˗��敪�̒ǉ�
�ǉ�    �F2001.08.31�F���R
���ݔԍ�+1�擾�̒ǉ�
���ݔԍ��X�V�̒ǉ�
�ǉ�    �F2001.09.01�F���c
��w���v�ʐ^���ނ̒ǉ�
��w���v�������ނ̒ǉ�
��Z�敪�̒ǉ�
�ǉ�    �F2001.09.03�F���c
���e�܋敪�̒ǉ�
�ǉ�    �F2001.09.04�F���c
���E���̂̏����l�ǉ�
�ǉ��@�@�F2001.09.04�F����
�E���敪�̒ǉ�
�ǉ�    �F2001.09.05�F���c
������ʂ̒ǉ�
�v���Z�b�gID�ԍ��擾�p�敪�̒ǉ�
�ǉ�    �F2001.09.06�F���c
�E��敪���R�`�p����L���p�ɕύX
�ǉ�    �F2001.09.07�F���c
func_PIND_Change_KAIKEI��ǉ�
���ʂ��R�`�p����L���p�ɕύX
���O�敪��ǉ�
�ǉ�    �F2001.09.10�F���c
�a���A��TEL,�A��w����ǉ�
func_PIND_Change_KITAKU,func_PIND_Change_TEL��ǉ�
�ǉ�    �F2001.09.11�F���c
�����v�ۂ̒ǉ�
func_PIND_Change_SYOKEN_YOUHI�̒ǉ�
�C��    �F2001.09.13�F���c
func_PIND_Change_KENSIN���L���p�ɕύX
�B�e�i����ǉ�
func_PIND_Change_SATUEISTATUS��ǉ�
�ǉ�    �F2001.09.13�F���R
�摜�m�F�̒ǉ�
func_PIND_Change_GAZOU_KAKUNIN�̒ǉ�
�ǉ�    �F2001.09.17�F�R��
//�v�����^�^�C�v�擾�̒ǉ�
func_Get_PrintType
�ǉ�    �F2001.09.20�F���R
�a���A��TEL,�A��w��,�摜�m�F�̉�ʗp��ǉ�
func_PIND_Change_KITAKU_G,func_PIND_Change_TEL_G,func_PIND_Change_GAZOU_KAKUNIN_G��ǉ�
�ǉ�    �F2001.09.21�F����
�v�����g�^�C�v�̔ԍ��擾�̒ǉ�
�ǉ�    �F2001.09.25�F����
//�S������̑S�p�A���p�`�F�b�N�̒ǉ�
func_ALL_ZENKAKU_CHECK,func_ALL_HANKAKU_CHECK
�C��    �F2001.10.01�F���c
func_PIND_Change_SATUEISTATUS�̏C��
�F�֗v�ۂ̒ǉ�
func_PIND_Change_COLOR_YOUHI�̒ǉ�
�ǉ�    �F2002.09.20�F���R
���E�g�p�̒ǉ�
func_PIND_Change_SAYUU�̒ǉ�
�ǉ�    �F2002.09.24�F���R
�ǉe�v�ۂ̒ǉ�
func_PIND_Change_DOKUEI�̒ǉ�
�ǉ�    �F2002.09.24�F���R
���u���g�p�̒ǉ�
func_PIND_Change_SHOTI�̒ǉ�
�ǉ�    �F2002.09.24�F���R
�v���e�̒ǉ�
func_PIND_Change_YZOUEI�̒ǉ�
�ǉ�    �F2002.09.24�F���R
�v���e�̒ǉ�
�O���b�h�J���������������ݒǉ�
func_Grid_ColumnSize_Write�̒ǉ�
�ǉ�    �F2002.10.02�F���R
�O���b�h�J��������ǂݍ��ޒǉ�
proc_Grid_ColumnSize_Read�̒ǉ�
�ǉ�    �F2002.10.02�F���R
��t����敪�̒ǉ�
func_PIND_Change_ISITATIAI�̒ǉ�
�ǉ�    �F2002.10.03�F���R
FCR�A�g�̒ǉ�
func_PIND_Change_FCR�̒ǉ�
�ǉ�    �F2002.10.05�F���R
MPPS�Ή��̒ǉ�
func_PIND_Change_MPPS�̒ǉ�
�ǉ�    �F2002.10.05�F���R
��Z�敪���̑Ή��̒ǉ�
�ǉ�    �F2002.10.08�F���R
������ʂ𐹘H���p�ɕύX
�ύX�@�@�F2002.10.09�F���R
�ǉe�v�ۂ̒ǉ��ɍ��ڒǉ�
�C���@�@�F2002.10.15�F���R
�ǉ�    �F2002.10.21�F����
�@������ʖ��̃t�B���^�t���O���ږ��̊i�[�^�C�v�錾
�@������ʖ��̃t�B���^�t���O���ږ��̊i�[�ϐ��錾
���҃}�X�^���ڎ擾���ڒǉ�(����ID�Q��)
�ǉ�    �F2002.10.22�F���R
���҃}�X�^���ڎ擾���ڒǉ�(RIS����ID�Q��)
�ǉ�    �F2002.10.22�F���R
�C��    �F2002.10.23�F����
�@������ʖ��̊��҃}�X�^�̌����R�����g���ږ����i�[�^�C�v�ɒǉ�
�ǉ��@�@�F2002.10.30�F�J��
��v���M��ʂ̒ǉ�
func_PIND_Change_KAIKEI�̒ǉ�
�ǉ��@�@�F2002.11.07�F���c �M
���ID���ڒǉ���
//2002.11.21
�ǉ��@�@�F2002.11.29�F�J��
��񍀖ڕʃ}�X�^�敪�̂T�`�P�S��ǉ�

KANRI�e�[�u���̍X�V�����擾 function func_GetWKAnriUketuke
//���@�\�i��O���j�F�V�F�[�}�i�[�t�@�C�����쐬
function func_Make_ShemaName(arg_OrderNO,               //�I�[�_NO
                             arg_MotoFileName: string;  //HIS���ϖ�
                             arg_Index: integer         //����NO
                             ):string;                  //�i�[̧�ٖ�


//�����g�p���@�\�i��O���j�F�����ϊ�
func_Moji_Henkan(arg_Moji: string;
                 arg_Flg: Integer  //1:�S�p�����p�A2:���p���S�p�A3:�S�p�Ђ炪�ȁ����p�J�^�J�i
                 ): string;
�C���@�@�F2003.02.17�F���c
�@�@�@�@�@�@�@�@�@�@�@�t�@�C���g���q�̐؂�o�����C��
�C��    �F2003.12.06�F�J��
�@�@�@�@�@�@�@�@�@�@�@������ʂ𐹃}���A���i�p�ɕύX�B
�C��    �F2003.12.11�F�J��
�@�@�@�@�@�@�@�@�@�@�@�`�[����t���O�̍X�V������ǉ��B
�C��    �F2003.12.25�F���c
�@�@�@�@�@�@�@�@�@�@�@RI�I�[�_�ԍ��ϊ��ԍ��i���ˁE�����j��ǉ��B
�C���@�@�F2004.01.04�F�J��
�@�@�@�@�@�@�@�@�@�@�@Initial�ݒ�p�֐���E1�i�v���`�F�b�N�j��ʗp��ǉ��B
�ǉ�    �F2004.01.13�F����
                      �֐��ǉ��ifunc_GyoumuKbn_Check�j�B
�ǉ�    �F2004.01.22�F����
                      ReportRisTable�ݒ�t���O(WinMaster�p)�ǉ�
�ǉ�    �F2004.03.25�F����
                      TensouOrderTable�p��ԃt���O�ǉ�
�ǉ�    �F2004.03.31�F���c
                      �d��NG��ޒǉ�
�ǉ�    �F2004.04.09�F����
                      ��t���pRIS�I�[�_���M�L���[�t���O&�_�~�[ID����֐��ǉ�
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
  Graphics,
  Controls,
  Forms,
  Dialogs,
  IniFiles,
  Registry,
  ExtCtrls,
  ComCtrls,
  StdCtrls,
  Grids,
//�v���_�N�g�J�����ʁ|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|
  Gval,
  myInitInf,
  pdct_ini,
  ErrorMsg,
  DB_ACC,
  Trace,
  com00, ComSb01,
  OraDate2,
  OraNumber,
  OraStringGrid,
  jis2sjis,
  //2003.10.06 Start************************************************************
  GKitSpreadControl;
  //2003.10.06 end**************************************************************

////�^�N���X�錾-------------------------------------------------------------
//type
//2002.10.21 ������ʖ��̃t�B���^�t���O���ږ��̊i�[�^�C�v�錾
type TKensaType_Field = record
  Kensa_ID: String;
  FilterName: String;
  KensaCommentName: String;
  end;

//�萔�錾-------------------------------------------------------------------

{$INCLUDE'INC_Ris_Card.inc'}

const
//�v���_�N�g�ŗL��񁫁�����������������������������������������������������������
G_HELPFILENAME= 'ris_ych.hlp';      //�w���v�t�@�C����
//���̨����FGPCST
//���R�[�h�y�і��̒�`
//2001.09.07
// ����
GPCST_SEX_1='1';
GPCST_SEX_2='2';
GPCST_SEX_3='3';
GPCST_SEX_1_NAME='M';
GPCST_SEX_2_NAME='F';
GPCST_SEX_3_NAME='�s��';
GPCST_SEX_3P_NAME='O';
// ���O�敪
{2004.01.08
GPCST_NYUGAIKBN_1='1';
GPCST_NYUGAIKBN_2='2';
2004.01.08}
GPCST_NYUGAIKBN_1='2';
GPCST_NYUGAIKBN_2='1';
{2002.10.30
GPCST_NYUGAIKBN_1_NAME='���@';
GPCST_NYUGAIKBN_2_NAME='�O��';
2002.10.30}
GPCST_NYUGAIKBN_1_NAME='�O��';
GPCST_NYUGAIKBN_2_NAME='���@';
// ��v���
GPCST_KAIKEITYPE_0='0';
GPCST_KAIKEITYPE_1='1';
GPCST_KAIKEITYPE_2='2';
GPCST_KAIKEITYPE_3='3';
GPCST_KAIKEITYPE_0_NAME='�㎖';
GPCST_KAIKEITYPE_1_NAME='����';
GPCST_KAIKEITYPE_2_NAME='�Z��';
GPCST_KAIKEITYPE_3_NAME='����';
// �o�^�V�X�e���敪  _SYSK
GPCST_CODE_SYSK_RIS = 'R';
GPCST_CODE_SYSK_HIS = 'H';
GPCST_NAME_SYSK_RIS = 'RIS';
GPCST_NAME_SYSK_HIS = 'HIS';
// �����i�� _KENSIN
GPCST_CODE_KENSIN_0 = '0';
GPCST_CODE_KENSIN_1 = '1';
GPCST_CODE_KENSIN_2 = '2';
GPCST_CODE_KENSIN_3 = '3';
GPCST_CODE_KENSIN_4 = '4';
GPCST_NAME_KENSIN_0 = '����';
GPCST_NAME_KENSIN_1 = '���';
GPCST_NAME_KENSIN_2 = '����';
GPCST_NAME_KENSIN_3 = '����';
GPCST_NAME_KENSIN_4 = '���~';
GPCST_RYAKU_NAME_KENSIN_0 = '��';
GPCST_RYAKU_NAME_KENSIN_1 = '��';
GPCST_RYAKU_NAME_KENSIN_2 = '��';
GPCST_RYAKU_NAME_KENSIN_3 = '��';
GPCST_RYAKU_NAME_KENSIN_4 = '�~';
// �����i�� _KENSIN_SUB
GPCST_CODE_KENSIN_SUB_5 = '5';
GPCST_CODE_KENSIN_SUB_6 = '6';
GPCST_CODE_KENSIN_SUB_7 = '7';
GPCST_CODE_KENSIN_SUB_8 = '8';
GPCST_CODE_KENSIN_SUB_9 = '9';
GPCST_CODE_KENSIN_SUB_10= '10';
GPCST_NAME_KENSIN_SUB_5 = '�ďo';
GPCST_NAME_KENSIN_SUB_6 = '�x��';
GPCST_NAME_KENSIN_SUB_7 = '�m��';
GPCST_NAME_KENSIN_SUB_8 = '�ۗ�';
GPCST_NAME_KENSIN_SUB_9 = '�Č�';
GPCST_NAME_KENSIN_SUB_10= '�Ď�';
GPCST_RYAKU_NAME_KENSIN_SUB_5 = '��';
GPCST_RYAKU_NAME_KENSIN_SUB_6 = '�x';
GPCST_RYAKU_NAME_KENSIN_SUB_7 = '�m';
GPCST_RYAKU_NAME_KENSIN_SUB_8 = '��';
GPCST_RYAKU_NAME_KENSIN_SUB_9 = '��';
GPCST_RYAKU_NAME_KENSIN_SUB_10= '��';

// �����˗��t���O _SYOKEN
GPCST_CODE_SYOKEN_0 = '0';
GPCST_CODE_SYOKEN_1 = '1';
GPCST_NAME_SYOKEN_0 = '�s�v';
GPCST_NAME_SYOKEN_1 = '�v';
// RI���{�t���O _RI
GPCST_CODE_RI_0 = '0';
GPCST_CODE_RI_1 = '1';
GPCST_NAME_RI_0 = '���ׂȂ�';
GPCST_NAME_RI_1 = '���ׂ���';
// ���ԊO�敪  _JIKAN
GPCST_CODE_JIKAN_0 = '0';
GPCST_CODE_JIKAN_1 = '1';
GPCST_CODE_JIKAN_2 = '2';
GPCST_CODE_JIKAN_3 = '3';
GPCST_NAME_JIKAN_0 = '�莞';
GPCST_NAME_JIKAN_1 = '�\��O';
GPCST_NAME_JIKAN_2 = '�x��';
GPCST_NAME_JIKAN_3 = '����';
// �B�e�i�� _SATUEI
GPCST_CODE_SATUEI_0 = '0';
GPCST_CODE_SATUEI_1 = '1';
GPCST_CODE_SATUEI_2 = '2';
GPCST_NAME_SATUEI_0 = '���B�e';
GPCST_NAME_SATUEI_1 = '�B�e��';
GPCST_NAME_SATUEI_2 = '�B�e�L�����Z��';
// ���e�܋敪 _ZOUEI
GPCST_CODE_ZOUEI_0 = '0';
GPCST_CODE_ZOUEI_1 = '1';
GPCST_CODE_ZOUEI_2 = '2';
GPCST_CODE_ZOUEI_3 = '3';
GPCST_CODE_ZOUEI_4 = '4';
GPCST_NAME_ZOUEI_0 = '';
GPCST_NAME_ZOUEI_1 = '���e��';
GPCST_NAME_ZOUEI_2 = '���';
GPCST_NAME_ZOUEI_3 = '�J�e';
GPCST_NAME_ZOUEI_4 = '����';
// ��Z�敪 SYUGI
GPCST_CODE_SYUGI_0 = '0';
GPCST_CODE_SYUGI_1 = '1';
GPCST_CODE_SYUGI_2 = '2';
//GPCST_CODE_SYUGI_3 = '3';
GPCST_NAME_SYUGI_0 = '';
GPCST_NAME_SYUGI_1 = '��{';
GPCST_NAME_SYUGI_2 = '���u';
//GPCST_NAME_SYUGI_3 = '�ȊO�͎�Z';
// �E��敪
{GPCST_SYOKUSHU_1='1';
GPCST_SYOKUSHU_2='2';
GPCST_SYOKUSHU_3='3';
GPCST_SYOKUSHU_4='4';
GPCST_SYOKUSHU_1_NAME='��t';
GPCST_SYOKUSHU_2_NAME='�Z�t';
GPCST_SYOKUSHU_3_NAME='�Ō�w';
GPCST_SYOKUSHU_4_NAME='�E��';}
//2001.09.06
GPCST_SYOKUSHU_1='1';
GPCST_SYOKUSHU_2='2';
GPCST_SYOKUSHU_3='3';
GPCST_SYOKUSHU_4='4';
GPCST_SYOKUSHU_1_NAME='��t';
GPCST_SYOKUSHU_2_NAME='������';
GPCST_SYOKUSHU_3_NAME='�Z�t';
GPCST_SYOKUSHU_4_NAME='�Ō�t';
//�����[�ԍ�
GPCST_CHUHYO_BASE  = '00';
GPCST_CHUHYO_CH010 = '01';
GPCST_CHUHYO_CH020 = '02';
GPCST_CHUHYO_CH030 = '03';
GPCST_CHUHYO_CH040 = '04';
GPCST_CHUHYO_CH050 = '05';
GPCST_CHUHYO_CH060 = '06';
GPCST_CHUHYO_CH070 = '04';
//�������ĕ\���^�C�g��
GPCST_AUTO_DISP_TITLE  = '�����ĕ\�����|';
//2001.09.10
//���A��w��
GPCST_KITAKU_0 = '0';
GPCST_KITAKU_1 = '1';
GPCST_KITAKU_0_NAME = '���A��';
GPCST_KITAKU_1_NAME = '�A���';
//2001.09.10
//���a���A��TEL
GPCST_TEL_0 = '0';
GPCST_TEL_1 = '1';
GPCST_TEL_0_NAME = '��';
GPCST_TEL_1_NAME = '�v';
//2001.09.11
//�������v��
GPCST_SYOKEN_YOUHI_0 = '0';
GPCST_SYOKEN_YOUHI_1 = '1';
GPCST_SYOKEN_YOUHI_0_NAME = '�s�v';
GPCST_SYOKEN_YOUHI_1_NAME = '�K�v';
// �B�e�i��
GPCST_CODE_SATUEIS_0 = '0';
GPCST_CODE_SATUEIS_1 = '1';
GPCST_CODE_SATUEIS_2 = '2';
GPCST_NAME_SATUEIS_0 = '��';
GPCST_NAME_SATUEIS_1 = '��';
GPCST_NAME_SATUEIS_2 = '���~';
GPCST_NAME_SATUEIS2_0 = '������';
GPCST_NAME_SATUEIS2_1 = '���͍�';
GPCST_NAME_SATUEIS2_2 = '���~';
//���摜�m�F
GPCST_GAZOU_KAKUNIN_0 = '0';
GPCST_GAZOU_KAKUNIN_1 = '1';
GPCST_GAZOU_KAKUNIN_0_NAME = '��';
GPCST_GAZOU_KAKUNIN_1_NAME = '��';
//2001.09.20
//���A��w��
GPCST_KITAKU_0_G = '0';
GPCST_KITAKU_1_G = '1';
GPCST_KITAKU_0_NAME_G = '��';
GPCST_KITAKU_1_NAME_G = '�A';
//���a���A��TEL
GPCST_TEL_0_G = '0';
GPCST_TEL_1_G = '1';
GPCST_TEL_0_NAME_G = '';
GPCST_TEL_1_NAME_G = 'TEL';
//���摜�m�F
GPCST_GAZOU_KAKUNIN_0_G = '0';
GPCST_GAZOU_KAKUNIN_1_G = '1';
GPCST_GAZOU_KAKUNIN_0_NAME_G = '��';
GPCST_GAZOU_KAKUNIN_1_NAME_G = '��';
//����������������������������������������������������������������
//�֐������̒萔//
//�Ǘ��e�[�u��
G_KANRI_TBL_RMODE = '0';//�Q�ƃ��[�h
G_KANRI_TBL_WMODE = '1';//�X�V���[�h

//���˗��敪 2001.03.15
GPCST_KBN_10 = '10'; //�P���B�e
GPCST_KBN_15 = '15'; //�߰���َB�e
GPCST_KBN_20 = '20'; //�f�w�B�e
GPCST_KBN_30 = '30'; //X�����e
GPCST_KBN_50 = '50'; //CT
GPCST_KBN_60 = '60'; //MR
GPCST_KBN_70 = '70'; //RI
GPCST_KBN_80 = '80'; //���Ǒ��e
GPCST_KBN_90 = '90'; //�������
{2001.09.01 Start}
//����w���v�ʐ^����
CST_DSB = 'DSB';
//����w���v��������
CST_DTB = 'DTB';
//����Z�敪
CST_SYUGI = 'SHG';
{2001.09.01 End}
//2001.09.03
//�����e�܋敪
CST_ZOUEI = 'ZOE';
//2001.09.04
CST_SAYUU_DEF = '�Ȃ�';
//2001.09.03
//���E���敪
CST_SYOKUIN = 'SHK';
{2001.09.05 Start}
//���������
{2003.11.26 �ύX
GPCST_SYUBETU_01 = '01'; //��ʎB�e
GPCST_SYUBETU_02 = '02'; //DIP�DIC
GPCST_SYUBETU_03 = '03'; //Portable
GPCST_SYUBETU_04 = '04'; //MMG
GPCST_SYUBETU_05 = '05'; //���[����
GPCST_SYUBETU_06 = '06'; //���[����
GPCST_SYUBETU_07 = '07'; //CT
GPCST_SYUBETU_08 = '08'; //MRI
GPCST_SYUBETU_09 = '09'; //XTV
GPCST_SYUBETU_10 = '10'; //���Ǒ��e
GPCST_SYUBETU_11 = '11'; //�S�J�e
GPCST_SYUBETU_12 = '12'; //Echo
GPCST_SYUBETU_13 = '13'; //RI
GPCST_SYUBETU_14 = '14'; //�Q�Ɖ摜�捞
GPCST_SYUBETU_15 = '15'; //�t�B�����o��
GPCST_SYUBETU_20 = '20'; //���Ìv��CT
GPCST_SYUBETU_21 = '21'; //���Èʒu����
}

{2003.12.06 �ύX
GPCST_SYUBETU_01 = '01'; //���     <�B�e�n>
GPCST_SYUBETU_02 = '02'; //����     <�����n>
GPCST_SYUBETU_03 = '03'; //����     <�����n>
GPCST_SYUBETU_04 = '04'; //CT       <�����n>
GPCST_SYUBETU_05 = '05'; //MRI      <�����n>
GPCST_SYUBETU_06 = '06'; //�j��w   <�����n>
GPCST_SYUBETU_07 = '07'; //����     <�����n>
GPCST_SYUBETU_08 = '08'; //�~����� <�B�e�n>
GPCST_SYUBETU_09 = '09'; //�~������ <�����n>
GPCST_SYUBETU_10 = '10'; //�~��CT   <�����n>
GPCST_SYUBETU_11 = '11'; //����     <�B�e�n>
GPCST_SYUBETU_12 = '12'; //����     <�����n>
GPCST_SYUBETU_13 = '';   //���g�p
GPCST_SYUBETU_14 = '';   //���g�p
GPCST_SYUBETU_15 = '';   //���g�p
GPCST_SYUBETU_20 = '';   //���g�p
GPCST_SYUBETU_21 = '';   //���g�p}

{2003.12.19 �ύX
GPCST_SYUBETU_11 = '11'; //���     �@�@�@<�B�e�n>
GPCST_SYUBETU_12 = '12'; //���ꌟ��     �@<�B�e�n>
GPCST_SYUBETU_13 = '13'; //����     �@�@�@<�����n>
GPCST_SYUBETU_14 = '14'; //����       �@�@<�����n>
GPCST_SYUBETU_15 = '15'; //����      �@�@ <�����n>
GPCST_SYUBETU_16 = '16'; //CT   �@�@�@�@�@<�����n>
GPCST_SYUBETU_17 = '17'; //MR    �@�@�@�@ <�����n>
GPCST_SYUBETU_18 = '18'; //�j��w�@�@�@�@ <�����n>
GPCST_SYUBETU_19 = '19'; //���� �@�@�@�@�@<�����n>
GPCST_SYUBETU_20 = '20'; //���Èʒu����   <�B�e�n>
GPCST_SYUBETU_21 = '21'; //���Èʒu����CT <�����n>
GPCST_SYUBETU_22 = '22'; //�~�����     �@<�B�e�n>
GPCST_SYUBETU_23 = '23'; //�~������       <�����n>
GPCST_SYUBETU_24 = '24'; //�~��CT         <�����n>
GPCST_SYUBETU_25 = '25';   //���g�p
GPCST_SYUBETU_26 = '26';   //���g�p
GPCST_SYUBETU_27 = '27';   //���g�p}

GPCST_SYUBETU_01 = '01'; //���     �@�@�@<�B�e�n>
GPCST_SYUBETU_12 = '12'; //���ꌟ��     �@<�B�e�n>
GPCST_SYUBETU_03 = '03'; //����     �@�@�@<�����n>
GPCST_SYUBETU_10 = '10'; //����       �@�@<�����n>
GPCST_SYUBETU_08 = '08'; //����      �@�@ <�����n>
GPCST_SYUBETU_05 = '05'; //CT   �@�@�@�@�@<�����n>
GPCST_SYUBETU_06 = '06'; //MR    �@�@�@�@ <�����n>
GPCST_SYUBETU_07 = '07'; //�j��w�@�@�@�@ <�����n>
GPCST_SYUBETU_09 = '09'; //���� �@�@�@�@�@<�����n>
GPCST_SYUBETU_14 = '14'; //���Èʒu����   <�B�e�n>
GPCST_SYUBETU_15 = '15'; //���Èʒu����CT <�����n>
GPCST_SYUBETU_31 = '31'; //�~�����     �@<�B�e�n>
GPCST_SYUBETU_38 = '38'; //�ʊٌ���       <�����n>
GPCST_SYUBETU_35 = '35'; //�ʊ�CT         <�����n>
GPCST_SYUBETU_13 = '13'; //��ߎ��߰����   <�B�e�n> 2003.12.19�ǉ�



//���v���Z�b�gID�ԍ��擾�p
CST_PRESET = 'PRE';
{2001.09.05 End}
//2001.09.07
//�����O�敪�擾�p
CST_NYUGAI = 'NYU';
//���v�����^�^�C�v
GPCST_PRI_TYPE_01 = '���[�U�[';         //���[�U�[
GPCST_PRI_TYPE_02 = '���x��';           //���x��
GPCST_PRI_TYPE_03 = '�h�b�g�C���p�N�g'; //�h�b�g�C���p�N�g
//2001.09.21
//���v�����^�^�C�v
GPCST_PRI_TYPE_NO_01 = '1';     //���[�U�[
GPCST_PRI_TYPE_NO_02 = '2';     //���x��
GPCST_PRI_TYPE_NO_03 = '3';     //�h�b�g�C���p�N�g
//2001.11.10
GPCST_SATUEISITU_KYUKYU = '�~�}'; //�B�e��=�~�}
//2002.09.20
//���F�֗v��
GPCST_COLOR_YOUHI_0 = '0';
GPCST_COLOR_YOUHI_1 = '1';
GPCST_COLOR_YOUHI_0_NAME = '�s�v';
GPCST_COLOR_YOUHI_1_NAME = '�K�v';
//2002.09.24
//�����E�g�p
GPCST_SAYUU_0 = '0';
GPCST_SAYUU_1 = '1';
GPCST_SAYUU_0_NAME = '���Ȃ�';
GPCST_SAYUU_1_NAME = '����';
//2002.09.24
//���ǉe�v��
GPCST_DOKUEI_0 = '0';
GPCST_DOKUEI_1 = '1';
GPCST_DOKUEI_2 = '2';
GPCST_DOKUEI_0_NAME = '�s�v';
GPCST_DOKUEI_1_NAME = '�K�v';
GPCST_DOKUEI_2_NAME = '�ً}';
//2002.09.24
//�����u���g�p
GPCST_SHOTI_0 = '0';
GPCST_SHOTI_1 = '1';
GPCST_SHOTI_0_NAME = '���Ȃ�';
GPCST_SHOTI_1_NAME = '����';
GPCST_SHOTI_0_RYAKU_NAME = '';
GPCST_SHOTI_1_RYAKU_NAME = '�g';
//2002.09.24
//���v���e
GPCST_YZOUEI_0 = '0';
GPCST_YZOUEI_1 = '1';
GPCST_YZOUEI_0_NAME = '';
GPCST_YZOUEI_1_NAME = '��';
//2002.09.24
//�������敪
GPCST_SYORI_1 = '01';
GPCST_SYORI_2 = '02';
GPCST_SYORI_3 = '03';
GPCST_SYORI_1_NAME = '�V�K';
GPCST_SYORI_2_NAME = '�X�V';
GPCST_SYORI_3_NAME = '�폜';
//2002.10.03
//�����Ȉ�t����敪
GPCST_ISITATIAI_0 = '0';
GPCST_ISITATIAI_1 = '1';
GPCST_ISITATIAI_0_NAME = '����Ȃ�';
GPCST_ISITATIAI_1_NAME = '�����';
GPCST_ISITATIAI_0_RyakuNAME = '���Ȃ�';
GPCST_ISITATIAI_1_RyakuNAME = '����';
GPCST_ISITATIAI_0_RYAKU = '';
GPCST_ISITATIAI_1_RYAKU = '�L';
//2002.10.03
//���f�W�^�C�Y�i��
GPCST_DEJITAI_0 = '0';
GPCST_DEJITAI_1 = '1';
GPCST_DEJITAI_0_NAME = '��';
GPCST_DEJITAI_1_NAME = '��';
//�������i��
GPCST_KENZOU_0 = '0';
GPCST_KENZOU_1 = '1';
GPCST_KENZOU_2 = '2';
GPCST_KENZOU_0_NAME = '��';
GPCST_KENZOU_1_NAME = '��';
GPCST_KENZOU_2_NAME = '��';
//2002.10.05
//��FCR�A�g
GPCST_FCR_0 = '0';
GPCST_FCR_1 = '1';
GPCST_FCR_0_NAME = '���Ȃ�';
GPCST_FCR_1_NAME = '����';
//2002.10.05
//��MPPS�Ή�
GPCST_MPPS_0 = '0';
GPCST_MPPS_1 = '1';
GPCST_MPPS_0_NAME = '���Ȃ�';
GPCST_MPPS_1_NAME = '����';

GPCST_ERR_0 = '0';
GPCST_ERR_1 = '1';
GPCST_ERR_0_NAME = '���Ȃ�';
GPCST_ERR_1_NAME = '����';
//2002.10.05
//����Z�敪��
//GPCST_SHG_1_NAME = '��{';
GPCST_SHG_1_NAME = '���Z'; //2004.02.01 koba
GPCST_SHG_2_NAME = '���u';
//����v���M���
GPCST_KAIKEI_0 = '0';
GPCST_KAIKEI_1 = '1'  ;
GPCST_KAIKEI_0_NAME = '���Ȃ�';
GPCST_KAIKEI_1_NAME = '����'  ;

//���敪Ͻ�ID
GPCST_KBN_ID_SHOKEN   = '3';
GPCST_KBN_ID_KENSAKBN = '4';
GPCST_KBN_ID_3D = '16';
GPCST_KBN_ID_Cancel = '15';

//��RI�I�[�_�敪
GPCST_RI_ORDER_0 = '0';
GPCST_RI_ORDER_1 = '1'  ;
GPCST_RI_ORDER_2 = '2'  ;
GPCST_RI_ORDER_0_NAME = '�Ȃ�';
GPCST_RI_ORDER_1_NAME = '����'  ;
GPCST_RI_ORDER_2_NAME = '����'  ;
//�����ID����
GPCST_GAMEN_0 ='B1';   //��t�����ꗗ���ID
GPCST_GAMEN_1 ='E1';   //����Dr.�w�����ID
GPCST_GAMEN_2 ='D1';   //������t�ꗗ���ID
GPCST_GAMEN_3 ='G1';   //�B�e�Ɩ����ID
GPCST_GAMEN_4 ='H1';   //�����Ɩ��ꗗ���ID
GPCST_GAMEN_5 ='J1';   //Portable�Ɩ����ID
GPCST_GAMEN_6 ='K1';   //RI�Ɩ����ID
CPCST_GAMEN_7 ='N1';   //�t�B�����Ɩ����ID
GPCST_GAMEN_8 ='F1';   //�����Ɩ����ID
GPCST_GAMEN_9 ='X3';   //�����䒠�ꗗ���ID
GPCST_GAMEN_10='P1';   //���Ҏ��шꗗ���
//���I�[�_�w���R�����g
GPCST_ORDER_COMMENT_131 = '131';//������f�@����
GPCST_ORDER_COMMENT_132 = '132';//������f�@�L��
//��������
GPCST_MRSA_SECTION_KEY = 'NAMECARDPRINT';
GPCST_MRSA_CODE_KEY = 'MRSACODE';
GPCST_MRSA_NAME_KEY = 'MRSANAME';

CST_PATH_GRID_COLUMNS   : string = 'C:\ris\columns\';//��د�޶�ѻ��ޕۑ���
//��Web�p �w������@
{2004.03.09
GPCST_WED_KANJAID = 'patientid';
GPCST_WED_KENSADAY = 'date';
GPCST_WED_ORDERNO = 'accession';
GPCST_WED_MODALITY = 'modality';
2004.03.09}
//2004.03.09
GPCST_WED_KANJAID = 'ID';
GPCST_WED_KENSADAY = 'DATE';
//2004.03.29 GPCST_WED_ORDERNO = 'ODERNO';
GPCST_WED_ORDERNO = 'ORDERNO';
GPCST_WED_MODALITY = 'MODALITY';
//���˗���w�����~���
GPCST_FUTUUDOKUEI_CODE         = '101'; //���ʓǉe
GPCST_KINKYUUDOKUEI_CODE       = '102'; //�ً}�ǉe
GPCST_DOKUHOKA_CODE            = '111'; //�ƕ���
GPCST_KURUMAISU_CODE           = '112'; //�Ԉ֎q
GPCST_SUTORECCHA_CODE          = '113'; //�X�g���b�`���[
GPCST_BED_CODE                 = '114'; //�x�b�h
GPCST_NINSINNASI_CODE          = '121'; //�D�P�Ȃ�
GPCST_NINSINARI_CODE           = '122'; //�D�P�L��
GPCST_NINSINFUMEI_CODE         = '123'; //�S�g�s��
GPCST_KESASAGOSINSATUNASI_CODE = '131'; //������f�@�Ȃ�
GPCST_KENSAGOSANSATUARI_CODE   = '132'; //������f�@����
GPCST_CALLFUYOU_CODE           = '141'; //Call�s�v
GPCST_DRCALL_CODE              = '142'; //�B�e���S����Call
GPCST_BYOUSITU_CODE            = '201'; //�a��
GPCST_SHUJUTUSITU_CODE         = '202'; //��p��
GPCST_KAIFUKUSITU_CODE         = '203'; //�񕜎�
GPCST_KINKYUDORAISITU_CODE     = '204'; //�ً}�h���C��
GPCST_KINKYUWETOSITU_CODE      = '205'; //�ً}�E�F�b�g��
GPCST_GAIRAI_CODE              = '206'; //�O��
GPCST_JINKINOUSEIJOU_CODE      = '301'; //�t�@�\����
GPCST_JINKINOUIJOU_CODE        = '302'; //�t�@�\�ُ�
GPCST_JINKINOUFUMEI_CODE       = '303'; //�t�@�\�s��
GPCST_ZENSOKUNASI_CODE         = '311'; //�b���Ȃ�
GPCST_ZENSOKUARI_CODE          = '312'; //�b������
//2003.05.30
GPCST_ZENSOKUFUMEI_CODE        = '313'; //�b���s��
//2003.05.30 end
GPCST_YODONASI_CODE            = '321'; //���[�h�A�����M�[�Ȃ�
GPCST_YODOARI_CODE             = '322'; //���[�h�A�����M�[����
GPCST_YODOFUMEI_CODE           = '323'; //���[�h�A�����M�[�s��
GPCST_TAINAIKINZOKUNASI_CODE   = '341'; //�̓������Ȃ��m�F�ς�
GPCST_TAINAIKINZOKUARI_CODE    = '342'; //�̓���������
GPCST_PESUMEKAARI_CODE         = '343'; //�y�[�X���[�J�[����
GPCST_HEISHONASI_CODE          = '351'; //�����|�ǂȂ�
GPCST_HEISHOARI_CODE           = '352'; //�����|�ǂ���
GPCST_BUSUKOPANKA_CODE         = '361'; //�u�X�R�p����
GPCST_BUSUKOPANHI_CODE         = '362'; //�u�X�R�p����
GPCST_GURUKAGONKA_CODE         = '371'; //�u�X�ց[�O���J�S����
GPCST_GURUKAGONKIN_CODE        = '372'; //�u�X�ց[�O���J�S����
GPCST_OMUTUNASI_CODE           = '381'; //���ނ��Ȃ�
GPCST_OMUTUARI_CODE            = '382'; //���ނ�����
GPCST_JUNYUNASI_CODE           = '391'; //�����Ȃ�
GPCST_JUNYUCHU_CODE            = '392'; //������

//2002.11.18
//����񍀖ڕʃ}�X�^�敪/ID
CST_KMS = 'KMS';
CST_KMS_ID_1 = '1';
CST_KMS_ID_2 = '2';
CST_KMS_ID_5 = '5';   //�A�������F���ҏ��  2002.11.29
CST_KMS_ID_6 = '6';   //�A�������F���b�Z�[�W
CST_KMS_ID_7 = '7';   //�A�������F�Z�t�Ɩ�
CST_KMS_ID_8 = '8';   //�B�e���{�F�N��
CST_KMS_ID_9 = '9';   //�B�e���{�F�ǂ�����
CST_KMS_ID_10 = '10'; //Dr�w���F���e�L��
CST_KMS_ID_11 = '11'; //Dr�w���F�^�C�~���O
CST_KMS_ID_12 = '12'; //Dr�w���F�B���͈�
CST_KMS_ID_13 = '13'; //Dr�w���F����B�e
CST_KMS_ID_14 = '14'; //�����R�����g
CST_KMS_ID_17 = '17'; //�t�B��������
//2003.12.09
CST_KMS_ID_18 = '18'; //���l
CST_KMS_ID_19 = '19'; //���×p�@�V/�p
CST_KMS_ID_20 = '20'; //���×p�@�������
CST_KMS_ID_21 = '21'; //mAs
CST_KMS_ID_22 = '22'; //���ݐ�

//2002.11.19
//����񍀖ڕʃ}�X�^�敪
GPCST_SOUSIN_FLG_0 = '0';
GPCST_SOUSIN_FLG_1 = '1';
GPCST_SOUSIN_FLG_0_NAME = '��';
GPCST_SOUSIN_FLG_1_NAME = '��';

//2002.11.20
//���t��Format
CST_FORMATDATE_0='YYYYMMDD';
CST_FORMATDATE_1='YYYY/MM/DD';
CST_FORMATDATE_2='YYYY/MM/DD HH:NN';
CST_FORMATDATE_3='YYYY/MM/DD HH:MM:SS';
CST_FORMATDATE_4='HHMMSS';
CST_FORMATDATE_5='HH:MM:SS';

//2002.11.21
//�Ɩ��ڍ׉�����ݑ���
GPCST_BUTTON_0 = '0';  //�ۑ��̂�
GPCST_BUTTON_1 = '1';  //�����ۗ�
GPCST_BUTTON_2 = '2';  //���{
GPCST_BUTTON_3 = '3';  //�����I��
GPCST_BUTTON_4 = '4';  //���Z��

CST_ENG_TUKI_1='Jan';
CST_ENG_TUKI_2='Feb';
CST_ENG_TUKI_3='Mar';
CST_ENG_TUKI_4='Apr';
CST_ENG_TUKI_5='May';
CST_ENG_TUKI_6='Jun';
CST_ENG_TUKI_7='Jul';
CST_ENG_TUKI_8='Aug';
CST_ENG_TUKI_9='Sep';
CST_ENG_TUKI_10='Oct';
CST_ENG_TUKI_11='Nov';
CST_ENG_TUKI_12='Dec';

//MWM�p���M�A��M����
GPCST_JUSIN_MOJI = 'START';
GPCST_JUSIN_MOJI_LEN = 5;
GPCST_SOUSIN_MOJI_1 = 'OK';
GPCST_SOUSIN_MOJI_2 = 'NG';
GPCST_SOUSIN_MOJI_LEN = 2;
//�D��
GPCST_YUUSEN_0='0';
GPCST_YUUSEN_1='1';
GPCST_YUUSEN_2='2';
GPCST_YUUSEN_0_RYAKUNAME='';
GPCST_YUUSEN_1_RYAKUNAME='��';
GPCST_YUUSEN_2_RYAKUNAME='�D';

GPCST_INFKBN_FU='FU';   //��t
GPCST_INFKBN_FC='FC';   //��t�L�����Z�� {2002.12.17]
GPCST_INFKBN_FO='F0';   //���{
GPCST_INFKBN_F1='F1';   //���~           {2002.12.17]
GPCST_INFKBN_FY='FY';   //�\��           {2003.01.07]
GPCST_INFKBN_FH='FH';   //�ۗ�
GPCST_SYORIKBN_01='01'; //�V�K
GPCST_SYORIKBN_02='02'; //�X�V
GPCST_SYORIKBN_03='03'; //�폜
GPCST_JOUTAIKBN_3='3'; //���{
GPCST_JOUTAIKBN_7='7'; //���~

//�_�C���N�g����t���O
GPCST_DIRECT_FLG='1';

GPCST_FCR = 'FCR';
GPCST_FPD = 'FPD';

{2003.05.07 start}
GPCST_NEW_FEILD_NAME = 'MWMCARET_FLG';
GPCST_MWM_TYPE_FLG_0 = '0';
GPCST_MWM_TYPE_FLG_0_NAME = '�s�v';
GPCST_MWM_TYPE_FLG_1 = '1';
GPCST_MWM_TYPE_FLG_1_NAME = '�K�v';
{2003.05.07 end}

//2003.12.11
//�����@��}�X�^�\��Flg�p
GPCST_HYOJI_FLG_0 = '0';
GPCST_HYOJI_FLG_0_NAME = '���Ȃ�';
GPCST_HYOJI_FLG_1 = '1';
GPCST_HYOJI_FLG_1_NAME = '����';

//�`�[����t���O  2003.12.11
GPCST_DENPYO_INSATU_FLG_1 = '1';

//���ҏЉ�t���O  2003.12.11
GPCST_KANJA_SYOKAIFLG_0 = '0';
GPCST_KANJA_SYOKAIFLG_1 = '1';

//���Z�t���O 2003.12.12
GSPCST_SEISAN_FLG_0 = '0';
GSPCST_SEISAN_FLG_0_NAME = '�����Z';
GSPCST_SEISAN_FLG_1 = '1';
GSPCST_SEISAN_FLG_1_NAME = '���Z��';

//2003.10.13--------------------------------------------------------------------
GPCST_SATUEIJISSI_NAME = '�����B�e���{�ҁ���';
//2003.10.13--------------------------------------------------------------------
GSPCST_GYOUMU_KBN_1 = '1';
GSPCST_GYOUMU_KBN_1_NAME = '����';
GSPCST_GYOUMU_KBN_2 = '2';
GSPCST_GYOUMU_KBN_2_NAME = '����';
GSPCST_GYOUMU_KBN_3 = '3';
GSPCST_GYOUMU_KBN_3_NAME = '�[��';
GSPCST_GYOUMU_KBN_4 = '4';
GSPCST_GYOUMU_KBN_4_NAME = '�ً}';

GSPCST_PORTABLE_FLG_0 = '0';
GSPCST_PORTABLE_FLG_1 = '1';
GSPCST_PORTABLE_FLG_2 = '2';
GSPCST_PORTABLE_FLG_3 = '3'; //2004.04.21

//���ӏ��敪 2003.12.15
GPCST_DOUISHO_KBN_0 = '0';
GPCST_DOUISHO_KBN_0_NAME = '�Ȃ�';
GPCST_DOUISHO_KBN_1 = '1';
GPCST_DOUISHO_KBN_1_NAME = '����';

//��M�}�X�^�e�[�u��
//���F 2003.12.16
GPCST_JOUTAI_FLG_0 = '0';
GPCST_JOUTAI_FLG_0_NAME = '�\��';
GPCST_JOUTAI_FLG_1 = '1';
GPCST_JOUTAI_FLG_1_NAME = '�m�F�ς�';
GPCST_JOUTAI_FLG_3 = '3';
GPCST_JOUTAI_FLG_3_NAME = '�폜';
//�����敪 2003.12.16
GPCST_JUSHIN_SHORI_1 = '1';
GPCST_JUSHIN_SHORI_1_NAME = '�V�K';
GPCST_JUSHIN_SHORI_2 = '2';
GPCST_JUSHIN_SHORI_2_NAME = '�ύX';
GPCST_JUSHIN_SHORI_3 = '3';
GPCST_JUSHIN_SHORI_3_NAME = '�폜';
//�}�X�^�敪 2003.12.18
GPCST_JUSHIN_MASTERTYPE_1 =  '1';
GPCST_JUSHIN_MASTERTYPE_1_NAME  = '�B�e��Z';
GPCST_JUSHIN_MASTERTYPE_11 = '11';
GPCST_JUSHIN_MASTERTYPE_11_NAME = '����';
GPCST_JUSHIN_MASTERTYPE_12 = '12';
GPCST_JUSHIN_MASTERTYPE_12_NAME = '�w��';
GPCST_JUSHIN_MASTERTYPE_13 = '13';
GPCST_JUSHIN_MASTERTYPE_13_NAME = '���';
GPCST_JUSHIN_MASTERTYPE_14 = '14';
GPCST_JUSHIN_MASTERTYPE_14_NAME = '���';
GPCST_JUSHIN_MASTERTYPE_15 = '15';
GPCST_JUSHIN_MASTERTYPE_15_NAME = '̨��';
GPCST_JUSHIN_MASTERTYPE_16 = '16';
GPCST_JUSHIN_MASTERTYPE_16_NAME = '�B�e���@';
GPCST_JUSHIN_MASTERTYPE_17 = '17';
GPCST_JUSHIN_MASTERTYPE_17_NAME = '���Z';
GPCST_JUSHIN_MASTERTYPE_18 = '18';
GPCST_JUSHIN_MASTERTYPE_18_NAME = '���e��';
GPCST_JUSHIN_MASTERTYPE_C =  'C';
GPCST_JUSHIN_MASTERTYPE_C_NAME  = '�S���҃}�X�^';
//���ʖ����MF
GPCST_MISOUSIN_FLG_1 = '1'; //�����M
GPCST_MISOUSIN_FLG_1_NAME = '�����M'; //�����M
GPCST_MISOUSIN_FLG_N = '0';  //���M
GPCST_MISOUSIN_FLG_N_NAME = '���M';  //���M
//�`���[�W���g�pF
GPCST_CHARGE_FLG_1 = '1'; //���g�p
GPCST_CHARGE_FLG_1_NAME = '�s��'; //���g�p
GPCST_CHARGE_FLG_N = '0';  //�g�p
GPCST_CHARGE_FLG_N_NAME = '��'; //�g�p
//�o�敪
GPCST_HEIKEI_KBN_1 = '1';
GPCST_HEIKEI_KBN_1_NAME = '��';
GPCST_HEIKEI_KBN_0 = '0';
GPCST_HEIKEI_KBN_0_NAME = '�O';
//���o�K��
GPCST_GEKKEI_KBN_1 = '1';
GPCST_GEKKEI_KBN_1_NAME = '�s�K��';
GPCST_GEKKEI_KBN_0 = '0';
GPCST_GEKKEI_KBN_0_NAME = '�قڋK���I';
//���o�����[�K�v
GPCST_GEKKEI_FLG_0 = '0';
GPCST_GEKKEI_FLG_0_NAME = '�s�v';
GPCST_GEKKEI_FLG_1 = '1';
GPCST_GEKKEI_FLG_1_NAME = '�K�v';
//�|�[�^�u���t���O
GPCST_PORTABLE_FLG_0 = '0';
GPCST_PORTABLE_FLG_0_NAME = '�ʏ�';
GPCST_PORTABLE_FLG_1 = '1';
GPCST_PORTABLE_FLG_1_NAME = '�|�[�^�u��';
GPCST_PORTABLE_FLG_2 = '2';
GPCST_PORTABLE_FLG_2_NAME = '��p��';
GPCST_PORTABLE_FLG_3 = '3';           //2004.06.15
GPCST_PORTABLE_FLG_3_NAME = '���̑�'; //2004.06.15
//2003.12.25
//RI�I�[�_�ԍ��ϊ��ԍ��i���ˁE�����j
GPCST_RIORDER_NO_CHUSYA = '0';
GPCST_RIORDER_NO_KENSA  = '6';

//2004.01.22
//ReportRisTable�ݒ�t���O(WinMaster�p)
GPCST_REPORT_FLG_1 = '1';
GPCST_REPORT_FLG_1_NAME = '����';
GPCST_REPORT_FLG_0 = '0';
GPCST_REPORT_FLG_0_NAME = '�Ȃ�';

GPCST_MISIYOU_FLG_1 = '1';
GPCST_MISIYOU_FLG_1_NAME = '���g�p';
GPCST_MISIYOU_FLG_0 = '0';
GPCST_MISIYOU_FLG_0_NAME = '�g�p';

//RIS�I�[�_���M�L���[�쐬�ݒ�  2004.02.05
GPCST_RISORDERSOUSIN_FLG_0 = '0';
GPCST_RISORDERSOUSIN_FLG_0_NAME = '�Ȃ�';
GPCST_RISORDERSOUSIN_FLG_1 = '1';
GPCST_RISORDERSOUSIN_FLG_1_NAME = '�ʏ�'; //'����'; //2004.04.09
//2004.04.09
GPCST_RISORDERSOUSIN_FLG_2 = '2';
GPCST_RISORDERSOUSIN_FLG_2_NAME = 'HIS�Ȃ�Rep����';

//2004.03.25--
//�]���I�[�_�[�e�[�u��
//�m�FF
GPCST_TENSOU_KAKUNIN_FLG_0 = '0';
GPCST_TENSOU_KAKUNIN_FLG_0_NAME = '�\��';
GPCST_TENSOU_KAKUNIN_FLG_1 = '1';
GPCST_TENSOU_KAKUNIN_FLG_1_NAME = '�m�F�ς�';
GPCST_TENSOU_KAKUNIN_FLG_3 = '3';
GPCST_TENSOU_KAKUNIN_FLG_3_NAME = '�폜';
//�����
GPCST_TENSOU_INFKBN_F0 = 'F0';
GPCST_TENSOU_INFKBN_FU = 'FU';
GPCST_TENSOU_INFKBN_FC = 'FC';
GPCST_TENSOU_INFKBN_F1 = 'F1';
GPCST_TENSOU_INFKBN_F0_NAME = '���{���';
GPCST_TENSOU_INFKBN_FU_NAME = '������t';
GPCST_TENSOU_INFKBN_FC_NAME = '��t�L�����Z��';
GPCST_TENSOU_INFKBN_F1_NAME = '�������~';
GPCST_TENSOU_INFKBN_JISSHI_NAME = '���{���';
GPCST_TENSOU_INFKBN_UKETUKE_NAME = '��t���';
GPCST_TENSOU_INFKBN_KANJA_NAME = '���ҏ��v��';
GPCST_TENSOU_INFKBN_JUSHIN_NAME = '��M����ð���';   //2004.05.04
//��ԃ��b�Z�[�W
GPCST_TENSOU_JOUTAI_01 = '01';
GPCST_TENSOU_JOUTAI_02 = '02';
GPCST_TENSOU_JOUTAI_03 = '03';
GPCST_TENSOU_JOUTAI_04 = '04';
//2004.03.31
GPCST_TENSOU_JOUTAI_66 = '66';
GPCST_TENSOU_JOUTAI_77 = '77';
GPCST_TENSOU_JOUTAI_88 = '88';
GPCST_TENSOU_JOUTAI_99 = '99';
GPCST_TENSOU_JOUTAI_01_NAME = '����';
GPCST_TENSOU_JOUTAI_02_NAME = '�d���G���[';
GPCST_TENSOU_JOUTAI_03_NAME = '�ʐM�G���[';
GPCST_TENSOU_JOUTAI_04_NAME = '���[�U�m�F';
//2004.03.31
GPCST_TENSOU_JOUTAI_66_NAME = '���M�ϓd���G���[';
GPCST_TENSOU_JOUTAI_77_NAME = '���M�ϗ�O�G���[';
GPCST_TENSOU_JOUTAI_88_NAME = '�i���G���[';
GPCST_TENSOU_JOUTAI_99_NAME = '�����M��O�G���[';
//���M�t���O
GPCST_TENSOU_SOUSHINFLG_0 = '0';
GPCST_TENSOU_SOUSHINFLG_1 = '1';
GPCST_TENSOU_SOUSHINFLG_0_NAME = '��';
GPCST_TENSOU_SOUSHINFLG_1_NAME = '��';
//�o�^���
GPCST_TENSOU_SYORIKBN_01 = '01';
GPCST_TENSOU_SYORIKBN_02 = '02';
GPCST_TENSOU_SYORIKBN_03 = '03';
GPCST_TENSOU_SYORIKBN_01_NAME = '�V�K';
GPCST_TENSOU_SYORIKBN_02_NAME = '�X�V';
GPCST_TENSOU_SYORIKBN_03_NAME = '�폜';
//--2004.03.25
//���t�B���������[���
GPCST_FILMLABEL_1 = '1';     //
GPCST_FILMLABEL_2 = '2';     //
GPCST_FILMLABEL_3 = '3';     //

GPCST_FILMLABEL_1_NAME = '�ۗ��E������';     //
GPCST_FILMLABEL_2_NAME = '�����ς̂�';     //
GPCST_FILMLABEL_3_NAME = '�Ȃ�';     //

//2004.05.04--
//��M�I�[�_�e�[�u��
//�V�F�[�}�擾�t���O
GPCST_JUSHIN_SHEMA_0 ='0';
GPCST_JUSHIN_SHEMA_1 ='1';
GPCST_JUSHIN_SHEMA_2 ='2';
GPCST_JUSHIN_SHEMA_0_NAME ='�V�F�[�}���擾';
GPCST_JUSHIN_SHEMA_1_NAME ='�V�F�[�}�擾�ς�';
GPCST_JUSHIN_SHEMA_2_NAME ='���s';

//2004.05.05 ->
//�B�e�ꏊ�敪�i�a���}�X�^�j
GPCST_CODE_BYK_1 = '1';   //�{��
GPCST_CODE_BYK_2 = '2';   //�ʊ�
GPCST_CODE_BYK_3 = '3';   //�~��
//<-

type  //�ƍ��f�[�^�\����
  TTUKA_SHUGI = record
      KBN        : TStringList;      //�敪
      KBN_NAME   : TStringList;      //�敪����
      KBN_ID     : TStringList;      //�敪ID
      NAME       : TStringList;      //����
      ID         : TStringList;      //ID
      SUBNAME    : TStringList;      //��ދ敪����
      SUBID      : TStringList;      //��ދ敪ID
      IJISU      : TStringList;      //�㎖��
      IJITANI    : TStringList;      //�㎖�P��
      JISSAISU   : TStringList;      //���ې�
      JISSAITANI : TStringList;      //���ےP��
      SHORI_FLG  : TStringList;      //�����׸ށ@1�F�ǉ��@2�F�C���@3�F�폜
      DB_FLG     : TStringList;      //DB�׸ށ@
  end;

var
//�V�F�[�}�̈�
g_Shema_OrderNO: string;
g_Shema_KanjaID: string;
g_Shema_KanjaName: string;
g_Shema_Bui_File: array[0..9] of string;
g_Shema_Bui_Name:  array[0..9] of string;
g_Shema_Bui_Comment: array[0..9] of string;
g_Shema_DirM: array[0..9] of string;
g_Shema_DirS: array[0..9] of string;
g_Shema_File: array[0..9] of string;
g_Shema_Client_File: array[0..9] of string;
g_Shema_HTML_Original_File: string;
g_Shema_HTML_File: string;
//�摜�\���̈�
g_Gazou_HTML_File: string; //

//RIS�I�[�_���M�L���[�쐬�ݒ�  2004.02.05
g_RIS_Order_Sousin_Flg :String;    //0�F�]���I�[�_�ɃL���[�쐬�Ȃ� 1�F�]���I�[�_�ɃL���[�쐬


//�ϐ��錾-------------------------------------------------------------------
//var
//�֐��葱���錾-------------------------------------------------------------
//���@�\�i��O�L�j�FNameMS�̓���敪���R���{�ɐݒ�i�R���{�N���A����j
procedure proc_NameMSToComb(
   arg_Qry:TQuery;
   arg_KBN:string;
   arg_Comb: TComboBox
   );
//���@�\�i��O�L�j�FNameMS�̓���敪���R���{�ɐݒ�i�R���{�N���A���Ȃ��j
procedure proc_NameMSToComb1(
   arg_Qry:TQuery;
   arg_KBN:string;
   arg_Comb: TComboBox
   );
//���@�\�i��O�L�j�FListView�̓��e���쐬
procedure proc_ListViewToFile(
       arg_FName:string;      //�ۑ��t�@�C����
       arg_ListView:TListView //�Ώ�
       );
//���@�\�i��O�L�j�FStringGrid�̓��e��csv�ɕۑ�
procedure proc_StringGridToFile(
       arg_FName:string;          //�ۑ��t�@�C����
       arg_StringGrid:TStringGrid //�Ώ�
       );
//���@�\�i��O�L�j�FStringGrid�̓��e��csv�ɕۑ�
//                  ��\���J�����͕ۑ����Ȃ�
procedure proc_StringGridToFile2(
       arg_FName:string;          //�ۑ��t�@�C����
       arg_StringGrid:TStringGrid //�Ώ�
       );
//���@�\�i��O���j�FDate��Between����쐬
function func_DateBetween(
       arg_FName:string;   //���ږ�
       arg_Date1:TDate;    //����
       arg_Date2:TDate     //�I��
       ):string;
//���@�\�i��O�L�j�FKANRI�e�[�u���̌����S�폜
function func_DelKAnri(
       arg_DB:TDatabase;         //�ڑ����ꂽDB
       arg_TanName:string       //PC����
       ):boolean;                //����True���� False���s
//���@�\�i��O�L�j�FKANRI�e�[�u���̌����Ԋ�
function func_ReleasKAnri(
       arg_DB:TDatabase;         //�ڑ����ꂽDB
       arg_TanName:string;       //PC����
       arg_ProgId:string;        //�v���O����ID
       arg_RisId:string;         //RIS����ID
       arg_SyoriMode:string      //�ԊҌ����� G_KANRI_TBL_RMODE �Q�ƌ���
                                 //           G_KANRI_TBL_WMODE �X�V����

       ):boolean;                //����True���� False���s
//���@�\�i��O�L�j�FKANRI�e�[�u���̎Q�ƌ����擾
function func_GetRKAnri(
       arg_DB:TDatabase;         //�ڑ����ꂽDB
       arg_TanName:string;       //PC����
       arg_ProgId:string;        //�v���O����ID
       arg_RisId:string          //RIS����ID
       ):boolean;                //����True���� False���s
//���@�\�i��O�L�j�FKANRI�e�[�u���̍X�V�����擾
function func_GetWKAnri(
       arg_DB:TDatabase;         //�ڑ����ꂽDB
       arg_TanName:string;       //PC����
       arg_ProgId:string;        //�v���O����ID
       arg_RisId:string          //RIS����ID
       ):boolean;                //����True���� False���s

//2002.11.28
//���@�\�i��O�L�j�FKANRI�e�[�u���̍X�V�����擾
function func_GetWKAnriUketuke(
       arg_DB:TDatabase;         //�ڑ����ꂽDB
       arg_TanName:string;       //PC����
       arg_ProgId:string;        //�v���O����ID
       arg_RisId:string          //RIS����ID
       ):boolean;                //����True���� False���s
//���@�\�i��O�L�j�FUSERMS��User_name���m�F
function func_ChkUserName(
       arg_DB:TDatabase;
       arg_UserName:string
       ):boolean;
//���@�\�i��O�L�j�FUSERMS��User_name��PASSWORD���m�F
function func_ChkUserPass(
       arg_DB:TDatabase;
       arg_UserName:string;
       arg_Password:string
       ):boolean;
//���@�\�i��O�L�j�FUSERMS��User_name��class���m�F
function func_ChkUserClass(
       arg_DB:TDatabase;         //�ڑ����ꂽDB
       arg_UserName:string;      //���[�U��
       arg_Class:string          //�N���X
       ):boolean;
//���@�\�i��O�L�j�FSQL�̌��ʂ̃��R�[�h����Ԃ�
function func_SqlCount(
       arg_DB:TDatabase;
       arg_Sql:Tstrings):Integer;
//���@�\�i��O�L�j�FSQL�̎��s���ʂ�Ԃ�
function func_SqlExec(
       arg_DB:TDatabase;          //�ڑ����ꂽDB
       arg_Sql:Tstrings):boolean; //�L����SQL
//���@�\�i��O���j�F���ނ𖼑O�ɕϊ��o�^ ��Z�敪
function func_PIND_Change_SYUGI(
       arg_Code:string    //����
       ):string;          //����
//���@�\�i��O���j�F���ނ𖼑O�ɕϊ��o�^ ���e�܋敪
function func_PIND_Change_ZOUEI(
       arg_Code:string    //����
       ):string;          //����
//���@�\�i��O���j�F���ނ𖼑O�ɕϊ��o�^ �B�e�i��  SATUEI
function func_PIND_Change_SATUEI(
       arg_Code:string    //����
       ):string;          //����
//���@�\�i��O���j�F���ނ𖼑O�ɕϊ��o�^ ���ԊO�敪
function func_PIND_Change_JIKAN(
       arg_Code:string    //����
       ):string;          //����
//���@�\�i��O���j�F���ނ𖼑O�ɕϊ��o�^ RI���{�t���O
function func_PIND_Change_RI(
       arg_Code:string    //����
       ):string;          //����
//���@�\�i��O���j�F���ނ𖼑O�ɕϊ��o�^ �����˗��t���O
function func_PIND_Change_SYOKEN(
       arg_Code:string    //����
       ):string;          //����
//���@�\�i��O���j�F���ނ𖼑O�ɕϊ��o�^ �����i��  KENSIN
function func_PIND_Change_KENSIN(
       arg_Code:string;    //����
       arg_SubCode:string    //����
       ):string;          //����
//���@�\�i��O���j�F���ނ𗪖��O�ɕϊ��o�^ �����i��  KENSIN
function func_PIND_Change_KENSIN_Ryaku(
       arg_Code:string    //����
       ):string;          //����
//���@�\�i��O���j�F���ނ𖼑O�ɕϊ��o�^�V�X�e���敪
function func_PIND_Change_SYSK(
       arg_Code:string    //����
       ):string;          //����

//���@�\�i��O���j�F���ނ𖼑O�ɕϊ� ��
function func_PIND_Change_Sex(
       arg_Code:string    //����
       ):string;          //����
//���@�\�i��O���j�F���ނ𖼑O�ɕϊ� ���O�敪
function func_PIND_Change_Nyugai(
       arg_Code:string    //����
       ):string;          //����

//���@�\�i��O���j�F���[�N���X�g�\��e�[�u���p�L�[���ڕҏW
function func_WorklistInfo_Key_Make(
         //IN
         arg_KanjaID: string;
         arg_OrderNO: string;
         //OUT
         var arg_Rcv_ACCESSION_NUMBER: string;
         var arg_Rcv_PATIENT_ID: string
        ): Boolean;
//���@�\�i��O���j�F���[�N���X�g�\��e�[�u���p�S���ڕҏW
function func_WorklistInfo_Make(
         //IN
         arg_Query: TQuery;
         arg_Group_No: string;
         arg_SysDate: string;
         arg_SysTime: string;
         arg_KanjaID: string;
         arg_OrderNO: string;
         arg_SimeiKana: string;
         arg_SimeiKanji: string;
         arg_Sex: string;
         arg_BirthDay: string;
         arg_Start_Date: string;
         arg_Start_Time: string;
         arg_Irai_Doctor_Name: string;
         arg_Irai_Section_Name: string;
         arg_Irai_Section_Kana: string;
         arg_KensaKikiName: string;
         arg_Modality_Type: string;
         arg_KensaComment1: string;
         arg_SUID: string;
         //OUT
         var arg_Rcv_SCH_STATION_AE_TITLE: string;
         var arg_Rcv_SCH_PROC_STEP_LOCATION: string;
         var arg_Rcv_SCH_PROC_STEP_START_DATE: string;
         var arg_Rcv_SCH_PROC_STEP_START_TIME: string;
         var arg_Rcv_SCH_PERF_PHYSICIANS_NAME_ROMA: string;
         var arg_Rcv_SCH_PERF_PHYSICIANS_NAME_KANJI: string;
         var arg_Rcv_SCH_PERF_PHYSICIANS_NAME_KANA: string;
         var arg_Rcv_SCH_PROC_STEP_DESCRIPTION: string;
         var arg_Rcv_SCH_PROC_STEP_ID: string;
         var arg_Rcv_COMMENTS_ON_THE_SCH_PROC_STEP: string;
         var arg_Rcv_MODALITY: string;
         var arg_Rcv_REQ_PROC_ID: string;
         var arg_Rcv_STUDY_INSTANCE_UID: string;
         var arg_Rcv_REQ_PROC_DESCRIPTION: string;
         var arg_Rcv_REQUESTING_PHYSICIAN: string;
         var arg_Rcv_REQUESTING_SERVICE: string;
         var arg_Rcv_ACCESSION_NUMBER: string;
         var arg_Rcv_INSTITUTION: string;
         var arg_Rcv_INSTITUTION_ADDRESS: string;
         var arg_Rcv_PATIENT_NAME_ROMA: string;
         var arg_Rcv_PATIENT_NAME_KANJI: string;
         var arg_Rcv_PATIENT_NAME_KANA: string;
         var arg_Rcv_PATIENT_ID: string;
         var arg_Rcv_PATIENT_BIRTH_DATE: string;
         var arg_Rcv_PATIENT_SEX: string;
         var arg_Rcv_PATIENT_WEIGHT: string
        ): Boolean;
//���@�\�i��O���j�F�J�^�J�i�����[�}���ϊ�
function func_Kana_To_Roma(
         arg_Kana: string
         ): string;
//�����g�p���@�\�i��O�L�j�F���ݔԍ�+1�擾
function func_Get_NumberControl(
         arg_Database:TDatabase;
         arg_Query:TQuery;
         arg_Kubun:string;
         arg_Date:string
         ):integer;
//�����g�p���@�\�i��O�L�j�F���ݔԍ��X�V
function func_NumberControl_Update(
         arg_Database:TDatabase;
         arg_Query:TQuery;
         arg_Mode:integer;
         arg_Kubun:string;
         arg_UpdateDate:string;
         arg_Now_NO:integer
         ):Boolean;
//���@�\�i��O���j�F���ނ𖼑O�ɕϊ� ��v���
function func_PIND_Change_KAIKEI(arg_Code:string):string;
//���@�\�i��O���j�F���ނ𖼑O�ɕϊ� �A��w��
function func_PIND_Change_KITAKU(arg_Code:string):string;
//���@�\�i��O���j�F���ނ𖼑O�ɕϊ��o�^ �a�@�A��TEL
function func_PIND_Change_TEL(arg_Code:string):string;
//���@�\�i��O���j�F���ނ𖼑O�ɕϊ��o�^ �����v��
function func_PIND_Change_SYOKEN_YOUHI(arg_Code:string):string;//����
//���@�\�i��O���j�F���ނ𖼑O�ɕϊ��o�^ �B�e�i��
function func_PIND_Change_SATUEISTATUS(arg_Code:string):string;//����
//���@�\�i��O���j�F���ނ𖼑O�ɕϊ��o�^ �摜�m�F
function func_PIND_Change_GAZOU_KAKUNIN(arg_Code:string):string;//����

//���@�\�i��O���j�F���ނ𖼑O�ɕϊ� �A��w��
function func_PIND_Change_KITAKU_G(arg_Code:string):string;
//���@�\�i��O���j�F���ނ𖼑O�ɕϊ��o�^ �a�@�A��TEL
function func_PIND_Change_TEL_G(arg_Code:string):string;
//���@�\�i��O���j�F���ނ𖼑O�ɕϊ��o�^ �摜�m�F
function func_PIND_Change_GAZOU_KAKUNIN_G(arg_Code:string):string;//����

//���@�\�i��O���j�F���ނ𖼑O�ɕϊ��o�^ �F�֗v��
function func_PIND_Change_COLOR_YOUHI(arg_Code:string):string;//����
//���@�\�i��O���j�F���ނ𖼑O�ɕϊ��o�^ ���E�g�p
function func_PIND_Change_SAYUU(arg_Code:string):string;//����
//���@�\�i��O���j�F���ނ𖼑O�ɕϊ��o�^ �ǉe�v��
function func_PIND_Change_DOKUEI(arg_Code:string):string;//����
//���@�\�i��O���j�F���ނ𖼑O�ɕϊ��o�^ ���u���g�p
function func_PIND_Change_SHOTI(arg_Code:string):string;//����
//���@�\�i��O���j�F���ނ𖼑O�ɕϊ��o�^ ���u���g�p�E����
function func_PIND_Change_SHOTI_RYAKU(arg_Code:string):string;//����
//���@�\�i��O���j�F���ނ𖼑O�ɕϊ��o�^ �v���e
function func_PIND_Change_YZOUEI(arg_Code:string):string;//����
//���@�\�i��O���j�F���ނ𖼑O�ɕϊ��o�^ ���Ȉ�t����
function func_PIND_Change_ISITATIAI(arg_Code:string):string;//����
//���@�\�i��O���j�F���ނ𖼑O�ɕϊ��o�^ ���Ȉ�t����E����
function func_PIND_Change_ISITATIAI_RYAKU(arg_Code:string):string;//����
//���@�\�i��O���j�F���ނ𖼑O�ɕϊ��o�^ FCR�A�g
function func_PIND_Change_FCR(arg_Code:string):string;//����
//���@�\�i��O���j�F���ނ𖼑O�ɕϊ��o�^ MPPS�Ή�
function func_PIND_Change_MPPS(arg_Code:string):string;//����
//���@�\�i��O���j�F���ނ𖼑O�ɕϊ��o�^ �G���[���
function func_PIND_Change_Err(arg_Code:string):string;//����
//���@�\�i��O���j�F���ނ𖼑O�ɕϊ��o�^ ��v���M���
function func_PIND_Change_KAIKEISOUSIN(arg_Code:string):string;//����
//���@�\�i��O���j�F���ނ𖼑O�ɕϊ��o�^ RI�I�[�_�敪
function func_PIND_Change_RI_ORDER(arg_Code:string):string;//����

//���@�\�i��O���j�F�v�����^�^�C�v�擾
function func_Get_PrintType(arg_Type:String):String;
//���@�\�i��O���j�F�S������̑S�p�`�F�b�N
function func_ALL_ZENKAKU_CHECK(arg_text: string):Boolean;
//���@�\�i��O���j�F�S������̔��p�`�F�b�N
function func_ALL_HANKAKU_CHECK(arg_text: string):Boolean;
//2002.11.18
//���@�\�i��O���j�F�S������̔��p�`�F�b�N
function func_ALL_HANKAKU_AISUU_CHECK(arg_text: string):Boolean;
//2002.10.02 �ǉ�
//���@�\�i��O���j�F�O���b�h�J����������������
function func_Grid_ColumnSize_Write(arg_Grid: TStringGrid; arg_Name,arg_No: string):Boolean;
//���@�\�i��O���j�F�O���b�h�J��������ǂݍ���
procedure proc_Grid_ColumnSize_Read(arg_Grid: TStringGrid; arg_Name,arg_No: string; var arg_Column: TStringList);
//���@�\�i��O���j�F�O���b�h�J���������Z�b�g����
procedure proc_Grid_ColumnSize_Set(arg_Grid: TStringGrid; arg_Name,arg_No: string);
//2002.10.21 �ǉ�
//2002.10.23 �C�� �����R�����g���ږ����i�[
//���@�\�i��O���j�F������ʖ��̃t�B���^�t���O���ږ��̊i�[�ϐ��Z�b�g
function func_SetKensaTypeFilter_Flg(arg_Query: TQuery):Boolean;
//���@�\�i��O���j�F�������ID�Ńt�B���^�t���O���ږ���Ԃ�
function func_GetFilter_Flg_Name(arg_KensaType_ID: String):String;
//2002.10.23 �ǉ�
//���@�\�i��O���j�F�������ID�Ō����R�����g���ږ���Ԃ�
function func_GetKensa_Comment_Name(arg_KensaType_ID: String):String;
//2004.04.09--
//���@�\�i��O���j�FRIS�I�[�_���̓]���I�[�_�A�]��Report�e�[�u���ւ̃L���[�쐬����
//�@�ڍׁ@�_�~�[���Ҕ���A�I�[�_�쐬���̃��|�[�g���M�L���[�쐬����ARIS�I�[�_����HIS�AReport���M����
//�@���ӎ����@�֐��g�p�O��proc_SetOrderSoushin�֐������s����Ă��鎖���O��
function func_Check_CueAndDummy(arg_SysKbn:String;arg_KanjaID:String;arg_Mode:integer):Boolean;
//���@�\�i��O���j�FRIS�I�[�_���M�t���O�Z�b�g
procedure proc_SetOrderSoushin;
//--2004.04.09
//���@�\�i��O���j�F �_�~�[���Ҕ��� 2004.08.06
function func_Check_DummyKanja(arg_KanjaID:string  //����ID
                               ):Boolean;

function GetWeekInfo(Day:String;Week,SName:TPanel):Boolean;
var
  //2002.10.21 ������ʖ��̃t�B���^�t���O���ږ��̊i�[�ϐ��錾
  ga_KENSA_TYPE_FEILD: array of TKensaType_Field;
  gi_KENSA_TYPE_FIELD_COUNT: Integer;
  g_TuikaShugi_info:TTUKA_SHUGI;
//2002.10.22
//���@�\�i��O���j�F����ID��芳�ҏ��擾
function func_KanjaInfo_Make(
         //IN
         arg_Query: TQuery;
         arg_Query2: TQuery;
         arg_KanjaID: string;
         //OUT
         var arg_SimeiKanji: string;      //��������
         var arg_SimeiKana: string;       //�J�i����
         var arg_Sex: string;             //����
         var arg_BirthDay: string;        //���N����
         var arg_Age: string;             //�N��
         var arg_Byoutou_ID: string;      //�a��ID
         var arg_Byoutou: string;         //�a������
         var arg_Byousitu_ID: string;     //�a��ID
         var arg_Byousitu: string;        //�a������
         var arg_Kanja_Nyugaikbn: string; //���ғ��O�敪
         var arg_Kanja_Nyugai: string;    //���ғ��O�敪����
         var arg_Section_ID: string;      //�f�É�ID
         var arg_Section: string;         //�f�É�
         var arg_Sincyo: string;          //�g��
         var arg_Taijyu: string           //�̏d
        ): Boolean;
//���@�\�i��O���j�FRIS����ID��芳�ҏ��擾
function func_KanjaOrderInfo_Make(
         //IN
         arg_Query: TQuery;
         arg_Query2: TQuery;
         arg_RIS_ID: string;
         //OUT
         var arg_KanjaID: string;               //����ID
         var arg_SimeiKanji: string;            //��������
         var arg_SimeiRoma: string;             //�p������
         var arg_Sex: string;                   //����
         var arg_BirthDay: string;              //���N����
         var arg_Age: string;                   //�N��
         var arg_Byoutou_ID: string;            //�a��ID
         var arg_Byoutou: string;               //�a������
         var arg_Byousitu_ID: string;           //�a��ID
         var arg_Byousitu: string;              //�a������
         var arg_Kanja_Nyugaikbn: string;       //���ғ��O�敪
         var arg_Kanja_Nyugai_Name: string;     //���ғ��O�敪����
         var arg_Section_ID: string;            //�f�É�ID
         var arg_Section: string;               //�f�É�
         var arg_Sincyo: string;                //�g��
         var arg_Taijyu: string;                //�̏d
         var arg_Irai_Name: string;             //�˗��Ȗ���
         var arg_Irai_SectionID: string;        //�˗���ID
         var arg_Denpyo_NyugaiKbn: string;      //�`�[���O�敪(�`�[�a��)
         var arg_Denpyo_NyugaiName: string;     //�`�[���O�敪����(�`�[�a��)
         var arg_Denpyo_ByoutouID: string;      //�`�[�a��ID
         var arg_IraiDoctor: string;            //�˗���t��
         var arg_Section_Tel1: string;          //�˗��ȘA����(��S��)
         var arg_Section_Tel2: string           //�˗��ȘA����(��S���ȍ~)
        ): Boolean;

//�e�L�X�g�p���O�쐬
procedure proc_Append_Log(arg_DispID:String;      //���ID
                          arg_Disp_Name:String;    //��ʖ���
                          arg_Msg:String;          //��������
                          arg_str,arg_str2:String);//�\��1.2

//���@�\�i��O���j�F�V�F�[�}�i�[�t�@�C�����쐬
function func_Make_ShemaName(arg_OrderNO,               //�I�[�_NO
                             arg_MotoFileName: string;  //HIS���ϖ�
                             arg_Index: integer         //����NO
                             ):string;                  //�i�[̧�ٖ�

//2002.12.06 �\�t�B�X�P�[�g�ǉ��@��
//���@�\�i��O���j�F�i���t���O�ɂ���t�ԍ��\���E��\���l��Ԃ�
function func_GetUke_No(arg_Main,arg_Sub: String):Bool;
//���@�\�i��O���j�F�i���t���O�ɂ��F�̃L�[�R�[�h��Ԃ�
function func_GetColor_Key(arg_Main,arg_Sub: String):String;
//���@�\�i��O���j�F�D��t���O�ɂ��D�於��Ԃ�
function func_GetYuusen_Name(arg_Yuusen: String):String;
//���@�\�i��O���j�F�޼����ދ敪�ɂ���޼����ޖ���Ԃ�
function func_GetDejitaizu_Name(arg_Dejitaizu: String):String;
//���@�\�i��O���j�FWAVE�t�@�C����Dir��Ԃ�
function func_GetWav_Name:String;  //2002.12.08
//2002.12.06 �\�t�B�X�P�[�g�ǉ��@��


//2002.10.22

//���@�\�i��O���j�F�����ϊ�
function func_Moji_Henkan(arg_Moji: string;
                          arg_Flg: Integer  //1:�S�p�����p�A2:���p���S�p�A3:�S�p�Ђ炪�ȁ����p�J�^�J�i
                          ): string;
//�����������擾 �߂�l�F������ʗ��� �i������ EX. X�� C��
function func_Make_Takensa(arg_RIS_ID, arg_KanjaID,
     arg_Date: String): String;
//�����������擾 �߂�l�F�������t���O ������ʗ��� �i������ EX. X�� C��   2003.10.07
function func_Make_Takensa2(arg_RIS_ID,arg_KanjaID,arg_Date,
                            arg_Main,arg_Sub:String;
                            var arg_v_takenchuu:String):String;

//���C���A�T�u�X�e�[�^�X����i�����̎擾
function func_Stetas_Info_Ryaku(arg_Main_Sts,
      arg_Sub_Sts: String): String;


//���@�\�i��O���j�F������ʖ��̃l�[���J�[�h�̒��[No���擾
function func_Get_NameCard_ID_No(arg_KensaTypeID:string): string;

//���@�\�i��O���j�F��t�[���������ʖ��̉ۂ̂��擾
function func_Get_UketukePrint_No(arg_KensaTypeID:string): Boolean;

//���@�\�i��O���j�F���[���̃_�C���N�g����t���O�̎擾�擾
function func_Get_DirectFlg(
                    arg_Query: TQuery;
                    arg_CyohyouNo: string):string;

//���@�\�i��O���j�F�[�����ɃC�j�V�����ݒ肳�ꂽ��ʂ���e�Ɩ����L���Ȏ�ʂ݂̂����o��
function func_Check_Initiali_Kensa(
                 arg_PrgId: string;
                 arg_Initiali_Kensa: string): string;

//���@�\�i��O���j�F�[�����ɃC�j�V�����ݒ肳�ꂽ���{���u�����ʂɕR�t���L���Ȏ��{���u�݂̂����o��
function func_Check_Initiali_Souti(
                 arg_PrgId: string;
                 arg_Query: TQuery;
                 arg_Initiali_Kensa: string;
                 arg_Initiali_Souti: string): string;

//2003.10.06 Start**************************************************************
//���@�\�i��O���j�F�O���b�h�J����������������(Gkit)
function func_Gkit_ColumnSize_Write(arg_GGrid: TGKitSpreadControl; arg_Name,arg_No: string):Boolean;
//���@�\�i��O���j�F�O���b�h�J��������ǂݍ���(Gkit)
procedure proc_Gkit_ColumnSize_Read(arg_GGrid: TGKitSpreadControl; arg_Name,arg_No: string; var arg_Column: string);
//���@�\�i��O���j�F�O���b�h�J���������Z�b�g����(Gkit)
procedure proc_Gkit_ColumnSize_Set(arg_GGrid: TGKitSpreadControl; arg_Name,arg_No: string);
//2003.10.06 end****************************************************************

//���@�\�i��O���j�F�`�[����t���O�̍X�V
function func_Update_Denpyo_Insatu_flg(arg_DB:TDatabase          //�ް��ް�
                                       ;arg_Key_RIS_ID:string     //RIS_ID (�����J���}��؂�)
                                       ;var arg_Err:string
                                       ): Boolean;
//���@�\�i��O���j�F�`�[����t���O�̍X�V(�j��w)
function func_Update_Denpyo_Insatu_flg_RI(arg_DB:TDatabase          //�ް��ް�
                                       ;arg_Key_RIS_ID:string     //RIS_ID (�����J���}��؂�)
                                       ;var arg_Err:string
                                       ): Boolean;

//2004.01.13
//���@�\�F���ݎ��������ɋƖ��敪��Ԃ�
function func_GyoumuKbn_Check(arg_KensaType:string;arg_Query:TQuery):string;

//�����у��C����RIS���ʔԍ��ő�l���X�V 2004.03.29
// �g�����U�N�V�������J�n����Ă��鎖���O��
// �K�����{�����Ŏ��у��C���A���ѕ��ʍX�V��ɂ��̊֐����Ăяo��
// ���у��C���A���ѕ��ʂƓ����^�C�~���O�ŃR�~�b�g�i�����g�����U�N�V���������j
function func_Up_ExRis_Bui_No_Max(arg_RisID:string; //RIS����ID
                              arg_Query:TQuery      //Query
                              ):Boolean;

//�����у��C����RIS���ʔԍ��ő�l���X�V�i�I�[�_�쐬���j 2004.03.30
// ����̎��ѕ��ʂ�RIS���ʔԍ��ő�l�ōX�V
function func_Up_Pre_ExRis_Bui_No_Max(arg_RisID:string; //RIS����ID
                                      arg_Query:TQuery      //Query
                                      ):Boolean;
                              
implementation

uses DB; //**************************************************************

//�g�p���j�b�g---------------------------------------------------------------
//uses

//�萔�錾       -------------------------------------------------------------
const
//�e�[�u�����
CST_TBL_KANRI      = 'KanriTable';//�Ǘ��e�[�u����
CST_TBLIN_TAN_NAME = 'tan_name';  //�Ǘ��e�[�u�����ږ� �[����
CST_TBLIN_PRODID   = 'prog_id';   //�Ǘ��e�[�u�����ږ� �v���O����ID
CST_TBLIN_RISID    = 'ris_id';    //�Ǘ��e�[�u�����ږ� RIS����ID
CST_TBLIN_SYORIMODE= 'syori_mode';//�Ǘ��e�[�u�����ږ� ���[�h


//�f�B���N�g�����i���g�p�j
//CST_COREP_DIR_NAME='co_rep\';
//CST_DUMMYIMAGE_DIR_NAME='Image\';
//CST_COREPORT_DIR_NAME='co_reptemp\';
//CST_OPENDEF_DIR_NAME='';
//CST_SAVEDEF_DIR_NAME='';
//CST_MRDRAW_EXEPATH='MRDraw\';
//CST_MRDRAW_INIPATH='MRDraw\';
//CST_MRDRAW_TEMPPATH='drawtemp\';
//CST_MRDRAW_SAVEPATH='drawsave\';
//CST_PPUP_EXEPATH='PlanID\';

//2004.01.13
//�Ɩ��敪�����ݒ�
//�Փ�
CST_GYOKBN_SAI_2_S='08:30:00';     //����Start
CST_GYOKBN_SAI_2_E='23:59:59';     //����End
CST_GYOKBN_SAI_3_S='00:00:00';     //�[��Start
CST_GYOKBN_SAI_3_E='08:29:59';     //�[��End
//���j
CST_GYOKBN_SUN_2_S='08:30:00';     //����Start
CST_GYOKBN_SUN_2_E='23:59:59';     //����End
CST_GYOKBN_SUN_3_S='00:00:00';     //�[��Start
CST_GYOKBN_SUN_3_E='08:29:59';     //�[��End
//�y�j�i��P,��R�j
CST_GYOKBN_SAT_13_2_S='08:30:00';  //����Start
CST_GYOKBN_SAT_13_2_E='23:59:59';  //����End
CST_GYOKBN_SAT_13_3_S='00:00:00';  //�[��Start
CST_GYOKBN_SAT_13_3_E='08:29:59';  //�[��End
//�y�j�i��Q,��S,��T�j
CST_GYOKBN_SAT_245_1_S='08:30:00'; //����Start
CST_GYOKBN_SAT_245_1_E='13:30:59'; //����End
CST_GYOKBN_SAT_245_2_S='13:31:00'; //����Start
CST_GYOKBN_SAT_245_2_E='23:59:59'; //����End
CST_GYOKBN_SAT_245_3_S='00:00:00'; //�[��Start
CST_GYOKBN_SAT_245_3_E='08:29:59'; //�[��End
//����
CST_GYOKBN_NOR_1_S='08:30:00';     //����Start
CST_GYOKBN_NOR_1_E='17:00:59';     //����End
CST_GYOKBN_NOR_2_S='17:01:00';     //����Start
CST_GYOKBN_NOR_2_E='23:59:59';     //����End
CST_GYOKBN_NOR_3_S='00:00:00';     //�[��Start
CST_GYOKBN_NOR_3_E='08:29:59';     //�[��End

//�ϐ��錾     ---------------------------------------------------------------
//var
//�֐��葱���錾--------------------------------------------------------------
//�g�p�\�֐��|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|


//���̃R�[�h�ϊ������|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|

//���@�\�i��O���j�F���ނ𖼑O�ɕϊ��o�^ ��Z�敪
function func_PIND_Change_SYUGI(
       arg_Code:string    //����
       ):string;          //����
var
   w_Res:string;
begin
  IF arg_Code=GPCST_CODE_SYUGI_0 THEN w_Res:= GPCST_NAME_SYUGI_0
  ELSE
  IF arg_Code=GPCST_CODE_SYUGI_1 THEN w_Res:= GPCST_NAME_SYUGI_1
  ELSE
  IF arg_Code=GPCST_CODE_SYUGI_2 THEN w_Res:= GPCST_NAME_SYUGI_2
{  ELSE
  IF arg_Code=GPCST_CODE_SYUGI_3 THEN w_Res:= GPCST_NAME_SYUGI_3}
  ELSE
  IF arg_Code=GPCST_NAME_SYUGI_0 THEN w_Res:= GPCST_CODE_SYUGI_0
  ELSE
  IF arg_Code=GPCST_NAME_SYUGI_1 THEN w_Res:= GPCST_CODE_SYUGI_1
  ELSE
  IF arg_Code=GPCST_NAME_SYUGI_2 THEN w_Res:= GPCST_CODE_SYUGI_2
//  ELSE
//  IF arg_Code=GPCST_NAME_SYUGI_3 THEN w_Res:= GPCST_CODE_SYUGI_3
  ELSE w_Res:= '';
  result:=w_Res;
end;
//���@�\�i��O���j�F���ނ𖼑O�ɕϊ��o�^ ���e�܋敪
function func_PIND_Change_ZOUEI(
       arg_Code:string    //����
       ):string;          //����
var
   w_Res:string;
begin
  IF arg_Code=GPCST_CODE_ZOUEI_0 THEN w_Res:= GPCST_NAME_ZOUEI_0
  ELSE
  IF arg_Code=GPCST_CODE_ZOUEI_1 THEN w_Res:= GPCST_NAME_ZOUEI_1
  ELSE
  IF arg_Code=GPCST_CODE_ZOUEI_2 THEN w_Res:= GPCST_NAME_ZOUEI_2
  ELSE
  IF arg_Code=GPCST_CODE_ZOUEI_3 THEN w_Res:= GPCST_NAME_ZOUEI_3
  ELSE
  IF arg_Code=GPCST_NAME_ZOUEI_0 THEN w_Res:= GPCST_CODE_ZOUEI_0
  ELSE
  IF arg_Code=GPCST_NAME_ZOUEI_1 THEN w_Res:= GPCST_CODE_ZOUEI_1
  ELSE
  IF arg_Code=GPCST_NAME_ZOUEI_2 THEN w_Res:= GPCST_CODE_ZOUEI_2
  ELSE
  IF arg_Code=GPCST_NAME_ZOUEI_3 THEN w_Res:= GPCST_CODE_ZOUEI_3
  ELSE w_Res:= '';
  result:=w_Res;
end;
//���@�\�i��O���j�F���ނ𖼑O�ɕϊ��o�^ �B�e�i��  SATUEI
function func_PIND_Change_SATUEI(
       arg_Code:string    //����
       ):string;          //����
var
   w_Res:string;
begin
  IF arg_Code=GPCST_CODE_SATUEI_0 THEN w_Res:= GPCST_NAME_SATUEI_0
  ELSE
  IF arg_Code=GPCST_CODE_SATUEI_1 THEN w_Res:= GPCST_NAME_SATUEI_1
  ELSE
  IF arg_Code=GPCST_CODE_SATUEI_2 THEN w_Res:= GPCST_NAME_SATUEI_2
  ELSE
  IF arg_Code=GPCST_NAME_SATUEI_0 THEN w_Res:= GPCST_CODE_SATUEI_0
  ELSE
  IF arg_Code=GPCST_NAME_SATUEI_1 THEN w_Res:= GPCST_CODE_SATUEI_1
  ELSE
  IF arg_Code=GPCST_NAME_SATUEI_2 THEN w_Res:= GPCST_CODE_SATUEI_2
  ELSE w_Res:= '';
  result:=w_Res;
end;
//���@�\�i��O���j�F���ނ𖼑O�ɕϊ��o�^ ���ԊO�敪
function func_PIND_Change_JIKAN(
       arg_Code:string    //����
       ):string;          //����
var
   w_Res:string;
begin
  IF arg_Code=GPCST_CODE_JIKAN_0 THEN w_Res:= GPCST_NAME_JIKAN_0
  ELSE
  IF arg_Code=GPCST_CODE_JIKAN_1 THEN w_Res:= GPCST_NAME_JIKAN_1
  ELSE
  IF arg_Code=GPCST_CODE_JIKAN_2 THEN w_Res:= GPCST_NAME_JIKAN_2
  ELSE
  IF arg_Code=GPCST_CODE_JIKAN_3 THEN w_Res:= GPCST_NAME_JIKAN_3
  ELSE
  IF arg_Code=GPCST_NAME_JIKAN_0 THEN w_Res:= GPCST_CODE_JIKAN_0
  ELSE
  IF arg_Code=GPCST_NAME_JIKAN_1 THEN w_Res:= GPCST_CODE_JIKAN_1
  ELSE
  IF arg_Code=GPCST_NAME_JIKAN_2 THEN w_Res:= GPCST_CODE_JIKAN_2
  ELSE
  IF arg_Code=GPCST_NAME_JIKAN_3 THEN w_Res:= GPCST_CODE_JIKAN_3
  ELSE w_Res:= '';
  result:=w_Res;
end;

//���@�\�i��O���j�F���ނ𖼑O�ɕϊ��o�^ RI���{�t���O
function func_PIND_Change_RI(
       arg_Code:string    //����
       ):string;          //����
var
   w_Res:string;
begin
  IF arg_Code=GPCST_CODE_RI_0 THEN w_Res:= GPCST_NAME_RI_0
  ELSE
  IF arg_Code=GPCST_CODE_RI_1 THEN w_Res:= GPCST_NAME_RI_1
  ELSE
  IF arg_Code=GPCST_NAME_RI_0 THEN w_Res:= GPCST_CODE_RI_0
  ELSE
  IF arg_Code=GPCST_NAME_RI_1 THEN w_Res:= GPCST_CODE_RI_1
  ELSE w_Res:= '';
  result:=w_Res;
end;
//���@�\�i��O���j�F���ނ𖼑O�ɕϊ��o�^ �����˗��t���O
function func_PIND_Change_SYOKEN(
       arg_Code:string    //����
       ):string;          //����
var
   w_Res:string;
begin
  IF arg_Code=GPCST_CODE_SYOKEN_0 THEN w_Res:= GPCST_NAME_SYOKEN_0
  ELSE
  IF arg_Code=GPCST_CODE_SYOKEN_1 THEN w_Res:= GPCST_NAME_SYOKEN_1
  ELSE
  IF arg_Code=GPCST_NAME_SYOKEN_0 THEN w_Res:= GPCST_CODE_SYOKEN_0
  ELSE
  IF arg_Code=GPCST_NAME_SYOKEN_1 THEN w_Res:= GPCST_CODE_SYOKEN_1
  ELSE w_Res:= '';
  result:=w_Res;
end;
//���@�\�i��O���j�F���ނ𖼑O�ɕϊ��o�^ �����i��  KENSIN
function func_PIND_Change_KENSIN(
       arg_Code:string;    //����
       arg_SubCode:string    //����
       ):string;          //����
var
   w_Res:string;
begin
  //2001.09.13
  //'0'
  if arg_Code = GPCST_CODE_KENSIN_0 then begin
    //'����t'
    if arg_SubCode = '' then
      w_Res := GPCST_NAME_KENSIN_0
    else if arg_SubCode = GPCST_CODE_KENSIN_SUB_5 then
      w_Res := GPCST_NAME_KENSIN_SUB_5
    else if arg_SubCode = GPCST_CODE_KENSIN_SUB_6 then
      w_Res := GPCST_NAME_KENSIN_SUB_6
  end
  //'1'
  else if arg_Code = GPCST_CODE_KENSIN_1 then begin
    //'����t'
    if arg_SubCode = '' then
      w_Res := GPCST_NAME_KENSIN_1
    else if arg_SubCode = GPCST_CODE_KENSIN_SUB_7 then
      w_Res := GPCST_NAME_KENSIN_SUB_7;
  end
  //'2'
  else if arg_Code = GPCST_CODE_KENSIN_2 then begin
    //'������'
    if arg_SubCode = '' then
      w_Res := GPCST_NAME_KENSIN_2
    else if arg_SubCode = GPCST_CODE_KENSIN_SUB_8 then
      w_Res := GPCST_NAME_KENSIN_SUB_8
    else if arg_SubCode = GPCST_CODE_KENSIN_SUB_9 then
      w_Res := GPCST_NAME_KENSIN_SUB_9
    else if arg_SubCode = GPCST_CODE_KENSIN_SUB_10 then
      w_Res := GPCST_NAME_KENSIN_SUB_10;
  end
  //'3'
  else if arg_Code = GPCST_CODE_KENSIN_3 then begin
    //'������'
    w_Res := GPCST_NAME_KENSIN_3;
  end
  //'4'
  else if arg_Code = GPCST_CODE_KENSIN_4 then begin
    //'���~'
    w_Res := GPCST_NAME_KENSIN_4;
  end


  //'����t'
  else if arg_Code = GPCST_NAME_KENSIN_0 then
    w_Res := GPCST_CODE_KENSIN_0
  else if arg_SubCode = GPCST_NAME_KENSIN_SUB_5 then
    w_Res := GPCST_CODE_KENSIN_SUB_5
  else if arg_SubCode = GPCST_NAME_KENSIN_SUB_6 then
    w_Res := GPCST_CODE_KENSIN_SUB_6
  //'��t��'
  else if arg_Code = GPCST_NAME_KENSIN_1 then
    w_Res := GPCST_CODE_KENSIN_1
  else if arg_SubCode = GPCST_NAME_KENSIN_SUB_7 then
    w_Res := GPCST_CODE_KENSIN_SUB_7
  //'������'
  else if arg_Code = GPCST_NAME_KENSIN_2 then
    //'2'
    w_Res := GPCST_CODE_KENSIN_2
  else if arg_SubCode = GPCST_NAME_KENSIN_SUB_8 then
    w_Res := GPCST_CODE_KENSIN_SUB_8
  else if arg_SubCode = GPCST_NAME_KENSIN_SUB_9 then
    w_Res := GPCST_CODE_KENSIN_SUB_9
  else if arg_SubCode = GPCST_NAME_KENSIN_SUB_10 then
    w_Res := GPCST_CODE_KENSIN_SUB_10
  //'������'
  else if arg_Code = GPCST_NAME_KENSIN_3 then begin
    //'3'
    w_Res := GPCST_CODE_KENSIN_3;
  end
  //'���~'
  else if arg_Code = GPCST_NAME_KENSIN_4 then begin
    //'4'
    w_Res := GPCST_CODE_KENSIN_4;
  end
  //����ȊO
  else
    w_Res := '';
  //�߂�l
  result:=w_Res;
end;
//���@�\�i��O���j�F���ނ𖼑O�ɕϊ��o�^ �����i��  KENSIN
function func_PIND_Change_KENSIN_Ryaku(
       arg_Code:string    //����
       ):string;          //����
var
   w_Res:string;
begin
  //2001.09.13
  //'0'
  if arg_Code = GPCST_CODE_KENSIN_0 then
    //'����t'
    w_Res := GPCST_RYAKU_NAME_KENSIN_0
  //'1'
  else if arg_Code = GPCST_CODE_KENSIN_1 then
    //'��t��'
    w_Res := GPCST_RYAKU_NAME_KENSIN_1
  //'2'
  else if arg_Code = GPCST_CODE_KENSIN_2 then
    //'������'
    w_Res := GPCST_RYAKU_NAME_KENSIN_2
  //'3'
  else if arg_Code = GPCST_CODE_KENSIN_3 then
    //'������'
    w_Res := GPCST_RYAKU_NAME_KENSIN_3
  //'4'
  else if arg_Code = GPCST_CODE_KENSIN_4 then
    //'���~'
    w_Res := GPCST_RYAKU_NAME_KENSIN_4
  //'����t'
  else if arg_Code = GPCST_RYAKU_NAME_KENSIN_0 then
    //'0'
    w_Res := GPCST_CODE_KENSIN_0
  //'��t��'
  else if arg_Code = GPCST_RYAKU_NAME_KENSIN_1 then
    //'1'
    w_Res := GPCST_CODE_KENSIN_1
  //'������'
  else if arg_Code = GPCST_RYAKU_NAME_KENSIN_2 then
    //'2'
    w_Res := GPCST_CODE_KENSIN_2
  //'������'
  else if arg_Code = GPCST_RYAKU_NAME_KENSIN_3 then
    //'3'
    w_Res := GPCST_CODE_KENSIN_3
  //'���~'
  else if arg_Code = GPCST_RYAKU_NAME_KENSIN_4 then
    //'4'
    w_Res := GPCST_CODE_KENSIN_4
  //����ȊO
  else
    w_Res := '';
  //�߂�l
  result:=w_Res;
end;

//���@�\�i��O���j�F���ނ𖼑O�ɕϊ��o�^�V�X�e���敪
function func_PIND_Change_SYSK(
       arg_Code:string    //����
       ):string;          //����
var
   w_Res:string;
begin
  IF arg_Code=GPCST_CODE_SYSK_RIS THEN w_Res:= GPCST_NAME_SYSK_RIS
  ELSE
  IF arg_Code=GPCST_CODE_SYSK_HIS THEN w_Res:= GPCST_NAME_SYSK_HIS
  ELSE
  IF arg_Code=GPCST_NAME_SYSK_RIS THEN w_Res:= GPCST_CODE_SYSK_RIS
  ELSE
  IF arg_Code=GPCST_NAME_SYSK_HIS THEN w_Res:= GPCST_CODE_SYSK_HIS
  ELSE w_Res:= '';
  result:=w_Res;
end;
//���@�\�i��O���j�F���ނ𖼑O�ɕϊ� ��
function func_PIND_Change_Sex(
       arg_Code:string    //����
       ):string;          //����
var
   w_Res:string;
begin
  IF arg_Code=GPCST_SEX_1 THEN w_Res:= GPCST_SEX_1_NAME
  ELSE
  IF arg_Code=GPCST_SEX_2 THEN w_Res:= GPCST_SEX_2_NAME
  ELSE
  IF arg_Code=GPCST_SEX_1_NAME THEN w_Res:= GPCST_SEX_1
  ELSE
  IF arg_Code=GPCST_SEX_2_NAME THEN w_Res:= GPCST_SEX_2
  ELSE w_Res:= '';
  result:=w_Res;
end;
//���@�\�i��O���j�F���ނ𖼑O�ɕϊ� ���O�敪
function func_PIND_Change_Nyugai(
       arg_Code:string    //����
       ):string;          //����
var
   w_Res:string;
begin
  IF arg_Code=GPCST_NYUGAIKBN_1 THEN w_Res:= GPCST_NYUGAIKBN_1_NAME
  ELSE
  IF arg_Code=GPCST_NYUGAIKBN_2 THEN w_Res:= GPCST_NYUGAIKBN_2_NAME
  ELSE
  IF arg_Code=GPCST_NYUGAIKBN_1_NAME THEN w_Res:= GPCST_NYUGAIKBN_1
  ELSE
  IF arg_Code=GPCST_NYUGAIKBN_2_NAME THEN w_Res:= GPCST_NYUGAIKBN_2
  ELSE w_Res:= '';

  result:=w_Res;
end;
//���̃R�[�h�ϊ�����������������������������������������������������������������
//������������������������������������������������������������������������������

//�\�`�����۰ق̃t�@�C���o�͏����|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|

//���@�\�i��O�L�j�FStringGrid�̓��e��csv�ɕۑ�
procedure proc_StringGridToFile(
       arg_FName:string;          //�ۑ��t�@�C����
       arg_StringGrid:TStringGrid //�Ώ�
       );
var
    w_Rowcount  : integer;
    w_Colcount  : integer;
    w_CSVFile   : TextFile;
    w_string    : string;

begin
    //--- �V�Ķ�ق��쐬���J��(CSV) ---
    AssignFile(w_CSVFile,arg_FName);
    if FileExists(arg_FName) then
    begin
        if DeleteFile(arg_FName) then
        begin
          Rewrite(w_CSVFile);
        end
        else
        begin
          raise T_ESysExcep.Create(
            '�ꏊ�F���X�g�̃t�@�C���ۑ����B' + #13#10 +
            '�����F�t�@�C�����폜�ł��܂���B' + #13#10 +
            '�Ώ��F�t�@�C���̋��L�����������ĉ������B'
                              );
          exit;
        end;
    end
    else
    begin
        Rewrite(w_CSVFile);
    end;
    try
     //CSV��������
     //��
     w_string := '';
     for w_Colcount:=0 to arg_StringGrid.ColCount-1 do
     begin
       if w_Colcount > 0 then  w_string :=  w_string + ',';
       w_string := w_string + '"' + arg_StringGrid.Cells[w_Colcount, 0] + '"' ;
     end;
     Writeln(w_CSVFile,w_string);        //�ް����
     //���e
     for w_Rowcount:=2 to arg_StringGrid.RowCount-1 do
     begin
        w_string := '';
        for w_Colcount:=0 to arg_StringGrid.ColCount-1 do
        begin
          if w_Colcount > 0 then  w_string :=  w_string + ',';
          w_string := w_string + '"' + arg_StringGrid.Cells[w_Colcount, w_Rowcount] + '"';
        end;
        Writeln(w_CSVFile,w_string);        //�ް����
     end;
     Flush(w_CSVFile);
     CloseFile(w_CSVFile);                    //CSV̧�ٸ۰��
    except
        CloseFile(w_CSVFile);                //CSV̧�ٸ۰��
        raise;
    end;//except
end;

//���@�\�i��O�L�j�FStringGrid�̓��e��csv�ɕۑ�
//                  ��\���J�����͕ۑ����Ȃ�
procedure proc_StringGridToFile2(
       arg_FName:string;          //�ۑ��t�@�C����
       arg_StringGrid:TStringGrid //�Ώ�
       );
var
    w_Rowcount  : integer;
    w_Colcount  : integer;
    w_CSVFile   : TextFile;
    w_string    : string;

begin
    //--- �V�Ķ�ق��쐬���J��(CSV) ---
    AssignFile(w_CSVFile,arg_FName);
    if FileExists(arg_FName) then
    begin
        if DeleteFile(arg_FName) then
        begin
          Rewrite(w_CSVFile);
        end
        else
        begin
          raise T_ESysExcep.Create(
            '�ꏊ�F���X�g�̃t�@�C���ۑ����B' + #13#10 +
            '�����F�t�@�C�����폜�ł��܂���B' + #13#10 +
            '�Ώ��F�t�@�C���̋��L�����������ĉ������B'
                              );
          exit;
        end;
    end
    else
    begin
        Rewrite(w_CSVFile);
    end;
    try
     //CSV��������
     //��
     w_string := '';
     for w_Colcount:=0 to arg_StringGrid.ColCount-1 do
     begin
       if arg_StringGrid.ColWidths[w_Colcount] > 0 then begin
         if w_Colcount > 0 then  w_string :=  w_string + ',';
         w_string := w_string + '"' + arg_StringGrid.Cells[w_Colcount, 0] + '"' ;
       end;
     end;
     Writeln(w_CSVFile,w_string);        //�ް����
     //���e
     for w_Rowcount:=2 to arg_StringGrid.RowCount-1 do
     begin
        w_string := '';
        for w_Colcount:=0 to arg_StringGrid.ColCount-1 do
        begin
          if arg_StringGrid.ColWidths[w_Colcount] > 0 then begin
            if w_Colcount > 0 then  w_string :=  w_string + ',';
            w_string := w_string + '"' + arg_StringGrid.Cells[w_Colcount, w_Rowcount] + '"';
          end;
        end;
        Writeln(w_CSVFile,w_string);        //�ް����
     end;
     Flush(w_CSVFile);
     CloseFile(w_CSVFile);                    //CSV̧�ٸ۰��
    except
        CloseFile(w_CSVFile);                //CSV̧�ٸ۰��
        raise;
    end;//except
end;

//���@�\�i��O�L�j�FListView�̓��e���쐬
procedure proc_ListViewToFile(
       arg_FName:string;      //�ۑ��t�@�C����
       arg_ListView:TListView //�Ώ�
       );
var
    w_Rowcount  : integer;
    w_Colcount  : integer;
    w_CSVFile   : TextFile;
    w_string    : string;

begin
    //--- �V�Ķ�ق��쐬���J��(CSV) ---
    AssignFile(w_CSVFile,arg_FName);
    if FileExists(arg_FName) then
    begin
        if DeleteFile(arg_FName) then
        begin
          Rewrite(w_CSVFile);
        end
        else
        begin
          raise T_ESysExcep.Create(
            '�ꏊ�F���X�g�̃t�@�C���ۑ����B' + #13#10 +
            '�����F�t�@�C�����폜�ł��܂���B' + #13#10 +
            '�Ώ��F�t�@�C���̋��L�����������ĉ������B'
                              );
          exit;
        end;
    end
    else
    begin
        Rewrite(w_CSVFile);
    end;
    try
     //CSV��������
     //��
     for w_Colcount:=0 to  arg_ListView.Columns.Count-1 do
     begin
       if w_Colcount > 0 then  w_string :=  w_string + ',';
       w_string := w_string + '"' + arg_ListView.Columns[w_Colcount].Caption + '"' ;
     end;
     Writeln(w_CSVFile,w_string);        //�ް����
     //���e
     for w_Rowcount:=0 to  arg_ListView.Items.Count-1 do
     begin
        w_string := '"' +arg_ListView.Items[w_Rowcount].caption + '"';
        for w_Colcount:=0 to  arg_ListView.Items[w_Rowcount].SubItems.Count-1 do
        begin
          w_string := w_string + ',';
          w_string := w_string + '"' + arg_ListView.Items[w_Rowcount].SubItems[w_Colcount] + '"';
        end;
        Writeln(w_CSVFile,w_string);        //�ް����
     end;
     Flush(w_CSVFile);
     CloseFile(w_CSVFile);                    //CSV̧�ٸ۰��
    except
        CloseFile(w_CSVFile);                //CSV̧�ٸ۰��
        raise;
    end;//except
end;

//�\�`�����۰ق̃t�@�C���o�͏���������������������������������������������������
//������������������������������������������������������������������������������

//�r�p�k�̈�ʏ��������|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|
//���@�\�i��O���j�FDate��Between����쐬
function func_DateBetween(
       arg_FName:string;   //���ږ�
       arg_Date1:TDate;    //����
       arg_Date2:TDate     //�I��
       ):string;
var
   w_Res:string;
begin

  w_Res := ' To_Char(' + arg_FName + ',''yyyymmdd'') ';
  w_Res := w_Res + ' between ';
  w_Res := w_Res + '''' + FormatDateTime('yyyymmdd',arg_Date1) + '''' ;
  w_Res := w_Res + ' and ' ;
  w_Res := w_Res + '''' + FormatDateTime('yyyymmdd',arg_Date2) + '''' ;
  result:=w_Res;

end;

//���@�\�i��O�L�j�FSQL�̌��ʂ̃��R�[�h����Ԃ�
function func_SqlCount(
       arg_DB:TDatabase;
       arg_Sql:Tstrings):Integer;
var
  w_Qry:TQuery;
begin
  w_Qry:=TQuery.Create(nil);
  try
    w_Qry.Close;
    w_Qry.DatabaseName :=arg_DB.DatabaseName;
    w_Qry.SQL.AddStrings(arg_Sql);
    w_Qry.Open;
    w_Qry.Last;
    result:=w_Qry.RecordCount;
    w_Qry.Close;
  finally
    w_Qry.Free;
  end;
end;

//���@�\�i��O�L�j�FSQL�̎��s���ʂ�Ԃ�
{$HINTS OFF}
function func_SqlExec(
       arg_DB:TDatabase;          //�ڑ����ꂽDB
       arg_Sql:Tstrings):boolean; //�L����SQL
var
  w_Qry:TQuery;
begin
  w_Qry:=TQuery.Create(nil);
  result:=False;
  try
    w_Qry.Close;
    w_Qry.DatabaseName :=arg_DB.DatabaseName;
    w_Qry.SQL.Clear;
    w_Qry.SQL.AddStrings(arg_Sql);
    try
      w_Qry.ExecSQL;
      result:=True;
    except
      result:=False;
      raise;
    end;
  finally
    w_Qry.Free;
  end;
end;
{$HINTS ON}
//�\�`�����۰ق̃t�@�C���o�͏���������������������������������������������������
//������������������������������������������������������������������������������

//�Ǘ��e�[�u�������|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|
//���@�\�i��O�L�j�FKANRI�e�[�u���̌����S�폜
{$HINTS OFF}
function func_DelKAnri(
       arg_DB:TDatabase;         //�ڑ����ꂽDB
       arg_TanName:string       //PC����
       ):boolean;                //����True���� False���s
var
   w_ExecSql:string;
   w_Strings:TStrings;
   res:integer;
   rtn:boolean;
begin
//�P�D�����l���ݒ�
  result := false;
//�Q�D�����擾
//�Q�D�P�g�����U�N�V�����l��
  arg_DB.StartTransaction;
//�Q�D�Q��Ԗ⍇�킹
  try
    //���Y�[���̂��ׂĂ��폜
    w_ExecSql:= 'Delete ';
    w_ExecSql:= w_ExecSql + ' from  '+ CST_TBL_KANRI +' ';
    w_ExecSql:= w_ExecSql + ' where ';
    w_ExecSql:= w_ExecSql + '       ( ' + CST_TBLIN_TAN_NAME + '   = ''' + arg_TanName + ''')';
    w_Strings:= func_StrToTStrList('');
    try
      w_Strings.Add(w_ExecSql);
      rtn := func_SqlExec(arg_DB,w_Strings);
      if rtn then
      begin
        arg_DB.Commit;
        result:=True;
      end
      else
      begin
        arg_DB.Rollback;
        result:=false;
      end;
    finally
      w_Strings.Free;
    end;
    exit;
  except
    arg_DB.Rollback;
    result:=false;
    raise;
    exit;
  end;
end;
{$HINTS ON}
//���@�\�i��O�L�j�FKANRI�e�[�u���̌����Ԋ�
{$HINTS OFF}
function func_ReleasKAnri(
       arg_DB:TDatabase;         //�ڑ����ꂽDB
       arg_TanName:string;       //PC����
       arg_ProgId:string;        //�v���O����ID
       arg_RisId:string;         //RIS����ID
       arg_SyoriMode:string      //�ԊҌ����� G_KANRI_TBL_RMODE �Q�ƌ���
                                 //           G_KANRI_TBL_WMODE �X�V����
       ):boolean;                //����True���� False���s
var
   w_ExecSql:string;
   w_Strings:TStrings;
   res:integer;
   rtn:boolean;
begin
//�P�D�����l���ݒ�
  result := false;
//�Q�D�����擾
//�Q�D�P�g�����U�N�V�����l��
  arg_DB.StartTransaction;
//�Q�D�Q��Ԗ⍇�킹
  try
    w_ExecSql:= 'Delete ';
    w_ExecSql:= w_ExecSql + ' from  '+ CST_TBL_KANRI +' ';
    w_ExecSql:= w_ExecSql + ' where ';
    w_ExecSql:= w_ExecSql + '       ( ' + CST_TBLIN_SYORIMODE + ' = ' + arg_SyoriMode  + ')';
    w_ExecSql:= w_ExecSql + '   and ';
    w_ExecSql:= w_ExecSql + '       ( ' + CST_TBLIN_RISID + '     = ''' + arg_RisId + ''')';
    w_ExecSql:= w_ExecSql + '   and ';
    w_ExecSql:= w_ExecSql + '       ( ' + CST_TBLIN_PRODID + '    = ''' + arg_ProgId  + ''')';
    w_ExecSql:= w_ExecSql + '   and ';
    w_ExecSql:= w_ExecSql + '       ( ' + CST_TBLIN_TAN_NAME + '  = ''' + arg_TanName + ''')';
    w_Strings:= func_StrToTStrList('');
    try
      w_Strings.Add(w_ExecSql);
      rtn := func_SqlExec(arg_DB,w_Strings);
      if rtn then
      begin
        arg_DB.Commit;
        result:=True;
      end
      else
      begin
        arg_DB.Rollback;
        result:=false;
      end;
    finally
      w_Strings.Free;
    end;
    exit;
  except
    arg_DB.Rollback;
    result:=false;
    raise;
    exit;
  end;
end;
{$HINTS ON}

//���@�\�i��O�L�j�FKANRI�e�[�u���̎Q�ƌ����擾
{$HINTS OFF}
function func_GetRKAnri(
       arg_DB:TDatabase;         //�ڑ����ꂽDB
       arg_TanName:string;       //PC����
       arg_ProgId:string;        //�v���O����ID
       arg_RisId:string          //RIS����ID
       ):boolean;                //����True���� False���s
var
   w_SelectSql:string;
   w_ExecSql:string;
   w_Strings:TStrings;
   res:integer;
   rtn:boolean;
begin
//�P�D�����l���ݒ�
  result := false;
//�Q�D�����擾
//�Q�D�P�g�����U�N�V�����l��
  arg_DB.StartTransaction;
//�Q�D�Q��Ԗ⍇�킹
  try
    //��ԑJ�ڏ��� ���ׂ�
    w_SelectSql:= 'select * ';
    w_SelectSql:= w_SelectSql + ' from  '+ CST_TBL_KANRI +' ';
    w_SelectSql:= w_SelectSql + ' where ';
    w_SelectSql:= w_SelectSql + '       ( ' + CST_TBLIN_SYORIMODE + ' = ' + G_KANRI_TBL_RMODE  + ')';
    w_SelectSql:= w_SelectSql + '   and ';
    w_SelectSql:= w_SelectSql + '       ( ' + CST_TBLIN_RISID   + '   = '''   + arg_RisId + ''')';
    w_SelectSql:= w_SelectSql + '   and ';
    w_SelectSql:= w_SelectSql + '       ( ' + CST_TBLIN_PRODID    + ' = '''   + arg_ProgId + ''')';
    w_SelectSql:= w_SelectSql + '   and ';
    w_SelectSql:= w_SelectSql + '       ( ' + CST_TBLIN_TAN_NAME  + ' = '''   + arg_TanName + ''')';

    w_Strings:= func_StrToTStrList('');
    try
      w_Strings.Add(w_SelectSql);
      res:=func_SqlCount(arg_DB,w_Strings);
      if res=0 then
      begin
//�Q�D�R�����擾
// �Ȃ���Ό����擾�錾
        w_ExecSql:= 'insert into '+ CST_TBL_KANRI +' (';
        w_ExecSql:= w_ExecSql + ' ' + CST_TBLIN_TAN_NAME  + ', ';
        w_ExecSql:= w_ExecSql + ' ' + CST_TBLIN_PRODID    + ', ';
        w_ExecSql:= w_ExecSql + ' ' + CST_TBLIN_RISID     + ', ';
        w_ExecSql:= w_ExecSql + ' ' + CST_TBLIN_SYORIMODE + ' ';
        w_ExecSql:= w_ExecSql + ' ) values (';
        w_ExecSql:= w_ExecSql + '''' + arg_TanName       + ''',';
        w_ExecSql:= w_ExecSql + '''' + arg_ProgId        + ''',';
        w_ExecSql:= w_ExecSql + '''' + arg_RisId         + ''',';
        w_ExecSql:= w_ExecSql + ''   + G_KANRI_TBL_RMODE +')';
        w_Strings.Clear;
        w_Strings.Add(w_ExecSql);
        rtn := func_SqlExec(arg_DB,w_Strings);
        if rtn then
        begin
          arg_DB.Commit;
          result:=True;
        end
        else
        begin
          arg_DB.Rollback;
          result:=false;
        end;
      end
      else
      begin
//�Q�D�S�����擾�ł��Ȃ�(�Q�Ǝ擾�͑��Ŏg�p���ł�OK)
//�Q�Ə�����Ɏc������Update���ŃJ�E���g���A�b�v���鏈���ƂȂ�
//�X�V���ł�����݂�ΎQ�ƒ����̔��ʂ͂�
          arg_DB.Rollback;
          result:=True;
      end;
    finally
      w_Strings.Free;
    end;
    exit;
  except
    arg_DB.Rollback;
    result:=false;
    raise;
    exit;
  end;
end;
{$HINTS ON}

//���@�\�i��O�L�j�FKANRI�e�[�u���̍X�V�����擾
{$HINTS OFF}
function func_GetWKAnri(
       arg_DB:TDatabase;         //�ڑ����ꂽDB
       arg_TanName:string;       //PC����
       arg_ProgId:string;        //�v���O����ID
       arg_RisId:string          //RIS����ID
       ):boolean;                //����True���� False���s
var
   w_SelectSql:string;
   w_ExecSql:string;
   w_Strings:TStrings;
   res:integer;
   rtn:boolean;
begin
//�P�D�����l���ݒ�
  result := false;
//�Q�D�����擾
//�Q�D�P�g�����U�N�V�����l��
  arg_DB.StartTransaction;
//�Q�D�Q��Ԗ⍇�킹
  try
    //��ԑJ�ڏ��� arg_OrderId arg_OrderId arg_KensaDate �̕s����
    //�X�V���[�h�̂��̂����Ȃ��Ƃ��ŎQ�Ƃ�OK
    w_SelectSql:= 'select * ';
    w_SelectSql:= w_SelectSql + ' from  '+ CST_TBL_KANRI +' ';
    w_SelectSql:= w_SelectSql + ' where ';
    w_SelectSql:= w_SelectSql + '       ( ' + CST_TBLIN_SYORIMODE + '    = ' + G_KANRI_TBL_WMODE  + ')';
    w_SelectSql:= w_SelectSql + '   and ';
    w_SelectSql:= w_SelectSql + '       ( ' + CST_TBLIN_RISID + '   = '''   + arg_RisId + ''')';

    w_Strings:= func_StrToTStrList('');
    try
      w_Strings.Add(w_SelectSql);
      res:=func_SqlCount(arg_DB,w_Strings);
      if res=0 then
      begin
//�Q�D�R�����擾
        w_ExecSql:= 'insert into '+ CST_TBL_KANRI +' (';
        w_ExecSql:= w_ExecSql + ' ' + CST_TBLIN_TAN_NAME  + ', ';
        w_ExecSql:= w_ExecSql + ' ' + CST_TBLIN_PRODID    + ', ';
        w_ExecSql:= w_ExecSql + ' ' + CST_TBLIN_RISID     + ', ';
        w_ExecSql:= w_ExecSql + ' ' + CST_TBLIN_SYORIMODE + ' ';
        w_ExecSql:= w_ExecSql + ' ) values (';
        w_ExecSql:= w_ExecSql + '''' + arg_TanName       + ''',';
        w_ExecSql:= w_ExecSql + '''' + arg_ProgId        + ''',';
        w_ExecSql:= w_ExecSql + '''' + arg_RisId         + ''',';
        w_ExecSql:= w_ExecSql + ''   + G_KANRI_TBL_WMODE + ')';
        w_Strings.Clear;
        w_Strings.Add(w_ExecSql);
        rtn := func_SqlExec(arg_DB,w_Strings);
        if rtn then
        begin
          arg_DB.Commit;
          result:=True;
        end
        else
        begin
          arg_DB.Rollback;
          result:=false;
        end;
      end
      else
      begin
//�Q�D�S�����擾�ł��Ȃ�(���Ŏg�p��)
          arg_DB.Rollback;
          result:=false;
      end;
    finally
      w_Strings.Free;
    end;
    exit;
  except
    arg_DB.Rollback;
    result:=false;
    raise;
    exit;
  end;
end;
{$HINTS ON}
//���@�\�i��O�L�j�FKANRI�e�[�u���̍X�V�����擾
{$HINTS OFF}
function func_GetWKAnriUketuke(
       arg_DB:TDatabase;         //�ڑ����ꂽDB
       arg_TanName:string;       //PC����
       arg_ProgId:string;        //�v���O����ID
       arg_RisId:string          //RIS����ID
       ):boolean;                //����True���� False���s
var
   w_SelectSql:string;
   w_ExecSql:string;
   w_Strings:TStrings;
   res:integer;
   rtn:boolean;
begin
//�P�D�����l���ݒ�
  result := false;
//�Q�D�����擾
{
//�Q�D�P�g�����U�N�V�����l��
  arg_DB.StartTransaction;
}
//�Q�D�Q��Ԗ⍇�킹
  try
    //��ԑJ�ڏ��� arg_OrderId arg_OrderId arg_KensaDate �̕s����
    //�X�V���[�h�̂��̂����Ȃ��Ƃ��ŎQ�Ƃ�OK
    w_SelectSql:= 'select * ';
    w_SelectSql:= w_SelectSql + ' from  '+ CST_TBL_KANRI +' ';
    w_SelectSql:= w_SelectSql + ' where ';
    w_SelectSql:= w_SelectSql + '       ( ' + CST_TBLIN_SYORIMODE + '    = ' + G_KANRI_TBL_WMODE  + ')';
    w_SelectSql:= w_SelectSql + '   and ';
    w_SelectSql:= w_SelectSql + '       ( ' + CST_TBLIN_RISID + '   = '''   + arg_RisId + ''')';

    w_Strings:= func_StrToTStrList('');
    try
      w_Strings.Add(w_SelectSql);
      res:=func_SqlCount(arg_DB,w_Strings);
      if res=0 then begin
//�Q�D�R�����擾
        w_ExecSql:= 'insert into '+ CST_TBL_KANRI +' (';
        w_ExecSql:= w_ExecSql + ' ' + CST_TBLIN_TAN_NAME  + ', ';
        w_ExecSql:= w_ExecSql + ' ' + CST_TBLIN_PRODID    + ', ';
        w_ExecSql:= w_ExecSql + ' ' + CST_TBLIN_RISID     + ', ';
        w_ExecSql:= w_ExecSql + ' ' + CST_TBLIN_SYORIMODE + ' ';
        w_ExecSql:= w_ExecSql + ' ) values (';
        w_ExecSql:= w_ExecSql + '''' + arg_TanName       + ''',';
        w_ExecSql:= w_ExecSql + '''' + arg_ProgId        + ''',';
        w_ExecSql:= w_ExecSql + '''' + arg_RisId         + ''',';
        w_ExecSql:= w_ExecSql + ''   + G_KANRI_TBL_WMODE + ')';
        w_Strings.Clear;
        w_Strings.Add(w_ExecSql);
        rtn := func_SqlExec(arg_DB,w_Strings);
        if rtn then begin
//          arg_DB.Commit;
          result:=True;
        end
        else begin
//          arg_DB.Rollback;
          result:=false;
        end;
      end
      else begin
//�Q�D�S�����擾�ł��Ȃ�(���Ŏg�p��)
//          arg_DB.Rollback;
          result:=false;
      end;
    finally
      w_Strings.Free;
    end;
    exit;
  except
//    arg_DB.Rollback;
    result:=false;
    raise;
    exit;
  end;
end;

//�Ǘ��e�[�u������
//������������������������������������������������������������������������������


//�g�p�\�֐�������������������������������������������������������������������
//������������������������������������������������������������������������������
//������������������������������������������������������������������������������
//������������������������������������������������������������������������������
//������������������������������������������������������������������������������
//������������������������������������������������������������������������������
//������������������������������������������������������������������������������

//���@�\�i��O�L�j�FNameMS�̓���敪���R���{�ɐݒ�i�R���{�N���A����j
procedure proc_NameMSToComb(
   arg_Qry:TQuery;
   arg_KBN:string;
   arg_Comb: TComboBox
   );
begin
  arg_Comb.Items.clear;
  proc_NameMSToComb1(
                arg_Qry,
                arg_KBN,
                arg_Comb);
end;

//���@�\�i��O�L�j�FNameMS�̓���敪���R���{�ɐݒ�i�R���{�N���A���Ȃ��j
procedure proc_NameMSToComb1(
   arg_Qry:TQuery;
   arg_KBN:string;
   arg_Comb: TComboBox
   );
begin
  arg_Qry.Close;
  arg_Qry.SQL.clear;
  arg_Qry.SQL.Add('select ');
  arg_Qry.SQL.Add('    kbn, ');
  arg_Qry.SQL.Add('    name ');
  arg_Qry.SQL.Add('  from ');
  arg_Qry.SQL.Add('    namems ');
  arg_Qry.SQL.Add('  where ');
  arg_Qry.SQL.Add('    kbn = ''' + arg_KBN + '''' );
  arg_Qry.SQL.Add('  order by ');
  arg_Qry.SQL.Add('    output_seq ');
  arg_Qry.Open;
  try
    arg_Qry.First;
    while not(arg_Qry.Eof)  do
    begin
      arg_Comb.Items.Add( arg_Qry.FieldByName('name').AsString);
      arg_Qry.Next
    end;
    arg_Comb.ItemIndex := -1;
  finally
    arg_Qry.Close;
  end;
end;


//���[�U���m�F�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|
//���@�\�i��O�L�j�FUSERMS��User_name���m�F
function func_ChkUserName(
       arg_DB:TDatabase;
       arg_UserName:string
       ):boolean;
var
   w_Str:string;
   w_Strings:TStrings;
   res:integer;
begin
  result := false;
  w_Str  := 'select user_name from userms ';
  w_Str  := w_Str + 'where user_name= '''+ arg_UserName+ '''';

  w_Strings:= func_StrToTStrList('');
  try
    w_Strings.Add(w_Str);
    res:=func_SqlCount(arg_DB,w_Strings);

    if res>0 then result:=true;

  finally
    w_Strings.Free;
  end;
  exit;
end;
//���@�\�i��O�L�j�FUSERMS��User_name��PASSWORD���m�F
function func_ChkUserPass(
       arg_DB:TDatabase;
       arg_UserName:string;
       arg_Password:string
       ):boolean;
var
   w_Str:string;
   w_Strings:TStrings;
   res:integer;
begin
  result := false;
  w_Str  := 'select user_name from userms ';
  w_Str  := w_Str + 'where ';
  w_Str  := w_Str + '      user_name = '''+ arg_UserName+ '''';
  w_Str  := w_Str + ' and ';
  w_Str  := w_Str + '      password  = '''+ arg_Password+ '''';

  w_Strings:= func_StrToTStrList('');
  try
    w_Strings.Add(w_Str);
    res:=func_SqlCount(arg_DB,w_Strings);

    if res>0 then result:=true;

  finally
    w_Strings.Free;
  end;
  exit;
end;

//���@�\�i��O�L�j�FUSERMS��User_name��class���m�F
function func_ChkUserClass(
       arg_DB:TDatabase;         //�ڑ����ꂽDB
       arg_UserName:string;      //���[�U��
       arg_Class:string          //�N���X
       ):boolean;
var
   w_Str:string;
   w_Strings:TStrings;
   res:integer;
begin
  result := false;
  w_Str  := 'select user_name from userms ';
  w_Str  := w_Str + 'where (user_name = '''+ arg_UserName + ''')';
  w_Str  := w_Str + '  and (class     = '+ arg_Class    + ')';

  w_Strings:= func_StrToTStrList('');
  try
    w_Strings.ADD(w_Str);
    res:=func_SqlCount(arg_DB,w_Strings);

    if res>0 then result:=true;

  finally
    w_Strings.Free;
  end;
  exit;
end;
//���[�U���m�F������������������������������������������������������������������

//���@�\�i��O���j�F���[�N���X�g�\��e�[�u���p�L�[���ڕҏW
function func_WorklistInfo_Key_Make(
         //IN
         arg_KanjaID: string;
         arg_OrderNO: string;
         //OUT
         var arg_Rcv_ACCESSION_NUMBER: string;
         var arg_Rcv_PATIENT_ID: string
        ): Boolean;
begin
  Result := True;
//���[�N���X�g�\��e�[�u���L�[���ڕҏW

//17.��t�ԍ�
  //����ID�{�I�[�_NO
  //...'-'���Ƃ� 2001.02.15
  arg_Rcv_ACCESSION_NUMBER := Trim(StringReplace(arg_KanjaID,'-','',[rfReplaceAll]))
                            + arg_OrderNO;
//23.����ID
  //
  arg_Rcv_PATIENT_ID := arg_KanjaID;
end;
//���[�N���X�g�\��e�[�u���p�L�[���ڕҏW����������������������������������������

//���@�\�i��O���j�F���[�N���X�g�\��e�[�u���p�S���ڕҏW
function func_WorklistInfo_Make(
         //IN
         arg_Query: TQuery;
         arg_Group_No: string;
         arg_SysDate: string;
         arg_SysTime: string;
         arg_KanjaID: string;
         arg_OrderNO: string;
         arg_SimeiKana: string;
         arg_SimeiKanji: string;
         arg_Sex: string;
         arg_BirthDay: string;
         arg_Start_Date: string;
         arg_Start_Time: string;
         arg_Irai_Doctor_Name: string;
         arg_Irai_Section_Name: string;
         arg_Irai_Section_Kana: string;
         arg_KensaKikiName: string;
         arg_Modality_Type: string;
         arg_KensaComment1: string;
         arg_SUID: string;
         //OUT
         var arg_Rcv_SCH_STATION_AE_TITLE: string;
         var arg_Rcv_SCH_PROC_STEP_LOCATION: string;
         var arg_Rcv_SCH_PROC_STEP_START_DATE: string;
         var arg_Rcv_SCH_PROC_STEP_START_TIME: string;
         var arg_Rcv_SCH_PERF_PHYSICIANS_NAME_ROMA: string;
         var arg_Rcv_SCH_PERF_PHYSICIANS_NAME_KANJI: string;
         var arg_Rcv_SCH_PERF_PHYSICIANS_NAME_KANA: string;
         var arg_Rcv_SCH_PROC_STEP_DESCRIPTION: string;
         var arg_Rcv_SCH_PROC_STEP_ID: string;
         var arg_Rcv_COMMENTS_ON_THE_SCH_PROC_STEP: string;
         var arg_Rcv_MODALITY: string;
         var arg_Rcv_REQ_PROC_ID: string;
         var arg_Rcv_STUDY_INSTANCE_UID: string;
         var arg_Rcv_REQ_PROC_DESCRIPTION: string;
         var arg_Rcv_REQUESTING_PHYSICIAN: string;
         var arg_Rcv_REQUESTING_SERVICE: string;
         var arg_Rcv_ACCESSION_NUMBER: string;
         var arg_Rcv_INSTITUTION: string;
         var arg_Rcv_INSTITUTION_ADDRESS: string;
         var arg_Rcv_PATIENT_NAME_ROMA: string;
         var arg_Rcv_PATIENT_NAME_KANJI: string;
         var arg_Rcv_PATIENT_NAME_KANA: string;
         var arg_Rcv_PATIENT_ID: string;
         var arg_Rcv_PATIENT_BIRTH_DATE: string;
         var arg_Rcv_PATIENT_SEX: string;
         var arg_Rcv_PATIENT_WEIGHT: string
        ): Boolean;
begin
  Result := True;
//���[�N���X�g�\��e�[�u���S���ڕҏW

//1.�\��Ͻð���AE����
  //...�����@�햼��
  //...�Ȃ� 2001.02.15
  arg_Rcv_SCH_STATION_AE_TITLE := '';//arg_KensaKikiName;
//2.�\��ώ葱���ï�ߏꏊ
  //...�����@�햼��(�\��̂Ȃ����̂�1.�\��Ͻð���AE���̂ɓ���)
  if arg_KensaKikiName <> '' then begin
    arg_Rcv_SCH_PROC_STEP_LOCATION := arg_KensaKikiName;
  end else begin
    arg_Rcv_SCH_PROC_STEP_LOCATION := arg_Rcv_SCH_STATION_AE_TITLE;
  end;
//3.�\��ώ葱���ï�ߊJ�n���t
  //...DATE�^
  arg_Rcv_SCH_PROC_STEP_START_DATE := '';
  if Length(Trim(arg_Start_Date)) = 10 then begin
    arg_Rcv_SCH_PROC_STEP_START_DATE := Trim(arg_Start_Date);
  end else begin
    arg_Rcv_SCH_PROC_STEP_START_DATE := func_Date8To10(Trim(arg_Start_Date));
  end;
//4.�\��ώ葱���ï�ߊJ�n����
  //...DATE�^(�J�n���t�{�J�n����)
  arg_Rcv_SCH_PROC_STEP_START_TIME := '';
  if Length(Trim(arg_Start_Time)) = 8 then begin
    arg_Rcv_SCH_PROC_STEP_START_TIME := arg_Rcv_SCH_PROC_STEP_START_DATE
                                      + ' '
                                      + Trim(arg_Start_Time);
  end else begin
    arg_Rcv_SCH_PROC_STEP_START_TIME := arg_Rcv_SCH_PROC_STEP_START_DATE
                                      + ' '
                                      + func_Time6To8(Trim(arg_Start_Time));
  end;
//5.�\�񂳂ꂽ���s��t��(ROMA)
  //...�Œ�(INI�}�X�^���擾)
  arg_Rcv_SCH_PERF_PHYSICIANS_NAME_ROMA := func_Get_WinMaster_DATA(arg_Group_No,g_WORKLIST_INFO,g_WORKLIST_I_ROMA);
//6.�\�񂳂ꂽ���s��t��(����)
  //...�Œ�(INI�}�X�^���擾)
  arg_Rcv_SCH_PERF_PHYSICIANS_NAME_KANJI := func_Get_WinMaster_DATA(arg_Group_No,g_WORKLIST_INFO,g_WORKLIST_I_KANJI);
  arg_Rcv_SCH_PERF_PHYSICIANS_NAME_KANJI := Trim(StringReplace(arg_Rcv_SCH_PERF_PHYSICIANS_NAME_KANJI, ' ', '�@', [rfReplaceAll]));
//7.�\�񂳂ꂽ���s��t��(�J�i)
  //...�Œ�(INI�}�X�^���擾)
  arg_Rcv_SCH_PERF_PHYSICIANS_NAME_KANA := func_Get_WinMaster_DATA(arg_Group_No,g_WORKLIST_INFO,g_WORKLIST_I_KANA);
  arg_Rcv_SCH_PERF_PHYSICIANS_NAME_KANA := HanToZen(arg_Rcv_SCH_PERF_PHYSICIANS_NAME_KANA);
  arg_Rcv_SCH_PERF_PHYSICIANS_NAME_KANA := StringReplace(arg_Rcv_SCH_PERF_PHYSICIANS_NAME_KANA, ' ', '�@', [rfReplaceAll]);
//8.�\��ώ葱���ï�ߋL�q
  //...�Ȃ�
  arg_Rcv_SCH_PROC_STEP_DESCRIPTION := '';
//9.�\��ώ葱���ï��ID
  //...17.��t�ԍ��ɓ���(����ID�{�I�[�_NO)
  //...'-'���Ƃ� 2001.02.15
  arg_Rcv_SCH_PROC_STEP_ID := Trim(StringReplace(arg_KanjaID,'-','',[rfReplaceAll]))
                            + arg_OrderNO;
//10.�\��ώ葱���ï�߃R�����g
  //...�����R�����g
  arg_Rcv_COMMENTS_ON_THE_SCH_PROC_STEP := Trim(arg_KensaComment1);
//11.���_���e�B
  //...�˗��敪���_���e�B�^�C�v
  arg_Rcv_MODALITY := arg_Modality_Type;
//12.�˗��ώ葱��ID
  //...17.��t�ԍ��ɓ���(����ID�{�I�[�_NO)
  //...'-'���Ƃ� 2001.02.15
  arg_Rcv_REQ_PROC_ID := Trim(StringReplace(arg_KanjaID,'-','',[rfReplaceAll]))
                       + arg_OrderNO;
//13.�����C���X�^���XUID
  arg_Rcv_STUDY_INSTANCE_UID := arg_SUID;
//14.�˗��ώ葱���L�q
  //...8.�\��ώ葱���ï�ߋL�q�ɓ���
  arg_Rcv_REQ_PROC_DESCRIPTION := '';
//15.�˗���t
  //...�S�p�ϊ�
  arg_Rcv_REQUESTING_PHYSICIAN := Trim(StringReplace(Trim(arg_Irai_Doctor_Name), ' ', '�@', [rfReplaceAll]));
//16.�˗�����
  //...CT�AMR�̓��[�}���ϊ�
  if (arg_Rcv_MODALITY = 'CT') or
     (arg_Rcv_MODALITY = 'MR') then begin
    arg_Rcv_REQUESTING_SERVICE := func_Kana_To_Roma(Trim(arg_Irai_Section_Kana));
  end
  //...CT�AMR�ȊO�͊���
  else begin
    arg_Rcv_REQUESTING_SERVICE := Trim(StringReplace(Trim(arg_Irai_Section_Name), ' ', '�@', [rfReplaceAll]));
  end;
//17.��t�ԍ�
  //����ID�{�I�[�_NO
  //...'-'���Ƃ� 2001.02.15
  arg_Rcv_ACCESSION_NUMBER := Trim(StringReplace(arg_KanjaID,'-','',[rfReplaceAll]))
                            + arg_OrderNO;
//18.�{�ݖ�
  //...�Œ�(INI�}�X�^���擾)
  arg_Rcv_INSTITUTION := func_Get_WinMaster_DATA(arg_Group_No,g_HOSP,g_HOSP_NAME);
//19.�{�ݏZ��
  //...�Œ�(INI�}�X�^���擾)
  arg_Rcv_INSTITUTION_ADDRESS := func_Get_WinMaster_DATA(arg_Group_No,g_HOSP,g_HOSP_ADDRESS);
//20.���Җ�(ROMA)
  //...�J�i�����[�}���ϊ�
  arg_Rcv_PATIENT_NAME_ROMA := func_Kana_To_Roma(arg_SimeiKana);
//21.���Җ�(����)
  //...�S�p�ϊ�
  arg_Rcv_PATIENT_NAME_KANJI := Trim(StringReplace(arg_SimeiKanji, ' ', '�@', [rfReplaceAll]));
//22.���Җ�(�J�i)
  //
  arg_Rcv_PATIENT_NAME_KANA := arg_SimeiKana;
  arg_Rcv_PATIENT_NAME_KANA := HanToZen(arg_Rcv_PATIENT_NAME_KANA);
  arg_Rcv_PATIENT_NAME_KANA := StringReplace(arg_Rcv_PATIENT_NAME_KANA, ' ', '�@', [rfReplaceAll]);
//23.����ID
  //
  arg_Rcv_PATIENT_ID := arg_KanjaID;
//24.���҂̒a����
  //...DATE�^
  arg_Rcv_PATIENT_BIRTH_DATE := '';
  if arg_BirthDay <> '' then begin
    if Length(Trim(arg_BirthDay)) = 10 then begin
      arg_Rcv_PATIENT_BIRTH_DATE := Trim(arg_BirthDay);
    end else begin
      arg_Rcv_PATIENT_BIRTH_DATE := func_Date8To10(Trim(arg_BirthDay));
    end;
  end;
//25.���҂̐���
  //...M:�j�AF:��
  if (arg_Sex <> GPCST_SEX_1) and
     (arg_Sex <> GPCST_SEX_2) then begin
     arg_Sex := func_PIND_Change_Sex(arg_Sex);
  end;
  arg_Rcv_PATIENT_SEX := arg_Sex;
//26.���҂̑̏d
  //...�Ȃ�
  arg_Rcv_PATIENT_WEIGHT := '';
end;
//���[�N���X�g�\��e�[�u���p�S���ڕҏW������������������������������������������

//���@�\�i��O���j�F�J�^�J�i�����[�}���ϊ�
// MS-IME2 for Windows�̃��[�}���ƃJ�i�̑Ή��\
function func_Kana_To_Roma(
         arg_Kana: string
         ): string;
var
  w_i,w_ii: integer;
  w_t: integer;
  w_Get_Kana: string;
  w_Get_Roma: string;
  w_Roma: string;

  w_Before_Kana: string;
  w_After_Kana: string;
  w_LTU: Boolean;
//�A�`���s�y�ё��_��
type TNAMEAREA_1 = array[1..242] of String;
const
  Kana_Area_Max = 242;
  Kana_Area : TNAMEAREA_1 =
       (
        '�',	'�',	'�',	'�',	'�',
        '�',	'�',	'�',	'�',	'�',
        '�',	'�',	'�',	'�',	'�',
        '�',	'�',	'�',	'�',	'�',
        '�',	'�',	'�',	'�',	'�',
        '�',	'�',	'�',	'�',	'�',
        '�',	'�',	'�',	'�',	'�',
        '�',		'�',		'�',
        '�',	'�',	'�',	'�',	'�',
        '�',	'�',			'�',
        		'��',
        '��',	'��',	'��',	'��',	'��',
        '��',	'��',	'��',	'��',	'��',
        '��',	'��',	'��',	'��',	'��',
        '��',	'��',	'��',	'��',	'��',
        '��',	'��',	'��',	'��',	'��',
        '��',	'��',		'��',	'��',
        '��',	'��',	'��',	'��',	'��',
        '��',	'��',	'��',	'��',	'��',
        '§',	'¨',		'ª',	'«',
        'ħ',	'Ĩ', 	'ĩ',	'Ī',	'ī',
        '̧',	'̨',	'̩',	'̪',	'̫',
        '�ާ',	'�ި',		'�ު',	'�ޫ',
        '�ާ',	'�ި',	'�ީ',	'�ު',	'�ޫ',
        '�ާ',	'�ި',	'�ީ',	'�ު',	'�ޫ',
        '��',	'��',	'��', 	'��',	'��',
        '��',		'��',		'��',
        '��',	'��',	'��',	'��',	'��',
        '��',	'��',	'��',	'��',	'��',
        'ì',	'è',	'í',	'ê',	'î',
        'Ƭ',	'ƨ',	'ƭ',	'ƪ',	'Ʈ',
        'ˬ',	'˨',	'˭',	'˪',	'ˮ',
        'Ь',	'Ш',	'Э',	'Ъ',	'Ю',
        'ج',	'ب',	'ح',	'ت',	'خ',
        '�ެ',	'�ި',	'�ޭ',	'�ު',	'�ޮ',
        '�ެ',	'�ި',	'�ޭ',	'�ު',	'�ޮ',
        '�ެ',	'�ި',	'�ޭ',	'�ު',	'�ޮ',
        '�ެ',	'�ި',	'�ޭ',	'�ު',	'�ޮ',
        '�ެ',	'�ި',	'�ޭ',	'�ު',	'�ޮ',
        '�߬',	'�ߨ',	'�߭',	'�ߪ',	'�߮',
        '�',	'�', 	'�',	'�',	'�',
        '�',		'�',		'�',
        '�',
        '�',	'�',	'�',
        '!',	'"',	'#',	'$',	'%',
        '&',	'''',	'(',	')',	'=',
        '^',	'~',	'\',	'|',	'�',
        '{',	'@',	'`',	'�',	'}',
        ':',	'*',	';',	'+',	'_',
        '�',	'?',	'�',	'>',	'�',
        '<',	'/',    '.',
        '0',	'1',	'2',	'3',	'4',
        '5',	'6',	'7',	'8',	'9'
       );
  Roma_Area : TNAMEAREA_1 =
       (
        'A',	'I',	'U',	'E',	'O',
        'KA',	'KI',	'KU',	'KE',	'KO',
        'SA',	'SHI',	'SU', 	'SE',	'SO',
        'TA',	'CHI',	'TSU',	'TE',	'TO',
        'NA',	'NI',	'NU',	'NE',	'NO',
        'HA',	'HI',	'FU',	'HE',	'HO',
        'MA',	'MI',	'MU',	'ME',	'MO',
        'YA',		'YU',		'YO',
        'RA',	'RI',	'RU',	'RE',	'RO',
        'WA',	'WO',			'N',
        		'VU',
        'GA',	'GI',	'GU',	'GE',	'GO',
        'ZA',	'JI',	'ZU',	'ZE',	'ZO',
        'DA',	'DI',	'DU',	'DE',	'DO',
        'BA',	'BI',	'BU',	'BE',	'BO',
        'PA',	'PI',	'PU',	'PE',	'PO',
        'WHA',	'WHI',		'WHE',	'WHO',
        'QWA',	'QWI',	'QWU',	'QWE',	'QWO',
        'SWA',	'SWI',	'SWU',	'SWE',	'SWO',
        'TSA',	'TSI',		'TSE',	'TSO',
        'TWA',	'TWI',	'TWU',	'TWE',	'TWO',
        'FWA',	'FWI',	'FWU',	'FWE',	'FWO',
        'VA',	'VI',		'VE',	'VO',
        'GWA',	'GWI',	'GWU',	'GWE',	'GWO',
        'DWA',	'DWI',	'DWU',	'DWE',	'DWO',
        'KYA',	'KYI',	'KYU',	'KYE',	'KYO',
        'QYA',		'QYU',		'QYO',
        'SYA',	'SYI',	'SYU',	'SYE',	'SYO',
        'CHA',	'CYI',	'CHU',	'CHE',	'CHO',
        'THA',	'THI',	'THU',	'THE',	'THO',
        'NYA',	'NYI',	'NYU',	'NYE',	'NYO',
        'HYA',	'HYI',	'HYU',	'HYE',	'HYO',
        'MYA',	'MYI',	'MYU',	'MYE',	'MYO',
        'RYA',	'RYI',	'RYU',	'RYE',	'RYO',
        'GYA',	'GYI',	'GYU',	'GYE',	'GYO',
        'JYA',	'JYI',	'JYU',	'JYE',	'JYO',
        'DYA',	'DYI',	'DYU',	'DYE',	'DYO',
        'DHA',	'DHI',	'DHU',	'DHE',	'DHO',
        'BYA',	'BYI',	'BYU',	'BYE',	'BYO',
        'PYA',	'PYI',	'PYU',	'PYE',	'PYO',
        'LA',	'LI',	'LU',	'LE',	'LO',
        'LYA',		'LYU',		'LYO',
        'LTU',
        '�',	'�',	'-',
        '!',	'"',	'#',	'$',	'%',
        '&',	'''',	'(',	')',	'=',
        '^',	'~',	'\',	'|',	'�',
        '{',	'@',	'`',	'�',	'}',
        ':',	'*',	';',	'+',	'_',
        '�',	'?',	'�',	'>',	'�',
        '<',	'/',    '.',
        '0',	'1',	'2',	'3',	'4',
        '5',	'6',	'7',	'8',	'9'
       );
begin
  Result := '';
  arg_Kana := Trim(arg_Kana);
  w_Roma := '';
  w_LTU := False;

  w_i := 1;
  while w_i <= (Length(arg_Kana)) do
  begin
    w_Get_Kana := Copy(arg_Kana,w_i,1);
    w_After_Kana := Copy(arg_Kana,w_i+1,1);
    w_Before_Kana := Copy(arg_Kana,w_i-1,1);
    w_ii := w_i;
    //�u��v�͎��ŏ�������̂Ŕ�΂�
    if (w_Get_Kana = '�') then begin
      if w_LTU = True then begin
        w_Roma := w_Roma + 'LTU';
      end;
      w_LTU := True;
      w_i := w_i + 1;
      Continue;
    end;
    //�uށv�A�u߁v�͌������ď�������
    if (w_After_Kana = '�') or (w_After_Kana = '�') then begin
      w_Get_Kana := w_Get_Kana + w_After_Kana;
      w_i := w_i + 1;
      //�X�ɂ��̎�������
      w_After_Kana := Copy(arg_Kana,w_i+1,1);
    end;
    //�u��v�u��v�u��v�u��v�u��v
    //�u��v�u��v�u��v�u��v�u��v
    //�͌������ď�������
    if (w_After_Kana = '�') or
       (w_After_Kana = '�') or
       (w_After_Kana = '�') or
       (w_After_Kana = '�') or
       (w_After_Kana = '�') or
       (w_After_Kana = '�') or
       (w_After_Kana = '�') or
       (w_After_Kana = '�') then begin
      w_Get_Kana := w_Get_Kana + w_After_Kana;
      w_i := w_i + 1;
      //�X�ɂ��̎�������
      w_After_Kana := Copy(arg_Kana,w_i+1,1);
    end;

    w_Get_Roma := '';
    for w_t := 1 to Kana_Area_Max do begin
      if Kana_Area[w_t] = w_Get_Kana then begin
        w_Get_Roma := Roma_Area[w_t];
        Break;
      end;
    end;
    if w_Get_Roma = '' then begin
      if w_ii <> w_i then begin
        w_i := w_ii;
        w_Get_Kana := Copy(arg_Kana,w_i,1);
        for w_t := 1 to Kana_Area_Max do begin
          if Kana_Area[w_t] = w_Get_Kana then begin
            w_Get_Roma := Roma_Area[w_t];
            Break;
          end;
        end;
      end;
    end;

    if w_Get_Roma = '' then begin
      if w_LTU = True then begin
        w_Get_Roma := 'LTU';
        w_LTU := False;
      end;
      w_Get_Roma := w_Get_Roma + ' ';
    end
    else begin
      if w_LTU = True then begin
        w_Get_Roma := Copy(w_Get_Roma, 1, 1) + w_Get_Roma;
        w_LTU := False;
      end;
      //�O�Ɂu݁v�������āA�ꉹ�̏ꍇ
      if (w_Before_Kana = '�') and
         ((w_Get_Kana = '�') or
          (w_Get_Kana = '�') or
          (w_Get_Kana = '�') or
          (w_Get_Kana = '�') or
          (w_Get_Kana = '�') ) then begin
        w_Get_Roma := 'N' + w_Get_Roma;
      end;
    end;

    //����
    w_Roma := w_Roma + w_Get_Roma;

    //����
    w_i := w_i + 1;
  end;

  //�Ō�ɯ���c���Ă��鎞
  if w_LTU = True then begin
    w_Roma := w_Roma + 'LTU';
  end;

  Result := Trim(w_Roma);
end;
//�J�^�J�i�����[�}���ϊ���������������������������������������������������������


//�����g�p���@�\�i��O�L�j�F���ݔԍ�+1�擾
function func_Get_NumberControl(
         arg_Database:TDatabase;
         arg_Query:TQuery;
         arg_Kubun:string;
         arg_Date:string
         ):integer;
var
  w_NO: integer;
  w_Date: string;
  w_Sys_Date: string;
  w_Year: string;
begin
  Result := 0;
  w_NO := 0;
  //�w��敪�Ȃ��̓G���[
  if arg_Kubun = '' then
    Exit;
  //���t�Ǘ�����̓V�X�e�����t�ɂ���
  if arg_Date <> '' then
    arg_Date := FormatDateTime('YYYY/MM/DD', func_GetDBSysDate(arg_Query));
  //��t���͔N�x�ɂ��؂�ւ��邽�ߓ��t�Ǘ��ɂ���
  if arg_Kubun = 'UNO' then
    arg_Date := FormatDateTime('YYYY/MM/DD', func_GetDBSysDate(arg_Query));
{2002.11.22
  //��t����20001�`
  if arg_Kubun = 'UNO' then
    w_NO := 20000;
2002.11.22}
  //12�Ԃ�601�`
  if arg_Kubun = 'S12' then
    w_NO := 600;
  //13�Ԃ�401�`
  if arg_Kubun = 'S13' then
    w_NO := 400;
  //15�Ԃ�101�`
  if arg_Kubun = 'S15' then
    w_NO := 100;
  //16�Ԃ�501�`
  if arg_Kubun = 'S16' then
    w_NO := 500;
  //17�Ԃ�201�`
  if arg_Kubun = 'S17' then
    w_NO := 200;
  //19�Ԃ�301�`
  if arg_Kubun = 'S19' then
    w_NO := 300;
  //�~�}��901�`
  if arg_Kubun = 'S99' then
    w_NO := 900;
//�ԍ��Ǘ����w��敪�̌��ݔԍ��{�P�����߂�
  arg_Database.StartTransaction;
  try
    with arg_Query do begin
      Close;
      SQL.Clear;
      SQL.Add ('SELECT ');
      SQL.Add (' nb.* ');
      SQL.Add (' FROM NUMBERCONTROLTABLE nb ');
      SQL.Add (' WHERE nb.KANRI_ID = :PKANRI_ID ');
      SQL.Add (' for update ');
      if not Prepared then Prepare;
      ParamByName('PKANRI_ID').AsString := arg_Kubun;
      //Open;
      //First;
      ExecSQL;
    end;
    with arg_Query do begin
      Close;
      SQL.Clear;
      SQL.Add ('SELECT ');
      SQL.Add (' nb.* ');
      SQL.Add (' FROM NUMBERCONTROLTABLE nb ');
      SQL.Add (' WHERE nb.KANRI_ID = :PKANRI_ID ');
      if not Prepared then Prepare;
      ParamByName('PKANRI_ID').AsString := arg_Kubun;
      Open;
      First;
    end;
//...���R�[�h����
    if not(arg_Query.Eof) then begin
      //...���t�Ǘ��Ȃ�
      if arg_Date = '' then begin
        if arg_Query.FieldByName('NOW_NO').AsString <> '' then begin
          w_NO := arg_Query.FieldByName('NOW_NO').AsInteger;
          //+1����
          w_NO := w_NO + 1;
        end;
      end
    //...���t�Ǘ�����
      else begin
{2002.11.22
        //�u��t���v�͔N�x�ɂ��؂�ւ���
        if arg_Kubun = 'UNO' then begin
          if arg_Query.FieldByName('UPDATEDATE').AsString <> '' then begin
            w_Year := FormatDateTime('YYYY', arg_Query.FieldByName('UPDATEDATE').AsDateTime);
            //�N���قȂ�ꍇ�͐V���Ɏn�߂�
            if w_Year <> Copy(arg_Date,1,4) then begin
              //+1����
              w_NO := w_NO + 1;
            end
            //�N�������ꍇ�͌��Ɂ{�P����
            else begin
              w_NO := arg_Query.FieldByName('NOW_NO').AsInteger;
              //+1����
              w_NO := w_NO + 1;
            end;
          end
          else begin
            //+1����
            w_NO := w_NO + 1;
          end;
        end
        //�ʏ�
        else begin
          if arg_Query.FieldByName('UPDATEDATE').AsString <> '' then begin
            w_Date := FormatDateTime('YYYY/MM/DD', arg_Query.FieldByName('UPDATEDATE').AsDateTime);
            //���t���قȂ�ꍇ�͐V���Ɏn�߂�
            if w_Date <> arg_Date then begin
              //+1����
              w_NO := w_NO + 1;
            end
            //���t�������ꍇ�͌��Ɂ{�P����
            else begin
              w_NO := arg_Query.FieldByName('NOW_NO').AsInteger;
              //+1����
              w_NO := w_NO + 1;
            end;
          end
          else begin
            //+1����
            w_NO := w_NO + 1;
          end;
        end;
2002.11.22}
        if arg_Query.FieldByName('UPDATEDATE').AsString <> '' then begin
          w_Date := FormatDateTime('YYYY/MM/DD', arg_Query.FieldByName('UPDATEDATE').AsDateTime);
          //���t���قȂ�ꍇ�͐V���Ɏn�߂�
          if w_Date <> arg_Date then begin
            //+1����
            w_NO := w_NO + 1;
          end
          //���t�������ꍇ�͌��Ɂ{�P����
          else begin
            w_NO := arg_Query.FieldByName('NOW_NO').AsInteger;
            //+1����
            w_NO := w_NO + 1;
          end;
        end
        else begin
          //+1����
          w_NO := w_NO + 1;
        end;
      end;
      if w_NO <= 0 then begin
        arg_Database.Rollback; // �R�~�b�g�Ŏ��s�����ꍇ�C�ύX��������
        Exit;
      end;
      //�ԍ��Ǘ��e�[�u���X�V
      w_Sys_Date := FormatDateTime('YYYY/MM/DD', func_GetDBSysDate(arg_Query));
      if not func_NumberControl_Update(arg_Database, arg_Query, 2, arg_Kubun, w_Sys_Date, w_NO) then begin
        arg_Database.Rollback; // �R�~�b�g�Ŏ��s�����ꍇ�C�ύX��������
        Exit;
      end;
      arg_Database.Commit; // ���������ꍇ�C�ύX���R�~�b�g����
    end
//...���R�[�h�Ȃ�
    else begin
      //���R�[�h���Ȃ��ꍇ�͐V���Ɏn�߂�
      //+1����
      w_NO := w_NO + 1;
      //�ԍ��Ǘ��e�[�u���ǉ�
      w_Sys_Date := FormatDateTime('YYYY/MM/DD', func_GetDBSysDate(arg_Query));
      if not func_NumberControl_Update(arg_Database, arg_Query, 1, arg_Kubun, w_Sys_Date, w_NO) then begin
        arg_Database.Rollback; // �R�~�b�g�Ŏ��s�����ꍇ�C�ύX��������
        Exit;
      end;
      arg_Database.Commit; // ���������ꍇ�C�ύX���R�~�b�g����
    end;
  except
    on E: Exception do begin
      arg_Database.Rollback; // ���s�����ꍇ�C�ύX��������
      Exit;
    end;
  end;
  //
  Result := w_NO;
end;
//�����g�p���@�\�i��O�L�j�F���ݔԍ��X�V
function func_NumberControl_Update(
         arg_Database:TDatabase;
         arg_Query:TQuery;
         arg_Mode:integer;
         arg_Kubun:string;
         arg_UpdateDate:string;
         arg_Now_NO:integer
         ):Boolean;
begin
  Result := False;
  if (arg_Mode <> 1) and  //�ǉ�
     (arg_Mode <> 2) then //�C��
    Exit;
//�X�V�J�n
//  arg_Database.StartTransaction;
  try
{
    with arg_Query do begin
      Close;
      SQL.Clear;
      SQL.Add ('SELECT ');
      SQL.Add (' nb.* ');
      SQL.Add (' FROM NUMBERCONTROLTABLE nb ');
      SQL.Add (' WHERE nb.KANRI_ID = :PKANRI_ID ');
      SQL.Add (' for update ');
      if not Prepared then Prepare;
      ParamByName('PKANRI_ID').AsString := arg_Kubun;
      //Open;
      //First;
      ExecSQL;
    end;
}
    //�ǉ�����
    if arg_Mode = 1 then begin
      with arg_Query do begin
        Close;
        SQL.Clear;
        SQL.Add ('INSERT INTO NUMBERCONTROLTABLE ');
        SQL.Add ('(');
        SQL.Add (' KANRI_ID,');
        SQL.Add (' UPDATEDATE,');
        SQL.Add (' NOW_NO ');
        SQL.Add (') VALUES ( ');
        SQL.Add (' :PKANRI_ID,');
        SQL.Add (' :PUPDATEDATE,');
        SQL.Add (' :PNOW_NO ');
        SQL.Add (')');
        if not Prepared then Prepare;
        ParamByName('PKANRI_ID').AsString := arg_Kubun;
        ParamByName('PUPDATEDATE').AsDate := func_StrToDate(arg_UpdateDate);
        ParamByName('PNOW_NO').AsInteger  := arg_Now_NO;
        ExecSQL;
      end;
    end
    //�C������
    else begin
      with arg_Query do begin
        Close;
        SQL.Clear;
        SQL.Add('UPDATE NUMBERCONTROLTABLE SET ');
        SQL.Add(' UPDATEDATE = :PUPDATEDATE ');
        SQL.Add(',NOW_NO = :PNOW_NO ');
        SQL.Add('WHERE ');
        SQL.Add(' KANRI_ID = :PKEYCODE ');
        if not Prepared then Prepare;
        ParamByName('PUPDATEDATE').AsDate := func_StrToDate(arg_UpdateDate);
        ParamByName('PNOW_NO').AsInteger  := arg_Now_NO;
        //�L�[
        ParamByName('PKEYCODE').AsString  := arg_Kubun;
        ExecSQL;
      end;
    end;
{
    try
      arg_Database.Commit; // ���������ꍇ�C�ύX���R�~�b�g����
    except
      on E: Exception do begin
        arg_Database.Rollback; // �R�~�b�g�Ŏ��s�����ꍇ�C�ύX��������
        Exit;
      end;
    end;
}
  except
    on M:T_ESysExcep do begin
//      arg_Database.Rollback; // �R�~�b�g�Ŏ��s�����ꍇ�C�ύX��������
      Exit;
    end;
    on E: Exception do begin
//      arg_Database.Rollback; // ���s�����ꍇ�C�ύX��������
      Exit;
    end;
  end;
//����
  Result := True;
end;
//�ԍ��Ǘ��e�[�u�����ݔԍ��ҏW������������������������������������������
//2001.09.07
//���@�\�i��O���j�F���ނ𖼑O�ɕϊ��o�^ ��v���
function func_PIND_Change_KAIKEI(arg_Code:string):string;//����
var
   w_Res:string;
begin
  //arg_Code = '0'
  if arg_Code = GPCST_KAIKEITYPE_0 then
    //'�㎖'
    w_Res := GPCST_KAIKEITYPE_0_NAME
  //arg_Code = '1'
  else if arg_Code = GPCST_KAIKEITYPE_1 then
    //'����'
    w_Res := GPCST_KAIKEITYPE_1_NAME
  //arg_Code = '2'
  else if arg_Code = GPCST_KAIKEITYPE_2 then
    //'�Z��'
    w_Res := GPCST_KAIKEITYPE_2_NAME
  //arg_Code = '3'
  else if arg_Code = GPCST_KAIKEITYPE_3 then
    //'����'
    w_Res := GPCST_KAIKEITYPE_3_NAME
  //arg_Code = '�㎖'
  else if arg_Code = GPCST_KAIKEITYPE_0_NAME then
    //'0'
    w_Res := GPCST_KAIKEITYPE_0
  //arg_Code = '����'
  else if arg_Code = GPCST_KAIKEITYPE_1_NAME then
    //'1'
    w_Res := GPCST_KAIKEITYPE_1
  //arg_Code = '�Z��'
  else if arg_Code = GPCST_KAIKEITYPE_2_NAME then
    //'2'
    w_Res := GPCST_KAIKEITYPE_2
  //arg_Code = '����'
  else if arg_Code = GPCST_KAIKEITYPE_3_NAME then
    //'3'
    w_Res := GPCST_KAIKEITYPE_3
  else
    w_Res:= '';
  result:=w_Res;
end;
//2001.09.10
//���@�\�i��O���j�F���ނ𖼑O�ɕϊ��o�^ �A��w��
function func_PIND_Change_KITAKU(arg_Code:string):string;//����
var
   w_Res:string;
begin
  //arg_Code = '0'
  if arg_Code = GPCST_KITAKU_0 then
    //'���A��'
    w_Res := GPCST_KITAKU_0_NAME
  //arg_Code = '1'
  else if arg_Code = GPCST_KITAKU_1 then
    //'�A���'
    w_Res := GPCST_KITAKU_1_NAME
  //arg_Code = '���A��'
  else if arg_Code = GPCST_KITAKU_0_NAME then
    //'0'
    w_Res := GPCST_KITAKU_0
  //arg_Code = '�A���'
  else if arg_Code = GPCST_KITAKU_1_NAME then
    //'1'
    w_Res := GPCST_KITAKU_1
  //arg_Code = ''
  else if arg_Code = '' then
    //'���A��'
    w_Res := GPCST_KITAKU_0_NAME
  else
    w_Res := '';
  result:=w_Res;
end;
//2001.09.10
//���@�\�i��O���j�F���ނ𖼑O�ɕϊ��o�^ �a�@�A��TEL
function func_PIND_Change_TEL(arg_Code:string):string;//����
var
   w_Res:string;
begin
  //arg_Code = '0'
  if arg_Code = GPCST_TEL_0 then
    //'��'
    w_Res := GPCST_TEL_0_NAME
  //arg_Code = '1'
  else if arg_Code = GPCST_TEL_1 then
    //'�v'
    w_Res := GPCST_TEL_1_NAME
  //arg_Code = '��'
  else if arg_Code = GPCST_TEL_0_NAME then
    //'0'
    w_Res := GPCST_TEL_0
  //arg_Code = '�v'
  else if arg_Code = GPCST_TEL_1_NAME then
    //'1'
    w_Res := GPCST_TEL_1
  //arg_Code = ''
  else if arg_Code = '' then
    //'��'
    w_Res := GPCST_TEL_0_NAME
  else
    w_Res := '';
  result:=w_Res;
end;
//2001.09.11
//���@�\�i��O���j�F���ނ𖼑O�ɕϊ��o�^ �����v��
function func_PIND_Change_SYOKEN_YOUHI(arg_Code:string):string;//����
var
   w_Res:string;
begin
  //arg_Code = '0'
  if arg_Code = GPCST_SYOKEN_YOUHI_0 then
    //'�s�v'
    w_Res := GPCST_SYOKEN_YOUHI_0_NAME
  //arg_Code = '1'
  else if arg_Code = GPCST_SYOKEN_YOUHI_1 then
    //'�K�v'
    w_Res := GPCST_SYOKEN_YOUHI_1_NAME
  //arg_Code = '�s�v'
  else if arg_Code = GPCST_SYOKEN_YOUHI_0_NAME then
    //'0'
    w_Res := GPCST_SYOKEN_YOUHI_0
  //arg_Code = '�K�v'
  else if arg_Code = GPCST_SYOKEN_YOUHI_1_NAME then
    //'1'
    w_Res := GPCST_SYOKEN_YOUHI_1
  //arg_Code = ''
  else if arg_Code = '' then
    //'�s�v'
    w_Res := GPCST_SYOKEN_YOUHI_0_NAME
  else
    w_Res := '';
  result:=w_Res;
end;
//2001.09.13
//���@�\�i��O���j�F���ނ𖼑O�ɕϊ��o�^ �B�e�i��
function func_PIND_Change_SATUEISTATUS(arg_Code:string):string;//����
var
   w_Res:string;
begin
  //arg_Code = '0'
  if arg_Code = GPCST_CODE_SATUEIS_0 then
    //'���B�e'
    w_Res := GPCST_NAME_SATUEIS_0
  //arg_Code = '1'
  else if arg_Code = GPCST_CODE_SATUEIS_1 then
    //'�B�e��'
    w_Res := GPCST_NAME_SATUEIS_1
  //arg_Code = '2'
  else if arg_Code = GPCST_CODE_SATUEIS_2 then
    //'���~'
    w_Res := GPCST_NAME_SATUEIS_2
  //arg_Code = '���B�e'
  else if arg_Code = GPCST_NAME_SATUEIS_0 then
    //'0'
    w_Res := GPCST_CODE_SATUEIS_0
  //arg_Code = '�B�e��'
  else if arg_Code = GPCST_NAME_SATUEIS_1 then
    //'1'
    w_Res := GPCST_CODE_SATUEIS_1
  //arg_Code = '���~'
  else if arg_Code = GPCST_NAME_SATUEIS_2 then
    //'2'
    w_Res := GPCST_CODE_SATUEIS_2
  else
    w_Res := '';
  result:=w_Res;
end;
//2001.09.13
//���@�\�i��O���j�F���ނ𖼑O�ɕϊ��o�^ �摜�m�F
function func_PIND_Change_GAZOU_KAKUNIN(arg_Code:string):string;//����
var
   w_Res:string;
begin
  //arg_Code = '0'
  if arg_Code = GPCST_GAZOU_KAKUNIN_0 then
    //'��'
    w_Res := GPCST_GAZOU_KAKUNIN_0_NAME
  //arg_Code = '1'
  else if arg_Code = GPCST_GAZOU_KAKUNIN_1 then
    //'��'
    w_Res := GPCST_GAZOU_KAKUNIN_1_NAME
  //arg_Code = '��'
  else if arg_Code = GPCST_GAZOU_KAKUNIN_0_NAME then
    //'0'
    w_Res := GPCST_GAZOU_KAKUNIN_0
  //arg_Code = '��'
  else if arg_Code = GPCST_GAZOU_KAKUNIN_1_NAME then
    //'1'
    w_Res := GPCST_GAZOU_KAKUNIN_1
  //arg_Code = ''
  else if arg_Code = '' then
    //'��'
    w_Res := GPCST_GAZOU_KAKUNIN_0_NAME
  else
    w_Res := '';
  result:=w_Res;
end;
//2001.09.20
//���@�\�i��O���j�F���ނ𖼑O�ɕϊ��o�^ �A��w��
function func_PIND_Change_KITAKU_G(arg_Code:string):string;//����
var
   w_Res:string;
begin
  //arg_Code = '0'
  if arg_Code = GPCST_KITAKU_0_G then
    //'��'
    w_Res := GPCST_KITAKU_0_NAME_G
  //arg_Code = '1'
  else if arg_Code = GPCST_KITAKU_1_G then
    //'�A'
    w_Res := GPCST_KITAKU_1_NAME_G
  //arg_Code = '��'
  else if arg_Code = GPCST_KITAKU_0_NAME_G then
    //'0'
    w_Res := GPCST_KITAKU_0_G
  //arg_Code = '�A'
  else if arg_Code = GPCST_KITAKU_1_NAME_G then
    //'1'
    w_Res := GPCST_KITAKU_1_G
  //arg_Code = ''
  else if arg_Code = '' then
    //'��'
    w_Res := GPCST_KITAKU_0_NAME_G
  else
    w_Res := '';
  result:=w_Res;
end;
//2001.09.20
//���@�\�i��O���j�F���ނ𖼑O�ɕϊ��o�^ �a�@�A��TEL
function func_PIND_Change_TEL_G(arg_Code:string):string;//����
var
   w_Res:string;
begin
  //arg_Code = '0'
  if arg_Code = GPCST_TEL_0_G then
    //'��'
    w_Res := GPCST_TEL_0_NAME_G
  //arg_Code = '1'
  else if arg_Code = GPCST_TEL_1_G then
    //'�v'
    w_Res := GPCST_TEL_1_NAME_G
  //arg_Code = ''
  else if arg_Code = GPCST_TEL_0_NAME_G then
    //'0'
    w_Res := GPCST_TEL_0_G
  //arg_Code = 'TEL'
  else if arg_Code = GPCST_TEL_1_NAME_G then
    //'1'
    w_Res := GPCST_TEL_1_G
  //arg_Code = ''
  else if arg_Code = '' then
    //''
    w_Res := GPCST_TEL_0_NAME_G
  else
    w_Res := '';
  result:=w_Res;
end;
//2001.09.20
//���@�\�i��O���j�F���ނ𖼑O�ɕϊ��o�^ �摜�m�F
function func_PIND_Change_GAZOU_KAKUNIN_G(arg_Code:string):string;//����
var
   w_Res:string;
begin
  //arg_Code = '0'
  if arg_Code = GPCST_GAZOU_KAKUNIN_0_G then
    //'��'
    w_Res := GPCST_GAZOU_KAKUNIN_0_NAME_G
  //arg_Code = '1'
  else if arg_Code = GPCST_GAZOU_KAKUNIN_1_G then
    //'��'
    w_Res := GPCST_GAZOU_KAKUNIN_1_NAME_G
  //arg_Code = '��'
  else if arg_Code = GPCST_GAZOU_KAKUNIN_0_NAME_G then
    //'0'
    w_Res := GPCST_GAZOU_KAKUNIN_0_G
  //arg_Code = '��'
  else if arg_Code = GPCST_GAZOU_KAKUNIN_1_NAME_G then
    //'1'
    w_Res := GPCST_GAZOU_KAKUNIN_1_G
  //arg_Code = ''
  else if arg_Code = '' then
    //'��'
    w_Res := GPCST_GAZOU_KAKUNIN_0_NAME_G
  else
    w_Res := '';
  result:=w_Res;
end;

//2001/09/17
//���@�\�i��O���j�F�v�����^�^�C�v���擾
function func_Get_PrintType(arg_Type:String):String;//����
var
   w_Res:string;
begin
  w_Res:='';

  //���[�U�[
  if arg_Type = '1' then
     w_Res:=GPCST_PRI_TYPE_01;
  //���x��
  if arg_Type = '2' then
     w_Res:=GPCST_PRI_TYPE_02;
  //�h�b�g�C���p�N�g
  if arg_Type = '3' then
     w_Res:=GPCST_PRI_TYPE_03;

  result:=w_Res;
end;
//2001.09.25
//���@�\�i��O���j�F�S������̑S�p�`�F�b�N
function func_ALL_ZENKAKU_CHECK(arg_text: string):Boolean;
var
  i: integer;
  r: Boolean;
begin
  r := True;
  for i := 1 to Length(Trim(arg_text)) do begin
    if StrByteType(PChar(Trim(arg_text)), i-1) = mbSingleByte then begin
      r := False;
      Break;
    end;
  end;
  Result := r;
end;
//���@�\�i��O���j�F�S������̔��p�`�F�b�N
function func_ALL_HANKAKU_CHECK(arg_text: string):Boolean;
var
  i: integer;
  r: Boolean;
begin
  r := True;
  for i := 1 to Length(Trim(arg_text)) do begin
    if (StrByteType(PChar(Trim(arg_text)), i-1) = mbLeadByte)  or
       (StrByteType(PChar(Trim(arg_text)), i-1) = mbTrailByte) then begin
      r := False;
      Break;
    end;
  end;
  Result := r;
end;
//2002.11.18
//���@�\�i��O���j�F�S������̔��p�`�F�b�N
function func_ALL_HANKAKU_AISUU_CHECK(arg_text: string):Boolean;
var
  i: integer;
  r: Boolean;
  s: String;
begin
  r := True;
  for i := 1 to Length(Trim(arg_text)) do begin
    if (StrByteType(PChar(Trim(arg_text)), i-1) = mbLeadByte)  or
       (StrByteType(PChar(Trim(arg_text)), i-1) = mbTrailByte) then begin
      r := False;
      Break;
    end else begin
      s := Copy(Trim(arg_text), i, 1);
//      if (PChar(s) < #48)
//      or ((PChar(s) > #57) and (PChar(s) < #65))
//      or ((PChar(s) > #90) and (PChar(s) < #97))
//      or (PChar(s) > #122) then begin
      if (PChar(s) < #32)
      or (PChar(s) > #126) then begin
        r := False;
        Break;
      end;
    end;
  end;
  Result := r;
end;

//2002.09.20
//���@�\�i��O���j�F���ނ𖼑O�ɕϊ��o�^ �F�֗v��
function func_PIND_Change_COLOR_YOUHI(arg_Code:string):string;//����
var
   w_Res:string;
begin
  //arg_Code = '0'
  if arg_Code = GPCST_COLOR_YOUHI_0 then
    //'�s�v'
    w_Res := GPCST_COLOR_YOUHI_0_NAME
  //arg_Code = '1'
  else if arg_Code = GPCST_COLOR_YOUHI_1 then
    //'�K�v'
    w_Res := GPCST_COLOR_YOUHI_1_NAME
  //arg_Code = '�s�v'
  else if arg_Code = GPCST_COLOR_YOUHI_0_NAME then
    //'0'
    w_Res := GPCST_COLOR_YOUHI_0
  //arg_Code = '�K�v'
  else if arg_Code = GPCST_COLOR_YOUHI_1_NAME then
    //'1'
    w_Res := GPCST_COLOR_YOUHI_1
  //arg_Code = ''
  else if arg_Code = '' then
    //'�s�v'
    w_Res := GPCST_COLOR_YOUHI_0_NAME
  else
    w_Res := '';
  result:=w_Res;
end;
//2002.09.24
//���@�\�i��O���j�F���ނ𖼑O�ɕϊ��o�^ ���E�g�p
function func_PIND_Change_SAYUU(arg_Code:string):string;//����
var
   w_Res:string;
begin
  //arg_Code = '0'
  if arg_Code = GPCST_SAYUU_0 then
    //'�s�v'
    w_Res := GPCST_SAYUU_0_NAME
  //arg_Code = '1'
  else if arg_Code = GPCST_SAYUU_1 then
    //'�K�v'
    w_Res := GPCST_SAYUU_1_NAME
  //arg_Code = '�s�v'
  else if arg_Code = GPCST_SAYUU_0_NAME then
    //'0'
    w_Res := GPCST_SAYUU_0
  //arg_Code = '�K�v'
  else if arg_Code = GPCST_SAYUU_1_NAME then
    //'1'
    w_Res := GPCST_SAYUU_1
  //arg_Code = ''
  else if arg_Code = '' then
    //'�s�v'
    w_Res := GPCST_SAYUU_0_NAME
  else
    w_Res := '';
  result:=w_Res;
end;
//2002.09.24
//���@�\�i��O���j�F���ނ𖼑O�ɕϊ��o�^ �ǉe�v��
function func_PIND_Change_DOKUEI(arg_Code:string):string;//����
var
   w_Res:string;
begin
  //arg_Code = '0'
  if arg_Code = GPCST_DOKUEI_0 then
    //'�s�v'
    w_Res := GPCST_DOKUEI_0_NAME
  //arg_Code = '1'
  else if arg_Code = GPCST_DOKUEI_1 then
    //'�K�v'
    w_Res := GPCST_DOKUEI_1_NAME
  //arg_Code = '2'
  else if arg_Code = GPCST_DOKUEI_2 then
    //'�ȗ�'
    w_Res := GPCST_DOKUEI_2_NAME
  //arg_Code = '�s�v'
  else if arg_Code = GPCST_DOKUEI_0_NAME then
    //'0'
    w_Res := GPCST_DOKUEI_0
  //arg_Code = '�K�v'
  else if arg_Code = GPCST_DOKUEI_1_NAME then
    //'1'
    w_Res := GPCST_DOKUEI_1
  //arg_Code = '�ȗ�'
  else if arg_Code = GPCST_DOKUEI_2_NAME then
    //'2'
    w_Res := GPCST_DOKUEI_2
  //arg_Code = ''
  else if arg_Code = '' then
    //'�s�v'
    w_Res := GPCST_DOKUEI_0_NAME
  else
    w_Res := '';
  result:=w_Res;
end;
//2002.09.24
//���@�\�i��O���j�F���ނ𖼑O�ɕϊ��o�^ ���u���g�p
function func_PIND_Change_SHOTI(arg_Code:string):string;//����
var
   w_Res:string;
begin
  //arg_Code = '0'
  if arg_Code = GPCST_SHOTI_0 then
    //'�s�v'
    w_Res := GPCST_SHOTI_0_NAME
  //arg_Code = '1'
  else if arg_Code = GPCST_SHOTI_1 then
    //'�K�v'
    w_Res := GPCST_SHOTI_1_NAME
  //arg_Code = '�s�v'
  else if arg_Code = GPCST_SHOTI_0_NAME then
    //'0'
    w_Res := GPCST_SHOTI_0
  //arg_Code = '�K�v'
  else if arg_Code = GPCST_SHOTI_1_NAME then
    //'1'
    w_Res := GPCST_SHOTI_1
  //arg_Code = ''
  else if arg_Code = '' then
    //'�s�v'
    w_Res := GPCST_SHOTI_0_NAME
  else
    w_Res := '';
  result:=w_Res;
end;
//2002.12.14
//���@�\�i��O���j�F���ނ𖼑O�ɕϊ��o�^ ���u���g�p�E����
function func_PIND_Change_SHOTI_RYAKU(arg_Code:string):string;//����
var
   w_Res:string;
begin
  //arg_Code = '0'
  if arg_Code = GPCST_SHOTI_0 then
    //'�s�v'
    w_Res := GPCST_SHOTI_0_RYAKU_NAME
  //arg_Code = '1'
  else if arg_Code = GPCST_SHOTI_1 then
    //'�K�v'
    w_Res := GPCST_SHOTI_1_RYAKU_NAME
  //arg_Code = '�s�v'
  else if arg_Code = GPCST_SHOTI_0_RYAKU_NAME then
    //'0'
    w_Res := GPCST_SHOTI_0
  //arg_Code = '�K�v'
  else if arg_Code = GPCST_SHOTI_1_RYAKU_NAME then
    //'1'
    w_Res := GPCST_SHOTI_1
  //arg_Code = ''
  else if arg_Code = '' then
    //'�s�v'
    w_Res := GPCST_SHOTI_0_RYAKU_NAME
  else
    w_Res := '';
  result:=w_Res;
end;
//2002.09.24
//���@�\�i��O���j�F���ނ𖼑O�ɕϊ��o�^ �v���e
function func_PIND_Change_YZOUEI(arg_Code:string):string;//����
var
   w_Res:string;
begin
  //arg_Code = '0'
  if arg_Code = GPCST_YZOUEI_0 then
    //'�s�v'
    w_Res := GPCST_YZOUEI_0_NAME
  //arg_Code = '1'
  else if arg_Code = GPCST_YZOUEI_1 then
    //'�K�v'
    w_Res := GPCST_YZOUEI_1_NAME
  //arg_Code = '�s�v'
  else if arg_Code = GPCST_YZOUEI_0_NAME then
    //'0'
    w_Res := GPCST_YZOUEI_0
  //arg_Code = '�K�v'
  else if arg_Code = GPCST_YZOUEI_1_NAME then
    //'1'
    w_Res := GPCST_YZOUEI_1
  //arg_Code = ''
  else if arg_Code = '' then
    //'�s�v'
    w_Res := GPCST_YZOUEI_0_NAME
  else
    w_Res := '';
  result:=w_Res;
end;

//���@�\�i��O���j�F�O���b�h�J����������������
function func_Grid_ColumnSize_Write(arg_Grid: TStringGrid; arg_Name,arg_No: string):Boolean;
var
  TxtFile: TextFile;
  w_Dir_Name: string;
  w_File_Name: string;
  w_Record: string[255];
  i: integer;
begin
  Result := True;
//  w_File_Name := CST_PATH_GRID_COLUMNS + arg_Name + '_' + arg_No + '.txt';
  w_File_Name := gi_columndir_DIR + arg_Name + '_' + arg_No + '.txt';
  w_Dir_Name  := ExtractFileDir(w_File_Name);
  if not(DirectoryExists(w_Dir_Name)) then begin
    if not(CreateDir(w_Dir_Name)) then begin
      //raise Exception.Create('Cannot Create ' + w_Dir_Name);
      Exit;
    end;
  end;

  w_Record := '';
  for i := 0 to (arg_Grid.ColCount - 1) do begin
    w_Record := w_Record + IntToStr(arg_Grid.ColWidths[i]) + ',';
  end;
  if Length(w_Record) > 0 then begin
    w_Record := Copy(w_Record, 1, Length(w_Record) - 1);
  end;
  //��������
  try
    AssignFile(TxtFile, w_File_Name);
    Rewrite(TxtFile);
    try
      Writeln(TxtFile, w_Record);
    finally
      Flush(TxtFile);
      CloseFile(TxtFile);
    end;
  except
    raise Exception.Create('Cannot AssignFile ' + w_File_Name);
  end;
end;


//���@�\�i��O���j�F�O���b�h�J��������ǂݍ���
procedure proc_Grid_ColumnSize_Read(arg_Grid: TStringGrid; arg_Name,arg_No: string; var arg_Column: TStringList);
var
  TxtFile: TextFile;
  w_File_Name: string;
  w_Record: string[255];
  w_Grid_Size: TStringList;
  w_Text_Size: TStringList;
  i: integer;
begin
//  w_File_Name := CST_PATH_GRID_COLUMNS + arg_Name + '_' + arg_No + '.txt';
  w_File_Name := gi_columndir_DIR + arg_Name + '_' + arg_No + '.txt';
  w_Grid_Size := TStringList.Create;
  w_Text_Size := TStringList.Create;
  try
    for i := 0 to (arg_Grid.ColCount - 1) do begin
      w_Grid_Size.Add(IntToStr(arg_Grid.ColWidths[i]));
    end;
    if FileExists(w_File_Name) then begin
      //�P�s�̂ݓǂݍ���
      try
        AssignFile(TxtFile, w_File_Name);
        Reset(TxtFile);
        try
          while not Eof(TxtFile) do
          begin
            Readln(TxtFile, w_Record);
            //�ǂݍ��񂾍s���ް������݂���ꍇ
            if Length(Trim(w_Record)) > 0 then
            begin
              w_Text_Size.CommaText := w_Record;
              Break;
            end;
          end;
        finally
          CloseFile(TxtFile);
        end;
      except
        raise Exception.Create('Cannot AssignFile ' + w_File_Name);
      end;
    end;
    //�J��������߂�
    if w_Grid_Size.Count <> w_Text_Size.Count then begin
      arg_Column.Text := w_Grid_Size.Text;
      Exit;
    end;
    arg_Column.Text := w_Text_Size.Text;
    Exit;
  finally
    w_Grid_Size.Free;
    w_Text_Size.Free;
  end;
end;
//���@�\�i��O���j�F�O���b�h�J���������Z�b�g����
procedure proc_Grid_ColumnSize_Set(arg_Grid: TStringGrid; arg_Name,arg_No: string);
var
  w_Cols: TStringList;
  w_Col: integer;
begin
  w_Cols := TStringList.Create;
  try
    //�J�������ǂݍ���
    proc_Grid_ColumnSize_Read(arg_Grid, arg_Name, arg_No, w_Cols);
    if w_Cols.Count = arg_Grid.ColCount then begin
      //���ύX
      for w_Col := 0 to (arg_Grid.ColCount - 1) do begin
        arg_Grid.ColWidths[w_Col] := StrToInt(w_Cols.Strings[w_Col]);
      end;
    end
    else begin
      //�J�������i�[
      func_Grid_ColumnSize_Write(arg_Grid, arg_Name, arg_No);
    end;
  finally
    w_Cols.Free;
  end;
end;
//2002.10.03
//���@�\�i��O���j�F���ނ𖼑O�ɕϊ��o�^ ���Ȉ�t����敪
function func_PIND_Change_ISITATIAI(arg_Code:string):string;//����
var
   w_Res:string;
begin
  //arg_Code = '0'
  if arg_Code = GPCST_ISITATIAI_0 then
    //'����Ȃ�'
    w_Res := GPCST_ISITATIAI_0_NAME
  //arg_Code = '1'
  else if arg_Code = GPCST_ISITATIAI_1 then
    //'�����'
    w_Res := GPCST_ISITATIAI_1_NAME
  //arg_Code = '����Ȃ�'
  else if arg_Code = GPCST_ISITATIAI_0_NAME then
    //'0'
    w_Res := GPCST_ISITATIAI_0
  //arg_Code = '�����'
  else if arg_Code = GPCST_ISITATIAI_1_NAME then
    //'1'
    w_Res := GPCST_ISITATIAI_1
  //arg_Code = ''
  else if arg_Code = '' then
    //'����Ȃ�'
    w_Res := GPCST_ISITATIAI_0_NAME
  else
    w_Res := '';
  result:=w_Res;
end;
//2002.12.14
//���@�\�i��O���j�F���ނ𖼑O�ɕϊ��o�^ ���Ȉ�t����敪
function func_PIND_Change_ISITATIAI_RYAKU(arg_Code:string):string;//����
var
   w_Res:string;
begin
  //arg_Code = '0'
  if arg_Code = GPCST_ISITATIAI_0 then
    //'����Ȃ�'
    w_Res := GPCST_ISITATIAI_0_RYAKU
  //arg_Code = '1'
  else if arg_Code = GPCST_ISITATIAI_1 then
    //'�����'
    w_Res := GPCST_ISITATIAI_1_RYAKU
  //arg_Code = '����Ȃ�'
  else if arg_Code = GPCST_ISITATIAI_0_RYAKU then
    //'0'
    w_Res := GPCST_ISITATIAI_0
  //arg_Code = '�����'
  else if arg_Code = GPCST_ISITATIAI_1_RYAKU then
    //'1'
    w_Res := GPCST_ISITATIAI_1
  //arg_Code = ''
  else if arg_Code = '' then
    //'����Ȃ�'
    w_Res := GPCST_ISITATIAI_0_RYAKU
  else
    w_Res := '';
  result:=w_Res;
end;
//2002.10.05
//���@�\�i��O���j�F���ނ𖼑O�ɕϊ��o�^ FCR�A�g
function func_PIND_Change_FCR(arg_Code:string):string;//����
var
   w_Res:string;
begin
  //arg_Code = '0'
  if arg_Code = GPCST_FCR_0 then
    //'�s�v'
    w_Res := GPCST_FCR_0_NAME
  //arg_Code = '1'
  else if arg_Code = GPCST_FCR_1 then
    //'�K�v'
    w_Res := GPCST_FCR_1_NAME
  //arg_Code = '�s�v'
  else if arg_Code = GPCST_FCR_0_NAME then
    //'0'
    w_Res := GPCST_FCR_0
  //arg_Code = '�K�v'
  else if arg_Code = GPCST_FCR_1_NAME then
    //'1'
    w_Res := GPCST_FCR_1
  //arg_Code = ''
  else if arg_Code = '' then
    //'�s�v'
    w_Res := GPCST_FCR_0_NAME
  else
    w_Res := '';
  result:=w_Res;
end;
//2002.10.05
//���@�\�i��O���j�F���ނ𖼑O�ɕϊ��o�^ MPPS�Ή�
function func_PIND_Change_MPPS(arg_Code:string):string;//����
var
   w_Res:string;
begin
  //arg_Code = '0'
  if arg_Code = GPCST_MPPS_0 then
    //'�s�v'
    w_Res := GPCST_MPPS_0_NAME
  //arg_Code = '1'
  else if arg_Code = GPCST_MPPS_1 then
    //'�K�v'
    w_Res := GPCST_MPPS_1_NAME
  //arg_Code = '�s�v'
  else if arg_Code = GPCST_MPPS_0_NAME then
    //'0'
    w_Res := GPCST_MPPS_0
  //arg_Code = '�K�v'
  else if arg_Code = GPCST_MPPS_1_NAME then
    //'1'
    w_Res := GPCST_MPPS_1
  //arg_Code = ''
  else if arg_Code = '' then
    //'�s�v'
    w_Res := GPCST_MPPS_0_NAME
  else
    w_Res := '';
  result:=w_Res;
end;
//���@�\�i��O���j�F���ނ𖼑O�ɕϊ��o�^ �G���[���   2004.01.16
function func_PIND_Change_Err(arg_Code:string):string;//����
var
   w_Res:string;
begin
  //arg_Code = '0'
  if arg_Code = GPCST_ERR_0 then
    //'�s�v'
    w_Res := GPCST_ERR_0_NAME
  //arg_Code = '1'
  else if arg_Code = GPCST_ERR_1 then
    //'�K�v'
    w_Res := GPCST_ERR_1_NAME
  //arg_Code = '�s�v'
  else if arg_Code = GPCST_ERR_0_NAME then
    //'0'
    w_Res := GPCST_ERR_0
  //arg_Code = '�K�v'
  else if arg_Code = GPCST_ERR_1_NAME then
    //'1'
    w_Res := GPCST_ERR_1
  //arg_Code = ''
  else if arg_Code = '' then
    //'�s�v'
    w_Res := GPCST_ERR_0_NAME
  else
    w_Res := '';
  result:=w_Res;
end;
//2002.10.30
//���@�\�i��O���j�F���ނ𖼑O�ɕϊ��o�^ ��v���M���
function func_PIND_Change_KAIKEISOUSIN(arg_Code:string):string;//����
var
   w_Res:string;
begin
  //arg_Code = '0'
  if arg_Code = GPCST_KAIKEI_0 then
    //'���Ȃ�'
    w_Res := GPCST_KAIKEI_0_NAME
  //arg_Code = '1'
  else if arg_Code = GPCST_KAIKEI_1 then
    //'����'
    w_Res := GPCST_KAIKEI_1_NAME
  //arg_Code = '���Ȃ�'
  else if arg_Code = GPCST_KAIKEI_0_NAME then
    //'0'
    w_Res := GPCST_KAIKEI_0
  //arg_Code = '����'
  else if arg_Code = GPCST_KAIKEI_1_NAME then
    //'1'
    w_Res := GPCST_KAIKEI_1
  //arg_Code = ''
  else if arg_Code = '' then
    //'���Ȃ�'
    w_Res := GPCST_KAIKEI_0_NAME
  else
    w_Res := '';
  result:=w_Res;
end;
//2002.11.06
//���@�\�i��O���j�F���ނ𖼑O�ɕϊ��o�^ RI�I�[�_�敪
function func_PIND_Change_RI_ORDER(arg_Code:string):string;//����
var
   w_Res:string;
begin
  //arg_Code = '0'
  if arg_Code = GPCST_RI_ORDER_0 then
    //'�Ȃ�'
    w_Res := GPCST_RI_ORDER_0_NAME
  //arg_Code = '1'
  else if arg_Code = GPCST_RI_ORDER_1 then
    //'����'
    w_Res := GPCST_RI_ORDER_1_NAME
  //arg_Code = '2'
  else if arg_Code = GPCST_RI_ORDER_2 then
    //'����'
    w_Res := GPCST_RI_ORDER_2_NAME
  //arg_Code = '�Ȃ�'
  else if arg_Code = GPCST_RI_ORDER_0_NAME then
    //'0'
    w_Res := GPCST_RI_ORDER_0
  //arg_Code = '����'
  else if arg_Code = GPCST_RI_ORDER_1_NAME then
    //'1'
    w_Res := GPCST_RI_ORDER_1
  //arg_Code = '����'
  else if arg_Code = GPCST_RI_ORDER_2_NAME then
    //'1'
    w_Res := GPCST_RI_ORDER_2
  //arg_Code = ''
  else if arg_Code = '' then
    //'�Ȃ�'
    w_Res := GPCST_RI_ORDER_0_NAME
  else
    w_Res := '';
  result:=w_Res;
end;

//2002.10.21
//2002.10.23 �C�� �����R�����g���ږ����i�[
//���@�\�F������ʖ��̃t�B���^�t���O���ږ��̊i�[�ϐ��Z�b�g
function func_SetKensaTypeFilter_Flg(arg_Query: TQuery):Boolean;
var
  wi_Filter: Integer;
  ws_Count: String;
begin
  wi_Filter := 0;


  try
    with arg_Query do begin
      Close;
      SQL.Clear;
      SQL.Add ('SELECT KENSATYPE_ID ');
      SQL.Add ('FROM KensaTypeMaster ');
      SQL.Add ('ORDER BY KENSATYPE_ID');
      if not Prepared then Prepare;
      Open;
      Last;
      gi_KENSA_TYPE_FIELD_COUNT := RecordCount;

      if gi_KENSA_TYPE_FIELD_COUNT = 0 then begin
        gi_KENSA_TYPE_FIELD_COUNT := -1;
      end else begin
        SetLength(ga_KENSA_TYPE_FEILD, gi_KENSA_TYPE_FIELD_COUNT);

        First;
        //�擾�f�[�^���i�[
        While not EOF do begin
          wi_Filter := wi_Filter + 1;
          ga_KENSA_TYPE_FEILD[wi_Filter-1].Kensa_ID         := FieldByName('KENSATYPE_ID').AsString;
          ws_Count := IntToStr(wi_Filter);
          if Length(ws_Count) = 1 then ws_Count             := '0' + ws_Count;
          ga_KENSA_TYPE_FEILD[wi_Filter-1].FilterName       := 'FILTER_FLG' + ws_Count;
          ga_KENSA_TYPE_FEILD[wi_Filter-1].KensaCommentName := 'KENSA_COMMENT_' + ws_Count;
          Next;
        end;
      end;
      Close;
    end;
    result:=True;
  except
    on E: Exception do begin
      raise;
    end;
  end;
end;
//2002.10.21
//���@�\�F�������ID�Ńt�B���^�t���O���ږ���Ԃ�
function func_GetFilter_Flg_Name(arg_KensaType_ID: String):String;
var
  wi_count: Integer;
begin
  //�Y�����錟�����ID����t�B���^�t���O���ږ����w��
  for wi_count := 0 to gi_KENSA_TYPE_FIELD_COUNT -1 do begin
    if ga_KENSA_TYPE_FEILD[wi_count].Kensa_ID = arg_KensaType_ID then begin
      Result := ga_KENSA_TYPE_FEILD[wi_count].FilterName;
      Break;
    end;
  end;
end;
//2002.10.23
//���@�\�i��O���j�F�������ID�Ō����R�����g���ږ���Ԃ�
function func_GetKensa_Comment_Name(arg_KensaType_ID: String):String;
var
  wi_count: Integer;
begin
  //�Y�����錟�����ID���猟���R�����g���ږ����w��
  for wi_count := 0 to gi_KENSA_TYPE_FIELD_COUNT -1 do begin
    if ga_KENSA_TYPE_FEILD[wi_count].Kensa_ID = arg_KensaType_ID then begin
      Result := ga_KENSA_TYPE_FEILD[wi_count].KensaCommentName;
      Break;
    end;
  end;
end;

//2002.10.22
//���@�\�i��O���j�F����ID��芳�ҏ��擾
function func_KanjaInfo_Make(
         //IN
         arg_Query: TQuery;
         arg_Query2: TQuery;
         arg_KanjaID: string;
         //OUT
         var arg_SimeiKanji: string;      //��������
         var arg_SimeiKana: string;       //�J�i����
         var arg_Sex: string;             //����
         var arg_BirthDay: string;        //���N����
         var arg_Age: string;             //�N��
         var arg_Byoutou_ID: string;      //�a��ID
         var arg_Byoutou: string;         //�a������
         var arg_Byousitu_ID: string;     //�a��ID
         var arg_Byousitu: string;        //�a������
         var arg_Kanja_Nyugaikbn: string; //���ғ��O�敪
         var arg_Kanja_Nyugai: string;    //���ғ��O�敪����
         var arg_Section_ID: string;      //�f�É�ID
         var arg_Section: string;         //�f�É�
         var arg_Sincyo: string;          //�g��
         var arg_Taijyu: string           //�̏d
        ): Boolean;
var
  w_BirthDay: TDate;
  w_Sys_Date: TDateTime;     // �V�X�e�����t
begin
  Result := False;
  //���҃}�X�^��芳�ҏ��擾�擾
  try
    with arg_Query do begin
      Close;
      SQL.Clear;
      SQL.Add ('SELECT km.KANJAID, km.KANJISIMEI, km.ROMASIMEI, km.SEX, km.KANJA_NYUGAIKBN ');
      SQL.Add ('      ,km.SECTION_ID,km.BYOUTOU_ID,km.SINCYO,km.TAIJYU,km.BYOUSITU_ID,km.PROFILE_TYPES ');
      SQL.Add ('      ,Trim(TO_CHAR(km.BIRTHDAY,''00000000'')) BIRTHDAY ');
      SQL.Add ('      ,ku.KUBUN_NAME AS SEX_NAME ');
      SQL.Add ('      ,s1.SECTION_NAME AS SINRYO_NAME ');
      SQL.Add ('      ,KANASIMEI ');   //2003.12.19
      SQL.Add ('FROM  KANJAMASTER km,KUBUNMASTER ku ');
      SQL.Add ('     ,SECTIONMASTER s1 ');
      SQL.Add ('WHERE  km.KANJAID = ''' + arg_KanjaID  + '''');
    {2004.01.14 start}
      //SQL.Add ('  AND  s1.SECTION_ID  = km.SECTION_ID');
      SQL.Add ('  AND  s1.SECTION_ID(+)  = km.SECTION_ID');
    {2004.01.14 end}
      SQL.Add ('  AND  ku.KUBUN(+) = ''' + 'SEX' + '''');
      SQL.Add ('  AND  ku.KUBUN_ID(+) = km.SEX');
      if not Prepared then Prepare;
      Open;
      Last;
      First;
      if not(Eof) then begin
        //�擾�f�[�^���i�[
        //��������
        arg_SimeiKanji := FieldByName('KANJISIMEI').AsString;
        //�J�i����
//      arg_SimeiKana := FieldByName('ROMASIMEI').AsString; 2003.12.19
        arg_SimeiKana := FieldByName('KANASIMEI').AsString;

        //����
        arg_Sex         := FieldByName('SEX_NAME').AsString;
        //���N����
        //�N��
        if FieldByName('BIRTHDAY').AsString <> '' then begin
          w_BirthDay := func_StrToDate(func_Date8To10(FieldByName('BIRTHDAY').AsString));
          arg_BirthDay := FormatDateTime('YYYY/MM/DD', w_BirthDay);
          //�V�X�e�����t�擾
          w_Sys_Date      := func_GetDBSysDate(arg_Query2);
          arg_Age := IntToStr(func_GetAgeofCase(w_BirthDay, w_Sys_Date, 0));
        end;
        //���ғ��O�敪�`�F�b�N
        arg_Kanja_Nyugaikbn := FieldByName('KANJA_NYUGAIKBN').AsString;
        arg_Byoutou_ID      := FieldByName('BYOUTOU_ID').AsString;
        arg_Byousitu_ID     := FieldByName('BYOUSITU_ID').AsString;
        if FieldByName('KANJA_NYUGAIKBN').AsString = GPCST_NYUGAIKBN_2 then begin
          //���ғ��O�敪(���@)
          arg_Kanja_Nyugai := GPCST_NYUGAIKBN_2_NAME;
          //�a���擾
          with arg_Query2 do begin
            Close;
            SQL.Clear;
            SQL.Add ('SELECT b1.BYOUTOU_NAME ');
            SQL.Add ('FROM  BYOUTOUMASTER b1 ');
            SQL.Add ('WHERE  b1.BYOUTOU_ID  = ''' + arg_Byoutou_ID + '''');
            if not Prepared then Prepare;
            Open;
            Last;
            First;
            //�a������
            arg_Byoutou  := FieldByName('BYOUTOU_NAME').AsString;
          end;
          //�a���擾
          with arg_Query2 do begin
            Close;
            SQL.Clear;
            SQL.Add ('SELECT bs.BYOUSITU_NAME ');
            SQL.Add ('FROM  BYOUSITUMASTER bs ');
            SQL.Add ('WHERE  bs.BYOUSITU_ID = ''' + arg_Byousitu_ID + '''');
            if not Prepared then Prepare;
            Open;
            Last;
            First;
            //�a������
            arg_Byousitu     := FieldByName('BYOUSITU_NAME').AsString;
          end;
        end else
          if FieldByName('KANJA_NYUGAIKBN').AsString = GPCST_NYUGAIKBN_1 then begin
            //���ғ��O�敪(�O��)
            arg_Kanja_Nyugai := GPCST_NYUGAIKBN_1_NAME;
            //�a������
            arg_Byoutou      := '';
            //�a������
            arg_Byousitu     := '';
        end;
        //�f�É�
        arg_Section_ID  := FieldByName('SECTION_ID').AsString;
        arg_Section     := FieldByName('SINRYO_NAME').AsString;
        //�g��
        arg_Sincyo      := FieldByName('SINCYO').AsString;
        //�̏d
        arg_Taijyu      := FieldByName('TAIJYU').AsString;

        result:=True;
      end;
    end;
  except
    on E: Exception do begin
      raise;
    end;
  end;

end;
//���@�\�i��O���j�FRIS����ID��芳�ҏ��擾
function func_KanjaOrderInfo_Make(
         //IN
         arg_Query: TQuery;
         arg_Query2: TQuery;
         arg_RIS_ID: string;
         //OUT
         var arg_KanjaID: string;               //����ID
         var arg_SimeiKanji: string;            //��������
         var arg_SimeiRoma: string;             //�p������
         var arg_Sex: string;                   //����
         var arg_BirthDay: string;              //���N����
         var arg_Age: string;                   //�N��
         var arg_Byoutou_ID: string;            //�a��ID
         var arg_Byoutou: string;               //�a������
         var arg_Byousitu_ID: string;           //�a��ID
         var arg_Byousitu: string;              //�a������
         var arg_Kanja_Nyugaikbn: string;       //���ғ��O�敪
         var arg_Kanja_Nyugai_Name: string;     //���ғ��O�敪����
         var arg_Section_ID: string;            //�f�É�ID
         var arg_Section: string;               //�f�É�
         var arg_Sincyo: string;                //�g��
         var arg_Taijyu: string;                //�̏d
         var arg_Irai_Name: string;             //�˗��Ȗ���
         var arg_Irai_SectionID: string;        //�˗���ID
         var arg_Denpyo_NyugaiKbn: string;      //�`�[���O�敪(�`�[�a��)
         var arg_Denpyo_NyugaiName: string;     //�`�[���O�敪����(�`�[�a��)
         var arg_Denpyo_ByoutouID: string;      //�`�[�a��ID
         var arg_IraiDoctor: string;            //�˗���t��
         var arg_Section_Tel1: string;          //�˗��ȘA����(��S��)
         var arg_Section_Tel2: string           //�˗��ȘA����(��S���ȍ~)
        ): Boolean;
var
  w_BirthDay: TDate;
  w_KensaDay: TDate;
Begin
  //�I�[�_���C���}�X�^��芳�ҏ��擾�擾
  try
    with arg_Query do begin
      Close;
      SQL.Clear;
      SQL.Add ('SELECT om.KANJAID,om.KENSA_DATE,om.KENSA_DATE_AGE,om.DENPYO_NYUGAIKBN, om.IRAI_SECTION_ID ');
      SQL.Add ('      ,om.IRAI_DOCTOR_NAME,om.DENPYO_BYOUTOU_ID ');
      SQL.Add ('      ,km.KANJAID, km.KANJISIMEI, km.ROMASIMEI, km.SEX, km.KANJA_NYUGAIKBN ');
      SQL.Add ('      ,km.SECTION_ID,km.BYOUTOU_ID,km.SINCYO,km.TAIJYU,km.BYOUSITU_ID ');
      SQL.Add ('      ,Trim(TO_CHAR(km.BIRTHDAY,''00000000'')) BIRTHDAY ');
      SQL.Add ('      ,ku.KUBUN_NAME AS SEX_NAME ');
      SQL.Add ('      ,s1.SECTION_NAME AS SINRYO_NAME,s2.SECTION_NAME AS IRAI_NAME,s2.SECTION_TEL ');
      SQL.Add ('      ,om.Irai_Doctor_Renraku  ');
      SQL.Add ('FROM  ORDERMAINTABLE om,KANJAMASTER km,KUBUNMASTER ku ');
      SQL.Add ('     ,SECTIONMASTER s1,SECTIONMASTER s2 ');
      SQL.Add ('WHERE  om.RIS_ID = ''' + arg_RIS_ID  + '''');
      SQL.Add ('  AND  om.KANJAID     = km.KANJAID');
    {2004.01.14 start}
      //SQL.Add ('  AND  s1.SECTION_ID  = km.SECTION_ID');
      //SQL.Add ('  AND  s2.SECTION_ID  = om.IRAI_SECTION_ID');
      SQL.Add ('  AND  s1.SECTION_ID(+)  = km.SECTION_ID');
      SQL.Add ('  AND  s2.SECTION_ID(+)  = om.IRAI_SECTION_ID');
    {2004.01.14 end}
      SQL.Add ('  AND  ku.KUBUN(+) = ''' + 'SEX' + '''');
      SQL.Add ('  AND  ku.KUBUN_ID(+) = km.SEX');
      if not Prepared then Prepare;
      Open;
      Last;
      First;
        //�擾�f�[�^���i�[
        //����ID
        arg_KanjaID := FieldByName('KANJAID').AsString;
        //��������
        arg_SimeiKanji := FieldByName('KANJISIMEI').AsString;
        //�p������
        arg_SimeiRoma := FieldByName('ROMASIMEI').AsString;
        //����
        arg_Sex         := FieldByName('SEX_NAME').AsString;
        //���N����
        if FieldByName('BIRTHDAY').AsString <> '' then begin
          w_BirthDay := func_StrToDate(func_Date8To10(FieldByName('BIRTHDAY').AsString));
          arg_BirthDay := FormatDateTime('YYYY/MM/DD', w_BirthDay);
          //�N��
          if FieldByName('KENSA_DATE').AsString <> '' then begin
            w_KensaDay := func_StrToDate(func_Date8To10(FieldByName('KENSA_DATE').AsString));
            arg_Age := IntToStr(func_GetAgeofCase(w_BirthDay, w_KensaDay, 0));
          end;
        end;
        //���ғ��O�敪�`�F�b�N
        arg_Kanja_Nyugaikbn := FieldByName('KANJA_NYUGAIKBN').AsString;
        arg_Byoutou_ID      := FieldByName('BYOUTOU_ID').AsString;
        arg_Byousitu_ID     := FieldByName('BYOUSITU_ID').AsString;
{��No.5062 2003.05.07 start��}
        arg_Section_Tel1    := '';
{��No.5062 2003.05.07 end��}
        if FieldByName('KANJA_NYUGAIKBN').AsString = GPCST_NYUGAIKBN_2 then begin
          //���ғ��O�敪(���@)
          arg_Kanja_Nyugai_Name:= GPCST_NYUGAIKBN_2_NAME;
          //�a���擾
          with arg_Query2 do begin
            Close;
            SQL.Clear;
            SQL.Add ('SELECT b1.BYOUTOU_NAME, b1.BYOUTOU_TEL ');
            SQL.Add ('FROM  BYOUTOUMASTER b1 ');
            SQL.Add ('WHERE  b1.BYOUTOU_ID  = ''' + arg_Byoutou_ID + '''');
            if not Prepared then Prepare;
            Open;
            Last;
            First;
            //�a������
            arg_Byoutou      := FieldByName('BYOUTOU_NAME').AsString;
{��No.5062 2003.05.07 start��}
            //�a���A����
            arg_Section_Tel1 := FieldByName('BYOUTOU_TEL').AsString;
{��No.5062 2003.05.07 end��}
          end;
          //�a���擾
          with arg_Query2 do begin
            Close;
            SQL.Clear;
            SQL.Add ('SELECT bs.BYOUSITU_NAME ');
            SQL.Add ('FROM  BYOUSITUMASTER bs ');
            SQL.Add ('WHERE  bs.BYOUSITU_ID = ''' + arg_Byousitu_ID + '''');
            if not Prepared then Prepare;
            Open;
            Last;
            First;
            //�a������
            arg_Byousitu     := FieldByName('BYOUSITU_NAME').AsString;
          end;
        end else
          if FieldByName('KANJA_NYUGAIKBN').AsString = GPCST_NYUGAIKBN_1 then begin
            //���ғ��O�敪(�O��)
            arg_Kanja_Nyugai_Name := GPCST_NYUGAIKBN_1_NAME;
            //�a������
            arg_Byoutou      := '';
            //�a������
            arg_Byousitu     := '';
        end;
        //�f�É�
        arg_Section_ID  := FieldByName('SECTION_ID').AsString;
        arg_Section     := FieldByName('SINRYO_NAME').AsString;
        //�g��
        arg_Sincyo      := FieldByName('SINCYO').AsString;
        //�̏d
        arg_Taijyu      := FieldByName('TAIJYU').AsString;
        //�˗���
        arg_Irai_Name   := FieldByName('IRAI_NAME').AsString;
        arg_Irai_SectionID   := FieldByName('IRAI_SECTION_ID').AsString;
        //�`�[���O�敪�`�F�b�N
        arg_Denpyo_NyugaiKbn := FieldByName('DENPYO_NYUGAIKBN').AsString;
        arg_Denpyo_ByoutouID := FieldByName('DENPYO_BYOUTOU_ID').AsString;
        if FieldByName('DENPYO_NYUGAIKBN').AsString = GPCST_NYUGAIKBN_2 then begin
          //�a���擾
          with arg_Query2 do begin
            Close;
            SQL.Clear;
            SQL.Add ('SELECT BYOUTOU_NAME ');
            SQL.Add ('FROM  BYOUTOUMASTER  ');
            SQL.Add ('WHERE  BYOUTOU_ID  = ''' + arg_Denpyo_ByoutouID + '''');
            if not Prepared then Prepare;
            Open;
            Last;
            First;
            //�`�[�a������
            arg_Denpyo_NyugaiName := FieldByName('BYOUTOU_NAME').AsString;
          end;
        end else
        if FieldByName('DENPYO_NYUGAIKBN').AsString = GPCST_NYUGAIKBN_1 then begin
          //�`�[�a������
          arg_Denpyo_NyugaiName := GPCST_NYUGAIKBN_1_NAME;
        end;
        //�˗���t����
        arg_IraiDoctor  := FieldByName('IRAI_DOCTOR_NAME').AsString;
        //�˗����A����/PB
//        arg_Section_Tel1 := COPY(FieldByName('SECTION_TEL').AsString,1,4);
//        arg_Section_Tel2 := COPY(FieldByName('SECTION_TEL').AsString,5,16);
{��No.5062 2003.05.07 start��}
//        arg_Section_Tel1 := FieldByName('SECTION_TEL').AsString;
        //���ғ��O�敪(�O��)�̎��̓I�[�_���C���̈˗��ȘA����
        if FieldByName('KANJA_NYUGAIKBN').AsString = GPCST_NYUGAIKBN_1 then
          arg_Section_Tel1 := FieldByName('SECTION_TEL').AsString;
{��No.5062 2003.05.07 end��}
        arg_Section_Tel2 := FieldByName('Irai_Doctor_Renraku').AsString;
      end;
    result:=True;
  except
    on E: Exception do begin
      raise;
    end;
  end;

end;

procedure proc_Append_Log(arg_DispID:String;      //���ID
                          arg_Disp_Name:String;    //��ʖ���
                          arg_Msg:String;          //��������
                          arg_str,arg_str2:String);//�\��1.2
var
    LogFile: TextFile;
    w_Log: string;
    wBack_Name1: string;
    wBack_Name2: string;
    wBack_Name3: string;
    hd,Size: Integer;
    w_date:TDateTime;

    w_LogPath: string;
    w_Log_File:String;
    //INI���̎擾
    w_Qry:TQuery;
const
  CST_KAIGYO=#13#10;
begin
  w_Qry := TQuery.Create(nil);
  try
    w_Qry.DatabaseName := DM_DbAcc.DBs_MSter.DatabaseName;
    if arg_str <> '' then
      arg_str := StringReplace(arg_str, CST_KAIGYO, '', [rfReplaceAll]);
    if arg_str2 <> '' then
      arg_str2 := StringReplace(arg_str2, CST_KAIGYO, '', [rfReplaceAll]);

    //�p�X�ݒ�
    w_LogPath:=G_EnvPath;
{
    //�L�[�̒l��ǂށB
    w_LogPath:= func_ReadIniKeyVale(
                                   g_LOG_SECSION,
                                   g_LOG_PATH_KEY,
                                   w_LogPath);
    w_LogPath := func_ChngVal(w_LogPath);

}    // �t�H���_�����݂��Ă��Ȃ��ꍇ�ɂ̓t�H���_��p�ӂ���B
    if (DirectoryExists(w_LogPath)=False) then
      ForceDirectories(w_LogPath);


    //���O�t�@�C��������
    w_Log_File := 'stmr.log';

    if FileExists(w_LogPath  + w_Log_File) then begin
      // ���O�̃T�C�Y���m�F����B
      wBack_Name1 := ChangeFileExt(w_LogPath  + w_Log_File, '.bak1');
      wBack_Name2 := ChangeFileExt(w_LogPath  + w_Log_File, '.bak2');
      wBack_Name3 := ChangeFileExt(w_LogPath  + w_Log_File, '.bak3');
      hd := SysUtils.FileOpen(w_LogPath + w_Log_File, fmOpenRead or fmShareDenyWrite);
      Size := GetFileSize(hd, nil);
      FileClose(hd);
      // ���T�C�Y�𒴂����ꍇ�́A�o�b�N�A�b�v���Ƃ�B

      if Size > 600000 then
      begin
        if FileExists(wBack_Name3) then DeleteFile(PChar(wBack_Name3));
        if FileExists(wBack_Name2) then RenameFile(wBack_Name2, wBack_Name3);
        if FileExists(wBack_Name1) then RenameFile(wBack_Name1, wBack_Name2);
        RenameFile(w_LogPath + w_Log_File, wBack_Name1);
        AssignFile(LogFile, w_LogPath + w_Log_File);
        Rewrite(LogFile);
      end
      else begin
        AssignFile(LogFile,w_LogPath + w_Log_File);
        Append(LogFile);
      end;
    end
    else begin
      try
        AssignFile(LogFile,w_LogPath + w_Log_File);
        Rewrite(LogFile);
      except
        Exit;
      end;
    end;
    try
      //���ް�̎�������
      w_date:= func_GetDBSysDate(w_Qry);
      //۸ލ쐬
      w_Log :=  FormatDateTime('YYYY/MM/DD HH:MM',w_date)
              +  ' �y��ʁz' + arg_DispID + ' '+ arg_Disp_Name  + ' �y�����z'   + arg_Msg;
      if Length(arg_str) > 0 then
        w_Log := w_Log +#13#10 +  StringOfChar(' ',17) +'�yү����1�z' + arg_str;
      if Length(arg_str2) > 0 then
        w_Log := w_Log +#13#10 +  StringOfChar(' ',17) +'�yү����2�z' + arg_str2;
      Writeln(LogFile, w_Log);
    finally
      Flush(LogFile);
      CloseFile(LogFile);
    end;
  finally
    w_Qry.Free;
  end;
end;
//���@�\�i��O���j�F�V�F�[�}�i�[�t�@�C�����쐬
function func_Make_ShemaName(arg_OrderNO,               //�I�[�_NO
                             arg_MotoFileName: string;  //HIS���ϖ�
                             arg_Index: integer         //����NO
                             ):string;                  //�i�[̧�ٖ�
var
  w_P: integer;
  w_Kakuchosi: string;
  w_i:Integer;
begin
  Result := '';
  if arg_MotoFileName = '' then
    Exit;
  //if arg_Index = 0 then
  //  Exit;
  //2003.02.17
  w_P := 0;
  //HIS���ϖ����g���q�ʒu�擾
  for w_i := Length(arg_MotoFileName) downto 1 do begin
    if Copy(arg_MotoFileName,w_i,1) = '.' then begin
      w_P := w_i;
      Break;
    end;
  end;
  //HIS���ϖ����g���q�ʒu�擾
  //w_P := Pos('.',arg_MotoFileName);
  if w_P <= 0 then
    Exit;

  w_Kakuchosi := Copy(arg_MotoFileName,w_P,Length(arg_MotoFileName)-w_P+1);

  //�i�[̧�ٖ��쐬�i̧�ٖ�="����NO_���ϕ���NO.HIS���ϊg���q"�j
  Result := arg_OrderNO + '_' + FormatFloat('00',arg_Index) + w_Kakuchosi;
end;

//���@�\�i��O���j�F�i���t���O�ɂ���t�ԍ��\���E��\���l��Ԃ�
function func_GetUke_No(arg_Main,
                        arg_Sub: String
                        ):Bool;
begin
  Result := False; //��\��
  if arg_Main = GPCST_CODE_KENSIN_0 then Exit;
  if arg_Main = GPCST_CODE_KENSIN_2 then begin
//2003.01.09 SUBSTATUS�̎Q�Ƃ�NAME����CODE�ɕύX
//    if (arg_Sub = GPCST_NAME_KENSIN_SUB_8) or
//       (arg_Sub = GPCST_NAME_KENSIN_SUB_9) then begin
      if (arg_Sub = GPCST_CODE_KENSIN_SUB_8) or
       (arg_Sub = GPCST_CODE_KENSIN_SUB_9) then begin
      Exit;
    end;
  end;
  Result := True; //�\���\
end;
//���@�\�i��O���j�F�i���t���O�ɂ��F�̃L�[�R�[�h��Ԃ�
function func_GetColor_Key(arg_Main,
                           arg_Sub: String
                           ):String;
begin
  Result := '';
  //����
  if arg_Main = GPCST_CODE_KENSIN_0 then begin
    //����
    if arg_Sub = '' then begin
      Result := 'MIUKE';
      Exit;
    end;
    //���󁕌ďo
    if arg_Sub = GPCST_CODE_KENSIN_SUB_5 then begin
      Result := 'YOBIDASI';
      Exit;
    end;
    //���󁕒x��
    if arg_Sub = GPCST_CODE_KENSIN_SUB_6 then begin
      Result := 'TIKOKU';
      Exit;
    end;
  end;
  //���
  if arg_Main = GPCST_CODE_KENSIN_1 then begin
    //���
    if arg_Sub = '' then begin
      Result := 'UKEZUMI';
      Exit;
    end;
    //��ρ��m��
    if arg_Sub = GPCST_CODE_KENSIN_SUB_7 then begin
      Result := 'KAKUHO';
      Exit;
    end;
  end;
  //����
  if arg_Main = GPCST_CODE_KENSIN_2 then begin
    //����
    if arg_Sub = '' then begin
      Result := 'KENCYUU';
      Exit;
    end;
    //�������Čďo
    if arg_Sub = GPCST_CODE_KENSIN_SUB_9 then begin
      Result := 'SAIYOBI';
      Exit;
    end;
    //�������Ď�t
    if arg_Sub = GPCST_CODE_KENSIN_SUB_10 then begin
      Result := 'SAIUKE';
      Exit;
    end;
    //�������ۗ�
    if arg_Sub = GPCST_CODE_KENSIN_SUB_8 then begin
      Result := 'HORYUU';
      Exit;
    end;
  end;
  //����
  if arg_Main = GPCST_CODE_KENSIN_3 then begin
    Result := 'KENZUMI';
    Exit;
  end;
  //���~
  if arg_Main = GPCST_CODE_KENSIN_4 then begin
    Result := 'CYUUSI';
    Exit;
  end;
end;
//���@�\�i��O���j�F�D��t���O�ɂ��D�於��Ԃ�
function func_GetYuusen_Name(arg_Yuusen: String):String;
begin
  Result := '';
 if arg_Yuusen = GPCST_YUUSEN_0 then begin
   Result := GPCST_YUUSEN_0_RYAKUNAME;
   Exit;
 end;
 if arg_Yuusen = GPCST_YUUSEN_1 then begin
   Result := GPCST_YUUSEN_1_RYAKUNAME;
   Exit;
 end;
 if arg_Yuusen = GPCST_YUUSEN_2 then begin
   Result := GPCST_YUUSEN_2_RYAKUNAME;
   Exit;
 end;
end;
//���@�\�i��O���j�F�޼����ދ敪�ɂ���޼����ޖ���Ԃ�
function func_GetDejitaizu_Name(arg_Dejitaizu: String):String;
begin
  Result := '';
  if arg_Dejitaizu = GPCST_DEJITAI_0 then begin
    Result := GPCST_DEJITAI_0_NAME;
  end;
  if arg_Dejitaizu = GPCST_DEJITAI_1 then begin
    Result := GPCST_DEJITAI_1_NAME;
  end;
end;
//���@�\�i��O���j�F�����ϊ�
function func_Moji_Henkan(arg_Moji: string;
                          arg_Flg: Integer  //1:�S�p�����p�A2:���p���S�p�A3:�S�p�Ђ炪�ȁ����p�J�^�J�i
                          ): string;
var
  w_Chr:        array [0..255] of char;
  w_MapFlags:   DWORD;
begin
  // �S�p(2�޲�)�����p(1�޲�)�ɕϊ�
  if arg_Flg = 1 then begin
    LCMapString(
                GetUserDefaultLCID(),
                LCMAP_HALFWIDTH,
                PChar(arg_Moji),      //�ϊ����镶����
                Length(arg_Moji) + 1, //�T�C�Y
                w_Chr,                //�ϊ�����
                Sizeof(w_Chr)         //�T�C�Y
               );
  end;
  // ���p(1�޲�)���S�p(2�޲�)�ɕϊ�
  if arg_Flg = 2 then begin
    LCMapString(
                GetUserDefaultLCID(),
                LCMAP_FULLWIDTH,
                PChar(arg_Moji),      //�ϊ����镶����
                Length(arg_Moji) + 1, //�T�C�Y
                w_Chr,                //�ϊ�����
                Sizeof(w_Chr)         //�T�C�Y
               );
  end;
  // �S�p�Ђ炪�ȁ����p�J�^�J�i�ɕϊ�
  if arg_Flg = 3 then begin
    w_MapFlags := LCMAP_KATAKANA;               //�J�^�J�i
    w_MapFlags := w_MapFlags + LCMAP_HALFWIDTH; //���p����
    LCMapString(
                GetUserDefaultLCID(),
                w_MapFlags,
                PChar(arg_Moji),
                Length(arg_Moji) + 1,
                w_Chr,
                Sizeof(w_Chr)
               );
  end;

  Result := Trim(w_Chr);
end;
//���@�\�i��O���j�FWAVE�t�@�C����Dir��Ԃ�
function func_GetWav_Name:String;
//var
//  w_Ini : TIniFile;
//  w_Home,w_File : String;
begin
//  w_Ini := TIniFile.Create(GetCurrentDir+'\'+ g_DOCSYS_INI_NAME);
//  try
//    w_Home := w_Ini.ReadString(g_COMMON_SECSION,g_HOMEDIR_KEY,'');
//    w_File := w_Ini.ReadString(g_DIRINF_SECSION,'wavedir','');
//    Result := StringReplace(w_File,'%HOMEDIR%',w_Home,[rfReplaceAll]);
     Result := gi_WAVEDIR_DIR;
//  finally
//    w_Ini.Free;
//  end;
end;

//******************************************************************************
//  �����T�v  �C�x���g
//  �������e  ���C���X�e�[�^�X�ƃT�u�X�e�[�^�X����X�e�[�^�X�𔻒f����
//  ����      ���C���A�T�u�X�e�[�^�X:String
//  �߂�l    ���i������
//******************************************************************************
function func_Stetas_Info_Ryaku(arg_Main_Sts,arg_Sub_Sts:String):String;
begin
  //����
  if (arg_Main_Sts = GPCST_CODE_KENSIN_0) and (arg_Sub_Sts = '') then
    Result := GPCST_RYAKU_NAME_KENSIN_0
  //�ďo
  else if (arg_Main_Sts = GPCST_CODE_KENSIN_0) and (arg_Sub_Sts = GPCST_CODE_KENSIN_SUB_5) then
    Result := GPCST_RYAKU_NAME_KENSIN_SUB_5
  //�x��
  else if (arg_Main_Sts = GPCST_CODE_KENSIN_0) and (arg_Sub_Sts = GPCST_CODE_KENSIN_SUB_6) then
    Result := GPCST_RYAKU_NAME_KENSIN_SUB_6
  //��t��
  else if (arg_Main_Sts = GPCST_CODE_KENSIN_1) and (arg_Sub_Sts = '') then
    Result := GPCST_RYAKU_NAME_KENSIN_1
  //�m��
  else if (arg_Main_Sts = GPCST_CODE_KENSIN_1) and (arg_Sub_Sts = GPCST_CODE_KENSIN_SUB_7) then
    Result := GPCST_RYAKU_NAME_KENSIN_SUB_7
  //�����@
  else if (arg_Main_Sts = GPCST_CODE_KENSIN_2) and (arg_Sub_Sts = '') then
    Result := GPCST_RYAKU_NAME_KENSIN_2
  //�ۗ�
  else if (arg_Main_Sts = GPCST_CODE_KENSIN_2) and (arg_Sub_Sts = GPCST_CODE_KENSIN_SUB_8) then
    Result := GPCST_RYAKU_NAME_KENSIN_SUB_8
  //�Č�
  else if (arg_Main_Sts = GPCST_CODE_KENSIN_2) and (arg_Sub_Sts = GPCST_CODE_KENSIN_SUB_9) then
    Result := GPCST_RYAKU_NAME_KENSIN_SUB_9
  //�Ď�
  else if (arg_Main_Sts = GPCST_CODE_KENSIN_2) and (arg_Sub_Sts = GPCST_CODE_KENSIN_SUB_10) then
    Result := GPCST_RYAKU_NAME_KENSIN_SUB_10
  //����
  else if (arg_Main_Sts = GPCST_CODE_KENSIN_3) and (arg_Sub_Sts = '') then
    Result := GPCST_RYAKU_NAME_KENSIN_3
  //���~
  else if (arg_Main_Sts = GPCST_CODE_KENSIN_4) and (arg_Sub_Sts = '') then
    Result := GPCST_RYAKU_NAME_KENSIN_4;
end;
//******************************************************************************
//  �����T�v  �������擾�C�x���g
//  �������e  �O���b�h�ɕ\�����鑼�������ڂɂ��Ă̏���
//  ����      RIS ID,����ID�A������:String yyyymmdd
//  �߂�l    ������
//******************************************************************************
function func_Make_Takensa(arg_RIS_ID,arg_KanjaID,arg_Date:String):String;
var
  w_Qry:TQuery;
  ws_Kensa_Name:String;
  ws_Kensa_Shuberu_Ryaku:String;
  ws_Line,ws_Line1:String;
  w_i:Integer;
  ws_Kensa_Flg,ws_Kensa_Status_Flg,ws_KensaSub_Status_Flg:String;
begin
  w_Qry := TQuery.Create(Nil);
  try
    w_Qry.DatabaseName := DM_DbAcc.DBs_MSter.DatabaseName;
    //�I�[�_���C��������̎擾
    with w_Qry do begin
      //����
      Close;
      //�O��SQL���̃N���A
      SQL.Clear;
      //SQL���쐬
      SQL.Add('SELECT Exm.KanjaID,Exm.RIS_ID,Exm.Kensa_Date, ');
      SQL.Add('       Exm.Call_Tikoku_Date,Exm.Uketuke_Update_Date,Exm.Kensa_Horyuu_Date,Exm.Jisseki_Update_Date, ');
      SQL.Add('       Exm.KensaSubStatus_Flg,Exm.KensaStatus_Flg,  ');
      SQL.Add('       NVL(Exm.KensaSubStatus_Flg,Exm.KensaStatus_Flg) As KensaStatus,  ');
      SQL.Add('       Km.KENSATYPE_RYAKUNAME, ');
      SQL.Add('       Orm.Kensa_StartTime ');
      SQL.Add('FROM EXMAINTABLE Exm, ORDERMAINTABLE Orm, KensaTypeMaster Km');
      SQL.Add('WHERE Exm.KanjaID = :PKanjaID');
      SQL.Add('  AND Exm.RIS_ID <> :PRIS_ID');
      SQL.Add('  AND Exm.Kensa_Date = :PKensa_Date');
      SQL.Add('  AND Exm.KENSATYPE_ID = Km.KENSATYPE_ID(+) ');
      SQL.Add('  AND Exm.RIS_ID = Orm.RIS_ID');
      SQL.Add('ORDER BY Orm.Kensa_StartTime,Km.KENSATYPE_ID ');

      //�₢���킹�m�F
      if not Prepared then
        //�₢���킹����
        Prepare;
      //RIS����ID
      ParamByName('PRIS_ID').AsString := arg_RIS_ID;
      ParamByName('PKanjaID').AsString := arg_KanjaID;
      ParamByName('PKensa_Date').AsString := arg_Date;
      //�J��
      Open;
      //�Ō�̃��R�[�h�Ɉړ�
      Last;
      //�ŏ��̃��R�[�h�Ɉړ�
      First;
      //�f�[�^�Ȃ�
      if (w_Qry.RecordCount = 0)  then
        //�����I��
        Exit
      else begin
        ws_Line:='';
        for w_i := 1 to w_Qry.RecordCount do begin
          ws_Kensa_Shuberu_Ryaku := '';
          ws_Kensa_Name := '';
          //��������
          ws_Kensa_Flg := w_Qry.FieldByName('KensaStatus').AsString;
          ws_Kensa_Status_Flg := w_Qry.FieldByName('KensaStatus_Flg').AsString;
          ws_KensaSub_Status_Flg := w_Qry.FieldByName('KensaSubStatus_Flg').AsString;
          //������ʗ���
          ws_Kensa_Shuberu_Ryaku := w_Qry.FieldByName('KensaType_RyakuName').AsString;
          //�����i��
          ws_Kensa_Name := func_Stetas_Info_Ryaku(ws_Kensa_Status_Flg,ws_KensaSub_Status_Flg);
          ws_Line1 := '';
          ws_Line1 := ws_Kensa_Shuberu_Ryaku + ws_Kensa_Name;
          if w_i = 1 then
            ws_Line := ws_Line1
          else
            ws_Line :=  ws_Line + ' ' +ws_Line1;
          Next;
        end;
      end;

    end;
  finally
    if w_Qry <> Nil then begin
      w_Qry.Close;
      w_Qry.Free;
    end;

  end;
  Result := ws_Line;
end;
//******************************************************************************
//  �����T�v  �������擾�C�x���g   2003.10.07
//  �������e  �O���b�h�ɕ\�����鑼�������ڂɂ��Ă̏���
//  ����      RIS ID,����ID,������,���C���i��,�T�u�i��:String yyyymmdd
//  �߂�l    ������,�������t���O
//******************************************************************************
function func_Make_Takensa2(arg_RIS_ID,arg_KanjaID,arg_Date,
                            arg_Main,arg_Sub:String;
                            var arg_v_takenchuu:String):String;
var
  w_Qry:TQuery;
  ws_Kensa_Name:String;
  ws_Kensa_Shuberu_Ryaku:String;
  ws_Line,ws_Line1:String;
  w_i:Integer;
  ws_Kensa_Flg,ws_Kensa_Status_Flg,ws_KensaSub_Status_Flg:String;
begin
  w_Qry := TQuery.Create(Nil);
  arg_v_takenchuu := '';
  try
    w_Qry.DatabaseName := DM_DbAcc.DBs_MSter.DatabaseName;
    //�I�[�_���C��������̎擾
    with w_Qry do begin
      //����
      Close;
      //�O��SQL���̃N���A
      SQL.Clear;
      //SQL���쐬
      SQL.Add('SELECT Exm.KanjaID,Exm.RIS_ID,Exm.Kensa_Date, ');
      SQL.Add('       Exm.Call_Tikoku_Date,Exm.Uketuke_Update_Date,Exm.Kensa_Horyuu_Date,Exm.Jisseki_Update_Date, ');
      SQL.Add('       Exm.KensaSubStatus_Flg,Exm.KensaStatus_Flg,  ');
      SQL.Add('       NVL(Exm.KensaSubStatus_Flg,Exm.KensaStatus_Flg) As KensaStatus,  ');
      SQL.Add('       Km.KENSATYPE_RYAKUNAME, ');
      SQL.Add('       Orm.Kensa_StartTime ');
      SQL.Add('FROM EXMAINTABLE Exm, ORDERMAINTABLE Orm, KensaTypeMaster Km');
      SQL.Add('WHERE Exm.KanjaID = :PKanjaID');
      SQL.Add('  AND Exm.RIS_ID <> :PRIS_ID');
      SQL.Add('  AND Exm.Kensa_Date = :PKensa_Date');
      SQL.Add('  AND Exm.KENSATYPE_ID = Km.KENSATYPE_ID(+) ');
      SQL.Add('  AND Exm.RIS_ID = Orm.RIS_ID');
      SQL.Add('ORDER BY Orm.Kensa_StartTime,Km.KENSATYPE_ID ');

      //�₢���킹�m�F
      if not Prepared then
        //�₢���킹����
        Prepare;
      //RIS����ID
      ParamByName('PRIS_ID').AsString := arg_RIS_ID;
      ParamByName('PKanjaID').AsString := arg_KanjaID;
      ParamByName('PKensa_Date').AsString := arg_Date;
      //�J��
      Open;
      //�Ō�̃��R�[�h�Ɉړ�
      Last;
      //�ŏ��̃��R�[�h�Ɉړ�
      First;
      //�f�[�^�Ȃ�
      if (w_Qry.RecordCount = 0)  then
        //�����I��
        Exit
      else begin
        ws_Line:='';
        for w_i := 1 to w_Qry.RecordCount do begin
          ws_Kensa_Shuberu_Ryaku := '';
          ws_Kensa_Name := '';
          //��������
          ws_Kensa_Flg := w_Qry.FieldByName('KensaStatus').AsString;
          ws_Kensa_Status_Flg := w_Qry.FieldByName('KensaStatus_Flg').AsString;
          ws_KensaSub_Status_Flg := w_Qry.FieldByName('KensaSubStatus_Flg').AsString;
          //������ʗ���
          ws_Kensa_Shuberu_Ryaku := w_Qry.FieldByName('KensaType_RyakuName').AsString;
          //�����i��
          ws_Kensa_Name := func_Stetas_Info_Ryaku(ws_Kensa_Status_Flg,ws_KensaSub_Status_Flg);
          ws_Line1 := '';
          ws_Line1 := ws_Kensa_Shuberu_Ryaku + ws_Kensa_Name;
          if w_i = 1 then
            ws_Line := ws_Line1
          else
            ws_Line :=  ws_Line + ' ' +ws_Line1;
          if ((arg_Main = GPCST_CODE_KENSIN_0) and (arg_Sub = '')) or
             (arg_Sub = GPCST_CODE_KENSIN_SUB_5) or
             ((arg_Main = GPCST_CODE_KENSIN_1) and (arg_Sub = '')) then
          begin
            if ((ws_Kensa_Status_Flg = GPCST_CODE_KENSIN_2) and
                (ws_KensaSub_Status_Flg = '')) or
              (ws_KensaSub_Status_Flg = GPCST_CODE_KENSIN_SUB_5) or
              (ws_KensaSub_Status_Flg = GPCST_CODE_KENSIN_SUB_7) then
            begin
              arg_v_takenchuu := '1';
            end;
          end;

          Next;
        end;
      end;

    end;
  finally
    if w_Qry <> Nil then begin
      w_Qry.Close;
      w_Qry.Free;
    end;

  end;
  Result := ws_Line;
end;
//******************************************************************************
//  �����T�v  ������ʖ��̒P�[�̒��[No    �l�[���J�[�h
//  �������e  �������ID�Ŏg�p����P�[�̒��[No���擾
//  ����      �������ID
//  �߂�l    �P�[�̒��[No
//�@�C���F2003.12.30
//        ���}���A���i�p��ȰѶ��ނ���P�[�p�ɕύX�B
//******************************************************************************
function func_Get_NameCard_ID_No(arg_KensaTypeID:string): string;
begin
  Result := '';
  //Portable�w���[
  if arg_KensaTypeID = GPCST_SYUBETU_13 then begin //��ߎ��߰����
    Result := '201';
  end else
  //RI���Ҏw���[
  if arg_KensaTypeID = GPCST_SYUBETU_07 then begin   //RI
    Result := '202';
  end else begin
  //�t�B���������\
    Result := '203';
  end;

end;
function func_Get_UketukePrint_No(arg_KensaTypeID:string): Boolean;
begin

  Result := False;
  if (arg_KensaTypeID = GPCST_SYUBETU_01) or  //���
     (arg_KensaTypeID = GPCST_SYUBETU_03) or  //����
     (arg_KensaTypeID = GPCST_SYUBETU_05) or  //CT
     (arg_KensaTypeID = GPCST_SYUBETU_06) or  //MR
     (arg_KensaTypeID = GPCST_SYUBETU_10) or  //����
     (arg_KensaTypeID = GPCST_SYUBETU_12) or  //���ꌟ��
     (arg_KensaTypeID = GPCST_SYUBETU_08) or  //����
     (arg_KensaTypeID = GPCST_SYUBETU_09) or  //���� �@
     (arg_KensaTypeID = GPCST_SYUBETU_14) or  //���Èʒu����
     //2004.05.03 (arg_KensaTypeID = GPCST_SYUBETU_15)     //���Èʒu����CT
     (arg_KensaTypeID = GPCST_SYUBETU_15) or  //���Èʒu����CT
     (arg_KensaTypeID = GPCST_SYUBETU_31) or  //�~�����
     (arg_KensaTypeID = GPCST_SYUBETU_07) or  //�j��w
     (arg_KensaTypeID = GPCST_SYUBETU_38) or  //�ʊٌ���
     (arg_KensaTypeID = GPCST_SYUBETU_35)     //�ʊ�CT
  then Result := True;

end;
//******************************************************************************
//  �����T�v  ���[���̃_�C���N�g����t���O���擾
//  �������e  ���[No�Œ��[�}�X�^���_�C���N�g����t���O���擾
//  ����      �ڑ��ς݃N�G���[�A���[No
//  �߂�l    �_�C���N�g����t���O
//******************************************************************************
function func_Get_DirectFlg(
                    arg_Query: TQuery;
                    arg_CyohyouNo: string):string;
var
  w_CyohyouNo:string;
begin
  Result := '';

  w_CyohyouNo := arg_CyohyouNo;
  if (arg_CyohyouNo = '103A') or
     (arg_CyohyouNo = '103B') or
     (arg_CyohyouNo = '103C') or
     (arg_CyohyouNo = '103D') then begin
    w_CyohyouNo := '103';
  end;

  try
    with arg_Query do begin
      //����
      Close;
      //�O��SQL���̃N���A
      SQL.Clear;
      //SQL���쐬
      SQL.Add('SELECT * ');
      SQL.Add('FROM CYOHYOUMASTER ');
      SQL.Add('WHERE CYOHYOU_NO = :CYOHYOU_NO');
      //�₢���킹�m�F
      if not Prepared then Prepare;
      //���[No
      ParamByName('CYOHYOU_NO').AsString := w_CyohyouNo;
      //�J��
      Open;
      //�Ō�̃��R�[�h�Ɉړ�
      Last;
      //�ŏ��̃��R�[�h�Ɉړ�
      First;
      if not(Eof) then begin
        Result := FieldByName('DEFAULT_FLG').AsString;
      end;
    end;
  finally
    arg_Query.Close;
  end;
end;
//******************************************************************************
//  �����T�v  �e�Ɩ����L���Ȏ�ʂ݂̂����o��
//  �������e  �[�����ɃC�j�V�����ݒ肳�ꂽ��ʂ���e�Ɩ����L���Ȏ�ʂ݂̂����o��
//  ����      ���ID�A�J���}��؂�̌������ID
//  �߂�l    �J���}��؂�̌������ID
//  �C���F2003.12.07�F�J��
//                    ������ʂ𐹃}���A���i�p�ɕύX
//******************************************************************************
function func_Check_Initiali_Kensa(
                 arg_PrgId: string;
                 arg_Initiali_Kensa: string): string;
var
  w_Strs : TStrings;
  w_i: Integer;
  w_ret: Integer;
  w_Return:string;
begin

  Result := '';

  w_Return := '';

  if arg_Initiali_Kensa = '' then Exit;

  w_Strs := TStringList.Create;

  try
    try
      w_Strs := func_StrToTStrList(arg_Initiali_Kensa);
      w_ret := w_Strs.Count;
    except
      w_ret := 0;
    end;

    if w_ret = 0 then Exit;

    //�B�e�Ɩ�
    if arg_PrgId = 'G1' then begin
      for w_i := 0 to w_Strs.Count -1 do begin
{2003.12.07
        if (w_Strs[w_i] = GPCST_SYUBETU_01) or
           (w_Strs[w_i] = GPCST_SYUBETU_02) or
           (w_Strs[w_i] = GPCST_SYUBETU_04) or
           (w_Strs[w_i] = GPCST_SYUBETU_05) or
           (w_Strs[w_i] = GPCST_SYUBETU_06) then begin}
        //2003.12.19�ύX
        if (w_Strs[w_i] = GPCST_SYUBETU_01) or            //���
           (w_Strs[w_i] = GPCST_SYUBETU_12) or            //���ꌟ��
           (w_Strs[w_i] = GPCST_SYUBETU_14) or            //���Èʒu����
           (w_Strs[w_i] = GPCST_SYUBETU_31) then begin    //�~�����
          if w_Return <> '' then
            w_Return := w_Return + ',' + w_Strs[w_i]
          else
            w_Return := w_Return + w_Strs[w_i];
        end;
      end;
    end else
    //�����Ɩ�
    if arg_PrgId = 'H1' then begin
      for w_i := 0 to w_Strs.Count -1 do begin
{2003.12.07
        if (w_Strs[w_i] = GPCST_SYUBETU_07) or
           (w_Strs[w_i] = GPCST_SYUBETU_08) or
           (w_Strs[w_i] = GPCST_SYUBETU_09) or
           (w_Strs[w_i] = GPCST_SYUBETU_10) or
           (w_Strs[w_i] = GPCST_SYUBETU_11) or
           (w_Strs[w_i] = GPCST_SYUBETU_12) then begin}
        //2003.12.19�ύX
        if (w_Strs[w_i] = GPCST_SYUBETU_03) or           //����
           (w_Strs[w_i] = GPCST_SYUBETU_10) or           //����
           (w_Strs[w_i] = GPCST_SYUBETU_08) or           //����
           (w_Strs[w_i] = GPCST_SYUBETU_05) or           //CT
           (w_Strs[w_i] = GPCST_SYUBETU_06) or           //MR
           (w_Strs[w_i] = GPCST_SYUBETU_09) or           //����
           (w_Strs[w_i] = GPCST_SYUBETU_15) or           //���Èʒu����CT
           (w_Strs[w_i] = GPCST_SYUBETU_38) or           //�~������
           (w_Strs[w_i] = GPCST_SYUBETU_35) then begin   //�~��CT
          if w_Return <> '' then
            w_Return := w_Return + ',' + w_Strs[w_i]
          else
            w_Return := w_Return + w_Strs[w_i];
        end;
      end;
    end else
    //Portable�Ɩ� 2003.12.19
    if arg_PrgId = 'J1' then begin
      for w_i := 0 to w_Strs.Count -1 do begin
        if (w_Strs[w_i] = GPCST_SYUBETU_01) or           //���
           (w_Strs[w_i] = GPCST_SYUBETU_12) or           //���ꌟ��
           (w_Strs[w_i] = GPCST_SYUBETU_14) or           //���Èʒu����
           (w_Strs[w_i] = GPCST_SYUBETU_31) or           //�~�����
           (w_Strs[w_i] = GPCST_SYUBETU_13) then begin   //��ߎ��߰����
          if w_Return <> '' then
            w_Return := w_Return + ',' + w_Strs[w_i]
          else
            w_Return := w_Return + w_Strs[w_i];
        end;
      end;
    end else
    //RI�Ɩ�
    if arg_PrgId = 'K1' then begin
      for w_i := 0 to w_Strs.Count -1 do begin
//      if (w_Strs[w_i] = GPCST_SYUBETU_13) then begin 2003.12.07
        if (w_Strs[w_i] = GPCST_SYUBETU_07) then begin //2003.12.19
          if w_Return <> '' then
            w_Return := w_Return + ',' + w_Strs[w_i]
          else
            w_Return := w_Return + w_Strs[w_i];
        end;
      end;
    end else
    //�v���`�F�b�N 2004.01.04
    if arg_PrgId = 'E1' then begin
      for w_i := 0 to w_Strs.Count -1 do begin
        if (w_Strs[w_i] = GPCST_SYUBETU_03) or           //����
           (w_Strs[w_i] = GPCST_SYUBETU_10) or           //����
           (w_Strs[w_i] = GPCST_SYUBETU_08) or           //����
           (w_Strs[w_i] = GPCST_SYUBETU_05) or           //CT
           (w_Strs[w_i] = GPCST_SYUBETU_06) or           //MR
           (w_Strs[w_i] = GPCST_SYUBETU_07) or           //�j��w
           (w_Strs[w_i] = GPCST_SYUBETU_09) or           //����
           (w_Strs[w_i] = GPCST_SYUBETU_15) or           //���Èʒu����CT
           (w_Strs[w_i] = GPCST_SYUBETU_38) or           //�~������
           (w_Strs[w_i] = GPCST_SYUBETU_35) then begin   //�~��CT
          if w_Return <> '' then
            w_Return := w_Return + ',' + w_Strs[w_i]
          else
            w_Return := w_Return + w_Strs[w_i];
        end;
      end;
    end else
    //���̑�
    begin
      w_Return := arg_Initiali_Kensa;
    end;

    Result := w_Return;
  finally
    w_Strs.Free;
  end;

end;
//******************************************************************************
//  �����T�v  �e�Ɩ����L���Ȏ��{���u�݂̂����o��
//  �������e  �[�����ɃC�j�V�����ݒ肳�ꂽ���{���u�����ʂɕR�t���L���Ȏ��{���u�݂̂����o��
//  ����      ���ID�A�ڑ��ς݃N�G���A�J���}��؂�̌������ID�A�J���}��؂�̌����@��ID
//  �߂�l    �J���}��؂�̌����@��ID
//  �C���F2003.12.07�F�J��
//                    ���}���A���i�p�Ɍ�����ʂ�ύX�B
//******************************************************************************
function func_Check_Initiali_Souti(
                 arg_PrgId: string;
                 arg_Query: TQuery;
                 arg_Initiali_Kensa: string;
                 arg_Initiali_Souti: string): string;
var
  w_StrsK,w_StrsS : TStrings;
  w_i,w_j,w_Exists: Integer;
  w_ret: Integer;
  w_Filter:string;
  w_Return:string;
begin

  Result := '';

  w_Return := '';

  if arg_Initiali_Souti = '' then Exit;
  
  w_StrsS := TStringList.Create;

  try
    try
      w_StrsS := func_StrToTStrList(arg_Initiali_Souti);
      w_ret := w_StrsS.Count;
    except
      w_ret := 0;
    end;

    if w_ret = 0 then Exit;

    with arg_Query do begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT KENSAKIKI_ID FROM KENSAKIKIMASTER ');

      if arg_Initiali_Kensa = '' then begin
        //�B�e�Ɩ�
        if arg_PrgId = 'G1' then begin
{2003.12.07
          SQL.Add(' WHERE (' + func_GetFilter_Flg_Name(GPCST_SYUBETU_01) + ' = ''1'') ');
          SQL.Add('    OR (' + func_GetFilter_Flg_Name(GPCST_SYUBETU_02) + ' = ''1'') ');
          SQL.Add('    OR (' + func_GetFilter_Flg_Name(GPCST_SYUBETU_04) + ' = ''1'') ');
          SQL.Add('    OR (' + func_GetFilter_Flg_Name(GPCST_SYUBETU_05) + ' = ''1'') ');
          SQL.Add('    OR (' + func_GetFilter_Flg_Name(GPCST_SYUBETU_06) + ' = ''1'') ');}
          //2003.12.19
          SQL.Add(' WHERE (' + func_GetFilter_Flg_Name(GPCST_SYUBETU_01) + ' = ''1'') ');
          SQL.Add('    OR (' + func_GetFilter_Flg_Name(GPCST_SYUBETU_12) + ' = ''1'') ');
          SQL.Add('    OR (' + func_GetFilter_Flg_Name(GPCST_SYUBETU_14) + ' = ''1'') ');
          SQL.Add('    OR (' + func_GetFilter_Flg_Name(GPCST_SYUBETU_31) + ' = ''1'') ');
        end else
        //�����Ɩ�
        if arg_PrgId = 'H1' then begin
{2003.12.07
          SQL.Add(' WHERE (' + func_GetFilter_Flg_Name(GPCST_SYUBETU_07) + ' = ''1'') ');
          SQL.Add('    OR (' + func_GetFilter_Flg_Name(GPCST_SYUBETU_08) + ' = ''1'') ');
          SQL.Add('    OR (' + func_GetFilter_Flg_Name(GPCST_SYUBETU_09) + ' = ''1'') ');
          SQL.Add('    OR (' + func_GetFilter_Flg_Name(GPCST_SYUBETU_10) + ' = ''1'') ');
          SQL.Add('    OR (' + func_GetFilter_Flg_Name(GPCST_SYUBETU_11) + ' = ''1'') ');
          SQL.Add('    OR (' + func_GetFilter_Flg_Name(GPCST_SYUBETU_12) + ' = ''1'') ');}
          //2003.12.19
          SQL.Add(' WHERE (' + func_GetFilter_Flg_Name(GPCST_SYUBETU_03) + ' = ''1'') ');
          SQL.Add('    OR (' + func_GetFilter_Flg_Name(GPCST_SYUBETU_10) + ' = ''1'') ');
          SQL.Add('    OR (' + func_GetFilter_Flg_Name(GPCST_SYUBETU_08) + ' = ''1'') ');
          SQL.Add('    OR (' + func_GetFilter_Flg_Name(GPCST_SYUBETU_05) + ' = ''1'') ');
          SQL.Add('    OR (' + func_GetFilter_Flg_Name(GPCST_SYUBETU_06) + ' = ''1'') ');
          SQL.Add('    OR (' + func_GetFilter_Flg_Name(GPCST_SYUBETU_09) + ' = ''1'') ');
          SQL.Add('    OR (' + func_GetFilter_Flg_Name(GPCST_SYUBETU_15) + ' = ''1'') ');
          SQL.Add('    OR (' + func_GetFilter_Flg_Name(GPCST_SYUBETU_38) + ' = ''1'') ');
          SQL.Add('    OR (' + func_GetFilter_Flg_Name(GPCST_SYUBETU_35) + ' = ''1'') ');
        end else
        //Portable�Ɩ�
        if arg_PrgId = 'J1' then begin
//          SQL.Add(' WHERE (' + func_GetFilter_Flg_Name(GPCST_SYUBETU_03) + ' = ''1'') '); 2003.12.08
          //2003.12.19
          SQL.Add(' WHERE (' + func_GetFilter_Flg_Name(GPCST_SYUBETU_01) + ' = ''1'') ');
          SQL.Add('    OR (' + func_GetFilter_Flg_Name(GPCST_SYUBETU_12) + ' = ''1'') ');
          SQL.Add('    OR (' + func_GetFilter_Flg_Name(GPCST_SYUBETU_14) + ' = ''1'') ');
          SQL.Add('    OR (' + func_GetFilter_Flg_Name(GPCST_SYUBETU_31) + ' = ''1'') ');
          SQL.Add('    OR (' + func_GetFilter_Flg_Name(GPCST_SYUBETU_13) + ' = ''1'') ');
        end else
        //�v���`�F�b�N
        if arg_PrgId = 'E1' then begin
          SQL.Add(' WHERE (' + func_GetFilter_Flg_Name(GPCST_SYUBETU_03) + ' = ''1'') ');
          SQL.Add('    OR (' + func_GetFilter_Flg_Name(GPCST_SYUBETU_10) + ' = ''1'') ');
          SQL.Add('    OR (' + func_GetFilter_Flg_Name(GPCST_SYUBETU_08) + ' = ''1'') ');
          SQL.Add('    OR (' + func_GetFilter_Flg_Name(GPCST_SYUBETU_05) + ' = ''1'') ');
          SQL.Add('    OR (' + func_GetFilter_Flg_Name(GPCST_SYUBETU_06) + ' = ''1'') ');
          SQL.Add('    OR (' + func_GetFilter_Flg_Name(GPCST_SYUBETU_07) + ' = ''1'') ');
          SQL.Add('    OR (' + func_GetFilter_Flg_Name(GPCST_SYUBETU_09) + ' = ''1'') ');
          SQL.Add('    OR (' + func_GetFilter_Flg_Name(GPCST_SYUBETU_15) + ' = ''1'') ');
          SQL.Add('    OR (' + func_GetFilter_Flg_Name(GPCST_SYUBETU_38) + ' = ''1'') ');
          SQL.Add('    OR (' + func_GetFilter_Flg_Name(GPCST_SYUBETU_35) + ' = ''1'') ');
        end else
        //RI�Ɩ�
        if arg_PrgId = 'K1' then begin
//        SQL.Add(' WHERE (' + func_GetFilter_Flg_Name(GPCST_SYUBETU_13) + ' = ''1'') '); 2003.12.07
          //2003.12.19
          SQL.Add(' WHERE (' + func_GetFilter_Flg_Name(GPCST_SYUBETU_07) + ' = ''1'') ');
        end;

      end else
      begin
        w_StrsK := TStringList.Create;
        try
          try
            w_StrsK := func_StrToTStrList(arg_Initiali_Kensa);
            w_ret := w_StrsK.Count;
          except
            w_ret := 0;
          end;

          if w_ret = 0 then Exit;

          w_j := 0;

          for w_i := 0 to w_StrsK.Count -1 do begin
            w_Filter := func_GetFilter_Flg_Name(w_StrsK[w_i]);

            if w_Filter <> '' then begin
              w_j := w_j + 1;
              if w_j = 1 then begin
                SQL.Add('WHERE (' + w_Filter + ' = ''1'')');
              end else begin
                SQL.Add('   OR (' + w_Filter + ' = ''1'')');
              end;
            end;
          end;
        finally
          w_StrsK.Free;
        end;
      end;

      SQL.Add('ORDER BY DISP_CODE ');

      //�₢���킹�m�F
      if not Prepared then Prepare;
      Open;
      //�Ō�̃��R�[�h�Ɉړ�
      Last;
      //�ŏ��̃��R�[�h�Ɉړ�
      First;
      w_Exists := 0;
      while not(Eof) do begin
        for w_i := 0 to w_StrsS.Count-1 do begin
          if w_StrsS[w_i] = FieldByName('KENSAKIKI_ID').AsString then begin
            if w_Return <> '' then
              w_Return := w_Return + ',' + FieldByName('KENSAKIKI_ID').AsString
            else
              w_Return := w_Return + FieldByName('KENSAKIKI_ID').AsString;
            w_Exists := w_Exists + 1;
            Break;
          end;
        end;
        Next;
      end;
      if RecordCount = w_Exists then begin
        w_Return := '';
      end;
    end;

    Result := w_Return;
  finally
    w_StrsS.Free;
  end;

end;
//2003.10.06 Start**************************************************************
//******************************************************************************
//���@�\�i��O���j�F�O���b�h�J����������������
//******************************************************************************
function func_Gkit_ColumnSize_Write(arg_GGrid: TGKitSpreadControl; arg_Name,arg_No: string):Boolean;
var
  TxtFile: TextFile;
  w_Dir_Name: string;
  w_File_Name: string;
  w_Record: string[255];
  i: integer;
begin
  Result := True;
  w_File_Name := gi_columndir_DIR + arg_Name + '_' + arg_No + '.txt';
  w_Dir_Name  := ExtractFileDir(w_File_Name);
  if not(DirectoryExists(w_Dir_Name)) then begin
    if not(CreateDir(w_Dir_Name)) then begin
      Exit;
    end;
  end;

  w_Record := '';
  w_Record := arg_GGrid.ColsWidth;
  //��������
  try
    AssignFile(TxtFile, w_File_Name);
    Rewrite(TxtFile);
    try
      Writeln(TxtFile, w_Record);
    finally
      Flush(TxtFile);
      CloseFile(TxtFile);
    end;
  except
    raise Exception.Create('Cannot AssignFile ' + w_File_Name);
  end;
end;
//******************************************************************************
//���@�\�i��O���j�F�O���b�h�J��������ǂݍ���
//******************************************************************************
procedure proc_Gkit_ColumnSize_Read(arg_GGrid: TGKitSpreadControl; arg_Name,arg_No: string; var arg_Column: string);
var
  TxtFile: TextFile;
  w_File_Name: string;
  w_Record: string[255];
begin
  w_File_Name := gi_columndir_DIR + arg_Name + '_' + arg_No + '.txt';
  try
    if FileExists(w_File_Name) then begin
      //�P�s�̂ݓǂݍ���
      try
        AssignFile(TxtFile, w_File_Name);
        Reset(TxtFile);
        try
          while not Eof(TxtFile) do begin
            Readln(TxtFile, w_Record);
            //�ǂݍ��񂾍s���ް������݂���ꍇ
            if Length(Trim(w_Record)) > 0 then begin
              arg_Column := w_Record;
              Break;
            end;
          end;
        finally
          CloseFile(TxtFile);
        end;
      except
        raise Exception.Create('Cannot AssignFile ' + w_File_Name);
      end;
    end;
  finally
  end;
end;
//******************************************************************************
//���@�\�i��O���j�F�O���b�h�J���������Z�b�g����
//******************************************************************************
procedure proc_Gkit_ColumnSize_Set(arg_GGrid: TGKitSpreadControl; arg_Name,arg_No: string);
var
  w_Cols: string;
begin
  try
    //�J�������ǂݍ���
    proc_Gkit_ColumnSize_Read(arg_GGrid, arg_Name, arg_No, w_Cols);
    if w_Cols <> '' then begin
      arg_GGrid.ColsWidth := w_Cols;
    end;
  finally
  end;
end;
//2003.10.06 end**************************************************************

//2003.12.11*********************************************************************
//���@�\�i��O���j�F�`�[����t���O�̍X�V
//******************************************************************************
function func_Update_Denpyo_Insatu_flg(arg_DB:TDatabase          //�ް��ް�
                                       ;arg_Key_RIS_ID:string     //RIS_ID (�����J���}��؂�)
                                       ;var arg_Err:string
                                       ): Boolean;
var
  w_RisID_List:TStrings;
  w_Qry:TQuery;
  i:Integer;
  ws_RisID:String;
begin
  Result := True;

  if arg_Key_RIS_ID = '' then Exit;

  w_RisID_List := TStringList.Create;
  w_Qry := TQuery.Create(nil);
  try
    w_Qry.DatabaseName := arg_DB.DatabaseName;

    w_RisID_List.CommaText := arg_Key_RIS_ID;

    arg_DB.StartTransaction;
    for i:= 0 to w_RisID_List.Count -1 do begin
      ws_RisID := w_RisID_List[i];
      with w_Qry do begin
        Close;
        SQL.Clear;
        SQL.Add('UPDATE ORDERMAINTABLE SET ');
        SQL.Add('DENPYO_INSATU_FLG = :PDENPYO_INSATU_FLG ');
        SQL.Add('WHERE RIS_ID = :PRISID');

        ParamByName('PRISID').AsString := ws_RisID;

        ParamByName('PDENPYO_INSATU_FLG').AsString := GPCST_DENPYO_INSATU_FLG_1;
        //��������
        try
          ExecSQL;
        except
          Raise;
        end;
      end;
    end;
    try
      arg_DB.Commit; // ���������ꍇ�C�ύX���R�~�b�g����
    except
      on E: Exception do begin
        arg_DB.Rollback; // �R�~�b�g�Ŏ��s�����ꍇ�C�ύX��������
        arg_Err := E.Message;
        Result := False;
      end;
    end;
  finally
    FreeAndNil(w_RisID_List);
    FreeAndNil(w_Qry);
  end;

end;

//2004.03.11*********************************************************************
//���@�\�i��O���j�F�`�[����t���O�̍X�V (�j��w�p)
//******************************************************************************
function func_Update_Denpyo_Insatu_flg_RI(arg_DB:TDatabase          //�ް��ް�
                                       ;arg_Key_RIS_ID:string     //RIS_ID (�����J���}��؂�)
                                       ;var arg_Err:string
                                       ): Boolean;
var
  w_RisID_List:TStrings;
  w_Qry:TQuery;
  i:Integer;
  ws_RisID:String;
begin
  Result := True;

  if arg_Key_RIS_ID = '' then Exit;

  w_RisID_List := TStringList.Create;
  w_Qry := TQuery.Create(nil);
  try
    w_Qry.DatabaseName := arg_DB.DatabaseName;

    w_RisID_List.CommaText := arg_Key_RIS_ID;

    arg_DB.StartTransaction;
    for i:= 0 to w_RisID_List.Count -1 do begin
      ws_RisID := w_RisID_List[i];
      with w_Qry do begin
        Close;
        SQL.Clear;
        SQL.Add('UPDATE ORDERMAINTABLE SET ');
        SQL.Add('DENPYO_INSATU_FLG = to_number(nvl(DENPYO_INSATU_FLG,''0''))+1 ');
        SQL.Add('WHERE RIS_ID = :PRISID');

        ParamByName('PRISID').AsString := ws_RisID;

        //��������
        try
          ExecSQL;
        except
          Raise;
        end;
      end;
    end;
    try
      arg_DB.Commit; // ���������ꍇ�C�ύX���R�~�b�g����
    except
      on E: Exception do begin
        arg_DB.Rollback; // �R�~�b�g�Ŏ��s�����ꍇ�C�ύX��������
        arg_Err := E.Message;
        Result := False;
      end;
    end;
  finally
    FreeAndNil(w_RisID_List);
    FreeAndNil(w_Qry);
  end;

end;

//2004.01.13
function func_GyoumuKbn_Check(arg_KensaType:string; //�������
                              arg_Query:TQuery      //Query
                              ):string;
var
  w_Today:TDateTime; //���t+����
  w_Date:TDate; //���ɂ�
  w_Time:TTime; //����
  w_Day:string; //��������
  w_Week:integer; //1:�� 2:��... 7�F�y 8�F�Փ�

  //2004.05.12
  wi_Time:integer; //�����i�����^�j
begin
//
  //���ݎ����擾
  w_Today:=func_GetDBSysDate(arg_Query);
  w_Week:=DayOfWeek(w_Today);
  w_Date:=StrToDate(Copy(DateTimeToStr(w_Today),1,10));
  w_Time:=StrToTime(Copy(DateTimeToStr(w_Today),12,8));

  //2004.05.12
  //���ݎ����i�����^�j
  wi_Time:=StrToint(FormatDateTime('hhnnss',w_Today));

  //�Փ��`�F�b�N
  with arg_Query do begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT HIZUKE ');
    SQL.Add('  FROM CalendarMaster ');
    SQL.Add(' WHERE HIZUKE=:PHIZUKE ');
    SQL.Add('  ');
    ParamByName('PHIZUKE').AsString:=DateToStr(w_Today);
    if not Prepared then Prepare;
    Open;
    Last;
    First;
    if RecordCount>0 then begin
      //�Փ�
      w_Week:=8;
    end;
  end;

  if w_Week = 8 then begin
    //�Փ�
    //���t�擾
    //if (StrToTime(CST_GYOKBN_SAI_2_S)<=w_Time) and (w_Time<=StrToTime(CST_GYOKBN_SAI_2_E)) then begin
    //������Ŕ���(1/1000�b���r�ł��Ȃ���)2004.05.12
    if (StrToInt(func_Time8To6(CST_GYOKBN_SAI_2_S))<= wi_Time) and (wi_Time<=StrToInt(func_Time8To6(CST_GYOKBN_SAI_2_E))) then begin
      //����
      Result:=GSPCST_GYOUMU_KBN_2;
      Exit;
    end
    //2004.05.12 else if (StrToTime(CST_GYOKBN_SAI_3_S)<=w_Time) and (w_Time<=StrToTime(CST_GYOKBN_SAI_3_E)) then begin
    //������Ŕ���(1/1000�b���r�ł��Ȃ���)2004.05.12
    else if (StrToInt(func_Time8To6(CST_GYOKBN_SAI_3_S))<=wi_Time) and (wi_Time<=StrToInt(func_Time8To6(CST_GYOKBN_SAI_3_E))) then begin
      //�[��
      Result:=GSPCST_GYOUMU_KBN_3;
      Exit;
    end
    else begin
      //2004.05.12 //�ً}
      //2004.05.12 Result:=GSPCST_GYOUMU_KBN_4;
      //����
      Result:=GSPCST_GYOUMU_KBN_1;
      Exit;
    end;
  end
  else if w_Week = 1 then begin
    //���j��
    //2004.05.12 if (StrToTime(CST_GYOKBN_SUN_2_S)<=w_Time) and (w_Time<=StrToTime(CST_GYOKBN_SUN_2_E)) then begin
    //������Ŕ���(1/1000�b���r�ł��Ȃ���)2004.05.12
    if (StrToInt(func_Time8To6(CST_GYOKBN_SUN_2_S))<=wi_Time) and (wi_Time<=StrToInt(func_Time8To6(CST_GYOKBN_SUN_2_E))) then begin
      //����
      Result:=GSPCST_GYOUMU_KBN_2;
      Exit;
    end
    //2004.05.12 else if (StrToTime(CST_GYOKBN_SUN_3_S)<=w_Time) and (w_Time<=StrToTime(CST_GYOKBN_SUN_3_E)) then begin
    //������Ŕ���(1/1000�b���r�ł��Ȃ���)2004.05.12
    else if (StrToInt(func_Time8To6(CST_GYOKBN_SUN_3_S))<=wi_Time) and (wi_Time<=StrToInt(func_Time8To6(CST_GYOKBN_SUN_3_E))) then begin
      //�[��
      Result:=GSPCST_GYOUMU_KBN_3;
      Exit;
    end
    else begin
      //2004.05.12 //�ً}
      //2004.05.12 Result:=GSPCST_GYOUMU_KBN_4;
      //����
      Result:=GSPCST_GYOUMU_KBN_1;
      Exit;
    end;
  end
  else if w_Week = 7 then begin
    //�y�j��
    w_Day:=Copy(DateToStr(w_Date),9,2);
    if (StrToInt(w_Day)<8) or ((StrToInt(w_Day)>=15) and (StrToInt(w_Day)<=21)) then begin
      //��P,�R�T
      //2004.05.12 if (StrToTime(CST_GYOKBN_SAT_13_2_S)<=w_Time) and (w_Time<=StrToTime(CST_GYOKBN_SAT_13_2_E)) then begin
      //������Ŕ���(1/1000�b���r�ł��Ȃ���)2004.05.12
      if (StrToInt(func_Time8To6(CST_GYOKBN_SAT_13_2_S))<=wi_Time) and (wi_Time<=StrToInt(func_Time8To6(CST_GYOKBN_SAT_13_2_E))) then begin
        //����
        Result:=GSPCST_GYOUMU_KBN_2;
        Exit;
      end
      //2004.05.12 else if (StrToTime(CST_GYOKBN_SAT_13_3_S)<=w_Time) and (w_Time<=StrToTime(CST_GYOKBN_SAT_13_3_E)) then begin
      //������Ŕ���(1/1000�b���r�ł��Ȃ���)2004.05.12
      else if (StrToInt(func_Time8To6(CST_GYOKBN_SAT_13_3_S))<=wi_Time) and (wi_Time<=StrToInt(func_Time8To6(CST_GYOKBN_SAT_13_3_E))) then begin
        //�[��
        Result:=GSPCST_GYOUMU_KBN_3;
        Exit;
      end
      else begin
        //2004.05.12 //�ً}
        //2004.05.12 Result:=GSPCST_GYOUMU_KBN_4;
        //����
        Result:=GSPCST_GYOUMU_KBN_1;
        Exit;
      end;
    end
    else begin
      //��Q,�S,�T�T
      //2004.05.12 if (StrToTime(CST_GYOKBN_SAT_245_1_S)<=w_Time) and (w_Time<=StrToTime(CST_GYOKBN_SAT_245_1_E)) then begin
      //������Ŕ���(1/1000�b���r�ł��Ȃ���)2004.05.12
      if (StrToInt(func_Time8To6(CST_GYOKBN_SAT_245_1_S))<=wi_Time) and (wi_Time<=StrToInt(func_Time8To6(CST_GYOKBN_SAT_245_1_E))) then begin
        //����
        if arg_KensaType=GPCST_SYUBETU_01 then
          //��ʎB�e
          Result:=GSPCST_GYOUMU_KBN_1
        else
          //2004.05.12 Result:=GSPCST_GYOUMU_KBN_4;
          Result:=GSPCST_GYOUMU_KBN_1;
        Exit;
      end
      //2004.05.12 else if (StrToTime(CST_GYOKBN_SAT_245_2_S)<=w_Time) and (w_Time<=StrToTime(CST_GYOKBN_SAT_245_2_E)) then begin
      //������Ŕ���(1/1000�b���r�ł��Ȃ���)2004.05.12
      else if (StrToInt(func_Time8To6(CST_GYOKBN_SAT_245_2_S))<=wi_Time) and (wi_Time<=StrToInt(func_Time8To6(CST_GYOKBN_SAT_245_2_E))) then begin
        //����
        Result:=GSPCST_GYOUMU_KBN_2;
        Exit;
      end
      //2004.05.12 else if (StrToTime(CST_GYOKBN_SAT_245_3_S)<=w_Time) and (w_Time<=StrToTime(CST_GYOKBN_SAT_245_3_E)) then begin
      //������Ŕ���(1/1000�b���r�ł��Ȃ���)2004.05.12
      else if (StrToInt(func_Time8To6(CST_GYOKBN_SAT_245_3_S))<=wi_Time) and (wi_Time<=StrToInt(func_Time8To6(CST_GYOKBN_SAT_245_3_E))) then begin
        //�[��
        Result:=GSPCST_GYOUMU_KBN_3;
        Exit;
      end
      else begin
        //2004.05.12 //�ً}
        //2004.05.12 Result:=GSPCST_GYOUMU_KBN_4;
        //����
        Result:=GSPCST_GYOUMU_KBN_1;
        Exit;
      end;
    end;
  end
  else begin
    //����
    //2004.05.12 if (StrToTime(CST_GYOKBN_NOR_1_S)<=w_Time) and (w_Time<=StrToTime(CST_GYOKBN_NOR_1_E)) then begin
    //������Ŕ���(1/1000�b���r�ł��Ȃ���)2004.05.12
    if (StrToInt(func_Time8To6(CST_GYOKBN_NOR_1_S))<=wi_Time) and (wi_Time<=StrToInt(func_Time8To6(CST_GYOKBN_NOR_1_E))) then begin
      //����
      if arg_KensaType=GPCST_SYUBETU_01 then
        //��ʎB�e
        Result:=GSPCST_GYOUMU_KBN_1
      else
        //2004.05.12 Result:=GSPCST_GYOUMU_KBN_4;
        Result:=GSPCST_GYOUMU_KBN_1;
      Exit;
    end
    //2004.05.12 else if (StrToTime(CST_GYOKBN_NOR_2_S)<=w_Time) and (w_Time<=StrToTime(CST_GYOKBN_NOR_2_E)) then begin
    //������Ŕ���(1/1000�b���r�ł��Ȃ���)2004.05.12
    else if (StrToInt(func_Time8To6(CST_GYOKBN_NOR_2_S))<=wi_Time) and (wi_Time<=StrToInt(func_Time8To6(CST_GYOKBN_NOR_2_E))) then begin
      //����
      Result:=GSPCST_GYOUMU_KBN_2;
      Exit;
    end
    //2004.05.12 else if (StrToTime(CST_GYOKBN_NOR_3_S)<=w_Time) and (w_Time<=StrToTime(CST_GYOKBN_NOR_3_E)) then begin
    //������Ŕ���(1/1000�b���r�ł��Ȃ���)2004.05.12
    else if (StrToInt(func_Time8To6(CST_GYOKBN_NOR_3_S))<=wi_Time) and (wi_Time<=StrToInt(func_Time8To6(CST_GYOKBN_NOR_3_E))) then begin
      //�[��
      Result:=GSPCST_GYOUMU_KBN_3;
      Exit;
    end
    else begin
      //2004.05.12 //�ً}
      //2004.05.12 Result:=GSPCST_GYOUMU_KBN_4;
      //����
      Result:=GSPCST_GYOUMU_KBN_1;
      Exit;
    end;
  end;

end;

//�����у��C����RIS���ʔԍ��ő�l���X�V�i���{���j 2004.03.29
// �g�����U�N�V�������J�n����Ă��鎖���O��
// �K�����{�����Ŏ��у��C���A���ѕ��ʍX�V��ɂ��̊֐����Ăяo��
// ���у��C���A���ѕ��ʂƓ����^�C�~���O�ŃR�~�b�g�i�����g�����U�N�V���������j
function func_Up_ExRis_Bui_No_Max(arg_RisID:string; //RIS����ID
                              arg_Query:TQuery      //Query
                              ):Boolean;
var
  w_MaxNo:string;
  w_Sel_Query: TQuery;
  w_New_Bui_No: Integer;
  w_New_Bui_No_Max: Integer;
begin
  w_MaxNo := '';
  //���ρA���~�̃I�[�_�ŕ��ʔԍ��̍ő�l���擾
  with arg_Query do begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT max(nvl(exb.RIS_BUI_NO,0)) MAX_NO ');
    SQL.Add('  FROM EXBUITABLE exb, EXMAINTABLE exm ');
    SQL.Add(' WHERE exb.RIS_ID = exm.RIS_ID ');
    SQL.Add('   AND exm.RIS_ID = :PRIS_ID ');
    SQL.Add('   AND ((exm.KENSASTATUS_FLG = ''' + GPCST_CODE_KENSIN_3 + ''') ');
    SQL.Add('     OR (exm.KENSASTATUS_FLG = ''' + GPCST_CODE_KENSIN_4 + ''')) ');
    SQL.Add('  ');
    ParamByName('PRIS_ID').AsString:=arg_RisID;
    if not Prepared then Prepare;
    Open;
    Last;
    First;
    if not Eof then begin
      //�ő�l�擾
      w_MaxNo := FieldByName('MAX_NO').AsString;
    end;
    Close;
  end;

  //�ő�l���擾�ł��Ȃ����͏����I��
  if w_MaxNo = '' then Exit;

  w_New_Bui_No_Max := StrToInt(w_MaxNo);
  w_New_Bui_No     := 0;

  w_Sel_Query := TQuery.Create(nil);
  try
    w_Sel_Query.DatabaseName := arg_Query.DatabaseName;

    w_Sel_Query.Close;
    w_Sel_Query.SQL.Clear;
    w_Sel_Query.SQL.Add('SELECT exb.NO, nvl(exm.RIS_BUI_NO_MAX,0) RIS_BUI_NO_NEW ');
    w_Sel_Query.SQL.Add('  FROM EXBUITABLE exb, EXMAINTABLE exm ');
    w_Sel_Query.SQL.Add(' WHERE exm.RIS_ID = exb.RIS_ID ');
    w_Sel_Query.SQL.Add('   AND exm.RIS_ID = :PRIS_ID ');
    w_Sel_Query.SQL.Add('   AND exb. RIS_BUI_NO is null ');
    w_Sel_Query.SQL.Add(' ORDER BY NO ');
    w_Sel_Query.ParamByName('PRIS_ID').AsString:=arg_RisID;
    if not w_Sel_Query.Prepared then w_Sel_Query.Prepare;
    w_Sel_Query.Open;
    w_Sel_Query.Last;
    w_Sel_Query.First;
    if not w_Sel_Query.Eof then w_New_Bui_No := w_Sel_Query.FieldByName('RIS_BUI_NO_NEW').AsInteger;
    while not w_Sel_Query.Eof do begin
      w_New_Bui_No := w_New_Bui_No + 1;
      arg_Query.SQL.Clear;
      arg_Query.SQL.Add('UPDATE EXBUITABLE SET ');
      arg_Query.SQL.Add(' RIS_BUI_NO = :PRIS_BUI_NO ');
      arg_Query.SQL.Add(' WHERE RIS_ID = :PRIS_ID ');
      arg_Query.SQL.Add('   AND NO = :PNO ');
      if not arg_Query.Prepared then arg_Query.Prepare;
      arg_Query.ParamByName('PRIS_ID').AsString      := arg_RisID;
      arg_Query.ParamByName('PNO').AsInteger         := w_Sel_Query.FieldByName('NO').AsInteger;
      arg_Query.ParamByName('PRIS_BUI_NO').AsInteger := w_New_Bui_No;
      arg_Query.ExecSQL;
      arg_Query.Close;

      w_Sel_Query.Next;
    end;
  finally
    w_Sel_Query.Close;
    FreeAndNil(w_Sel_Query);
  end;

  if w_New_Bui_No_Max < w_New_Bui_No then w_New_Bui_No_Max := w_New_Bui_No;

  //���у��C����RIS���ʔԍ��ő�l���X�V
  with arg_Query do begin
    Close;
    SQL.Clear;
    SQL.Add('UPDATE EXMAINTABLE SET ');
    SQL.Add(' RIS_BUI_NO_MAX = :PRIS_BUI_NO_MAX ');
    SQL.Add('WHERE ');
    SQL.Add(' RIS_ID = :PRIS_ID ');
    SQL.Add('  AND nvl(RIS_BUI_NO_MAX,0) < ' + IntToStr(w_New_Bui_No_Max) + ' ');  //MAX���傫���Ȃ�ꍇ����
    if not Prepared then Prepare;
    ParamByName('PRIS_BUI_NO_MAX').AsInteger  := w_New_Bui_No_Max;
    //�L�[
    ParamByName('PRIS_ID').AsString  := arg_RisID;
    ExecSQL;
  end;

end;

//�����у��C����RIS���ʔԍ��ő�l���X�V�i�I�[�_�쐬���j 2004.03.30
// ����̎��ѕ��ʂ�RIS���ʔԍ��ő�l�ōX�V
function func_Up_Pre_ExRis_Bui_No_Max(arg_RisID:string; //RIS����ID
                                      arg_Query:TQuery      //Query
                                      ):Boolean;
var
  w_MaxNo:string;
begin
  w_MaxNo := '';
  try
  //���ʔԍ��̍ő�l���擾
  with arg_Query do begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT max(nvl(RIS_BUI_NO,0)) MAX_NO ');
    SQL.Add('  FROM EXBUITABLE ');
    SQL.Add(' WHERE RIS_ID = :PRIS_ID ');
    SQL.Add('  ');
    ParamByName('PRIS_ID').AsString:=arg_RisID;
    if not Prepared then Prepare;
    Open;
    Last;
    First;
    if not Eof then begin
      //�ő�l�擾
      w_MaxNo := FieldByName('MAX_NO').AsString;
    end;
    Close;
  end;

  //�ő�l���擾�ł��Ȃ����͏����I��
  if w_MaxNo = '' then Exit;

  //���у��C����RIS���ʔԍ��ő�l���X�V
  with arg_Query do begin
    Close;
    SQL.Clear;
    SQL.Add('UPDATE EXMAINTABLE SET ');
    SQL.Add(' RIS_BUI_NO_MAX = :PRIS_BUI_NO_MAX ');
    SQL.Add('WHERE ');
    SQL.Add(' RIS_ID = :PRIS_ID ');
    if not Prepared then Prepare;
    ParamByName('PRIS_BUI_NO_MAX').AsString  := w_MaxNo;
    //�L�[
    ParamByName('PRIS_ID').AsString  := arg_RisID;
    ExecSQL;
    Close;
  end;

  except
    arg_Query.Close;
    raise;
  end;

end;
//2004.04.09
//���@�\�i��O���j�FRIS�I�[�_���̓]���I�[�_�A�]��Report�e�[�u���ւ̃L���[�쐬����
//�@�ڍׁ@�_�~�[���Ҕ���A�I�[�_�쐬���̃��|�[�g���M�L���[�쐬����ARIS�I�[�_����HIS�AReport���M����
//�@���ӎ����@�֐��g�p�O��proc_SetOrderSoushin�֐������s����Ă��鎖���O��
function func_Check_CueAndDummy(arg_SysKbn:string;   //�V�X�e���敪
                                arg_KanjaID:string;  //����ID
                                arg_Mode:integer     //0:��t���{Report�o�^ 1:��t���{�]���I�[�_�o�^  2:�I�[�_�쐬Report�o�^
                               ):Boolean;
var
//wb_Kanja:Boolean;
//wb_Order:Boolean;
//wb_Report:Boolean;
ws_Yoyaku:string;
begin
//

  Result:=False;
  //wb_Order:=True;
  //wb_Report:=True;

  //�_�~�[����ID����
  if func_Get_WinMaster_DATA('',g_DUMMYKANJA,g_DUMMYKANJA_KEY+arg_KanjaID)<> '' then Exit;

  //�V�X�e���敪��HIS�I�[�_�̏ꍇ
  if arg_SysKbn=GPCST_CODE_SYSK_HIS then begin
    Result:=True;
    Exit;
  end;

  //0:��t���{Report�o�^
  if arg_Mode=0 then begin
    //Report���M�Ȃ�
    if g_RIS_Order_Sousin_Flg=GPCST_RISORDERSOUSIN_FLG_0 then Exit;
  end else
  //1:��t���{�]���I�[�_�o�^
  if arg_Mode=1 then begin
    //HIS���M�Ȃ�
    if ((g_RIS_Order_Sousin_Flg=GPCST_RISORDERSOUSIN_FLG_0 )  or
        (g_RIS_Order_Sousin_Flg=GPCST_RISORDERSOUSIN_FLG_2 )) then Exit;
  end else
  //2:�I�[�_�쐬Report�o�^
  if arg_Mode=2 then begin
    //Report���M�Ȃ�
    if g_RIS_Order_Sousin_Flg=GPCST_RISORDERSOUSIN_FLG_0 then Exit;
    //�I�[�_�쐬���̃��|�[�g���M�L���[�쐬�ݒ���擾
    ws_Yoyaku:=func_Get_WinMaster_DATA('',g_REPORT,g_REPORT_YOYAKU);
    //Report���M�L���[�쐬�Ȃ�
    if ws_Yoyaku<>GPCST_REPORT_FLG_1 then Exit;
  end;

  Result:=True;


  {2004.04.09
  //�_�~�[����ID����
  if func_Get_WinMaster_DATA('',g_DUMMYKANJA,g_DUMMYKANJA_KEY+arg_KanjaID)<> '' then
    //��аID
      //wb_Kanja:=False
    //��аID�Ȃ̂�Result=False�̂܂܏����I��
    Exit
  else
    //��аID����Ȃ�
    wb_Kanja:=True;

  //�V�X�e���敪����
  if arg_SysKbn=GPCST_CODE_SYSK_HIS then begin
    Result:=True;
    Exit;
  end;

  //RIS�I�[�_���M�L���[����
  if arg_Mode=1 then begin

    //��t���{�]���I�[�_
    if ((g_RIS_Order_Sousin_Flg=GPCST_RISORDERSOUSIN_FLG_0 )  or
        (g_RIS_Order_Sousin_Flg=GPCST_RISORDERSOUSIN_FLG_2 )) then
      wb_Order:=False
    else
      wb_Order:=True;

  end
  else if arg_Mode=0 then begin

    //��t���{Report
    if (g_RIS_Order_Sousin_Flg=GPCST_RISORDERSOUSIN_FLG_1 ) or
       (g_RIS_Order_Sousin_Flg=GPCST_RISORDERSOUSIN_FLG_2 ) then
      wb_Order:=True
    else
      wb_Order:=False;

  end
  else if arg_Mode=2 then begin

    //�I�[�_�쐬��Report�o�^

    if (g_RIS_Order_Sousin_Flg=GPCST_RISORDERSOUSIN_FLG_1 ) or
       (g_RIS_Order_Sousin_Flg=GPCST_RISORDERSOUSIN_FLG_2 ) then
      wb_Order:=True
    else
      wb_Order:=False;

    ws_Yoyaku:=func_Get_WinMaster_DATA('',g_REPORT,g_REPORT_YOYAKU);
    if (ws_Yoyaku=GPCST_REPORT_FLG_1) then
      wb_Report:=True
    else
      wb_Report:=False;

  end;

  if (wb_Kanja=True)  and
     (wb_Order=True)  and
     (wb_Report=True) then
    Result:=True
  else
    Result:=False;
  2004.04.09}
end;
//2004.01.09
//���@�\�i��O���j�FRIS�I�[�_���M�t���O�Z�b�g
procedure proc_SetOrderSoushin;
begin
//
  g_RIS_Order_Sousin_Flg := func_Get_WinMaster_DATA(g_PARAM01_GP00,g_RISORDER,g_RISORDER_SOUSIN);
  if (g_RIS_Order_Sousin_Flg <> GPCST_RISORDERSOUSIN_FLG_1) and
     (g_RIS_Order_Sousin_Flg <> GPCST_RISORDERSOUSIN_FLG_2) then
    g_RIS_Order_Sousin_Flg := GPCST_RISORDERSOUSIN_FLG_0;
end;
//���@�\�i��O���j�F �_�~�[���Ҕ��� 2004.08.06
function func_Check_DummyKanja(arg_KanjaID:string  //����ID
                               ):Boolean;
begin
  Result := False;
  if func_Get_WinMaster_DATA('',g_DUMMYKANJA,g_DUMMYKANJA_KEY + arg_KanjaID) <> '' then
    Result := True;

end;
//���@�\�i��O���j�F���t����A�j���A�j���}�X�^)���l�������Ƃ���
function GetWeekInfo(Day:String; Week,SName:TPanel):Boolean;
Var
  DDate:Tdate;
  Qry:TQuery;
begin
  Result := False;
  Week.Caption := '';
  Week.Font.Color := clWindowText;

  SName.Caption := '';
  SName.Font.Color := clWindowText;
  if Day = '' then Exit;

  DDate := StrtoDate(Day);
  case DayOfWeek(DDate) of
    1: begin
         Week.Caption := '���j��';
         Week.Font.Color := clRed;
       end;
    2: Week.Caption := '���j��';
    3: Week.Caption := '�Ηj��';
    4: Week.Caption := '���j��';
    5: Week.Caption := '�ؗj��';
    6: Week.Caption := '���j��';
    7: begin
         Week.Caption := '�y�j��';
         Week.Font.Color := clBlue;
       end;
  end;
  Qry := TQuery.Create(Nil);
  try
    Qry.DatabaseName := DM_DbAcc.DBs_MSter.DatabaseName;
    with Qry do begin
      //����
      Close;
      //�O��SQL���̃N���A
      SQL.Clear;
      //SQL���쐬
      SQL.Add('SELECT BIKO ');
      SQL.Add('FROM CALENDARMASTER ');
      SQL.Add('WHERE HIZUKE = :PHIZUKE ');
      if not Prepared then Prepare;
      ParamByName('PHIZUKE').AsString := Day;
      Open;
      Last;
      First;
      if (Qry.RecordCount > 0)  then begin
        SName.Caption := Qry.FieldByName('BIKO').AsString;
        SName.Font.Color := clRed;
      end;
    end;
  finally
    FreeAndNil(Qry);
  end;

  Result := True;
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
