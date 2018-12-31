using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.InteropServices;
using System.Text;
using System.Threading.Tasks;

namespace JAProj
{
    static class DllLoader
    {
        //podlaczenie biblioteki asemblerowej
        [DllImport("JAAsm.dll", EntryPoint = "MyProc1")]
        unsafe public static extern void MyProc1(byte* tab, int width, int height, double contrastLevel);

        //podlaczenie biblioteki cpp
        [DllImport("JACpp.dll", EntryPoint = "MyProc2")]
        unsafe public static extern void MyProc2(byte* tab, int width, int height, double contrastLevel);
    }
}
