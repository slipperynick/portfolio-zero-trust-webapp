from fastapi import FastAPI, Request
from datetime import datetime
from sqlalchemy.ext.asyncio import create_async_engine, AsyncSession
from sqlalchemy.orm import sessionmaker, declarative_base
from sqlalchemy import Column, Integer, String, DateTime
import os

DB_USER = os.getenv("POSTGRES_USER")
DB_PASS = os.getenv("POSTGRES_PASSWORD")
DB_NAME = os.getenv("POSTGRES_DB")
DB_HOST = os.getenv("POSTGRES_HOST", "postgres")  # K8s service name

DATABASE_URL = f"postgresql+asyncpg://{DB_USER}:{DB_PASS}@{DB_HOST}:5432/{DB_NAME}"

engine = create_async_engine(DATABASE_URL, echo=True)
SessionLocal = sessionmaker(engine, class_=AsyncSession, expire_on_commit=False)
Base = declarative_base()


class Visit(Base):
    __tablename__ = "visits"
    id = Column(Integer, primary_key=True, index=True)
    ip = Column(String)
    user_agent = Column(String)
    ts_utc = Column(DateTime)


app = FastAPI()


@app.on_event("startup")
async def startup():
    async with engine.begin() as conn:
        await conn.run_sync(Base.metadata.create_all)


@app.get("/health")
def health():
    return {"status": "ok"}


@app.post("/visit")
async def add_visit(req: Request):
    async with SessionLocal() as session:
        ua = req.headers.get("user-agent", "unknown")
        ip = req.client.host if req.client else "unknown"
        entry = Visit(ip=ip, user_agent=ua, ts_utc=datetime.utcnow())
        session.add(entry)
        await session.commit()
        return {"message": "visit stored"}


@app.get("/visits")
async def list_visits():
    async with SessionLocal() as session:
        result = await session.execute(
            Visit.__table__.select().order_by(Visit.id.desc()).limit(50)
        )
        visits = [dict(row._mapping) for row in result]
        return {"count": len(visits), "items": visits}
