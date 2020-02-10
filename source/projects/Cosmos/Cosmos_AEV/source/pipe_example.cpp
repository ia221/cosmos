#include <string>
#include <iostream>
#include <cstdlib>
#include <cstdio>
#include <array>
#include <unistd.h>
#include <fstream>
#include <sys/types.h>
//#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>

/* an example of opening a pipe to another program and gathering the information
 * from the stdout of that program
 */
int main()
{
    std::string command("python ~/sensors/temp.py  2>&1");

    std::array<char, 128> buffer;
    std::string result;
    std::cout << "Opening reading pipe" << std::endl;
    FILE* pipe = popen(command.c_str(), "r");
    if (!pipe)
    {
        std::cerr << "Couldn't start command." << std::endl;
        return 0;
    }
    std::cerr << "start command." << std::endl;
    while (fgets(buffer.data(), 128, pipe) != NULL) {
        result = buffer.data();
        std::cout<<result;
    }
    auto returnCode = pclose(pipe);

    return 0;
}

