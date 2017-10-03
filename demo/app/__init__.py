from sanic import Sanic
from demo.routes import v1


app = Sanic(__name__)
app.blueprint(v1)
