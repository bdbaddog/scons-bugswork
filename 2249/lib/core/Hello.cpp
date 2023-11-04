#include "core/CorePCH.hpp"
#ifndef USE_PCH
#include "core/Hello.hpp"
#include <iostream>
#endif

Hello::Hello(const std::string& msg):m_msg(msg)
{
}

Hello::~Hello()
{
}

void Hello::sayIt()
{
    std::cout << m_msg << std::endl;
}

