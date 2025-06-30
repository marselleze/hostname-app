#pragma once
#include <drogon/drogon.h>

void hostnameHandler(
    const drogon::HttpRequestPtr& req,
    std::function<void(const drogon::HttpResponsePtr&)>&& callback
);
