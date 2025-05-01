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
	/// キューテーブル アクセスクラス
	/// </summary>	
	public static class QueueTable
	{
		#region 定数
		/// <summary>
		/// テーブル名
		/// </summary>
		private const string TABLE_NAME = "TOHISINFO";
		#endregion

		#region メンバー
		#endregion

		#region [publlc]メソッド
		/// <summary>
		/// Select
		/// </summary>
		/// <returns>データ</returns>
		public static DataTable Select()
		{
			string sqlStr = @"SELECT THI.*, EX.STATUS
FROM TOHISINFO THI
  LEFT JOIN EXMAINTABLE EX ON THI.RIS_ID = EX.RIS_ID
WHERE THI.REQUESTTYPE = 'PR01'
AND THI.TRANSFERSTATUS = '00'
ORDER BY THI.REQUESTID";

			//SQL実行
			return AppGlobal.RISDB.ExecuteDataTable(sqlStr);
		}

		/// <summary>
		/// Update
		/// </summary>
		/// <param name="requestID">REQUESTID</param>
		/// <param name="isOk">ファイル出力 成功・失敗</param>
		/// <param name="errTxt">エラー内容</param>
		/// <returns>T:成功 F:失敗</returns>
		public static bool Update(int requestID, bool isOk, string errTxt)
		{
			string sqlStr = @"UPDATE TOHISINFO
SET TRANSFERSTATUS = '01'
   ,TRANSFERDATE = SYSDATE
   ,TRANSFERRESULT =:TRANSFERRESULT
   ,TRANSFERTEXT =:TRANSFERTEXT
WHERE REQUESTID =:REQUESTID";

			string result = isOk ? "OK" : "NG";
			//パラメータ
			OraParams prms = new OraParams();
			prms.Add("REQUESTID", 8, requestID);
			prms.Add("TRANSFERRESULT", 10, result);
			prms.Add("TRANSFERTEXT", 1024, errTxt);	//Long → とりあえず1024設定
			try
			{
				int count = AppGlobal.RISDB.ExecuteSQL(sqlStr, prms);
				AppGlobal.ApLogger.Info(TABLE_NAME + " [{0}]件 更新", count);
				return true;
			}
			catch (Exception ex)
			{
				AppGlobal.ApLogger.Error(TABLE_NAME + " 更新でエラー発生:" + ex);
				return false;
			}
		}
		#endregion
	}
}
