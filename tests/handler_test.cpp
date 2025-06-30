#include <gtest/gtest.h>
#include "../handler.h"
#include <drogon/drogon.h>

TEST(HostnameHandlerTest, ValidResponse) {
    // Mock-запрос
    auto req = drogon::HttpRequest::newHttpRequest();
    drogon::HttpResponsePtr resp;

    // Захват ответа через callback
    hostnameHandler(req, [&](const auto& response) {
        resp = response;
    });

    // Проверки
    EXPECT_EQ(resp->getStatusCode(), drogon::k200OK);
    EXPECT_EQ(resp->contentType(), drogon::CT_APPLICATION_JSON);

    auto json = resp->getJsonObject();
    ASSERT_TRUE(json);
    EXPECT_FALSE(json->get("hostname", "").asString().empty());
}
