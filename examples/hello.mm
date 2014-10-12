#import <Foundation/Foundation.h>

using namespace std;
class People
{
public:
  void sayHello()
  {
    cout<< "hello,world" << endl;
  }
};

int main (int argc, const char * argv[])
{
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
  People people;
  people.sayHello();
  [pool drain];
  return 0;
}
