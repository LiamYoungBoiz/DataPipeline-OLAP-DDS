using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Diagnostics;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace giaodien1
{
    public partial class tableau : Form
    {
        public tableau()
        {
            InitializeComponent();
            load();
        }
        public void load()
        {
            string tableauDesktopPath = @"C:\Program Files\Tableau\Tableau 2024.3\bin\tableau.exe";
            string tableauFilePath = @"C:\Users\Liam\Downloads\olap.twb";
            try
            {
                Process.Start(tableauDesktopPath, $"\"{tableauFilePath}\"");
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Lỗi khi mở Tableau Desktop: {ex.Message}", "Lỗi", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }

        private void tableau_Load(object sender, EventArgs e)
        {

        }
    }
}
