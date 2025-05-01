using System;
using System.Data;
using System.Collections.Generic;
//
using ComLib.log;
using ComLib.database;
using SlnCom;
using ResDetailIF.config;
using ResDetailIF.Main;

namespace ResDetailIF.data.ris
{
	/// <summary>
	/// PATIENTINFO �A�N�Z�X�N���X
	/// </summary>	
	public static class PatientInfo
	{
		#region �萔
		/// <summary>
		/// �e�[�u����
		/// </summary>
		private const string TABLE_NAME = "PATIENTINFO";
		#endregion

		#region �����o�[
		#endregion

		#region [publlc]���\�b�h
		/// <summary>
		/// Update
		/// </summary>
		/// <param name="kanjaID">����ID</param>
		/// <param name="inchakuDate">�@������</param>
		/// <returns>T:���� F:���s</returns>
		public static bool Update(string kanjaID, DateTime inchakuDate)
		{
			//INCHAKU_FLG = 1 (������)
			string sqlStr = @"UPDATE PATIENTINFO
SET INCHAKU_DATE =:INCHAKU_DATE
   ,INCHAKU_FLG ='1'
WHERE KANJA_ID =:KANJA_ID";

			//�p�����[�^
			OraParams prms = new OraParams();
			prms.Add("INCHAKU_DATE", inchakuDate);
			prms.Add("KANJA_ID", 64, kanjaID);;
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
