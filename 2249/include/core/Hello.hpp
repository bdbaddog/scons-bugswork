#ifndef HELLO_HPP
#define HELLO_HPP

#ifndef USE_PCH
#include <string>
#endif

class Hello
{
    public:
       Hello(const std::string& msg);
       ~Hello();
       void sayIt();
       
   private:
      std::string m_msg; 
};

#endif // HELLO_HPP

