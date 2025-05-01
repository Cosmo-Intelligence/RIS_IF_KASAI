using System;
using System.Net;

namespace ComLib
{
	/// <summary>
	/// Enumユーティリティ
	/// </summary>
	public static class NetWork
	{
		/// <summary>
		/// 初期化
		/// </summary>
		/// <remarks>使用前に必ず呼ぶこと</remarks>
		public static void Initailize()
		{
			HostName = Dns.GetHostName();

			IpAddress = "";
			foreach (IPAddress address in Dns.GetHostAddresses(HostName))
			{
				if (address.AddressFamily == System.Net.Sockets.AddressFamily.InterNetwork)
				{
					IpAddress = address.ToString();
					break;
				}
			}
		}

		/// <summary>
		/// 端末名
		/// </summary>
		public static string HostName
		{
			private set;
			get;
		}
		/// <summary>
		/// IPアドレス
		/// </summary>
		public static string IpAddress
		{
			private set;
			get;
		}
	}
}
