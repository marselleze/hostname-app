#include <cstdlib>
#include <drogon/drogon.h>
#include <unistd.h> // Для gethostname()
#include <json/json.h>
#include "handler.h"

using namespace drogon;

int main()
{
    app()
        .addListener("0.0.0.0", 8080)
        .setThreadNum(8)\
        .enableServerHeader(false)
        .registerHandler("/api/hostname", &hostnameHandler, {Get})
        .run();
    return EXIT_SUCCESS;
}
