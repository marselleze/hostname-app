#include "handler.h"
#include <unistd.h>
#include <json/json.h>

using namespace drogon;

void hostnameHandler(const HttpRequestPtr& req,
                    std::function<void(const HttpResponsePtr&)>&& callback)
{
    char host[1024];
    if (gethostname(host, sizeof(host)) != 0) {
        auto resp = HttpResponse::newHttpResponse();
        resp->setStatusCode(HttpStatusCode::k500InternalServerError);
        resp->setBody("Error getting hostname");
        callback(resp);
        return;
    }

    Json::Value json;
    json["hostname"] = host;
    auto resp = HttpResponse::newHttpJsonResponse(json);
    callback(resp);
}
