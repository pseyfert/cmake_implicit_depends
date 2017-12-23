#ifndef dont_use_base
class base {
};
#else
#include "base.h"
#endif
class derived : public base {
};
