﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace LoggerC
{
    class BufferLogger : Logger
    {

        protected override void _write(LogLevel messageLogLevel, string message)
        {
            throw new NotImplementedException();
        }
    }
}