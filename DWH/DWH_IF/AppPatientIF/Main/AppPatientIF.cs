using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Diagnostics;
using System.ServiceProcess;
using System.Text;
using System.Reflection;
using System.Threading;
//
using ResDetailIF.config;

namespace ResDetailIF.Main
{
	/// <summary>
	/// サービス
	/// </summary>
	public partial class srvAppPatientIF : ServiceBase
	{
		#region メンバー
		/// <summary>
		/// ファサード
		/// </summary>
		private AppFacade facade = new AppFacade();
		#endregion

		#region コンストラクタ
		/// <summary>
		/// コンストラクタ
		/// </summary>
		public srvAppPatientIF()
		{
			InitializeComponent();
		}
		#endregion

		#region サービス処理
		/// <summary>
		/// サービス開始
		/// </summary>
		/// <param name="args"></param>
		protected override void OnStart(string[] args)
		{
			timerCycle.Enabled = false;
			//タイマー設定
			timerCycle.Interval = AppConfig.CycleInterval;
			timerCycle.Enabled = true;
		}
		/// <summary>
		/// サービス終了
		/// </summary>
		protected override void OnStop()
		{
			facade.Dispose();
		}
		#endregion

		#region タイマー
		/// <summary>
		/// 定周期タイマー
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
		private void timerCycle_Elapsed(object sender, System.Timers.ElapsedEventArgs e)
		{
			AppGlobal.ApLogger.Info("定周期処理 >>>>>>>>>>>>>>>>>>>>");

			//定周期処理停止
			timerCycle.Enabled = false;

			try
			{
				facade.MainProc();
			}
			catch (Exception ex)
			{
				AppGlobal.ApLogger.Error("予想外のエラーが発生!!!");
				AppGlobal.ApLogger.Error(ex);
			}
			finally
			{
				timerCycle.Enabled = true;
				AppGlobal.ApLogger.Info("定周期処理 <<<<<<<<<<<<<<<<<<<<");
			}
		}
		#endregion

	}
}

