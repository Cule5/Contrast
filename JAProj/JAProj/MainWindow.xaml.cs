using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Runtime.InteropServices;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;
using Microsoft.Win32;
using Path = System.IO.Path;

namespace JAProj
{
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {

        public MainWindow()
        {
            InitializeComponent();




        }

        private void photoLoader_Click(object sender, RoutedEventArgs e)
        {

            OpenFileDialog dlg = new OpenFileDialog();

            dlg.DefaultExt = ".bmp";
            dlg.Filter = "Bitmap Images(*.bmp) | *.bmp";

            bool? ifSelect = dlg.ShowDialog();
            if (ifSelect == true)
            {
                string str = dlg.FileName;
                Uri uri = new Uri(str);
                ImageSource imageSource = new BitmapImage(uri);

                inputImage.Source = imageSource;

            }
        }

        private void runButton_Click(object sender, RoutedEventArgs e)
        {

            ProgramAttributes.TypeOfDll dllType = ProgramAttributes.TypeOfDll.Asm;
            if (assembly.IsChecked == true)
                dllType = ProgramAttributes.TypeOfDll.Asm;
            else if (cpp.IsChecked == true)
                dllType = ProgramAttributes.TypeOfDll.Cpp;

            try
            {
                ImageConverter imageConverter = new ImageConverter(inputImage.Source);
                byte[] pixelBuffer = imageConverter.ToTab();
                int width = ((BitmapImage) inputImage.Source).PixelWidth;
                int height = ((BitmapImage) inputImage.Source).PixelHeight;
                ProgramAttributes programAttributes = new ProgramAttributes(int.Parse(amountThreds.Text),
                    (int) slider.Value, dllType, pixelBuffer, height, width);
                ThreadCreator threadCreator = new ThreadCreator(programAttributes);
                threadCreator.CreateThreads();

                var watch = Stopwatch.StartNew();

                threadCreator.RunAlgorithm();

                watch.Stop();

                long elapsedTicks = watch.ElapsedTicks;

                results.Text = "Time of working algorithm: " + elapsedTicks.ToString();

                outputImage.Source = imageConverter.ToBitmapSource(pixelBuffer);
            }
            catch (NullReferenceException nullReferenceException)
            {
                MessageBox.Show("BAD PARAMETER!");
            }



        }

        private void PhotoGenerator_Click(object sender, RoutedEventArgs e)
        {

            SaveFileDialog dlg = new SaveFileDialog();
            dlg.FileName = "ImageConverter";
            dlg.Filter = "Bitmap Images(*.bmp) | *.bmp";
            if (dlg.ShowDialog() == true)
            {
                string filePath = dlg.FileName;
                BitmapSource bitmapSource = (BitmapSource)outputImage.Source;
                BitmapEncoder encoder = new PngBitmapEncoder();
                encoder.Frames.Add(BitmapFrame.Create(bitmapSource));

                using (var fileStream = new System.IO.FileStream(filePath, System.IO.FileMode.Create))
                {
                    encoder.Save(fileStream);
                }
            }
        }

        private void AmountThreds_LostFocus(object sender, RoutedEventArgs e)
        {
            try
            {
                int number = int.Parse(amountThreds.Text);
                if (number <= 0 || number > 64)
                    amountThreds.Text = "1";
            }
            catch (FormatException formatException)
            {
                amountThreds.Text = "1";
            }

        }

        
    }


}

