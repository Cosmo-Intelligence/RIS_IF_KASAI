using System;
using System.Data;
using System.Collections.Generic;
//
using ComLib.log;
using ComLib.database;
using ResDetailIF.config;
using SlnCom;

namespace ResDetailIF.data.dwh
{
	/// <summary>
	/// RIS_APPPATIENT �A�N�Z�X�N���X
	/// </summary>	
	public static class AppPatient
	{
		#region �萔
		/// <summary>
		/// �e�[�u����
		/// </summary>
		private const string TABLE_NAME = "RIS_APPPATIENT";
		#endregion

		#region �v���p�e�B
		#endregion

		#region [publlc]���\�b�h
		/// <summary>
		/// Select
		/// </summary>
		/// <param name="row">�I�[�_�f�[�^</param>
		/// <returns>�f�[�^</returns>
		public static DataTable Select(DataRow row)
		{
			string sqlStr = @"SELECT 
   UPDATEDATE
  ,VISITTIME
FROM RIS_APPPATIENT
WHERE INVALIDSTATUS = '0'
AND VISITSTATUS = '1'
AND PATIENTNO =:PATIENTNO
ORDER BY UPDATEDATE DESC, VISITTIME DESC";

			OraParams prms = new OraParams();
			prms.Add("PATIENTNO", 10, row.StrVal("KANJA_ID"));

			//SQL���s
			DataTable dt = AppGlobal.DWHDB.ExecuteDataTable(sqlStr, prms);
			AppGlobal.ApLogger.Info(TABLE_NAME + " �擾����[{0}]", dt.Rows.Count);
			return dt;
		}
		#endregion
	}
}
