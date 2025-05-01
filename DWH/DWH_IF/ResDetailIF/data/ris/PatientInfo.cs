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
		/// <param name="data">ResDetail�f�[�^</param>
		/// <returns>T:���� F:���s</returns>
		public static bool Update(string kanjaID, ResDetailData data)
		{
			const string CREA_VAL_COL =		"CREATININERESULT";
			const string CREA_DATE_COL =	"CREATININEUPDATEDATE";
			const string EGFR_VAL_COL =		"EGFRRESULT";
			const string EGFR_DATE_COL =	"EGFRUPDATEDATE";

			//�f�[�^�X�V(�N���A�`�j��)
			if (Update(kanjaID, CREA_VAL_COL, CREA_DATE_COL, data.Creatinin) == false)
			{
				return false;
			}

			//�f�[�^�X�V(Egfr)
			if (Update(kanjaID, EGFR_VAL_COL, EGFR_DATE_COL, data.Egfr) == false)
			{
				return false;
			}

			return true;
		}
		#endregion

		#region [private]���\�b�h
		/// <summary>
		/// Update
		/// </summary>
		/// <param name="kanjaID">����ID</param>
		/// <param name="valCol">���ʒl�J����</param>
		/// <param name="dateCol">�̎���J����</param>
		/// <param name="data">ResDetail�f�[�^</param>
		/// <returns>T:���� F:���s</returns>
		private static bool Update(string kanjaID, string valCol, string dateCol, ResDetailData.DataSet data)
		{
			//�f�[�^�Ȃ�
			if (data.HasValue == false)
			{
				return true;
			}

			string sqlStr = @"UPDATE PATIENTINFO
SET {0} =:COL_VALUE
   ,{1} =:COL_DATE
WHERE KANJA_ID =:KANJA_ID";
			sqlStr = string.Format(sqlStr, valCol, dateCol);

			//�p�����[�^
			OraParams prms = new OraParams();
			prms.Add("COL_VALUE", 16, data.Value);
			prms.Add("COL_DATE", data.UpdateDate);
			prms.Add("KANJA_ID", 64, kanjaID);

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
