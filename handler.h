#pragma once
#include <drogon/drogon.h>

inline void hostnameHandler(
    const drogon::HttpRequestPtr& req,
    std::function<void(const drogon::HttpResponsePtr&)>&& callback
);
