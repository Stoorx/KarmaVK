using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.IO;
using VkNet;

namespace KarmaVK
{
    class Program
    {
        static void Main(string[] args)
        {

            Console.Title = "KarmaVK Server 0.1";
            Console.WriteLine("KarmaVK 0.1");
            StreamReader config = new StreamReader(@"D:\vkkarma.ini");
            string token = config.ReadLine();
            KarmaVK.KarmaVKbot a = new KarmaVKbot(token);
            Console.Read();
        }
    }
}
