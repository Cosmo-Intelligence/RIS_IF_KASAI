using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data;
using System.Windows.Forms;
//
using ComLib.database;

namespace ComLib.util
{
	/// <summary>
	/// DataGridView 拡張クラス
	/// </summary>
	public static class DataGridViewExtensions
	{
		#region [publlc]メソッド
		/// <summary>
		/// 行データ
		/// </summary>
		/// <param name="idx">行インデックス</param>
		/// <returns>行データ</returns>
		public static DataRow DataRow(this DataGridView dgv, int idx)
		{
			DataGridViewRow dgr = dgv.Rows[idx];
			return ((DataRowView)dgr.DataBoundItem).Row;
		}

		#region 行選択
		/// <summary>
		/// 行選択
		/// </summary>
		/// <param name="colName">カラム名</param>
		/// <param name="value">データ</param>
		public static void RowSelect(this DataGridView dgv, string colName, string value)
		{
			dgv.ClearSelection();

			for (int i = 0; i < dgv.Rows.Count; i++)
			{
				DataRow row = dgv.DataRow(i);
				if (row.StrVal(colName) == value)
				{
					dgv.Rows[i].Selected = true;
					dgv.CurrentCell = dgv.Rows[i].Cells[0];
					return;
				}
			}
		}
		/// <summary>
		/// 行選択 複数対応
		/// </summary>
		/// <param name="colName">カラム名</param>
		/// <param name="values">データ</param>
		public static void MultiRowSelect(this DataGridView dgv, string colName, List<string> values)
		{
			dgv.ClearSelection();

			for (int i = 0; i < dgv.Rows.Count; i++)
			{
				DataRow row = dgv.DataRow(i);
				if (values.Contains(row.StrVal(colName)) == true)
				{
					dgv.Rows[i].Selected = true;
				}
			}
		}
		#endregion

		#region 選択行取得
		/// <summary>
		/// 選択行取得
		/// </summary>
		/// <returns>行データ</returns>
		public static DataRow GetSelectRow(this DataGridView dgv)
		{
			if (dgv.SelectedRows.Count == 0)
			{
				return null;
			}
			DataGridViewRow dgr = dgv.SelectedRows[0];
			return ((DataRowView)dgr.DataBoundItem).Row;
		}
		/// <summary>
		/// 選択行の値 取得(カラム指定)
		/// </summary>
		/// <param name="colName">カラム名</param>
		/// <returns>値</returns>
		public static string SelectedValue(this DataGridView dgv, string colName)
		{
			if (dgv.SelectedRows.Count == 0)
			{
				return "";
			}

			DataGridViewRow dgr = dgv.SelectedRows[0];
			DataRow row = ((DataRowView)dgr.DataBoundItem).Row;

			return row.StrVal(colName);
		}
		/// <summary>
		/// 選択行の値 取得(カラム指定) 複数行対応
		/// </summary>
		/// <param name="colName">カラム名</param>
		/// <returns>値リスト</returns>
		public static List<string> SelectedValues(this DataGridView dgv, string colName)
		{
			List<string> list = new List<string>();
			if (dgv.SelectedRows.Count == 0)
			{
				return list;
			}

			foreach (DataGridViewRow dgr in dgv.SelectedRows)
			{
				DataRow row = ((DataRowView)dgr.DataBoundItem).Row;
				list.Add(row.StrVal(colName));
			}

			return list;
		}
		#endregion

		#region CSV出力
		/// <summary>
		/// CSV出力 ヘッダー
		/// </summary>
		/// <returns>CSV</returns>
		/// <remarks>途中の「,」 非対応</remarks>
		public static string HeaderCsv(this DataGridView dgv)
		{
			List<string> list = new List<string>();
			foreach (DataGridViewColumn col in dgv.Columns)
			{
				list.Add(col.HeaderText);
			}

			return String.Join(",", list.ToArray());
		}
		/// <summary>
		/// CSV出力 一覧
		/// </summary>
		/// <returns>CSV</returns>
		/// <remarks>途中の「,」 非対応</remarks>
		public static List<string> DataCsv(this DataGridView dgv)
		{
			List<string> lines = new List<string>();

			foreach (DataGridViewRow row in dgv.Rows)
			{
				List<string> list = new List<string>();
				foreach (DataGridViewCell cell in row.Cells)
				{
					if (cell.Value == null)
					{
						list.Add("");
					}
					else
					{
						list.Add(cell.Value.ToString());
					}
				}
				lines.Add(String.Join(",", list.ToArray()));
			}

			return lines;
		}
		#endregion
		#endregion
	}

}
