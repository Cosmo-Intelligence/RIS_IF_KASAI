using System;
using System.Collections.Generic;
using System.Text;
using System.IO;
using System.Data;
using System.Linq;
using System.Threading;
//
using ComLib;
using ComLib.database;
using ComLib.thread;
using SlnCom;
using ResDetailIF.config;
using ResDetailIF.data.ris;
using ResDetailIF.data.dwh;

namespace ResDetailIF.Main
{
	/// <summary>
	/// ファサードclass
	/// </summary>
	public class AppFacade : DisposeBase
	{
		#region 定数
		#endregion

		#region メンバー
		/// <summary>
		/// ログ・一時ファイル削除用スレッド
		/// </summary>
		private CycleThread vMdeleteThread;
		#endregion

		#region コンストラクタ
		/// <summary>
		/// コンストラクタ
		/// </summary>
		public AppFacade()
		{
			//1時間毎に削除
			vMdeleteThread = new CycleThread(1 * 60 * 60 * 1000, DeleteFiles, AppGlobal.ApLogger);

			//スレッド開始
			vMdeleteThread.Start("DeleteLogThread");
					}
		#endregion

		#region [public]メソッド
		/// <summary>
		/// メイン処理
		/// </summary>
		public void MainProc()
		{
			AppGlobal.ApLogger.Start();

			//DB再接続
			if (AppGlobal.RISDB.KeepConnection() == false)
			{
				AppGlobal.ApLogger.Error("DB接続失敗(RIS)");
				return;
			}
			if (AppGlobal.DWHDB.KeepConnection() == false)
			{
				AppGlobal.ApLogger.Error("DB接続失敗(DWH)");
				return;
			}

			//キュー検索
			DataTable dt = QueueTable.Select(DateTime.Now);
			AppGlobal.ApLogger.Info("対象オーダ 検索結果 [{0}]件", dt.Rows.Count);

			foreach (DataRow row in dt.Rows)
			{
				try
				{
					//キューを処理
					AppGlobal.ApLogger.Info("RIS_ID[{0}] 処理 --->", row.StrVal("RIS_ID"));
					TreatQueue(row);
				}
				catch (Exception ex)
				{
					AppGlobal.ApLogger.Fatal("対象オーダ 処理でエラー発生:" + ex);
				}
				finally
				{
					AppGlobal.ApLogger.Info("RIS_ID[{0}] 処理 <---", row.StrVal("RIS_ID"));
				}
			}

			AppGlobal.ApLogger.End();
		}
		#endregion

		#region [protected]メソッド
		/// <summary>
		/// UnManaged リソース解放
		/// </summary>
		protected override void ReleaseUnManaged()
		{
			//スレッド終了
			vMdeleteThread.Dispose();
		}
		#endregion

		#region [private]メソッド
		/// <summary>
		/// キューを処理
		/// </summary>
		private void TreatQueue(DataRow row)
		{
			AppGlobal.ApLogger.Start();

			//来院情報 取得
			DataTable dt = AppPatient.Select(row);
			if (dt.Rows.Count == 0)
			{
				AppGlobal.ApLogger.Info("DWHに来院情報なし → 患者情報更新なし");
				return;
			}
			DataRow dwhRow = dt.Rows[0];

			string inchakuDateStr = dwhRow.DateToStr("UPDATEDATE", "yyyyMMdd") + dwhRow.StrVal("VISITTIME");
			DateTime inchakuDate;
			if (StrUtil.TryParseDateTime(inchakuDateStr, "yyyyMMddHHmmss", out inchakuDate) == false)
			{
				AppGlobal.ApLogger.Info("院着日時が不正です [{0}]", inchakuDateStr);
				return;
			}

			AppGlobal.RISDB.BeginTrans();
			bool isCommit = false;
			try
			{
				isCommit = PatientInfo.Update(row.StrVal("KANJA_ID"), inchakuDate);
			}
			finally
			{
				AppGlobal.RISDB.EndTrans(isCommit);
			}

			AppGlobal.ApLogger.End();
		}

		/// <summary>
		/// ファイル削除
		/// </summary>
		private void DeleteFiles()
		{
			AppGlobal.ApLogger.Info("保存日数超過ファイル削除処理 --->");
			try
			{
				//ログファイル
				AppGlobal.ApLogger.DeleteExpired();
				AppGlobal.SqlLogger.DeleteExpired();
			}
			catch (Exception ex)
			{
				string msg = "保存日数超過ファイル削除処理でエラー発生\n" + ex;
				AppGlobal.ApLogger.Error(msg);
			}
			finally
			{
				AppGlobal.ApLogger.Info("保存日数超過ファイル削除処理 <---");
			}
		}
		#endregion
	}
}
