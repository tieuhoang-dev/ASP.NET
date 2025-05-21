using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace BaiTapLon.Models
{
    [Serializable]
    public class CartItem
	{
        public string MaSach { get; set; }
        public string TenSach { get; set; }
        public decimal DonGia { get; set; }
        public int SoLuong { get; set; }
    }
}