from fastapi import FastAPI, Request
from datetime import datetime

app = FastAPI()
visits = []  # in-memory for now


@app.get("/health")
def health():
    return {"status": "ok"}


@app.get("/")
def home():
    return {"message": "Hello from Visitlog"}


@app.post("/visit")
async def add_visit(req: Request):
    ua = req.headers.get("user-agent", "unknown")
    ip = req.client.host if req.client else "unknown"
    entry = {"ip": ip, "user_agent": ua, "ts_utc": datetime.utcnow().isoformat()}
    visits.append(entry)
    return entry


@app.get("/visits")
def list_visits():
    return {"count": len(visits), "items": visits[-50:]}
