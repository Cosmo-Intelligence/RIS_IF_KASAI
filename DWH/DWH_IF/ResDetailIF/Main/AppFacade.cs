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

			//検索用 項目コード 設定
			List<string> list = new List<string>();
			list.AddRange(AppConfig.ItemCodeEgfr);
			list.AddRange(AppConfig.ItemCodeCreatinin);
			ResDetail.ItemCode = SqlUtil.InStr(list, true);
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
			DataTable dt = QueueTable.Select();
			AppGlobal.ApLogger.Info(" ToHisInfo検索結果 [{0}]件", dt.Rows.Count);
			if (dt.Rows.Count == 0)
			{
				return;
			}

			//キューを処理
			foreach (DataRow row in dt.Rows)
			{
				try
				{
					AppGlobal.ApLogger.Info("REQUESTID[{0}] 処理 --->", row.StrVal("REQUESTID"));
					TreatQueue(row);
				}
				catch (Exception ex)
				{
					AppGlobal.ApLogger.Fatal("ToHisInfo処理でエラー発生:" + ex);
				}
				finally
				{
					AppGlobal.ApLogger.Info("REQUESTID[{0}] 処理 <---", row.StrVal("REQUESTID"));
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

			string errTxt = "";

			#region データ確認
			ResDetailData resDetail = null;
			if (isOKData(row, ref errTxt, ref resDetail) == false)
			{
				AppGlobal.ApLogger.Warn(errTxt);

				//キュー更新
				AppGlobal.RISDB.BeginTrans();
				QueueTable.Update(row.IntVal("REQUESTID"), false, errTxt);
				AppGlobal.RISDB.EndTrans(true);

				return;
			}
			#endregion

			#region データ更新
			bool isOk = false;
			isOk = UpdatePatient(row, resDetail);
			if (isOk == false)
			{
				errTxt = "データ更新に失敗しました";
			}

			//キュー更新
			AppGlobal.RISDB.BeginTrans();
			QueueTable.Update(row.IntVal("REQUESTID"), isOk, errTxt);
			AppGlobal.RISDB.EndTrans(true);
			#endregion

			AppGlobal.ApLogger.End();
		}

		/// <summary>
		/// データチェック
		/// </summary>
		/// <param name="row">キューデータ</param>
		/// <param name="errTxt">エラー文字列</param>
		/// <param name="resDetail">resDetailデータ</param>
		/// <returns>T: OK F:NG</returns>
		private bool isOKData(DataRow row, ref string errTxt, ref ResDetailData resDetail)
		{
			errTxt = "";
			//DWHデータ取得
			DataTable dt = ResDetail.Select(row);
			if (dt.Rows.Count == 0)
			{
				errTxt = "RESDETAIL に該当データがありません";
				return false;
			}

			resDetail = new ResDetailData(dt);
			resDetail.PickUp();
			if (resDetail.HasValue == false)
			{
				errTxt = "RESDETAIL データが不正";
				return false;
			}

			return true;
		}

		/// <summary>
		/// データ登録 患者情報
		/// </summary>
		/// <param name="row">キューデータ</param>
		/// <param name="errTxt">エラー文字列</param>
		/// <param name="resDetail">ResDetailデータ</param>
		/// <returns>T:OK F:NG</returns>
		private bool UpdatePatient(DataRow row, ResDetailData resDetail)
		{
			AppGlobal.ApLogger.Start();

			//トランザクション -->
			AppGlobal.RISDB.BeginTrans();
			bool isCommit = false;
			try
			{
				string kanjaID = row.StrVal("MESSAGEID1");
				//データ更新
				if (PatientInfo.Update(kanjaID, resDetail) == false)
				{
					return false;
				}
				//正常終了
				isCommit = true;
				return true;
			}
			finally
			{
				//トランザクション <--
				AppGlobal.RISDB.EndTrans(isCommit);
				AppGlobal.ApLogger.End();
			}

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
