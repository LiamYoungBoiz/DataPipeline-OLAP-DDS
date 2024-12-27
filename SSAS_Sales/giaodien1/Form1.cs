using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace giaodien1
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            TruyVanMDX truyVanMDXForm = new TruyVanMDX();
            truyVanMDXForm.Show();
        }

        private void button2_Click(object sender, EventArgs e)
        {
            // Tạo đối tượng form mới có tên là ThongKe
            ThongKe formThongKe = new ThongKe();

            // Hiển thị form ThongKe
            formThongKe.Show();
        }

        private void button3_Click(object sender, EventArgs e)
        {
            tableau tb = new tableau();

            // Hiển thị form ThongKe
            tb.Show();
        }
    }
}
