using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace JAProj
{
    class ProgramAttributes
    {

        public ProgramAttributes(int amountThreads, int contrastLevel, TypeOfDll dllType, byte[] pixelBuffer, int height, int width)
        {
            AmountThreads = amountThreads;
            ContrastLevel = Math.Pow((100.0 + contrastLevel) / 100.0, 2); ;
            DllType = dllType;
            PixelBuffer = pixelBuffer;
            Height = height;
            Width = width;

        }
        public enum TypeOfDll
        {
            Asm,
            Cpp
        }

        public int AmountThreads { get; }

        public double ContrastLevel { get; }
        public byte[] PixelBuffer { get; }
        public TypeOfDll DllType { get; }
        public int Width { get; }
        public int Height { get; }

    }
}
