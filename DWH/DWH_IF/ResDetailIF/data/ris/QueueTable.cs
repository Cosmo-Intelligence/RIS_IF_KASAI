using System;
using System.Data;
using System.Collections.Generic;
//
using ComLib.log;
using ComLib.database;
using ResDetailIF.config;
using SlnCom;

namespace ResDetailIF.data.ris
{
	/// <summary>
	/// �L���[�e�[�u�� �A�N�Z�X�N���X
	/// </summary>	
	public static class QueueTable
	{
		#region �萔
		/// <summary>
		/// �e�[�u����
		/// </summary>
		private const string TABLE_NAME = "TOHISINFO";
		#endregion

		#region �����o�[
		#endregion

		#region [publlc]���\�b�h
		/// <summary>
		/// Select
		/// </summary>
		/// <returns>�f�[�^</returns>
		public static DataTable Select()
		{
			string sqlStr = @"SELECT THI.*, EX.STATUS
FROM TOHISINFO THI
  LEFT JOIN EXMAINTABLE EX ON THI.RIS_ID = EX.RIS_ID
WHERE THI.REQUESTTYPE = 'PR01'
AND THI.TRANSFERSTATUS = '00'
ORDER BY THI.REQUESTID";

			//SQL���s
			return AppGlobal.RISDB.ExecuteDataTable(sqlStr);
		}

		/// <summary>
		/// Update
		/// </summary>
		/// <param name="requestID">REQUESTID</param>
		/// <param name="isOk">�t�@�C���o�� �����E���s</param>
		/// <param name="errTxt">�G���[���e</param>
		/// <returns>T:���� F:���s</returns>
		public static bool Update(int requestID, bool isOk, string errTxt)
		{
			string sqlStr = @"UPDATE TOHISINFO
SET TRANSFERSTATUS = '01'
   ,TRANSFERDATE = SYSDATE
   ,TRANSFERRESULT =:TRANSFERRESULT
   ,TRANSFERTEXT =:TRANSFERTEXT
WHERE REQUESTID =:REQUESTID";

			string result = isOk ? "OK" : "NG";
			//�p�����[�^
			OraParams prms = new OraParams();
			prms.Add("REQUESTID", 8, requestID);
			prms.Add("TRANSFERRESULT", 10, result);
			prms.Add("TRANSFERTEXT", 1024, errTxt);	//Long �� �Ƃ肠����1024�ݒ�
			try
			{
				int count = AppGlobal.RISDB.ExecuteSQL(sqlStr, prms);
				AppGlobal.ApLogger.Info(TABLE_NAME + " [{0}]�� �X�V", count);
				return true;
			}
			catch (Exception ex)
			{
				AppGlobal.ApLogger.Error(TABLE_NAME + " �X�V�ŃG���[����:" + ex);
				return false;
			}
		}
		#endregion
	}
}
