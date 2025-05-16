using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace BaiTapLon.Models
{
    public class Sach
    {
        public int MaSach { get; set; }
        public string TenSach { get; set; }
        public decimal DonGia { get; set; }
        public string DonViTinh { get; set; }
        public string MoTa { get; set; }
        public string HinhMinhHoa { get; set; }
        public DateTime NgayCapNhat { get; set; }
        public int SoLuongBan { get; set; }
        public int SoLanXem { get; set; }
        public int MaChuDe { get; set; }
        public string TenChuDe { get; set; }
        public string TenTacGia {  get; set; }
    }
}