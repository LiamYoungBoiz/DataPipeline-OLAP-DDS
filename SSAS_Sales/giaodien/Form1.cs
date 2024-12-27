using Microsoft.AnalysisServices.AdomdClient;

namespace giaodien
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            ConnectToSSAS();
        }
        private void ConnectToSSAS()
        {
            // Địa chỉ máy chủ SSAS và tên Cube
            string serverName = "DESKTOP-67M8U5J\\MSSQLSERVER1";  // Máy chủ SSAS (có thể là địa chỉ IP hoặc tên máy chủ)
            string cubeName = "DDS Fashion Shop"; // Tên của Cube trong SSAS

            // Kết nối SSAS
            try
            {
                using (AdomdConnection connection = new AdomdConnection($"Data Source={serverName};"))
                {
                    connection.Open();
                    MessageBox.Show("Kết nối thành công!");

                    // Sử dụng MDX hoặc DAX để truy vấn Cube
                    string mdxQuery = "select [Measures].[Total Sales] on 0,\r\n[Geography Dimension].[Territory] on 1\r\nfrom [DDS Fashion Shop]";

                    AdomdCommand command = new AdomdCommand(mdxQuery, connection);
                    AdomdDataReader reader = command.ExecuteReader();

                    while (reader.Read())
                    {
                        // Xử lý dữ liệu từ Cube
                        MessageBox.Show(reader[0].ToString());
                    }
                    reader.Close();
                    connection.Close();
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Lỗi kết nối: {ex.Message}");
            }
        }

        private void button2_Click(object sender, EventArgs e)
        {
            TruyVanMDX truyVanMDXForm = new TruyVanMDX();
            truyVanMDXForm.Show();
        }

        private void btnThongKE_Click(object sender, EventArgs e)
        {
            // Tạo đối tượng form mới có tên là ThongKe
            ThongKe formThongKe = new ThongKe();

            // Hiển thị form ThongKe
            formThongKe.Show();
        }
    }
}
