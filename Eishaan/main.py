from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from typing import List
from pymongo import MongoClient
import os

# MongoDB configuration
MONGO_URI = os.getenv("MONGO_URI", "mongodb://localhost:27017")
DATABASE_NAME = "grocery_manager"
COLLECTION_NAME = "grocery_lists"

# Initialize MongoDB client
client = MongoClient(MONGO_URI)
db = client[DATABASE_NAME]
grocery_collection = db[COLLECTION_NAME]

# FastAPI app initialization
app = FastAPI()

# Add CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Replace "*" with specific origins if needed
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Pydantic models for request and response validation
class GroceryItem(BaseModel):
    name: str
    quantity: int
    purchased: bool = False

class GroceryList(BaseModel):
    title: str
    items: List[GroceryItem]

# Utility to convert ObjectId to string
def object_id_to_str(item):
    item["_id"] = str(item["_id"])  # Convert ObjectId to string
    return item

# API Endpoints
@app.post("/grocery-lists/", response_model=dict)
async def create_grocery_list(grocery_list: GroceryList):
    """
    Create a new grocery list.
    """
    try:
        list_dict = grocery_list.dict()  # Convert the Pydantic model to dictionary
        result = grocery_collection.insert_one(list_dict)  # Insert into MongoDB
        # Retrieve the full list with the inserted ID
        created_grocery_list = grocery_collection.find_one({"_id": result.inserted_id})
        created_grocery_list = object_id_to_str(created_grocery_list)
        return {"message": "Grocery list created successfully", "grocery_list": created_grocery_list}
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Internal server error: {str(e)}")

@app.get("/grocery-lists/", response_model=List[dict])
async def get_all_grocery_lists():
    """
    Retrieve all grocery lists.
    """
    try:
        lists = list(grocery_collection.find())  # Retrieve all grocery lists
        return [object_id_to_str(grocery_list) for grocery_list in lists]
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Internal server error: {str(e)}")
