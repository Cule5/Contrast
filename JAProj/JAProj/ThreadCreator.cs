using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace JAProj
{
    class ThreadCreator
    {
        private List<Thread> _threadList = new List<Thread>();

        private List<int> _singleHeight = new List<int>();

        private ProgramAttributes _programAttributes;

        private unsafe byte*[] _adressTab;

        public ThreadCreator(ProgramAttributes programAttributes)
        {
            _programAttributes = programAttributes;
            unsafe
            {
                _adressTab = new byte*[_programAttributes.AmountThreads];
            }
        }

        public void RunAlgorithm()
        {
            foreach (var thread in _threadList)
                thread.Start();

            foreach (var thread in _threadList)
                thread.Join();
        }
        public void CreateThreads()
        {
            SetSingleHeight();
            SetAdress(_singleHeight);

            if (_programAttributes.DllType == ProgramAttributes.TypeOfDll.Asm)
            {
                for (int i = 0; i < _programAttributes.AmountThreads; ++i)
                {
                    unsafe
                    {
                        byte* ptr = _adressTab[i];
                        int singleHeight = _singleHeight[i];
                        _threadList.Add(new Thread(() => DllLoader.MyProc1(ptr, _programAttributes.Width, singleHeight, _programAttributes.ContrastLevel)));


                    }
                }
            }
            else if (_programAttributes.DllType == ProgramAttributes.TypeOfDll.Cpp)
            {
                for (int i = 0; i < _programAttributes.AmountThreads; ++i)
                {
                    unsafe
                    {
                        byte* ptr = _adressTab[i];
                        int singleHeight = _singleHeight[i];
                        _threadList.Add(new Thread(() => DllLoader.MyProc2(ptr, _programAttributes.Width, singleHeight,
                            _programAttributes.ContrastLevel)));

                    }

                }
            }
        }
        private void SetAdress(List<int> singleHeight)
        {

            unsafe
            {
                fixed (byte* tab = &(_programAttributes.PixelBuffer)[0])
                {
                    byte* ptr = tab;
                    for (int i = 0; i < _programAttributes.AmountThreads; ++i)
                    {
                        int it = 4 * _programAttributes.Width * singleHeight[i];
                        _adressTab[i] = ptr;
                        ptr += it;
                    }
                }
            }
        }
        private void SetSingleHeight()
        {
            int height = _programAttributes.Height;
            int singleHeight = height / _programAttributes.AmountThreads;
            int rest = _programAttributes.Height - singleHeight * _programAttributes.AmountThreads;
            for (int i = 0; i < _programAttributes.AmountThreads; ++i)
                _singleHeight.Add(singleHeight);

            for (int i = 0; i < rest; ++i)
                ++_singleHeight[i];

        }
    }
}
