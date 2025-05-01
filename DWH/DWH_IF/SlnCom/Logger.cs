using System;
using System.Collections.Generic;
using System.Text;
using System.Diagnostics;
using System.Windows.Forms;
using System.IO;
//
using log4net;
using log4net.Appender;
using ComLib;
using ComLib.log;

namespace SlnCom
{
	/// <summary>
	/// Log4net制御 クラス
	/// </summary>
	public class Logger : ILogger
	{
		#region メンバー変数
		/// <summary>
		/// Log4netオブジェクト
		/// </summary>
		private log4net.ILog logObj = null;
		/// <summary>
		/// ログ保存日数
		/// </summary>
		private int keepDays = 30;
		/// <summary>
		/// 保存日数超過ファイル削除
		/// </summary>
		private FileControl fileCtl;
		#endregion

		#region コンストラクタ
		/// <summary>
		/// コンストラクタ
		/// </summary>
		/// <param name="appenderName">appender name</param>
		/// <param name="keepDays">ログ保存日数</param>
		public Logger(string appenderName, int keepDays)
		{
			logObj = log4net.LogManager.GetLogger(appenderName);
			this.keepDays = keepDays;
			fileCtl = new FileControl(this);
		}
		#endregion

		#region [private]メソッド
		/// <summary>
		/// 呼び出し元のメソッド名取得
		/// </summary>
		/// <returns>メソッド名</returns>
		private string GetMethodName()
		{
			//Start, End を呼び出したメソッド名を取得する
			StackFrame frame = new StackFrame(2);
			if (frame != null)
			{
				System.Reflection.MethodBase method = frame.GetMethod();
				return string.Format("{0}.{1}", method.ReflectedType.FullName ,method.Name);
			}
			else
			{
				return "";
			}
		}
		#endregion

		#region [ILogger]実装
		/// <summary>
		/// 出力先
		/// </summary>
		/// <returns>出力先パス</returns>
		public string FilePath()
		{
			//appender名で設定を探す
			foreach (var repository in LogManager.GetAllRepositories())
			{
				IAppender appender = null;
				foreach (var apd in repository.GetAppenders())
				{
					if (apd.Name == logObj.Logger.Name)
					{
						appender = apd;
						break;
					}
				}
				if (appender != null)
				{
					return ((FileAppender)appender).File;
				}
			}
			//設定が見つからない → 実行ファイルパス
			return Application.ExecutablePath;
		}
		/// <summary>
		/// 過去ログ削除
		/// </summary>
		public void DeleteExpired()
		{
			fileCtl.DeleteExpiredFile(Path.GetDirectoryName(FilePath()), "*.log*", keepDays);
		}
		/// <summary>
		/// メソッド開始
		/// </summary>
		public void Start()
		{
			logObj.DebugFormat("[{0}] -->", GetMethodName());
		}
		/// <summary>
		/// メソッド終了
		/// </summary>
		public void End()
		{
			logObj.DebugFormat("[{0}] <--", GetMethodName());
		}

		/// <summary>
		/// Log出力 Debug
		/// </summary>
		/// <param name="msg">ログ内容</param>
		public void Debug(object msg)
		{
			logObj.Debug(msg);
		}
		/// <summary>
		/// Log出力(フォーマット付) Debug
		/// </summary>
		/// <param name="msg">ログ内容</param>
		/// <param name="args">パラメータ</param>
		public void Debug(string msg, params object[] args)
		{
			logObj.DebugFormat(msg, args);
		}

		/// <summary>
		/// Log出力 Info
		/// </summary>
		/// <param name="msg">ログ内容</param>
		public void Info(object msg)
		{
			logObj.Info(msg);
		}
		/// <summary>
		/// Log出力(フォーマット付) Info
		/// </summary>
		/// <param name="msg">ログ内容</param>
		/// <param name="args">パラメータ</param>
		public void Info(string msg, params object[] args)
		{
			logObj.InfoFormat(msg, args);
		}

		/// <summary>
		/// Log出力 Warn
		/// </summary>
		/// <param name="msg">ログ内容</param>
		public void Warn(object msg)
		{
			logObj.Warn(msg);
		}
		/// <summary>
		/// Log出力(フォーマット付) Warn
		/// </summary>
		/// <param name="msg">ログ内容</param>
		/// <param name="args">パラメータ</param>
		public void Warn(string msg, params object[] args)
		{
			logObj.WarnFormat(msg, args);
		}

		/// <summary>
		/// Log出力 Error
		/// </summary>
		/// <param name="msg">ログ内容</param>
		public void Error(object msg)
		{
			logObj.Error(msg);
		}
		/// <summary>
		/// Log出力(フォーマット付) Error
		/// </summary>
		/// <param name="msg">ログ内容</param>
		/// <param name="args">パラメータ</param>
		public void Error(string msg, params object[] args)
		{
			logObj.ErrorFormat(msg, args);
		}

		/// <summary>
		/// Log出力 Fatal
		/// </summary>
		/// <param name="msg">ログ内容</param>
		public void Fatal(object msg)
		{
			logObj.Fatal(msg);
		}
		/// <summary>
		/// Log出力(フォーマット付) Fatal
		/// </summary>
		/// <param name="msg">ログ内容</param>
		/// <param name="args">パラメータ</param>
		public void Fatal(string msg, params object[] args)
		{
			logObj.FatalFormat(msg, args);
		}
		#endregion
	}
}
