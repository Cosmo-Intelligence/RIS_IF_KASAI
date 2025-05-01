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
	/// ResDetail �A�N�Z�X�N���X
	/// </summary>	
	public static class ResDetail
	{
		#region �萔
		/// <summary>
		/// �e�[�u����
		/// </summary>
		private const string TABLE_NAME = "RIS_RESDETAIL";
		#endregion

		#region �v���p�e�B
		/// <summary>
		/// �����p ���ڃR�[�h
		/// </summary>
		public static string ItemCode
		{
			private get;
			set;
		}
		#endregion

		#region [publlc]���\�b�h
		/// <summary>
		/// Select
		/// </summary>
		/// <param name="risData">ToHisInfo�f�[�^</param>
		/// <returns>�f�[�^</returns>
		public static DataTable Select(DataRow risData)
		{
			string sqlStr = @"SELECT *
FROM RIS_RESDETAIL
WHERE PATIENTNO =:PATIENTNO
AND TESTSIGN >= '1'
AND TESTITEMCODE IN ({0})
ORDER BY COLLECTDATE DESC, COLLECTTIME DESC";

			sqlStr = string.Format(sqlStr, ItemCode);
			//�p�����[�^
			OraParams prms = new OraParams();
			prms.Add("PATIENTNO", 10, risData.StrVal("MESSAGEID1"));

			//SQL���s
			return AppGlobal.DWHDB.ExecuteDataTable(sqlStr, prms);
		}
		#endregion
	}
}
