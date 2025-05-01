using System;
using System.Collections.Generic;
using System.Configuration;
using System.Diagnostics;
using System.IO;
//
using ComLib;
using SlnCom;

namespace ResDetailIF.config
{
	/// <summary>
	/// app.Configアクセス クラス
	/// </summary>
	public class AppConfig : ConfigBase
	{
		/// <summary>
		/// コンストラクタ
		/// </summary>
		private AppConfig()
		{
			//private コンストラクタ
		}

		#region メンバ
		#endregion

		#region [private]メソッド
		#endregion

		#region [public]プロパティ
		/// <summary>
		/// 周期処理間隔
		/// </summary>
		public static int CycleInterval
		{
			get
			{
				const int DEF_VAL = 10000;

				int val = ConfigUtil.IntVal("CycleInterval", DEF_VAL);
				return (val >= 0) ? val : DEF_VAL;
			}
		}
		/// <summary>
		/// 項目コード Egfr
		/// </summary>
		public static List<string> ItemCodeEgfr
		{
			get
			{
				return ConfigUtil.ListVal("ItemCodeEgfr", "");
			}
		}
		/// <summary>
		/// 項目コード クレアチニン
		/// </summary>
		public static List<string> ItemCodeCreatinin
		{
			get
			{
				return ConfigUtil.ListVal("ItemCodeCreatinin", "");
			}
		}
		#endregion
	}
}