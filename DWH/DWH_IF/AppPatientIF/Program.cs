using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Reflection;
using System.Windows.Forms;
using System.ServiceProcess;
//
using ResDetailIF.Main;

namespace ResDetailIF
{
	static class Program
	{
		/// <summary>
		/// アプリケーションのメイン エントリ ポイントです。
		/// </summary>
		[STAThread]
		static void Main()
		{
			//二重起動をチェックする
			Mutex mutex = new Mutex(false, "MUTEX_APP_PATIENT_IF");
			if (mutex.WaitOne(0, false) == false)
			{
				mutex.Close();
				return;
			}

			try
			{
				//初期化
				if (AppInitialize.Execute() == false)
				{
					return;
				}

				//バージョン取得
				Assembly myAssembly = Assembly.GetEntryAssembly();
				string appPath = myAssembly.Location;
				System.Diagnostics.FileVersionInfo hVerInfo = (
					System.Diagnostics.FileVersionInfo.GetVersionInfo(appPath)
				);
				string version = hVerInfo.ProductVersion;

				//開始
				AppGlobal.ApLogger.Info("起動開始 {0} >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>", version);

#if DEBUG
				//アプリケーションのメインエントリポイント設定
				Application.EnableVisualStyles();
				Application.SetCompatibleTextRenderingDefault(false);
				Application.Run(new TestFrm());
#else
				ServiceBase[] ServicesToRun;
				ServicesToRun = new ServiceBase[]
				{ 
					new srvAppPatientIF()
				};
				ServiceBase.Run(ServicesToRun);
#endif
				AppGlobal.ApLogger.Info("起動終了 {0} <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<", version);
			}
			finally
			{
				mutex.Close();
			}
		}
	}
}
