#!/usr/bin/env python3
import requests
import time

def test_api():
    """Test the API endpoints"""
    base_url = "http://127.0.0.1:8000"
    
    print("Testing API endpoints...")
    
    # Test ping endpoint
    try:
        response = requests.get(f"{base_url}/ping", timeout=5)
        print(f"✅ Ping: {response.status_code} - {response.json()}")
    except Exception as e:
        print(f"❌ Ping failed: {e}")
    
    # Test health endpoint
    try:
        response = requests.get(f"{base_url}/health", timeout=5)
        print(f"✅ Health: {response.status_code} - {response.json()}")
    except Exception as e:
        print(f"❌ Health failed: {e}")
    
    # Test inventory endpoint
    try:
        response = requests.get(f"{base_url}/api/v1/inventory", timeout=5)
        print(f"✅ Inventory: {response.status_code} - {len(response.json())} items")
    except Exception as e:
        print(f"❌ Inventory failed: {e}")

if __name__ == "__main__":
    test_api()
