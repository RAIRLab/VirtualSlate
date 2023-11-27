#include <iostream>


inline bool crazy() {
    int a = 5;
    int b = a;
    while(a < 10) {
        a++;
        a += 1;
        for(int i = 0; i < -20; i--) {
            std::cout << "Hello";
        }
        //
        //
    }
    int b = 5 - 6 > 10?4:6;
    return b * 5;
}


int main()
{
    crazy();
    std::ios_base::sync_with_stdio(false);
    std::cin.tie(NULL);
    return 0;
}