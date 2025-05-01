using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data;
//
using ComLib;
using ComLib.database;
using ResDetailIF.config;

namespace ResDetailIF.Main
{
	public class ResDetailData
	{
		#region inner class
		public class DataSet
		{
			#region プロパティ
			/// <summary>
			/// データ
			/// </summary>
			public string Value
			{
				get;
				set;
			}
			/// <summary>
			/// 更新日時
			/// </summary>
			public DateTime? UpdateDate
			{
				get;
				set;
			}

			/// <summary>
			/// 有効データ 有無
			/// </summary>
			public bool HasValue
			{
				get
				{
					return UpdateDate.HasValue;
				}
			}
			#endregion

			/// <summary>
			/// コンストラクタ
			/// </summary>
			public DataSet()
			{
				UpdateDate = null;
			}
		}
		#endregion

		#region メンバ
		/// <summary>
		/// ResDetailデータ
		/// </summary>
		private DataTable dt;
		#endregion

		#region プロパティ
		/// <summary>
		/// EGFR データ
		/// </summary>
		public DataSet Egfr
		{
			get;
			private set;
		}
		/// <summary>
		/// クレアチニン データ
		/// </summary>
		public DataSet Creatinin
		{
			get;
			private set;
		}
		/// <summary>
		/// 有効データ 有無
		/// </summary>
		public bool HasValue
		{
			get
			{
				return Egfr.HasValue || Creatinin.HasValue;
			}
		}
		#endregion

		#region コンストラクタ
		/// <summary>
		/// コンストラクタ
		/// </summary>
		private ResDetailData()
		{
			//private
		}
		/// <summary>
		/// コンストラクタ
		/// </summary>
		/// <param name="dt">ResDetailデータ</param>
		public ResDetailData(DataTable dt)
		{
			this.dt = dt;

			Egfr = new DataSet();
			Creatinin = new DataSet();
		}
		#endregion

		#region [public]メソッド
		/// <summary>
		/// データ取り出し
		/// </summary>
		/// <returns>T:OK F:NG</returns>
		public void PickUp()
		{
			//EGFR
			PickUpOneData(AppConfig.ItemCodeEgfr, Egfr);
			//クレアチニン
			PickUpOneData(AppConfig.ItemCodeCreatinin, Creatinin);
		}
		#endregion

		#region [private]メソッド
		/// <summary>
		/// データ取り出し
		/// </summary>
		/// <param name="itemCode">対象アイテムコード</param>
		/// <param name="target">対象データ</param>
		/// <returns>T:OK F:NG</returns>
		private void PickUpOneData(List<string> itemCode, DataSet target)
		{
			foreach (DataRow row in dt.Rows)
			{
				if (itemCode.Contains(row.StrVal("TESTITEMCODE")) == true)
				{
					//採取日
					string collectDateStr = row.StrVal("COLLECTDATE") + row.StrVal("COLLECTTIME");
					DateTime updDate;
					if (StrUtil.TryParseDateTime(collectDateStr, "yyyyMMddHHmm", out updDate) == false)
					{
						AppGlobal.ApLogger.Warn("ResDetail 採取日が不正[{0}]", collectDateStr);
						continue;
					}

					//日付比較
					if ((target.UpdateDate.HasValue == false) || (target.UpdateDate.Value < updDate))
					{
						target.UpdateDate = updDate;
					}
					else
					{
						continue;
					}

					//結果値
					string result = row.StrVal("EDITORIALRESULT");
					result = result.Trim();
					string outofStandard = row.StrVal("OUTOFSTANDARD");
					outofStandard = outofStandard.Trim();
					if (result == "")
					{
						AppGlobal.ApLogger.Warn("ResDetail EDITORIALRESULTがNULL");
						continue;
					}
					target.Value = result;
					if (outofStandard != "")
					{
						target.Value += "(" + outofStandard + ")";
					}
				}
			}
		}
		#endregion
	}
}
