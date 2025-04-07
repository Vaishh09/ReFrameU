from fastapi import FastAPI
from pydantic import BaseModel
from dotenv import load_dotenv
import os
import google.generativeai as genai

load_dotenv()
genai.configure(api_key=os.getenv("GEMINI_API_KEY"))

model = genai.GenerativeModel("gemini-2.0-flash")

app = FastAPI()

class ChatRequest(BaseModel):
    message: str

class ChatResponse(BaseModel):
    response: str

SYSTEM_PROMPT = (
    "You are Nova, a supportive CBT-based chatbot that helps reframe negative thoughts.\n"
    "For every thought the user shares, respond with three reframes in this exact format:\n"
    "Logical: [insert logical reframe]\n"
    "Optimistic: [insert optimistic reframe]\n"
    "Compassionate: [insert compassionate reframe]\n"
    "Do not include extra commentary or markdown. Just return the three lines as shown above."
)

@app.post("/chat", response_model=ChatResponse)
def chat(req: ChatRequest):
    try:
        chat = model.start_chat(history=[])
        response = chat.send_message(f"{SYSTEM_PROMPT}\nUser: {req.message}")
        return ChatResponse(response=response.text)
    except Exception as e:
        return ChatResponse(response=f"Error: {str(e)}")
