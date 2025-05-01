using System;
using System.IO;
using System.Diagnostics;
//
using ComLib;
using ComLib.log;
using ResDetailIF.config;

namespace ResDetailIF
{
	/// <summary>
	/// アプリケーション初期化処理 クラス
	/// </summary>
	public static class AppInitialize
	{
		#region [public]メソッド
		/// <summary>
		/// アプリケーション初期化実行
		/// </summary>
		/// <returns>処理結果 T:成功 F:失敗</returns>
		public static bool Execute()
		{
			//configファイル存在チェック
			if (File.Exists(AppConfig.AppConfigPath) == false)
			{
				return false;
			}
			//Log4net設定読込
			log4net.Config.XmlConfigurator.Configure(new FileInfo(AppConfig.AppConfigPath));

			//Config定義チェック(DB)
			if (ConnectionConfig() == false)
			{
				return false;
			}

			//IPアドレス取得
			NetWork.Initailize();
			AppGlobal.ApLogger.Info("ホスト名[{0}] IPアドレス[{1}]", NetWork.HostName, NetWork.IpAddress);

			/*
			//db接続チェック
			if (this.CheckOraConnection() == false)
			{
				return false;
			}
			*/
			//正常終了
			return true;
		}

		#endregion

		#region [private]メソッド
		/// <summary>
		/// DB接続設定の読み込み
		/// </summary>
		/// <returns>処理結果 T:成功 F:失敗</returns>
		private static bool ConnectionConfig()
		{
			if (AppConfig.RISConnectStr == "")
			{
				AppGlobal.ApLogger.Warn("RIS DB接続文字列が設定されていません");
				return false;
			}
			AppGlobal.ApLogger.Info("RIS DB接続文字列:" + AppConfig.RISConnectStr);

			if (AppConfig.DWHConnectStr == "")
			{
				AppGlobal.ApLogger.Warn("DWH DB接続文字列が設定されていません");
				return false;
			}
			AppGlobal.ApLogger.Info("DWH DB接続文字列:" + AppConfig.DWHConnectStr);
			return true;
		}
		#endregion
	}
}
