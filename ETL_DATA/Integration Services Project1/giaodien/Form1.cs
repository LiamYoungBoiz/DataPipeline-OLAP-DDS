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
            ConnectSSIS con=new ConnectSSIS();
            MessageBox.Show(con.ax());
        }
    }
}
