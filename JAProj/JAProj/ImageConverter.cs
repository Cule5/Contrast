using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Media;
using System.Windows.Media.Imaging;

namespace JAProj
{
    class ImageConverter
    {
        private readonly ImageSource _imageSource;

        public ImageConverter(ImageSource imageSource)
        {
            _imageSource = imageSource;
        }
        public byte[] ToTab()
        {
            BitmapImage bitmapImage = (BitmapImage)_imageSource;
            int height = bitmapImage.PixelHeight;
            int width = bitmapImage.PixelWidth;
            int stride = (bitmapImage.PixelWidth * bitmapImage.Format.BitsPerPixel + 7) / 8;
            byte[] pixelByteArray = new byte[bitmapImage.PixelHeight * stride];
            bitmapImage.CopyPixels(pixelByteArray, stride, 0);
            return pixelByteArray;
        }

        public BitmapSource ToBitmapSource(byte[] pixelBuffer)
        {
            int width = ((BitmapImage)_imageSource).PixelWidth;
            int height = ((BitmapImage)_imageSource).PixelHeight;
            double dpiX = ((BitmapImage)_imageSource).DpiX;
            double dpiY = ((BitmapImage)_imageSource).DpiY;
            PixelFormat pixelFormat = ((BitmapImage)_imageSource).Format;
            BitmapPalette bmpPalette = ((BitmapImage)_imageSource).Palette;
            int rawStride = (width * pixelFormat.BitsPerPixel + 7) / 8;

            BitmapSource bitmap = BitmapSource.Create(width, height, dpiX, dpiY, pixelFormat, null, pixelBuffer, rawStride);
            return bitmap;
        }
    }
}

