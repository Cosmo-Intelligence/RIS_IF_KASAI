unit pdct_uketuke;
{
���@�\���� �i�g�p�\��F����j
 EXE�v���W�F�N�g�̎�t�������ʃ��[�`��

������
�@
�C���F2002.11.08�F�J��
�@�@�@�@�@�@�@�@�@���ݗp��ID���������ID����B�e��ID�ɕύX�B
�ǉ��F2002.11.12�F���c �M
                  �����ȊO�̃I�[�_�̏ꍇw_Not_Toujitu��ǉ�
                  �����ȊO�I�[�_����t���鎞�\�������ɉ������Ȃ�
�C���F2003.12.10�F�J��
�@�@�@�@�@�@�@�@�@��t�o�^��,�L�����Z������TENSOUPACSTABLE,TENSOUREPORTTABLE�ւ̏������݂��������B
�C���F2003.12.15�F�J��
�@�@�@�@�@�@�@�@�@�I�[�_�L�����Z�����Ɏg�p���Ă���A�I�[�_���ʃe�[�u���̕��ʃR�����gID�P�`�T�𕔈ʃR�����g�ɕύX�B
�ǉ��F2003.12.16�F����
                  ��t�o�^�����ɓ��ӏ��敪�ǉ�
�ύX�F2004.03.05  ���у��C���e�[�u���ɓǉeF���ǉ����ꂽ���Ƃɂ���Ď�t�L�����Z�����ɓǉeF���I�[�_���ɖ߂�
�ǉ��F2004.04.09�F����
                  ��t�E��t�L�����Z�����ɓ]���I�[�_�e�[�u���Ɠ]�����|�[�g�e�[�u���ւ̏����ݐ����ǉ�
�ύX�F2004.04.12�F����
                  ��t�E��t�L�����Z�����A�]���I�[�_�e�[�u���Ɠ]�����|�[�g�e�[�u���Ɋ��ҶŎ�����o�^����悤�ɕύX
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
//�v���_�N�g�J�����ʁ|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|
  Gval,
//  myInitInf,
//  pdct_ini,
  pdct_com,
//  KanaRoma,
  ErrorMsg,
  DB_ACC;
//  Trace;

////�^�N���X�錾-------------------------------------------------------------
//type
//�萔�錾-------------------------------------------------------------------

const
CST_MODE_RISORDER = '1'; //RIS�I�[�_�o�^���
CST_ERRCODE_00 = '00'; //�ǂݍ��݃G���[
CST_ERRCODE_01 = '51'; //�i���G���[
CST_ERRCODE_02 = '52'; //�����i���G���[
CST_ERRCODE_05 = '55'; //��tNO�擾�G���[
CST_ERRCODE_07 = '57'; //�d���A�Ԏ擾�G���[
CST_ERRCODE_08 = '58'; //�X�V�����擾�G���[
CST_ERRCODE_10 = '60'; //�������݃G���[

CST_ERRCODE_12 = '62'; //�d���A�Ԏ擾�G���[(�]�����ҏ��e�[�u���p)
CST_ERRCODE_13 = '63'; //�d���A�Ԏ擾�G���[(Pacs-Ris�]���I�[�_�e�[�u���p)
CST_ERRCODE_14 = '64'; //�d���A�Ԏ擾�G���[(Report-Ris�]���I�[�_�e�[�u���p)
CST_ERRCODE_16 = '66'; //�D��t���O�G���[
CST_ERRCODE_17 = '67'; //��t�G���[
CST_YOBI_MODE_0 = '0'; //�ďo�������[�h
CST_YOBI_MODE_1 = '1'; //�ďo/�Čă��[�h

CST_KAKUHO_MODE_0 = '0'; //�m�ۉ������[�h
CST_KAKUHO_MODE_1 = '1'; //�m�ۃ��[�h

CST_TIKOKU_MODE_0 = '0'; //�x���������[�h
CST_TIKOKU_MODE_1 = '1'; //�x�����[�h

//�R�����g�t�B�[���h���̗p
type COM_FIELD = array[1..15] of String;
const
  COM_FIELD_NAME : COM_FIELD =
  ('COMMENT_ID_01','COMMENT_ID_02','COMMENT_ID_03','COMMENT_ID_04','COMMENT_ID_05',
   'COMMENT_ID_06','COMMENT_ID_07','COMMENT_ID_08','COMMENT_ID_09','COMMENT_ID_10',
   'COMMENT_ID_11','COMMENT_ID_12','COMMENT_ID_13','COMMENT_ID_14','COMMENT_ID_15');
//�R�����g�t�B�[���h��
CST_COM_S = 1;
CST_COM_E = 15;

//�ϐ��錾-------------------------------------------------------------------
//var
//�֐��葱���錾-------------------------------------------------------------
//���@�\�i��O�L�j�F��t����
function func_Uketuke_Kyotu(
         arg_DB:TDatabase;             //�ڑ����ꂽDB
         arg_Mode:string;              //0:��t�����A1:RIS�I�[�_�o�^�̎�t����
         arg_PROG_ID:string;           //�v���O����ID
         arg_Ris_ID:TStrings;            //RIS����ID
         arg_Kanja_ID:string;          //����ID
         arg_KensaDate:string;         //�\���(yyyy/mm/dd)
         arg_Uketukesya_ID:string;     //��t��ID
         arg_Kensastatus_Flg:string;   //�X�V�O�̌����i��
         arg_Kensasubstatus_Flg:string; //�X�V�O�̌����i������׸�
         arg_Kensatype_ID:string;      //�X�V�O�̌������(RIS�I�[�_�o�^�̂�)
         arg_Kensatype_Name:string;    //�X�V�O�̌�����ʖ���(RIS�I�[�_�o�^�̂�)
         arg_Douji_Uke_Flg: string;    //������t�̗L��(0:�Ȃ��A1:����)(��t�o�^�̂�)        �|���g�p
         arg_UkeJun:string;            //������t�̎�t��(��t�o�^�̂݁A������t�L�̏ꍇ�̂�)�|���g�p
         arg_First_KensatypeID:string; //������t�̍ŏ��̌������(��t�o�^�̂݁A������t�L�Ŏ�t�����Q�Ԗڈȍ~�̏ꍇ�̂�)�|���g�p
         arg_RenrakuMemo: string;      //�A������
         arg_DouishoKbn: string;       //���ӏ��敪 //2003.12.16
         var arg_Error_Code:string;    //�G���[�R�[�h
         var arg_Error_Message:string; //�G���[���b�Z�[�W
         var arg_Error_SQL:string;     //�G���[SQL��
         var arg_Error_Haita:Boolean   //�r���폜�G���[ True:�r��ð��ٍ폜���s�AFalse:�r��ð��ٍ폜����
         ):Integer;                    //����0:�����A1:�r��/�i���װ�A2:�i���X�V�װ�A3:���Mð��ُ����ݴװ
//���@�\�i��O�L�j�F��t����(�|�[�^�u��)
function func_Uketuke_Portable(
         arg_DB:TDatabase;             //�ڑ����ꂽDB
         arg_Mode:string;              //0:��t�����A1:RIS�I�[�_�o�^�̎�t����
         arg_PROG_ID:string;           //�v���O����ID
         arg_Ris_ID:TStrings;            //RIS����ID
         arg_Kanja_ID:Tstrings;          //����ID
         arg_KensaDate:string;         //�\���(yyyy/mm/dd)
         arg_Uketukesya_ID:string;     //��t��ID
         var arg_Error_Code:string;    //�G���[�R�[�h
         var arg_Error_Message:string; //�G���[���b�Z�[�W
         var arg_Error_SQL:string;     //�G���[SQL��
         var arg_Error_Haita:Boolean   //�r���폜�G���[ True:�r��ð��ٍ폜���s�AFalse:�r��ð��ٍ폜����
         ):Integer;                    //����0:�����A1:�r��/�i���װ�A2:�i���X�V�װ�A3:���Mð��ُ����ݴװ
//���@�\�i��O�L�j�FRIS����ID�쐬
function func_Uketuke_Make_RisID(
         arg_DB:TDatabase;             //�ڑ����ꂽDB
         arg_Query:TQuery;             //�ڑ����ꂽQuery
         arg_DateTime:string           //��������
         ):string;
//���@�\�i��O�L�j�F�I�[�_NO�쐬
function func_Uketuke_Make_OrderNO(
         arg_DB:TDatabase;             //�ڑ����ꂽDB
         arg_Query:TQuery;             //�ڑ����ꂽQuery
         arg_DateTime:string           //��������
         ):string;
//���@�\�i��O�L�j�F��tNO�쐬
function func_Uketuke_Make_UketukeNO(
         arg_DB:TDatabase;             //�ڑ����ꂽDB
         arg_Query:TQuery;             //�ڑ����ꂽQuery
         arg_DateTime:string;          //��������
         arg_KID:string                //�敪
         ):string;
//���@�\�i��O�L�j�F����NO�쐬
function func_Uketuke_Make_ToujituNO(
         arg_DB:TDatabase;             //�ڑ����ꂽDB
         arg_Query:TQuery;             //�ڑ����ꂽQuery
         arg_DateTime:string           //��������
         ):string;
//���@�\�i��O�L�j�F�d���A�ԍ쐬
function func_Uketuke_Make_DenbunNO(
         arg_DB:TDatabase;             //�ڑ����ꂽDB
         arg_Query:TQuery;             //�ڑ����ꂽQuery
         arg_DateTime:string           //��������
         ):string;
//���@�\�i��O�L�j�F�d���A�ԍ쐬(�]�����ҏ��e�[�u��)
function func_Uketuke_Make_KanjaDenbunNO(
         arg_DB:TDatabase;             //�ڑ����ꂽDB
         arg_Query:TQuery;             //�ڑ����ꂽQuery
         arg_DateTime:string           //��������
         ):string;
//���@�\�i��O�L�j�F�d���A�ԍ쐬(Pacs-Ris�]���I�[�_�e�[�u��)
function func_Uketuke_Make_PacsDenbunNO(
         arg_DB:TDatabase;             //�ڑ����ꂽDB
         arg_Query:TQuery;             //�ڑ����ꂽQuery
         arg_DateTime:string           //��������
         ):string;
//���@�\�i��O�L�j�F�d���A�ԍ쐬(Report-Ris�]���I�[�_�e�[�u��)
function func_Uketuke_Make_ReportDenbunNO(
         arg_DB:TDatabase;             //�ڑ����ꂽDB
         arg_Query:TQuery;             //�ڑ����ꂽQuery
         arg_DateTime:string           //��������
         ):string;
//���@�\�i��O�L�j�FSUID�����A�ԍ쐬
function func_Uketuke_Make_ToujituSUID(
         arg_DB:TDatabase;             //�ڑ����ꂽDB
         arg_Query:TQuery;             //�ڑ����ꂽQuery
         arg_DateTime:string           //��������
         ):string;
//���@�\�i��O�L�j�F��t�L�����Z������
function func_UketukeCancel_Kyotu(
         arg_DB:TDatabase;             //�ڑ����ꂽDB
         arg_PROG_ID:string;           //�v���O����ID
         arg_Ris_ID:string;            //RIS����ID
         arg_Kanja_ID:string;          //����ID
         arg_KensaDate:string;         //�\���(yyyy/mm/dd)
         arg_Uketukesya_Name:string;   //��t�Җ�
         arg_Kensastatus_Flg:string;   //�X�V�O�̌����i��
         arg_KensaSubstatus_Flg:string;   //�X�V�O�̌����i���T�u
         var arg_Error_Code:string;    //�G���[�R�[�h
         var arg_Error_Message:string; //�G���[���b�Z�[�W
         var arg_Error_SQL:string;     //�G���[SQL��
         var arg_Error_Haita:Boolean   //�r���폜�G���[ True:�r��ð��ٍ폜���s�AFalse:�r��ð��ٍ폜����
         ):Integer;                    //����0:�����A1:�r��/�i���װ�A2:�i���X�V�װ�A3:���Mð��ُ����ݴװ


{2002.12.06
//���@�\�i��O�L�j�FWorklistInfo�쐬
function func_WorklistInfo_Kyotu(
         arg_DB:TDatabase;             //�ڑ����ꂽDB
         arg_Ris_ID: string;           //RIS����ID
         var arg_Error_Message:string  //�G���[���b�Z�[�W
         ):Boolean;
2002.12.06}

//���@�\�i��O�L�j�F��t�D��t���O�̐؂�ւ�����
function func_Yuusen_Change(
         arg_DB:TDatabase;             //�ڑ����ꂽDB
         arg_PROG_ID:string;           //�v���O����ID
         arg_Ris_ID:string;            //RIS����ID
         arg_YuusenFlg:string;         //�D��t���O�i���݂̒l�j
         arg_NewYuusenFlg:string;      //�ύX�D��t���O�i�ύX���ׂ��l�j
         var arg_Error_Code:string;    //�G���[�R�[�h
         var arg_Error_Message:string; //�G���[���b�Z�[�W
         var arg_Error_SQL:string;      //�G���[SQL��
         var arg_Error_Haita:Boolean   //�r���폜�G���[ True:�r��ð��ٍ폜���s�AFalse:�r��ð��ٍ폜����
         ):boolean;                    //����True���� False���s


//���@�\�i��O�L�j�F�x���X�e�[�^�X�̐؂�ւ�����
function func_Tikoku_Change(
         arg_DB:TDatabase;             //�ڑ����ꂽDB
         arg_PROG_ID:string;           //�v���O����ID
         arg_Ris_ID:string;            //RIS����ID
         arg_Status:string;            //�X�e�[�^�X�i����/�����j
         arg_SubStatus:string;         //�T�u�X�e�[�^�X�i����/�ďo/�Č�/�ۗ�/�Ď�j
         arg_Mode:string;              //�x��/�������[�h�i1:�x��/0:�����j
         var arg_Error_Code:string;    //�G���[�R�[�h
         var arg_Error_Message:string; //�G���[���b�Z�[�W
         var arg_Error_SQL:string;     //�G���[SQL��
         var arg_Error_Haita:Boolean   //�r���폜�G���[ True:�r��ð��ٍ폜���s�AFalse:�r��ð��ٍ폜����
         ):boolean;                    //����True���� False���s

//���@�\�i��O�L�j�F�ďo�A�ČăX�e�[�^�X�̐؂�ւ�����
function func_Yobidasi_Change(
         arg_DB:TDatabase;             //�ڑ����ꂽDB
         arg_PROG_ID:string;           //�v���O����ID
         arg_Ris_ID:string;            //RIS����ID
         arg_Status:string;            //�X�e�[�^�X�i����/�����j
         arg_SubStatus:string;         //�T�u�X�e�[�^�X�i����/�ďo/�Č�/�ۗ�/�Ď�j
         arg_Mode:string;              //�ďo/�������[�h�i1:�ďo�A�Č�/0:�����j
         var arg_Error_Code:string;    //�G���[�R�[�h
         var arg_Error_Message:string; //�G���[���b�Z�[�W
         var arg_Error_SQL:string;     //�G���[SQL��
         var arg_Error_Haita:Boolean   //�r���폜�G���[ True:�r��ð��ٍ폜���s�AFalse:�r��ð��ٍ폜����
         ):boolean;                    //����True���� False���s

//���@�\�i��O�L�j�F�m�ۃX�e�[�^�X�̐؂�ւ�����
function func_Kakuho_Change(
         arg_DB:TDatabase;             //�ڑ����ꂽDB
         arg_PROG_ID:string;           //�v���O����ID
         arg_Ris_ID:string;            //RIS����ID
         arg_Status:string;            //�X�e�[�^�X�i��ρj
         arg_Mode:string;              //�ďo/�������[�h�i1:�m��/0:�����j
         var arg_Error_Code:string;    //�G���[�R�[�h
         var arg_Error_Message:string; //�G���[���b�Z�[�W
         var arg_Error_SQL:string;     //�G���[SQL��
         var arg_Error_Haita:Boolean   //�r���폜�G���[ True:�r��ð��ٍ폜���s�AFalse:�r��ð��ٍ폜����
         ):boolean;                    //����True���� False���s

procedure proc_Get_Lock_HaitaData(
          arg_Query:TQuery;         //�ڑ����ꂽQuery
          arg_Ris_ID:String;        //RIS����ID
          var arg_Tan:String;       //�[����
          var arg_Kanja:String;     //����ID
          var arg_KensaDate:string; //�������tYYYY/MM/DD
          var arg_Kensa_Name:String //������
          );   //������ʖ�
//���X�V�ƍŐV�̐i���̃`�F�b�N
function proc_Kousin_Sintyoku(
          arg_DB:TDatabase;             //�ڑ����ꂽDB
          arg_PROG_ID:string;           //�v���O����ID
          arg_Ris_ID:TStrings;
          arg_Kanja_ID:TStrings;
          arg_RomaSimei:TStrings;
          arg_main:TStrings;
          arg_Sub:TStrings;
          var arg_Error_Code:string;    //�G���[�R�[�h
          var arg_Error_Message:string; //�G���[���b�Z�[�W
          var arg_Error_SQL:string     //�G���[SQL��
          ):Integer;                    //����0:�����A1:�r��/�i���װ
//���X�V�����̕Ԋ�
procedure proc_Kousin_Henkan(
                               arg_DB:TDatabase;             //�ڑ����ꂽDB
                               arg_PROG_ID:string;           //�v���O����ID
                               arg_Ris_ID:TStrings
                               );


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

//�ϐ��錾     ---------------------------------------------------------------
//var
//�֐��葱���錾--------------------------------------------------------------
//�g�p�\�֐��|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|


//���̃R�[�h�ϊ������|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|

//******************************************************************************
// ����t����
//******************************************************************************
function func_Uketuke_Kyotu(
         arg_DB:TDatabase;             //�ڑ����ꂽDB
         arg_Mode:string;              //0:��t�����A1:RIS�I�[�_�o�^�̎�t����
         arg_PROG_ID:string;           //�v���O����ID
         arg_Ris_ID:TStrings;            //RIS����ID
         arg_Kanja_ID:string;          //����ID
         arg_KensaDate:string;         //�\���(yyyy/mm/dd)
         arg_Uketukesya_ID:string;     //��t��ID
         arg_Kensastatus_Flg:string;   //�X�V�O�̌����i��
         arg_Kensasubstatus_Flg:string; //�X�V�O�̌����i������׸�
         arg_Kensatype_ID:string;      //�X�V�O�̌������(RIS�I�[�_�o�^�̂�)
         arg_Kensatype_Name:string;    //�X�V�O�̌�����ʖ���(RIS�I�[�_�o�^�̂�)
         arg_Douji_Uke_Flg: string;    //������t�̗L��(0:�Ȃ��A1:����)(��t�o�^�̂�)        �|���g�p
         arg_UkeJun:string;            //������t�̎�t��(��t�o�^�̂݁A������t�L�̏ꍇ�̂�)�|���g�p
         arg_First_KensatypeID:string; //������t�̍ŏ��̌������(��t�o�^�̂݁A������t�L�Ŏ�t�����Q�Ԗڈȍ~�̏ꍇ�̂�)�|���g�p
         arg_RenrakuMemo: string;      //�A������
         arg_DouishoKbn: string;       //���ӏ��敪 //2003.12.16
         var arg_Error_Code:string;    //�G���[�R�[�h
         var arg_Error_Message:string; //�G���[���b�Z�[�W
         var arg_Error_SQL:string;     //�G���[SQL��
         var arg_Error_Haita:Boolean   //�r���폜�G���[ True:�r��ð��ٍ폜���s�AFalse:�r��ð��ٍ폜����
         ):Integer;                    //����0:�����A1:�r��/�i���װ�A2:�i���X�V�װ�A3:���Mð��ُ����ݴװ
var
  w_Query_Data: TQuery;
  w_Query_Update: TQuery;

  w_DateTime: TDateTime;
  w_Tan_Name: string;
  w_Date: string;
  w_Time: string;
//���у��C���f�[�^
  w_EX_KENSASTATUS_FLG: string;
  w_EX_KENSASUBSTATUS_FLG: string;
  w_EX_KENSATYPE_ID: string;
  w_EX_KENSATYPE_NAME: string;
  w_EX_UKETUKE_TANTOU_ID: string;
  w_EX_Renraku_Memo: string;
  w_RenrakuMemo_FieldSize:Integer;
  w_EX_Kanja_ID: string;
//�I�[�_���C���f�[�^
  w_OD_SYSTEMKBN: string;
//���҃}�X�^�f�[�^
  w_KJ_ROMASIMEI: string;
  w_KJ_BIRTHDAY: string;
  w_KJ_SEX: string;
  w_KJ_KANJA_NYUGAIKBN: string;
  w_KJ_SECTION_ID: string;
  w_KJ_BYOUTOU_ID: string;
  w_KJ_BYOUSITU_ID: string;
//
  w_KensaDate_Age: string;      //�������N��
  w_New_Uketuke_NO: string;     //�V�K�̎�tNO
  w_New_Denbun_NO: string;      //�V�K�̓d���A��
  w_New_KanjaDenbun_NO: string; //�V�K�̓d���A��(�]�����ҏ��e�[�u��)
  w_New_PacsDenbun_NO: string;  //�V�K�̓d���A��(Pacs-Ris�]���I�[�_�e�[�u��)
  w_New_ReportDenbun_NO: string;//�V�K�̓d���A��(Report-Ris�I�[�_�e�[�u��)

  w_New_KENSA_DATE: string;     //������
  w_Now_KENSA_DATE: string;

  w_Flg_Kensa:string;           //�����i��������
  w_New_AccessionNo:string;     //�VAccessionNo.�i�I�[�_No.+HIS���s���t�j

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

  //���ݓ����擾
  w_DateTime := func_GetDBSysDate(w_Query_Data);
  //���ݓ��t�擾
  w_Date := FormatDateTime(CST_FORMATDATE_1, w_DateTime);
  //���ݎ����擾
  w_Time := FormatDateTime(CST_FORMATDATE_4, w_DateTime);
  //�R���s���[�^���擾
  w_Tan_Name := func_GetThisMachineName;
  //������
  w_New_KENSA_DATE := func_Date10To8(FormatDateTime(CST_FORMATDATE_1 ,w_DateTime));

  //�����i���E�r���Ǘ�����
  try
    //�g�����U�N�V�����l��
    arg_DB.StartTransaction;
    //ROOP
    for w_i := 0 to arg_Ris_ID.Count -1 do begin
      //�X�V�����擾
      if not func_GetWKAnriUketuke(arg_DB,     //�ڑ����ꂽDB
                            w_Tan_Name,        //PC����
                            arg_PROG_ID,       //�v���O����ID
                            arg_Ris_ID[w_i]    //RIS����ID
                           ) then begin
         proc_Get_Lock_HaitaData(w_Query_Data,
                                 arg_Ris_ID[w_i],
                                 w_Tan_Name,
                                 w_EX_Kanja_ID,
                                 w_Now_KENSA_DATE,
                                 w_EX_KENSATYPE_NAME);
         arg_Error_Message := #13#10
                            +#13#10+'�[�����@�@�F'+w_Tan_Name
                            +#13#10+'���҂h�c�@�F'+w_EX_Kanja_ID
                            +#13#10+'���ь������F'+w_Now_KENSA_DATE
                            +#13#10+'������ʁ@�F'+w_EX_KENSATYPE_ID
                            +#13#10+'�q�h�r�h�c�F'+arg_Ris_ID[w_i]
                            ;
        arg_Error_Code := CST_ERRCODE_08; //�X�V�����擾�G���[
        Result := 1;
        Break;
      end;
      //�I�[�_���C���A���у��C���A���҃}�X�^���ŐV���̎擾
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
            //�ŐV�̌����i������
            if (FieldByName('KENSASTATUS_FLG').AsString <> GPCST_CODE_KENSIN_0) and
              (FieldByName('KENSASTATUS_FLG').AsString <>  GPCST_CODE_KENSIN_2) then begin
              //��t�o�^�s��
              arg_Error_Code := CST_ERRCODE_02; //�i���G���[
              arg_Error_Message := #13#10
                                  +#13#10+'���҂h�c�@�F'+arg_Kanja_ID
                                  +#13#10+'�q�h�r�h�c�F'+arg_Ris_ID[w_i]
                                  ;
              Result := 1;
              Close;
              Break;
            end;
            if (FieldByName('KENSASTATUS_FLG').AsString = GPCST_CODE_KENSIN_2) and
              ((FieldByName('KENSASUBSTATUS_FLG').AsString <> GPCST_CODE_KENSIN_SUB_8) and
              (FieldByName('KENSASUBSTATUS_FLG').AsString <> GPCST_CODE_KENSIN_SUB_9)) then begin
              //��t�o�^�s��
              arg_Error_Code := CST_ERRCODE_02; //�i���G���[
              arg_Error_Message := #13#10
                                  +#13#10+'���҂h�c�@�F'+arg_Kanja_ID
                                  +#13#10+'�q�h�r�h�c�F'+arg_Ris_ID[w_i]
                                  ;
              Result := 1;
              Close;
              Break;
            end;

            w_Now_KENSA_DATE      := func_Date8To10(FieldByName('KENSA_DATE').AsString);

            w_EX_KENSATYPE_ID     := FieldByName('KENSATYPE_ID').AsString;
          end
          else begin
            arg_Error_Code := CST_ERRCODE_01; //�ǂݍ��݃G���[
            arg_Error_Message := #13#10
                                +#13#10+'���҂h�c�@�F'+arg_Kanja_ID
                                +#13#10+'�q�h�r�h�c�F'+arg_Ris_ID[w_i]
                                ;
            Result := 1;
            Close;
            Break;
          end;
          Close;
        end;
      end;
    end;  //Roop End
    //�G���[�`�F�b�N
    //�G���[�����݂������́A�r���Ǘ�Rollback
    //�G���[�����݂��Ȃ��������́A�r���Ǘ�Commit
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
      arg_DB.Rollback; // �R�~�b�g�Ŏ��s�����ꍇ�C�ύX��������
      arg_Error_Code := CST_ERRCODE_10; //�o�^���s
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
  //��t�ԍ��擾
    //��t��(���t�Ǘ�����)
    w_New_Uketuke_NO := '';
    w_New_Uketuke_NO := func_Uketuke_Make_UketukeNO(arg_DB,
                                                    w_Query_Data,
                                                    FormatDateTime(CST_FORMATDATE_3, w_DateTime),
                                                    'UNO'
                                                   );
    if w_New_Uketuke_NO = '' then begin
      arg_Error_Code := CST_ERRCODE_05; //��tNO�擾�G���[
      Result := 1;
      Exit;
    end;
}
    try
      for w_i := 0 to arg_Ris_ID.Count -1 do begin
        //��t��(���t�Ǘ�����)
        wt_New_Uketuke_NO.Add('');
        wt_New_Uketuke_NO[w_i] := func_Uketuke_Make_UketukeNO(arg_DB,
                                                    w_Query_Data,
                                                    FormatDateTime(CST_FORMATDATE_3, w_DateTime),
                                                    'UNO'
                                                   );
        if wt_New_Uketuke_NO[w_i] = '' then begin
          arg_Error_Code := CST_ERRCODE_05; //��tNO�擾�G���[
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
        arg_Error_Code := CST_ERRCODE_05; //�o�^���s
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

    //����Ҳ݁E����Ͻ��X�V����
    Try
      arg_DB.StartTransaction;

      for w_i := 0 to arg_Ris_ID.Count -1 do begin
        //�I�[�_���C���A���у��C���A���҃}�X�^���ŐV���̎擾
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
              arg_Error_Code := CST_ERRCODE_01; //�ǂݍ��݃G���[
              Result := 2;
              Exit;
            end;
            //���̑��̏��͌Œ�l
            w_EX_KENSASTATUS_FLG    := GPCST_CODE_KENSIN_0; //����t
            w_EX_KENSASUBSTATUS_FLG := '';
            w_EX_KENSATYPE_ID       := arg_Kensatype_ID;
            w_EX_KENSATYPE_NAME     := arg_Kensatype_Name;
            w_OD_SYSTEMKBN          := GPCST_CODE_SYSK_RIS; //RIS
            //�X�V�O�̌����i���͖���t�ɂ���
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
              //�����i��Ҳ��׸ނƌ����i������׸ނ�����
              //�����i��Ҳ��׸ނ�����t�ŁA�����i������׸ނ�Def�̏ꍇ'0'���Z�b�g
              w_Flg_Kensa := '';
              if FieldByName('KENSASTATUS_FLG').AsString = GPCST_CODE_KENSIN_0 then begin
                w_Flg_Kensa := '0';
              end;
              //�����i��Ҳ��׸ނ������ŁA�����i������׸ނ�8�F�ۗ��܂���9:�ČĂ̏ꍇ'2'���Z�b�g
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

              //�I�[�_No�̊i�[ 2003.01.08
{2003.02.05
              wt_OrderNo.Add(FieldByName('ORDERNO').AsString);
2003.02.05}
{2003.12.18 start}
              //�VAccessionNo.�̍쐬
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
              arg_Error_Code := CST_ERRCODE_01; //�ǂݍ��݃G���[
              arg_Error_Message := #13#10
                                  +#13#10+'���҂h�c�@�F'+arg_Kanja_ID
                                  +#13#10+'�q�h�r�h�c�F'+arg_Ris_ID[w_i]
                                  ;
              Result := 2;
              break;
            end;
          end;
        end;
        //�������N��
        w_KensaDate_Age := '999';
        if w_KJ_BIRTHDAY <> '' then begin
          w_KensaDate_Age := IntToStr(func_GetAgeofCase(func_StrToDate(w_KJ_BIRTHDAY), func_StrToDate(arg_KensaDate), 0));
        end;
  //�X�V�����J�n
    //RIS�I�[�_�o�^---------------------------------------------------------------
        if arg_Mode = CST_MODE_RISORDER then begin

        end
    //�ʏ�o�^--------------------------------------------------------------------
        else begin
          //���b�N
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
          //���у��C���e�[�u��
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

            //�����i���׸ނ��A0:����t�̎�
            if w_Flg_Kensa = GPCST_CODE_KENSIN_0 then begin
              ParamByName('PKENSASTATUS_FLG').AsString      := GPCST_CODE_KENSIN_1; //��t��
              ParamByName('PKENSASUBSTATUS_FLG').AsString   := '';
              ParamByName('PUKETUKE_TANTOU_ID').AsString    := arg_Uketukesya_ID;
            end;
            //�����i���׸ނ��A2:�����Ō����i������׸ނ�8:�ۗ��܂���9:�ČĂ̎�
            if w_Flg_Kensa = GPCST_CODE_KENSIN_2 then begin
              ParamByName('PKENSASTATUS_FLG').AsString      := GPCST_CODE_KENSIN_2; //��t��
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
            //���ӏ��敪
            ParamByName('PDOUISHO_FLG').AsString             := arg_DouishoKbn;
            //2004.04.20
            ParamByName('PUKETUKE_NO').AsString              := wt_New_Uketuke_NO[w_i];
            ExecSQL;
          end;
          {--- 2004.04.20 Start ---
          //���҃}�X�^
          with w_Query_Update do begin
            Close;
            SQL.Clear;
            SQL.Add('UPDATE KANJAMASTER SET ');
            SQL.Add(' UKETUKE_NO   = :PUKETUKE_NO ');
//RIS�X�V����            SQL.Add(' RIS_UPDATEDATE   = :PRIS_UPDATEDATE ');
            SQL.Add('WHERE KANJAID = :PKANJAID ');
            if not Prepared then Prepare;
            ParamByName('PKANJAID').AsString := arg_Kanja_ID;

            ParamByName('PUKETUKE_NO').AsString  := w_New_Uketuke_NO;
//RIS�X�V����            ParamByName('PRIS_UPDATEDATE').AsString  := w_DateTime;

            ExecSQL;
          end;
          --- 2004.04.20 End ---}
        end;
      end;  //Roop End
      try
        //�G���[�`�F�b�N
        //�G���[�����݂������́A�r���Ǘ�Rollback
        //�G���[�����݂��Ȃ��������́A�r���Ǘ�Commit
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
        arg_DB.Rollback; // �R�~�b�g�Ŏ��s�����ꍇ�C�ύX��������
        arg_Error_Code := CST_ERRCODE_10; //�o�^���s
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

    //�]���e�[�u��������
    try
      for w_i := 0 to arg_Ris_ID.Count -1 do begin
        //�����i��"����"�̎��̂݁A�]���e�[�u���֏�������
        if wt_Flg_Kensa[w_i] = GPCST_CODE_KENSIN_0 then begin
          {//2004.04.09
          //RIS�I�[�_�ő��M�L���[�쐬�ݒ肪"�Ȃ�"�̏ꍇ�̓L���[���쐬���Ȃ��B 2004.02.05
          if (wt_SystemKbn[w_i] = GPCST_CODE_SYSK_RIS) and
             (g_RIS_Order_Sousin_Flg = GPCST_RISORDERSOUSIN_FLG_0) then
          else begin
          }
          //2004.04.09
          //RIS�I�[�_�ő��M�L���[�쐬�ݒ肪"�Ȃ�"or"HIS�Ȃ�Rep����"�̏ꍇ�̓L���[���쐬���Ȃ��B
          if func_Check_CueAndDummy(wt_SystemKbn[w_i],arg_Kanja_ID,1) then begin

            //�d���A��:�]���I�[�_�e�[�u��(���t�Ǘ�����)
            w_New_Denbun_NO := '';
            w_New_Denbun_NO := func_Uketuke_Make_DenbunNO(arg_DB,
                                                          w_Query_Data,
                                                          FormatDateTime(CST_FORMATDATE_3, w_DateTime)
                                                         );

            if w_New_Denbun_NO = '' then begin
              if arg_Error_Code <> '' then begin
                arg_Error_Code := CST_ERRCODE_07; //�d���A�Ԏ擾�G���[
                arg_Error_Message := #13#10
                                    +#13#10+'���҂h�c�@�F'+arg_Kanja_ID
                                    +#13#10+'�q�h�r�h�c�F'+arg_Ris_ID[w_i]
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
                  ParamByName('PINFKBN').AsString       := GPCST_INFKBN_FU;     //��t�d��
                  ParamByName('PSYORIKBN').AsString     := GPCST_SYORIKBN_01;   //�V�K
                  ParamByName('PJOUTAIKBN').AsString    := '00'; //��ԂȂ�
                  ParamByName('PSOUSIN_DATE').AsString  := '';
                  ParamByName('PSOUSIN_FLG').AsString   := '0';  //�����M
                  ParamByName('PSOUSIN_STATUS_NAME').AsString := '';
                  ParamByName('PKENSATYPE_NAME').AsString     := wt_KensaType_Name[w_i];
                  ParamByName('PKANJAID').AsString      := arg_Kanja_ID;
                  ParamByName('PROMASIMEI').AsString    := wt_RomaSimei[w_i];
                  ParamByName('PKENSA_DATE').AsString   := wt_Kensa_Date[w_i];//func_Date10To8(FormatDateTime(CST_FORMATDATE_1 ,w_DateTime));
                  ExecSQL;
                end;

                try
                  arg_DB.Commit; // ���������ꍇ�C�ύX���R�~�b�g����
                except
                  on E: Exception do begin
                    arg_DB.Rollback; // �R�~�b�g�Ŏ��s�����ꍇ�C�ύX��������
                    arg_Error_Code := CST_ERRCODE_10; //�o�^���s
                    arg_Error_Message := #13#10
                                       + #13#10+'commit'
                                       + #13#10+E.Message;
                    arg_Error_SQL := w_Query_Update.SQL.Text;
                    Result := 3;
                  end;
                end;
              except
                on E: Exception do begin
                  arg_DB.Rollback; // �R�~�b�g�Ŏ��s�����ꍇ�C�ύX��������
                  arg_Error_Code := CST_ERRCODE_10; //�o�^���s
                  arg_Error_Message := #13#10
                                     + #13#10+E.Message;
                  arg_Error_SQL := w_Query_Update.SQL.Text;
                  Result := 3;
                end;
              end;
            end;
          end; //2004.02.05
{2003.12.18
          //�d���A��:PACS-RIS�]���I�[�_�e�[�u��(���t�Ǘ�����)
          w_New_PacsDenbun_NO := '';
          w_New_PacsDenbun_NO := func_Uketuke_Make_PacsDenbunNO(arg_DB,
                                                          w_Query_Data,
                                                          FormatDateTime(CST_FORMATDATE_3, w_DateTime)
                                                         );
          if w_New_PacsDenbun_NO = '' then begin
            if arg_Error_Code <> '' then begin
              arg_Error_Code := CST_ERRCODE_13; //�d���A�Ԏ擾�G���[
              arg_Error_Message := #13#10
                                  +#13#10+'PACS-RIS�]���e�[�u���̓d���A�Ԏ擾�Ɏ��s���܂����B'
                                  +#13#10+'���҂h�c�@�F'+arg_Kanja_ID
                                  +#13#10+'�q�h�r�h�c�F'+arg_Ris_ID[w_i]
                                  ;
            end;
            Result := 3;
          end else begin
            arg_DB.StartTransaction;
            try
              //PACS-RIS�]���I�[�_�e�[�u���ɂ���������
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
                ParamByName('PINFKBN').AsString       := GPCST_INFKBN_FU;     //��t�d��
                ParamByName('PSYORIKBN').AsString     := GPCST_SYORIKBN_02;   //�X�V
                ParamByName('PJOUTAIKBN').AsString    := '00'; //��ԂȂ�
                ParamByName('PSOUSIN_DATE').AsString  := '';
                ParamByName('PSOUSIN_FLG').AsString   := '0';  //�����M
                ParamByName('PSOUSIN_STATUS_NAME').AsString := '';
                ParamByName('PKENSATYPE_NAME').AsString     := wt_KensaType_Name[w_i];
                ParamByName('PKANJAID').AsString      := arg_Kanja_ID;
                ParamByName('PROMASIMEI').AsString    := wt_RomaSimei[w_i];
                ParamByName('PKENSA_DATE').AsString   := wt_Kensa_Date[w_i];//func_Date10To8(FormatDateTime(CST_FORMATDATE_1 ,w_DateTime));
                ExecSQL;
              end;
              try
                arg_DB.Commit; // ���������ꍇ�C�ύX���R�~�b�g����
              except
                on E: Exception do begin
                  arg_DB.Rollback; // �R�~�b�g�Ŏ��s�����ꍇ�C�ύX��������
                  arg_Error_Code := CST_ERRCODE_10; //�o�^���s
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
                  arg_DB.Rollback; // �R�~�b�g�Ŏ��s�����ꍇ�C�ύX��������
                  arg_Error_Code := CST_ERRCODE_10; //�o�^���s
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
          //���M�L���[�쐬�ݒ肪"����"or"HIS�Ȃ�Rep����"�̏ꍇ�̓L���[���쐬����B
          if func_Check_CueAndDummy(wt_SystemKbn[w_i],arg_Kanja_ID,0) then begin

            //�d���A��:REPORT-RIS�]���I�[�_�e�[�u��(���t�Ǘ�����)
            w_New_ReportDenbun_NO := '';
            w_New_ReportDenbun_NO := func_Uketuke_Make_ReportDenbunNO(arg_DB,
                                                            w_Query_Data,
                                                            FormatDateTime(CST_FORMATDATE_3, w_DateTime)
                                                           );
            if w_New_ReportDenbun_NO = '' then begin
              if arg_Error_Code <> '' then begin
                arg_Error_Code := CST_ERRCODE_14; //�d���A�Ԏ擾�G���[
                arg_Error_Message := #13#10
                                    +#13#10+'REPORT-RIS�]���e�[�u���̓d���A�Ԏ擾�Ɏ��s���܂����B'
                                    +#13#10+'���҂h�c�@�F'+arg_Kanja_ID
                                    +#13#10+'�q�h�r�h�c�F'+arg_Ris_ID[w_i]
                                    ;
              end;
              Result := 3;
            end else begin

              arg_DB.StartTransaction;
              try
                //HIS�I�[�_�̏ꍇ�AREPORT-RIS�]���I�[�_�e�[�u���ɂ���������
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
                  ParamByName('PINFKBN').AsString       := GPCST_INFKBN_FU;     //��t�d��
                  ParamByName('PSYORIKBN').AsString     := GPCST_SYORIKBN_02;   //�X�V
                  ParamByName('PJOUTAIKBN').AsString    := '00'; //��ԂȂ�
                  ParamByName('PSOUSIN_DATE').AsString  := '';
                  ParamByName('PSOUSIN_FLG').AsString   := '0';  //�����M
                  ParamByName('PSOUSIN_STATUS_NAME').AsString := '';
                  ParamByName('PKENSATYPE_NAME').AsString     := wt_KensaType_Name[w_i];
                  ParamByName('PKANJAID').AsString      := arg_Kanja_ID;
                  ParamByName('PROMASIMEI').AsString    := wt_RomaSimei[w_i];
                  ParamByName('PKENSA_DATE').AsString   := wt_Kensa_Date[w_i];//func_Date10To8(FormatDateTime(CST_FORMATDATE_1 ,w_DateTime));
                  ExecSQL;
                end;

                try
                  arg_DB.Commit; // ���������ꍇ�C�ύX���R�~�b�g����
                except
                  on E: Exception do begin
                    arg_DB.Rollback; // �R�~�b�g�Ŏ��s�����ꍇ�C�ύX��������
                    arg_Error_Code := CST_ERRCODE_10; //�o�^���s
                    arg_Error_Message := #13#10
                                       + #13#10+'commit'
                                       + #13#10+E.Message;
                    arg_Error_SQL := w_Query_Update.SQL.Text;
                    Result := 3;
                  end;
                end;
              except
                on E: Exception do begin
                    arg_DB.Rollback; // �R�~�b�g�Ŏ��s�����ꍇ�C�ύX��������
                    arg_Error_Code := CST_ERRCODE_10; //�o�^���s
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
      //�d���A��:�]�����ҏ��e�[�u��(���t�Ǘ�����)
      w_New_KanjaDenbun_NO := '';
      w_New_KanjaDenbun_NO := func_Uketuke_Make_KanjaDenbunNO(arg_DB,
                                                      w_Query_Data,
                                                      FormatDateTime(CST_FORMATDATE_3, w_DateTime)
                                                     );
      if w_New_KanjaDenbun_NO = '' then begin
        if arg_Error_Code <> '' then begin
          arg_Error_Code := CST_ERRCODE_12; //�d���A�Ԏ擾�G���[
          arg_Error_Message := #13#10
                              +#13#10+'�]�����ҏ��e�[�u���̓d���A�Ԏ擾�Ɏ��s���܂����B'
                              +#13#10+'���҂h�c�@�F'+arg_Kanja_ID
                              ;
        end;
         Result := 3;
      end else begin
        arg_DB.StartTransaction;
        try
          //�]�����ҏ��e�[�u���ɂ���������
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
            ParamByName('PSOUSIN_FLG').AsString   := '0';  //�����M
            ParamByName('PSOUSIN_STATUS_NAME').AsString := '';
            ParamByName('PANS_SBT').AsString      := '';
            ParamByName('PKANJAID').AsString      := arg_Kanja_ID;
            ParamByName('PROMASIMEI').AsString    := w_KJ_ROMASIMEI;
            ParamByName('PKENSA_DATE').AsString   := wt_Kensa_Date[0];//func_Date10To8(FormatDateTime(CST_FORMATDATE_1 ,w_DateTime));
            ExecSQL;
          end;
          try
            arg_DB.Commit; // ���������ꍇ�C�ύX���R�~�b�g����
          except
            on E: Exception do begin
              arg_DB.Rollback; // �R�~�b�g�Ŏ��s�����ꍇ�C�ύX��������
              arg_Error_Code := CST_ERRCODE_10; //�o�^���s
              arg_Error_Message := #13#10
                                 + #13#10+'commit'
                                 + #13#10+E.Message;
              arg_Error_SQL := w_Query_Update.SQL.Text;
              Result := 3;
            end;
          end;
        except
          on E: Exception do begin
            arg_DB.Rollback; // �R�~�b�g�Ŏ��s�����ꍇ�C�ύX��������
            arg_Error_Code := CST_ERRCODE_10; //�o�^���s
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
      //�X�V�����Ԋ�
      if not func_ReleasKAnri(arg_DB,            //�ڑ����ꂽDB
                              w_Tan_Name,        //PC����
                              arg_PROG_ID,       //�v���O����ID
                              arg_Ris_ID[w_i],        //RIS����ID
                              G_KANRI_TBL_WMODE  //�ԊҌ�����(G_KANRI_TBL_WMODE �X�V����)
                             ) then begin
        arg_Error_Haita := True;
      end;
    end;
  end;
end;
//******************************************************************************
// ����t����(�|�[�^�u��)12.21�ǉ�
//******************************************************************************
function func_Uketuke_Portable(
         arg_DB:TDatabase;             //�ڑ����ꂽDB
         arg_Mode:string;              //0:��t�����A1:RIS�I�[�_�o�^�̎�t����
         arg_PROG_ID:string;           //�v���O����ID
         arg_Ris_ID:TStrings;            //RIS����ID
         arg_Kanja_ID:TStrings;          //����ID
         arg_KensaDate:string;         //�\���(yyyy/mm/dd)
         arg_Uketukesya_ID:string;     //��t��ID
         var arg_Error_Code:string;    //�G���[�R�[�h
         var arg_Error_Message:string; //�G���[���b�Z�[�W
         var arg_Error_SQL:string;     //�G���[SQL��
         var arg_Error_Haita:Boolean   //�r���폜�G���[ True:�r��ð��ٍ폜���s�AFalse:�r��ð��ٍ폜����
         ):Integer;                    //����0:�����A1:�r��/�i���װ�A2:�i���X�V�װ�A3:���Mð��ُ����ݴװ
var
  w_Query_Data: TQuery;
  w_Query_Update: TQuery;

  w_DateTime: TDateTime;
  w_Tan_Name: string;
  w_Date: string;
  w_Time: string;
//���у��C���f�[�^
  //w_EX_KENSASTATUS_FLG: string;
  //w_EX_KENSASUBSTATUS_FLG: string;
  w_EX_KENSATYPE_ID: string;
  w_EX_KENSATYPE_NAME: string;
  w_EX_UKETUKE_TANTOU_ID: string;
  w_EX_Renraku_Memo: string;
  //w_EX_Kanja_ID: string;
//�I�[�_���C���f�[�^
  //w_OD_SYSTEMKBN: string;
  w_OD_ORDERNO: string;   //2003.01.08
  w_New_AccessionNo:string;     //�VAccessionNo.�i�I�[�_No.+HIS���s���t�j
//���҃}�X�^�f�[�^
  w_KJ_ROMASIMEI: string;
  w_KJ_BIRTHDAY: string;
  //w_KJ_SEX: string;
  w_KJ_KANJA_NYUGAIKBN: string;
  w_KJ_SECTION_ID: string;
  w_KJ_BYOUTOU_ID: string;
  w_KJ_BYOUSITU_ID: string;
//
  w_KensaDate_Age: string;      //�������N��
  w_New_Uketuke_NO: string;     //�V�K�̎�tNO
  w_New_Denbun_NO: string;      //�V�K�̓d���A��
  w_New_KanjaDenbun_NO: string; //�V�K�̓d���A��(�]�����ҏ��e�[�u��)
  w_New_PacsDenbun_NO: string;  //�V�K�̓d���A��(Pacs-Ris�]���I�[�_�e�[�u��)
  w_New_ReportDenbun_NO: string;//�V�K�̓d���A��(Report-Ris�I�[�_�e�[�u��)

  w_New_KENSA_DATE: string;     //������
  //w_Now_KENSA_DATE: string;

  w_Flg_Kensa:string;           //�����i��������

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

  //���ݓ����擾
  w_DateTime := func_GetDBSysDate(w_Query_Data);
  //���ݓ��t�擾
  w_Date := FormatDateTime(CST_FORMATDATE_1, w_DateTime);
  //���ݎ����擾
  w_Time := FormatDateTime(CST_FORMATDATE_4, w_DateTime);
  //�R���s���[�^���擾
  w_Tan_Name := func_GetThisMachineName;
  //������
//  w_New_KENSA_DATE := func_Date10To8(FormatDateTime(CST_FORMATDATE_1 ,w_DateTime));

  //�����i���E�r���Ǘ�����
  try


    //����Ҳ݁E����Ͻ��X�V����
    Try

      for w_i := 0 to arg_Ris_ID.Count -1 do begin
        //��t�ԍ��擾
        //��t��(���t�Ǘ�����)
        w_New_Uketuke_NO := '';
        w_New_Uketuke_NO := func_Uketuke_Make_UketukeNO(arg_DB,
                                                        w_Query_Data,
                                                        FormatDateTime(CST_FORMATDATE_3, w_DateTime),
                                                        'UNO'
                                                       );
        if w_New_Uketuke_NO = '' then begin
          arg_Error_Code := CST_ERRCODE_05; //��tNO�擾�G���[
          Result := 1;
          Exit;
        end;
        //�I�[�_���C���A���у��C���A���҃}�X�^���ŐV���̎擾
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
              //�����i��Ҳ��׸ނƌ����i������׸ނ�����
              //�����i��Ҳ��׸ނ�����t�ŁA�����i������׸ނ�Def�̏ꍇ'0'���Z�b�g
              w_Flg_Kensa := '';
              if FieldByName('KENSASTATUS_FLG').AsString = GPCST_CODE_KENSIN_0 then begin
                w_Flg_Kensa := '0';
              end;
              //�����i��Ҳ��׸ނ������ŁA�����i������׸ނ�8�F�ۗ��܂���9:�ČĂ̏ꍇ'2'���Z�b�g
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
              //�VAccessionNo.�̍쐬
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
              arg_Error_Code := CST_ERRCODE_01; //�ǂݍ��݃G���[
              arg_Error_Message := #13#10
                                  +#13#10+'���҂h�c�@�F'+arg_Kanja_ID[w_i]
                                  +#13#10+'�q�h�r�h�c�F'+arg_Ris_ID[w_i]
                                  ;
              Result := 2;
              break;
            end;
          end;
        end;
        //�������N��
        w_KensaDate_Age := '999';
        if w_KJ_BIRTHDAY <> '' then begin
          w_KensaDate_Age := IntToStr(func_GetAgeofCase(func_StrToDate(w_KJ_BIRTHDAY), func_StrToDate(arg_KensaDate), 0));
        end;
  //�X�V�����J�n
        arg_DB.StartTransaction;
        try
          //���b�N
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
          //���у��C���e�[�u��
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

            //�����i���׸ނ��A0:����t�̎�
            if w_Flg_Kensa = GPCST_CODE_KENSIN_0 then begin
              ParamByName('PKENSASTATUS_FLG').AsString      := GPCST_CODE_KENSIN_1; //��t��
              ParamByName('PKENSASUBSTATUS_FLG').AsString   := '';
              ParamByName('PUKETUKE_TANTOU_ID').AsString    := arg_Uketukesya_ID;
            end;
            //�����i���׸ނ��A2:�����Ō����i������׸ނ�8:�ۗ��܂���9:�ČĂ̎�
            if w_Flg_Kensa = GPCST_CODE_KENSIN_2 then begin
              ParamByName('PKENSASTATUS_FLG').AsString      := GPCST_CODE_KENSIN_2; //��t��
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
          //���҃}�X�^
          with w_Query_Update do begin
            Close;
            SQL.Clear;
            SQL.Add('UPDATE KANJAMASTER SET ');
            SQL.Add(' UKETUKE_NO   = :PUKETUKE_NO ');
//RIS�X�V����            SQL.Add(' RIS_UPDATEDATE   = :PRIS_UPDATEDATE ');
            SQL.Add('WHERE KANJAID = :PKANJAID ');
            if not Prepared then Prepare;
            ParamByName('PKANJAID').AsString := arg_Kanja_ID[w_i];

            ParamByName('PUKETUKE_NO').AsString  := w_New_Uketuke_NO;
//RIS�X�V����            ParamByName('PRIS_UPDATEDATE').AsString  := w_DateTime;

            ExecSQL;

            arg_DB.Commit;

          end;
          --- 2004.04.20 End ---}
        except
          on E: Exception do begin
            arg_DB.Rollback; // �R�~�b�g�Ŏ��s�����ꍇ�C�ύX��������
            arg_Error_Code := CST_ERRCODE_10; //�o�^���s
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
          //RIS�I�[�_�ő��M�L���[�쐬�ݒ肪"�Ȃ�"�̏ꍇ�̓L���[���쐬���Ȃ��B 2004.02.05
          if (w_OD_SYSTEMKBN = GPCST_CODE_SYSK_RIS) and
             (g_RIS_Order_Sousin_Flg = GPCST_RISORDERSOUSIN_FLG_0) then
          else begin
          }
          //2004.04.09
          //RIS�I�[�_�ő��M�L���[�쐬�ݒ肪"�Ȃ�"or"HIS�Ȃ�Rep����"�̏ꍇ�̓L���[���쐬���Ȃ��B
          if func_Check_CueAndDummy(w_OD_SYSTEMKBN,arg_Kanja_ID[w_i],1) then begin

            //�d���A��:�]���I�[�_�e�[�u��(���t�Ǘ�����)
            w_New_Denbun_NO := '';
            w_New_Denbun_NO := func_Uketuke_Make_DenbunNO(arg_DB,
                                                          w_Query_Data,
                                                          FormatDateTime(CST_FORMATDATE_3, w_DateTime)
                                                         );

            if w_New_Denbun_NO = '' then begin
              if arg_Error_Code <> '' then begin
                arg_Error_Code := CST_ERRCODE_07; //�d���A�Ԏ擾�G���[
                arg_Error_Message := #13#10
                                    +#13#10+'���҂h�c�@�F'+arg_Kanja_ID[w_i]
                                    +#13#10+'�q�h�r�h�c�F'+arg_Ris_ID[w_i]
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
                  ParamByName('PINFKBN').AsString       := GPCST_INFKBN_FU;     //��t�d��
                  ParamByName('PSYORIKBN').AsString     := GPCST_SYORIKBN_01;   //�V�K
                  ParamByName('PJOUTAIKBN').AsString    := '00'; //��ԂȂ�
                  ParamByName('PSOUSIN_DATE').AsString  := '';
                  ParamByName('PSOUSIN_FLG').AsString   := '0';  //�����M
                  ParamByName('PSOUSIN_STATUS_NAME').AsString := '';
                  ParamByName('PKENSATYPE_NAME').AsString     := w_EX_KENSATYPE_NAME;
                  ParamByName('PKANJAID').AsString      := arg_Kanja_ID[w_i];
                  ParamByName('PROMASIMEI').AsString    := w_KJ_ROMASIMEI;
                  ParamByName('PKENSA_DATE').AsString   := w_New_KENSA_DATE;//func_Date10To8(FormatDateTime(CST_FORMATDATE_1 ,w_DateTime));
                  ExecSQL;
                end;

                try
                  arg_DB.Commit; // ���������ꍇ�C�ύX���R�~�b�g����
                except
                  on E: Exception do begin
                    arg_DB.Rollback; // �R�~�b�g�Ŏ��s�����ꍇ�C�ύX��������
                    arg_Error_Code := CST_ERRCODE_10; //�o�^���s
                    arg_Error_Message := #13#10
                                       + #13#10+'commit'
                                       + #13#10+E.Message;
                    arg_Error_SQL := w_Query_Update.SQL.Text;
                    Result := 3;
                  end;
                end;
              except
                on E: Exception do begin
                  arg_DB.Rollback; // �R�~�b�g�Ŏ��s�����ꍇ�C�ύX��������
                  arg_Error_Code := CST_ERRCODE_10; //�o�^���s
                  arg_Error_Message := #13#10
                                     + #13#10+E.Message;
                  arg_Error_SQL := w_Query_Update.SQL.Text;
                  Result := 3;
                end;
              end;
            end;
          end; //2004.02.05
        {2003.12.18
          //�d���A��:PACS-RIS�]���I�[�_�e�[�u��(���t�Ǘ�����)
          w_New_PacsDenbun_NO := '';
          w_New_PacsDenbun_NO := func_Uketuke_Make_PacsDenbunNO(arg_DB,
                                                          w_Query_Data,
                                                          FormatDateTime(CST_FORMATDATE_3, w_DateTime)
                                                         );
          if w_New_PacsDenbun_NO = '' then begin
            if arg_Error_Code <> '' then begin
              arg_Error_Code := CST_ERRCODE_13; //�d���A�Ԏ擾�G���[
              arg_Error_Message := #13#10
                                  +#13#10+'PACS-RIS�]���e�[�u���̓d���A�Ԏ擾�Ɏ��s���܂����B'
                                  +#13#10+'���҂h�c�@�F'+arg_Kanja_ID[w_i]
                                  +#13#10+'�q�h�r�h�c�F'+arg_Ris_ID[w_i]
                                  ;
            end;
            Result := 3;
          end else begin
            arg_DB.StartTransaction;
            try
              //PACS-RIS�]���I�[�_�e�[�u���ɂ���������
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
                ParamByName('PINFKBN').AsString       := GPCST_INFKBN_FU;     //��t�d��
                ParamByName('PSYORIKBN').AsString     := GPCST_SYORIKBN_02;   //�X�V
                ParamByName('PJOUTAIKBN').AsString    := '00'; //��ԂȂ�
                ParamByName('PSOUSIN_DATE').AsString  := '';
                ParamByName('PSOUSIN_FLG').AsString   := '0';  //�����M
                ParamByName('PSOUSIN_STATUS_NAME').AsString := '';
                ParamByName('PKENSATYPE_NAME').AsString     := w_EX_KENSATYPE_NAME;
                ParamByName('PKANJAID').AsString      := arg_Kanja_ID[w_i];
                ParamByName('PROMASIMEI').AsString    := w_KJ_ROMASIMEI;
                ParamByName('PKENSA_DATE').AsString   := w_New_KENSA_DATE;//func_Date10To8(FormatDateTime(CST_FORMATDATE_1 ,w_DateTime));
                ExecSQL;
              end;
              try
                arg_DB.Commit; // ���������ꍇ�C�ύX���R�~�b�g����
              except
                on E: Exception do begin
                  arg_DB.Rollback; // �R�~�b�g�Ŏ��s�����ꍇ�C�ύX��������
                  arg_Error_Code := CST_ERRCODE_10; //�o�^���s
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
                  arg_DB.Rollback; // �R�~�b�g�Ŏ��s�����ꍇ�C�ύX��������
                  arg_Error_Code := CST_ERRCODE_10; //�o�^���s
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
          //���M�L���[�쐬�ݒ肪"����"or"HIS�Ȃ�Rep����"�̏ꍇ�̓L���[���쐬����B
          if func_Check_CueAndDummy(w_OD_SYSTEMKBN,arg_Kanja_ID[w_i],0) then begin
            //�d���A��:REPORT-RIS�]���I�[�_�e�[�u��(���t�Ǘ�����)
            w_New_ReportDenbun_NO := '';
            w_New_ReportDenbun_NO := func_Uketuke_Make_ReportDenbunNO(arg_DB,
                                                            w_Query_Data,
                                                            FormatDateTime(CST_FORMATDATE_3, w_DateTime)
                                                           );
            if w_New_ReportDenbun_NO = '' then begin
              if arg_Error_Code <> '' then begin
                arg_Error_Code := CST_ERRCODE_14; //�d���A�Ԏ擾�G���[
                arg_Error_Message := #13#10
                                    +#13#10+'REPORT-RIS�]���e�[�u���̓d���A�Ԏ擾�Ɏ��s���܂����B'
                                    +#13#10+'���҂h�c�@�F'+arg_Kanja_ID[w_i]
                                    +#13#10+'�q�h�r�h�c�F'+arg_Ris_ID[w_i]
                                    ;
              end;
              Result := 3;
            end else begin

              arg_DB.StartTransaction;
              try
                //HIS�I�[�_�̏ꍇ�AREPORT-RIS�]���I�[�_�e�[�u���ɂ���������
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
                  ParamByName('PINFKBN').AsString       := GPCST_INFKBN_FU;     //��t�d��
                  ParamByName('PSYORIKBN').AsString     := GPCST_SYORIKBN_02;   //�X�V
                  ParamByName('PJOUTAIKBN').AsString    := '00'; //��ԂȂ�
                  ParamByName('PSOUSIN_DATE').AsString  := '';
                  ParamByName('PSOUSIN_FLG').AsString   := '0';  //�����M
                  ParamByName('PSOUSIN_STATUS_NAME').AsString := '';
                  ParamByName('PKENSATYPE_NAME').AsString     := w_EX_KENSATYPE_NAME;
                  ParamByName('PKANJAID').AsString      := arg_Kanja_ID[w_i];
                  ParamByName('PROMASIMEI').AsString    := w_KJ_ROMASIMEI;
                  ParamByName('PKENSA_DATE').AsString   := w_New_KENSA_DATE;//func_Date10To8(FormatDateTime(CST_FORMATDATE_1 ,w_DateTime));
                  ExecSQL;
                end;

                try
                  arg_DB.Commit; // ���������ꍇ�C�ύX���R�~�b�g����
                except
                  on E: Exception do begin
                    arg_DB.Rollback; // �R�~�b�g�Ŏ��s�����ꍇ�C�ύX��������
                    arg_Error_Code := CST_ERRCODE_10; //�o�^���s
                    arg_Error_Message := #13#10
                                       + #13#10+'commit'
                                       + #13#10+E.Message;
                    arg_Error_SQL := w_Query_Update.SQL.Text;
                    Result := 3;
                  end;
                end;
              except
                on E: Exception do begin
                    arg_DB.Rollback; // �R�~�b�g�Ŏ��s�����ꍇ�C�ύX��������
                    arg_Error_Code := CST_ERRCODE_10; //�o�^���s
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
          //�d���A��:�]�����ҏ��e�[�u��(���t�Ǘ�����)
          w_New_KanjaDenbun_NO := '';
          w_New_KanjaDenbun_NO := func_Uketuke_Make_KanjaDenbunNO(arg_DB,
                                                          w_Query_Data,
                                                          FormatDateTime(CST_FORMATDATE_3, w_DateTime)
                                                         );
          if w_New_KanjaDenbun_NO = '' then begin
            if arg_Error_Code <> '' then begin
              arg_Error_Code := CST_ERRCODE_12; //�d���A�Ԏ擾�G���[
              arg_Error_Message := #13#10
                                  +#13#10+'�]�����ҏ��e�[�u���̓d���A�Ԏ擾�Ɏ��s���܂����B'
                                  +#13#10+'���҂h�c�@�F'+arg_Kanja_ID[w_i]
                                  ;
            end;
             Result := 3;
          end else begin
            arg_DB.StartTransaction;
            try
              //�]�����ҏ��e�[�u���ɂ���������
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
                ParamByName('PSOUSIN_FLG').AsString   := '0';  //�����M
                ParamByName('PSOUSIN_STATUS_NAME').AsString := '';
                ParamByName('PANS_SBT').AsString      := '';
                ParamByName('PKANJAID').AsString      := arg_Kanja_ID[w_i];
                ParamByName('PROMASIMEI').AsString    := w_KJ_ROMASIMEI;
                ParamByName('PKENSA_DATE').AsString   := w_New_KENSA_DATE;//func_Date10To8(FormatDateTime(CST_FORMATDATE_1 ,w_DateTime));
                ExecSQL;
              end;
              try
                arg_DB.Commit; // ���������ꍇ�C�ύX���R�~�b�g����
              except
                on E: Exception do begin
                  arg_DB.Rollback; // �R�~�b�g�Ŏ��s�����ꍇ�C�ύX��������
                  arg_Error_Code := CST_ERRCODE_10; //�o�^���s
                  arg_Error_Message := #13#10
                                     + #13#10+'commit'
                                     + #13#10+E.Message;
                  arg_Error_SQL := w_Query_Update.SQL.Text;
                  Result := 3;
                end;
              end;
            except
              on E: Exception do begin
                arg_DB.Rollback; // �R�~�b�g�Ŏ��s�����ꍇ�C�ύX��������
                arg_Error_Code := CST_ERRCODE_10; //�o�^���s
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
      //�X�V�����Ԋ�
      if not func_ReleasKAnri(arg_DB,            //�ڑ����ꂽDB
                              w_Tan_Name,        //PC����
                              arg_PROG_ID,       //�v���O����ID
                              arg_Ris_ID[w_i],        //RIS����ID
                              G_KANRI_TBL_WMODE  //�ԊҌ�����(G_KANRI_TBL_WMODE �X�V����)
                             ) then begin
        arg_Error_Haita := True;
      end;
    end;
  end;
end;
//******************************************************************************
// ��RIS����ID�쐬
//******************************************************************************
function func_Uketuke_Make_RisID(
         arg_DB:TDatabase;             //�ڑ����ꂽDB
         arg_Query:TQuery;             //�ڑ����ꂽQuery
         arg_DateTime:string           //��������
         ):string;
var
  w_NO: integer;
begin
  Result := '';
  //RIS����ID�擾(���t�Ǘ�����)
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
// ���I�[�_NO�쐬
//******************************************************************************
function func_Uketuke_Make_OrderNO(
         arg_DB:TDatabase;             //�ڑ����ꂽDB
         arg_Query:TQuery;             //�ڑ����ꂽQuery
         arg_DateTime:string           //��������
         ):string;
var
  w_NO: integer;
begin
  Result := '';
  //�I�[�_NO�擾(���t�Ǘ��Ȃ�)
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
// ����tNO�쐬
//******************************************************************************
function func_Uketuke_Make_UketukeNO(
         arg_DB:TDatabase;             //�ڑ����ꂽDB
         arg_Query:TQuery;             //�ڑ����ꂽQuery
         arg_DateTime:string;          //��������
         arg_KID:string                //�敪
         ):string;
var
  w_NO: integer;
begin
  //��tNO�擾(���t�Ǘ�����)
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
// ������NO�쐬
//******************************************************************************
function func_Uketuke_Make_ToujituNO(
         arg_DB:TDatabase;             //�ڑ����ꂽDB
         arg_Query:TQuery;             //�ڑ����ꂽQuery
         arg_DateTime:string           //��������
         ):string;
var
  w_NO: integer;
begin
  //������(���t�Ǘ�����)
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
// ���d���A�ԍ쐬
//******************************************************************************
function func_Uketuke_Make_DenbunNO(
         arg_DB:TDatabase;             //�ڑ����ꂽDB
         arg_Query:TQuery;             //�ڑ����ꂽQuery
         arg_DateTime:string           //��������
         ):string;
var
  w_NO: integer;
begin
  //�d���A��(��t�p)(���t�Ǘ�����)
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
// ���d���A�ԍ쐬(�]�����ҏ��e�[�u��)
//******************************************************************************
function func_Uketuke_Make_KanjaDenbunNO(
         arg_DB:TDatabase;             //�ڑ����ꂽDB
         arg_Query:TQuery;             //�ڑ����ꂽQuery
         arg_DateTime:string           //��������
         ):string;
var
  w_NO: integer;
begin
  //�d���A��(��t�p)(���t�Ǘ�����)
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
// ���d���A�ԍ쐬(Pacs-Ris�e�[�u��)
//******************************************************************************
function func_Uketuke_Make_PacsDenbunNO(
         arg_DB:TDatabase;             //�ڑ����ꂽDB
         arg_Query:TQuery;             //�ڑ����ꂽQuery
         arg_DateTime:string           //��������
         ):string;
var
  w_NO: integer;
begin
  //�d���A��(��t�p)(���t�Ǘ�����)
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
// ���d���A�ԍ쐬(Report-Ris�e�[�u��)
//******************************************************************************
function func_Uketuke_Make_ReportDenbunNO(
         arg_DB:TDatabase;             //�ڑ����ꂽDB
         arg_Query:TQuery;             //�ڑ����ꂽQuery
         arg_DateTime:string           //��������
         ):string;
var
  w_NO: integer;
begin
  //�d���A��(��t�p)(���t�Ǘ�����)
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
// ��SUID�����A�ԍ쐬
//******************************************************************************
function func_Uketuke_Make_ToujituSUID(
         arg_DB:TDatabase;             //�ڑ����ꂽDB
         arg_Query:TQuery;             //�ڑ����ꂽQuery
         arg_DateTime:string           //��������
         ):string;
var
  w_NO: integer;
begin
  //SUID�����A��(���t�Ǘ�����)
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
// ����t�L�����Z������
//******************************************************************************
function func_UketukeCancel_Kyotu(
         arg_DB:TDatabase;             //�ڑ����ꂽDB
         arg_PROG_ID:string;           //�v���O����ID
         arg_Ris_ID:string;            //RIS����ID
         arg_Kanja_ID:string;          //����ID
         arg_KensaDate:string;         //�\���(yyyy/mm/dd)
         arg_Uketukesya_Name:string;   //��t�Җ�
         arg_Kensastatus_Flg:string;   //�X�V�O�̌����i�����C��
         arg_KensaSubstatus_Flg:string;   //�X�V�O�̌����i���T�u
         var arg_Error_Code:string;    //�G���[�R�[�h
         var arg_Error_Message:string; //�G���[���b�Z�[�W
         var arg_Error_SQL:string;     //�G���[SQL��
         var arg_Error_Haita:Boolean   //�r���폜�G���[ True:�r��ð��ٍ폜���s�AFalse:�r��ð��ٍ폜����
         ):Integer;                    //����0:�����A1:�r��/�i���װ�A2:�i���X�V�װ�A3:���Mð��ُ����ݴװ
var
  w_Query_Data: TQuery;
  w_Query_Update: TQuery;

  w_DateTime: TDateTime;
  w_Tan_Name: string;
//���у��C���f�[�^
  w_EX_KENSASTATUS_FLG: string;
  w_EX_KENSASUBSTATUS_FLG: string;
  w_EX_KENSATYPE_ID: string;
  w_EX_KENSATYPE_NAME: string;
  w_EX_UKETUKE_TANTOU_ID: string;
  w_EX_KANJAID: string;
  w_EX_KENSA_DATE: string;
//�I�[�_���C���f�[�^
  w_OD_KENSA_DATE: string;
  w_OD_KENSA_DATE_AGE: string;
  w_OD_ORDERNO: string;  //2003.01.08
  w_New_AccessionNo:string;     //�VAccessionNo.�i�I�[�_No.+HIS���s���t�j
  w_OD_DENPYO_NYUGAIKBN: string;  //2003.03.14
  w_OD_KENSAKIKI_ID: string;      //2003.03.14
  w_OD_YOTEIKAIKEI_FLG: string;  //2003.03.14
  w_OD_DOKUEI_FLG: string;  //2004.03.05
//���҃}�X�^�f�[�^
  w_KJ_ROMASIMEI: string;
//
  w_New_Denbun_NO: string;     //�V�K�̓d���A��
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
    //���ݓ����擾
    w_DateTime := func_GetDBSysDate(w_Query_Data);
    //�R���s���[�^���擾
    w_Tan_Name := func_GetThisMachineName;

    //�X�V�����擾
    if not func_GetWKAnri(arg_DB,            //�ڑ����ꂽDB
                          w_Tan_Name,        //PC����
                          arg_PROG_ID,       //�v���O����ID
                          arg_Ris_ID         //RIS����ID
                         ) then begin
      proc_Get_Lock_HaitaData(w_Query_Data,
                              arg_Ris_ID,
                              w_Tan_Name,
                              w_EX_KANJAID,
                              w_Now_KENSA_DATE,
                              w_EX_KENSATYPE_NAME);
      arg_Error_Message := #13#10
                          +#13#10+'�[�����@�@�F'+w_Tan_Name
                          +#13#10+'���҂h�c�@�F'+w_EX_KANJAID
                          +#13#10+'���ь������F'+w_Now_KENSA_DATE
                          +#13#10+'������ʁ@�F'+w_EX_KENSATYPE_NAME
                          +#13#10+'�q�h�r�h�c�F'+arg_Ris_ID
                          ;
      arg_Error_Code := CST_ERRCODE_08; //�X�V�����擾�G���[
      Result := 1;
      Exit;
    end;

    try
      try
        //�I�[�_���C���A���у��C���A���҃}�X�^���ŐV���̎擾
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
            w_EX_KENSASTATUS_FLG    := FieldByName('KENSASTATUS_FLG').AsString;           //�������C���X�e�[�^�X
            w_EX_KENSASUBSTATUS_FLG := FieldByName('KENSASUBSTATUS_FLG').AsString;        //�����T�u�X�e�[�^�X
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
            //�VAccessionNo.�̍쐬
            //w_New_AccessionNo := Right('00000000'+FieldByName('ORDERNO').AsString,8) + FieldByName('HIS_HAKKO_DATE').AsString;
            w_New_AccessionNo := FieldByName('ORDERNO').AsString;
            w_OD_ORDERNO := w_New_AccessionNo;
            //2004.02.05
            w_OD_SYSTEMKBN := FieldByName('SYSTEMKBN').AsString;
{2003.12.18 end}
          end
          else begin
            arg_Error_Code := CST_ERRCODE_01; //�ǂݍ��݃G���[
            Result := 1;
            Exit;
          end;
          Close;

        end;
      except
        on E: Exception do begin
          arg_Error_Code := CST_ERRCODE_10; //�o�^���s
          arg_Error_Message := #13#10
                             + #13#10+E.Message;
          arg_Error_SQL := w_Query_Data.SQL.Text;
          w_Query_Data.Close;
          Result := 1;
          exit;
        end;
      end;

      //�ŐV�����i���Ɣ�r���قȂ�ꍇ�ɃG���[�Ƃ���
      if (w_EX_KENSASTATUS_FLG <> arg_Kensastatus_Flg)
      or (w_EX_KENSASUBSTATUS_FLG <> arg_KensaSubstatus_Flg) then begin
        arg_Error_Code := CST_ERRCODE_02; //�����i���G���[
        Result := 1;
        Exit;
      end;

//�X�V�����J�n
      arg_DB.StartTransaction;
      try
        //���b�N
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

        //���у��C���e�[�u��
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
          //����A�{��A������̃N���A 2004.03.31 ��
            SQL.Add(',KENSAI_DOCTOR_ID1    = :PKENSAI_DOCTOR_ID1 ');
            SQL.Add(',KENSAI_DOCTOR_ID2    = :PKENSAI_DOCTOR_ID2 ');
            SQL.Add(',SYOHOISI_ID          = :PSYOHOISI_ID ');
          //2004.03.31 ��
          end;
        {2003.03.14 end}
          SQL.Add('WHERE RIS_ID = :PRIS_ID ');
          if not Prepared then Prepare;

          //�����i���׸ނ��A0:����t�̎�
          if w_EX_KENSASTATUS_FLG = GPCST_CODE_KENSIN_1 then begin
            ParamByName('PKENSASTATUS_FLG').AsString      := GPCST_CODE_KENSIN_0;        //����t
            ParamByName('PKENSASUBSTATUS_FLG').AsString   := '';                         //Default
            ParamByName('PUKETUKE_TANTOU_ID').AsString    := '';                         //��t�S���Ҹر
          {2002.12.17
            ParamByName('PKENSA_DATE').AsString             := w_OD_KENSA_DATE;            //�\�茟�����t
            ParamByName('PKENSA_DATE_AGE').AsString         := w_OD_KENSA_DATE_AGE;        //�\�茟�����N��
          2002.12.17}
            ParamByName('PUKETUKE_TANTOU_ID').AsString    := '';                         //��t�S���Ҹر
          {2003.03.14 start}
            ParamByName('PNEWUPDATE_FLG').AsString        := '0';                        //�V�K�o�^�׸މ���
            ParamByName('PKENSA_DATE').AsString           := w_OD_KENSA_DATE;            //��������߂�
            ParamByName('PKENSA_DATE_AGE').AsString       := w_OD_KENSA_DATE_AGE;        //�������N���߂�
            ParamByName('PDENPYO_NYUGAIKBN').AsString     := w_OD_DENPYO_NYUGAIKBN;      //�`�[���O�敪��߂�
            ParamByName('PJISSEKIKAIKEI_FLG').AsString    := w_OD_YOTEIKAIKEI_FLG;       //���щ�v�׸ނ�߂�
            ParamByName('PKENSAKIKI_ID').AsString         := w_OD_KENSAKIKI_ID;          //���{���u��߂�
            ParamByName('PEXAMNO1').AsString              := '';                         //�Ǘ����ځiExamNo1�j
            ParamByName('PPROTOCOL').AsString             := '';                         //�Ǘ����ځi�v���g�R���j
            ParamByName('PKENSA_KBN').AsString            := '';                         //�Ǘ����ځi�����敪�j
            ParamByName('PSYOKEN_COMMENT').AsString       := '';                         //�Ǘ����ځi�����j
            ParamByName('PTHREED_COMMENT').AsString       := '';                         //�Ǘ����ځi�R�c���j
            ParamByName('PRI_CANCEL').AsString            := '';                         //�Ǘ����ځi�L�����Z���j
            ParamByName('PTOUSITIME').AsString            := '';                         //�Ǘ����ځi�������ԁj
            ParamByName('PBAKUSYASUU').AsString           := '';                         //�Ǘ����ځi�����ː��j

            ParamByName('PKENSA_GISI_ID1').AsString       := '';                         //�Z�t1
            ParamByName('PKENSA_GISI_ID2').AsString       := '';                         //�Z�t2
            ParamByName('PNYURYOKU_KANGOSI_ID1').AsString := '';                         //���͊Ō�m1
            ParamByName('PNYURYOKU_KANGOSI_ID2').AsString := '';                         //���͊Ō�m2
            ParamByName('PKENSAI_SECTION_ID1').AsString   := '';                         //�����S����f�É�1
            ParamByName('PKENSAI_DOCTOR_NAME1').AsString  := '';                         //�����S������1
            ParamByName('PKENSAI_SECTION_ID2').AsString   := '';                         //�����S����f�É�2
            ParamByName('PKENSAI_DOCTOR_NAME2').AsString  := '';                         //�����S������2
            ParamByName('PBIKOU').AsString                := '';                         //�B�e�R�����g
          {2003.03.14 end}
            ParamByName('PDOKUEI_FLG').AsString           := w_OD_DOKUEI_FLG;            //�ǉeF��߂�
          //2004.03.31 ��
            ParamByName('PKENSAI_DOCTOR_ID1').AsString    := '';                         //����ID
            ParamByName('PKENSAI_DOCTOR_ID2').AsString    := '';                         //�{��ID
            ParamByName('PSYOHOISI_ID').AsString           := '';                         //������ID
          //2004.03.31 ��
          end;
          //�����i���׸ނ��A2:�����Ō����i������׸ނ�10:�Ď�̎�
          if w_EX_KENSASTATUS_FLG = GPCST_CODE_KENSIN_2 then begin
            ParamByName('PKENSASTATUS_FLG').AsString      := GPCST_CODE_KENSIN_2;        //������
            ParamByName('PKENSASUBSTATUS_FLG').AsString   := GPCST_CODE_KENSIN_SUB_8;    //�ۗ�
            ParamByName('PUKETUKE_TANTOU_ID').AsString    := w_EX_UKETUKE_TANTOU_ID;                           //��t�S���Ҹر
          end;

        {2003.12.19 start}
          //ParamByName('PUKETUKE_UPDATE_DATE').AsDateTime  := w_DateTime;                 //��ݾٍX�V����
         // ParamByName('PUKETUKE_JISSI_TERMINAL').AsString := w_Tan_Name;                 //��ݾٍX�V�[��
          ParamByName('PUKETUKECL_UPDATE_DATE').AsDateTime  := w_DateTime;                 //��ݾٍX�V����
          ParamByName('PUKETUKECL_JISSI_TERMINAL').AsString := w_Tan_Name;                 //��ݾٍX�V�[��
        {2003.12.19 end}
          ParamByName('PRIS_ID').AsString                 := arg_Ris_ID;                 //RIS����ID

          ExecSQL;

          //�����i���׸ނ��A0:����t�̎�
          if w_EX_KENSASTATUS_FLG = GPCST_CODE_KENSIN_1 then begin
            //���ѕ��ʃe�[�u��(�B�e�i�������B�e�^�ڍו��ʁA�v���Z�b�g�̃N���A)
            Close;
            SQL.Clear;
            SQL.Add ('UPDATE EXBUITABLE SET ');
            SQL.Add (' SATUEISTATUS    = :PSATUEISTATUS ');
            SQL.Add (',PRESET_NAME     = :PPRESET_NAME ');
            SQL.Add ('WHERE RIS_ID = :PRIS_ID');
            if not Prepared then Prepare;
            //���B�e�ɂ���
            ParamByName('PSATUEISTATUS').AsString := GPCST_CODE_SATUEI_0; //���B�e
            //�N���A
            ParamByName('PPRESET_NAME').AsString     := '';
            //�L�[
            ParamByName('PRIS_ID').AsString:=arg_Ris_ID;
            ExecSQL;

          //���ѕ��ʃe�[�u���̍폜
            Close;
            SQL.Clear;
            SQL.Add ('DELETE FROM EXBUITABLE ');
            SQL.Add ('WHERE RIS_ID = :PRIS_ID ');
            SQL.Add ('  AND HIS_ORIGINAL_FLG = :PHIS_ORIGINAL_FLG'); //���}���ł͵ؼ��ق͍폜�ł��Ȃ��ׁA�ǉ����ʂ݂̂̍폜�ł悢 2004.03.30
            if not Prepared then Prepare;
            ParamByName('PRIS_ID').AsString           := arg_Ris_ID;
            ParamByName('PHIS_ORIGINAL_FLG').AsString := '0'; //�I���W�i���ȊO 2004.03.30 ����
            ExecSQL;

          {RIS���ʔԍ�������ׁA���ѕ��ʃe�[�u���̓��꒼���͍s��Ȃ��B��L�ؼ��ٕ��ʈȊO�̍폜�őΉ�����
          2004.03.30
          //���ѕ��ʃe�[�u�����I�[�_���ʃe�[�u���Ɠ�����Ԃɂ���
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

          //���уt�B�����e�[�u��
            Close;
            SQL.Clear;
            SQL.Add ('DELETE FROM EXFILMTABLE ');
            SQL.Add ('WHERE RIS_ID = :PRIS_ID');
            if not Prepared then Prepare;
            ParamByName('PRIS_ID').AsString := arg_Ris_ID;
            ExecSQL;

          //���ё��e�܃e�[�u��
            Close;
            SQL.Clear;
            SQL.Add ('DELETE FROM EXZOUEIZAITABLE ');
            SQL.Add ('WHERE RIS_ID = :PRIS_ID');
            if not Prepared then Prepare;
            ParamByName('PRIS_ID').AsString := arg_Ris_ID;
            ExecSQL;

          //���ю�Z�e�[�u��
            Close;
            SQL.Clear;
            SQL.Add ('DELETE FROM EXINFUSETABLE ');
            SQL.Add ('WHERE RIS_ID = :PRIS_ID');
            if not Prepared then Prepare;
            ParamByName('PRIS_ID').AsString := arg_Ris_ID;
            ExecSQL;

          //���юB�e�e�[�u��
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
          arg_DB.Commit; // ���������ꍇ�C�ύX���R�~�b�g����
        except
          on E: Exception do begin
                arg_DB.Rollback; // �R�~�b�g�Ŏ��s�����ꍇ�C�ύX��������
                arg_Error_Code := CST_ERRCODE_10; //�o�^���s
                arg_Error_Message := #13#10
                                   + #13#10+'commit'
                                   + #13#10+E.Message;
                arg_Error_SQL := w_Query_Update.SQL.Text;
                Result := 2;
          end;
        end;
      except
        on E: Exception do begin
              arg_DB.Rollback; // �R�~�b�g�Ŏ��s�����ꍇ�C�ύX��������
              arg_Error_Code := CST_ERRCODE_10; //�o�^���s
              arg_Error_Message := #13#10
                                 + #13#10+E.Message;
              arg_Error_SQL := w_Query_Update.SQL.Text;
              Result := 2;
        end;
      end;

      //�����i��"���"��"����"�̎��̂݁A�]���e�[�u���֏�������
      if arg_Kensastatus_Flg = GPCST_CODE_KENSIN_1 then begin
        {//2004.04.09
        //RIS�I�[�_�ő��M�L���[�쐬�ݒ肪"�Ȃ�"�̏ꍇ�̓L���[���쐬���Ȃ��B 2004.02.05
        if (w_OD_SYSTEMKBN = GPCST_CODE_SYSK_RIS) and
           (g_RIS_Order_Sousin_Flg = GPCST_RISORDERSOUSIN_FLG_0) then
        else begin
        }
        //2004.04.09
        //RIS�I�[�_�ő��M�L���[�쐬�ݒ肪"�Ȃ�"or"HIS�Ȃ�Rep����"�̏ꍇ�̓L���[���쐬���Ȃ��B
        if func_Check_CueAndDummy(w_OD_SYSTEMKBN,arg_Kanja_ID,1) then begin

          //�d���A��:�]���I�[�_�e�[�u��(���t�Ǘ�����)
          w_New_Denbun_NO := '';
          w_New_Denbun_NO := func_Uketuke_Make_DenbunNO(arg_DB,
                                                        w_Query_Data,
                                                        FormatDateTime(CST_FORMATDATE_3, w_DateTime)
                                                       );

          if w_New_Denbun_NO = '' then begin
            if arg_Error_Code <> '' then begin
                arg_Error_Code := CST_ERRCODE_07; //�d���A�Ԏ擾�G���[
                arg_Error_Message := #13#10
                                    +#13#10+'���҂h�c�@�F'+ arg_Kanja_ID
                                    +#13#10+'�q�h�r�h�c�F'+ arg_Ris_ID
                                    ;
            end;
            arg_Error_Code := CST_ERRCODE_07; //�d���A�Ԏ擾�G���[
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
                ParamByName('PINFKBN').AsString       := GPCST_INFKBN_FC;     //��t�d��
                ParamByName('PSYORIKBN').AsString     := GPCST_SYORIKBN_03;   //�폜
                ParamByName('PJOUTAIKBN').AsString    := '00'; //��ԂȂ�
                ParamByName('PSOUSIN_DATE').AsString  := '';
                ParamByName('PSOUSIN_FLG').AsString   := '0';  //�����M
                ParamByName('PSOUSIN_STATUS_NAME').AsString := '';
                ParamByName('PKENSATYPE_NAME').AsString     := w_EX_KENSATYPE_NAME;
                ParamByName('PKANJAID').AsString      := arg_Kanja_ID;
                ParamByName('PROMASIMEI').AsString    := w_KJ_ROMASIMEI;
                ParamByName('PKENSA_DATE').AsString   := w_EX_KENSA_DATE; //func_Date10To8(FormatDateTime(CST_FORMATDATE_1 ,w_DateTime));
                ExecSQL;
              end;

              try
                arg_DB.Commit; // ���������ꍇ�C�ύX���R�~�b�g����
              except
                on E: Exception do begin
                    arg_DB.Rollback; // �R�~�b�g�Ŏ��s�����ꍇ�C�ύX��������
                    arg_Error_Code := CST_ERRCODE_10; //�o�^���s
                    arg_Error_Message := #13#10
                                       + #13#10+'commit'
                                       + #13#10+E.Message;
                      arg_Error_SQL := w_Query_Update.SQL.Text;
                  Result := 3;
                end;
              end;
            except
              on E: Exception do begin
                  arg_DB.Rollback; // �R�~�b�g�Ŏ��s�����ꍇ�C�ύX��������
                  arg_Error_Code := CST_ERRCODE_10; //�o�^���s
                  arg_Error_Message := #13#10
                                     + #13#10+E.Message;
                  arg_Error_SQL := w_Query_Update.SQL.Text;
                  Result := 3;
              end;
            end;
          end;
        end; //2004.02.05
      {2003.12.18
        //�d���A��:PACS-RIS�]���I�[�_�e�[�u��(���t�Ǘ�����)
        w_New_PacsDenbun_NO := '';
        w_New_PacsDenbun_NO := func_Uketuke_Make_PacsDenbunNO(arg_DB,
                                                          w_Query_Data,
                                                          FormatDateTime(CST_FORMATDATE_3, w_DateTime)
                                                         );
        if w_New_PacsDenbun_NO = '' then begin
          if arg_Error_Code <> '' then begin
              arg_Error_Code := CST_ERRCODE_13; //�d���A�Ԏ擾�G���[
              arg_Error_Message := #13#10
                                  +#13#10+'PACS-RIS�]���e�[�u���̓d���A�Ԏ擾�Ɏ��s���܂����B'
                                  +#13#10+'���҂h�c�@�F'+ arg_Kanja_ID
                                  +#13#10+'�q�h�r�h�c�F'+ arg_Ris_ID
                                  ;
          end;
          Result := 3;
        end else begin
          arg_DB.StartTransaction;
          try
            //PACS-RIS�]���I�[�_�e�[�u���ɂ���������
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
              ParamByName('PINFKBN').AsString       := GPCST_INFKBN_FC;     //��t�d��
              ParamByName('PSYORIKBN').AsString     := GPCST_SYORIKBN_03;   //�폜
              ParamByName('PJOUTAIKBN').AsString    := '00'; //��ԂȂ�
              ParamByName('PSOUSIN_DATE').AsString  := '';
              ParamByName('PSOUSIN_FLG').AsString   := '0';  //�����M
              ParamByName('PSOUSIN_STATUS_NAME').AsString := '';
              ParamByName('PKENSATYPE_NAME').AsString     := w_EX_KENSATYPE_NAME;
              ParamByName('PKANJAID').AsString      := arg_Kanja_ID;
              ParamByName('PROMASIMEI').AsString    := w_KJ_ROMASIMEI;
              ParamByName('PKENSA_DATE').AsString   := w_EX_KENSA_DATE; //func_Date10To8(FormatDateTime(CST_FORMATDATE_1 ,w_DateTime));
              ExecSQL;
            end;
            try
              arg_DB.Commit; // ���������ꍇ�C�ύX���R�~�b�g����
            except
              on E: Exception do begin
                  arg_DB.Rollback; // �R�~�b�g�Ŏ��s�����ꍇ�C�ύX��������
                  arg_Error_Code := CST_ERRCODE_10; //�o�^���s
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
                arg_DB.Rollback; // �R�~�b�g�Ŏ��s�����ꍇ�C�ύX��������
                arg_Error_Code := CST_ERRCODE_10; //�o�^���s
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
        //���M�L���[�쐬�ݒ肪"����"or"HIS�Ȃ�Rep����"�̏ꍇ�̓L���[���쐬����B
        if func_Check_CueAndDummy(w_OD_SYSTEMKBN,arg_Kanja_ID,0) then begin

          //�d���A��:REPORT-RIS�]���I�[�_�e�[�u��(���t�Ǘ�����)
          w_New_ReportDenbun_NO := '';
          w_New_ReportDenbun_NO := func_Uketuke_Make_ReportDenbunNO(arg_DB,
                                                            w_Query_Data,
                                                            FormatDateTime(CST_FORMATDATE_3, w_DateTime)
                                                           );
          if w_New_ReportDenbun_NO = '' then begin
            if arg_Error_Code <> '' then begin
              arg_Error_Code := CST_ERRCODE_14; //�d���A�Ԏ擾�G���[
              arg_Error_Message := #13#10
                                  +#13#10+'REPORT-RIS�]���e�[�u���̓d���A�Ԏ擾�Ɏ��s���܂����B'
                                  +#13#10 + '���҂h�c�@�F' + arg_Kanja_ID
                                  +#13#10 + '�q�h�r�h�c�F' + arg_Ris_ID
                                  ;
            end;
            Result := 3;
          end else begin

            arg_DB.StartTransaction;
            try
              //HIS�I�[�_�̏ꍇ�AREPORT-RIS�]���I�[�_�e�[�u���ɂ���������
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
                ParamByName('PINFKBN').AsString       := GPCST_INFKBN_FC;     //��t�d��
                ParamByName('PSYORIKBN').AsString     := GPCST_SYORIKBN_03;   //�폜
                ParamByName('PJOUTAIKBN').AsString    := '00';                //��ԂȂ�
                ParamByName('PSOUSIN_DATE').AsString  := '';
                ParamByName('PSOUSIN_FLG').AsString   := '0';                 //�����M
                ParamByName('PSOUSIN_STATUS_NAME').AsString := '';
                ParamByName('PKENSATYPE_NAME').AsString     := w_EX_KENSATYPE_NAME;
                ParamByName('PKANJAID').AsString      := arg_Kanja_ID;
                ParamByName('PROMASIMEI').AsString    := w_KJ_ROMASIMEI;
                ParamByName('PKENSA_DATE').AsString   := w_EX_KENSA_DATE; //func_Date10To8(FormatDateTime(CST_FORMATDATE_1 ,w_DateTime));
                ExecSQL;
              end;

              try
                arg_DB.Commit; // ���������ꍇ�C�ύX���R�~�b�g����
              except
                on E: Exception do begin
                    arg_DB.Rollback; // �R�~�b�g�Ŏ��s�����ꍇ�C�ύX��������
                    arg_Error_Code := CST_ERRCODE_10; //�o�^���s
                    arg_Error_Message := #13#10
                                       + #13#10+'commit'
                                       + #13#10+E.Message;
                    arg_Error_SQL := w_Query_Update.SQL.Text;
                    Result := 3;
                end;
              end;
            except
              on E: Exception do begin
                  arg_DB.Rollback; // �R�~�b�g�Ŏ��s�����ꍇ�C�ύX��������
                  arg_Error_Code := CST_ERRCODE_10; //�o�^���s
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
      //�X�V�����Ԋ�
      if not func_ReleasKAnri(arg_DB,            //�ڑ����ꂽDB
                              w_Tan_Name,        //PC����
                              arg_PROG_ID,       //�v���O����ID
                              arg_Ris_ID,        //RIS����ID
                              G_KANRI_TBL_WMODE  //�ԊҌ�����(G_KANRI_TBL_WMODE �X�V����)
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
//��t�D��t���O�̐؂�ւ�
//******************************************************************************
function func_Yuusen_Change(
         arg_DB:TDatabase;             //�ڑ����ꂽDB
         arg_PROG_ID:string;           //�v���O����ID
         arg_Ris_ID:string;            //RIS����ID
         arg_YuusenFlg:string;         //�ύX�D��t���O�i���݂̒l�j
         arg_NewYuusenFlg:string;      //�ύX�D��t���O�i�ύX���ׂ��l�j
         var arg_Error_Code:string;    //�G���[�R�[�h
         var arg_Error_Message:string; //�G���[���b�Z�[�W
         var arg_Error_SQL:string;      //�G���[SQL��
         var arg_Error_Haita:Boolean   //�r���폜�G���[ True:�r��ð��ٍ폜���s�AFalse:�r��ð��ٍ폜����
         ):boolean;                    //����True���� False���s

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

  //�R���s���[�^���擾
  w_Tan_Name := func_GetThisMachineName;

  try
    w_Query_Data := TQuery.Create(nil);
    w_Query_Data.DatabaseName := arg_DB.DatabaseName;
    w_Query_Update := TQuery.Create(nil);
    w_Query_Update.DatabaseName := arg_DB.DatabaseName;

    //���ݓ����擾
    w_DateTime := func_GetDBSysDate(w_Query_Data);
    //���ݓ��t�擾
    w_Date := FormatDateTime(CST_FORMATDATE_1, w_DateTime);
    //���ݎ����擾
    w_Time := FormatDateTime(CST_FORMATDATE_4, w_DateTime);

    //�X�V�����擾
    if not func_GetWKAnri(arg_DB,            //�ڑ����ꂽDB
                          w_Tan_Name,        //PC����
                          arg_PROG_ID,       //�v���O����ID
                          arg_Ris_ID         //RIS����ID
                         ) then begin
      proc_Get_Lock_HaitaData(w_Query_Data,
                              arg_Ris_ID,
                              w_Tan_Name,
                              w_KANJAID,
                              w_KENSA_DATE,
                              w_KENSATYPE_NAME);
      arg_Error_Message := #13#10
                          +#13#10+'�[�����@�@�F'+w_Tan_Name
                          +#13#10+'���҂h�c�@�F'+w_KANJAID
                          +#13#10+'���ь������F'+w_KENSA_DATE
                          +#13#10+'������ʁ@�F'+w_KENSATYPE_NAME
                          +#13#10+'�q�h�r�h�c�F'+arg_Ris_ID
                          ;
      arg_Error_Code := CST_ERRCODE_08; //�X�V�����擾�G���[
      Result := False;
      Exit;
    end;

    try
      try
        //�r�����b�N���Q�Ƃ����݂���ꍇ�Ƀ��b�Z�[�W��\�����ĕ\��
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
            arg_Error_Code := CST_ERRCODE_01; //�Ǎ��݃G���[
            Result := False;
            Close;
            Exit;
          end;
          Close;
        end;

      except
        on E: Exception do begin
          arg_Error_Code := CST_ERRCODE_10; //�o�^���s
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
        arg_Error_Code := CST_ERRCODE_16; //�D��t���O�G���[
        Exit;
      end;

      try
        //�g�����U�N�V�����X�^�[�g
        arg_DB.StartTransaction;

        with w_Query_Update do begin
          Close;
          SQL.Clear;
          SQL.Add ('UPDATE EXMAINTABLE SET ');
          SQL.Add ('  YUUSEN_FLG = :PYUUSEN_FLG ');
          SQL.Add ('WHERE RIS_ID        = :PRIS_ID');
          if not Prepared then Prepare;
          //�D��t���O�̕ύX
          ParamByName('PYUUSEN_FLG').AsString := arg_NewYuusenFlg;
          //
          ParamByName('PRIS_ID').AsString := arg_Ris_ID;
          ExecSQL;
        end;

        arg_DB.Commit;

      except
        on E: Exception do begin
          arg_DB.Rollback;
          arg_Error_Code := CST_ERRCODE_10; //�o�^���s
          arg_Error_Message := #13#10
                             + #13#10+E.Message;
          arg_Error_SQL := w_Query_Update.SQL.Text;
          Result := False;
          Exit;
        end;
      end;
    finally
      //�X�V�����Ԋ�
      if not func_ReleasKAnri(arg_DB,            //�ڑ����ꂽDB
                              w_Tan_Name,        //PC����
                              arg_PROG_ID,       //�v���O����ID
                              arg_Ris_ID,        //RIS����ID
                              G_KANRI_TBL_WMODE  //�ԊҌ�����(G_KANRI_TBL_WMODE �X�V����)
                              ) then
        arg_Error_Haita := True;
    end;
  finally
    if w_Query_Data <> nil then w_Query_Data.Free;
    if w_Query_Update <> nil then w_Query_Update.Free;
  end;
end;

//******************************************************************************
//�x���̐؂�ւ�
//******************************************************************************
function func_Tikoku_Change(
         arg_DB:TDatabase;             //�ڑ����ꂽDB
         arg_PROG_ID:string;           //�v���O����ID
         arg_Ris_ID:string;            //RIS����ID
         arg_Status:string;            //�X�e�[�^�X�i����/�����j
         arg_SubStatus:string;         //�T�u�X�e�[�^�X�i����/�ďo/�Č�/�ۗ�/�Ď�j
         arg_Mode:string;              //�x��/�������[�h�i1:�x��/0:�����j
         var arg_Error_Code:string;    //�G���[�R�[�h
         var arg_Error_Message:string; //�G���[���b�Z�[�W
         var arg_Error_SQL:string;     //�G���[SQL��
         var arg_Error_Haita:Boolean   //�r���폜�G���[ True:�r��ð��ٍ폜���s�AFalse:�r��ð��ٍ폜����
         ):boolean;                    //����True���� False���s

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

  //�R���s���[�^���擾
  w_Tan_Name := func_GetThisMachineName;

  try
    w_Query_Data := TQuery.Create(nil);
    w_Query_Data.DatabaseName := arg_DB.DatabaseName;
    w_Query_Update := TQuery.Create(nil);
    w_Query_Update.DatabaseName := arg_DB.DatabaseName;

    //���ݓ����擾
    w_DateTime := func_GetDBSysDate(w_Query_Data);
    //���ݓ��t�擾
    w_Date := FormatDateTime(CST_FORMATDATE_1, w_DateTime);
    //���ݎ����擾
    w_Time := FormatDateTime(CST_FORMATDATE_4, w_DateTime);

    //�X�V�����擾
    if not func_GetWKAnri(arg_DB,            //�ڑ����ꂽDB
                          w_Tan_Name,        //PC����
                          arg_PROG_ID,       //�v���O����ID
                          arg_Ris_ID         //RIS����ID
                         ) then begin
      proc_Get_Lock_HaitaData(w_Query_Data,
                              arg_Ris_ID,
                              w_Tan_Name,
                              w_KANJAID,
                              w_KENSA_DATE,
                              w_KENSATYPE_NAME);
      arg_Error_Message := #13#10
                          +#13#10+'�[�����@�@�F'+w_Tan_Name
                          +#13#10+'���҂h�c�@�F'+w_KANJAID
                          +#13#10+'���ь������F'+w_KENSA_DATE
                          +#13#10+'������ʁ@�F'+w_KENSATYPE_NAME
                          +#13#10+'�q�h�r�h�c�F'+arg_Ris_ID
                          ;
      arg_Error_Code := CST_ERRCODE_08; //�X�V�����擾�G���[
      Result := False;
      Exit;
    end;

    try
      try
        //�r�����b�N���Q�Ƃ����݂���ꍇ�Ƀ��b�Z�[�W��\�����ĕ\��
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
            arg_Error_Code := CST_ERRCODE_01; //�Ǎ��݃G���[
            Result := False;
            Close;
            Exit;
          end;
          Close;
        end;

      except
        on E: Exception do begin
          arg_Error_Code := CST_ERRCODE_10; //�o�^���s
          arg_Error_Message := #13#10
                             + #13#10+E.Message;
          arg_Error_SQL := w_Query_Data.SQL.Text;
          Result := False;
          Exit;
        end;
      end;

      if (arg_Status = w_KENSASTATUS) and
         (arg_SubStatus = w_KENSASUBSTATUS) then begin
        //�x��
        if arg_Mode = CST_TIKOKU_MODE_1 then begin
          if (w_KENSASTATUS = GPCST_CODE_KENSIN_0)
          and ((w_KENSASUBSTATUS = '')
          or (w_KENSASUBSTATUS = GPCST_CODE_KENSIN_SUB_5)) then begin
            //�T�u�X�e�[�^�X�x���Z�b�g
            w_UpSubStatus := GPCST_CODE_KENSIN_SUB_6;
          end
          else begin
            Result := False;
          end;
        end
        else
        //�x������
        if arg_Mode = CST_TIKOKU_MODE_0 then begin
          if (w_KENSASTATUS = GPCST_CODE_KENSIN_0)
          and (w_KENSASUBSTATUS = GPCST_CODE_KENSIN_SUB_6) then begin
            //�T�u�X�e�[�^�X����Default�Z�b�g
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
        arg_Error_Code := CST_ERRCODE_02; //�����i���G���[
        Exit;
      end;

      try
        //�g�����U�N�V�����X�^�[�g
        arg_DB.StartTransaction;

        with w_Query_Update do begin
          Close;
          SQL.Clear;
        //���b�N
          SQL.Add ('SELECT orma.RIS_ID ');
          SQL.Add ('FROM OrderMainTable orma ');
          SQL.Add ('WHERE orma.RIS_ID = :PRIS_ID ');
          SQL.Add (' for update ');
          if not Prepared then Prepare;
          ParamByName('PRIS_ID').AsString := arg_Ris_ID;
          ExecSQL;
          Close;
          SQL.Clear;
        //�X�V
          SQL.Add ('UPDATE EXMAINTABLE SET ');
          SQL.Add ('  KENSASUBSTATUS_FLG = :PKENSASUBSTATUS_FLG ');
          if arg_Mode = CST_TIKOKU_MODE_1 then begin
            SQL.Add (' ,CALL_TIKOKU_DATE = :PCALL_TIKOKU_DATE ');
          end;
          SQL.Add ('WHERE RIS_ID        = :PRIS_ID');
          if not Prepared then Prepare;
          //�T�u�X�e�[�^�X�̕ύX
          ParamByName('PKENSASUBSTATUS_FLG').AsString := w_UpSubStatus;

          if arg_Mode = CST_TIKOKU_MODE_1 then begin
            //�x�������̕ύX
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
          arg_Error_Code := CST_ERRCODE_10; //�o�^���s
          arg_Error_Message := #13#10
                             + #13#10+E.Message;
          arg_Error_SQL := w_Query_Update.SQL.Text;
          Result := False;
          Exit;
        end;
      end;
    finally
      //�X�V�����Ԋ�
      if not func_ReleasKAnri(arg_DB,            //�ڑ����ꂽDB
                              w_Tan_Name,        //PC����
                              arg_PROG_ID,       //�v���O����ID
                              arg_Ris_ID,        //RIS����ID
                              G_KANRI_TBL_WMODE  //�ԊҌ�����(G_KANRI_TBL_WMODE �X�V����)
                              ) then
        arg_Error_Haita := True;
    end;
  finally
    if w_Query_Data <> nil then w_Query_Data.Free;
    if w_Query_Update <> nil then w_Query_Update.Free;
  end;
end;

//******************************************************************************
//�ďo�A�ČĂ̐؂�ւ�
//******************************************************************************
function func_Yobidasi_Change(
         arg_DB:TDatabase;             //�ڑ����ꂽDB
         arg_PROG_ID:string;           //�v���O����ID
         arg_Ris_ID:string;            //RIS����ID
         arg_Status:string;            //�X�e�[�^�X�i����/�����j
         arg_SubStatus:string;         //�T�u�X�e�[�^�X�i����/�ďo/�Č�/�ۗ�/�Ď�j
         arg_Mode:string;              //�ďo/�������[�h�i1:�ďo�A�Č�/0:�����j
         var arg_Error_Code:string;    //�G���[�R�[�h
         var arg_Error_Message:string; //�G���[���b�Z�[�W
         var arg_Error_SQL:string;      //�G���[SQL��
         var arg_Error_Haita:Boolean   //�r���폜�G���[ True:�r��ð��ٍ폜���s�AFalse:�r��ð��ٍ폜����
         ):boolean;                    //����True���� False���s

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

  //�R���s���[�^���擾
  w_Tan_Name := func_GetThisMachineName;

  try
    w_Query_Data := TQuery.Create(nil);
    w_Query_Data.DatabaseName := arg_DB.DatabaseName;
    w_Query_Update := TQuery.Create(nil);
    w_Query_Update.DatabaseName := arg_DB.DatabaseName;

    //���ݓ����擾
    w_DateTime := func_GetDBSysDate(w_Query_Data);
    //���ݓ��t�擾
    w_Date := FormatDateTime(CST_FORMATDATE_1, w_DateTime);
    //���ݎ����擾
    w_Time := FormatDateTime(CST_FORMATDATE_4, w_DateTime);

    //�X�V�����擾
    if not func_GetWKAnri(arg_DB,            //�ڑ����ꂽDB
                          w_Tan_Name,        //PC����
                          arg_PROG_ID,       //�v���O����ID
                          arg_Ris_ID         //RIS����ID
                         ) then begin
      proc_Get_Lock_HaitaData(w_Query_Data,
                              arg_Ris_ID,
                              w_Tan_Name,
                              w_KANJAID,
                              w_KENSA_DATE,
                              w_KENSATYPE_NAME);
      arg_Error_Message := #13#10
                          +#13#10+'�[�����@�@�F'+w_Tan_Name
                          +#13#10+'���҂h�c�@�F'+w_KANJAID
                          +#13#10+'���ь������F'+w_KENSA_DATE
                          +#13#10+'������ʁ@�F'+w_KENSATYPE_NAME
                          +#13#10+'�q�h�r�h�c�F'+arg_Ris_ID
                          ;
      arg_Error_Code := CST_ERRCODE_08; //�X�V�����擾�G���[
      Result := False;
      Exit;
    end;

    try
      try
        //�r�����b�N���Q�Ƃ����݂���ꍇ�Ƀ��b�Z�[�W��\�����ĕ\��
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
            arg_Error_Code := CST_ERRCODE_01; //�Ǎ��݃G���[
            Result := False;
            Close;
            Exit;
          end;
          Close;
        end;

      except
        on E: Exception do begin
          arg_Error_Code := CST_ERRCODE_10; //�o�^���s
          arg_Error_Message := #13#10
                             + #13#10+E.Message;
          arg_Error_SQL := w_Query_Data.SQL.Text;
          Result := False;
          Exit;
        end;
      end;

      if (arg_Status = w_KENSASTATUS) and
         (arg_SubStatus = w_KENSASUBSTATUS) then begin
        //����
        if arg_Status = GPCST_CODE_KENSIN_0 then begin
          //�ďo
          if arg_Mode = CST_YOBI_MODE_1 then begin
            if (w_KENSASTATUS = GPCST_CODE_KENSIN_0)
            and ((w_KENSASUBSTATUS = '')
             or (w_KENSASUBSTATUS = GPCST_CODE_KENSIN_SUB_6)) then begin
              //�T�u�X�e�[�^�X�ďo�Z�b�g
              w_UpSubStatus := GPCST_CODE_KENSIN_SUB_5;
            end
            else begin
              Result := False;
            end;
          end
          else
          //�ďo����
          if arg_Mode = CST_YOBI_MODE_0 then begin
            if (w_KENSASTATUS = GPCST_CODE_KENSIN_0)
            and (w_KENSASUBSTATUS = GPCST_CODE_KENSIN_SUB_5) then begin
              //�T�u�X�e�[�^�X����Default�Z�b�g
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
        //����
        if arg_Status = GPCST_CODE_KENSIN_2 then begin
          //�ďo
          if arg_Mode = CST_YOBI_MODE_1 then begin
{2003.03.03
            if (w_KENSASTATUS = GPCST_CODE_KENSIN_2)
            and ((w_KENSASUBSTATUS = '')
            or (w_KENSASUBSTATUS = GPCST_CODE_KENSIN_SUB_8)
            or (w_KENSASUBSTATUS = GPCST_CODE_KENSIN_SUB_10)) then begin
2003.03.03}
            if ((w_KENSASUBSTATUS = GPCST_CODE_KENSIN_SUB_8) or
                (w_KENSASUBSTATUS = GPCST_CODE_KENSIN_SUB_10)) then begin
              //�T�u�X�e�[�^�X�ČăZ�b�g
              w_UpSubStatus := GPCST_CODE_KENSIN_SUB_9;
            end
            else begin
              Result := False;
            end;
          end
          else
          //�ďo����
          if arg_Mode = CST_YOBI_MODE_0 then begin
            if (w_KENSASTATUS = GPCST_CODE_KENSIN_2)
            and (w_KENSASUBSTATUS = GPCST_CODE_KENSIN_SUB_9) then begin
              //�T�u�X�e�[�^�X�ۗ��Z�b�g
              w_UpSubStatus := GPCST_CODE_KENSIN_SUB_8;
  //            //�T�u�X�e�[�^�X����Default�Z�b�g
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
        arg_Error_Code := CST_ERRCODE_02; //�����i���G���[
        Exit;
      end;

      //�g�����U�N�V�����X�^�[�g
      arg_DB.StartTransaction;
      try

        with w_Query_Update do begin
          Close;
          SQL.Clear;
        //���b�N
          SQL.Add ('SELECT orma.RIS_ID ');
          SQL.Add ('FROM OrderMainTable orma ');
          SQL.Add ('WHERE orma.RIS_ID = :PRIS_ID ');
          SQL.Add (' for update ');
          if not Prepared then Prepare;
          ParamByName('PRIS_ID').AsString := arg_Ris_ID;
          ExecSQL;
          Close;
          SQL.Clear;
        //�X�V
          SQL.Add ('UPDATE EXMAINTABLE SET ');
          SQL.Add ('  KENSASUBSTATUS_FLG = :PKENSASUBSTATUS_FLG ');
          if arg_Mode = CST_YOBI_MODE_1 then begin
            SQL.Add (' ,CALL_TIKOKU_DATE = :PCALL_TIKOKU_DATE ');
          end;
          SQL.Add ('WHERE RIS_ID        = :PRIS_ID');
          if not Prepared then Prepare;
          //�T�u�X�e�[�^�X�̕ύX
          ParamByName('PKENSASUBSTATUS_FLG').AsString := w_UpSubStatus;

          if arg_Mode = CST_YOBI_MODE_1 then begin
            //�ďo�����̕ύX
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
          arg_Error_Code := CST_ERRCODE_10; //�o�^���s
          arg_Error_Message := #13#10
                             + #13#10+E.Message;
          arg_Error_SQL := w_Query_Update.SQL.Text;
          Result := False;
          Exit;
        end;
      end;
    finally
      //�X�V�����Ԋ�
      if not func_ReleasKAnri(arg_DB,            //�ڑ����ꂽDB
                              w_Tan_Name,        //PC����
                              arg_PROG_ID,       //�v���O����ID
                              arg_Ris_ID,        //RIS����ID
                              G_KANRI_TBL_WMODE  //�ԊҌ�����(G_KANRI_TBL_WMODE �X�V����)
                              ) then
        arg_Error_Haita := True;
    end;
  finally
    if w_Query_Data <> nil then w_Query_Data.Free;
    if w_Query_Update <> nil then w_Query_Update.Free;
  end;
end;

//******************************************************************************
//�m�ۂ̐؂�ւ�
//******************************************************************************
function func_Kakuho_Change(
         arg_DB:TDatabase;             //�ڑ����ꂽDB
         arg_PROG_ID:string;           //�v���O����ID
         arg_Ris_ID:string;            //RIS����ID
         arg_Status:string;            //�X�e�[�^�X�i��ρj
         arg_Mode:string;              //�ďo/�������[�h�i1:�m��/0:�����j
         var arg_Error_Code:string;    //�G���[�R�[�h
         var arg_Error_Message:string; //�G���[���b�Z�[�W
         var arg_Error_SQL:string;     //�G���[SQL��
         var arg_Error_Haita:Boolean   //�r���폜�G���[ True:�r��ð��ٍ폜���s�AFalse:�r��ð��ٍ폜����
         ):boolean;                    //����True���� False���s

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

  //�R���s���[�^���擾
  w_Tan_Name := func_GetThisMachineName;

  try
    w_Query_Data := TQuery.Create(nil);
    w_Query_Data.DatabaseName := arg_DB.DatabaseName;
    w_Query_Update := TQuery.Create(nil);
    w_Query_Update.DatabaseName := arg_DB.DatabaseName;

    //���ݓ����擾
    w_DateTime := func_GetDBSysDate(w_Query_Data);
    //���ݓ��t�擾
    w_Date := FormatDateTime(CST_FORMATDATE_1, w_DateTime);
    //���ݎ����擾
    w_Time := FormatDateTime(CST_FORMATDATE_4, w_DateTime);

    //�X�V�����擾
    if not func_GetWKAnri(arg_DB,            //�ڑ����ꂽDB
                          w_Tan_Name,        //PC����
                          arg_PROG_ID,       //�v���O����ID
                          arg_Ris_ID         //RIS����ID
                         ) then begin
      proc_Get_Lock_HaitaData(w_Query_Data,
                              arg_Ris_ID,
                              w_Tan_Name,
                              w_KANJAID,
                              w_KENSA_DATE,
                              w_KENSATYPE_NAME);
      arg_Error_Message := #13#10
                          +#13#10+'�[�����@�@�F'+w_Tan_Name
                          +#13#10+'���҂h�c�@�F'+w_KANJAID
                          +#13#10+'���ь������F'+w_KENSA_DATE
                          +#13#10+'������ʁ@�F'+w_KENSATYPE_NAME
                          +#13#10+'�q�h�r�h�c�F'+arg_Ris_ID
                          ;
      arg_Error_Code := CST_ERRCODE_08; //�X�V�����擾�G���[
      Result := False;
      Exit;
    end;

    try
      try
        //�r�����b�N���Q�Ƃ����݂���ꍇ�Ƀ��b�Z�[�W��\�����ĕ\��
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
            arg_Error_Code := CST_ERRCODE_01; //�Ǎ��݃G���[
            Result := False;
            Close;
            Exit;
          end;
          Close;
        end;

      except
        on E: Exception do begin
          arg_Error_Code := CST_ERRCODE_10; //�o�^���s
          arg_Error_Message := #13#10
                             + #13#10+E.Message;
          arg_Error_SQL := w_Query_Data.SQL.Text;
          Result := False;
          Exit;
        end;
      end;

      //��t��
      if arg_Status = GPCST_CODE_KENSIN_1 then begin
        //�m��
        if arg_Mode = CST_KAKUHO_MODE_1 then begin
          //��t��
          if (w_KENSASTATUS = GPCST_CODE_KENSIN_1) and
             (w_KENSASUBSTATUS = '') then begin
            //�T�u�X�e�[�^�X�ďo�Z�b�g
            w_UpSubStatus := GPCST_CODE_KENSIN_SUB_7;
          end
          else begin
            Result := False;
          end;
        end
        else
        //�m�ۉ���
        if arg_Mode = CST_KAKUHO_MODE_0 then begin
          if (w_KENSASTATUS = GPCST_CODE_KENSIN_1) and
             (w_KENSASUBSTATUS = GPCST_CODE_KENSIN_SUB_7) then begin
            //�T�u�X�e�[�^�X����Default�Z�b�g
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
        arg_Error_Code := CST_ERRCODE_02; //�����i���G���[
        Exit;
      end;

      //�g�����U�N�V�����X�^�[�g
      arg_DB.StartTransaction;
      try

        with w_Query_Update do begin
          Close;
          SQL.Clear;
        //���b�N
          SQL.Add ('SELECT orma.RIS_ID ');
          SQL.Add ('FROM OrderMainTable orma ');
          SQL.Add ('WHERE orma.RIS_ID = :PRIS_ID ');
          SQL.Add (' for update ');
          if not Prepared then Prepare;
          ParamByName('PRIS_ID').AsString := arg_Ris_ID;
          ExecSQL;
          Close;
          SQL.Clear;
        //�X�V
          SQL.Add ('UPDATE EXMAINTABLE SET ');
          SQL.Add ('  KENSASUBSTATUS_FLG = :PKENSASUBSTATUS_FLG ');
//          if arg_Mode = CST_KAKUHO_MODE_1 then begin
//            SQL.Add (' ,CALL_TIKOKU_DATE = :PCALL_TIKOKU_DATE ');
//          end;
          SQL.Add ('WHERE RIS_ID        = :PRIS_ID');
          if not Prepared then Prepare;
          //�T�u�X�e�[�^�X�̕ύX
          ParamByName('PKENSASUBSTATUS_FLG').AsString := w_UpSubStatus;

//          if arg_Mode = CST_KAKUHO_MODE_1 then begin
//            //�ďo�����̕ύX
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
          arg_Error_Code := CST_ERRCODE_10; //�o�^���s
          arg_Error_Message := #13#10
                             + #13#10+E.Message;
          arg_Error_SQL := w_Query_Update.SQL.Text;
          Result := False;
          Exit;
        end;
      end;
    finally
      //�X�V�����Ԋ�
      if not func_ReleasKAnri(arg_DB,            //�ڑ����ꂽDB
                              w_Tan_Name,        //PC����
                              arg_PROG_ID,       //�v���O����ID
                              arg_Ris_ID,        //RIS����ID
                              G_KANRI_TBL_WMODE  //�ԊҌ�����(G_KANRI_TBL_WMODE �X�V����)
                              ) then
        arg_Error_Haita := True;
    end;
  finally
    if w_Query_Data <> nil then w_Query_Data.Free;
    if w_Query_Update <> nil then w_Query_Update.Free;
  end;
end;

//******************************************************************************
// �g�p���̑��[���𒲂ׂ�
//******************************************************************************
procedure proc_Get_Lock_HaitaData(arg_Query:TQuery;
                                  arg_Ris_ID:String;
                                  var arg_Tan:String;
                                  var arg_Kanja:String;
                                  var arg_KensaDate:string;
                                  var arg_Kensa_Name:String);
begin
  //�r�����擾
  with arg_Query do begin
    //����
    Close;
    //�O��SQL���̃N���A
    SQL.Clear;
    //SQL���쐬
    SQL.Add('SELECT kan.TAN_NAME, kan.PROG_ID, kan.RIS_ID, kan.SYORI_MODE, exma.KENSA_DATE, exma.KANJAID, mas.KENSATYPE_NAME ');
    SQL.Add('FROM KANRITABLE kan, EXMAINTABLE exma, KENSATYPEMASTER mas');
    SQL.Add('WHERE exma.KENSATYPE_ID = mas.KENSATYPE_ID(+)');
    SQL.Add('  AND kan.RIS_ID = exma.RIS_ID');
    SQL.Add('  AND kan.RIS_ID = '''+ arg_Ris_ID + '''');
    SQL.Add('  AND kan.SYORI_MODE = '+ G_KANRI_TBL_WMODE + '');
    //�⍇���m�F
    if not Prepared then
      //�⍇������
      Prepare;
    //�J��
    Open;
    //�Ō�̃��R�[�h�Ɉړ�
    Last;
    //�ŏ��̃��R�[�h�Ɉړ�
    First;
    //�[������
    arg_Kanja      := FieldByName('KANJAID').AsString;
    arg_Kensa_Name := FieldByName('KENSATYPE_NAME').AsString;
    arg_KensaDate  := func_Date8To10(FieldByName('KENSA_DATE').AsString);
    arg_Tan        := FieldByName('TAN_NAME').AsString;
    //����
    Close;
  end;
end;
//******************************************************************************
//�X�V�����̎擾�ƍŐV�i���̔�r
//******************************************************************************
function proc_Kousin_Sintyoku(
                               arg_DB:TDatabase;             //�ڑ����ꂽDB
                               arg_PROG_ID:string;           //�v���O����ID
                               arg_Ris_ID:TStrings;
                               arg_Kanja_ID:TStrings;
                               arg_RomaSimei:TStrings;
                               arg_main:TStrings;
                               arg_Sub:TStrings;
                               var arg_Error_Code:string;    //�G���[�R�[�h
                               var arg_Error_Message:string; //�G���[���b�Z�[�W
                               var arg_Error_SQL:string     //�G���[SQL��
                               ):Integer;                    //����0:�����A1:�r��/�i���װ�A2�F���[���ōX�V��

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

  //�R���s���[�^���擾
  w_Tan_Name := func_GetThisMachineName;
  try
    //�g�����U�N�V�����l��
    arg_DB.StartTransaction;
    //ROOP
    for w_i := 0 to arg_Ris_ID.Count -1 do begin
      //�X�V�����擾
      if not func_GetWKAnriUketuke(arg_DB,     //�ڑ����ꂽDB
                            w_Tan_Name,        //PC����
                            arg_PROG_ID,       //�v���O����ID
                            arg_Ris_ID[w_i]    //RIS����ID
                           ) then begin
         proc_Get_Lock_HaitaData(w_Query_Data,
                                 arg_Ris_ID[w_i],
                                 w_Tan_Name,
                                 w_Kanja,
                                 w_Now_KENSA_DATE,
                                 w_EX_KENSATYPE_NAME);
         arg_Error_Message := #13#10
                            +#13#10+'�[�����@�@�F'+w_Tan_Name
                            +#13#10+'���҂h�c�@�F'+w_Kanja
                            +#13#10+'���ь������F'+w_Now_KENSA_DATE
                            +#13#10+'������ʁ@�F'+w_EX_KENSATYPE_ID
                            +#13#10+'�q�h�r�h�c�F'+arg_Ris_ID[w_i]
                            ;
        w_Err_Flg :='1';
        w_Syutoku_Err := w_i -1;
        arg_Error_Code := CST_ERRCODE_08; //�X�V�����擾�G���[
        Result := 2;
        Break;
      end;
      //�I�[�_���C���A���у��C���A���҃}�X�^���ŐV���̎擾
      with w_Query_Data do begin
        Close;
        SQL.Clear;
        SQL.Add ('SELECT exma.*,km.ROMASIMEI ');
        SQL.Add ('FROM   EXMAINTABLE exma ');
        SQL.Add ('�@�@   ,KanjaMaster km');
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
            //�ŐV�̌����i������
            if ((FieldByName('KENSASTATUS_FLG').AsString <> GPCST_CODE_KENSIN_0) and
              (FieldByName('KENSASTATUS_FLG').AsString <>  GPCST_CODE_KENSIN_2)) or
              ((FieldByName('KENSASTATUS_FLG').AsString = GPCST_CODE_KENSIN_2) and
              ((FieldByName('KENSASUBSTATUS_FLG').AsString <> GPCST_CODE_KENSIN_SUB_8) and
              (FieldByName('KENSASUBSTATUS_FLG').AsString <> GPCST_CODE_KENSIN_SUB_9))) then begin
              //��t�o�^�s��
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
          w_Sintyoku :='�I�[�_�L�����Z��';
          w_Status.Add(w_Sintyoku);
          w_Data := w_Data+#13#10+arg_Kanja_ID[w_i]+'/'+arg_RomaSimei[w_i]+':'+w_Sintyoku;

        end;
        Close;
      end;
    end;  //Roop End
    //�G���[�`�F�b�N
    if w_Err_Flg ='2' then begin
      arg_Error_Message := w_Data;
      arg_Error_Code := CST_ERRCODE_17;
      Result :=1;
    end;
    //�G���[�����݂������́A�r���Ǘ�Rollback
    //�G���[�����݂��Ȃ��������́A�r���Ǘ�Commit
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
      //�X�V�����̕Ԋ�
      for w_i :=0 to w_Syutoku_Err do begin
         func_ReleasKAnri(arg_DB,            //�ڑ����ꂽDB
                          w_Tan_Name,        //PC����
                          arg_PROG_ID,       //�v���O����ID
                          arg_Ris_ID[w_i],   //RIS����ID
                          G_KANRI_TBL_WMODE  //�ԊҌ�����(G_KANRI_TBL_WMODE �X�V����)
                          )
      end;
      Exit;
    end;
    if Result = 0 then begin
      arg_DB.Commit;
    end;
  Except
    on E: Exception do begin
      arg_DB.Rollback; // �R�~�b�g�Ŏ��s�����ꍇ�C�ύX��������
      arg_Error_Code := CST_ERRCODE_10; //�o�^���s
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
                               arg_DB:TDatabase;             //�ڑ����ꂽDB
                               arg_PROG_ID:string;           //�v���O����ID
                               arg_Ris_ID:TStrings
                               );
var
 w_Tan_Name:string;
 w_i:integer;
 //arg_Error_Haita :Boolean;
begin
  //�R���s���[�^���擾
  w_Tan_Name := func_GetThisMachineName;

  for w_i := 0 to arg_Ris_ID.Count -1 do begin
    //�X�V�����Ԋ�
    if not func_ReleasKAnri(arg_DB,            //�ڑ����ꂽDB
                            w_Tan_Name,        //PC����
                            arg_PROG_ID,       //�v���O����ID
                            arg_Ris_ID[w_i],        //RIS����ID
                            G_KANRI_TBL_WMODE  //�ԊҌ�����(G_KANRI_TBL_WMODE �X�V����)
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
