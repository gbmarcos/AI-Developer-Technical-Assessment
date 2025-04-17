from fastapi.testclient import TestClient
from app.main import app

client = TestClient(app)

def test_get_books():
    response = client.get("/books")
    assert response.status_code == 200
    assert isinstance(response.json(), list)


def test_get_headlines():
    response = client.get("/headlines")
    assert response.status_code == 200
    assert "headlines" in response.json()