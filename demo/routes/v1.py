from sanic import Blueprint
from sanic.response import json


# pre-appends /v1 to all routes decorated with @v1.route()
v1 = Blueprint("v1", url_prefix="/v1")

@v1.route("/", methods=["GET"])
def index(request):
    return json({"data": "hello world!"})
