from demo import app


def test_get_index():
    request, response = app.test_client.get("/v1/")

    assert response.status == 200
    assert response.json == {"data": "hello world!"}
